import std/parsecsv
from std/os import paramStr
from std/streams import newFileStream
import times
import std/re
import strutils
import tables

var name_surname = re"([A-Za-z]+(\s+[A-Za-z]+)+)"
var email_address = re"[-A-Za-z0-9!#$%&'*+/=?^_`{|}~]+(?:\.[-A-Za-z0-9!#$%&'*+/=?^_`{|}~]+)*@(?:[A-Za-z0-9](?:[-A-Za-z0-9]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[-A-Za-z0-9]*[A-Za-z0-9])?"
var birthday = re"([0-9]+(/[0-9]+)+)"

var s = newFileStream(paramStr(1), fmRead)
if s == nil:
    quit("cannot open file" & paramStr(1))

var x: CsvParser
open(x, s, paramStr(1),)
while readRow(x):
      for i, lines in items(x.row):
        if i > 0: # Assuming the first line is headers
            let fields = lines.strip(",")
            if fields.len >= 3:
                var row = initTable[string, string]()
                row["Fullname"] = fields[0].strip()
                row["Email"] = fields[1].strip()
                row["Birthday"] = fields[2].strip()
                echo row["Fullname"]
        


close(x)


