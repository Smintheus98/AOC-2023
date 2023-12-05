import strutils
import global

let data: Scheme = input.readFile.strip.splitLines

var
  row = 0
  col = 0
  sum = 0

while row < data.dim.row:
  while col < data.dim.col:
    let spos = (row, col)
    if data.isNumber(spos):
      if data.isPartNumber(spos):
        let number = data.readNumber spos
        sum += number
      col += data.numLen spos
    else:
      col.inc
  col = 0
  row.inc

echo sum

