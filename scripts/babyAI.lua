local Class = require "libs.class"

--Handles Baby Behavior in general
local BabyAI = Class{

  init = function(self,x,y)
    self.tempPos = 5
    self.x = x or 0
    self.y = y or 0
    self.spawnedObjects = {}
  end;

  --This handles baby general behavior
  Behavior = function(self)
    self:Movement()
    self:Puke()
  end;
  --This handles the baby Movement
  Movement = function(self)
    self.x = self.x + self.tempPos
    self.y = self.y
    self.tempPos = -self.tempPos
  end;

  --Temporary name
  Puke = function(self)
    if math.random() > 0.9 then
      table.insert(self.spawnedObjects,{x= self.x + 5*math.random(1,10) * math.oneorminusone(),y=self.y,width=30,height=30, type = "puke",rgba={math.random(),.5,math.random(),1}})
    end
  end
}

return BabyAI
