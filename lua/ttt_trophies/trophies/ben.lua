local TROPHY = {}
TROPHY.id = "ben"
TROPHY.title = "Champion of the people"
TROPHY.desc = "Win the round with Ben alive after reviving him with a brain washing device"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local revivePlayer

    self:AddHook("TTTPlayerRoleChangedByItem", function(ply, tgt, item)
        if tgt:GetModel() == "models/bradyjharty/yogscast/sharky.mdl" and item:GetClass() == "weapon_hyp_brainwash" then
            revivePlayer = ply
        end
    end)

    self:AddHook("TTTEndRound", function(result)
        if not revivePlayer or result ~= WIN_TRAITOR then return end

        for _, ply in ipairs(player.GetAll()) do
            if ply:GetModel() == "models/bradyjharty/yogscast/sharky.mdl" and self:IsAlive(ply) then
                self:Earn({revivePlayer, ply})

                break
            end
        end

        revivePlayer = nil
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/bradyjharty/yogscast/sharky.mdl") and TTTTrophies:CanRoleSpawn(ROLE_HYPNOTIST)
end

RegisterTTTTrophy(TROPHY)