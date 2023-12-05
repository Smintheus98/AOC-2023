import strutils, sequtils, math
import strformat

type
  Color* = enum
    red green blue
  Sample* = array[Color, Natural]
  Game* = object
    id*: Positive
    samples*: seq[Sample]

proc `<=`*(s1, s2: Sample): bool =
  for color in Color:
    if s1[color] > s2[color]:
      return false
  return true


proc `>=`*(s1, s2: Sample): bool =
  for color in Color:
    if s1[color] < s2[color]:
      return false
  return true

proc max*(samples: seq[Sample]): Sample =
  for color in Color:
    result[color] = samples.mapIt(it[color]).max

proc min*(samples: seq[Sample]): Sample =
  for color in Color:
    result[color] = samples.mapIt(it[color]).min

proc power*(game: Game): Positive =
  game.samples.max.prod

proc parseSample*(s: string): Sample =
  let s = s.split(',').mapIt(it.strip.split)
  for c in s:
    let col = parseEnum[Color] c[1]
    result[col] = c[0].parseInt

proc parseGame*(line: string): Game =
  let line = line.split({':',';'}).mapIt(it.strip())
  result.id = line[0].split[1].parseInt
  for i in 1..<line.len:
    result.samples.add line[i].parseSample

const
  input* = "input"
  limit*: Sample = [12, 13, 14]
