local class = require 'middleclass'
local HC = require 'HC'
local Map = class('Map')

function Map:initialize(tiles) 
  self.tiles = tiles
  self.shapes = {}
  self.count = 0
  for i,v in pairs(self.tiles) do
    for j,w in pairs(v) do
      if w == 1 then
        shape = HC.rectangle((love.graphics.getWidth() / table.getn(self.tiles[1])) * (j - 1), (love.graphics.getHeight() / table.getn(self.tiles)) * (i - 1), love.graphics.getWidth() / table.getn(self.tiles[1]), love.graphics.getHeight() / table.getn(self.tiles))
        shape.tag = "wall"
        table.insert(self.shapes, shape)
      end
    end
  end
end

function Map:getCount()
  return self.count
end

function Map:toString()
  outString = ''
  for i,v in ipairs(self.tiles) do
    for j,w in ipairs(v) do
      outString = outString .. w .. ' '
    end
    outString = outString .. "\n"
  end
  return outString
end

function Map:draw()
  love.graphics.setColor(0, 200, 1, 255)
  for i,v in ipairs(self.tiles) do
    for j,w in ipairs(v) do
      if w == 1 then
        love.graphics.rectangle("fill", (love.graphics.getWidth() / table.getn(self.tiles[1])) * (j - 1), (love.graphics.getHeight() / table.getn(self.tiles)) * (i - 1), love.graphics.getWidth() / table.getn(self.tiles[1]), love.graphics.getHeight() / table.getn(self.tiles))
      end
    end
  end
end

return Map
