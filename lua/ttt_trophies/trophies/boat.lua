local TROPHY = {}
TROPHY.id = "boat"
TROPHY.title = "See if you can find a boat"
TROPHY.desc = "As an innocent, win while in an airboat"
TROPHY.rarity = 3

function TROPHY:Trigger()
    self.roleMessage = ROLE_DETECTIVE

    self:AddHook("TTTEndRound", function(result)
        if result == WIN_INNOCENT then
            for _, ply in ipairs(player.GetAll()) do
                if self:IsAlive(ply) and TTTTrophies:IsInnocentTeam(ply) then
                    local parent = ply:GetParent()
                    if not IsValid(parent) then continue end
                    local class = parent:GetClass()

                    if class == "prop_vehicle_airboat" then
                        self:Earn(ply)
                    end
                end
            end
        end
    end)
end

RegisterTTTTrophy(TROPHY)