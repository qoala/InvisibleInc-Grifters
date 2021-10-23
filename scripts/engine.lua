local simengine = include("sim/engine")
local simquery = include("sim/simquery")

local oldTryShootAt = simengine.tryShootAt

function simengine:tryShootAt( sourceUnit, targetUnit, dmgt0, equipped, ... )
	local chargedShot = false
	if sourceUnit:hasTrait("qed_rook_chargedShot") then
		local dmgt = simquery.calculateShotSuccess( self, sourceUnit, targetUnit, equipped )
		chargedShot = dmgt.damage and dmgt.damage > 0
	end

	local ret = oldTryShootAt( self, sourceUnit, targetUnit, dmgt0, equipped, ... )

	local ricochetTargetID = sourceUnit:getTraits().qed_rook_ricochetTargetID
	if ricochetTargetID then
		sourceUnit:getTraits().qed_rook_ricochetTargetID = nil
		local ricochetTarget = self:getUnit(ricochetTargetID)
		if ricochetTarget and (ricochetTarget ~= targetUnit) and self:canUnitSeeUnit( sourceUnit, ricochetTarget ) then
			oldTryShootAt( self, sourceUnit, ricochetTarget, dmgt0, equipped, ... )
		end
	end

	-- Only apply if shot deals damage (KO or lethal)
	if chargedShot then
		local abilityDef, augment = sourceUnit:ownsAbility("qed_rook_chargedShot")
		abilityDef:executeAbility( self, augment, sourceUnit )
	end

	return ret
end
