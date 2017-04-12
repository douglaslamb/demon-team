local class = require 'middleclass'
local vector = require 'vector'
local HC = require 'HC'
local Map = require 'map'
local Player = require 'player'
local Demon = require 'demon'
local PlayerController = require 'playerController'

function init()
  love.graphics.setFont(love.graphics.newFont(20))
  love.window.setMode(800, 800)

  loseHealthInterval = 5
  loseHealthAmt = 10
  loseHealthTimer = love.timer.getTime() + loseHealthInterval
  boardSize = 16
  squareWidth = love.graphics.getWidth() / boardSize
  maxHealth = 100
  medKitAmt = 10
  bulletDamageAmt = 10
  demonDamageAmt = 1
  screenEdgeSize = 10
  HC.resetHash()

  playerOneColor = 40
  playerTwoColor = 230 
  demonRGB = {200, 190, 1}
  backgroundRGB = {255, 200, 234}
  wallRGB = {255, 200, 1}

  winText = ""
  gameOver = false
  demonArray = {}
  healthArray = {}
  local demonAmt = 35

  leftScreenEdge = HC.rectangle(-1 * screenEdgeSize, 0, screenEdgeSize, love.graphics.getHeight())
  leftScreenEdge.tag = "edge"
  rightScreenEdge = HC.rectangle(love.graphics.getWidth(), 0, screenEdgeSize, love.graphics.getHeight())
  rightScreenEdge.tag = "edge"
  topScreenEdge = HC.rectangle(0, -1 * screenEdgeSize, love.graphics.getWidth(), screenEdgeSize)
  topScreenEdge.tag = "edge"
  bottomScreenEdge = HC.rectangle(0, love.graphics.getHeight(), love.graphics.getWidth(), screenEdgeSize)
  bottomScreenEdge.tag = "edge"

  --init sounds
  demonGotHitSound  = love.audio.newSource("assets/audio/demonHit.wav", "static")
  demonRoamOne  = love.audio.newSource("assets/audio/demonRoam1.wav", "static")
  demonRoamOne:setVolume(0.4)
  demonRoamTwo  = love.audio.newSource("assets/audio/demonRoam2.wav", "static")
  demonRoamTwo:setVolume(0.4)
  demonRoamThree  = love.audio.newSource("assets/audio/demonRoam3.wav", "static")
  demonRoamThree:setVolume(0.4)
  demonRoamSounds = {demonRoamOne, demonRoamTwo, demonRoamThree}
  demonDieSound = love.audio.newSource("assets/audio/demonDie.wav", "static")
  demonDieSound:setVolume(0.4)
  playerShootSound = love.audio.newSource("assets/audio/playerShoot.wav", "static")
  playerShootSound:setVolume(0.5)
  playerGotHurtSound = love.audio.newSource("assets/audio/playerHurt.wav", "static")
  getHealthSound = love.audio.newSource("assets/audio/getHealth.wav", "static")
  getHealthSound:setVolume(0.3)

  --create map

  bulletArray = {}

  local tileArray = createMapArray()
  while (not isArrayContiguous(tileArray)) do
    tileArray = createMapArray()
  end

  --fill map array with players
  local playerOneI = love.math.random(1, boardSize)
  local playerOneJ = love.math.random(1, boardSize)
  while tileArray[playerOneI][playerOneJ] ~= 0 do
    playerOneI = love.math.random(1, boardSize)
    playerOneJ = love.math.random(1, boardSize)
  end
  local playerOneNumber = love.math.random(2, 3)
  local playerTwoNumber = 5 - playerOneNumber
  tileArray[playerOneI][playerOneJ] = playerOneNumber
  --2 means playerOne, 3 means playerTwo , 4 means demon
  if playerOneJ ~= 1 and tileArray[playerOneI][playerOneJ - 1] == 0 then
    tileArray[playerOneI][playerOneJ - 1] = playerTwoNumber
  elseif playerOneJ ~= boardSize and tileArray[playerOneI][playerOneJ + 1] == 0 then
    tileArray[playerOneI][playerOneJ - 1] = playerTwoNumber
  elseif playerOneI ~= 1 and tileArray[playerOneI - 1][playerOneJ] == 0 then
    tileArray[playerOneI][playerOneJ - 1] = playerTwoNumber
  elseif playerOneI ~= boardSize and tileArray[playerOneI + 1][playerOneJ] == 0 then
    tileArray[playerOneI][playerOneJ - 1] = playerTwoNumber
  end 

  --fill map array w demons

  for i=1, demonAmt do
    demonI = love.math.random(1, boardSize)
    demonJ = love.math.random(1, boardSize)
    while tileArray[demonI][demonJ] ~= 0 do
      demonI = love.math.random(1, boardSize)
      demonJ = love.math.random(1, boardSize)
    end
    tileArray[demonI][demonJ] = 4
  end

  --create players and demons
  
  for i, v in pairs(tileArray) do
    for j, u in pairs(tileArray[i]) do
      if u == 2 then
        playerOne = Player:new((j - 1) * squareWidth + 25, (i - 1) * squareWidth + 25, playerOneColor, playerOneColor, playerOneColor, "playerOne", bulletArray, playerShootSound)
      elseif u == 3 then
        playerTwo = Player:new((j - 1) * squareWidth + 25, (i - 1) * squareWidth + 25, playerTwoColor, playerTwoColor, playerTwoColor, "playerTwo", bulletArray, playerShootSound)
      elseif u == 4 then
        table.insert(demonArray, Demon:new((j - 1) * squareWidth + 25, (i - 1) * squareWidth + 25, demonRGB[1], demonRGB[2], demonRGB[3], playerOne, playerTwo, demonGotHitSound, demonRoamSounds[love.math.random(1, 3)], demonDieSound))
      end
    end
  end
  
  map = Map:new(tileArray)

  playerOneController = PlayerController:new(playerOne, 0.2, "w", "s", "a", "d", "v")
  playerTwoController = PlayerController:new(playerTwo, 0.2, "up", "down", "left", "right", "rshift")
  for i, v in pairs(HC:hash():shapes()) do
    if v.tag == "playerOne" and v.container == nil then
      HC.remove(v)
    elseif v.tag == "playerTwo" and v.container == nil then
      HC.remove(v)
    end
  end
