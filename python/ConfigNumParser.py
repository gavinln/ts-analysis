#! /usr/bin/env python
# vim: set et sts=4 sw=4:
# -*- coding: utf-8 -*-
"""
This Module contains several convenient parsers and fonctions to easily parse
formatted text into values usable with python of Numpy fonctions.

The main function is parseConfigFile which allow to read a text file
structured in sections and convert it into a python object with the same
structure but where information is automatically converted into
python or numpy objects
(see http://www.scipy.org/Cookbook/Reading_Custom_Text_Files_with_Pyparsing)


== Parser definitions ==

 * number  : match string representing integers or floats and return the
             corresponding python object

 * pyValue : match string representing number, None, True, False, NaN or
             quoted strings and return the corresponding python object


== Parser generators ==

 * variableParser : create a parser to match variable names and return a
    cleaned version of it

 * paramParser    : create a parser to match a set of parameter definitions

 * tableColParser : create a parser to match a table, defined column by column

 * tableRowParser : create a parser to match a table, defined row by row

 * matrixParser   : create a parser to match a matrix

See the corresponding docstring for more information and parseConfigFile for an
example of utilisation.
"""
import pyparsing as pp
from numpy import array, NAN
from re import VERBOSE

__version__ = "0.1.1"
__all__ = """
    number pyValue matrixParser tableRowParser
    tableColParser paramParser variableParser
    parseConfigFile
""".split()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Utility functions and definitions


def variableParser(escapedChars, baseChars=pp.alphanums):
    """Return a parser matching any characters in baseChars separated by
    characters defined in escapedChars. Thoses characters are replaced with '_'

    The '_' character is therefore automatically in escapedChars.
    """
    escapeDef = pp.Word(escapedChars + "_").setParseAction(pp.replaceWith("_"))
    whitespaceChars = "".join(x for x in " \t\r" if x not in escapedChars)
    escapeDef = escapeDef.setWhitespaceChars(whitespaceChars)
    return pp.Combine(
        pp.Word(baseChars) + pp.Optional(pp.OneOrMore(escapeDef + pp.Word(baseChars)))
    )


def convertNumber(t):
    """Convert a string matching a number to a python number"""
    if t.float1 or t.float2 or t.float3:
        return [float(t[0])]
    else:
        return [int(t[0])]


# number : match any number and return asscoiated python value

number = pp.Regex(
    r"""
        [+-]?                           # optional sign
         (
            (?:\d+(?P<float1>\.\d*)?)   # match 2 or 2.02
          |                             # or
            (?P<float2>\.\d+)           # match .02
         )
         (?P<float3>[Ee][+-]?\d+)?      # optional exponent
    """,
    flags=VERBOSE,
)

number.setParseAction(convertNumber)

pyValue_list = [
    number,
    pp.Keyword("True").setParseAction(pp.replaceWith(True)),
    pp.Keyword("False").setParseAction(pp.replaceWith(False)),
    pp.Keyword("NAN", caseless=True).setParseAction(pp.replaceWith(NAN)),
    pp.Keyword("None").setParseAction(pp.replaceWith(None)),
    pp.QuotedString('"""', multiline=True),
    pp.QuotedString("'''", multiline=True),
    pp.QuotedString('"'),
    pp.QuotedString("'"),
]

# Common patterns

EOL = pp.LineEnd().suppress()
pyValue = pp.MatchFirst(e.setWhitespaceChars(" \t\r") for e in pyValue_list)
unitDef = (
    pp.Suppress("(")
    + (pp.Suppress(pp.oneOf("- /")) | pp.Optional(pp.Word(pp.alphanums + "^*/-._")))
    + pp.Suppress(")")
)
keyName = pp.variableParser(" _-./").setParseAction(pp.downcaseTokens)
keyNameWithoutSpace = pp.variableParser("_-./").setParseAction(pp.downcaseTokens)

# Parameter Definition


