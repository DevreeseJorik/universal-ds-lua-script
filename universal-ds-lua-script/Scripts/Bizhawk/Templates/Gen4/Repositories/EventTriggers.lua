EventTriggers = {

}

function EventTriggers:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EventTriggers:display()
    local NPCstruct = PlayerData.NPCstruct
    local x_cam = NPCstruct.x_cam_16
    local y_cam = NPCstruct.y_cam_16
    local z_cam = NPCstruct.z_cam_16
    local table = EventTriggersData.talkTriggers
    self:displayEventTriggers(table,x_cam,y_cam,z_cam)
end

function EventTriggers:displayEventTriggers(table,x,y,z)
    local trigger, x_trigger, y_trigger, z_trigger
    local w = 16
    local h = 14
    local centerX = Display.left + Display.width/2 - w/2
    local centerY = Display.height/2 - h/2

    for i=1, #table do
        trigger = table[i]
        x_trigger = trigger.x
        z_trigger = trigger.z

        gui.drawRectangle(
            centerX + (x_trigger - x)*w, 
            centerY + (z_trigger - z)*h, 
            w,
            h, 
            0xFFFF0000, 
            0xFFFF0000
        )
    end

end