end

function love.load()
  init()
end

function createMapArray()
  local tileArray = {}
  numberOfSpaces = 0
  for i=1, boardSize do
    tileArray[i] = {}
    for j=1, boardSize do
      if love.math.random(-5, 1) > 0 then
        tileArray[i][j] = 1
      else
        tileArray[i][j] = 0
      end
    end
  end
  --check array for closed spaces and close the smaller spaces
  return tileArray
end

function isArrayContiguous(inArray)
  local testArray = {}
  local startI = -1
  local startJ = -1
  for i, v in pairs(inArray) do
    testArray[i] = {}
    for j, u in pairs(inArray[i]) do
      testArray[i][j] = inArray[i][j]
    end
  end
  local function fill(i, j)
    testArray[i][j] = 1
    --look left right up down and call recursively if it's a space
    if (not (j == 1)) and testArray[i][j - 1] == 0 then
      fill(i, j - 1)
    end
    if (not (j == boardSize)) and testArray[i][j + 1] == 0 then
      fill(i, j + 1)
    end
    if (not (i == 1)) and testArray[i - 1][j] == 0 then
      fill(i - 1, j)
    end
    if (not (i == boardSize)) and testArray[i + 1][j] == 0 then
      fill(i + 1, j)
    end
  end
  for i, v in pairs(testArray) do
    for j, u in pairs(testArray[i]) do
      if testArray[i][j] == 0 then
        startI = i
        startJ = j
      end
    end
  end
  fill(startI, startJ)
  for i, v in pairs(testArray) do
    for j, u in pairs(testArray[i]) do
      if testArray[i][j] == 0 then
        return false
      end
    end
  end
  return true
end

function love.update(dt)
  if not gameOver then
    playerOneController:update(dt)
    playerTwoController:update(dt)
    for i, v in pairs(bulletArray) do
      if v.dead == true then
        bulletArray[i] = nil
      else
        v:update(dt)
      end
    end
    for i, v in pairs(healthArray) do
      if love.timer.getTime() > v.timeToLive then
        v.dead = true
      end
      if v.dead == true then
        HC.remove(v)
        healthArray[i] = nil
      end
    end
    for i, v in pairs(demonArray) do
      if v.health < 0 then 
        v.dead = true 
        v:makeDieSound()
      end
      if v.dead == true then
        local tempX, tempY = v.shape:center()
        local tempShape = HC.rectangle(tempX - 25 * 0.75, tempY - 25 * 0.75, 30, 30)
        tempShape.tag = "health"
        tempShape.timeToLive = love.timer.getTime() + 10
        function tempShape:draw()
          love.graphics.setColor(255, 255, 255, 255)
          love.graphics.rectangle("fill", tempX - 25 * 0.75, tempY - 25 * 0.75, 30, 30)
          love.graphics.setColor(255, 0, 0, 255)
          love.graphics.rectangle("fill", tempX - 12 * 0.75, tempY - 12 * 0.75, 15, 15)
        end
        table.insert(healthArray, tempShape)
        HC.remove(v.shape)
        demonArray[i] = nil
      else
        v:update(dt)
      end
    end

    handleCollisions(dt)

    if love.timer.getTime() > loseHealthTimer then
      local chance = 20
      loseHealthTimer = love.timer.getTime() + loseHealthInterval
      if love.math.random(1, 100) < chance then
        playerOne.health = playerOne.health - loseHealthAmt
      end
      if love.math.random(1, 100) < chance then
        playerTwo.health = playerOne.health - loseHealthAmt
      end
    end

    --check for gameover
    local demonAmt = 0 
    for i, v in pairs(demonArray) do
      if not (v == nil) then
        demonAmt = demonAmt + 1
      end
    end

    if playerOne.health < 1 or playerTwo.health < 1 then
      gameOver = true
      winText = "You lost. Sorry. Do you want to play again? Y/N"
    elseif demonAmt < 1 then
      gameOver = true
      winText = "You won! Do you want to play again? Y/N"
    end
  else
    for i, v in pairs(HC:hash():shapes()) do
      HC.remove(v)
    end
    HC.resetHash()
    if love.keyboard.isDown("y") then 
      init()
    elseif love.keyboard.isDown("n") then
      love.event.push('quit')
    end
  end
