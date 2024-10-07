import std / [strutils, sequtils, sugar]

type Direction* = enum
  North East South West

proc opposite(dir: Direction): Direction =
  ((dir.ord + 2) mod Direction.toSeq.len).Direction



type Position* = tuple
  row, col: int

proc `+`(p1, p2: Position): Position =
  (row: p1.row + p2.row, col: p1.col + p2.col)
proc `+=`(p1: var Position; p2: Position) =
  p1 = p1 + p2

proc toRelPos(dir: Direction): Position =
  case dir:
    of North: (row: -1, col:  0)
    of East:  (row:  0, col:  1)
    of South: (row:  1, col:  0)
    of West:  (row:  0, col: -1)



type Tile* = enum
  Ground = "."
  Animal = "S"
  VerticalPipe = "|"
  HorizontalPipe = "-"
  NorthEastBend = "L"
  NorthWestBend = "J"
  SouthEastBend = "F"
  SouthWestBend = "7"

proc connecting(tile: Tile): seq[Direction] =
  case tile:
    of Ground:          @[]
    of Animal:          @[]
    of VerticalPipe:    @[North, South]
    of HorizontalPipe:  @[East, West]
    of NorthEastBend:   @[North, East]
    of NorthWestBend:   @[North, West]
    of SouthEastBend:   @[South, East]
    of SouthWestBend:   @[South, West]



type PipeField* = object
  field: seq[seq[Tile]]
  animal: Position

proc `[]`(ps: PipeField; pos: Position): Tile =
  ps.field[pos.row][pos.col]

proc `[]=`(ps: var PipeField; pos: Position, tile: Tile) =
  ps.field[pos.row][pos.col] = tile


proc replaceAnimal(pf: var PipeField) =
  proc findAnimal(pf: PipeField): Position =
    for row, line in pf.field:
      for col, tile in line:
        if tile == Animal:
          return (row, col)
  pf.animal = pf.findAnimal
  var possibleDirs: seq[Direction] = @[]
  for dir in Direction:
    let npos = pf.animal + dir.toRelPos
    let counterDir = dir.opposite
    if counterDir in pf[npos].connecting:
      possibleDirs.add dir
  for tile in Tile:
    if possibleDirs.allIt(it in tile.connecting):
      pf[pf.animal] = tile
      return

proc addPadding(pf: var PipeField) =
  let linelen = pf.field[0].len
  pf.field.insert(newSeqWith(linelen, Ground), 0)
  pf.field.add(newSeqWith(linelen, Ground))
  for line in pf.field.mitems:
    line.insert(Ground, 0)
    line.add(Ground)

proc parsePipeField*(filename: string): PipeField =
  let data = filename.readFile.strip.splitLines.mapIt(it.toSeq)
  result.field = collect:
    for line in data:
      line.map(c => parseEnum[Tile]($c))
  result.addPadding()
  result.replaceAnimal()



type Walker* = object
  pos*: Position
  facing*: Direction
  steps*: int

proc walk(walker: var Walker; dir: Direction) =
  walker.pos += dir.toRelPos
  walker.facing = dir
  walker.steps.inc

proc next(walker: Walker; pf: PipeField): Direction =
  let tile = pf[walker.pos]
  for dir in tile.connecting:
    if dir != walker.facing.opposite:
      return dir

proc walkNext(walker: var Walker; pf: PipeField) =
  walker.walk(walker.next(pf))

proc findFarthest*(pf: PipeField): int =
  var walker = Walker(pos: pf.animal, steps: 0)
  let startDir = pf[pf.animal].connecting[0]

  walker.walk(startDir)
  while walker.pos != pf.animal:
    walker.walkNext(pf)
  return walker.steps div 2
