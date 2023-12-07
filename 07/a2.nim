import std / [strutils, sequtils, tables, algorithm]

const input = "input"

type
  Player = object
    hand: string
    bid: int
  Party = seq[Player]
  Card = enum
    joker = (1, "J"),
    two = (2, "2"),
    three = (3, "3"),
    four = (4, "4"),
    five = (5, "5"),
    six = (6, "6"),
    seven = (7, "7"),
    eight = (8, "8"),
    nine = (9, "9"),
    ten = (10, "T"),
    queen = (11, "Q"),
    king = (12, "K"),
    ass = (13, "A")
  HandType = enum
    high_card one_pair two_pair three_of_a_kind full_house four_of_a_kind five_of_a_kind

proc parsePlayer(line: string): Player =
  let line = line.split
  Player(
    hand: line[0],
    bid: line[1].parseInt
  )

proc getHandType(hand: string): HandType =
  var
    nJokers = 0
    countTable = hand.toCountTable
  discard countTable.pop('J', nJokers)
  let counts = countTable.values.toSeq.sorted(Descending)

  if nJokers == 5:
    return five_of_a_kind

  case counts[0] + nJokers:
    of 5:
      return five_of_a_kind
    of 4:
      return four_of_a_kind
    of 3:
      if counts[1] == 2:
        return full_house
      else:
        return three_of_a_kind
    of 2:
      if counts[1] == 2:
        return two_pair
      else:
        return one_pair
    else:
      return high_card


proc playercmp(player1, player2: Player): int =
  # hand1 (<|=|>) hand2  -> (-1|0|1)
  let handType1 = player1.hand.getHandType
  let handType2 = player2.hand.getHandType
  if handType1.ord < handType2.ord:
    return -1
  elif handType1.ord > handType2.ord:
    return 1
  else: # handType1 == handType2
    for i in 0..<player1.hand.len:
      let card1 = parseEnum[Card]($player1.hand[i])
      let card2 = parseEnum[Card]($player2.hand[i])
      if card1 == card2:
        continue
      elif card1 < card2:
        return -1
      elif card1 > card2:
        return 1
    return 0

proc rank(party: Party): Party =
  party.sorted(playercmp)


let party: Party = input.readFile.strip.splitLines.map parsePlayer
let rankedParty = party.rank

var total_win = 0
for i, player in rankedParty:
  total_win += player.bid * (i+1)

echo total_win
