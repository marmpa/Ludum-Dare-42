local Class = require "libs.class"
local BabyAi = require "scripts.babyAI"
--Class that handles Baby things
Baby = Class{
  __includes = BabyAi;

  init = function(self,x,y,map)
    BabyAi.init(self,x,y,map)
    self.status = nil
  end;

}



return Baby
