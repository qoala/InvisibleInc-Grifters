local util = include( "modules/util" )
local commondefs = include( "sim/unitdefs/commondefs" )
local simdefs = include("sim/simdefs")

return {
	augment_rook_overchargecells = util.extend( commondefs.augment_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_OVERCHARGECELLS,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_OVERCHARGECELLS_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_OVERCHARGECELLS_FLAVOR,
		traits = {
			installed = true,
			usesCharges = true,
			charges = 2,
			chargesMax = 3,
			modTrait = {{"mpMax",-0.5}},
			-- simunit:countAugments counts this as Torque Injectors
			-- TODO: use a trait for this, otherwise can install Torque Injectors iff charges = 0
			augment_torque_injectors = true,
		},
		abilities = util.tconcat( commondefs.augment_template.abilities, { "qed_rook_overchargeUse", "qed_rook_overchargeCharge" }),
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_generic_torso_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_generic_torso.png",
	},
	augment_rook_chargedshot = util.extend( commondefs.augment_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_CHARGEDSHOT,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_CHARGEDSHOT_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_CHARGEDSHOT_FLAVOR,
		traits = {
			installed = true,
			usesCharges = true,
			charges = 3,
			chargesMax = 3,
			addArmorPiercingRanged = 1,
			addTrait = {{"qed_charged_shot", true}},
			modTrait = {{"rangedKO_bonus", 1}, {"mpMax",-1}},
		},
		abilities = util.tconcat( commondefs.augment_template.abilities, { "qed_charged_shot" }),
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_generic_torso_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_generic_torso.png",
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
		abilities = { "carryable" },
		value = 100,
	},

	item_rook_pistols = util.extend( commondefs.weapon_reloadable_template ) {
		name = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS,
		desc = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_TOOLTIP,
		flavor = STRINGS.QED_GRIFTER.ITEMS.ROOK_PISTOLS_FLAVOR,
		icon = "itemrigs/FloorProp_Pistol.png",
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_gun_pistol_small.png",
		profile_icon_100 = "gui/icons/item_icons/icon-item_gun_pistol.png",
		equipped_icon = "gui/items/equipped_pistol.png",
		traits = { weaponType="pistol", baseDamage = 1, ammo = 2, maxAmmo = 2,},
		sounds = {shoot="SpySociety/Weapons/LowBore/shoot_handgun_silenced", reload="SpySociety/Weapons/LowBore/reload_handgun", use="SpySociety/Actions/item_pickup", shell="SpySociety/Weapons/Shells/shell_handgun_wood"},
		weapon_anim = "kanim_light_revolver",
		agent_anim = "anims_1h",
		value = 700,
	},
}