def paramParser(comment="#"):
    """Create a pattern matching any definition of parameters with the form

        variable_name (unit) = value            (unit is optional)

    Variable names can have spaces in them or any characters in '_-./' but
    theses characters are replaced with '_' and the resulting variable name
    will be cast to lowercase.

    Value can be any standard python value (int, number, None, False, True, NaN
    or quoted strings) or a raw string, which can be multiline if additional
    lines start with a whitespace.

    Return a Dict element to allow accessing data using the varible name as a
    key.

    This Dict has two special fields :
        names_ : the list of column names found
        units_ : a dict in the form {key : unit}
    """

    def formatBloc(t):
        """Format the result to have a list of (key, values) easily usable
            with Dict

        Add two fields :
            names_ : the list of column names found
            units_ : a dict in the form {key : unit}
        """
        rows = []

        # store units and names
        units = {}
        names = []

        for row in t:
            rows.append(pp.ParseResults([row.name, row.value]))
            names.append(row.name)
            if row.unit:
                units[row.name] = row.unit[0]

        rows.append(pp.ParseResults(["names_", names]))
        rows.append(pp.ParseResults(["unit_", units]))

        return rows

    # rawValue can be multiline but theses lines should start with a Whitespace
    rawLine = pp.CharsNotIn(comment + "\n") + (
        pp.lineEnd | pp.Suppress(comment + pp.restOfLine)
    )
    rawValue = pp.Combine(
        rawLine + pp.ZeroOrMore(pp.White(" \t").suppress() + pp.NotAny("[") + rawLine)
    )
    rawValue.setParseAction(lambda t: [x.strip() for x in t])

    valueDef = pyValue | rawValue
    paramDef = (
        keyName("name")
        + pp.Optional(unitDef)("unit")
        + pp.Suppress("=" + pp.empty)
        + valueDef("value")
    )
    paramBloc = pp.OneOrMore(pp.Group(paramDef)).setParseAction(formatBloc)

    return pp.Dict(paramBloc)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Table described in columns Definition


def tableColParser():
    """Define a pattern matching a table described in columns according to
        this schema :
            Name_1       Name_2     ...      Name_n
            (unit_1)    (unit_2)    ...     (unit_n)
            value_11    value_21    ...     value_n1
              ...         ...       ...       ...

    Names can't contains any whitespaces.
    Units are mandatory.

    Value can be any standard python value (int, number, None, False, True, NaN
    or quoted strings) or a raw string which can't contains spaces or '['.

    Return a Dict element to allow accessing data using the column name as a
    key.

    This Dict has two special fields :
        names_ : the list of column names found
        units_ : a dict in the form {key : unit}
    """

    def formatBloc(t):
        """Format the result to have a list of (key, values) easily usable
        with Dict and transform data into array

        Add two fields :
            names_ : the list of column names found
            units_ : a dict in the form {key : unit}
        """
        columns = []

        # store names and units names
        names = t.header
        units = {}

        transposedData = zip(*t.data)
        for header, unit, data in zip(t.header, t.unit, transposedData):
            units[header] = unit
            columns.append(pp.ParseResults([header, array(data)]))

        columns.append(pp.ParseResults(["names_", names]))
        columns.append(pp.ParseResults(["unit_", units]))

        return columns

    def defineColNumber(t):
        """Define unitLine and tabValueLine to match the same number of row
        than in header"""
        nbcols = len(t.header)
        unitLine << pp.Group(unitDef * nbcols + EOL)
        tabValueLine << pp.Group(tabValueDef * nbcols + EOL)

    tabValueDef = pyValue | pp.CharsNotIn("[ \t\r\n").setWhitespaceChars(" \t")
    firstLine = pp.Group(pp.OneOrMore(keyNameWithoutSpace) + EOL)
    unitLine = pp.Forward()
    tabValueLine = pp.Forward()

    tableCol = (
        firstLine("header").setParseAction(defineColNumber)
        + unitLine("unit")
        + pp.Group(pp.OneOrMore(tabValueLine))("data")
    ).setParseAction(formatBloc)

    return pp.Dict(tableCol)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Matrix parser
