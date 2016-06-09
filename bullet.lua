local class = require 'middleclass'
local HC = require 'HC'
local vector = require 'vector'
local Bullet = class('Bullet')

function Bullet:initialize(x, y, direction, playerTag)
  self.width = 10
  self.height = 10
  self.shape = HC.point(x, y)
  self.r = 0
  self.g = 255
  self.b = 0
  self.speed = 1000
  self.direction = direction
  self.tag = "bullet" .. playerTag
  self.shape.tag = self.tag 
  self.shape.container = self
end

function Bullet:getShape()
  return self.shape
end

function Bullet:update(dt)
  self.shape:move(self.direction.x * self.speed * dt, self.direction.y * self.speed * dt)
end

function Bullet:draw()
  drawX, drawY = self.shape:center()
  drawX = drawX - self.width * 0.5
  drawY = drawY - self.height * 0.5
  love.graphics.setColor(self.r, self.g, self.b, 255)
  love.graphics.rectangle("fill", drawX, drawY, self.width, self.width)
end

return Bullet
