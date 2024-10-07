## Not actually requred as already implemented
## as part of Nims standard library (within `math` module)
## But I will keep it here for future reference!

import std / [math, sequtils]

type
  Factor* = object
    prime*: int
    times*: int
  Factorization* = seq[Factor]

proc primes*(upto: int): seq[int] =
  result = @[]
  for number in 2..upto:
    block checkNumber:
      for i in 2..<number:
        if number mod i == 0:
          break checkNumber
      result.add number

proc mult*(factors: Factorization): int =
  factors.mapIt(it.prime ^ it.times).prod

proc factorize*(number: int): Factorization =
  let primes = primes(number)
  for prime in primes:
    if number mod prime == 0:
      block determine_times:
        for times in 1..log(number.float, prime.float).int:
          if not (number mod (prime^times) == 0):
            result.add Factor(prime: prime, times: times.pred)
            break determine_times
        result.add Factor(prime: prime, times: log(number.float, prime.float).int)


proc lcm*(numbers: seq[int]): int =
  # least common multiple
  var allFactors: Factorization = @[]
  for n in numbers:
    let factors = n.factorize
    for factor in factors:
      if factor.prime notin allFactors.mapIt(it.prime):
        allFactors.add factor
      else:
        for f in allFactors.mitems:
          if f.prime == factor.prime:
            f.times = max(f.times, factor.times)
            break
  return allFactors.mult

