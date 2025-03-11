
-- handles the episode 1 menu stuff
-- hooray!!
-- -pac

sfxinfo[freeslot("sfx_shsy07")].caption = "Menu beep"
sfxinfo[freeslot("sfx_shsy08")].caption = "Confirm"

local CH = customhud

local menu = S4HUD.dofile("Libs/menu sys.lua")

local function exitGame()
	COM_BufInsertText(consoleplayer, "quit")
end

local menuMus = false

local optionList = {
	[0] = {"Open Menu", function() return false end},
	[-1] = {"Help & Options", function() menu.setMenu("EP1-Options") end},
	[-2] = {"Exit Game", exitGame}
}

local function getLength(table)
	local length = 0
	for _ in pairs(table) do
		length = $+1
	end
	return length
end

local lastOption = -getLength(optionList)+1

local boxWidth = 80
local boxHeight = 8 * getLength(optionList)
local textBaseY = 140 - boxHeight + 8

local menuActive = false

local barProgress = 0
local barAdd = FU/(TICRATE/3)
local cursorY = 8

local function inputFunc(s, key)
	if menuActive ~= true
	and barProgress == 0 then
		S_StartSound(nil, sfx_shsy08, consoleplayer)
		menuActive = true
	elseif menuActive == true
	and (menu.compareKeyToGC(key.num, GC_SYSTEMMENU) or key.num == 27 or menu.compareKeyToGC(key.num, GC_SPIN)) -- apparently 27 is ESC
	and barProgress >= FU then
		menuActive = false
	end
	
	if barProgress < FU then return true end
	
	if (menu.compareKeyToGC(key.num, GC_JUMP)
		or key.num == 13)
	and optionList[s.curOption][2] then
		S_StartSound(nil, sfx_shsy08, consoleplayer)
		return optionList[s.curOption][2]()
	end
end

local function approach(cur, appr, div)
	local diff = cur + ((appr - cur) / div)
	local sign = min(max(-1, diff), 1)
	
	if cur > appr
	and diff < appr
	or cur < appr
	and diff > appr then
		diff = appr
	end
	return diff
end

local function drawFunc(s, v, _, menuType)
	if menuType == "game" then
		menu.setMenu(false)
		return
	end
	
	if barProgress < FU then
		cursorY = 8
		menu.modifyVar("curOption", 0)
	end
	
	if menuactive
	and menuActive then
		menuActive = false
	end
	
	if menuactive
	or menuActive then
		if not menuMus then
			menuMus = true
			S_ChangeMusic("S4MENU", true, consoleplayer, 0, 0, 250, 500)
		end
	elseif not menuactive
	and not menuActive then
		if menuMus then
			menuMus = false
			S_ChangeMusic("_TITLE", false, consoleplayer, 0, 0, 250, 250)
		end
	end
	
	if not menuActive then
		barProgress = max(0, $-barAdd)
		
		if barProgress == 0 then
			return
		end
	else
		barProgress = min(FU, $+barAdd)
	end
	
	local widthEase = FixedRound( ease.linear(barProgress, 10*FU, boxWidth*FU) ) / FU
	local heightEase = FixedRound( ease.linear(barProgress, 15*FU, boxHeight*FU) ) / FU
	
	local flags = V_SNAPTOBOTTOM
	v.drawFill(160-widthEase, 140-heightEase, widthEase*2, heightEase*2, 31|flags|V_20TRANS)
	
	if barProgress < FU then return end
	
	for i = 0, lastOption, -1 do
		local color = 0
		if s.curOption == i then
			color = V_BLUEMAP
		end
		v.drawString(160, textBaseY - (8 + 6) * i, optionList[i][1], flags|color, "center")
	end
	
	cursorY = approach($, (8 + 6) * s.curOption * FU, 4)
	v.drawScaled((160 - boxWidth + 8) * FU, textBaseY * FU - cursorY, FU/4, v.cachePatch("EP1TITLE_CUR"), flags)
end

local function optionFunc(s)
	if s.curOption > 0 then
		return lastOption
	elseif s.curOption < lastOption then
		return 0
	end
	
	S_StartSound(nil, sfx_shsy07, consoleplayer)
end

menu.addMenu("EP1-TitleMenu", {
	draw = drawFunc,
	input = inputFunc,
	changeOption = optionFunc
})

menu.setMenu("EP1-TitleMenu")

return function()
	if gamestate == GS_TITLESCREEN then return end
	
	menuActive = false
	barProgress = 0
	cursorY = 0
	menuMus = false
end