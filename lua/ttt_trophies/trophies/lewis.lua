local TROPHY = {}
TROPHY.id = "lewis"
TROPHY.title = "Poon reversal"
TROPHY.desc = "See Ben harpoon Lewis"
TROPHY.rarity = 2

function TROPHY:Trigger()
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if ply:GetModel() == "models/bradyjharty/yogscast/lewis.mdl" and attacker:GetModel() == "models/bradyjharty/yogscast/sharky.mdl" and IsValid(dmg:GetInflictor()) and dmg:GetInflictor():GetClass() == "hwapoon_arrow" then
            self:Earn(player.GetAll())
        end
    end)
end

function TROPHY:Condition()
    return scripted_ents.Get("hwapoon_arrow") ~= nil and util.IsValidModel("models/bradyjharty/yogscast/sharky.mdl") and util.IsValidModel("models/bradyjharty/yogscast/lewis.mdl")
end

RegisterTTTTrophy(TROPHY)