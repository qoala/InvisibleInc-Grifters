local simquery = include("sim/simquery")

function simquery.qed_isShootableDevice( unit, targetUnit )
	if targetUnit:getTraits().canBeShot then
		-- shootSingle handles viability of this target
		return false
	end
	if unit == targetUnit then
		return false
	end
	if not targetUnit:getTraits().mainframe_ice or targetUnit:getTraits().mainframe_status == "off" then
		return false
	end
	if not targetUnit:getTraits().canBeFriendlyShot and unit:getPlayerOwner() == targetUnit:getPlayerOwner() then
		return false
	end
	return true
end
