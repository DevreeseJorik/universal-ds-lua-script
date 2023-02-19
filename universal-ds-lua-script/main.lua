-- Lua script made by RETIRE

-- if you are using BizHawk and notice heavy framedrops when extending screen size do the following:
-- go to display options
-- user prescale: 1x
-- scaling filter: None
-- Final filter: None

-- if frame drops persist, it may be due to the drawRectangle function, I use it to draw tiles

gameDir  = "GameRepository"
displayDir = "Display"
utilityDir = "Utility"
dataDir = "Data"
scriptDir = "Scripts"
templateDir = "Templates"

dofile("GameLoader.lua")
dofile("DependencyLoader.lua")

dl = DependencyLoader:new()
game = Game:new()
game:detect()
Display = Display:new()

if game.game == 0 then
	while true do
		gui.text(1, 0, "Unknown or invalid ROM")
		emu.frameadvance()
	end
else
    game:runScript()
end