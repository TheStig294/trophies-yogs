local TROPHY = {}
TROPHY.id = "adminabuse"
TROPHY.title = "Admin Abuse!"
TROPHY.desc = "See Lewis manually trigger a randomat"
TROPHY.rarity = 3
TROPHY.hidden = true

function TROPHY:Trigger(earned)
    if earned then
        self:Earn(player.GetAll())
    end
end

-- Work around for the TTTRandomatCommand hook only accepting added hooks before the randomat base is run (during when autorun files are being loaded)
if SERVER then
    hook.Add("TTTRandomatCommand", "TTTTrophiesAdminAbuse", function(ply, cmd, args)
        if IsPlayer(ply) and ply:GetModel() == "models/bradyjharty/yogscast/lewis.mdl" and cmd == "ttt_randomat_trigger" then
            TROPHY:Trigger(true)
        end
    end)
end

-- Look for a convar specific to Mal's version of the randomat
-- (Yea I know I should use engine.GetAddons() but this is cheaper and there are no old clones of Mal's mod with this convar on the workshop and without the TTTRandomatCommand hook)
function TROPHY:Condition()
    return util.IsValidModel("models/bradyjharty/yogscast/lewis.mdl") and ConVarExists("ttt_randomat_allow_client_list")
end

RegisterTTTTrophy(TROPHY)