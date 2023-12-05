import glob

var sum = 0
for line in input.lines:
  let game = line.parseGame
  
  sum += game.power

echo sum
