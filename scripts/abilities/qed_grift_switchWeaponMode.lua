local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local inventory = include("sim/inventory")
local simquery = include("sim/simquery")
local abilityutil = include("sim/abilities/abilityutil")

-- Copy of NIAA's W93_switchWeaponMode
return {
	name = STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE,
	createToolTip = function( self,sim,unit,targetCell)
		return abilityutil.formatToolTip(STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE, util.sformat(STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE_DESC,self.mode), 1 )
	end,
	mode = "<c:73d216>KO</c>",
	profile_icon = "gui/icons/action_icons/Action_icon_Small/icon-item_select_small.png",

	alwaysShow = true,

	getName = function( self, sim, unit )
		return STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE
	end,

	canUseAbility = function( self, sim, weaponUnit, unit )
		return true
	end,

	executeAbility = function( self, sim, weaponUnit, unit )
		self.mode = weaponUnit:getTraits().mode
		if (weaponUnit:getTraits().mode == "LETHAL" or weaponUnit:getTraits().mode == "EMP") and weaponUnit:getTraits().modeKOdamage then
			self.mode = "<c:73d216>KO</c>"
			weaponUnit:getTraits().mode = "KO"
			weaponUnit:getTraits().baseDamage = weaponUnit:getTraits().modeKOdamage or 2
			weaponUnit:getTraits().armorPiercing = weaponUnit:getTraits().modeKO_AP or 0
			weaponUnit:getTraits().canSleep = true
			weaponUnit:getTraits().canEmp = nil
			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE_KO, unit = unit, color= cdefs.MOVECLR_DEFAULT })
		elseif weaponUnit:getTraits().mode == "KO" and weaponUnit:getTraits().modeLdamage then
			self.mode = "<c:ef2929>LETHAL</c>"
			weaponUnit:getTraits().mode = "LETHAL"
			weaponUnit:getTraits().baseDamage = weaponUnit:getTraits().modeLdamage or 1
			weaponUnit:getTraits().armorPiercing = weaponUnit:getTraits().modeL_AP or 0
			weaponUnit:getTraits().canSleep = nil
			weaponUnit:getTraits().canEmp = nil
			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE_L, unit = unit, color= cdefs.MOVECLR_DEFAULT })
		elseif weaponUnit:getTraits().mode == "KO" and weaponUnit:getTraits().modeEmpdamage then
			self.mode = "<c:14DCFF>EMP</c>"
			weaponUnit:getTraits().mode = "EMP"
			weaponUnit:getTraits().baseDamage = 0
			weaponUnit:getTraits().armorPiercing = weaponUnit:getTraits().modeEmp_AP or 0
			weaponUnit:getTraits().canSleep = nil
			weaponUnit:getTraits().canEmp = true
			sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.QED_GRIFTER.ABILITIES.SWITCH_WEAPON_MODE_EMP, unit = unit, color= cdefs.MOVECLR_DEFAULT })
		end
		simquery.LEVER_resetStatus( sim, unit, "ANY", false )
	end
}
