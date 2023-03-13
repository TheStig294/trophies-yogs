local TROPHY = {}
TROPHY.id = "holdspace"
TROPHY.title = "Hold space to slow down"
TROPHY.desc = "Double-jump out of a very long fall"
TROPHY.rarity = 3

function TROPHY:Trigger()
    local doubleJumping = {}

    self:AddHook("OnPlayerHitGround", function(ply, inWater, onFloater, speed)
        doubleJumping[ply] = false
    end)

    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == KEY_SPACE and not ply:OnGround() then
            if button == KEY_SPACE and not ply:OnGround() and not doubleJumping[ply] then
                local velocity = ply:GetVelocity().z

                if velocity <= -2000 then
                    self:Earn(ply)
                end
            end

            doubleJumping[ply] = true
        end
    end)
end

function TROPHY:Condition()
    return ConVarExists("multijump_default_jumps") and GetConVar("multijump_default_jumps"):GetInt() == 1 and ConVarExists("multijump_can_jump_while_falling") and GetConVar("multijump_can_jump_while_falling"):GetBool()
end

RegisterTTTTrophy(TROPHY)