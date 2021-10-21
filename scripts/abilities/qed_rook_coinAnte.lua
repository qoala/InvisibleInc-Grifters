local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

return {
	name = STRINGS.QED_GRIFTER.ABILITIES.COIN_ANTE,
	canUseWhileDragging = true,

	getName = function( self, sim, unit )
		return self.name
	end,
	createTooltip = function( self )
		return abilityutil.formatToolTip( STRINGS.QED_GRIFTER.ABILITIES.COIN_ANTE, "" )
	end,

	onSpawnAbility = function( self, sim, unit )
		sim:addTrigger( simdefs.TRG_START_TURN, self, unit )
	end,
	onDespawnAbility = function( self, sim, unit )
		sim:removeTrigger( simdefs.TRG_START_TURN, self )
		self.abilityOwner = nil
	end,

	canUseAbility = function( self, sim, unit )
		local userUnit = unit:getUnitOwner()
		if not userUnit then
			return false
		end
		local ok, reason = abilityutil.canConsumeAmmo( sim, unit )
		if not ok then
			return false, reason
		end
		return abilityutil.checkRequirements( unit, userUnit )
	end,

	onTrigger = function( self, sim, evType, evData, unit )
		if evType == simdefs.TRG_START_TURN then
			-- Reset
			local userUnit = unit:getUnitOwner()
			userUnit:getTraits().qed_peripheralIgnored = nil
		end
	end,

	executeAbility = function( self, sim, unit, userUnit, targetID )
		local x0, y0 = userUnit:getLocation()

		inventory.useItem( sim, userUnit, unit )

		if (true) then
			userUnit:getTraits().qed_peripheralIgnored = true

			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt = STRINGS.QED_GRIFTER.ITEMS.HEADS, x = x0, y = y0,color={r=255/255,g=255/255,b=51/255,a=1}} )
		else
			local target = sim:getUnit( targetID )
			local x1, y1 = target:getLocation()

			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt = STRINGS.QED_GRIFTER.ITEMS.SNAILS, x = x0, y = y0,color={r=255/255,g=255/255,b=51/255,a=1}} )
			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt = STRINGS.QED_GRIFTER.ITEMS.GRIFTED, x = x1, y = y1,color={r=255/255,g=255/255,b=51/255,a=1}} )
		end
	end,
}

