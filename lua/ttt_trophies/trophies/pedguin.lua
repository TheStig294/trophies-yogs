local TROPHY = {}
TROPHY.id = "pedguin"
TROPHY.title = "Barrel for Ped"
TROPHY.desc = "Prop-kill Pedguin, or as Pedguin, get prop-killed"
TROPHY.rarity = 3

function TROPHY:Trigger()
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        local infilctor = dmg:GetInflictor()
        if not IsPlayer(attacker) or not IsValid(infilctor) then return end

        if string.Left(infilctor:GetClass(), 12) == "prop_physics" and (ply:GetModel() == "models/kaesar/buffwinniethepooh/buffwinniethepooh.mdl" or ply:GetModel() == "models/kaesar/buffwinniethepooh/buffwinniethepooh2.mdl") then
            self:Earn({attacker, ply})
        end
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/kaesar/buffwinniethepooh/buffwinniethepooh.mdl")
end

RegisterTTTTrophy(TROPHY)