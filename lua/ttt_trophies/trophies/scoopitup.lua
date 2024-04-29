local TROPHY = {}
TROPHY.id = "scoopitup"
TROPHY.title = "Scoop it up with your ******* hands!"
TROPHY.desc = "Drop an item near a beggar without them ever picking it up"
TROPHY.rarity = 2

function TROPHY:Trigger()
    local beggars = {}
    local droppedWeapons = {}
    local wepNearBeggarPlayers = {}
    local beggarExists = false

    -- Tracking players who are beggars, also disables the 1-second timer if no beggars are in the round
    self:AddHook("TTTPlayerRoleChanged", function(ply, oldRole, newRole)
        if newRole == ROLE_BEGGAR then
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

    self:AddHook("PlayerDroppedWeapon", function(owner, wep)
        -- If weapon isn't buyable or was dropped by a beggar, ignore it
        if not wep.CanBuy or wep.CanBuy == {} or not IsValid(owner) or owner:IsBeggar() then return end

        if not droppedWeapons[owner] then
            droppedWeapons[owner] = {}
        end

        droppedWeapons[owner][wep] = true
    end)

    -- Detect if a beggar is near a dropped weapon
    timer.Create("TTTTrophiesScoopItUp", 1, 0, function()
        if not beggarExists then return end

        for owner, weps in pairs(droppedWeapons) do
            if not IsValid(owner) then continue end

            for wep, _ in pairs(weps) do
                if not IsValid(wep) then continue end
                local wepPos = wep:GetPos()

                for beggar, _ in pairs(beggars) do
                    local beggarPos = beggar:GetPos()
                    local distance = beggarPos:Distance(wepPos)

                    if distance < 100 and IsValid(owner) then
                        wepNearBeggarPlayers[owner] = true
                    end
                end
            end
        end
    end)

    -- If anyone picks up a weapon that was dropped, clear the owner from potentially getting the trophy
    self:AddHook("WeaponEquip", function(wep, ply)
        local owner

        for own, weps in pairs(droppedWeapons) do
            for w, _ in pairs(weps) do
                if wep == w then
                    owner = own
                    break
                end
            end
        end

        if IsValid(owner) then
            droppedWeapons[owner][wep] = nil

            if table.IsEmpty(droppedWeapons[owner]) then
                wepNearBeggarPlayers[owner] = false
            end
        end
    end)

    -- If the dropped weapon wasn't picked up at all during the round, the owner earns the trophy
    self:AddHook("TTTEndRound", function()
        for ply, droppedAndNoPickup in pairs(wepNearBeggarPlayers) do
            if droppedAndNoPickup then
                self:Earn(ply)
            end
        end

        table.Empty(beggars)
        table.Empty(droppedWeapons)
        table.Empty(wepNearBeggarPlayers)
        beggarExists = false
    end)
end

function TROPHY:Condition()
    return TTTTrophies:CanRoleSpawn(ROLE_BEGGAR)
end

RegisterTTTTrophy(TROPHY)