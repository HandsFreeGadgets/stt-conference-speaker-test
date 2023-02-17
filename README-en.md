# Summary

Repository testing different Speech-To-Text (STT) solutions and conference speakers for using them to transcribe commands for device interactions.

See the [German version](README.md).

# Funding

The project was funded by the German Federal Ministry of Education and Research under grant number 01IS22S34 from September 2022 to February 2023. The authors are responsible for the content of this publication.

<img src="BMBF_gefoerdert_2017_en.jpg" width="300px"/>

# Test Details

All tests have been executed while playing the same background video [A Beginner’s Guide to Quantum Computing](https://www.youtube.com/watch?v=S52rxZG-zi0) starting at offset 7:00.

The video was played using the conference speaker as output device. No other background noise was present during the test. 
This should resemble real situations with a low noise environment but possibly consumed media and communications output all using the conference speaker.

For all cloud solutions no context specific grammar was used, for the Coqui recognition the [German speech model](https://coqui.ai/models) and a grammar customized scorer was used.

The test set is limited and just focusing on one distance, one background, one speaker and one phrase, given more time a more complex setup can be created.

# Test Execution

All test scripts are using German as langauge for the speech recognition. For other languages the test script have to be modified are have to be extended to support this a parameter.

To redo the tests wav files in the `samples` folder have to be placed, matching the speaker names in the file `speaker.txt`. The file `utterances.txt` contains the statement matching each speaker line. 

## Google Cloud

The Google Cloud CLI must be installed and a [Google service account](https://cloud.google.com/speech-to-text/docs/before-you-begin) must be created.

~~~shell
cd test
export GOOGLE_APPLICATION_CREDENTIALS=<path to service account JSON file>
./google.sh
~~~

## MS Azure

The [Azure Speech CLI](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/spx-basics?tabs=windowsinstall%2Cterminal) must be installed and a Speech service has to be created.

~~~shell
cd test
spx config @key --set SPEECH-KEY
spx config @region --set SPEECH-REGION
~~~

## Coqui

Install Coqui:

~~~shell
python3 -m venv venv
source venv/bin/activate
python -m pip install -U pip
venv/bin/pip install -r requirements.txt
~~~

~~~shell
./coqui.sh
~~~

## OpenAI Whisper

Install Whispher:

~~~shell
# Install https://github.com/pyenv/pyenv
pyenv install 3.9.9
pyenv local 3.9.9
python3 -m venv venv-whispher
source venv-whispher/bin/activate
python -m pip install -U pip
pip3 install jiwer
pip3 install git+https://github.com/openai/whisper.git 
~~~

~~~shell
./openai.sh
~~~


## IBM Cloud

The IBM access token from a [speech-to-text service](https://cloud.ibm.com/apidocs/speech-to-text) has to be created.

~~~shell
export IBM_URL=...
export IBM_API_KEY=...
./ibm.sh
~~~

## Speechtext.ai

An API key has to be requested from [speechtext.ai](https://speechtext.ai/speech-recognition-api).

~~~shell
export SPEECHTEXT_KEY=...
./speechtext.sh
~~~

## rev.ai

An API key has to be requested from [rev.ai](https://www.rev.ai/access-token).

~~~shell
export REV_KEY=...
./rev.sh
~~~

## AWS Transcribe

A user in IAM has to be created with the transcribe policy.

~~~shell
source venv/bin/activate
python -m pip install -U pip
venv/bin/pip install -r requirements.txt
pip3 uninstall amazon-transcribe
pip install git+https://github.com/awslabs/amazon-transcribe-streaming-sdk.git@develop
~~~

~~~shell
python3 -m venv venv
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
./aws.sh
~~~

## AssemblyAI

An API key has to be requested from [rev.ai](https://www.rev.ai/access-token).

~~~shell
export ASSEMBLY_KEY=...
./assembly.sh
~~~

## trint

[trint](https://app.trint.com) only allows 3 tests in the trial mode.

## Speechmatics

Get an API key for the [API](https://portal.speechmatics.com/getting-started/).

~~~shell
export SPEECHMATICS_KEY=...
./speechmatics.sh
~~~

## Deepgram

Get an API key from [Deepgram](https://developers.deepgram.com/api-reference/).

~~~shell
export DEEPGRAM_KEY=...
./deepgram.sh
~~~

# Results

The results here are sometimes not reflecting the human perception of the voice quality. 
The conference speakers are using different technologies like echo cancellation, beam-forming, background noise reduction and 
voice recognition algorithms filtering only certain frequencies. Often these algorithms are producing audible good results 
but are cutting, silencing or disturbing important parts of the audio letting STT algorithms fail.


## Subjective Perception 

| Conference Speaker             | Human Perception                                                                                                   | Issues                                                                                 | Comment                                                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| EMEET OfficeCore M2 Max (Mono) | Good, background is filtered out pretty well, muffled, notable capped frequencies, amplitude level is not constant |                                                                                        | Stereo mode was not giving better results, AI mode mas making result worse, also the human perception was not improved | 
| EPOS EXPAND40+                 | Very good, clear, background filtered out almost perfectly                                                         |                                                                                        |                                                                                                                        | 
| Jabra Speak 750 UC             | Fair, frequency parts capped off, parts of audio filtered out or are cut off, background filtered out              |                                                                                        |                                                                                                                        |
| Konftel 70                     | Good, notable capped frequencies, muffled, background filtered out                                                 | Buttons not working under Linux                                                        |                                                                                                                        |
| Logitech P710e                 | Good, a bit muffled, background sometimes still recognizable                                                       | Battery reported to be low, was turning off, although connected to USB-C all the time. |                                                                                                                        |
| ReSpeaker Mic Array v2.0       | Very good, clear, although an external speaker was used background is filtered out well                            |                                                                                        | An external speaker was connected to the audio jack                                                                    |
| Sennheiser PC8                 |                                                                                                                    |                                                                                        | Just for reference using a headset with direct voice input                                                             |

## Performance

As quality criteria the WER (word error rate) is used.

| Conference Speaker             | Actual Text                                    | MS Azure                                         | WER                 | Match |
|--------------------------------|------------------------------------------------|--------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe, die Telefonnummer 0176138295 an.   | 0.0                 | x     | 
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Und rufe die Telefonnummer 01767382453 an.       | 0.0625              | o     | 
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Luftballons 1 Preis. Oh 138. An. | 0.46153846153846156 | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer 017673832985 an.     | 0.11764705882352941 | x     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767385492 an.          | 0.0                 | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761236453.            | 0.0625              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176123857923 an.        | 0.0                 | x     |

| Conference Speaker             | Actual Text                                    | OpenAI Whisper Large                             | WER                 | Match |
|--------------------------------|------------------------------------------------|--------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon und die Telefonnummer 0176-103-82953     | 0.2                 | o     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon, rufe die Telefonnummer 0176 738 2453 an. | 0.0                 | x     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Nummer 013-013-8.                | 0.3076923076923077  | -     | 
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefonrouten, Telefonnummer 0176 7383 2985 an.  | 0.17647058823529413 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767385492 an.          | 0.0                 | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 0176 123 64 53.         | 0.0625              | x     | 
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176 123 857 923 an.     | 0.0                 | x     |

| Conference Speaker             | Actual Text                                    | Google Cloud                                   | WER                 | Match |
|--------------------------------|------------------------------------------------|------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon Obi Telefonnummer von 17638            | 0.5333333333333333  | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer 01767 382453 an | 0.0                 | x     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon von Rheinbach                          | 0.9230769230769231  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Reborn Puppen Telefonnummer 01767 3832985 an   | 0.17647058823529413 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767 385492 an        | 0.0                 | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761 236453          | 0.0625              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176 12385 7923 an     | 0.0                 | x     |

| Conference Speaker             | Actual Text                                    | Speechmatics Enhanced                          | WER                 | Match |
|--------------------------------|------------------------------------------------|------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe die Telefonnummer 01761380953.    | 0.13333333333333333 | o     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer 01767382453 an. | 0.0                 | x     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Nummer von Nummer 1361381.     | 0.46153846153846156 | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer 017673832985.      | 0.17647058823529413 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon. Rufe die Nummer 01767385492 an!       | 0.0                 | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon. Wähle die Nummer 01761236453.         | 0.0625              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 017612 3857923 an.     | 0.0                 | x     |


| Conference Speaker             | Actual Text                                    | Coqui                                                                                        | WER                 | Match |
|--------------------------------|------------------------------------------------|----------------------------------------------------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | telefon die telefonnummer eins sieben sechs neun                                             | 0.5333333333333333  | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | telefon ruf die telefonnummer null eins sieben sechs acht vier fuenf drei an                 | 0.3125              | -     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | telefon langbein ist eins acht                                                               | 0.7692307692307693  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | forstner eins sieben sechs sieben drei drei neun an                                          | 0.5294117647058824  | -     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die nummer neun eins sieben sechs drei fuenf vier neun zwei                     | 0.3125              | -     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon waehle die nummer eins sieben sechs zwei drei sechs vier fuenf drei                  | 0.3125              | -     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die nummer null eins sieben sechs eins drei acht fuenf sieben neun drei drei an | 0.16666666666666666 | o     |


| Conference Speaker             | Actual Text                                    | IBM Cloud                                                                                     | WER                 | Match |
|--------------------------------|------------------------------------------------|-----------------------------------------------------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   |                                                                                               | 1.0                 | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer null eins sieben sechs sieben drei acht zwei vier fünf drei an | 0.0                 | x     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für eins Preis O. eins drei acht acht                                                 | 0.6153846153846154  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer null eins sieben sechs sieben drei acht drei zwei neun acht fünf  | 0.17647058823529413 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon pro für die Nummer null eins sieben sechs sieben drei acht fünf vier neun zwei acht   | 0.1875              | o     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer null eins sieben sechs eins zwei drei sechs vier fünf drei           | 0.0625              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer null eins sieben sechs eins zwei drei acht fünf sieben neun zwei drei | 0.05555555555555555 | x     |

| Conference Speaker             | Actual Text                                    | Speechtext.ai                                                                                         | WER                 | Match |
|--------------------------------|------------------------------------------------|-------------------------------------------------------------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe die Telefonnummer null EINZ sieben sechs EINZ drei acht und neun f\u00fcnf drei          | 0.26666666666666666 | o     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon O f\u00fcr die Telefonnummer null eins sieben sechs sieben drei acht Sophia f\u00fcnf drei an | 0.375               | -     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | ein Telefon f\u00fcr die noch online ein Kreis O eins bei acht an                                     | 0.7692307692307693  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer null eins sieben sechs sieben drei acht drei zwei neun achtzehn an        | 0.23529411764705882 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer Null eins sieben sechs sieben drei acht f\u00fcnf vier neun zwei              | 0.1875              | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon w\u00e4hle die Nummer Null eins sieben sechs eins zwei drei sechs vier f\u00fcnf drei         | 0.3125              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer Null eins sieben sechs eins zwei drei acht f\u00fcnf sieben neun zwei drei an | 0.1111111111111111  | x     |


| Conference Speaker             | Actual Text                                    | rev.ai                                            | WER                 | Match |
|--------------------------------|------------------------------------------------|---------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Hilde, wo viele Polen war, ein Ziehen 63 800.     | 0.8                 | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | ele fon rufe die Telefonnummer 0176738 zu 453 an. | 0.1875              | o     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon und ein Reich, wo ein Freier              | 0.9230769230769231  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | wir von guten Telefonnummer 01767383298           | 0.29411764705882354 | -     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon Pro für die Nummer 0176738 von 4921       | 0.25                | o     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761236453              | 0.0625              | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 017613857923 an.          | 0.05555555555555555 | o     |


| Conference Speaker             | Actual Text                                    | AWS Transcribe                                  | WER                 | Match |
|--------------------------------|------------------------------------------------|-------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Helena, wo oben Telefone waren 1763 800.        | 0.6666666666666666  | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon Rufe die Telefonnummer 0176738453 an.   | 0.0625              | x     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon von einem Reich. Wo ein Frage an        | 0.8461538461538461  | o     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Von Rufen Telefonnummer 0176738329 18 waren.    | 0.35294117647058826 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon Rufe die Nummer 01 gegen 6738 von 4921. | 0.1875              | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon Wähle die Nummer 01761236453.           | 0.0625              | o     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon Rufe die Nummer 017613857923 an.        | 0.05555555555555555 | o     |


| Conference Speaker             | Actual Text                                    | AssemblyAI                                                                                  | WER                 | Match |
|--------------------------------|------------------------------------------------|---------------------------------------------------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | telefon rufe die telefonnummer null eins sieben sechs eins von drei acht von neun zentralen | 0.26666666666666666 | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | telefon rufe die telefonnummer null eins sieben sechs sieben drei acht vier fünf drei an    | 0.0625              | o     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | telefon für die Nr. null eins preis eins bei acht anfang                                    | 0.5384615384615384  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | telefon rufen telefonnummer null eins sieben sechs sieben drei acht drei und neun acht n    | 0.29411764705882354 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die Nr. null eins sieben sechs sieben drei acht fünf vier neun zwei            | 0.125               | x     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon wähle die Nr. null eins sieben sechs eins zwei drei sechs vier fünf drei            | 0.125               | x     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die Nr. null eins sieben sechs eins drei acht fünf sieben neun drei an         | 0.16666666666666666 | o     |


| Conference Speaker             | Actual Text                                       | trint                                         | Match |
|--------------------------------|---------------------------------------------------|-----------------------------------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176 138295 an     | Telefonnummer. Telefonnummer 01761380951.     | o     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 0176 738 2453 an   | Telefon rufe die Telefonnummer 0176738453 an! | o     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 013 52 138 an             | n/a                                           | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 0176 7383 29 85 an | n/a                                           | -     |
| Logitech P710e                 | Telefon rufe die Nummer 0176 738 54 92  an        | Telefon. Rufe die Nummer 017673854921         | o     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 0176 1236453  an         | n/a                                           | -     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176 123857923 an         | n/a                                           | -     |


| Conference Speaker             | Actual Text                                    | Deepgram Standard                                                                                       | WER                 | Match |
|--------------------------------|------------------------------------------------|---------------------------------------------------------------------------------------------------------|---------------------|-------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | hilfe rufen hund ein eins drei acht null                                                                | 0.8                 | -     |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | rufe die telefonnummer null eins sechs sieben drei acht zu vier fünf drei alt                           | 0.25                | -     |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | ein acht                                                                                                | 0.9230769230769231  | -     |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | rufen telefonnummer null eins sieben sechs sieben drei ab dreizehn vor neun acht                        | 0.47058823529411764 | o     |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die nummer null liegen sechs sieben drei acht vier zwei jahren                             | 0.3125              | -     |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon wählt die nummer null eins sechs eins zwei drei sechs vier fünf drei                            | 0.1875              | o     |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die nummer null eins sieben sechs eins zwei drei fünf neuntausendsiebenhundert uhr drei an | 0.2222222222222222  | -     |

# Other speaker candidates

* [BEYERDYNAMIC SPACE](https://www.beyerdynamic.de/space.html)
* [Anker PowerConf S500](https://de.ankerwork.com/products/a3305)
* [Poly - Sync 40](https://www.poly.com/de/de/products/phones/sync/sync-40)
* [Lemorele Bluetooth Speakerphone](https://us.lemorele.com/collections/accessories/products/lemorele-bluetooth-speakerphone-w-4-mics-m4?spm=..collection_daa6c163-81af-43f3-b5bf-c477e8ec0643.collection_detail_1.2)
* [Bluetooth Speakerphone Pro](https://sandberg.world/de-de/product/bluetooth-speakerphone-pro)
