local TROPHY = {}
TROPHY.id = "tom"
TROPHY.title = "BAM!"
TROPHY.desc = "Through the \"Somehow, Palpatine returned!\" randomat, see Tom-bot win"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local palpRandomat = false

    self:AddHook("TTTRandomatTriggered", function(id, owner)
        if id == "palp" then
            palpRandomat = true
        end
    end)

    self:AddHook("TTTEndRound", function()
        if not palpRandomat then return end
        local tom = GetGlobalEntity("RandomatTomBot")
        if not IsValid(tom) then return end

        for _, bot in ipairs(player.GetBots()) do
            if bot == tom and self:IsAlive(bot) then
                self:Earn(player.GetAll())

                return
            end
        end

        palpRandomat = false
    end)
end

function TROPHY:Condition()
    return Randomat and Randomat.CanEventRun and Randomat:CanEventRun("palp")
end

RegisterTTTTrophy(TROPHY)