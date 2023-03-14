local TROPHY = {}
TROPHY.id = "zoey"
TROPHY.title = "Cat without a bat"
TROPHY.desc = "Buy a homerun bat before Zoey does"
TROPHY.rarity = 1

function TROPHY:Trigger()
    local alreadyBought = false
    local isPlaying = false

    self:AddHook("TTTBeginRound", function()
        isPlaying = false

        for _, ply in ipairs(player.GetAll()) do
            if ply:GetModel() == "models/luria/night_in_the_woods/playermodels/mae.mdl" or ply:GetModel() == "models/luria/night_in_the_woods/playermodels/mae_astral.mdl" and self:IsAlive(ply) then
                isPlaying = true
                break
            end
        end
    end)

    self:AddHook("TTTOrderedEquipment", function(ply, equipment, is_item)
        if not isPlaying then return end

        if not is_item and equipment == "weapon_ttt_homebat" then
            if not alreadyBought then
                self:Earn(ply)
            end

            if ply:GetModel() == "models/luria/night_in_the_woods/playermodels/mae.mdl" or ply:GetModel() == "models/luria/night_in_the_woods/playermodels/mae_astral.mdl" then
                alreadyBought = true
            end
        end
    end)
end

function TROPHY:Condition()
    return weapons.Get("weapon_ttt_homebat") ~= nil and util.IsValidModel("models/luria/night_in_the_woods/playermodels/mae.mdl")
end

RegisterTTTTrophy(TROPHY)