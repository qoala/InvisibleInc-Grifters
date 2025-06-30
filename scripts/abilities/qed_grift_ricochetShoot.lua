local array = include("modules/array")
local util = include("modules/util")
local cdefs = include("client_defs")
local abilitydefs = include("sim/abilitydefs")
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include("sim/abilities/abilityutil")
local inventory = include("sim/inventory")
local serverdefs = include("modules/serverdefs")

local shootSingle = abilitydefs.lookupAbility("shootSingle")

local abil = {
    name = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT,
    profile_icon = "gui/icons/action_icons/Action_icon_Small/icon-item_shoot_small.png",
    usesAction = true,

    _aim = nil,
}
function abil:getName(sim, abilityOwner, abilityUser, targetID)
    local target = sim:getUnit(targetID)
    if target then
        return util.sformat(STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT_AT, target:getName())
    else
        return self.name
    end
end
function abil:createToolTip(sim, abilityOwner, abilityUser, targetID)
    local target = sim:getUnit(targetID)
    local headerTxt = util.sformat(
            STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT_AT, target:getName())
    local bodyTxt = util.sformat(
            STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT_AT_TIP, target:getName())
    return abilityutil.formatToolTip(headerTxt, bodyTxt)
end
function abil:onSpawnAbility(sim, abilityOwner)
    self._aim = abilityOwner:hasAbility("qed_grift_ricochetAim")
    if not self._aim then
        -- Should never happen.
        simlog("[QED_GRIFT][ERROR] ricochetShoot without ricochetAim ability")
    end
end
function abil:onDespawnAbility(sim, abilityOwner)
    self._aim = nil
end
function abil:acquireTargets(targets, game, sim, abilityOwner, abilityUser)
    if not self._aim then
        -- Should never happen.
        return targets.unitTarget(game, {}, self, abilityOwner, abilityUser)
    end
    local hs = self._aim._hudState
    if not hs or hs.count == 0 then
        -- Insufficient aimed targets. Show no targets.
        local targeter = targets.unitTarget(game, {}, self, abilityOwner, abilityUser)
        return self._aim:_patchEndTargeting(targeter)
    end

    -- Show existing aimed targets.
    -- The most recently aimed target will be active.
    local units = {}
    for id, _ in pairs(hs.targets) do
        local target = sim:getUnit(id)
        table.insert(units, target)
    end
    local targeter = targets.unitTarget(game, units, self, abilityOwner, abilityUser, true)
    return self._aim:_patchEndTargeting(targeter)
end
function abil:canUseAbility(sim, abilityOwner, abilityUser, targetID)
    local weapon = simquery.getEquippedGun(abilityUser)
    if not targetID then
        -- Indicate whether or not the ability is usable before acquiring targets
        local hs = self._aim and self._aim._hudState
        if not hs or hs.count < 1 then
            -- ricochetAim is used to start targeting.
            -- Until its HUD is active, this ability is hidden.
            return false
        end
        if not weapon then
            return false, STRINGS.UI.REASON.NO_GUN
        end
        local ok, reason = abilityutil.canConsumeAmmo(sim, weapon)
        if not ok then
            return false, reason
        end
        if weapon:getTraits().usesCharges and weapon:getTraits().charges < 1 then
            return false, STRINGS.UI.REASON.CHARGE
        end
        if abilityUser:getAP() < 1 then
            return false, STRINGS.UI.REASON.ATTACK_USED
        end
        return true
    end

    -- Only usable on the most recent target
    local hs = self._aim and self._aim._hudState
    if not hs then
        return false
    end
    local currentPos = hs.targets[targetID]
    if currentPos == hs.count then
        return true
    else
        return false, util.sformat(STRINGS.QED_GRIFTER.ABILITIES.ALREADY_RICOCHET_AIMED, currentPos)
    end
end
function abil:shouldHudExecute(hud, sim, abilityOwner, abilityUser, targetID)
    return self._aim:_prepareFinalTargets(self)
end
function abil:executeAbility(sim, abilityOwner, abilityUser, finalTargetID, targetIDs)
    for _, id in ipairs(targetIDs) do
        -- TODO: ricochet animation and correct aiming facing.
        local unit = sim:getUnit(id)
        simlog(
                "[QED_GRIFT][INFO] Ricochet shot through %s[%s]", unit and unit:getName() or "nil",
                id)
    end
    -- Shoot the target.
    do
        local unit = sim:getUnit(finalTargetID)
        simlog(
                "[QED_GRIFT][INFO] Ricochet shot at %s[%s]", unit and unit:getName() or "nil",
                finalTargetID)
    end
    shootSingle.executeAbility(self, sim, abilityOwner, abilityUser, finalTargetID)
end

return abil
