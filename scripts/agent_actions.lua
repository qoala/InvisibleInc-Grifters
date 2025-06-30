local agent_actions = include("hud/agent_actions")

local oldPerformAbility = agent_actions.performAbility
function agent_actions.performAbility(game, abilityOwner, abilityUser, ability, ...)
    local targetArgs = {...}
    -- shouldHudExecute is called just before an ability would be performed, (The ... is whatever
    -- target data is passed to executeAbility)
    -- * If this fn returns nil or false, then the HUD is refreshed and the ability is NOT executed.
    --   * If the ability already refreshed/transitioned the HUD, a second output arg, skipRefresh,
    --     can be returned as true. In this case, the mod won't autorefresh the HUD.
    -- * If it returns true, the ability is performed immediately, as clicked. 
    --   In this case, the ability MUST NOT use any HUD state it may have tracked, unless that state
    --   is already stored in the target arguments passed from the targeter towards executeAbility.
    -- * If it returns a table, data, its fields will be used to replace portions of the current
    --   ability execution before recording this action to the sim.
    --   This is the intended path for multi-state abilities.
    --   * data.targets: switch the ability targets. Should be a list.
    --     Will be unpacked into the executeAbility args.
    --   * data.ability, data.abilityUser, data.abilityOwner: switch the ability being used
    --     and/or the units involved. The ability MUST be an ability on the owner, and the
    --     full set of args MUST already satisfy canUseAbility. The HUD won't verify canUse again.
    --
    -- This allows for generalized checks similar to abil.confirmAbility(), used by escape and
    -- lastWords, but also allows for multi-step actions to be tracked within the HUD before
    -- anything is recorded to sim history by performing an action.
    if ability.shouldHudExecute then
        local shouldPerformData, skipRefresh = ability:shouldHudExecute(game.hud, game.simCore, abilityOwner, abilityUser, ...)
        if not shouldPerformData then
            if not skipRefresh then
                game.hud:refreshHud()
            end
            return false
        elseif type(shouldPerformData) == "table" then
            if shouldPerformData.targets then
                targetArgs = shouldPerformData.targets
            end
            if shouldPerformData.ability then
                ability = shouldPerformData.ability
            end
            if shouldPerformData.abilityUser then
                abilityUser = shouldPerformData.abilityUser
            end
            if shouldPerformData.abilityOwner then
                abilityOwner = shouldPerformData.abilityOwner
            end
        end
    end
    return oldPerformAbility(game, abilityOwner, abilityUser, ability, unpack(targetArgs))
end
