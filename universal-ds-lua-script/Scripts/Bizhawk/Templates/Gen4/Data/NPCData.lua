NPC = {
    spriteId = 0,
    ObjCode = 0,
    runtimeId = 0,
    moveCode = 0,
    eventType = 0,
    eventFlag = 0,
    eventId = 0,
    movement = 0,
    facingDirection = 0,
    lastMovement = 0,
    lastFacingDirection = 0,

    xSpawn = 0,
    ySpawn = 0,
    zSpawn = 0,

    xFinal = 0,
    yFinal = 0,
    zFinal = 0,

    xPhysical = 0,
    yPhysical = 0,
    zPhysical = 0,

    xCam = 0,
    xCamSubpixel = 0,
    yCam = 0,
    yCamSubpixel = 0,
    zCam = 0,
    zCamSubpixel = 0,

    tileId1 = 0,
    tileId2 = 0,
}

function NPC:new()
    obj = obj or {}
    setmetatable(obj, self)
    obj.__index = self
    return obj
end

NPCData = {

}

function NPCData:New(offsetNPCData,o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

