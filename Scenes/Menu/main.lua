local Menu = {}

function Menu:enter()

  self.font = love.graphics.newFont(20)
  self.menuImage = love.graphics.newImage("imgs/menu.png")
  love.graphics.setFont(self.font)
  self.text = love.graphics.newText(self.font,"Press a for easy , b for medium, c for hard")--Text for telling the user what to do
  self.text1 = love.graphics.newText(self.font,"Press m for mute/unmute!!!!")
end

function Menu:draw()
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.menuImage,0,0)
  love.graphics.setColor(0.8,0.4,0.2)
  love.graphics.draw(self.text,love.graphics.getWidth()/2-self.text:getWidth()/2,love.graphics.getHeight()/2-self.text:getHeight()/2)
  love.graphics.draw(self.text1,love.graphics.getWidth()/2-self.text1:getWidth()/2,love.graphics.getHeight()/2-self.text1:getHeight()/2+30)

end

function Menu:keypressed(key, scancode, isrepeat)
  if(key=="a") then
    Gamestate.switch(scenes.scene1,10)
  elseif(key=="b") then
    Gamestate.switch(scenes.scene1,5)
  elseif(key=="c") then
    Gamestate.switch(scenes.scene1,1)
  end
end

return Menu
