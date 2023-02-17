# Zusammenfassung


Repository, das verschiedene Speech-To-Text (STT)-Lösungen und Konferenzlautsprecher testet, um sie zur Transkription von Befehlen für Geräteinteraktionen zu verwenden.

[Englische Version](README-de.md).


# Finanzierung

Das Projekt wurde vom deutschen Bundesministerium für Bildung und Forschung unter dem Förderkennzeichen 01IS22S34 von September 2022 bis Februar 2023 gefördert. 
Die Verantwortung für den Inhalt dieser Veröffentlichung liegt bei den Autoren.


<img src="BMBF_gefördert vom_deutsch.jpg" width="300px"/>

# Testdetails

Alle Tests wurden durchgeführt, während das gleiche Hintergrundvideo [A Beginner's Guide to Quantum Computing] (https://www.youtube.com/watch?v=S52rxZG-zi0) ab Offset 7:00 abgespielt wurde.

Das Video wurde über den Konferenzlautsprecher als Ausgabegerät abgespielt. Während des Tests waren keine anderen Hintergrundgeräusche vorhanden. 

Dies sollte einer realen Situation in einer geräuscharmen Umgebung ähneln mit anderen möglichen Medien- und Kommunikationsausgaben über den Konferenzlautsprecher.


Für alle Cloud-Lösungen wurde keine kontextspezifische Grammatik verwendet, für die Coqui-Erkennung wurde das [Deutsche Sprachmodel] (https://coqui.ai/models) und ein an die Grammatik angepasster Scorer verwendet.

Das Testszenario ist begrenzt und konzentriert sich nur auf eine Entfernung, einen Hintergrund, einen Sprecher und eine Phrase, mit mehr Zeit kann ein komplexeres Setup erstellt werden.

# Testdurchführung


Alle Testskripte verwenden Deutsch als Sprache für die Spracherkennung. Für andere Sprachen müssen die Testskripte modifiziert oder erweitert werden, um diesen Parameter zu unterstützen.

Um die Tests zu wiederholen, müssen wav-Dateien im Ordner `samples` abgelegt werden, die den Konferenzlautsprechernamen in der Datei `speaker.txt` entsprechen. 
Die Datei `utterances.txt` enthält die Anweisung zu jeder Konferenzlautsprecherzeile. 


## Google Cloud

Die Google Cloud CLI muss installiert sein und ein [Google Service Account](https://cloud.google.com/speech-to-text/docs/before-you-begin) muss erstellt werden.

~~~shell
cd test
export GOOGLE_APPLICATION_CREDENTIALS=<Pfad zur JSON-Datei des Dienstkontos>
./google.sh
~~~

## MS Azure

Das [Azure Speech CLI](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/spx-basics?tabs=windowsinstall%2Cterminal) muss installiert und ein Speech-Dienst erstellt werden.

~~~shell
cd test
spx config @key --Einstellung SPEECH-KEY
spx config @region --set SPEECH-REGION
~~~


## Coqui

Coqui installieren:

~~~shell
python3 -m venv venv
Quelle venv/bin/activate
python -m pip install -U pip
venv/bin/pip install -r requirements.txt
~~~

~~~shell
./coqui.sh
~~~

## OpenAI Whisper

Whispher installieren:

~~~shell
## https://github.com/pyenv/pyenv installieren
pyenv install 3.9.9
pyenv local 3.9.9
python3 -m venv venv-whispher
Quelle venv-whispher/bin/activate
python -m pip installieren -U pip
pip3 install jiwer
pip3 install git+https://github.com/openai/whisper.git 
~~~

~~~shell
./openai.sh
~~~

## IBM Cloud

Das IBM Access Token von einem [speech-to-text service](https://cloud.ibm.com/apidocs/speech-to-text) wird benötigt.

~~~shell
export IBM_URL=...
export IBM_API_KEY=...
./ibm.sh
~~~

## Speechtext.ai

Ein API-Schlüssel muss von [speechtext.ai](https://speechtext.ai/speech-recognition-api) angefordert werden.

~~~shell
export SPEECHTEXT_KEY=...
./speechtext.sh
~~~

## rev.ai

Ein API-Schlüssel muss von [rev.ai](https://www.rev.ai/access-token) angefordert werden.

~~~shell
export REV_KEY=...
./rev.sh
~~~


## AWS Transcribe

Es muss ein Benutzer in IAM mit der Transcribe-Richtlinie erstellt werden.

~~~shell
source venv/bin/activate
python -m pip install -U pip
venv/bin/pip install -r requirements.txt
pip3 amazon-transcribe deinstallieren
pip install git+https://github.com/awslabs/amazon-transcribe-streaming-sdk.git@develop
~~~

~~~shell
python3 -m venv venv
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
./aws.sh
~~~

## AssemblyAI

Ein API-Schlüssel muss von [rev.ai](https://www.rev.ai/access-token) angefordert werden.

~~~shell
export ASSEMBLY_KEY=...
./assembly.sh
~~~


## trint

[trint](https://app.trint.com) erlaubt nur 3 Tests im Testmodus.

## Speechmatics

Ein API-Schlüssel für die [API](https://portal.speechmatics.com/getting-started/) wird benötigt.

~~~shell
export SPEECHMATICS_KEY=...
./speechmatics.sh
~~~


## Deepgram

Ein API-Schlüssel von [Deepgram](https://developers.deepgram.com/api-reference/) is notwendig.

~~~shell
export DEEPGRAM_KEY=...
./deepgram.sh
~~~

# Ergebnisse

Die Ergebnisse hier spiegeln manchmal nicht die menschliche Wahrnehmung der Sprachqualität wider. 
Die Konferenzlautsprecher verwenden verschiedene Technologien wie Echounterdrückung, Beam-Forming, Hintergrundgeräuschunterdrückung und 
Spracherkennungsalgorithmen, die nur bestimmte Frequenzen filtern. Oft liefern diese Algorithmen zwar hörbar gute Ergebnisse 
aber sie schneiden wichtige Teile des Tons ab, verwenden Stille oder stören sie, sodass die STT-Algorithmen versagen.

## Subjektive Wahrnehmung 

| Konferenzlautsprecher          | Menschliche Wahrnehmung                                                                                                                  | Probleme                                                                        | Kommentar                                                                                                                                     |  
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| EMEET OfficeCore M2 Max (Mono) | Gut, Hintergrund wird ziemlich gut herausgefiltert, dumpf, merklich abgeschnittene Frequenzen, Amplitudenpegel ist nicht konstant        |                                                                                 | Stereomodus brachte keine besseren Ergebnisse, AI-Modus verschlechterte das Ergebnis, auch die menschliche Wahrnehmung wurde nicht verbessert | 
| EPOS EXPAND40+                 | Sehr gut, klar, Hintergrund wird fast perfekt herausgefiltert                                                                            |                                                                                 |                                                                                                                                               | 
| Jabra Speak 750 UC             | Befriedigend, Frequenzanteile werden gekappt, Teile des Tons werden herausgefiltert oder abgeschnitten, Hintergrund wird herausgefiltert |                                                                                 |                                                                                                                                               |
| Konftel 70                     | Gut, auffällige abgeschnittene Frequenzen, dumpf, Hintergrund herausgefiltert                                                            | Tasten funktionieren nicht unter Linux                                          |                                                                                                                                               |
| Logitech P710e                 | Gut, etwas gedämpft, Hintergrund manchmal noch erkennbar                                                                                 | Akku angeblich schwach, schaltete sich aus, obwohl ständig mit USB-C verbunden. |                                                                                                                                               |
| ReSpeaker Mic Array v2.0       | Sehr gut, klar. Obwohl ein externer Lautsprecher verwendet wurde, wird der Hintergrund gut herausgefiltert                               |                                                                                 | Ein externer Lautsprecher wurde an die Audiobuchse angeschlossen                                                                              |
| Sennheiser PC8                 |                                                                                                                                          |                                                                                 | Nur als Referenz bei Verwendung eines Headsets mit direktem Spracheingang                                                                     |

## Leistung

Als Qualitätskriterium wird die WER (Wortfehlerrate) verwendet.

| Konferenzlautsprecher          | Eigentlicher Text                                 | MS Azure                                         | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|--------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe, die Telefonnummer 0176138295 an.   | 0.0                 | x               | 
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Und rufe die Telefonnummer 01767382453 an.       | 0.0625              | o               | 
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Luftballons 1 Preis. Oh 138. An. | 0.46153846153846156 | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer 017673832985 an.     | 0.11764705882352941 | x               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767385492 an.          | 0.0                 | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761236453.            | 0.0625              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176123857923 an.        | 0.0                 | x               |

| Konferenzlautsprecher          | Eigentlicher Text                              | OpenAI Whisper Large                              | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|---------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon und die Telefonnummer 0176-103-82953      | 0.2                 | o               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon, rufe die Telefonnummer 0176 738 2453 an. | 0.0                 | x               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Nummer 013-013-8.                 | 0.3076923076923077  | -               | 
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefonrouten, Telefonnummer 0176 7383 2985 an.   | 0.17647058823529413 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767385492 an.           | 0.0                 | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 0176 123 64 53.          | 0.0625              | x               | 
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176 123 857 923 an.      | 0.0                 | x               |

| Konferenzlautsprecher          | Eigentlicher Text                              | Google Cloud                                   | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon Obi Telefonnummer von 17638            | 0.5333333333333333  | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer 01767 382453 an | 0.0                 | x               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon von Rheinbach                          | 0.9230769230769231  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Reborn Puppen Telefonnummer 01767 3832985 an   | 0.17647058823529413 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer 01767 385492 an        | 0.0                 | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761 236453          | 0.0625              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 0176 12385 7923 an     | 0.0                 | x               |

| Konferenzlautsprecher          | Eigentlicher Text                              | Speechmatics Enhanced                          | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe die Telefonnummer 01761380953.    | 0.13333333333333333 | o               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer 01767382453 an. | 0.0                 | x               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für die Nummer von Nummer 1361381.     | 0.46153846153846156 | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer 017673832985.      | 0.17647058823529413 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon. Rufe die Nummer 01767385492 an!       | 0.0                 | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon. Wähle die Nummer 01761236453.         | 0.0625              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 017612 3857923 an.     | 0.0                 | x               |


| Konferenzlautsprecher          | Eigentlicher Text                              | Coqui                                                                                        | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|----------------------------------------------------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | telefon die telefonnummer eins sieben sechs neun                                             | 0.5333333333333333  | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | telefon ruf die telefonnummer null eins sieben sechs acht vier fuenf drei an                 | 0.3125              | -               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | telefon langbein ist eins acht                                                               | 0.7692307692307693  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | forstner eins sieben sechs sieben drei drei neun an                                          | 0.5294117647058824  | -               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die nummer neun eins sieben sechs drei fuenf vier neun zwei                     | 0.3125              | -               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon waehle die nummer eins sieben sechs zwei drei sechs vier fuenf drei                  | 0.3125              | -               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die nummer null eins sieben sechs eins drei acht fuenf sieben neun drei drei an | 0.16666666666666666 | o               |


| Konferenzlautsprecher          | Eigentlicher Text                              | IBM Cloud                                                                                     | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|-----------------------------------------------------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   |                                                                                               | 1.0                 | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon rufe die Telefonnummer null eins sieben sechs sieben drei acht zwei vier fünf drei an | 0.0                 | x               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon für eins Preis O. eins drei acht acht                                                 | 0.6153846153846154  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer null eins sieben sechs sieben drei acht drei zwei neun acht fünf  | 0.17647058823529413 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon pro für die Nummer null eins sieben sechs sieben drei acht fünf vier neun zwei acht   | 0.1875              | o               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer null eins sieben sechs eins zwei drei sechs vier fünf drei           | 0.0625              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer null eins sieben sechs eins zwei drei acht fünf sieben neun zwei drei | 0.05555555555555555 | x               |

| Konferenzlautsprecher          | Eigentlicher Text                              | Speechtext.ai                                                                                         | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|-------------------------------------------------------------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Telefon rufe die Telefonnummer null EINZ sieben sechs EINZ drei acht und neun f\u00fcnf drei          | 0.26666666666666666 | o               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon O f\u00fcr die Telefonnummer null eins sieben sechs sieben drei acht Sophia f\u00fcnf drei an | 0.375               | -               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | ein Telefon f\u00fcr die noch online ein Kreis O eins bei acht an                                     | 0.7692307692307693  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Telefon rufen Telefonnummer null eins sieben sechs sieben drei acht drei zwei neun achtzehn an        | 0.23529411764705882 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon rufe die Nummer Null eins sieben sechs sieben drei acht f\u00fcnf vier neun zwei              | 0.1875              | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon w\u00e4hle die Nummer Null eins sieben sechs eins zwei drei sechs vier f\u00fcnf drei         | 0.3125              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer Null eins sieben sechs eins zwei drei acht f\u00fcnf sieben neun zwei drei an | 0.1111111111111111  | x               |


| Konferenzlautsprecher          | Eigentlicher Text                              | rev.ai                                            | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|---------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Hilde, wo viele Polen war, ein Ziehen 63 800.     | 0.8                 | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | ele fon rufe die Telefonnummer 0176738 zu 453 an. | 0.1875              | o               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon und ein Reich, wo ein Freier              | 0.9230769230769231  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | wir von guten Telefonnummer 01767383298           | 0.29411764705882354 | -               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon Pro für die Nummer 0176738 von 4921       | 0.25                | o               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon wähle die Nummer 01761236453              | 0.0625              | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon rufe die Nummer 017613857923 an.          | 0.05555555555555555 | o               |


| Konferenzlautsprecher          | Eigentlicher Text                              | AWS Transcribe                                  | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|-------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | Helena, wo oben Telefone waren 1763 800.        | 0.6666666666666666  | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | Telefon Rufe die Telefonnummer 0176738453 an.   | 0.0625              | x               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | Telefon von einem Reich. Wo ein Frage an        | 0.8461538461538461  | o               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | Von Rufen Telefonnummer 0176738329 18 waren.    | 0.35294117647058826 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | Telefon Rufe die Nummer 01 gegen 6738 von 4921. | 0.1875              | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | Telefon Wähle die Nummer 01761236453.           | 0.0625              | o               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | Telefon Rufe die Nummer 017613857923 an.        | 0.05555555555555555 | o               |


| Konferenzlautsprecher          | Eigentlicher Text                              | AssemblyAI                                                                                  | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|---------------------------------------------------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | telefon rufe die telefonnummer null eins sieben sechs eins von drei acht von neun zentralen | 0.26666666666666666 | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | telefon rufe die telefonnummer null eins sieben sechs sieben drei acht vier fünf drei an    | 0.0625              | o               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | telefon für die Nr. null eins preis eins bei acht anfang                                    | 0.5384615384615384  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | telefon rufen telefonnummer null eins sieben sechs sieben drei acht drei und neun acht n    | 0.29411764705882354 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die Nr. null eins sieben sechs sieben drei acht fünf vier neun zwei            | 0.125               | x               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon wähle die Nr. null eins sieben sechs eins zwei drei sechs vier fünf drei            | 0.125               | x               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die Nr. null eins sieben sechs eins drei acht fünf sieben neun drei an         | 0.16666666666666666 | o               |


| Konferenzlautsprecher          | Eigentlicher Text                                 | trint                                         | Übereinstimmung |
|--------------------------------|---------------------------------------------------|-----------------------------------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176 138295 an     | Telefonnummer. Telefonnummer 01761380951.     | o               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 0176 738 2453 an   | Telefon rufe die Telefonnummer 0176738453 an! | o               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 013 52 138 an             | n/a                                           | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 0176 7383 29 85 an | n/a                                           | -               |
| Logitech P710e                 | Telefon rufe die Nummer 0176 738 54 92  an        | Telefon. Rufe die Nummer 017673854921         | o               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 0176 1236453  an         | n/a                                           | -               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176 123857923 an         | n/a                                           | -               |


| Konferenzlautsprecher          | Eigentlicher Text                              | Deepgram Standard                                                                                       | WER                 | Übereinstimmung |
|--------------------------------|------------------------------------------------|---------------------------------------------------------------------------------------------------------|---------------------|-----------------|
| EMEET OfficeCore M2 Max (Mono) | Telefon rufe die Telefonnummer 0176138295 an   | hilfe rufen hund ein eins drei acht null                                                                | 0.8                 | -               |
| EPOS EXPAND40+                 | Telefon rufe die Telefonnummer 01767382453 an  | rufe die telefonnummer null eins sechs sieben drei acht zu vier fünf drei alt                           | 0.25                | -               |
| Jabra Speak 750 UC             | Telefon rufe die Nummer 01352138 an            | ein acht                                                                                                | 0.9230769230769231  | -               |
| Konftel 70                     | Telefon rufe die Telefonnummer 017673832985 an | rufen telefonnummer null eins sieben sechs sieben drei ab dreizehn vor neun acht                        | 0.47058823529411764 | o               |
| Logitech P710e                 | Telefon rufe die Nummer 01767385492 an         | telefon rufe die nummer null liegen sechs sieben drei acht vier zwei jahren                             | 0.3125              | -               |
| ReSpeaker Mic Array v2.0       | Telefon wähle die Nummer 01761236453 an        | telefon wählt die nummer null eins sechs eins zwei drei sechs vier fünf drei                            | 0.1875              | o               |
| Sennheiser PC8                 | Telefon rufe die Nummer 0176123857923 an       | telefon rufe die nummer null eins sieben sechs eins zwei drei fünf neuntausendsiebenhundert uhr drei an | 0.2222222222222222  | -               |

# Andere Konferenzlautsprecher Kandidaten

* [BEYERDYNAMIC SPACE](https://www.beyerdynamic.de/space.html)
* [Anker PowerConf S500](https://de.ankerwork.com/products/a3305)
* [Poly - Sync 40](https://www.poly.com/de/de/products/phones/sync/sync-40)
* [Lemorele Bluetooth Speakerphone](https://us.lemorele.com/collections/accessories/products/lemorele-bluetooth-speakerphone-w-4-mics-m4?spm=..collection_daa6c163-81af-43f3-b5bf-c477e8ec0643.collection_detail_1.2)
* [Bluetooth Speakerphone Pro](https://sandberg.world/de-de/product/bluetooth-speakerphone-pro)
