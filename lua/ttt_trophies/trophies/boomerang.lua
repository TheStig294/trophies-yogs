local TROPHY = {}
TROPHY.id = "boomerang"
TROPHY.title = "1-shot if it hits you twice!"
TROPHY.desc = "Kill Zylus in 1 shot of a boomerang, or as Zylus, be killed in one shot"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local boomerangEnt

    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        local inflictor = dmg:GetInflictor()
        if not took or not IsValid(inflictor) or inflictor:GetClass() ~= "ent_boomerangclose_randomat" then return end
        if not IsValid(ent) or not ent:IsPlayer() then return end
        if ent:GetModel() ~= "models/player/jenssons/kermit.mdl" then return end
        local attacker = dmg:GetAttacker()
        if not IsValid(attacker) or not attacker:IsPlayer() then return end
        -- Only keep track of the last boomerang that hit Zylus
        boomerangEnt = inflictor
    end)

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if ply:GetModel() ~= "models/player/jenssons/kermit.mdl" then return end
        local inflictor = dmg:GetInflictor()
        if not IsValid(inflictor) or not IsValid(attacker) or not attacker:IsPlayer() then return end

        -- If the same boomerang that originally damaged Zylus kills him, the attacker earns the trophy
        if inflictor:GetClass() == "ent_boomerangclose_randomat" and IsValid(boomerangEnt) and inflictor == boomerangEnt then
            self:Earn({attacker, ply})
        end
    end)

    self:AddHook("TTTEndRound", function()
        boomerangEnt = nil
    end)
end

function TROPHY:Condition()
    return ConVarExists("ttt_randomat_boomerang") and GetConVar("ttt_randomat_boomerang"):GetBool() and util.IsValidModel("models/player/jenssons/kermit.mdl")
end

RegisterTTTTrophy(TROPHY)