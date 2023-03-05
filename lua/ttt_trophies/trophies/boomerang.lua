local TROPHY = {}
TROPHY.id = "boomerang"
TROPHY.title = "It's a 1-shot if it hits you twice!"
TROPHY.desc = "Kill Zylus in 1 shot of a boomerang"
TROPHY.rarity = 3

-- Trophy trigger function only runs when the boomerang randomat is triggered
hook.Add("TTTRandomatTriggered", "TTTTrophiesBoomerang", function(id)
    if id == "boomerang" then
        TROPHY:Trigger(true)
    end
end)

function TROPHY:Trigger(boomerangTriggered)
    local boomerangEnt

    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if not boomerangTriggered then return end
        if not took or not IsValid(ent) or not ent:IsPlayer() then return end
        if ent:GetModel() ~= "models/player/jenssons/kermit.mdl" then return end
        local inflictor = dmg:GetInflictor()
        local attacker = dmg:GetAttacker()
        if not IsValid(inflictor) or not IsValid(attacker) or not attacker:IsPlayer() then return end

        -- Only keep track of the last boomerang that hit Zylus
        if inflictor:GetClass() == "ent_boomerangclose_randomat" then
            boomerangEnt = inflictor
        end
    end)

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if not boomerangTriggered then return end
        if ply:GetModel() ~= "models/player/jenssons/kermit.mdl" then return end
        local inflictor = dmg:GetInflictor()
        if not IsValid(inflictor) or not IsValid(attacker) or not attacker:IsPlayer() then return end

        -- If the same boomerang that originally damaged Zylus kills him, the attacker earns the trophy
        if inflictor:GetClass() == "ent_boomerangclose_randomat" and IsValid(boomerangEnt) and inflictor == boomerangEnt then
            self:Earn(attacker)
        end
    end)

    self:AddHook("TTTEndRound", function()
        boomerangEnt = nil
        boomerangTriggered = false
    end)
end

function TROPHY:Condition()
    return ConVarExists("ttt_randomat_boomerang") and GetConVar("ttt_randomat_boomerang"):GetBool() and util.IsValidModel("models/player/jenssons/kermit.mdl")
end

RegisterTTTTrophy(TROPHY)