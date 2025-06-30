local array = include("modules/array")
local mathutil = include("modules/mathutil")
local util = include("modules/util")
local cdefs = include("client_defs")
local abilitydefs = include("sim/abilitydefs")
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include("sim/abilities/abilityutil")
local inventory = include("sim/inventory")
local serverdefs = include("modules/serverdefs")

local abil = {
    name = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM,
    profile_icon = "gui/icons/skills_icons/skills_icon_small/icon-item_accuracy_small.png",
    _shoot_profile_icon = "gui/icons/action_icons/Action_icon_Small/icon-item_shoot_small.png",
    -- A lie, but usesAction colors the icon to indicate it'll (eventually) spend an attack.
    usesAction = true,

    _hudState = nil,
}
function abil:getName(sim, abilityOwner, abilityUser, targetID)
    local target = sim:getUnit(targetID)
    if target and self._hudState then
        return util.sformat(
                STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM_AT, self._hudState.count + 1,
                target:getName())
    else
        return self.name
    end
end
function abil:createToolTip(sim, abilityOwner, abilityUser, targetID)
    local target = sim:getUnit(targetID)
    local headerTxt, bodyTxt
    if not self._hudState or not target then
        headerTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM
        bodyTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM_TIP
    elseif self._hudState.count + 1 < abilityOwner:getTraits().qed_ricochetLimit then
        headerTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM_AT
        bodyTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_AIM_AT_TIP
        headerTxt = util.sformat(headerTxt, self._hudState.count + 1, target:getName())
        bodyTxt = util.sformat(bodyTxt, target:getName())
    else
        -- Aiming at the last target automatically fires
        headerTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT_AT
        bodyTxt = STRINGS.QED_GRIFTER.ABILITIES.RICOCHET_SHOOT_AT_TIP
        headerTxt = util.sformat(headerTxt, target:getName())
        bodyTxt = util.sformat(bodyTxt, target:getName())
    end
    if targetID then
        local ret, reason = self:canUseAbility(sim, abilityOwner, abilityUser, targetID)
        if not ret then
            if reason == nil then
                reason = "nil"
            elseif reason == false then
                reason = "false"
            end
        end
    end
    return abilityutil.formatToolTip(headerTxt, bodyTxt)
end
function abil:getProfileIcon(sim, abilityOwner, abilityUser, hasTarget)
    if not self._hudState or self._hudState.count + 1 < abilityOwner:getTraits().qed_ricochetLimit then
        return self.profile_icon
    else
        -- Aiming at the last target automatically fires
        return self._shoot_profile_icon
    end
end
function abil:acquireTargets(targets, game, sim, abilityOwner, abilityUser)
    if not self._hudState then
        -- Not yet aiming => Show button normally.
        return nil
    end
    local weapon = simquery.getEquippedGun(abilityUser)
    local player = abilityUser:getPlayerOwner()
    if not weapon or not player then
        -- No valid targets.
        return self:_patchEndTargeting(
                targets.unitTarget(game, {}, self, abilityOwner, abilityUser))
    end
    -- Identify and return targets.
    local units = {}
    for _, target in pairs(player:getSeenUnits()) do
        local existingPosition = self._hudState and self._hudState.targets[target:getID()]
        if existingPosition then
            -- Already-marked targets are displayed by ricochetShoot
        elseif simquery.isShootable(abilityUser, target) and self:_canSee(sim, abilityUser, target) then
            table.insert(units, target)
        end
    end
    return self:_patchEndTargeting(
            targets.unitTarget(
                    game, units, self, abilityOwner, abilityUser, true))
