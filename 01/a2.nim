import strutils

var sum = 0

let Numbers = [
  (name: "one",   val: 1),
  (name: "two",   val: 2),
  (name: "three", val: 3),
  (name: "four",  val: 4),
  (name: "five",  val: 5),
  (name: "six",   val: 6),
  (name: "seven", val: 7),
  (name: "eight", val: 8),
  (name: "nine",  val: 9),
]

proc getFirstNumber(line: string): int =
  let firstNumIdx = line.find(Digits)
  var firstTNumIdx = -1
  var firstTNumVal: int

  block loops:
    for l in 0..line.high:
      for number in Numbers:
        if line[l..^1].startswith number.name:
          firstTNumIdx = l
          firstTNumVal = number.val
          break loops

  if firstNumIdx >= 0 and firstNumIdx < firstTNumIdx or firstTNumIdx < 0:
    return line[firstNumIdx].`$`.parseInt
  else:
    return firstTNumVal

proc getLastNumber(line: string): int =
  let lastNumIdx = line.rfind(Digits)
  var lastTNumIdx = -1
  var lastTNumVal: int

  block loops:
    for u in countdown(line.high, 0):
      for number in Numbers:
        if line[0..u].endswith number.name:
          lastTNumIdx = u - number.name.len
          lastTNumVal = number.val
          break loops

  if lastNumIdx >= 0 and lastNumIdx > lastTNumIdx or lastTNumIdx < 0:
    return line[lastNumIdx].`$`.parseInt
  else:
    return lastTNumVal


var i = 0
for line in "input".lines:
  let n1 = line.getFirstNumber
  let n2 = line.getLastNumber
  let num = n1 * 10 + n2
  sum += num
  i.inc

echo sum
