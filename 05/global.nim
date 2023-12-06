import std / [strutils, sequtils]

const input* = "input"

type
  Translation* = object
    destStart*: int
    srcStart*: int
    rangeLen*: int
  TranslationMap* = seq[Translation]
  AlmanacKind* = enum
    Single Range 
  SeedRange* = object
    start*: int
    length*: int
  Almanac* = object
    case kind: AlmanacKind
      of Single:
        seeds*: seq[int]
      of Range:
        seedRanges*: seq[SeedRange]
    maps*: seq[TranslationMap]


proc parseTranslation*(line: string): Translation =
  let fields = line.split.map(parseInt)
  Translation(
    destStart: fields[0],
    srcStart: fields[1],
    rangeLen: fields[2],
  )

proc translate*(number: int; trans: Translation): int =
  if number in trans.srcStart..<trans.srcStart+trans.rangeLen:
    let diff = number - trans.srcStart
    return trans.destStart + diff
  else:
    return number

proc parseTranslationMap*(s: seq[string]): TranslationMap =
  result = @[]
  for line in s[1..^1]:
    result.add line.parseTranslation

proc translate*(number: int; transMap: TranslationMap): int =
  for trans in transMap:
    let num = number.translate(trans)
    if num != number:
      return num
  return number

proc parseAlmanac*(file: string; SeedRanges = false): Almanac =
  let data = file.readFile.splitLines
  let seeds = data[0].split(':')[1].strip.split.map parseInt
  if SeedRanges:
    result = Almanac(kind: Range)
    for i in countup(0, seeds.high, 2):
      result.seedRanges.add SeedRange(start: seeds[i], length: seeds[i+1])
  else:
    result = Almanac(kind: Single)
    result.seeds = seeds
  
  var buffer: seq[string] = @[]
  for i, line in data[2..^1]:
    if line == "":
      result.maps.add buffer.parseTranslationMap
      buffer = @[]
    else:
      buffer.add line

proc translate*(number: int; transMaps: seq[TranslationMap]): int =
  result = number
  for transMap in transMaps:
    result = result.translate(transMap)

proc min*(almanac: Almanac): int =
  echo "start solving"
  case almanac.kind:
    of Single:
      return almanac.seeds.mapIt(it.translate(almanac.maps)).min()
    of Range:
      var minloc = -1
      for i, rng in almanac.seedRanges:
        echo "range nr: ", i, " / ", almanac.seedRanges.len
        for offset in 0..<rng.length:
          let seed = rng.start + offset
          let loc = seed.translate(almanac.maps)
          if minloc < 0 or loc < minloc:
            minloc = loc
      return minloc

