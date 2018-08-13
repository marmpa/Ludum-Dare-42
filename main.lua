Gamestate = require "libs.gamestate"

scenes = {}
scenes.scene1 = require "Scenes.level1Test.main"
scenes.scene2 = require "Scenes.EndingScreen.main"
scenes.scene3 = require "Scenes.Menu.main"

font = nil

function math.oneorminusone()
  if math.random() >0.5 then
    return 1
  end
  return -1
end

function love.load()
  math.randomseed(os.time())
  font = love.graphics.newFont(20)
  love.graphics.setFont(font)

  Gamestate.registerEvents()
  Gamestate.switch(scenes.scene3)
end

function love.keypressed(key, scancode, isrepeat)
  if key=="return" then
    --Gamestate.switch(test2)
  end
end
