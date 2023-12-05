import std / [strutils, sequtils]

const
  input* = "input"

type Card* = object
  id*: int
  instances*: int
  winning*: seq[int]
  numbers*: seq[int]

proc parseCard*(line: string): Card =
  let line = line.split({':','|'}).mapIt(it.strip.splitWhitespace)
  Card(
    id: line[0][1].parseInt,
    instances: 1,
    winning: line[1].map(parseInt),
    numbers: line[2].map(parseInt)
  )

proc cnt*(card: Card): int =
  card.numbers.countIt(it in card.winning)

proc worth*(card: Card): int =
  let cnt = card.cnt
  if cnt == 0:
    return 0
  else:
    return 1 shl (cnt-1)

#[
var sum = 0
for line in input.lines:
  let card = line.parseCard
  sum += card.worth

echo sum
]#
