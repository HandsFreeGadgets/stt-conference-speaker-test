import asyncio
import json
import sys

import aiofile

from amazon_transcribe.client import TranscribeStreamingClient
from amazon_transcribe.handlers import TranscriptResultStreamHandler
from amazon_transcribe.model import TranscriptEvent
from amazon_transcribe.utils import apply_realtime_delay

SAMPLE_RATE = 44100
BYTES_PER_SAMPLE = 2
CHANNEL_NUMS = 1

AUDIO_PATH = "tests/integration/assets/test.wav"
CHUNK_SIZE = 1024 * 8
REGION = "eu-central-1"


class MyEventHandler(TranscriptResultStreamHandler):
    async def handle_transcript_event(self, transcript_event: TranscriptEvent):
        results = transcript_event.transcript.results
        for result in results:
            if not result.is_partial:
                for alt in result.alternatives:
                    print(alt.transcript)


async def basic_transcribe(audio_file: str):
    client = TranscribeStreamingClient(region=REGION)

    stream = await client.start_stream_transcription(
        language_code="de-DE",
        media_sample_rate_hz=SAMPLE_RATE,
        media_encoding="pcm",
    )

    async def write_chunks():
        async with aiofile.AIOFile(audio_file, "rb") as afp:
            reader = aiofile.Reader(afp, chunk_size=CHUNK_SIZE)
            await apply_realtime_delay(
                stream, reader, BYTES_PER_SAMPLE, SAMPLE_RATE, CHANNEL_NUMS
            )
        await stream.input_stream.end_stream()

    handler = MyEventHandler(stream.output_stream)
    await asyncio.gather(write_chunks(), handler.handle_events())


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(basic_transcribe(sys.argv[1]))
    loop.close()
