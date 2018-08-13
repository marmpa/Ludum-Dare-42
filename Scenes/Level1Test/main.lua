local level1Test = {}
local Baby = require "scripts.baby"
local Caretaker = require "scripts.Caretaker"

function level1Test:enter(prev,difficulty)
  self.t = 0
  self.dt = 0
  love.graphics.setBackgroundColor(0,0,0)


  self.font = love.graphics.newFont(14)--sets the font
  love.graphics.setFont(self.font)

  self.points = 0
  self.maxPoints = 1000 * difficulty
  self.babyCounter = 2

  self.isPaused = false

  self.varNeedToSpawnDChild = 2--How often to spawn demon childs
  self.varNeedToSpawnCaretaker = 5

  self.image = love.graphics.newImage("imgs/room.png")

  self:LoadMap()

  self.babys = {}
  table.insert(self.babys,Baby(2,2,self.map))
  table.insert(self.babys,Baby(3,2,self.map,"00x2"))

  self.caretaker = {}

  table.insert(self.caretaker,Caretaker(1,1,"caretaker1"))
end

function level1Test:LoadMap()--Loads the map data so that babys can move
  self.map = {}
  local i = 0
  for line in love.filesystem.lines("Scenes/Level1Test/maps/a.txt") do
    i = i + 1
    table.insert(self.map,{})
    --print(type(self.map))
    --print(type(self.map[i]))
    for char in line:gmatch"." do
      table.insert(self.map[i],char)
    end
  end
end

function level1Test:draw()
  --Drawing grid

  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.image,love.graphics.getWidth()*0.048828125,love.graphics.getHeight()*0.06510416666666666666666666666667)
  --Above draws image on scene
  for i=1,10 do
    for k=1,10 do
      --love.graphics.setColor((0.2*i)/(2)/self.t,(0.3*i*k)/30*self.t,(0.4*k)/4/self.t)

      --love.graphics.rectangle("line", i*50, k*50, 50,50)
    end
  end

  for i,v in ipairs(self.babys) do
    for k,l in ipairs(v.spawnedObjects) do
      love.graphics.setColor(l.rgba)
      love.graphics.rectangle("fill",l.x,l.y,l.width,l.height)
    end

    --Draw babys
    love.graphics.setColor(255,255,255)

    if(#v.spawnedObjects>=2) then
      love.graphics.setColor(.5,.5,.5)
    elseif(#v.spawnedObjects>=4) then
      love.graphics.setColor(.1,.1,.1)
    else
      love.graphics.setColor(255,255,255)
    end
    --love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
    love.graphics.draw(v.image, v.x, v.y)--draws baby
    if(v:IsButtonClicked()) then
      love.graphics.print(v.id,love.graphics.getWidth()*.8,love.graphics.getHeight()*.5)
    end
    --..........

  end

  for i,v in ipairs(self.caretaker) do
    --print("drawing caretaker",v.x,v.y,v.width,v.height)
    if(not v:WaitState()) then--changes the color so one can see who to click
      love.graphics.setColor(.5,.5,.5)
    else

      love.graphics.setColor(1,1,1)
    end


    --love.graphics.rectangle("fill", v.x,v.y,v.width,v.height)
    love.graphics.draw(v.image,v.x,v.y)
    if(v:IsButtonClicked()) then
      love.graphics.print(v.id,love.graphics.getWidth()*.8,love.graphics.getHeight()*.6)
    end

    if(not v:WaitState()) then
      love.graphics.print(v.id,love.graphics.getWidth()*.8,love.graphics.getHeight()*.5)
    end
  end

  love.graphics.print("Current points:"..self.points,love.graphics.getWidth()*.6,love.graphics.getHeight()*.1)--prints current points
  love.graphics.print("Point Maximum:"..self.maxPoints,love.graphics.getWidth()*.6,love.graphics.getHeight()*.2)--prints points need to loose





end



function level1Test:update(dt)

  --self.testObj:WaitUpdate(dt)
  --self.testObj:ButtonUpdate(self.testObj)

  --Update baby
  for i,v in ipairs(self.babys) do
    v:WaitUpdate(dt)
    v:ButtonUpdate(v)


  end
  --..........

  for i,v in ipairs(self.caretaker) do
    v:WaitUpdate(dt)
    v:ButtonUpdate(v)

    v:ButtonSelect(self.babys)--checks to follow baby
  end






  self.dt = self.dt + dt

  self.varNeedToSpawnDChild = 2
  self.varNeedToSpawnCaretaker = 5

  if self.dt >= 1 then

    for i,v in ipairs(self.babys) do
      if(v.spawnedObjects) then--if there is to much puke then make it into baby
        if(#v.spawnedObjects>=self.varNeedToSpawnDChild) then
          local removedObj = table.remove(v.spawnedObjects,1)

          table.insert(self.babys,Baby(removedObj.x,removedObj.y,self.map,"00x"..#self.babys+1))

          for k,l in ipairs(v.spawnedObjects) do
            table.remove(v.spawnedObjects,1)
          end

          self.babyCounter = self.babyCounter + 1
          self.varNeedToSpawnDChild = self.varNeedToSpawnDChild + 1--it raises how often the child will be born
        end
      end
    end

    if(self.babyCounter>=self.varNeedToSpawnCaretaker) then
      self.babyCounter = 0
      table.insert(self.caretaker,Caretaker(math.random(1,3),1,"caretaker"..#self.caretaker))
    end





    --self.testObj:Behavior(self.map,dt)

    --Baby behavior
    for i,v in ipairs(self.babys) do
      v:Behavior(self.map,dt)

      for k,l in ipairs(v.spawnedObjects) do--add points
        self.points = self.points + 1
      end
    end
    --..........

    for i,v in ipairs(self.caretaker) do--Updates caretakers
      v:Movement(self.map,dt,self.babys[1])
    end

    self.t = self.t + 0.01
    self.dt = 0

    self.maxPoints = self.maxPoints + 1
  end

  if self.t >=1 then
    self.t = 0.01
  end

  if (self.points > self.maxPoints) then--if one loses
    Gamestate.switch(scenes.scene2,self.points)
  end

end

function level1Test:mousepressed(x, y, button, istouch, presses )
  if(button == 1) then

    --Update baby
    for i,v in ipairs(self.babys) do
      v:ButtonClicked(x,y,self.babys)
    end
    --..........

    for i,v in ipairs(self.caretaker) do
      v:ButtonClicked(x,y,self.caretaker)

    end
  end

end

function level1Test:keypressed(key)
  if(key=="m" and not self.isPaused) then--Pauses and unpause audio
    self.isPaused = not self.isPaused
    love.audio.pause()
  elseif(key == "m" and self.isPaused) then
    self.isPaused = not self.isPaused
    for i,v in ipairs(self.babys) do
      love.audio.play(v.source)
    end
    for i,v in ipairs(self.caretaker) do
      love.audio.play(v.source)
    end
  end
end

return level1Test
