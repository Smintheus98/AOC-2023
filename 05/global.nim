import std / [strutils, sequtils]

const input* = "example"

type
  Translation* = object
    destStart*: int
    srcStart*: int
    rangeLen*: int
  TranslationMap* = seq[Translation]
  Almanac* = object
    seeds*: seq[int]
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

proc parseAlmanac*(file: string): Almanac =
  let data = file.readFile.splitLines
  result.seeds = data[0].split(':')[1].strip.split.map parseInt
  
  var sIdx, eIdx: int 
  for i, line in data[1..^1]:
    if line == "":
      eIdx = i.pred
      if sIdx > 0:
        result.maps.add data[sIdx..eIdx].parseTranslationMap
      sIdx = i.succ


