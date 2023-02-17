import sys

import jiwer

if __name__ == '__main__':
    transformation = jiwer.Compose([
        jiwer.ToLowerCase(),
        jiwer.RemovePunctuation(),
        jiwer.Strip(),
        jiwer.RemoveWhiteSpace(replace_by_space=True),
        jiwer.RemoveMultipleSpaces(),
        jiwer.SubstituteWords(
            {"null": "0", "eins": "1", "einz": "1", "zwei": "2", "drei": "3", "vier": "4", "fünf": "5", "sechs": "6", "sieben": "7",
             "acht": "8", "neun": "9",
             "zwo": "2", "elf": "11", "zwölf": "12", "zehn": "10", "dreizehn": "13", "plus": "+", "vierzehn": "14",
             "fünfzehn": "15", "sechszehn": "16", "siebzehn": "17", "achtzehn": "18",
             "neunzehn": "19", "zwanzig": "20"}),
        jiwer.SubstituteRegexes({r"(?<=\d)(?=\d)": r" "}),
        jiwer.SubstituteRegexes({r"\u00fc": r"ü"}),
        jiwer.ReduceToListOfListOfWords(word_delimiter=" ")
    ])
    print(jiwer.wer(
        sys.argv[1],
        sys.argv[2],
        truth_transform=transformation,
        hypothesis_transform=transformation
    ))
