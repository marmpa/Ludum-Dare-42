local Class = require "libs.class"

local Button = Class{--Class button that will make drawing clickable
  init = function(self,x,y,width,height,id)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.id = id or "00x0"
    self.clicked = false

    self.active = true
  end;

  ButtonUpdate = function(self,obj)
    self.x = obj.x
    self.y = obj.y
    self.width = obj.width
    self.height = obj.height
  end;

  Unclick = function(self)
    --print("whattt!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    self.clicked = false
  end;

  ButtonClicked = function(self,x,y,objs)--Checks if the button has been clicked
    if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
      self.clicked=not self.clicked
      print(self.id)

      if(objs) then --if it is provided then unclicks all other buttons

        for i,v in ipairs(objs) do--go through all the buttons and close them
          if(not (self.id==v.id)) then
            v:Unclick()
          end
        end
      end
    end


  end;

  IsButtonClicked = function(self)
    return self.clicked
  end;

  GetId = function(self)
    return self.id
  end;
}



return Button
