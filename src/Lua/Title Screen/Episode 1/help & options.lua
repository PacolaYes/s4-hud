
-- handles the episode 1 menu stuff
-- hooray!!
-- -pac

local CH = customhud

local menu = S4HUD.dofile("Libs/menu sys.lua")

local resConv = FU/2
local menuType

local optionList = {
	{
		"Tutorial",
		"learn how to play game",
		function()
			COM_BufInsertText(consoleplayer, "quit")
		end
	}
}

local function drawFillPatch(v, x, y, scale, patch, flags, c)
	if v == nil
	or scale == 0
	or patch == nil then return end
	
	x = $ or 0
	y = $ or 0
	scale = $ or FU
	flags = $ or 0
	local w = v.width() * FU / v.dupx()
	local h = v.height() * FU / v.dupy()
	
	local pwidth = patch.width * scale
	local pheight = patch.height * scale
	
	local curY = y
	while curY < h do
		local curX = x
		while curX < w do
			v.drawScaled(curX, curY, scale, patch, flags)
			curX = $+pwidth
		end
		curY = $+pheight
	end
end

local function inputFunc(s, key)
	
end

local function drawFunc(s, v, _, mtype)
	local patch = v.cachePatch("EP1OPT_BG")
	
	local scale = resConv / 2
	local flags = V_PERPLAYER|V_HUDTRANS
	
	local pwidth = (patch.width * scale)
	local pheight = (patch.height * scale)
	
	local xoffset = ((s.tics * 2) % patch.width) * scale
	local yoffset = ((s.tics * 2) % patch.height) * scale
	drawFillPatch(v, -pwidth + xoffset, -yoffset, scale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|flags)
	
	v.drawScaled(0, 10*resConv, scale, v.cachePatch("EP1OPT_TAB"), V_SNAPTOTOP|V_SNAPTOLEFT|flags)
	
	menuType = mtype
end

menu.addMenu("EP1-Options", {
	draw = drawFunc,
	input = inputFunc
})

return function()
	
end