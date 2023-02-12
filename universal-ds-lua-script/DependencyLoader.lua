DependencyLoader = {
    emuVersion = nil,
    emulator = nil
}

function DependencyLoader:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self:initEmulator()
    self:loadDependencies()
    return o
end

function DependencyLoader:initEmulator()
    if not client then
        self.emulator = "DeSmuME"
        print("Emulator: " .. self.emulator)
        return
    end
    local version = client.getversion()
    self.emuVersion = tonumber(string.sub(version, 1, 3))
    self.emulator = "BizHawk"
    print("Emulator: " .. self.emulator)
    print("Version: " .. self.emuVersion)
end

function DependencyLoader:loadDependencies()
    self.emuDir = "EmulatorDependencies/" .. self.emulator .. "/"
    dofile(self.emuDir .. displayDir .. "/Display.lua")
    dofile(self.emuDir .. utilityDir .. "/Input.lua")
    dofile(self.emuDir .. utilityDir .. "/Memory.lua")
    dofile(self.emuDir .. utilityDir .. "/Utility.lua")
    dofile(self.emuDir .. utilityDir .. "/Parsers.lua")

    if self.emulator == "BizHawk" then
        self:loadBizHawkDependencies(self.emuDir)
        return 
    end 
    self:loadDeSmuMEDependencies(self.emuDir)
end

function DependencyLoader:loadBizHawkDependencies(dir)
    if self.emuVersion >= 2.9 then
        dofile(dir .. "/version_2.9-x" .. "/MigrationHelpers.lua")
        return
    end 
end

function DependencyLoader:loadDeSmuMEDependencies(dir)
end