local TROPHY = {}
TROPHY.id = "nerdhealing"
TROPHY.title = "Ultimate nerd healing"
TROPHY.desc = "As a traitor, heal 50 health from a paladin"
TROPHY.rarity = 3

function TROPHY:Trigger()
    self.roleMessage = ROLE_TRAITOR
    local healedByPaladin = {}

    self:AddHook("TTTPaladinAuraHealed", function(ply, tgt, healed)
        if tgt:IsPlayer() and TTTTrophies:IsTraitorTeam(tgt) then
            if not healedByPaladin[tgt] then
                healedByPaladin[tgt] = 0
            end

            healedByPaladin[tgt] = healedByPaladin[tgt] + healed

            if healedByPaladin[tgt] >= 50 then
                self:Earn(tgt)
            end
        end
    end)

    self:AddHook("TTTPrepareRound", function()
        table.Empty(healedByPaladin)
    end)
end

function TROPHY:Condition()
    return TTTTrophies:CanRoleSpawn(ROLE_PALADIN)
end

RegisterTTTTrophy(TROPHY)