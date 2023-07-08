#!/usr/bin/env python3
#Translating a string into a binary sequence of Braille code.

import sys


def translate(s):
    """
    Return braille codes. Dictionary from list.
    """
    # Condition check
    if len(s) >= 50:
        return "Overlength"
    
    for i in s:
        if (i not in map(chr, range(65, 91))) and (i not in map(chr, range(97, 123))) and (i != " "):
            print(i)
            return "Non letters string"

    braille_dict = {
    'a': '100000',
    'b': '110000',
    'c': '100100',
    'd': '100110',
    'e': '100010',
    'f': '110100',
    'g': '110110',
    'h': '110010',
    'i': '010100',
    'j': '010110',
    'k': '101000',
    'l': '111000',
    'm': '101100',
    'n': '101110',
    'o': '101010',
    'p': '111100',
    'q': '111110',
    'r': '111010',
    's': '011100',
    't': '011110',
    'u': '101001',
    'v': '111001',
    'w': '010111',
    'x': '101101',
    'y': '101111',
    'z': '101011',
    ' ': '000000'}

    #Add uppercase to dictionary
    upperalph = list(map(chr, range(65, 91)))
    for i in upperalph:
        letter = i.lower()
        braille_dict[i] = "000000" + braille_dict[letter]
    
    # Encode from string to braille
    result = ""
    for i in s:
        result += str(braille_dict[i])
    return result


def main():
    if len(sys.argv) != 2:
        print(f"(+) usage: {sys.argv[0]} <>") 
        print(f"(+) eg: {sys.argv[0]} 'Oh my zsh'")
        sys.exit(-1)
    
    phrase = sys.argv[1]
    result = translate(phrase)
    print(result)
    

if __name__ == "__main__":
    main()
