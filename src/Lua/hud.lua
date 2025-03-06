
-- hudding the 4th sonic
-- hooray!!
-- -pac

local CH = customhud

local resConv = FU/2 -- base screenshot uses 640x400, so use this to convert it to 320x200 :P

CH.SetupFont("S4RNG", 0, 4, 33) -- RNG = Rings
CH.SetupFont("S4SCR", 1, 4, 13) -- SCR = Score
CH.SetupFont("S4LVS", 1, 4, 27) -- LVS = Lives

-- RING COUNTER
local noRingTime = TICRATE/2
CH.SetupItem("rings", "S4HUD", function(v, p)
	local flags = V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS
	v.drawScaled(57*resConv, 40*resConv, resConv/2, v.cachePatch("S4E1RING"), flags)
	
	if p.rings ~= 0 then
		CH.CustomNum(v, 64*resConv, 56*resConv, p.rings, "S4RNG", 3, flags, nil, resConv/2)
	elseif leveltime%noRingTime <= noRingTime/2-1 then
		CH.CustomFontString(v, 64*resConv, 56*resConv, "!!!", "S4RNG", flags, nil, resConv/2)
	end
end)

-- LIVES COUNTER
local lifeIcon = {
	x = 62*resConv,
	--y = 328*resConv,
	y = 358*resConv,
	scale = FU
}
CH.SetupItem("lives", "S4HUD", function(v, p)
	local flags = V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS
	
	local skin = skins[p.skin]
	local charGFX
	local charScale = FU
	if skin.sprites[SPR2_LIFE].numframes then
		charGFX = v.getSprite2Patch(p.skin, SPR2_LIFE, (p.powers[pw_super] and true or false))
		charScale = (skin.flags & SF_HIRES) and skin.highresscale or $
	else
		charGFX = v.cachePatch("DEF1UPPIC")
	end
	charScale = FixedMul($, lifeIcon.scale)
	
	local xPos = lifeIcon.x + charGFX.leftoffset * charScale
	local yPos = lifeIcon.y + charGFX.topoffset * charScale - charGFX.height * charScale
	for i = 1, 4 do
		local num = i%2 == 0 and -1 or 1
		local x = i <= 2 and num or 0
		local y = i > 2 and num or 0
		
		v.drawScaled(xPos + x * lifeIcon.scale, yPos + y * lifeIcon.scale, charScale, charGFX, flags, v.getColormap(TC_ALLWHITE) )
	end
	v.drawScaled(xPos, yPos, charScale, charGFX, flags, v.getColormap((p.mo and p.mo.valid and p.mo.colorized) and TC_RAINBOW or p.skin, (p.mo and p.mo.valid) and p.mo.color or p.skincolor) )
	
	v.drawString(99*resConv, 328*resConv, skin.hudname, flags, "small-fixed")
	v.drawScaled(99*resConv, 343*resConv, resConv/2, v.cachePatch("S4E1LIFEX"), flags)
	local numScale = resConv/2 + resConv/5
	--CH.CustomNum(v, 113*resConv, 353*resConv - 28 * numScale, p.lives, "S4LVS", 3, flags, nil, numScale)
	CH.CustomNum(v, 113*resConv, 339*resConv, p.lives, "S4LVS", 3, flags, nil, numScale)
end)

-- SCORE
CH.SetupItem("score", "S4HUD", function(v, p)
	local flags = V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS
	
	v.drawScaled(111*resConv, 49*resConv, resConv/2, v.cachePatch("S4E1SCOREBG"), flags)
	CH.CustomNum(v, 136*resConv, 52*resConv, p.score, "S4SCR", 9, flags, nil, resConv/2)
end)