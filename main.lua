Gamestate = require "libs.gamestate"

local test1 = require "test1"
test2 = require "test2"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(test1,test2)
end

function love.keypressed(key, scancode, isrepeat)
  if key=="return" then
    --Gamestate.switch(test2)
  end
end
