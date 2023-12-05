import glob

var sum = 0
for line in input.lines:
  let game = line.parseGame
  
  if game.samples.max <= limit:
    sum += game.id

echo sum
