
-- the title card
-- for episode 1
-- -pac

-- TODO:
-- 	- subtitle thing

local CH = customhud
local resConv = FU/2 -- base screenshot uses 640x400, so use this to convert it to 320x200 :P

local BGTime = TICRATE/2

CH.SetupFont("S4TC", -4, 16)
CH.SetupFont("S4ACT", 0, 16)

local fontScale = FixedMul(resConv, 65*FU/100)

CH.SetupItem("stagetitle", "S4HUD", function(v, p, tics, endtic)
	if tics > endtic then return end
	
	local patch = v.cachePatch("EP1TTL_BG")
	local scale = resConv/2
	
	local vwidth = v.width() * FU / v.dupx()
	local vheight = v.height() * FU / v.dupy()
	
	local fillWidth = vwidth / FU + 1
	
	local fadeStr = 10 -- Str stands for Strength
	local pTics = tics -- p stands for proper, because it accounts for the going back stuff :P
	
	local fadeEndTics = TICRATE / 4
	local fadePos = 32 - FixedRound(32*FU / fadeEndTics * min(tics, fadeEndTics)) / FU -- math for where the black fade is at
	
	local runAwayTic = TICRATE
	if tics >= endtic-runAwayTic then -- if you're supposed to be going away then
		pTics = endtic - $ -- make pTics be equals a countdown from runAwayTic to 0
		fadeStr = 10*FU / max(min(runAwayTic - pTics, fadeEndTics), 1) / FU - 1 -- wdym i copied this?? never would i do that
		
		fadeEndTics = TICRATE-5 -- im so smart :) (this code is a mess with the going out thing now D:)
	end
	
	v.fadeScreen(0, fadeStr)
	
	if fadeEndTics ~= 0 then
		v.fadeScreen(0xFA00, fadePos)
	end
	
	local uTics = max(pTics - fadeEndTics, 0)
	
	-- THE RED FILL (spongebob creepypasta)
	local showAnimTics = min(uTics, 5)
	local fillX = fillWidth - (fillWidth / 5) * showAnimTics
	v.drawFill(fillX, 200-(200/3), fillWidth, 200/3, 35|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER)
	
	if tics >= endtic-runAwayTic then -- if you're supposed to go away, then make the uTics just go down normally pls pls pls
		uTics = pTics -- im gonna go crazy! :D
	end
	
	-- add the 5 tics used for the anim above + 5 tics of delay, for the text anim, not the bg one below it :P
	uTics = max($-(5 + 5), 0)
	
	local zoneTics = min(uTics, 5)
	local mh = mapheaderinfo[gamemap]
	
	-- ZONE
	if mh and not (mh.levelflags & LF_NOZONE)
	and uTics > 0 then -- so it doesn't show up on non-green resolutions :P
		local zoneX = 488*resConv / 5 * zoneTics
		
		CH.CustomFontString(v, zoneX, 151*resConv, "ZONE", "S4TC", V_SNAPTORIGHT|V_PERPLAYER, "right", fontScale)
	end
	
	-- THE SPIKY THING IDK THE NAME OF
	local thingX = (-patch.width * scale) + (patch.width * scale / 5) * showAnimTics
	local thingY = tics % BGTime <= (BGTime/2)-1 and -patch.height * (scale/2) or 0
	while thingY < vheight do
		v.drawScaled(thingX, thingY, scale, patch, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER)
		thingY = $ + patch.height * scale
	end
	
	-- LEVEL NAME
	local str = mh and mh.lvlttl or "null"
	if str
	and uTics > 0 then
		str = $:upper()
		local fontX = 585*resConv / 5 * zoneTics
		
		--CH.CustomFontString(v, fontX+3*scale, 85*resConv+3*scale, str, "S4TC", flags|V_30TRANS, "right", fontScale)
		CH.CustomFontString(v, fontX, 95*resConv, str, "S4TC", V_SNAPTORIGHT|V_PERPLAYER, "right", fontScale)
	end
	
	-- ACT NUMBER
	if mh and mh.actnum ~= 0 then
		local actX = (400*resConv * 2) - 400*resConv / 5 * zoneTics
		
		v.drawScaled(actX, 194*resConv, FixedMul(resConv, 60*FU/100), v.cachePatch("EP1TTL_ACT"), V_SNAPTORIGHT|V_PERPLAYER)
		
		-- actX = 400, + 90 = 490, which is where we want it to be :P
		CH.CustomNum(v, actX + 90*resConv, 160*resConv, mh.actnum, "S4ACT", 0, V_SNAPTORIGHT|V_PERPLAYER, nil, FixedMul(resConv, FU+FU/2))
	end
	
	-- STR = 65%?
	-- ACT = 60%
	-- x = 400, 194
end, "titlecard")