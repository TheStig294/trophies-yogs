local TROPHY = {}
TROPHY.id = "zylus"
TROPHY.title = "A vote for Zylus..."
TROPHY.desc = "See Zylus survive a round with the democracy randomat"
TROPHY.rarity = 3
local democracyTriggered = false

if SERVER then
    hook.Add("TTTRandomatTriggered", "TTTTrophiesZylusRandomatTrigger", function(id, owner)
        if id == "democracy" then
            democracyTriggered = true
        end
    end)
end

function TROPHY:Trigger()
    self:AddHook("TTTEndRound", function()
        if not democracyTriggered then return end

        for _, ply in ipairs(player.GetAll()) do
            if self:IsAlive(ply) and ply:GetModel() == "models/player/jenssons/kermit.mdl" then
                self:Earn(player.GetAll())
                break
            end
        end

        democracyTriggered = false
    end)
end

function TROPHY:Condition()
    return ConVarExists("ttt_randomat_democracy") and GetConVar("ttt_randomat_democracy"):GetBool() and util.IsValidModel("models/player/jenssons/kermit.mdl")
end

RegisterTTTTrophy(TROPHY)