local class = require 'middleclass'
local HC = require 'HC'
local Bullet = require 'bullet'
local vector = require 'vector'
local Player = class('Player')

function Player:initialize(x, y, r, g, b, playerTag, bulletArray, shootSound)
  self.width = squareWidth * 0.75
  self.height = squareWidth * 0.75
  self.tag = playerTag --so the player can tag their own bullets so we know who bullets belong to
  self.shape = HC.rectangle(x - self.width * 0.5 , y - self.height * 0.5 , self.width, self.height)
  self.shape.tag = self.tag
  self.shape.container = self
  self.r = r
  self.g = g
  self.b = b
  self.bullets = bulletArray
  self.speed = 200
  self.health = maxHealth
  self.shootSound = shootSound
end

function Player:getShape()
  return self.shape
end

function Player:move(moveVec, dt)
  self.shape:move(moveVec.x * self.speed * dt, moveVec.y * self.speed * dt)
end

function Player:shoot(direction)
  self.shootSound:play()
  drawX, drawY = self.shape:center()
  table.insert(self.bullets, Bullet:new(drawX, drawY, direction, self.tag))
end

function Player:draw()
  if self.health < 0 then self.health = 0 end
  if self.health > maxHealth then self.health = maxHealth end
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

return Player
