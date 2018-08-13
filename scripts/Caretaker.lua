local Class = require "libs.class"
local Button = require "scripts.Button"

local Caretaker = Class{
  __includes = Button;--inherits Button class

  positionFromLeft = 0;--0.048828125 * love.graphics.getWidth();
  positionFromTop = 0;--0.06510416666666666666666666666667 * love.graphics.getHeight();

  init = function(self,x,y,id)--Constructor for class Caretaker
    self.width = 50
    self.height = 50
    self.x,self.y = self:MapToWorldPoints(x,y)

    Button.init(self,x,y,self.width,self.height,id or "caretaker1")

    self.objToFollow = nil
    self.image = love.graphics.newImage("imgs/caretaker.png")

    self.source = love.audio.newSource("Sounds/caretakerVoice"..math.random(1,3)..".wav","static")

    self.source:setLooping(true)
    self.source:setVolume(.01)
    self.source:play()

  end;

  Movement = function(self,map,dt)--It will dictate where the caretaker will go

    if(self.objToFollow) then
      local tempPosX,tempPosY = self:ReturnValidCoordinatesFunc(map,self.objToFollow)
      self.x,self.y = self:MapToWorldPoints(tempPosX,tempPosY)

      table.remove(self.objToFollow.spawnedObjects,1)
    end

    if(not self:WaitState()) then--it slowly removes the puke
        table.remove(self.objToFollow.spawnedObjects,1)
    end



  end;

  ReturnValidCoordinatesFunc = function(self,map,obj)
    local posTable = {}

    posTable[1] = {x=obj.x-self.width,y=obj.y}--Left
    posTable[2] = {x=obj.x+obj.width,y=obj.y}--Right
    posTable[3] = {x=obj.x,y=obj.y-self.height}--Up
    posTable[4] = {x=obj.x,y=obj.y+obj.height}--Down

    local pos
    local randValue
    repeat
      randValue = math.random(1,4)--Generates random number
      local mapX,mapY = self:WorldToMapPoints(posTable[randValue].x,posTable[randValue].y)

      pos = true
      --if(#map>mapY) then--The position that the caretaker will be placed
      --  if(#map[mapY]>mapX) then -- if it is within the map
      --    pos = true
        --end
      --end
    until(pos)



    return self:WorldToMapPoints(posTable[randValue].x,posTable[randValue].y)
  end;

  WaitState = function(self)
      if(not self.waitTimer or self.waitTimer<=0) then
        return true
      else
        --print("Waiting: "..self.waitTimer)
        --print("")
        --self.waitTimer = self.waitTimer - dt
        return false
      end
  end;

  WaitUpdate = function(self,dt)
    if(self.waitTimer) then
      self.waitTimer = self.waitTimer - dt
    end
  end;

  SetWaitTimer = function(self,timeInSeconds)
    self.waitTimer = timeInSeconds
  end;

  MapToWorldPoints = function(self,x,y)--returns a coordinates so we can draw babys
    return x*self.width+self.positionFromLeft,y*self.height+self.positionFromTop
  end;

  WorldToMapPoints = function(self,x,y)--returns world pixel to map points
    if((x-self.positionFromLeft)/self.width<1) then--if by returning to normal number gives us a
      --number less than one that means that that number was small to begin without
      --so return it
      --print("hey ---------------------------CCCCC")
      return math.floor(x),math.floor(y)
    end
    return math.floor((x-self.positionFromLeft)/self.width),math.floor((y-self.positionFromTop)/self.height)
  end;

  ButtonSelect = function(self,objs)
    if(self:WaitState()) then --wait if needed
      if(self.clicked) then--Checks when the caretaker is clicked
        for i,v in ipairs(objs) do
          if(v:IsButtonClicked()) then
            self.objToFollow = v --Follows new baby
            self.objToFollow:SetWaitTimer(5)--set it to wait 10 seconds
            self:SetWaitTimer(5)

            self:Unclick()
            v:Unclick()
          end
        end
      end
    end
  end;
}

return Caretaker
