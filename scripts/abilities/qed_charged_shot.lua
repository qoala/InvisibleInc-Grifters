local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

return {
	name = STRINGS.QED_GRIFTER.ABILITIES.CHARGED_SHOT,
	getName = function( self, sim, unit )
		return self.name
	end,
	createTooltip = function( self )
		return abilityutil.formatToolTip( STRINGS.ABILITIES.OVERWATCH_SHOOT, STRINGS.ABILITIES.OVERWATCH_SHOOT_DESC, 1 )
	end,

	executeAbility = function( self, sim, unit, userUnit )
		if unit:getTraits().charges > 0 then
			inventory.useItem( sim, userUnit, unit )
			-- Emptied cell unencumberance
			userUnit:addMPMax( 1 )
			userUnit:addMP( 1 )
		end

		if unit:getTraits().charges <= 0 then
			-- No more charged bonuses, just empty AP bonus
			unit:getTraits().addArmorPiercingRanged = nil
			userUnit:getTraits().rangedKO_bonus = userUnit:getTraits().rangedKO_bonus - 1
			userUnit:getTraits().qed_charged_shot = false
		end
	end
}
