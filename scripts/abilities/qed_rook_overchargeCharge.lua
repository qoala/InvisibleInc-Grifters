local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local inventory = include("sim/inventory")
local serverdefs = include( "modules/serverdefs" )

return {
	name = STRINGS.ITEMSEXTEND.UI.CONSOLE_USE,
	profile_icon = "gui/icons/action_icons/Action_icon_Small/icon-action_chargeweapon_small.png",
	proxy = true,

	createToolTip = function( self,sim, abilityOwner, abilityUser, targetID )
		local targetUnit = sim:getUnit( targetID )
		local headerTxt = STRINGS.ITEMSEXTEND.UI.CONSOLE_USE
		local bodyTxt = string.format( STRINGS.ITEMSEXTEND.UI.CONSOLE_USE_TIP, abilityOwner:getName() )
		return abilityutil.formatToolTip( headerTxt, bodyTxt, simdefs.DEFAULT_COST )
	end,
		
	getName = function( self, sim, unit )
		return STRINGS.ITEMSEXTEND.UI.CONSOLE_USE
	end,

	getProfileIcon = function( self, sim, abilityOwner )
		if abilityOwner and abilityOwner:getTraits().skillIcon then
			return abilityOwner:getTraits().skillIcon
		else
			return self.profile_icon
		end
	end,

	acquireTargets = function( self, targets, game, sim, unit )
		local userUnit = unit:getUnitOwner()
		assert( userUnit, tostring(unit and unit:getName())..", "..tostring(unit:getLocation()) )
		local cell = sim:getCell( userUnit:getLocation() )
        	local cells = { cell }
		for dir, exit in pairs(cell.exits) do
			if simquery.isOpenExit( exit ) then
				table.insert( cells, exit.cell )
			end
		end

		local units = {}
		for i, cell in pairs(cells) do
			for _, cellUnit in ipairs( cell.units ) do
				if cellUnit:getTraits().mainframe_console and cellUnit:getTraits().mainframe_status == "active" then
					table.insert( units, cellUnit )
				end
			end
		end

		return targets.unitTarget( game, units, self, unit, userUnit )
	end,
		
	canUseAbility = function( self, sim, unit )
		local userUnit = unit:getUnitOwner()
		if not userUnit then
			return false
		end
		if not unit:getTraits().installed then
			return false
		end

		if unit:getTraits().charges >= unit:getTraits().chargesMax then
			return false, STRINGS.UI.REASON.CHARGE_FULL
		end

		return abilityutil.checkRequirements( unit, userUnit)
	end,
		
	executeAbility = function( self, sim, abilityOwner, unit, targetUnitID )
		local targetUnit = sim:getUnit( targetUnitID )
		local x1, y1 = targetUnit:getLocation()
		local x0,y0 = unit:getLocation()
		local facing = simquery.getDirectionFromDelta( x1 - x0, y1 - y0 )
		local params = {color ={{symbol="inner_line",r=0,g=1,b=1,a=0.75},{symbol="wall_digital",r=0,g=1,b=1,a=0.75},{symbol="boxy_tail",r=0,g=1,b=1,a=0.75},{symbol="boxy",r=0,g=1,b=1,a=0.75}} }

		local skillBoost = 0
		if abilityOwner:getTraits().skillBoost then
			skillBoost = unit:getSkillLevel( abilityOwner:getTraits().skillBoost )
		end
		inventory.useItem( sim, unit, abilityOwner )

		sim:dispatchEvent( simdefs.EV_UNIT_USECOMP, { unitID = unit:getID(), targetID = targetUnit:getID(), facing = facing, sound = simdefs.SOUNDPATH_USE_CONSOLE, soundFrame = 10 } )
		sim:dispatchEvent( simdefs.EV_UNIT_ADD_FX, { unit = unit, kanim = "fx/deamon_ko", symbol = "effect", anim="break", above=true, params=params} )

		-- Effect
		targetUnit:processEMP( abilityOwner:getTraits().rebootTime - skillBoost, true )
		abilityOwner:getTraits().charges = abilityOwner:getTraits().charges + 1

		if unit:getTraits().charges <= unit:getTraits().chargesMax then
			unit:getTraits().modTrait[0][1] = unit:getTraits().modTrait[0][1] - 0.5
			userUnit:addMPMax( -0.5 )
			userUnit:addMP( -0.5 )
		end
		if unit:getTraits().charges > 0 then
			-- No more charged bonuses, just empty AP bonus
			unit:getTraits().augment_torque_injectors = true
		end

		sim:emitSound( { path = "SpySociety/Actions/recharge_item", range = simdefs.SOUND_RANGE_0 }, x0, y0, userUnit )
		-- END Effect

		sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = targetUnit } )
		simquery.LEVER_resetStatus( sim, unit, "LEGIT", true )
	end,
}

