import global

var sum = 0
for line in input.lines:
  let card = line.parseCard
  sum += card.worth

echo sum
