local TROPHY = {}
TROPHY.id = "pedguin"
TROPHY.title = "Barrel for Ped"
TROPHY.desc = "Prop-kill Pedguin while he isn't on your team"
TROPHY.rarity = 3

function TROPHY:Trigger()
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        local infilctor = dmg:GetInflictor()
        if not IsPlayer(attacker) or not IsValid(infilctor) then return end
        if attacker.IsSameTeam and attacker:IsSameTeam(ply) then return end

        if string.Left(infilctor:GetClass(), 12) == "prop_physics" and ply:GetModel() == "models/kaesar/buffwinniethepooh/buffwinniethepooh.mdl" then
            self:Earn(attacker)
        end
    end)
end

function TROPHY:Condition()
    return CR_VERSION and util.IsValidModel("models/kaesar/buffwinniethepooh/buffwinniethepooh.mdl")
end

RegisterTTTTrophy(TROPHY)