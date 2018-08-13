local Class = require "libs.class"
local BabyAi = require "scripts.babyAI"
local Button = require "scripts.Button"
--Class that handles Baby things
Baby = Class{
  __includes = {BabyAi,Button};

  init = function(self,x,y,map,id)
    self.width = 50
    self.height = 50
    BabyAi.init(self,x,y,map)
    Button.init(self,x,y,self.width,self.height,id or "00x1")
    self.status = nil

    self.image = love.graphics.newImage("imgs/baby.png")
    self.source = love.audio.newSource("Sounds/babycry"..math.random(1,3)..".wav","static")

    self.source:setLooping(true)
    self.source:setVolume(.0009)
    self.source:play()
  end;


  SourceCheck

}





return Baby
