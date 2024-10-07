import std / [strformat, strutils, sequtils, sugar, os]
import math

const input* = "input"

type
  Direction* = enum
    Left = "L", Right = "R"
  Kids* = array[Direction, Node]
  Node* = ref object
    name*: string
    kids*: Kids
  NetworkKind* = enum
    Single Parallel
  Network* = object
    pattern*: seq[Direction]
    case kind: NetworkKind:
      of Single:
        first*: Node
      of Parallel:
        firsts*: seq[Node]

converter toDirection*(c: char): Direction = 
  parseEnum[Direction]($c)

proc `$`*(node: Node): string =
  fmt"{node.name} = ({node.kids[Left].name}, {node.kids[Right].name})"

proc `$`*(nodes: seq[Node]): string =
  nodes.mapIt($it).join("\n")

proc find*(nodes: seq[Node]; name: string): Node =
  for node in nodes:
    if node.name == name:
      return node
  raise newException(ValueError, fmt"ERROR: no node with name: '{name}'")

proc findEndsIn*(nodes: seq[Node]; last: char): seq[Node] =
  for node in nodes:
    if node.name.endsWith(last):
      result.add node


proc parseNetwork*(filename: string; kind = Single): Network =
  result = Network(kind: kind)

  let file = filename.readFile.strip.splitLines
  result.pattern = file[0].toSeq.map(toDirection)

  let data = file[2..^1].map(s => s.split('=').mapIt(it.strip))

  let nodes = data.mapIt(Node(name: it[0]))
  case kind:
    of Single:   result.first = nodes.find("AAA")
    of Parallel: result.firsts = nodes.findEndsIn('A')

  for i, line in data:
    let currNode = nodes[i]
    let kids = line[1].strip(chars = {'(', ')'}).split(',').mapIt(it.strip)
    for i, kid in kids:
      currNode.kids[i.Direction] = nodes.find(kid)


proc countSteps*(network: Network): int =
  result = 0
  var patternIdx = -1

  if network.kind == Single:
    var node = network.first

    while node.name != "ZZZ":
      patternIdx = patternIdx.succ mod network.pattern.len
      let dir = network.pattern[patternIdx]

      node = node.kids[dir]
      result.inc
  elif network.kind == Parallel:
    # CREEPY SOLUTION! 
    # actually quite elegant in the end (using `least common multiple`)
    # but we use knowlege, we didn't get from the instructions (clean/equidistant periods)!
    # The iterative solution took too long though!
    var
      nodes = network.firsts
      periods = newSeq[int](nodes.len)
      cnt = 0

    while any(periods, x => x == 0):
      patternIdx = patternIdx.succ mod network.pattern.len
      let dir = network.pattern[patternIdx]
      
      cnt.inc
      for i, node in nodes.mpairs:
        node = node.kids[dir]
        if node.name.endsWith('Z') and periods[i] == 0:
          periods[i] = cnt

    return periods.lcm
