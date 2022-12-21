local TROPHY = {}
TROPHY.id = "duncan"
TROPHY.title = "Rubber tree survivor"
TROPHY.desc = "Survive a donconnon from Doncon"
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

        if attacker:GetModel() == "models/player/doncon/doncon.mdl" and (inflictor:GetClass() == "doncmk2_en" or inflictor:GetClass() == "ent_ttt_donconnon_randomat") then
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