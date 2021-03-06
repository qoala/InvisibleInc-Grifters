local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local abilitydefs = include( "sim/abilitydefs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

local shootSingle = abilitydefs.lookupAbility("shootSingle")

return util.extend(shootSingle) {
	acquireTargets = function( self, targets, game, sim, unit, userUnit )
		local units = {}
		for _, targetUnit in pairs(sim:getAllUnits()) do
			if simquery.qed_isShootableDevice( userUnit, targetUnit ) and sim:canUnitSeeUnit( userUnit, targetUnit ) then
				table.insert( units, targetUnit )
			end
		end
		return targets.unitTarget( game, units, self, unit, userUnit )
	end,

	canUseAbility = function( self, sim, ownerUnit, unit, targetUnitID )

		local targetUnit = sim:getUnit( targetUnitID )
		if not targetUnit then
			-- Indicate whether or not the ability is usable before acquiring targets
			local weaponUnit = simquery.getEquippedGun( unit )
			if not weaponUnit or not weaponUnit:getTraits().qed_canShootDevices then
				return false
			end

			local ok, reason = abilityutil.canConsumeAmmo( sim, weaponUnit )
			if not ok then
				return false
			end

			if weaponUnit:getTraits().usesCharges and weaponUnit:getTraits().charges < 1 then
				return false
			end

			if unit:getAP() < 1 and not unit:isNPC() then
				return false
			end

			return true
		end

		if not simquery.qed_isShootableDevice( unit, targetUnit ) then
			return false
		end
		if not sim:canUnitSeeUnit( unit, targetUnit ) then
			return false, STRINGS.UI.REASON.BLOCKED
		end

		return true
	end,
}

