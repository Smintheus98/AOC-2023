import global

const input = "input"

var sum = 0

for line in input.lines:
  let ts = line.parseTimeSeries
  sum += ts.forecast

echo sum
