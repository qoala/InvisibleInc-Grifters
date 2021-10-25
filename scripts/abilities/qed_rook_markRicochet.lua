local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local abilitydefs = include( "sim/abilitydefs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

function canShoot( sim, unit, targetUnit, weaponUnit )
	if not (simquery.isShootable( unit, targetUnit ) or (weaponUnit:getTraits().qed_canShootDevices and simquery.qed_isShootableDevice( unit, targetUnit ))) then
		return false, STRINGS.UI.REASON.INVALID_TARGET
	end
	if not sim:canUnitSeeUnit( unit, targetUnit ) then
		return false, STRINGS.UI.REASON.BLOCKED
	end
	return true
end

return {
	name = STRINGS.QED_GRIFTER.ABILITIES.MARK_RICOCHET,
	profile_icon = "gui/icons/action_icons/Action_icon_Small/icon-item_shoot_small.png",
	proxy = true,

	getName = function( self, sim, ownerUnit, userUnit, targetUnitID )
		return STRINGS.QED_GRIFTER.ABILITIES.MARK_RICOCHET
	end,

	createToolTip = function( self,sim, abilityOwner, abilityUser, targetID )
		local targetUnit = sim:getUnit( targetID )
		local headerTxt = STRINGS.QED_GRIFTER.ABILITIES.MARK_RICOCHET
		local bodyTxt = string.format( STRINGS.QED_GRIFTER.ABILITIES.MARK_RICOCHET_TIP, targetUnit:getName() )
		return abilityutil.formatToolTip( headerTxt, bodyTxt )
	end,

	getProfileIcon = function( self, sim, abilityOwner )
		return self.profile_icon
	end,

	onSpawnAbility = function( self, sim, unit )
		sim:addTrigger( simdefs.TRG_START_TURN, self, unit )
	end,
	onDespawnAbility = function( self, sim, unit )
		sim:removeTrigger( simdefs.TRG_START_TURN, self )
		unit:getTraits().qed_rook_ricochetTargetID = nil
	end,

	onTrigger = function( self, sim, evType, evData, unit )
		if evType == simdefs.TRG_START_TURN then
			-- Reset
			unit:getTraits().qed_rook_ricochetTargetID = nil
		end
	end,

	acquireTargets = function( self, targets, game, sim, unit, userUnit )
		local weaponUnit = simquery.getEquippedGun( userUnit )
		if not weaponUnit then
			return targets.unitTarget( game, {}, self, unit, userUnit )
		end
		-- simlog("QDEBUG acquireTargets unit=%s userUnit=%s equip=%s", unit:getID(), userUnit:getID(), weaponUnit:getID())

		local existingID = unit:getTraits().qed_rook_ricochetTargetID
		local units = {}
		for _, targetUnit in pairs(sim:getAllUnits()) do
			if existingID == targetUnit:getID() or canShoot( sim, userUnit, targetUnit, weaponUnit ) then
				table.insert( units, targetUnit )
			end
		end
		return targets.unitTarget( game, units, self, unit, userUnit )
	end,

	canUseAbility = function( self, sim, ownerUnit, unit, targetUnitID )
		-- simlog("QDEBUG canUse ownerUnit=%s unit=%s target=%s", ownerUnit:getID(), unit:getID(), targetUnitID or "nil")
		local targetUnit = sim:getUnit( targetUnitID )
		if not targetUnit then
			-- Indicate whether or not the ability is usable before acquiring targets
			return unit:getAP() >= 1
		end
		local weaponUnit = simquery.getEquippedGun( unit )
		if not weaponUnit then
			if unit:getTraits().qed_rook_ricochetTargetID == targetUnitID then
				return false, STRINGS.UI.REASON.NO_GUN
			else
				return false
			end
		end

		local ok, reason = canShoot( sim, unit, targetUnit, weaponUnit )
		if not ok then
			return false, reason
		end
		if targetUnitID and unit:getTraits().qed_rook_ricochetTargetID == targetUnitID then
			return false, STRINGS.QED_GRIFTER.ABILITIES.ALREADY_MARKED
		end

		return true
	end,

	executeAbility = function( self, sim, abilityOwner, unit, targetUnitID )
		unit:getTraits().qed_rook_ricochetTargetID = targetUnitID

		local x0, y0 = unit:getLocation()
		sim:dispatchEvent( simdefs.EV_PLAY_SOUND, {sound="SpySociety/Actions/overwatch_tazer", x=x0,y=y0} )
	end
}
