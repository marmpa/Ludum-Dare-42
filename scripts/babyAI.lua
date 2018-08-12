local Class = require "libs.class"
local Grid = require("libs.grid")
local PathFinder = require("libs.pathfinder")

--Handles Baby Behavior in general
local BabyAI = Class{
  walkable="0";
  positionFromLeft = .1 * love.graphics.getWidth();
  positionFromTop = 0.25 * love.graphics.getHeight();
  init = function(self,x,y)
    self.tempPos = 5
    self.x = x or 0
    self.y = y or 0
    self.needsLockOn = true
    self.spawnedObjects = {}
  end;

  --This handles baby general behavior
  Behavior = function(self,map)
    self:Movement(map)
    self:Puke()
  end;
  --This handles the baby Movement
  Movement = function(self,map)

    --The following finds the way to go
    local coordX,coordY = self:Lockon(map)
    local nodeX,nodeY
    print(coordX.."      Nai mikre")
    if(coordX) then --if lockon is false then it does not need to lock on again
      --find the correct path
      self.grid = Grid(map)
      self.myFinder = PathFinder(self.grid,'JPS',self.walkable)

      local startx,starty = self:WorldToMapPoints(self.x,self.y) -- starting point
      local endx,endy = coordX,coordY

      print(startx,starty,"Startx, Starty")
      print(endx,endy,"endx, endy")

      self.path,self.pathLen = self.myFinder:getPath(startx,starty,endx,endy)
    end


    if self.path then
      print(('Path from [%d,%d] to [%d,%d] found! Length: %.2f')
    	:format(1, 1,5,1, self.pathLen))
      for node, count in self.path:iter() do--Now works the path finding stuff
    	  print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
        nodeX,nodeY = node.x,node.y
    	end
    else
      print("noo")
    end


    --................................

    if(not nodeX) then
      return
    end

    self.x,self.y = self:MapToWorldPoints(nodeX,nodeY)
    self.tempPos = -self.tempPos
    self.needsLockOn = true
  end;

  Lockon = function(self,map)
    --Assuming that mapDimensions will be given like this
    --map = {x=1,y=2}

    if(not self.needsLockOn) then
      print("nai baba")
      return nil
    end

    self.needsLockOn = false -- so it can not enter in this loop otherwise

    local coords = self:ReturnValidCoordinatesFunc(map)--Calling function to find coordinates
    local coordX,coordY = coords[1],coords[2]

    print(coordX.." "..coordY.."axaaaaaaaaaaa")
    return coordX,coordY
  end;

  Lockoff = function(self)
    self.needsLockOn=true
  end;

  ReturnValidCoordinatesFunc = function(self,map)
    --This function returns a random set of coordinates
    --Map like : {{5,4},{2,3}}
    local randomNumber1,randomNumber2
    local val = false
    repeat
      --find two random coordinates for baby to wonder to
      randomNumber1 = math.random(1,#map)
      randomNumber2 = math.random(1,#map[randomNumber1])



      if(tostring(map[randomNumber1][randomNumber2])==self.walkable) then --if the baby can walk at that point
        val=true
      end
    until(val)
    --When coming out of this loop guaranteed to have correct coordinate
    print(randomNumber1.."oxi mana mmmmmmmmmmm")
    return {randomNumber1,randomNumber2}
  end;

  --Temporary name
  Puke = function(self)
    if math.random() > 0.9 then
      table.insert(self.spawnedObjects,{x= self.x + 5*math.random(1,10) * math.oneorminusone(),y=self.y,width=30,height=30, type = "puke",rgba={math.random(),.5,math.random(),1}})
    end
  end;

  MapToWorldPoints = function(self,x,y)--returns a coordinates so we can draw babys
    return x*self.positionFromLeft,y*self.positionFromTop
  end;

  WorldToMapPoints = function(self,x,y)--returns world pixel to map points
    if(x/self.positionFromLeft<1) then
      print("hey ---------------------------")
      return x,y
    end
    return x/self.positionFromLeft,y/self.positionFromTop
  end;
}

return BabyAI
