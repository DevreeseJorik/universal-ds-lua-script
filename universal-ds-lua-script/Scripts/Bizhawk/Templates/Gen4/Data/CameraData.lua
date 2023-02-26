CameraData = {

}

function CameraData:new(offsetCameraData,o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.offsetCameraData = offsetCameraData
    return o
end

function CameraData:update()
    self.cameraStructAddress = Memory:read_u32_le(MemoryState.base + self.offsetCameraData)
    self.cameraData = Memory:read_bytes_as_array(self.cameraStructAddress, 48)
    self.cameraOrbitTarget = self:getCameraOrbit(0x14)
    self.cameraOrbitSelf = self:getCameraOrbit(0x20)

end

function CameraData:getCameraOrbit(offset)
    local cameraOrbit = {}
    cameraOrbit.x_subpixel = Memory:getByteRange(self.cameraData, offset, 2)
    cameraOrbit.x = Memory:getByteRange(self.cameraData, offset + 0x2, 2)

    cameraOrbit.y_subpixel = Memory:getByteRange(self.cameraData, offset + 0x4, 2)
    cameraOrbit.y = Memory:getByteRange(self.cameraData, offset + 0x6, 2)

    cameraOrbit.z_subpixel = Memory:getByteRange(self.cameraData, offset + 0x8, 2)
    cameraOrbit.z = Memory:getByteRange(self.cameraData, offset + 0xA, 2)
    return cameraOrbit
end

function CameraData:increaseMapOrbit()
    self.cameraStructAddress = Memory.read_u32_le(MemoryState.base + self.offsetCameraData)
    self.mapOrbitX = Memory.read_u32_le(self.cameraStructAddress + 0x2C)
    Memory:write_u32_le(self.cameraStructAddress + 0x2C, self.mapOrbitX + 0x10)
end

function CameraData:decreaseMapOrbit()
    self.cameraStructAddress = Memory.read_u32_le(MemoryState.base + self.offsetCameraData)
    self.mapOrbitX = Memory.read_u32_le(self.cameraStructAddress + 0x2C)
    Memory:write_u32_le(self.cameraStructAddress + 0x2C, self.mapOrbitX - 0x10)
end