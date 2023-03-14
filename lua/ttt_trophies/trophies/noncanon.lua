local TROPHY = {}
TROPHY.id = "noncanon"
TROPHY.title = "Non-canon round"
TROPHY.desc = "Win as a traitor while detective Zylus isn't on your team, as Zylus, see this"
TROPHY.rarity = 2

function TROPHY:Trigger()
    self:AddHook("TTTEndRound", function(result)
        if result == WIN_TRAITOR then
            local nonCanonRound = false

            for _, ply in ipairs(player.GetAll()) do
                if ply:GetModel() == "models/player/jenssons/kermit.mdl" and TTTTrophies:IsGoodDetectiveLike(ply) then
                    nonCanonRound = true
                    break
                end
            end

            if nonCanonRound then
                for _, ply in ipairs(player.GetAll()) do
                    if TTTTrophies:IsTraitorTeam(ply) or ply:GetModel() == "models/player/jenssons/kermit.mdl" then
                        self:Earn(ply)
                    end
                end
            end
        end
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/player/jenssons/kermit.mdl")
end

RegisterTTTTrophy(TROPHY)