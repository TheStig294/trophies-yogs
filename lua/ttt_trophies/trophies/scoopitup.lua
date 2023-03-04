local TROPHY = {}
TROPHY.id = "scoopitup"
TROPHY.title = "\"SCOOP IT UP WITH YOUR ******* HANDS!\""
TROPHY.desc = "Drop an item near a beggar without them ever picking it up"
TROPHY.rarity = 2

function TROPHY:Trigger()
    local beggars = {}
    local droppedWeaponOwners = {}
    local droppedWeaponPlayers = {}
    local beggarExists = false

    -- Handling tracking of players who are beggars as cheaply as possible, also disables the 1-second timer if no beggars are in the round
    self:AddHook("TTTPlayerRoleChanged", function(ply, oldRole, newRole)
        if newRole then
            beggars[ply] = true
            beggarExists = true
        else
            beggars[ply] = false
            beggarExists = false

            for _, isBeggar in pairs(beggars) do
                if isBeggar then
                    beggarExists = true
                    break
                end
            end
        end
    end)

    -- This hook doesn't do anything in TTT... need to ask for a drop weapon hook to be added...
    self:AddHook("PlayerDroppedWeapon", function(ply, wep)
        -- If weapon isn't buyable or was dropped by a beggar, ignore it
        if not wep.CanBuy or wep.CanBuy == {} or ply:IsBeggar() then return end
        droppedWeaponOwners[wep] = ply
    end)

    -- Detect if a beggar is near a dropped weapon
    timer.Create("TTTTrophiesScoopItUp", 1, 0, function()
        if not beggarExists then return end

        for wep, wepOwner in pairs(droppedWeaponOwners) do
            if not IsValid(wep) then continue end
            local wepPos = wep:GetPos()

            for beggar, _ in pairs(beggars) do
                local beggarPos = beggar:GetPos()
                local distance = beggarPos:Distance(wepPos)

                if distance < 100 and IsValid(wepOwner) then
                    droppedWeaponPlayers[wepOwner] = true
                end
            end
        end
    end)

    -- If a beggar picks up a weapon that was dropped, clear the owner from potentially getting the trophy
    self:AddHook("WeaponEquip", function(wep, ply)
        if beggars[ply] then
            local owner = droppedWeaponOwners[wep]

            if IsValid(owner) then
                droppedWeaponPlayers[owner] = false
            end
        end
    end)

    -- If the dropped weapon wasn't picked up at all during the round, the owner earns the trophy
    self:AddHook("TTTEndRound", function()
        for ply, droppedAndNoPickup in pairs(droppedWeaponPlayers) do
            if droppedAndNoPickup then
                self:Earn(ply)
            end
        end

        table.Empty(beggars)
        table.Empty(droppedWeaponOwners)
        table.Empty(droppedWeaponPlayers)
        beggarExists = false
    end)
end

function TROPHY:Condition()
    return ConVarExists("ttt_beggar_enabled") and GetConVar("ttt_beggar_enabled"):GetBool()
end

RegisterTTTTrophy(TROPHY)