local class = require 'middleclass'
local HC = require 'HC'
local vector = require 'vector'
local PlayerController = class('PlayerController')

function PlayerController:initialize(player, shotInterval, up, down, left, right, shoot)
  self.player = player
  self.shotInterval = shotInterval
  self.shotClock = love.timer.getTime()
  self.up = up
  self.down = down
  self.left = left
  self.right = right
  self.shoot = shoot
end

function PlayerController:update(dt)
  --shooting
  if love.keyboard.isDown(self.shoot) and love.keyboard.isDown(self.up, self.down, self.left, self.right) and love.timer.getTime() - self.shotClock > self.shotInterval then
    shotVec = vector(0, 0)
    if love.keyboard.isDown(self.left) then
      shotVec.x = -1
    elseif love.keyboard.isDown(self.right) then
      shotVec.x = 1
    end
    if love.keyboard.isDown(self.up) then
      shotVec.y = -1
    elseif love.keyboard.isDown(self.down) then
      shotVec.y = 1
    end
      shotVec = shotVec:normalized()
      self.player:shoot(shotVec)
      self.shotClock = love.timer.getTime()
  end

  --moving
  if love.keyboard.isDown(self.up, self.down, self.left, self.right) and not love.keyboard.isDown(self.shoot) then
    moveVec = vector(0, 0)
    if love.keyboard.isDown(self.left) then
      moveVec.x = -1
    elseif love.keyboard.isDown(self.right) then
      moveVec.x = 1
    end
    if love.keyboard.isDown(self.up) then
      moveVec.y = -1
    elseif love.keyboard.isDown(self.down) then
      moveVec.y = 1
    end
    moveVec = moveVec:normalized()
    self.player:move(moveVec, dt)
  end
end

return PlayerController
