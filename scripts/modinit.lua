local serverdefs = include( "modules/serverdefs" )

local function earlyInit( modApi )
	modApi.requirements =
	{
		"Function Library",
	}
end

local function init( modApi )
	local scriptPath = modApi:getScriptPath()
	-- Store script path for cross-file includes
	-- rawset(_G,"SCRIPT_PATHS",rawget(_G,"SCRIPT_PATHS") or {})
	-- SCRIPT_PATHS.qoala_grifter = scriptPath

	include( scriptPath .. "/engine" )
	include( scriptPath .. "/inventory" )
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

	modApi:addAbilityDef( "qed_rook_chargedShot", scriptPath .. "/abilities/qed_rook_chargedShot" )
	modApi:addAbilityDef( "qed_rook_overchargeCharge", scriptPath .. "/abilities/qed_rook_overchargeCharge" )
	modApi:addAbilityDef( "qed_rook_overchargeUse", scriptPath .. "/abilities/qed_rook_overchargeUse" )

	local mod_itemdefs = include( scriptPath .. "/itemdefs" )
	for name, itemdef in pairs(mod_itemdefs) do
		modApi:addItemDef( name, itemdef )
	end

	local mod_agentdefs = include( scriptPath .. "/agentdefs" )
	modApi:addAgentDef( "rook", mod_agentdefs.rook, { "rook", "rook_a" } )
	modApi:addAgentDef( "rook_a", mod_agentdefs.rook_a )
	-- modApi::addRescueAgent()
end

local function lateLoad( modApi, options, params )
end

local function initStrings( modApi )
	local dataPath = modApi:getDataPath()
	local scriptPath = modApi:getScriptPath()

	local MOD_STRINGS = include( scriptPath .. "/strings" )
	modApi:addStrings( dataPath, "QED_GRIFTER", MOD_STRINGS )
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
