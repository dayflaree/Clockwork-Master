
--[[
	0 - For sale
	-1 - Unownable
	-2 - Police Doors
	>1 - Owned
]]--

function PMETA:DoorsOwned()
	return tonumber(self:GetNWInt( "DoorsOwned" ))
end

function OCRP_Purchase_Door(ply,door)
	if door.UnOwnable != nil then return end
	if door:GetNWInt( "Owner" ) < 0 || door.Propertykey then
		return
	elseif ply:GetMoney(WALLET) >= 300 and ply:DoorsOwned() < OCRPCfg["MaxDoors"] then 
		ply:TakeMoney(WALLET, 300)
		door:SetNWInt("Owner",ply:EntIndex())
		ply:SetNWInt( "DoorsOwned", ply:GetNWInt( "DoorsOwned" ) + 1 )
	else
		ply:Hint( "OCRP: You already have ".. OCRPCfg["MaxDoors"] .." doors, sell one to buy another." )
	end
	door.Permissions = {}
	door.Permissions["Buddies"] = true
	door.Permissions["Org"] = true
	door.Permissions["Goverment"] = false
	door.Permissions["Mayor"] = false
end

function OCRP_Sell_Door(ply,door)
	if door.UnOwnable != nil then return end
	if door:GetNWInt("Owner") <= 0 then return end
	if door.Propertykey then
		return
	end
	ply:AddMoney(WALLET, 150)
	door:SetNWInt("Owner",0)
	ply:SetNWInt( "DoorsOwned", ply:GetNWInt( "DoorsOwned" ) - 1 )
	door.Permissions = {}
	door.Permissions["Buddies"] = false
	door.Permissions["Org"] = false
	door.Permissions["Goverment"] = true
	door.Permissions["Mayor"] = true	
end

function OCRP_Purchase_Property(ply,property)
	if GAMEMODE.Properties[string.lower(game.GetMap())][property] != nil then
		local doors = {}
			for _,door in pairs(ents.GetAll()) do
				if door:IsDoor() then
					if door:IsValid() && door:GetClass() != "prop_vehicle_jeep" then
						if door.Propertykey != nil && door.Propertykey == property then
							if door:GetNWInt("Owner") > 0 then
								return
							else
								table.insert(doors,door)
							end
						end
					end
				end
			end
			if  ply:GetMoney(WALLET) >= GAMEMODE.Properties[string.lower(game.GetMap())][property].Price then 
				ply:TakeMoney(WALLET, GAMEMODE.Properties[string.lower(game.GetMap())][property].Price)
				for _,ply1 in pairs(player.GetAll()) do
					if ply1:IsValid() then
						umsg.Start("OCRP_UpdateOwnerShip", ply1)
							umsg.Long(ply:EntIndex())
							umsg.String(GAMEMODE.Properties[string.lower(game.GetMap())][property].Name)
						umsg.End()	
					end
				end
				for _,door in pairs(doors) do
					if door:IsDoor() then
						if door:IsValid() && door:GetClass() != "prop_vehicle_jeep" then
							if door.Propertykey != nil && door.Propertykey == property then
								door:SetNWInt("Owner",ply:EntIndex())
								ply:SetNWInt( "DoorsOwned", ply:GetNWInt( "DoorsOwned" ) + 1 )
								door.Permissions = {}
								door.Permissions["Buddies"] = true
								door.Permissions["Org"] = true
								door.Permissions["Goverment"] = false
								door.Permissions["Mayor"] = false
							end
						end
					end
				end
				ply:Hint("You bought "..GAMEMODE.Properties[string.lower(game.GetMap())][property].Name..".")
			end
	end
end
concommand.Add("OCRP_Buy_Property",function(ply,cmd,args) if !ply:NearNPC( "Relator" ) then return false end OCRP_Purchase_Property(ply,math.Round(args[1])) end)

