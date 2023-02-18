Display = { -- for gui.text, multiply by 2 to get the correct position
    top = 0,
    bottom = 0,
    left = 260,
    right = 192,
    topScreenY = 0,
    width = 256,
    height = 191
}

function Display:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.screenX = self.left
    self.centerX = self.screenX + self.width/2
    self.centerY = self.topScreenY + self.height
    self.bottomScreenY = self.topScreenY + self.height
    self.rightScreen = self.left + self.width
    return o
end

function Display:setGameExtraPadding()
    client.SetGameExtraPadding(Display.left,Display.top,Display.right,Display.bottom)
    client.setwindowsize(2)
    gui.defaultTextBackground(0)
end

function Display:drawLine(x,y,width,height,clr,screenX,screenY)
	screenY = screenY or 0
    screenX = screenX or 1
    x = x + screenX * self.screenX
    y = y + screenY * self.bottomScreenY
	gui.drawLine(x,y,x+width,y+height,clr)
end 

function Display:drawLineCentered(x,y,width,height,clr,centerX,centerY,screenX,screenY)
    centerX = centerX or 1
    centerY = centerY or 0
    screenX = screenX or 0
    screenY = screenY or 0
    x = x + centerX* self.centerX
    y = y + centerY* self.centerY/2 -- center is half of 2 screens, center of center is half of 1 screen
    self:drawLine(x,y,width,height,clr,screenX,screenY)
end

function Display:drawLineIfWithinBounds(x,y,width,height,clr,screenX,screenY)
    screenY = screenY or 0
    screenX = screenX or 1
    x = x + screenX * self.screenX
    y = y + screenY * self.bottomScreenY
    if x < Display.left or x > Display.rightScreen then return end 
    if y < Display.top or y > Display.centerY then return end
    gui.drawLine(x,y,x+width,y+height,clr)
end

function Display:drawLineCenteredIfWithinBounds(x,y,width,height,clr,centerX,centerY,screenX,screenY)
    centerX = centerX or 1
    centerY = centerY or 0
    screenX = screenX or 0
    screenY = screenY or 0
    x = x + centerX* self.centerX
    y = y + centerY* self.centerY/2 -- center is half of 2 screens, center of center is half of 1 screen
    self:drawLineIfWithinBounds(x,y,width,height,clr,screenX,screenY)
end

function Display:update()
    --self:cleanStaleLayers()
    if MemoryState.gameplayState == "Underground" then 
        self.screenY = {self.bottomScreenY,self.topScreenY} 
        return 
    end
    self.screenY = {self.topScreenY,self.bottomScreenY}
end

function Display:cleanStaleLayers()
    gui.clearGraphics()
    --gui.cleartext()
end