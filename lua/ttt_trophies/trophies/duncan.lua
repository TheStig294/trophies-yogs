local TROPHY = {}
TROPHY.id = "duncan"
TROPHY.title = "Rubber tree survivor"
TROPHY.desc = "Survive a donconnon from Duncan or as Doncon"
TROPHY.rarity = 2

function TROPHY:Trigger()
    local tbl = scripted_ents.GetStored("doncmk2_en")
    local ENT = tbl.t

    -- Patching the donconnon to pass an inflictor
    function ENT:StartTouch(entity)
        local owner = self:GetOwner()
        if entity == self:GetOwner() then return end
        entity:TakeDamage(self.DonconDamage, owner, self)
        self:EmitSound("donc_fire")
    end

    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if not IsPlayer(ent) or not took then return end
        local attacker = dmg:GetAttacker()
        local inflictor = dmg:GetInflictor()
        if not IsPlayer(attacker) or not IsValid(inflictor) then return end

        if ent:GetModel() == "models/player/doncon/doncon.mdl" or (inflictor:GetClass() == "doncmk2_en" and attacker:GetModel() == "models/player/doncon/doncon.mdl") then
            timer.Simple(2, function()
                if self:IsAlive(ent) then
                    self:Earn(ent)
                end
            end)
        end
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/player/doncon/doncon.mdl") and scripted_ents.Get("doncmk2_en") ~= nil
end

RegisterTTTTrophy(TROPHY)