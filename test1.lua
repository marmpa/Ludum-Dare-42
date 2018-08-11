local test1 = {}

function test1:draw()
  love.graphics.print("Marios")
end

function test1:keyreleased(key)
    if key=="return" then
      assert(test2,test2)
      Gamestate.switch(test2,test1)
    end
end

function test1:enter(previous)
  self.previous = previous
end

return test1
