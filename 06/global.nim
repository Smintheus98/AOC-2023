import std / [strutils, sequtils, math]

const input* = "input"

type
  Race* = object
    time*: int
    recordDist*: int
  Tournament* = object
    races*: seq[Race]
  SingleRace* = Race

proc countRecordBreaker*(race: Race): int =
  result = 0
  for hold in 0..<race.time:
    if hold * (race.time - hold) > race.recordDist:
      result.inc

proc parseTournament*(file: string): Tournament =
  let data = file.readFile.strip.splitLines.mapIt(it.splitWhitespace)
  for col in 1..<data[0].len:
    result.races.add Race(time: data[0][col].parseInt, recordDist: data[1][col].parseInt)

proc recordBreakerKombos*(tournament: Tournament): int =
  result = 1
  for race in tournament.races:
    result *= race.countRecordBreaker

proc toSingleRace*(tournament: Tournament): SingleRace =
  result = SingleRace(time: 0, recordDist: 0)
  for race in tournament.races:
    result.time *= 10 ^ ( log(race.time.float, 10.0).int + 1 )
    result.time += race.time
    result.recordDist *= 10 ^ ( log(race.recordDist.float, 10.0).int + 1 )
    result.recordDist += race.recordDist

