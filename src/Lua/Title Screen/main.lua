
-- handles title screen stuff in general
-- that the other luas don't handle atleast

local ts = "Title Screen/"
dofile(ts+"logo.lua")

local ep1 = ts+"Episode 1/"
local ep1Menu = dofile(ep1+"title menu.lua")
local ep1Options = dofile(ep1+"help & options.lua")

local menu = S4HUD.dofile("Libs/menu sys.lua")

menu.addMenu("handler", {
	draw = function(v)
		if gamestate == GS_TITLESCREEN then
			menu.setMenu("EP1-TitleMenu")
		else
			menu.setMenu(nil)
		end
	end
})

addHook("ThinkFrame", function()
		
	ep1Menu()
end)