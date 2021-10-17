
local function earlyInit( modApi )
	modApi.requirements =
	{
	}
end

local function init( modApi )
	local scriptPath = modApi:getScriptPath()
	-- Store script path for cross-file includes
	-- rawset(_G,"SCRIPT_PATHS",rawget(_G,"SCRIPT_PATHS") or {})
	-- SCRIPT_PATHS.qoala_grifter = scriptPath
end

local function lateInit( modApi )
end

local function earlyUnload( modApi )
end

local function earlyLoad( modApi, options, params )
	earlyUnload( modApi )
end

local function load( modApi, options, params )
	local scriptPath = modApi:getScriptPath()
end

local function lateLoad( modApi, options, params )
end

local function initStrings( modApi )
	local dataPath = modApi:getDataPath()
	local scriptPath = modApi:getScriptPath()

	local MOD_STRINGS = include( scriptPath .. "/strings" )
	modApi:addStrings( dataPath, "QED_GRIFTER", MOD_STRINGS)
end

return {
	earlyInit = earlyInit,
	init = init,
	-- lateInit = lateInit,
	-- earlyLoad = earlyLoad,
	-- earlyUnload = earlyUnload,
	load = load,
	-- lateLoad = lateLoad,
	initStrings = initStrings,
}
