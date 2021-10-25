local simengine = include("sim/engine")
local simquery = include("sim/simquery")

local oldTryShootAt = simengine.tryShootAt

function simengine:tryShootAt( sourceUnit, targetUnit, dmgt0, equipped, ... )
	local ret = oldTryShootAt( self, sourceUnit, targetUnit, dmgt0, equipped, ... )

	local ricochetTargetID = sourceUnit:getTraits().qed_rook_ricochetTargetID
	if ricochetTargetID then
		sourceUnit:getTraits().qed_rook_ricochetTargetID = nil
		local ricochetTarget = self:getUnit(ricochetTargetID)
		if ricochetTarget and (ricochetTarget ~= targetUnit) and self:canUnitSeeUnit( sourceUnit, ricochetTarget )
				and (ricochetTarget:getTraits().canBeShot or (equipped:getTraits().qed_canShootDevices and simquery.qed_isShootableDevice(sourceUnit, ricochetTarget))) then
			oldTryShootAt( self, sourceUnit, ricochetTarget, dmgt0, equipped, ... )
		end
	end

	return ret
end
