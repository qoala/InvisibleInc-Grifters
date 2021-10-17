local simengine = include("sim/engine")
local simquery = include("sim/simquery")

local oldTryShootAt = simengine.tryShootAt

function simengine:tryShootAt( sourceUnit, targetUnit, dmgt0, equipped, ... )
	local chargedShot = false
	if sourceUnit:hasTrait("qed_charged_shot") then
		local dmgt = simquery.calculateShotSuccess( self, sourceUnit, targetUnit, equipped )
		chargedShot = dmgt.damage and dmgt.damage > 0
	end

	local ret = oldTryShootAt( self, sourceUnit, targetUnit, dmgt0, equipped, ... )

	-- Only apply if shot deals damage (KO or lethal)
	if chargedShot then
		local abilityDef, augment = sourceUnit:ownsAbility("qed_charged_shot")
		abilityDef:executeAbility( self, augment, sourceUnit )
	end

	return ret
end
