local Class = require "libs.class"
local Grid = require("libs.grid")
local PathFinder = require("libs.pathfinder")

--Handles Baby Behavior in general
local BabyAI = Class{
  walkable="0";
  positionFromLeft = 0;--0.048828125 * love.graphics.getWidth();
  positionFromTop = 0;--0.06510416666666666666666666666667 * love.graphics.getHeight();
  canContinueLast=false;--For findnext point thingie so it can work properly
  init = function(self,x,y,map)
    self.tempPos = 5
    self.x = x or 0
    self.y = y or 0
    self.needsLockOn = true
    self.spawnedObjects = {}
    self.grid = Grid(map)
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
    if(coordX) then --if lockon is false then it does not need to lock on again
      --find the correct path


      self.myFinder = PathFinder(self.grid,'JPS',self.walkable)

      local startx,starty = self:WorldToMapPoints(self.x,self.y) -- starting point
      local endx,endy = math.floor(coordX),math.floor(coordY)

      print(startx,starty,"Startx, Starty")
      print(endx,endy,"endx, endy")


      self.path,self.pathLen = self.myFinder:getPath(startx,starty,endx,endy)
    end


    self.pathTable = {}
    if self.path then
      print(('Path from [%d,%d] to [%d,%d] found! Length: %.2f')
    	:format(1, 1,5,1, self.pathLen))
      for node, count in self.path:iter() do--Now works the path finding stuff
    	  print(('Step: %d - x: %d - y: %d'):format(count, node.x, node.y))
        nodeX,nodeY = node.x,node.y
        table.insert(self.pathTable,{x=node.x,y = node.y})
    	end
      self.currentPathPosition = {i=1,x=self.pathTable[1].x,y=self.pathTable[1].y}
      self.path=nil
    else
      print("noo")
    end



    --................................
    self:NextPathPoint()
    if(not nodeX) then
      return
    end

    --self.x,self.y = self:MapToWorldPoints(nodeX,nodeY)
    --self.tempPos = -self.tempPos
  end;

  Lockon = function(self,map)
    --Assuming that mapDimensions will be given like this
    --map = {x=1,y=2}

    if(not self.needsLockOn) then --checks if needsLockOn so it can do stuff
      print("nai baba")
      return nil
    end

    self:Lockoff() -- so it can not enter in this loop otherwise

    local coords = self:ReturnValidCoordinatesFunc(map)--Calling function to find coordinates
    local coordX,coordY = coords[1],coords[2]

    print(coordX.." "..coordY.."axaaaaaaaaaaa")
    return coordX,coordY
  end;

  Lockoff = function(self)
    self.needsLockOn=false
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
    return {randomNumber2,randomNumber1}
  end;

  --Temporary name
  Puke = function(self)
    if math.random() > 0.9 then
      table.insert(self.spawnedObjects,{x= self.x + 5*math.random(1,10) * math.oneorminusone(),y=self.y,width=30,height=30, type = "puke",rgba={math.random(),.5,math.random(),1}})
    end
  end;

  MapToWorldPoints = function(self,x,y)--returns a coordinates so we can draw babys
    return x*50+self.positionFromLeft,y*50+self.positionFromTop
  end;

  WorldToMapPoints = function(self,x,y)--returns world pixel to map points
    if((x-self.positionFromLeft)/50<1) then--if by returning to normal number gives us a
      --number less than one that means that that number was small to begin without
      --so return it
      print("hey ---------------------------")
      return math.floor(x),math.floor(y)
    end
    return math.floor((x-self.positionFromLeft)/50),math.floor((y-self.positionFromTop)/50)
  end;

  NextPathPoint = function(self)--gives the next path point so baby can move
    if(self.pathTable[self.currentPathPosition.i+1]) then--if it has a next in its path
      --print("NextPathPoint")
      --sets up next point
      local nextNum = self.currentPathPosition.i+1
      local tempPath = {i=nextNum,x=self.pathTable[nextNum].x,y=self.pathTable[nextNum].y}

      self.x,self.y = self:MapToWorldPoints(self.currentPathPosition.x,self.currentPathPosition.y)
      print("NextPathPoint",self:WorldToMapPoints(self.x,self.y))
      print("Current point",self.currentPathPosition.x,self.currentPathPosition.y)
      self.currentPathPosition = tempPath
      print("Next point",self.currentPathPosition.x,self.currentPathPosition.y)
    elseif(not self.canContinueLast) then -- if it does not but it is unlocked
      self.x,self.y = self:MapToWorldPoints(self.currentPathPosition.x,self.currentPathPosition.y)
      self.canContinueLast=true
    else--if locked
      self.canContinueLast=false
      self.needsLockOn=true
    end
  end;
}

return BabyAI
