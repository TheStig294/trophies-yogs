local TROPHY = {}
TROPHY.id = "rythian"
TROPHY.title = "Barrel justice!"
TROPHY.desc = "See Rythian kill someone with barrel justice"
TROPHY.rarity = 2

function TROPHY:Trigger()
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if attacker:GetModel() ~= "models/player_phoenix.mdl" then return end

        if dmg:GetInflictor() and dmg:GetInflictor():GetModel() == "models/props_c17/oildrum001_explosive.mdl" then
            self:Earn(player.GetAll())
        end
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/player_phoenix.mdl")
end

RegisterTTTTrophy(TROPHY)