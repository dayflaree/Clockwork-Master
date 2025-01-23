function set_afk(ply)
	if ply.afk_npc and ply.afk_npc:IsValid() then
		
		ply:Spawn()
	
		ply:SetPos(ply.afk_npc:GetPos())
		ply:SetColor(255, 255, 255, 255)
		ply.afk_npc:Remove()
		
		ply:CrosshairEnable()
		
		ply:RestoreWeapons()
	end
		
	timer.Create("AFK_" .. ply:UniqueID(), 120, 1, function()
		if not ply or not ply:IsValid() or ply:InVehicle() or not ply:Alive() or not ply:OnGround() or not string.find(ply:GetModel(), "group") then
			return
		end
		
		ply:SaveWeapons()
		ply:StripWeapons()
		ply:CrosshairDisable()
		
		local npc = ents.Create("npc_afk")
		npc:SetPos(ply:GetPos())
		npc:SetAngles(ply:GetAngles())
		npc:Spawn()
		
		npc:SetAnimationSequence(ply:GetPData("afk_anim") or "sit_ground")
		
		npc:SetModel(string.Replace(string.Replace(ply:GetModel(), "player/", ""), "models/", "models/humans/"))
		npc:SetNWString("owner", "World")
		
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(npc)
		
		ply:SetMoveType(MOVETYPE_OBSERVER)
		
		ply:SetColor(255, 255, 255, 0)
		ply:SetPos(npc:GetPos() + Vector(0, 0, 200))
		
		ply.afk_npc = npc
	end)
end
hook.Add("KeyPress", "AFK_KeyPress", set_afk)
hook.Add("PlayerInitialSpawn", "AFK_PlayerInitialSpawn", set_afk)

local Player = FindMetaTable("Player")

function Player:SaveWeapons()
	self.weps = {}
		
	for k, weapon in pairs(self:GetWeapons()) do
		table.insert(self.weps, {
			class = weapon:GetClass(),
			p_ammo = weapon:GetPrimaryAmmoType(),
			p_ammo_count = self:GetAmmoCount(weapon:GetPrimaryAmmoType()),
			s_ammo = weapon:GetSecondaryAmmoType(),
			s_ammo_count = self:GetAmmoCount(weapon:GetSecondaryAmmoType())
		})
	end
	
	self.ActiveWeapon = self:GetActiveWeapon():GetClass()
end

function Player:RestoreWeapons()
	if not self.weps or not self.ActiveWeapon then return end
	
	for k, weapon in pairs(self.weps) do
		self:Give(weapon.class)
		self:GiveAmmo(p_ammo_count, p_ammo)
		self:GiveAmmo(s_ammo_count, s_ammo)
	end
	
	self:SelectWeapon(self.ActiveWeapon)
end