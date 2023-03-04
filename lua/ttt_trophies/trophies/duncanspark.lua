local TROPHY = {}
TROPHY.id = "duncanspark"
TROPHY.title = "Duncan's Park Souvenir"
TROPHY.desc = "Win as a detective or traitor with an item you've bought the least"
TROPHY.rarity = 3

function TROPHY:Trigger()
    self.roleMessage = ROLE_TRAITOR
    -- Getting the list of buyable detective items
    -- At the start of the first round of a map, ask the first connected client for the printnames of all detective and detective weapons
    -- Items are sent as ClassNames for active items, and PrintNames for passive items to uniquely identify them
    local detectiveTraitorBuyable = {}

    -- First check if its on the SWEP list
    for _, v in pairs(weapons.GetList()) do
        if TTTTrophies:IsBuyableItem(ROLE_DETECTIVE, v) or TTTTrophies:IsBuyableItem(ROLE_TRAITOR, v) then
            detectiveTraitorBuyable[v.ClassName] = true
        end
    end

    -- If its not on the SWEP list, then check the equipment items table
    for _, v in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if TTTTrophies:IsBuyableItem(ROLE_DETECTIVE, v) or TTTTrophies:IsBuyableItem(ROLE_TRAITOR, v) then
            detectiveTraitorBuyable[v.name] = true
        end
    end

    self:AddHook("TTTRoleWeaponUpdated", function(role, weapon, inc, exc, noRandom)
        if role ~= ROLE_DETECTIVE and role ~= ROLE_TRAITOR then return end

        if inc then
            detectiveTraitorBuyable[weapon] = true
        end

        if exc then
            detectiveTraitorBuyable[weapon] = nil
        end
    end)

    if not TTTTrophies.stats[self.id] then
        TTTTrophies.stats[self.id] = {}
    end

    self:AddHook("TTTOrderedEquipment", function(ply, equipment, is_item, given_by_randomat)
        if TTTTrophies.earned[ply:SteamID()] and TTTTrophies.earned[ply:SteamID()][self.plyID] then return end

        timer.Simple(0.1, function()
            -- Items given by randomats aren't bought by the player, so they shouldn't count
            if given_by_randomat or GetGlobalBool("DisableRandomatStats") or not IsValid(ply) then return end
            if not TTTTrophies:IsDetectiveLike(ply) and not TTTTrophies:IsTraitorTeam(ply) then return end
            -- Recording the item as bought
            local plyID = ply:SteamID()
            local noOfPurchases = 0

            -- If an item is a passive item, then the passed item id in the equipment parameter needs to be converted to the item's print name
            -- This is so as items are uninstalled/reinstalled old items don't count as bought for new items and vice-versa, as item ids change
            if is_item then
                equipment = tonumber(equipment)

                if equipment then
                    equipment = math.floor(equipment)
                else
                    -- If is_item is truthy but the passed equipment failed to be converted to a number then something went wrong here
                    return
                end

                local item = GetEquipmentItem(ROLE_DETECTIVE, equipment)

                if not item then
                    item = GetEquipmentItem(ROLE_TRAITOR, equipment)
                end

                if not item then return end
                -- Don't count loadout items towards stats
                if item.loadout then return end

                if item and item.name then
                    if not TTTTrophies.stats[self.id][plyID] then
                        TTTTrophies.stats[self.id][plyID] = {}
                    end

                    if not TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] then
                        TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] = 0
                    end

                    if not TTTTrophies.stats[self.id][plyID][item.name] then
                        TTTTrophies.stats[self.id][plyID][item.name] = 0
                    end

                    noOfPurchases = TTTTrophies.stats[self.id][plyID][item.name]
                    TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] = TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] + 1
                    TTTTrophies.stats[self.id][plyID][item.name] = TTTTrophies.stats[self.id][plyID][item.name] + 1
                end
            else
                -- Active items are indexed by their classname, which this hook passes by itself
                if not TTTTrophies.stats[self.id][plyID] then
                    TTTTrophies.stats[self.id][plyID] = {}
                end

                if not TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] then
                    TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] = 0
                end

                if not TTTTrophies.stats[self.id][plyID][equipment] then
                    TTTTrophies.stats[self.id][plyID][equipment] = 0
                end

                noOfPurchases = TTTTrophies.stats[self.id][plyID][equipment]
                TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] = TTTTrophies.stats[self.id][plyID]["____TotalPurchases"] + 1
                TTTTrophies.stats[self.id][plyID][equipment] = TTTTrophies.stats[self.id][plyID][equipment] + 1
            end

            local plyStats = table.Copy(TTTTrophies.stats[self.id][plyID])
            -- Don't give out this trophy until at least a sample of 100 purchases have been gathered
            if plyStats.____TotalPurchases < 100 then return end

            -- If there's an item bought less than the current one, abort
            for itemName, purchaseCount in pairs(plyStats) do
                if noOfPurchases > purchaseCount then return end
            end

            -- Otherwise, mark the player as potentially able to get the trophy
            ply.TTTTrophiesDuncansParkBoughtLeast = true
            ply:ChatPrint("[Trophy progress]\nLeast purchased item bought! Win the round as a detective/traitor to earn a trophy!")
        end)
    end)

    self:AddHook("TTTEndRound", function(win)
        if win == WIN_TRAITOR then
            for _, ply in ipairs(player.GetAll()) do
                if ply.TTTTrophiesDuncansParkBoughtLeast and self:IsAlive(ply) and TTTTrophies:IsTraitorTeam(ply) then
                    self:Earn(ply)
                    ply.TTTTrophiesDuncansParkBoughtLeast = false
                end
            end
        elseif win == WIN_INNOCENT then
            for _, ply in ipairs(player.GetAll()) do
                if ply.TTTTrophiesDuncansParkBoughtLeast and self:IsAlive(ply) and TTTTrophies:IsGoodDetectiveLike(ply) then
                    self:Earn(ply)
                    ply.TTTTrophiesDuncansParkBoughtLeast = false
                end
            end
        end
    end)
end

RegisterTTTTrophy(TROPHY)