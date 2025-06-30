return {
	OPTIONS = {
	},

	AGENTS = {
		ROOK = {
			NAME = "Rook",
			FILE = "FILE #00-000000A-00000000",
			YEARS_OF_SERVICE = "?",
			HOMETOWN = "REDACTED",
			RESCUED = "...",
			BIO_SPOKEN = "?",

			ALT_1 = {
				FULLNAME = "REDACTED",
				CODENAME = "Rook",
				AGE = "REDACTED",
				BIO = "?",
				TOOLTIP = "Professional Spy",
			},
			ALT_2 = {
				FULLNAME = "REDACTED",
				CODENAME = "ARCHIVED - SABOTEUR",
				AGE = "REDACTED",
				BIO = "?",
				TOOLTIP = "Saboteur",
			},

			BANTER = {
				START = {
					"...",
				},
				FINAL_WORDS = {
					"...",
				},
				-- crossbanter is in a separate file
			},
		},
	},

	ABILITIES = {
		COIN_ANTE = "Ante Coin",

		MARK_RICOCHET = "Mark Ricochet",
		MARK_RICOCHET_TIP = "Mark %s",
		ALREADY_MARKED = "Already Marked",

		RICOCHET_AIM = "Begin Ricochet Aiming",
		RICOCHET_AIM_TIP = "Initiate aiming sequence for ricochet.",
		RICOCHET_AIM_AT = "Ricochet #{1}: {2}",
		RICOCHET_AIM_AT_TIP = "Add {1} to the current ricochet shot.",
		ALREADY_RICOCHET_AIMED = "Already Targeted (#{1})",
		RICOCHET_SHOOT = "Shoot Ricochet",
		RICOCHET_SHOOT_AT = "Shoot Ricochet at {1}",
		RICOCHET_SHOOT_AT_TIP = "Fire the EH1076 Pistols at {1}",

		SWITCH_WEAPON_MODE = "SWITCH FIRING MODE",
		SWITCH_WEAPON_MODE_DESC = "Switch between firing modes. Current: {1}",
		SWITCH_WEAPON_MODE_KO = "WEAPON MODE: KO",
		SWITCH_WEAPON_MODE_L = "WEAPON MODE: LETHAL",
		SWITCH_WEAPON_MODE_EMP = "WEAPON MODE: EMP",
	},

	ITEMS = {
		ROOK_PISTOLS = "EH1076 Pistols, Modified",
		ROOK_PISTOLS_TOOLTIP = "Ranged targets. Can switch between KO and Lethal damage.",
		ROOK_PISTOLS_FLAVOR = "Modular ammunition chambers allow the use of unorthodox - and even illegal - rounds. For the agency, incendiary rounds have been replaced with tranquilizers.",
		ROOK_PISTOLS_EMP = "EH1076 Pistols, Saboteur Loadout",
		ROOK_PISTOLS_EMP_TOOLTIP = "Ranged targets. EMP damage. Can also target mainframe devices.",
		ROOK_PISTOLS_EMP_FLAVOR = "When bringing down a profusion of tech, loading up on rechargeable EMP bolts is the solution.",

		ROOK_COIN = "Squad Coin",
		ROOK_COIN_TOOLTIP = "Gamble when first stepping into guards' noticed tiles. Effects do not persist to the corp's turn.\nHEADS (50%): Guards ignore seeing Rook in noticed tiles this turn.\nSNAILS (50%): One guard noticing Rook can only notice tiles this turn.",
		ROOK_COIN_FLAVOR = "Evoke: Rook is noticed.\nGamble.\nHeads: Gain Composure\nTails: Incept Doubt",
		HEADS = "HEADS",
		SNAILS = "SNAILS",
		DOUBT = "DOUBT",

		ROOK_RICOCHET = "Ricochet Shot",
		ROOK_RICOCHET_TOOLTIP = "Mark a target, then the next ranged weapon attack this turn hits that target in addition to its intended target.\nRequires line of sight at time of firing.\nNo additional ammo cost.",
		ROOK_RICOCHET_FLAVOR = "",
	},
}
