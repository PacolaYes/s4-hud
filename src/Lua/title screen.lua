
-- makes the title screen a bunch of pngs moving up
-- like hit sonic game, spongebob squarepants supersponge
-- -Pac

local titleTics = 0

addHook("ThinkFrame", function()
	if gamestate == GS_TITLESCREEN then return end
	
	titleTics = 0
end)

-- all variables comes from source code!!
local CHARSTART = 41
local SONICSTART = (CHARSTART+0)
--local SONICIDLE = (SONICSTART+57)
local SONICIDLE = (SONICSTART+TICRATE)
local SONICX = 89*FU
local SONICY = 13*FU
local TAILSSTART = (CHARSTART+27)
--local TAILSIDLE = (TAILSSTART+60)
local TAILSIDLE = (TAILSSTART+TICRATE)
local TAILSX = 35*FU
local TAILSY = 19*FU
local KNUXSTART = (CHARSTART+44)
--local KNUXIDLE = (KNUXSTART+70)
local KNUXIDLE = (KNUXSTART+TICRATE)
local KNUXX = 167*FU
local KNUXY = 7*FU

-- sonic graphics:
-- T2SOIB03 for going up
-- T2SOIB05, T2SOIB10, T2SOIB14
-- T2SOBA01 for finger loop thingie
-- T2SOBK0 1 to 3 for blinking frames

local frameList = {
	["sonic"] = {"05", "10", "14"}
}

local fingerConv = {
	[1] = "01",
	[2] = "01",
	[3] = "03",
	[4] = "03",
	[5] = "05",
	[6] = "05",
	[7] = "07",
	[8] = "08",
	[9] = "08",
	[10] = "10",
	[11] = "10",
	[12] = "12",
	[13] = "12"
}

-- for the front graphics
-- change B to F (?)

-- designed around the vanilla graphics
-- but should work with modded ones
-- no guarantees about offsets in those though :P
-- IF they change the 2x graphics of the "Alacroix" title screen though :P
local function drawBackChars(v)
	if titleTics >= KNUXSTART then
		local ticDiff = KNUXIDLE-titleTics
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-40
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), KNUXY, KNUXY+(20*FU))
				v.drawScaled(KNUXX, uy, FU/2, S4HUD.getPatch(v, "T2KNIB03"))
			else
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2KNIB"+frameList.sonic[frameNum/FU]
				
				v.drawScaled(KNUXX, KNUXY, FU/2, S4HUD.getPatch(v, animFrame))
			end
		else
			v.drawScaled(KNUXX, KNUXY, FU/2, S4HUD.getPatch(v, "T2KNBA01"))
		end
	end
	if titleTics >= TAILSSTART then
		local ticDiff = TAILSIDLE-titleTics
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-40
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), TAILSY, TAILSY+(20*FU))
				v.drawScaled(TAILSX, uy, FU/2, S4HUD.getPatch(v, "T2TAIB03"))
			else
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2TAIB"+frameList.sonic[frameNum/FU]
				
				v.drawScaled(TAILSX, TAILSY, FU/2, S4HUD.getPatch(v, animFrame))
			end
		else
			local tailFrame = ((titleTics/3)%12)+1
			tailFrame = fingerConv[$]
			v.drawScaled(TAILSX, TAILSY, FU/2, S4HUD.getPatch(v, "T2TABT"+tailFrame))
			v.drawScaled(TAILSX, TAILSY, FU/2, S4HUD.getPatch(v, "T2TAFT"+tailFrame))
			v.drawScaled(TAILSX, TAILSY, FU/2, S4HUD.getPatch(v, "T2TABA01"))
		end
	end
	if titleTics >= SONICSTART then
		local ticDiff = SONICIDLE-titleTics -- 57 is the start value
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-18
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), SONICY, SONICY+(40*FU))
				v.drawScaled(SONICX-(40*FU)/2, uy, FU/2, S4HUD.getPatch(v, "T2SOIB03"))
			else
				-- who needs math when we have ease.linear!!!!
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2SOIB"+frameList.sonic[frameNum/FU]
				
				v.drawScaled(SONICX, SONICY, FU/2, S4HUD.getPatch(v, animFrame))
			end
		else
			v.drawScaled(SONICX, SONICY, FU/2, S4HUD.getPatch(v, "T2SOBA01"))
		end
	end
end

local function drawFrontChars(v)
	if titleTics >= KNUXSTART then
		local ticDiff = KNUXIDLE-titleTics
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-40
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), KNUXY, KNUXY+(20*FU))
				v.drawScaled(KNUXX, uy, FU/2, S4HUD.getPatch(v, "T2KNIF03"))
			else
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2KNIF"+frameList.sonic[frameNum/FU]
				
				if v.patchExists(animFrame) then
					v.drawScaled(KNUXX, KNUXY, FU/2, S4HUD.getPatch(v, animFrame))
				end
			end
		else
			local handFrame = ((titleTics/3)%13)+1
			handFrame = fingerConv[$]
			v.drawScaled(KNUXX, KNUXY, FU/2, S4HUD.getPatch(v, "T2KNDH"+handFrame))
		end
	end
	
	if titleTics >= TAILSSTART then
		local ticDiff = TAILSIDLE-titleTics
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-40
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), TAILSY, TAILSY+(20*FU))
				v.drawScaled(TAILSX, uy, FU/2, S4HUD.getPatch(v, "T2TAIF03"))
			else
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2TAIF"+frameList.sonic[frameNum/FU]
				
				if v.patchExists(animFrame) then
					v.drawScaled(TAILSX, TAILSY, FU/2, S4HUD.getPatch(v, animFrame))
				end
			end
		else
			
		end
	end
	
	if titleTics >= SONICSTART then
		local ticDiff = SONICIDLE-titleTics -- 57 is the start value
		if ticDiff > 0 then
			if ticDiff > 18 then
				local upDiff = ticDiff-18
				local uy = ease.linear(max(FixedDiv(upDiff, 17), 0), SONICY, SONICY+(40*FU))
				v.drawScaled(SONICX-(40*FU)/2, uy, FU/2, S4HUD.getPatch(v, "T2SOIF03"))
			else
				-- who needs math when we have ease.linear!!!!
				local frameNum = max(ease.linear(FixedDiv(ticDiff, 18), (#frameList.sonic+1)*FU, 0), FU)
				local animFrame = "T2SOIF"+frameList.sonic[frameNum/FU]
				
				if v.patchExists(animFrame) then
					v.drawScaled(SONICX, SONICY, FU/2, S4HUD.getPatch(v, animFrame))
				end
			end
		else
			local fingerFrame = ((titleTics/3)%9)+1
			fingerFrame = fingerConv[$]
			v.drawScaled(SONICX, SONICY, FU/2, S4HUD.getPatch(v, "T2SODH"+fingerFrame))
		end
	end
end

-- why cant stjr give us anything
addHook("HUD", function(v)
	if chaotix -- chaotix has their own title screen, so ignore
	or S4HUD.disableTitle then return end
	
	if titlemapinaction then
		titleTics = leveltime
	end
	
	v.drawScaled(40*FU, 20*FU, FU/2, S4HUD.getPatch(v, "T2EMBL"))
	
	drawBackChars(v)
	
	v.drawScaled(39*FU, 93*FU, FU/2, S4HUD.getPatch(v, "T2RBTX"))
	
	drawFrontChars(v)
	
	titleTics = $+1
end, "title")