def matrixParser(pattern=pyValue):
    """Return a pattern matching a matrix containing only element matching
    pattern"""

    def formatBloc(t):
        "return an array object"
        return [array(t.asList())]

    def defineColNumber(t):
        """define matrixLine to match the same number of col than t has"""
        nbcols = len(t[0])
        matrixLine << pp.Group(pattern * nbcols + EOL)

    firstLine = pp.Group(pp.OneOrMore(pattern) + EOL).setParseAction(defineColNumber)
    matrixLine = pp.Forward()
    matrixDef = (firstLine + pp.OneOrMore(matrixLine)).setParseAction(formatBloc)

    return matrixDef


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
def tableRowParser():
    """Define a pattern matching a table described in row following the
        schema :

        Name_1 (unit)   value_11     value_12   ... value_1n
        Name_2 (unit)   value_21     value_22   ... value_2n
         ...     ...        ...      ...        ...     ...

    Units are optional.
    Name can contains spaces if theyt are followed by an unit, otherwise, they
    can't.

    Value can be any standard python value (int, number, None, False, True, NaN
    or quoted strings) or a raw string which can't contains spaces or '['.

    Return a Dict element to allow accessing data using the column name as a
    key.

    This Dict has two special fields :
        names_ : the list of row names found
        units_ : a dict in the form {key : unit}
    """

    def formatBloc(t):
        """Format the result to have a list of (key, values) easily usable
            with Dict and transform values into array

        Add two fields :
            names_ : the list of row names found
            units_ : a dict in the form {key : unit}
        """
        rows = []

        # store units and names
        units = {}
        names = []

        for row in t:
            rows.append(pp.ParseResults([row.header, array(tuple(row.value))]))
            names.append(row.header)
            if row.unit:
                units[row.header] = row.unit[0]

        rows.append(pp.ParseResults(["names_", names]))
        rows.append(pp.ParseResults(["unit_", units]))

        return rows

    def defineColNumber(t):
        """Define unitLine and tabValueLine to match the same number of
        columns than the first line had"""
        nbcols = len(t[0].value)
        tabValueLine << pp.Group(
            rowHeader + pp.Group(tabValueDef * nbcols)("value") + EOL
        )

    # Table described in rows
    tabValueDef = pyValue | pp.CharsNotIn("[ \t\r\n").setWhitespaceChars(" \t")
    rowHeader = (keyName("header") + unitDef("unit")) | keyNameWithoutSpace("header")
    firstLine = pp.Group(
        rowHeader + pp.Group(pp.OneOrMore(tabValueDef))("value") + EOL
    ).setParseAction(defineColNumber)
    tabValueLine = pp.Forward()

    tableRowDef = (firstLine + pp.OneOrMore(tabValueLine)).setParseAction(formatBloc)

    return pp.Dict(tableRowDef)


def test_pattern(pattern, fname="data.txt"):
    """A simple function to test a ParserElement"""
    for (
        r,
        s,
        t,
    ) in pattern.scanString(pp.file(fname).read()):
        print("found : ", r)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# section parser
def parseConfigFile(fname):
    """Parse a file structured in section according to the schema
            [ section Name ]
                <bloc>
                ....

    where <bloc> can be any text matching one of elements created by :

     * paramParser    <=> a set of variable definitions
     * tableColParser <=> a table defined column by column
     * tableRowParser <=> a table defined row by row
     * matrixParser   <=> a Matrix containg only python values or NaN

    Any text after the character # is considered as a comment and is ignored

    Return a Dict element to allow accessing bloc using the section name as a
    key.
    """

    # Section header
    sectionName = pp.Suppress("[") + keyName + pp.Suppress("]")

    # Group section name and content
    section = pp.Group(
        sectionName
        + (paramParser() | tableColParser() | tableRowParser() | matrixParser())
    )

    # Build the final parser and suppress empty sections
    parser = pp.Dict(pp.OneOrMore(section | pp.Suppress(sectionName)))

    # Defines comments
    parser.ignore("#" + pp.restOfLine)

    # parse file
    try:
        return parser.parseFile(fname, parseAll=True)

    except pp.ParseException as pe:
        # complete the error message
        msg = "ERROR during parsing of %s,  line %d:" % (fname, pe.lineno)
        msg += "\n" + "-" * 40 + "\n"
        msg += pe.line + "\n"
        msg += " " * (pe.col - 1) + "^\n"
        msg += "-" * 40 + "\n" + pe.msg
        pe.msg = msg
        raise


if __name__ == "__main__":

    from sys import argv
    from pprint import pprint

    if len(argv) < 2:
        fname = "data.txt"
    else:
        fname = argv[1]

    data = parseConfigFile(fname)
    pprint(data.asList())
