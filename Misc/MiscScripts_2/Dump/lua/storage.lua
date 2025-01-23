local MaxItemsPerProp = 10
local StorageContainers = {
	
}

hook.Add("KeyPress", "Storage_KeyPress", function(ply, key)
	if key == IN_USE then
		local prop = ply:GetEyeTrace().Entity
		if prop:GetClass() == "prop_physics" then
			-- if table.HasValue(StorageContainers, prop:GetModel()) then
			if not prop.StoredItems then prop.StoredItems = {} end
			if #prop.StoredItems < MaxItemsPerProp then
				if not prop.AvailableVolume then prop.AvailableVolume = prop:GetPhysicsObject():GetVolume() end
				local items = ents.FindInSphere(prop:GetPos(), 200)
				for _, ent in pairs(items) do
					if ent:GetClass() == "prop_physics" then
						local vol = ent:GetPhysicsObject():GetVolume()
						if vol <= prop.AvailableVolume then
							-- Store
							prop.AvailableVolume = prop.AvailableVolume - ent:GetPhysicsObject():GetVolume()
							if prop.StoredItems[ent:GetModel()] then
								prop.StoredItems[ent:GetModel()] = tableprop.StoredItems[ent:GetModel()] + 1
							else
								prop.StoredItems[ent:GetModel()] = 1
							end
							ent:Remove()
						end
					end
				end
			end
			-- end
		end
	end
end)