function OCRP_Sell_Property(ply,property)
	if GAMEMODE.Properties[string.lower(game.GetMap())][property] != nil then
		local doors = {}
			for _,door in pairs(ents.GetAll()) do
				if door:IsDoor() then
					if door:IsValid() && door:GetClass() != "prop_vehicle_jeep" then
						if door.Propertykey != nil && door.Propertykey == property then
							if door:GetNWInt("Owner") != ply:EntIndex() then
								return
							else
								table.insert(doors,door)
							end
						end
					end
				end
			end
		ply:AddMoney(BANK, GAMEMODE.Properties[string.lower(game.GetMap())][property].Price/2)	
		ply:Hint("$"..GAMEMODE.Properties[string.lower(game.GetMap())][property].Price/2 .." has been sent to your bank from the realtor.")
		for key,data in pairs(GAMEMODE.Properties[string.lower(game.GetMap())][property]) do
			for _,ply in pairs(player.GetAll()) do
				if ply:IsValid() then
					umsg.Start("OCRP_UpdateOwnerShip", ply)
						umsg.Long(0)
						umsg.String(GAMEMODE.Properties[string.lower(game.GetMap())][property].Name)
					umsg.End()	
				end
			end
		end
			for _,door in pairs(doors) do
				if door:IsDoor() then
					if door:IsValid() && door:GetClass() != "prop_vehicle_jeep" then
						if door.Propertykey != nil && door.Propertykey == property then
							door:SetNWInt("Owner",0)
							door:SetNWBool("UnLocked",true)
							door:Fire("UnLock")
							if door.PadLock != nil && ply == door.PadLock.Owner then
								door.PadLock:SetParent(nil)
								door.PadLock:GetPhysicsObject():Wake()
								door.PadLock = nil
							end
							door:Fire("Close")
							ply:SetNWInt( "DoorsOwned", ply:GetNWInt( "DoorsOwned" ) - 1 )
							door.Permissions = {}
							door.Permissions["Buddies"] = false
							door.Permissions["Org"] = false
							door.Permissions["Goverment"] = true
							door.Permissions["Mayor"] = true
						end
					end
				end
			end
	end
end
concommand.Add("OCRP_Sell_Property",function(ply,cmd,args) if !ply:NearNPC( "Relator" ) then return false end OCRP_Sell_Property(ply,math.Round(args[1])) end)

function OCRP_Set_Permissions(ply,door,Org,Bud,Gov,May)
	if door.UnOwnable != nil && ply:Team() == CLASS_CITIZEN then return end 
	if Bud == "nil" then Bud = "false" end
	if Org == "nil" then Org = "false" end
	if Gov == "nil" then Gov = "false" end
	if May == "nil" then May = "false" end
	
	if door:GetNWInt( "Owner" ) == ply:EntIndex() then
		door.Permissions = {}
		door.Permissions["Buddies"] = tobool(Bud)
		door.Permissions["Org"] = tobool(Org)
		door.Permissions["Goverment"] = tobool(Gov)
		door.Permissions["Mayor"] = tobool(May)
	elseif ply:Team() == CLASS_Mayor then
		door.Permissions = {}
		door.Permissions["Buddies"] = tobool(Bud)
		door.Permissions["Org"] = tobool(Org)
		door.Permissions["Goverment"] = tobool(Gov)
		door.Permissions["Mayor"] = tobool(May)
	end
end
concommand.Add("OCRP_Set_Permissions", function(ply, command, args)  	local trace = util.GetPlayerTrace(ply) 	local tr = util.TraceLine(trace) if tr.Entity:IsValid() && tr.Entity:IsDoor() then OCRP_Set_Permissions(ply,tr.Entity,args[1],args[2],args[3],args[4]) end end)

function OCRP_Has_Permission(ply,obj)
	if obj.Permissions == nil then return false end
	if obj.UnOwnable then
		if obj.UnOwnable == -4 then
			return false
		end
	end
	local permtbl = obj.Permissions
	local owner = player.GetByID(obj:GetNWInt("Owner"))
	
	if obj:GetModel() == "models/nova/jeep_seat.mdl" then
		obj = obj:GetParent()
	end
	
	if obj:IsVehicle() and obj:GetDriver():IsPlayer() then
		owner = obj:GetDriver()
	end
	
	if owner == ply then 
		return true
	end
	if permtbl["Buddies"] and owner:IsValid() then
		if owner:IsBuddy(ply) then
			return true
		end
	end
	if permtbl["Goverment"] && ply:Team() != CLASS_CITIZEN then
		return true
	end
	if permtbl["Org"] && owner != nil then
		if tonumber(owner.Org) > 0 then
			if ply:GetOrg() == owner:GetOrg() then
				return true
			end
		end
	end
	if permtbl["Mayor"] && ply:Team() > 3 then
		return true
	end

	return false
end

function OCRP_Toggle_Lock(ply,door)
	if OCRP_Has_Permission(ply,door) then
		if door:GetNWBool("UnLocked") then
			door:SetNWBool("UnLocked",false)
			door:Fire("Lock")
			door:EmitSound("doors/door_latch1.wav",70,100)
		else
			door:SetNWBool("UnLocked",true)
			door:Fire("UnLock")
			door:EmitSound("doors/door_latch3.wav",70,100)
			if door.PadLock != nil && ply == door.PadLock.Owner then
				door.PadLock:SetParent(nil)
				door.PadLock:GetPhysicsObject():Wake()
				door.PadLock = nil
			end
		end	
	end
end






