import std / [strutils, sequtils, sugar]

type
  TimeSeries* = seq[int]
  ForecastDirection* = enum
    Future Past

proc parseTimeSeries*(line: string): TimeSeries =
  line.split.map parseInt

proc allZero(ts: TimeSeries): bool =
  ts.all(x => x == 0)

proc diff(ts: TimeSeries): TimeSeries =
  result = collect:
    for i in 0..<ts.high:
      ts[i.succ] - ts[i]

proc undiff(ts, diff: TimeSeries; direction = Future): TimeSeries =
  assert ts.len > 0
  result = ts
  if diff.len == 0:
    result.add result[^1]
  elif ts.len == diff.len:
    case direction:
      of Future: result.add ts[^1] + diff[^1]
      of Past:   result.insert(ts[0] - diff[0], 0)

proc forecast*(ts: TimeSeries; direction = Future): int =
  var diffs = @[ts]
  while not diffs[^1].allZero:
    diffs.add diffs[^1].diff
  diffs.add @[]

  for i in countDown(diffs.high, 1):
    diffs[i-1] = undiff(diffs[i-1], diffs[i], direction)

  case direction:
    of Future: return diffs[0][^1]
    of Past:   return diffs[0][0]
