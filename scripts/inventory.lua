local inventory = include("sim/inventory")

local oldUseItem = inventory.useItem
function inventory.useItem( sim, unit, item, ... )
	local ret = oldUseItem( sim, unit, item, ... )

	if item:getTraits().cooldown then
		local abilityDef, augment = unit:ownsAbility("qed_rook_overchargeUse")
		if abilityDef then
			abilityDef:executeAbility( sim, augment, unit, item )
		end
	end

	return ret
end
