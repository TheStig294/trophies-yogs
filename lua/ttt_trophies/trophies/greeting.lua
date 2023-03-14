local TROPHY = {}
TROPHY.id = "greeting"
TROPHY.title = "New Player Greeting"
TROPHY.desc = "See the player who's played the least get blown up with a Remote Sticky Bomb"
TROPHY.rarity = 2

function TROPHY:Trigger()
    if not TTTTrophies.stats[self.id] then
        TTTTrophies.stats[self.id] = {}
    end

    local notSpectator = {}
    local leastPlayedPlayer

    self:AddHook("TTTBeginRound", function()
        local minRounds

        for _, ply in ipairs(player.GetAll()) do
            if self:IsAlive(ply) then
                notSpectator[ply] = true
                local roundsPlayed = TTTTrophies.stats[self.id][ply:SteamID()]

                if not minRounds or not roundsPlayed or minRounds > roundsPlayed then
                    minRounds = roundsPlayed
                    leastPlayedPlayer = ply
                end
            end
        end
    end)

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if not IsValid(leastPlayedPlayer) or not IsValid(attacker) then return end
        local inflictor = dmg:GetInflictor()

        if IsValid(inflictor) and inflictor:GetClass() == "ttt_rsb" and ply == leastPlayedPlayer then
            self:Earn(player.GetAll())
        end
    end)

    self:AddHook("TTTEndRound", function()
        for _, ply in ipairs(player.GetAll()) do
            if notSpectator[ply] then
                local rounds = TTTTrophies.stats[self.id][ply:SteamID()]

                if not rounds then
                    rounds = 0
                else
                    rounds = rounds + 1
                end

                TTTTrophies.stats[self.id][ply:SteamID()] = rounds
            end
        end
    end)
end

function TROPHY:Condition()
    return scripted_ents.Get("ttt_rsb") ~= nil
end

RegisterTTTTrophy(TROPHY)