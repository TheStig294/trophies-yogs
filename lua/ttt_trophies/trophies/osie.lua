local TROPHY = {}
TROPHY.id = "osie"
TROPHY.title = "Role inventor"
TROPHY.desc = "Play a round with the Mud Scientist with Osie"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local eventTriggered = false

    self:AddHook("TTTRandomatTriggered", function(id, owner)
        if id == "mudscientist" then
            eventTriggered = true
        end
    end)

    self:AddHook("TTTPrepareRound", function()
        timer.Simple(2, function()
            if not eventTriggered then return end

            for _, ply in ipairs(player.GetAll()) do
                if ply:GetModel() == "models/player/mokeyfix/nosacz.mdl" then
                    self:Earn(player.GetAll())
                    break
                end
            end

            eventTriggered = false
        end)
    end)
end

function TROPHY:Condition()
    return Randomat and Randomat.Events and Randomat.Events["mudscientist"] and util.IsValidModel("models/player/mokeyfix/nosacz.mdl")
end

RegisterTTTTrophy(TROPHY)