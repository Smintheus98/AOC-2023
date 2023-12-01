import strutils

var sum = 0

for line in "input".lines:
  let n1 = line[find(line, Digits)]
  let n2 = line[rfind(line, Digits)]
  let num = parseInt(n1 & n2)
  sum += num

echo sum
