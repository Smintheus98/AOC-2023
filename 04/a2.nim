import std / [strutils, sequtils]
import global

var cards = input.readFile.strip.splitLines.map(parseCard)

for i, card in cards:
  let cnt = card.cnt
  for j in (i+1)..(i+cnt):
    cards[j].instances.inc card.instances

echo cards.foldl(a + b.instances, 0)
