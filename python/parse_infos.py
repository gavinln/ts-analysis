# https://scipy-cookbook.readthedocs.io/items/Reading_Custom_Text_Files_with_Pyparsing.html
import pathlib
from pyparsing import Word, SkipTo, Optional, alphanums, lineEnd, empty
from pyparsing import Suppress


SCRIPT_DIR = pathlib.Path(__file__).parent.resolve()


# parameter definition
keyName = Word(alphanums + "_")

LParen, RParen = map(Suppress, "()")
unitDef = LParen + Word(alphanums + "^*/-._") + RParen
paramValueDef = SkipTo("#" | lineEnd)

paramDef = keyName + Optional(unitDef) + "=" + empty + paramValueDef


def test_paramDef():
    print(paramDef.parseString("Debug = False"))


def main():
    pass


if __name__ == "__main__":
    main()
