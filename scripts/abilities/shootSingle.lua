local abilitydefs = include("sim/abilitydefs")

local abil = abilitydefs.lookupAbility("shootSingle")

local oldAcquireTargets = abil.acquireTargets
function abil:acquireTargets(targets, game, sim, abilityOwner, abilityUser, ...)
    local aim = abilityOwner:hasAbility("qed_grift_ricochetAim")
    if aim and aim._hudState then
        -- Suppress normal shootSingle targets when aiming ricochet.
        return targets.unitTarget(game, {}, self, abilityOwner, abilityUser)
    end

    return oldAcquireTargets(self, targets, game, sim, abilityOwner, abilityUser, ...)
end
