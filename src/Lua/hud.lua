
-- hudding the 4th sonic
-- hooray!!
-- -pac

local CH = customhud

local resConv = FU/2 -- base screenshot uses 640x400, so use this to convert it to 320x200 :P

CH.SetupFont("S4RNG", 0, 4, 33)

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

local lifeIcon = {
	x = 66*resConv,
	y = 328*resConv,
	scale = FU
}
CH.SetupItem("lives", "S4HUD", function(v, p)
	local flags = V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS
	
	local skin = skins[p.skin]
	local charGFX
	if skin.sprites[SPR2_LIFE].numframes then
		charGFX = v.getSprite2Patch(p.skin, SPR2_LIFE, (p.powers[pw_super] and true or false))
	else
		--charGFX = 
	end
	
	local xPos = lifeIcon.x + charGFX.leftoffset * lifeIcon.scale
	local yPos = lifeIcon.y + charGFX.topoffset * lifeIcon.scale
	for i = 1, 4 do
		local num = i%2 == 0 and -1 or 1
		local x = i <= 2 and num or 0
		local y = i > 2 and num or 0
		
		v.drawScaled(xPos + x * lifeIcon.scale, yPos + y * lifeIcon.scale, lifeIcon.scale, charGFX, flags, v.getColormap(TC_ALLWHITE) )
	end
	v.drawScaled(xPos, yPos, lifeIcon.scale, charGFX, flags, v.getColormap((p.mo and p.mo.valid and p.mo.colorized) and TC_RAINBOW or p.skin, (p.mo and p.mo.valid) and p.mo.color or p.skincolor) )
end)