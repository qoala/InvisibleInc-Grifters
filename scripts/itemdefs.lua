local util = include( "modules/util" )
local commondefs = include( "sim/unitdefs/commondefs" )
local simdefs = include("sim/simdefs")

return {
	augment_rook_ricochet = util.extend( commondefs.augment_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_RICOCHET,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_RICOCHET_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_RICOCHET_FLAVOR,
		traits = {
			installed = true,
			addAbilities = "qed_grift_markRicochet",
		},
		profile_icon = "gui/icons/skills_icons/skills_icon_small/icon-item_augment_shalem_small.png",
		profile_icon_100 = "gui/icons/skills_icons/icon-item_augment_shalem.png",
	},

	item_rook_coin = util.extend( commondefs.item_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_COIN,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_COIN_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_COIN_FLAVOR,
		icon = "itemrigs/FloorProp_AmmoClip.png",
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_chip_accellerator_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_chip_accellerator.png",
		traits = {
			cooldown = 0,
			cooldownMax = 3,
			restrictedUse={{agentID="rook",name=STRINGS.QED_GRIFTER.AGENTS.ROOK.NAME}},
		},
		abilities = { "carryable", "qed_grift_coinAnte" },
		value = 100,
	},

	item_rook_pistols = util.extend( commondefs.weapon_reloadable_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_FLAVOR,
		traits = {
			weaponType="pistol",
			baseDamage = 2,
			canSleep = true,
			ammo = 2,
			maxAmmo = 2,
			modeKOdamage = 2,
			modeLdamage = 1,
			mode = "KO",
			qed_ricochetLimit = 3,
		},
		abilities = util.tconcat( commondefs.weapon_reloadable_template.abilities, { "qed_grift_switchWeaponMode", "qed_grift_ricochetAim", "qed_grift_ricochetShoot" }),
		icon = "itemrigs/FloorProp_Pistol.png",
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_gun_pistol_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_gun_pistol.png",
		equipped_icon = "gui/items/equipped_pistol.png",
		sounds = {shoot="SpySociety/Weapons/LowBore/shoot_handgun_silenced", reload="SpySociety/Weapons/LowBore/reload_handgun", use="SpySociety/Actions/item_pickup", shell="SpySociety/Weapons/Shells/shell_handgun_wood"},
		weapon_anim = "kanim_light_revolver",
		agent_anim = "anims_1h",
		value = 700,
	},

	item_rook_pistols_emp = util.extend( commondefs.weapon_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_EMP,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_EMP_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_EMP_FLAVOR,
		traits = {
			weaponType="pistol",
			usesCharges = true,
			charges = 2,
			chargesMax = 2,
			baseDamage = 0,
			qed_canShootDevices = true,
			canEmp = true,
			modeEmpdamage = 2,
			armorPiercing = 1,
		},
		abilities = util.tconcat( commondefs.weapon_template.abilities, { "recharge", "qed_grift_shootDevice" }),
		icon = "itemrigs/FloorProp_Pistol.png",
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_gun_pistol_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_gun_pistol.png",
		equipped_icon = "gui/items/equipped_pistol.png",
		sounds = {shoot="SpySociety/Weapons/LowBore/shoot_handgun_silenced", reload="SpySociety/Weapons/LowBore/reload_handgun", use="SpySociety/Actions/item_pickup", shell="SpySociety/Weapons/Shells/shell_handgun_wood"},
		weapon_anim = "kanim_light_revolver",
		agent_anim = "anims_1h",
		value = 700,
	},
}
