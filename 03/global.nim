import strutils, sequtils, strformat

const
  input* = "input"

type
  Scheme* = seq[string]
  Position* = tuple
    row, col: int

proc dim*(scheme: Scheme): Position =
  (row: scheme.len, col: scheme[0].len)

proc `[]`*(scheme: Scheme; pos: Position): char =
  scheme[pos.row][pos.col]

proc numLen*(scheme: Scheme; spos: Position): Natural =
  var pos = spos
  while pos.col < scheme.dim.col and scheme[pos].isDigit:
    pos.col.inc
  return pos.col - spos.col

proc readNumber*(scheme: Scheme; spos: Position): Natural =
  let n = scheme.numLen(spos)
  return parseInt(scheme[spos.row][spos.col..<(spos.col + n)])

proc readINumber*(scheme: Scheme; ipos: Position): Natural =
  var spos = ipos
  while true:
    let pos: Position = (spos.row, spos.col - 1)
    if pos.col < 0 or not scheme[pos].isDigit:
      break
    spos = pos
  return scheme.readNumber(spos)

proc isPartNumber*(scheme: Scheme; spos: Position): bool =
  let
    dim = scheme.dim
    n = scheme.numLen(spos)
  for row in max(0, spos.row - 1)..min(dim.row - 1, spos.row + 1):
    for col in max(0, spos.col - 1)..min(dim.col - 1, spos.col + n):
      if scheme[(row, col)] notin "0123456789.":
        return true
  return false

proc isNumber*(scheme: Scheme; spos: Position): bool =
  scheme[spos].isDigit

proc isGear*(scheme: Scheme; spos: Position): bool =
  if scheme[spos] != '*':
    return false

  var
    sameNumber = false
    adjNumCnt = 0
  
  for row in max(0, spos.row - 1)..min(scheme.dim.row-1, spos.row + 1):
    for col in max(0, spos.col - 1)..min(scheme.dim.col-1, spos.col + 1):
      let pos = (row, col)
      if scheme.isNumber pos:
        if not sameNumber:
          adjNumCnt.inc
          sameNumber = true
      else:
        sameNumber = false
    sameNumber = false
  return adjNumCnt == 2


proc gearRatio*(scheme: Scheme; spos: Position): int =
  if not scheme.isGear spos:
    return 0

  var
    sameNumber = false
    adjNumCnt = 0
  result = 1
  
  for row in max(0, spos.row - 1)..min(scheme.dim.row-1, spos.row + 1):
    for col in max(0, spos.col - 1)..min(scheme.dim.col-1, spos.col + 1):
      let pos = (row, col)
      if scheme.isNumber pos:
        if not sameNumber:
          adjNumCnt.inc
          sameNumber = true
          result *= scheme.readINumber pos
      else:
        sameNumber = false
    sameNumber = false

