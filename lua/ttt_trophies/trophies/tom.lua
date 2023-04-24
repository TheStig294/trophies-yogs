local TROPHY = {}
TROPHY.id = "tom"
TROPHY.title = "BAM!"
TROPHY.desc = "Through the \"Somehow, Palpatine returned!\" randomat, see Tom-bot win"
TROPHY.rarity = 3
local palpRandomat = false

if SERVER then
    hook.Add("TTTRandomatTriggered", "TTTTrophiesBamRandomatTrigger", function(id, owner)
        if id == "palp" then
            palpRandomat = true
        end
    end)
end

function TROPHY:Trigger()
    self:AddHook("TTTEndRound", function()
        if not palpRandomat then return end
        local tom = GetGlobalEntity("RandomatTomBot")

        if IsValid(tom) and self:IsAlive(tom) then
            self:Earn(player.GetAll())
        end

        palpRandomat = false
    end)
end

function TROPHY:Condition()
    return Randomat and Randomat.CanEventRun and Randomat:CanEventRun("palp")
end

RegisterTTTTrophy(TROPHY)