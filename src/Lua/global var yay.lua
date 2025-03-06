
-- just the caching stuff ig
-- idk if caching is even the right word in this case :P

local taebl = {}
local cachedPatches = {}

-- this isn't even used in the old main hud code because
-- i did stuff or something previously like idk
-- my code is mostly all jank anyways :P
function taebl.getPatch(v, patch)
	if not v or not patch then return end
	
	if not (cachedPatches[patch] and cachedPatches[patch].valid) then
		cachedPatches[patch] = v.cachePatch(patch)
	end
	return cachedPatches[patch]
end

taebl.lifeicons = { -- if you for some reason want a custom life icon to show up for a certain character, here it is, take sonic as an example!!
	-- no, sonic doesn't use this because it's hardcoded to use it :D
	--["sonic"] = {"S4E1SONICICON", FU/2, 0, 0}
	-- more indepth explanation:
	-- first, is the patch name, you CAN use SPR2_ & SPR_ if they're NOT the constants but instead strings, so "SPR2_STND" instead of SPR2_STND
	-- then, the scale it should draw at, FU is 1, do math for decimal values i think you get it :P
	-- 3rd value is the number of frames-1, so you can use the frame constants (ex: G)
	-- 4th value is the anim tics, 0 or lower = dont animate
	-- all you really need is to do to make this show up is add the first thingie
	-- the rest can all be defaulted
	-- NEEDS to be a table though!!
	-- so if you only want the first thingie do uh
	-- {"name"} instead of just "name"!!!
}
-- idk if it being global is really necessary but whatever :P
rawset(_G, "S4HUD", taebl)