Display = {
    topScreenY = -192,
    bottomScreenY = 0,
    width = 256,
    height = 192,
}

function Display:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Display:drawLine(x,y,width,height,clr,screen)
	screen = screen or 0
    y = y + self.screenY[screen+1]
	gui.line(x,y,x+width,y+height,clr)
end 

function Display:drawLineCentered(x,y,width,height,clr,centerX,centerY,screen)
    centerX = centerX or 0
    centerY = centerY or 0
    screen = screen or 0
    x = x + centerX* self.width/2
    y = y + centerY* self.height/2
    self:drawLine(x,y,width,height,clr,screen)
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
    --gui.clearGraphics()
    --gui.cleartext()
end