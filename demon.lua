local class = require 'middleclass'
local HC = require 'HC'
local Bullet = require 'bullet'
local vector = require 'vector'
local Demon = class('Demon')

function Demon:initialize(x, y, r, g, b, playerOne, playerTwo, gotHitSound, roamSound, dieSound)
  self.width = (love.graphics.getWidth() / 16) * 0.75
  self.height = (love.graphics.getHeight() / 16) * 0.75
  angle = love.math.random() * math.pi * 2
  dirX = math.cos(angle) 
  dirY = math.sin(angle)
  self.direction = vector(dirX, -dirY)
  self.tag = 'demon' 
  self.shape = HC.rectangle(x - self.width * 0.5 , y - self.height * 0.5 , self.width, self.height)
  self.shape.tag = self.tag
  self.shape.container = self
  self.r = r
  self.g = g
  self.b = b
  self.speed = 100
  self.health = 100
  self.playerOne = playerOne
  self.playerTwo = playerTwo
  self.hit = false
  self.sayingOuch = false
  self.gotHitSound = gotHitSound
  self.roamSound = roamSound
  self.dieSound = dieSound
end

function Demon:getShape()
  return self.shape
end

function Demon:move(moveVec, dt)
  self.shape:move(moveVec.x * self.speed * dt, moveVec.y * self.speed * dt)
end

function Demon:wander(dt)
  self:move(self.direction, dt)
end

function Demon:moveToward(x, y, dt)
  --needs implementation
end

function Demon:checkIntersect(l1p1, l1p2, l2p1, l2p2)
  local function sign(n) return n > 0 and 1 or n < 0 and -1 or 0 end
  local function checkDir(pt1, pt2, pt3) return sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
  return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

function Demon:update(dt)
  changeDir = love.math.random(0, 100)
  if changeDir < 1 then
    local angle = love.math.random() * math.pi * 2
    local x = math.cos(angle)
    local y = math.sin(angle)
    self.direction = vector(x, y)
  end
  self:wander(dt)
  makeRoamSound = love.math.random(0, 10000)
  if makeRoamSound < 1 then
    --self.roamSound:play()
  end
  if self.sayingOuch then
    self.r = self.oldR
    self.sayingOuch = false
  end
  if self.hit then
    self.oldR = self.r
    self.r = 255
    self.hit = false
    self.sayingOuch = true
  end
end

function Demon:makeHitSound()
  self.gotHitSound:play()
end

function Demon:makeDieSound()
  self.dieSound:play()
end

function Demon:draw()
  drawX, drawY = self.shape:center()
  drawX = drawX - self.width * 0.5
  drawY = drawY - self.height * 0.5
  love.graphics.setColor(self.r, self.g, self.b, 255)
  love.graphics.rectangle("fill", drawX, drawY, self.width, self.width)

  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.rectangle("fill", drawX + self.width * .125, drawY + self.height * .125, self.width * 0.25, self.width * 0.25)
  love.graphics.rectangle("fill", drawX + self.width * .625, drawY + self.height * .125, self.width * 0.25, self.width * 0.25)
  love.graphics.rectangle("fill", drawX + self.width * .125, drawY + self.height * .7, self.width * 0.75, self.height * 0.125)
end

return Demon
