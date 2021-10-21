local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

return {
	name = STRINGS.QED_GRIFTER.ABILITIES.OVERCHARGE_USE,
	getName = function( self, sim, unit )
		return self.name
	end,
	createTooltip = function( self )
		return abilityutil.formatToolTip( STRINGS.QED_GRIFTER.ABILITIES.OVERCHARGE_USE, "" )
	end,

	executeAbility = function( self, sim, unit, userUnit )
		if unit:getTraits().charges > 0 then
			unit:getTraits().charges = unit:getTraits().charges - 1

			if unit:getTraits().charges < unit:getTraits().chargesMax then
				-- Emptied cell unencumberance
				unit:getTraits().modTrait[1][2] = unit:getTraits().modTrait[1][2] + 0.5
				userUnit:addMPMax( 0.5 )
				userUnit:addMP( 0.5 )
			end
			if unit:getTraits().charges <= 0 then
				-- No more charged bonuses, just empty AP bonus
				unit:getTraits().augment_torque_injectors = nil
			end
		end
	end
}

