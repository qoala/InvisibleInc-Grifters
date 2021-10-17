return {
	OPTIONS = {
	},

	AGENTS = {
		ROOK = {
			NAME = "Rook",
			FILE = "FILE #00-000000A-00000000",
			YEARS_OF_SERVICE = "?",
			HOMETOWN = "?",
			RESCUED = "...",
			BIO_SPOKEN = "?",

			ALT_1 = {
				FULLNAME = "Unknown",
				AGE = "?",
				BIO = "?",
				TOOLTIP = "Professional Spy",
			},
			ALT_2 = {
				FULLNAME = "Unknown",
				AGE = "?",
				BIO = "?",
				TOOLTIP = "Aerostat Soldier",
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
		CHARGED_SHOT = "Overchage Shot",
	},

	ITEMS = {
		ROOK_PISTOLS = "EH1076 Pistols, Modified",
		ROOK_PISTOLS_TOOLTIP = "Ranged targets. Lethal damage.",
		ROOK_PISTOLS_FLAVOR = "Modular ammunition chambers allow the use of unorthodox - and even illegal - rounds.",

		ROOK_COIN = "Squad Coin",
		ROOK_COIN_TOOLTIP = "Gain a buff for 2 turns.\nHeads: Guards do not notice Rook in peripheral vision.\nSnails: Guards that notice Rook expose additional credits (once each).",
		ROOK_COIN_FLAVOR = "",

		ROOK_CHARGECELLS = "Overcharge Cells",
		ROOK_CHARGECELLS_TOOLTIP = "Consumes charges on ranged lethal/KO attack for +1 armor piercing and +1 KO damage.\nAgent's base AP is reduced by 1, but gains 1 for each charge below max.",
		ROOK_CHARGECELLS_FLAVOR = "These early charge cells overcharge a wide variety of weapons. Stray discharge has an adverse effect on muscle movement until spent.",

	},
}
