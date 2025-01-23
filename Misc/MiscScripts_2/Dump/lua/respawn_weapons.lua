local function RespawnWeapon(weapon)
	timer.Simple(30, function()
		local w = ents.Create(weapon:GetClass())
		w:SetPos(weapon:GetPos())
		w:SetAngles(weapon:GetAngles())
		w:Spawn()
		w:CallOnRemove("Respawn", RespawnWeapon)
	end)
end

hook.Add("InitPostEntity", "Respawns", function()
	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		ent:CallOnRemove("Respawn", RespawnWeapon)
	end
end)