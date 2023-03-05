local TROPHY = {}
TROPHY.id = "zylusday"
TROPHY.title = "International Zylus Day!"
TROPHY.desc = "Play within a week of International Zylus Day (June 19)"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local day = os.date("%d")
    local month = os.date("%m")
    if month ~= "06" then return end
    day = tonumber(day)

    -- International Zylus Day is on June 19, a 1 week window is June 12-26
    if day >= 12 and day <= 26 then
        self:AddHook("TTTEndRound", function()
            self:Earn(player.GetAll())
        end)
    end
end

RegisterTTTTrophy(TROPHY)