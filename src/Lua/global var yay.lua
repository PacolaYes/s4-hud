
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

local files = {}
function taebl.dofile(file)
	if not files[file] then
		files[file] = dofile(file)
	end
	return files[file]
end

return taebl