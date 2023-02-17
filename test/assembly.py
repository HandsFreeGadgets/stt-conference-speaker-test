import os
import sys
import requests
from time import sleep

if __name__ == '__main__':
    import requests

    filename = sys.argv[1]
    token = os.environ['ASSEMBLY_KEY']

    def read_file(filename, chunk_size=5242880):
        with open(filename, 'rb') as _file:
            while True:
                data = _file.read(chunk_size)
                if not data:
                    break
                yield data


    headers = {'authorization': token}
    response = requests.post('https://api.assemblyai.com/v2/upload',
                             headers=headers,
                             data=read_file(filename))

    endpoint = "https://api.assemblyai.com/v2/transcript"
    json = {"audio_url": response.json()['upload_url'], "language_code": "de", "punctuate": False, "format_text": True}
    headers = {
        "authorization": token,
        "content-type": "application/json"
    }
    response = requests.post(endpoint, json=json, headers=headers)
    id = response.json()['id']

    endpoint = "https://api.assemblyai.com/v2/transcript/"+id
    headers = {
        "authorization": token,
    }
    while True:
        sleep(5)
        response = requests.get(endpoint, headers=headers)
        if response.json()['status'] == 'completed' or response.json()['status'] == 'error':
            break
    print(response.json()['text'])
