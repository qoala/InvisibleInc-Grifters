local Senses = include("sim/btree/senses")
local simdefs = include("sim/simdefs")

local oldAddInterest = Senses.addInterest

function Senses:addInterest(x, y, sense, reason, sourceUnit, ignoreDisguies, ...)
	if sourceUnit and sense == simdefs.SENSE_PERIPHERAL and reason == simdefs.REASON_SENSEDTARGET then
		local sim = self.unit:getSim()
		local abilityDef, item = sourceUnit:ownsAbility("qed_grift_coinAnte")
		if abilityDef and sourceUnit:canUseAbility( sim, abilityDef, item ) then
			abilityDef:executeAbility( sim, item, sourceUnit, self.unit:getID() )
		end

		if sourceUnit:getTraits().qed_peripheralIgnored then
			return
		end
	end

	return oldAddInterest(self, x, y, sense, reason, sourceUnit, ignoreDisguies, ...)
end