end

function love.draw()
  map:draw()
  love.graphics.setBackgroundColor(backgroundRGB[1], backgroundRGB[2], backgroundRGB[3])
  for i, v in pairs(healthArray) do
    v:draw()
  end
  playerOne:draw()
  playerTwo:draw()
  for i, v in pairs(demonArray) do
    v:draw()
  end
  for i, v in pairs(bulletArray) do
    v:draw()
  end
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf("Player 1: " .. playerOne.health .. "\n" .. "Player 2: " .. playerTwo.health, 0, 0, 500, 'left')
  love.graphics.printf(winText, 400, 400, 400)
  local playerOneCount = 0
  local playerTwoCount = 0
  local demonCount = 0
  for i, v in pairs(HC:hash():shapes()) do
    if v.tag == "playerOne" then
      playerOneCount = playerOneCount + 1
    elseif v.tag == "playerTwo" then
      playerTwoCount = playerTwoCount + 1
    elseif v.tag == "demon" then
      demonCount = demonCount + 1
    end
  end
end

function handleCollisions(dt)
  for shape, delta in pairs(HC.collisions(leftScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end

  for shape, delta in pairs(HC.collisions(rightScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end

  for shape, delta in pairs(HC.collisions(topScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end
  
  for shape, delta in pairs(HC.collisions(bottomScreenEdge)) do
    shape:move(-delta.x, -delta.y)
  end

  --bullets

  for i, v in pairs(bulletArray) do
    for shape, delta in pairs(HC.collisions(v.shape)) do
      if shape.tag == "wall" or shape.tag == "edge" then
        v.dead = true
        HC.remove(v.shape)
      elseif shape.tag == "demon" then
        shape.container.health = shape.container.health - 35
        shape.container.hit = true
        if not (shape.container.health < 30) then
          shape.container:makeHitSound()
        end
        v.dead = true
        HC.remove(v.shape)
      end
    end
  end

  --players

  for shape, delta in pairs(HC.collisions(playerOne:getShape())) do
    if shape.tag == "playerTwo" then
      playerOne:getShape():move(delta.x, delta.y)
      shape:move(-delta.x, -delta.y)
    end
  end

  for shape, delta in pairs(HC.collisions(playerOne:getShape())) do
    if shape.tag == "wall" then
      playerOne:getShape():move(delta.x, delta.y)
    elseif shape.tag == "health" and playerOne.health < maxHealth then
      playerOne.health = playerOne.health + medKitAmt
      getHealthSound:play()
      shape.dead = true
    elseif shape.tag == "bulletplayerTwo" then
      playerOne.health = playerOne.health - bulletDamageAmt
      playerGotHurtSound:play()
      shape.container.dead = true
      HC.remove(shape)
    end
  end

  for shape, delta in pairs(HC.collisions(playerTwo:getShape())) do
    if shape.tag == "wall" then
      playerTwo:getShape():move(delta.x, delta.y)
    elseif shape.tag == "health" and playerTwo.health < maxHealth then
      playerTwo.health = playerTwo.health + medKitAmt
      getHealthSound:play()
      shape.dead = true
    elseif shape.tag == "bulletplayerOne" then
      playerTwo.health = playerTwo.health - bulletDamageAmt
      playerGotHurtSound:play()
      shape.container.dead = true
      HC.remove(shape)
    end
  end
  
  --demons

  for i, v in pairs(demonArray) do
    for shape, delta in pairs(HC.collisions(v:getShape())) do
      if shape.tag == "playerOne" then
        v:getShape():move(delta.x, delta.y)
        shape:move(-delta.x, -delta.y)
        playerOne.health = playerOne.health - demonDamageAmt
        playerGotHurtSound:play()
      elseif shape.tag == "playerTwo" then
        v:getShape():move(delta.x, delta.y)
        shape:move(-delta.x, -delta.y)
        playerTwo.health = playerTwo.health - demonDamageAmt
        playerGotHurtSound:play()
      elseif shape.tag == "demon" then
        v:getShape():move(delta.x, delta.y)
        shape:move(-delta.x, -delta.y)
      elseif shape.tag == "wall" then
        v:getShape():move(delta.x, delta.y)
      end
    end
  end
end
