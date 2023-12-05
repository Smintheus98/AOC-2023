import strutils
import global

let data: Scheme = input.readFile.strip.splitLines

var
  sum = 0

for row in 0..<data.dim.row:
  for col in 0..<data.dim.col:
    let spos = (row, col)
    if data.isGear(spos):
      sum += data.gearRatio(spos)

echo sum

