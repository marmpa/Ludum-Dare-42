local EndingScreen = {}

function EndingScreen:enter(prev,points)
  font = love.graphics.newFont(50)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.graphics.setFont(font)

  self.pointsGot = points

  self.text = love.graphics.newText(font, "Your Score was: "..self.pointsGot)--text to write

  self.source = love.audio.newSource("win.mp3", "static")
  self.source.setVolume(.2)
  self.source:setLooping(true)
  self.source:play()
end

function EndingScreen:draw()
  love.graphics.draw(self.text,love.graphics.getWidth()/2-self.text:getWidth()/2,love.graphics.getHeight()/2-self.text:getHeight()/2)
end

function EndingScreen:keypressed( key, scancode, isrepeat )
  if(key=="escape") then
    Gamestate.switch(scenes.scene1,6,5)
  end
end

return EndingScreen
