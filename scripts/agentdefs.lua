local util = include( "modules/util" )
local commondefs = include( "sim/unitdefs/commondefs" )
local simdefs = include("sim/simdefs")

-- Rook
-- Cybernetic leg
-- Based on Decker/Sharp
local ROOK_SOUNDS =
{
	bio = "",
	escapeVo = "",
	speech="SpySociety/Agents/dialogue_player",
	step = simdefs.SOUNDPATH_FOOTSTEP_MALE_HARDWOOD_NORMAL,
	stealthStep = simdefs.SOUNDPATH_FOOTSTEP_MALE_HARDWOOD_SOFT,

	wallcover = "SpySociety/Movement/foley_trench/wallcover",
	crouchcover = "SpySociety/Movement/foley_trench/crouchcover",
	fall = "SpySociety/Movement/foley_trench/fall",
	fall_knee = "SpySociety/Movement/bodyfall_agent_knee_hardwood",
	fall_kneeframe = 9,
	fall_hand = "SpySociety/Movement/bodyfall_agent_hand_hardwood",
	fall_handframe = 20,
	land = "SpySociety/Movement/deathfall_agent_hardwood",
	land_frame = 35,
	getup = "SpySociety/Movement/foley_trench/getup",
	grab = "SpySociety/Movement/foley_trench/grab_guard",
	pin = "SpySociety/Movement/foley_trench/pin_guard",
	pinned = "SpySociety/Movement/foley_trench/pinned",
	peek_fwd = "SpySociety/Movement/foley_trench/peek_forward",
	peek_bwd = "SpySociety/Movement/foley_trench/peek_back",
	move = "SpySociety/Movement/foley_cyborg/move",
	hit = "SpySociety/HitResponse/hitby_ballistic_flesh",
}

-- Sal
-- based on Nika
local SAL_SOUNDS =
{
	bio = "",
	escapeVo = "",
	speech="SpySociety/Agents/dialogue_player",
	step = simdefs.SOUNDPATH_FOOTSTEP_FEMALE_HARDWOOD_NORMAL,
	stealthStep = simdefs.SOUNDPATH_FOOTSTEP_FEMALE_HARDWOOD_SOFT,

	wallcover = "SpySociety/Movement/foley_suit/wallcover",
	crouchcover = "SpySociety/Movement/foley_suit/crouchcover",
	fall = "SpySociety/Movement/foley_suit/fall",
	land = "SpySociety/Movement/deathfall_agent_hardwood",
	land_frame = 16,
	getup = "SpySociety/Movement/foley_suit/getup",
	grab = "SpySociety/Movement/foley_suit/grab_guard",
	pin = "SpySociety/Movement/foley_suit/pin_guard",
	pinned = "SpySociety/Movement/foley_suit/pinned",
	peek_fwd = "SpySociety/Movement/foley_suit/peek_forward",
	peek_bwd = "SpySociety/Movement/foley_suit/peek_back",
	move = "SpySociety/Movement/foley_suit/move",
	hit = "SpySociety/HitResponse/hitby_ballistic_flesh",
}

return {
	rook = {
		type = "simunit",
		agentID = "rook",
		name = STRINGS.QED_GRIFTER.AGENTS.ROOK.NAME,
		fullname = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.FULLNAME,
		codename = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.FULLNAME,
		loadoutName = STRINGS.UI.ON_FILE,
		file =STRINGS.QED_GRIFTER.AGENTS.ROOK.FILE,
		yearsOfService = STRINGS.QED_GRIFTER.AGENTS.ROOK.YEARS_OF_SERVICE,
		age = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.AGE,
		homeTown =  STRINGS.QED_GRIFTER.AGENTS.ROOK.HOMETOWN,
		gender = "male",
		class = "Stealth",
		toolTip = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.TOOLTIP,
		onWorldTooltip = commondefs.onAgentTooltip,
		profile_icon_36x36= "gui/profile_icons/stealth_36.png",
		profile_icon_64x64= "gui/profile_icons/stealth1_64x64.png",
		splash_image = "gui/agents/deckard_1024.png",

		team_select_img = {
			"gui/agents/team_select_1_deckard.png",
		},

		profile_anim = "portraits/stealth_guy_face",
		kanim = "kanim_stealth_male",
		hireText = STRINGS.QED_GRIFTER.AGENTS.ROOK.RESCUED,
		traits = util.extend( commondefs.DEFAULT_AGENT_TRAITS ) { mp=8, mpMax =8, },
		skills = util.extend( commondefs.DEFAULT_AGENT_SKILLS ) {},
		startingSkills = { inventory = 2 },
		abilities = util.tconcat( {  "sprint",  }, commondefs.DEFAULT_AGENT_ABILITIES ),
		children = {},
		sounds = ROOK_SOUNDS,
		speech = STRINGS.QED_GRIFTER.AGENTS.ROOK.BANTER,
		blurb = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.BIO,
		upgrades = {"augment_rook_overchargecells", "item_tazer", "item_rook_pistols"},
	},

	rook_a = {
		type = "simunit",
		agentID = "rook",
		name = STRINGS.QED_GRIFTER.AGENTS.ROOK.NAME,
		fullname = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_1.FULLNAME,
		codename = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_2.FULLNAME,
		loadoutName = STRINGS.UI.ON_ARCHIVE,
		file =STRINGS.QED_GRIFTER.AGENTS.ROOK.FILE,
		yearsOfService = STRINGS.QED_GRIFTER.AGENTS.ROOK.YEARS_OF_SERVICE,
		age = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_2.AGE,
		homeTown =  STRINGS.QED_GRIFTER.AGENTS.ROOK.HOMETOWN,
		gender = "male",
		class = "Stealth",
		toolTip = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_2.TOOLTIP,
		onWorldTooltip = commondefs.onAgentTooltip,
		profile_icon_36x36= "gui/profile_icons/stealth_36.png",
		profile_icon_64x64= "gui/profile_icons/stealth1_64x64.png",
		splash_image = "gui/agents/deckard_1024.png",

		team_select_img = {
			"gui/agents/team_select_1_deckard.png",
		},

		profile_anim = "portraits/stealth_guy_face",
		kanim = "kanim_stealth_male",
		hireText = STRINGS.QED_GRIFTER.AGENTS.ROOK.RESCUED,
		traits = util.extend( commondefs.DEFAULT_AGENT_TRAITS ) { mp=8, mpMax =8, },
		skills = util.extend( commondefs.DEFAULT_AGENT_SKILLS ) {},
		startingSkills = { inventory = 2 },
		abilities = util.tconcat( {  "sprint",  }, commondefs.DEFAULT_AGENT_ABILITIES ),
		children = {},
		sounds = ROOK_SOUNDS,
		speech = STRINGS.QED_GRIFTER.AGENTS.ROOK.BANTER,
		blurb = STRINGS.QED_GRIFTER.AGENTS.ROOK.ALT_2.BIO,
		upgrades = {"item_rook_pistols", "item_rook_coin"},
	},

	-- sal = {
	-- },
}
