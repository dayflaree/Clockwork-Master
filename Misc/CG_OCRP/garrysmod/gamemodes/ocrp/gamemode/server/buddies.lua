function AddBud( ply, cmd, args )
	local NewBudID = args[1]
	for k, v in pairs(player.GetAll()) do
		if v:UniqueID() == NewBudID then
			NewBud = v
			umsg.Start("ocrp_buds", ply)
				umsg.Entity(v)
			umsg.End()
		end
	end
	if ply == NewBud then return false end
	table.insert(ply.OCRPData["Buddies"], NewBud)
end
concommand.Add("OCRP_AddBuddy", AddBud)

function RemoveAllBuds( ply, cmd, args )
	for k, v in pairs(ply.OCRPData["Buddies"]) do
		ply.OCRPData["Buddies"][k] = nil
		umsg.Start("ocrp_buds", ply)
			umsg.Entity(v)
		umsg.End()
	end
end
concommand.Add("OCRP_RemoveAllBuddys", RemoveAllBuds)

function RemoveBud( ply, cmd, args )
	local ToRemoveID = args[1]
	for k, v in pairs(player.GetAll()) do
		if v:UniqueID() == ToRemoveID then
			ToRemove = v
			umsg.Start("ocrp_buds", ply)
				umsg.Entity(v)
			umsg.End()
		end
	end
	if ply == ToRemove then return false end
	for k, v in pairs(ply.OCRPData["Buddies"]) do
		if v == ToRemove then
			ply.OCRPData["Buddies"][k] = nil
		end
	end
end
concommand.Add("OCRP_RemoveBuddy", RemoveBud)

function PMETA:IsBuddy( bud )
	for k, v in pairs(self.OCRPData["Buddies"]) do
		if v == bud then
			return true
		end
	end
	return false
end

function OCRP_SPECTATEGM(ply,ply2,viewtype,un)
	if un then
		umsg.Start("SpecEnd", ply)
		umsg.End()
		ply:UnSpectate()
		ply:Spawn()
		ply.SpecEntity = nil
		return
	end
	local obs_mode
	if viewtype == "First" then
		obs_mode = OBS_MODE_IN_EYE
	else 
		obs_mode = OBS_MODE_CHASE
	end
	if ply != ply2 then
		--[[for _,obj in pairs(ply.VisibleWeps) do
			if obj:IsValid() then 
				obj:SetNoDraw(true) 
			end
		end]]
		ply:Spectate( obs_mode )
		ply:SpectateEntity( ply2 )
		ply.SpecEntity = ply2
		umsg.Start("Spec", ply)
			umsg.Entity(ply2)
			umsg.Bool(true)
		umsg.End()
	end
end

function PMETA:Hint( hint, admin, sel )
	if hint != nil and !admin then
		umsg.Start("OCRP_Hint", self)
			umsg.String( hint )
		umsg.End()
	elseif hint != nil and admin then
		if !sel then
			for k, v in pairs(player.GetAll()) do
				umsg.Start("OCRP_Hint", v)
					umsg.String( hint )
				umsg.End()
			end
		else
			umsg.Start("OCRP_Hint", sel)
				umsg.String( hint )
			umsg.End()
		end
	end
end

function Debug_Log( ply, t, ... )
	local arg = {...}
	local argString = table.ToString( arg )
	local DebugLog = ""
	local f = "OCRP/Logs/".. t ..".txt"
	if file.Exists(f) then
		DebugLog = file.Read(f)
	end
	DebugLog = DebugLog .. "["..os.date().."] - ["..ply:Nick().."] -> Data: { ".. argString .." }\n"
	file.Write(f,DebugLog)
end
		
		
		
			


	
