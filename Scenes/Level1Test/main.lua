local level1Test = {}
local Baby = require "scripts.baby"

function level1Test:enter(prev,a,b)
  self.ab = b
  self.t = 0
  self.dt = 0

  self.testObj = Baby(600,50)

  self.Grid = require("libs.grid")
  self.PathFinder = require("libs.pathfinder")

  self.map = {}
  local i = 0
  for line in love.filesystem.lines("Scenes/Level1Test/maps/a.txt") do
    i = i + 1
    table.insert(self.map,{})
    print(type(self.map))
    print(type(self.map[i]))
    for char in line:gmatch"." do
      table.insert(self.map[i],char)
    end
  end

  local dar = ""
  print(type(self.map))
  for i,v in ipairs(self.map) do
    i = i + 1
    print(type(v))

    for k,l in ipairs(v) do
      print("goo"..type(l))
      dar = dar.." "..l
    end
    print(dar)

    dar=""
  end


print(self.map[1])

for i,k in ipairs(self.map) do
  for l,m in ipairs(k) do
    print(m)
  end
  print()
end

print(type(self.map).." "..type(self.map[1]))

  self.walkable="0"--The error was that the data was written in string and not as number
  self.grid = self.Grid(self.map)
  self.myFinder = self.PathFinder(self.grid,'JPS',self.walkable)

  local startx,starty =1,1
  local endx,endy = 5,1

  self.path,self.pathLen = self.myFinder:getPath(startx,starty,endx,endy)
  print(self.path)
  print(#self.map[1])

end

function level1Test:draw()
  love.graphics.print(self.ab,100,100)
  local a = 1
  for line in love.filesystem.lines("Scenes/Level1Test/maps/a.txt") do
    love.graphics.setColor(255,255,255)
    love.graphics.print(line,a,10*a)
    a = a + 1
  end
  for i,v in ipairs(self.map) do
    for k,l in ipairs(v) do
      love.graphics.setColor(255,255,255)
      love.graphics.print(l,i*30,k*30)
    end
  end





  for i=1,10 do
    for k=1,10 do
      love.graphics.setColor((0.2*i)/(2)/self.t,(0.3*i*k)/30*self.t,(0.4*k)/4/self.t)

      love.graphics.rectangle("line", i*50, k*50, 50,50)
    end
  end

  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("line",self.testObj.x,self.testObj.y,50,50)

  for i,v in ipairs(self.testObj.spawnedObjects) do
    love.graphics.setColor(v.rgba)
    love.graphics.rectangle("fill", v.x,v.y,v.width,v.height)

  end

  if self.path then
    print(('Path from [%d,%d] to [%d,%d] found! Length: %.2f')
  	:format(1, 1,5,1, self.pathLen))
    for node, count in self.path:iter() do--Now works the path finding stuff
  	  print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
  	end
  else
    print("noo")
  end

end



function level1Test:update(dt)

  self.dt = self.dt + dt


  if self.dt >= 0.2 then
    self.testObj:Behavior()
    self.t = self.t + 0.01
    self.dt = 0
  end

  if self.t >=1 then
    self.t = 0.01
  end

end

return level1Test