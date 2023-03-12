local TROPHY = {}
TROPHY.id = "bringgun"
TROPHY.title = "You didn't bring me a gun!"
TROPHY.desc = "Die after being rezzed without picking up a weapon"
TROPHY.rarity = 2

function TROPHY:Trigger()
    local respawnedPlayers = {}

    self:AddHook("TTTPlayerSpawnForRound", function(ply, deadOnly)
        if GetRoundState() ~= ROUND_ACTIVE then return end
        if not deadOnly then return end
        respawnedPlayers[ply] = true
    end)

    self:AddHook("WeaponEquip", function(wep, ply)
        if respawnedPlayers[ply] then
            if not IsValid(wep) then return end
            if wep.Kind == WEAPON_UNARMED or wep.Kind == WEAPON_CARRY or wep.Kind == WEAPON_MELEE or wep.Kind == WEAPON_ROLE then return end
            respawnedPlayers[ply] = false
        end
    end)

    self:AddHook("PostPlayerDeath", function(ply)
        if respawnedPlayers[ply] and GetRoundState() == ROUND_ACTIVE and not (ply.IsZombie and ply:IsZombie()) then
            self:Earn(ply)
        end
    end)

    self:AddHook("TTTBeginRound", function()
        table.Empty(respawnedPlayers)
    end)
end

function TROPHY:Condition()
    return weapons.Get("weapon_vadim_defib") ~= nil or (ConVarExists("ttt_hypnotist_enabled") and GetConVar("ttt_hypnotist_enabled"):GetBool()) or (ConVarExists("ttt_paramedic_enabled") and GetConVar("ttt_paramedic_enabled"):GetBool())
end

RegisterTTTTrophy(TROPHY)