local TROPHY = {}
TROPHY.id = "whataretherules"
TROPHY.title = "WHAT ARE THE RULES?"
TROPHY.desc = "As a traitor, win a round with 6 or randomats active"
TROPHY.rarity = 3
local enoughRandomatsTriggered = false

-- Work around for the TTTRandomatCommand hook only accepting added hooks before the randomat base is run (during when autorun files are being loaded)
if SERVER then
    hook.Add("TTTRandomatTriggered", "TTTTrophiesAdminAbuse", function()
        if #Randomat.ActiveEvents >= 6 then
            enoughRandomatsTriggered = true
        end
    end)
end

function TROPHY:Trigger()
    self:AddHook("TTTEndRound", function(result)
        if enoughRandomatsTriggered and result == WIN_TRAITOR then
            for _, ply in ipairs(player.GetAll()) do
                if TTTTrophies:IsTraitorTeam(ply) then
                    self:Earn(ply)
                end
            end
        end

        enoughRandomatsTriggered = false
    end)
end

-- Look for a convar specific to Mal's version of the randomat
-- (Yea I know I should use engine.GetAddons() but this is cheaper and there are no old clones of Mal's mod with this convar on the workshop and without the TTTRandomatCommand hook)
function TROPHY:Condition()
    return ConVarExists("ttt_randomat_allow_client_list")
end

RegisterTTTTrophy(TROPHY)