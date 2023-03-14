local TROPHY = {}
TROPHY.id = "ravs"
TROPHY.title = "Huff this"
TROPHY.desc = "Kill Ravs with a fart grenade, or as Ravs, die to one"
TROPHY.rarity = 1

function TROPHY:Trigger()
    local SWEP = weapons.GetStored("weapon_fartgrenade")
    local fartSound = Sound("fart_1.wav")
    local dieSound = Sound("fart_2.wav")

    local hurtSounds = {Sound("vo/npc/Barney/ba_ohshit03.wav"), Sound("vo/k_lab/kl_ahhhh.wav"), Sound("vo/npc/male01/moan01.wav"), Sound("vo/npc/male01/moan04.wav"), Sound("vo/npc/male01/ohno.wav")}

    local hurtImpacts = {Sound("player/pl_pain5.wav"), Sound("player/pl_pain6.wav"), Sound("player/pl_pain7.wav")}

    -- Override the fart grenade so it passes an attacker and inflictor
    function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
        local owner = self:GetOwner()
        local gren = ents.Create("prop_physics")
        if not IsValid(gren) then return end
        gren:SetPos(src)
        gren:SetAngles(ang)
        gren:SetModel("models/weapons/w_grenade.mdl")
        gren:SetOwner(ply)
        gren:SetGravity(0.4)
        gren:SetFriction(0.2)
        gren:SetElasticity(0.45)
        gren:Spawn()
        gren:PhysWake()
        gren.IsFartGrenade = true

        timer.Simple(3, function()
            if (not IsValid(gren)) then return end
            ParticleEffect("fartsmoke", gren:GetPos() + Vector(-80, -40, 0), Angle(0, 0, 0), nil)
            gren:EmitSound(fartSound)
            local v = {}

            timer.Create("fartsmoke_" .. gren:EntIndex(), 0.5, 24, function()
                if (IsValid(gren)) then
                    local left = timer.RepsLeft("fartsmoke_" .. gren:EntIndex())
                    local players = player.GetAll()

                    for p in pairs(player.GetAll()) do
                        local ply = players[p]
                        local vel = ply:GetVelocity()
                        local dir = (ply:GetPos() - gren:GetPos()):GetNormalized()
                        local dmg_rate = math.Clamp(ply:GetPos():Distance(gren:GetPos()), 0, 420)
                        dmg_rate = (1 - ((1 / 420) * dmg_rate))
                        local zdist = ply:GetPos().z - gren:GetPos().z

                        if (zdist < 0) then
                            zdist = zdist * -1
                        end

                        if (dmg_rate <= 0 or zdist >= 160 or not ply:Alive()) then continue end
                        local force = vel + dmg_rate * 500 * dir
                        local isDead = ply:Health() - 10 <= 0
                        ply:TakeDamage(10, owner, gren)
                        ply:ScreenFade(SCREENFADE.IN, Color(255, 155, 0, 128), 0.3, 0)
                        ply:SetVelocity(force)

                        if (not IsValid(v[ply:EntIndex()])) then
                            ply:EmitSound(hurtSounds[math.random(1, 5)])
                            v[ply:EntIndex()] = ply
                        end

                        if (ply:Health() > 0) then
                            ply:EmitSound(hurtImpacts[math.random(1, 3)])
                        end

                        if (isDead) then
                            ply:EmitSound(dieSound)
                        end
                    end

                    if (left == 0) then
                        gren:Remove()
                    end
                end
            end)
        end)

        local phys = gren:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetVelocity(vel)
            phys:AddAngleVelocity(angimp)
        end
    end

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        if IsValid(dmg:GetInflictor()) and dmg:GetInflictor().IsFartGrenade and ply:GetModel() == "models/solidsnakemgs4/solidsnakemgs4.mdl" then
            self:Earn({attacker, ply})
        end
    end)
end

function TROPHY:Condition()
    return util.IsValidModel("models/solidsnakemgs4/solidsnakemgs4.mdl") and weapons.Get("weapon_fartgrenade")
end

RegisterTTTTrophy(TROPHY)