end
function abil:canUseAbility(sim, abilityOwner, abilityUser, targetID)
    local weapon = simquery.getEquippedGun(abilityUser)
    local player = abilityUser:getPlayerOwner()
    if not targetID then
        -- Indicate whether or not the ability is usable before acquiring targets
        if not player then
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
        if self._hudState and self._hudState.count >= abilityOwner:getTraits().qed_ricochetLimit then
            return false
        end
        return true
    end

    local target = sim:getUnit(targetID)
    if not target then
        return false
    end
    -- if self._hudState and self._hudState.targets[targetID] then
    --     return false, util.sformat(
    --             STRINGS.QED_GRIFTER.ABILITIES.ALREADY_RICOCHET_AIMED,
    --             self._hudState.targets[targetID])
    -- end
    if not simquery.isShootable(abilityUser, target) then
        return false, STRINGS.UI.REASON.INVALID_TARGET
    end
    if not self:_canSee(sim, abilityUser, target) then
        return false, STRINGS.UI.REASON.BLOCKED
    end
    return true
end
function abil:shouldHudExecute(hud, sim, abilityOwner, abilityUser, targetID)
    if not self._hudState then
        -- Initiate targeting.
        self:_initHudState()
        return nil
    end
    local target = sim:getUnit(targetID)
    if not target then
        -- Should never happen
        simlog("[QED_GRIFT][ERROR] shouldHudExecute: missing target.")
        return nil
    end

    -- Add the selected target into the state's list.
    local hs = self._hudState
    hs.count = hs.count + 1
    hs.targets[targetID] = hs.count
    hs.lastX, hs.lastY = target:getLocation()

    if hs.count >= abilityOwner:getTraits().qed_ricochetLimit then
        -- Aiming at the last target automatically fires
        local shotAbility = abilityOwner:hasAbility("qed_grift_ricochetShoot")
        if not shotAbility then
            -- Should never happen
            simlog("[QED_GRIFT][ERROR] ricochetShoot missing.")
            return true
        end
        return self:_prepareFinalTargets(shotAbility)
    end
end
function abil:executeAbility()
    -- Should never happen
    simlog("[QED_GRIFT][ERROR] ricochetAim should never reach executeAbility.")
end

function abil:_canSee(sim, unit, target, range)
    if self._hudState and self._hudState.lastX then
        -- Targeting comes from latest ricochet cell, not unit.
        -- So first: LOS-independent sight check
        if not simquery.couldUnitSee(sim, unit, target, true) then
            return false
        end
        -- Second: LOS-check from latest bounce to target.
        local x0, y0 = self._hudState.lastX, self._hudState.lastY
        local x1, y1 = target:getLocation()
        if not x1 then
            return false
        end
        if range and mathutil.dist2d(x0, y0, x1, y1) > range then
            return false
        end
        local xRay, yRay = sim:getLOS():raycast(x0, y0, x1, y1)
        return xRay == x1 and yRay == y1
    end
    -- Start of targeting: Normal sight rules.
    return sim:canUnitSeeUnit(unit, target)
end
function abil:_initHudState()
    self._hudState = {
        -- Targets: key=targetID, value=listPosition
        -- This is for both convenient contains-key lookup and tracking the selection order.
        targets = {},
        count = 0,
    }
end
function abil:_resetHudState()
    self._hudState = nil
end
function abil:_prepareFinalTargets(shotAbility)
    local hs = self._hudState
    self._hudState = nil
    -- Transpose the targets map into a list of target IDs, recreating the selection order.
    local targetIDs, finalTargetID = {}, nil
    for id, position in pairs(hs.targets) do
        if position < hs.count then
            targetIDs[position] = id
        elseif position == hs.count then
            finalTargetID = id
        end
    end
    return { --
        ability = shotAbility,
        targets = {finalTargetID, targetIDs},
    }
end
-- Different 'self' to avoid name collision with inner patch
abil._patchEndTargeting = function(aimAbility, targeter)
    if not aimAbility._hudState then
        return targeter
    end
    local currentCount = aimAbility._hudState.count
    local oldEndTargeting = targeter.endTargeting
    function targeter:endTargeting(...)
        if aimAbility._hudState and aimAbility._hudState.count == currentCount then
            aimAbility:_resetHudState()
        end
        oldEndTargeting(self, ...)
    end
    return targeter
end

return abil
