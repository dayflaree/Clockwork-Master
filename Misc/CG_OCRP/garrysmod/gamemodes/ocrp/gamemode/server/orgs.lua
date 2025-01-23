--This shit is prolly wrong, but hey-ho.
GM.Orgs = {}

function GM.NewOrg( ply )
	if tonumber(ply:GetOrg()) > tonumber(1) then return false end
	if ply:GetMoney(WALLET) < 5000 then return false end
	ply:TakeMoney(WALLET, 5000)

	tmysql.query( "INSERT INTO `ocrp_orgs` (`org_name`, `org_owner`, `org_notes`) VALUES('No Org Name', '".. ply:SteamID() .."', 'No notes currently.')" )
	timer.Simple(.5, function()
		tmysql.query( "SELECT `org_id` FROM `ocrp_orgs` WHERE `org_owner` = '".. ply:SteamID() .."'",
		function( results )
			local OrgID = results[1][1]

			GAMEMODE.Orgs[OrgID] = {}
			GAMEMODE.Orgs[OrgID].Name = "No Org Name"
			GAMEMODE.Orgs[OrgID].Owner = ply:SteamID()
			GAMEMODE.Orgs[OrgID].Notes = "No notes currently."
		--	GAMEMODE.Orgs[OrgID].Type = OrgType
			GAMEMODE.Orgs[OrgID].Members = {}
			
			PrintTable( GAMEMODE.Orgs[OrgID] )
			
			GAMEMODE.JoinOrg( ply, OrgID )
		end)
	end)
end

function GM.JoinOrg( ply, OrgID )
	if !GAMEMODE.Orgs[OrgID] then return false end
	
	ply:SetOrg(OrgID)
	tmysql.query( "UPDATE `ocrp_users` SET `org_id` = '".. OrgID .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'" )
	table.insert(GAMEMODE.Orgs[OrgID].Members, {Name = ply:Nick(), SteamID = ply:SteamID()})
	ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
	SendOrg( ply )
end

function GM.QuitOrg( ply, OrgID, Kick )
	if tonumber(ply.Org) != tonumber(OrgID) then return false end
	ply:SetNWString("OrgName", "No Org Name")
	if ply:SteamID() == GAMEMODE.Orgs[ply.Org].Owner and !Kick then
		tmysql.query( "UPDATE `ocrp_users` SET `org_id` = '0' WHERE `org_id` = '".. ply.Org .."'" )
		for k, v in pairs(player.GetAll()) do
			if tonumber(v.Org) == tonumber(ply.Org) then
				if v:SteamID() != GAMEMODE.Orgs[ply.Org].Owner then
					v:Hint( GAMEMODE.Orgs[ply.Org].Name .." has been disbanded by his owner." )
					v:SetOrg( 0 )
					v:SetNWInt("orgid", 0)
					v:SetNWString("OrgName", "No Org Name")
					SecondaryIDLeave( v )
				end
			end
		end
		ply:Hint( "You have disbanded ".. GAMEMODE.Orgs[ply.Org].Name .."." )
		ply:SetOrg( 0 )
		ply:SetNWInt("orgid", 0)
		GAMEMODE.Orgs[ply.Org] = nil
		return false
	else
		if Kick then
			ply:Hint( "You have been kicked from ".. GAMEMODE.Orgs[ply.Org].Name )
		else
			ply:Hint( "You have left ".. GAMEMODE.Orgs[ply.Org].Name )
		end
		
		tmysql.query( "UPDATE `ocrp_users` SET `org_id` = '0' WHERE `STEAM_ID` = '".. ply:SteamID() .."'" )
		for k, v in pairs(GAMEMODE.Orgs[ply.Org].Members) do
			if v.SteamID == ply:SteamID() then
				GAMEMODE.Orgs[ply.Org].Members[k] = nil
			end
		end
		ply:SetOrg(0)
		ply.Org = 0
	--	SendSingleOrgUser( ply )
		SecondaryID( ply )
		SecondaryIDLeave( ply )
		return false
	end
end

function GM.UpdateOrgName( ply, NewName )
	if !ply:InOrg() then return false end
	if GAMEMODE.Orgs[ply:GetOrg()].Owner != ply:SteamID() then return false end
	
	tmysql.query( "UPDATE `ocrp_orgs` SET `org_name` = '".. tmysql.escape(NewName) .."' WHERE `org_owner` = '".. ply:SteamID() .."'")
	GAMEMODE.Orgs[ply:GetOrg()].Name = NewName
	local NewName2 = GAMEMODE.Orgs[ply:GetOrg()].Name
	if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
		NewName2 = "Org name exceeds 25 chars"
	end
	for k,v in pairs(player.GetAll()) do
		if v:GetOrg() == ply:GetOrg() then
			v:SetNWString("OrgName", NewName2)
		end
	end
	SendOrg( ply )
end

function GM.UpdateOrgNotes( ply, NewNotes )
	if !ply:InOrg() then return false end
	if GAMEMODE.Orgs[ply:GetOrg()].Owner != ply:SteamID() then return false end
	
	tmysql.query( "UPDATE `ocrp_orgs` SET `org_notes` = '".. tmysql.escape(NewNotes) .."' WHERE `org_owner` = '".. ply:SteamID() .."'")
	GAMEMODE.Orgs[ply:GetOrg()].Notes = NewNotes
	SendOrg( ply )
end

function GM.OrgInvite( ply, cmd, args )
	if !ply:InOrg() then return false end
	if GAMEMODE.Orgs[ply:GetOrg()].Owner != ply:SteamID() then return false end

	local ORG_TOINVITE = args[1]
	if !ORG_TOINVITE then return false end

	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == ORG_TOINVITE then
			if tonumber(v:GetOrg()) < 1 then
				umsg.Start("ocrp_inv_mem", v )
					umsg.String( GAMEMODE.Orgs[ply:GetOrg()].Name )
				umsg.End()
				v.ORG_INV = ply:GetOrg()
				v.ORG_INV_BY = ply
			else
				ply:Hint(v:Nick().." is already in a organization")
			end
			for _, pl in pairs(player.GetAll()) do
				if pl:IsSuperAdmin() then
					pl:PrintMessage(HUD_PRINTCONSOLE, "(INVITE) ".. ply:Nick() .." invited ".. v:Nick() .." to ".. GAMEMODE.Orgs[ply:GetOrg()].Name ..".")
				end
			end
			return false
		end
	end
end

function GM.OrgInvite_Accept( ply, cmd, args )
	if !ply.ORG_INV then
		return false
	end
	if ply.ORG_INV_BY then
		ply.ORG_INV_BY:PrintMessage(HUD_PRINTTALK, "".. ply:Nick() .." accepted your invitation.")
	end

	GAMEMODE.JoinOrg(ply, ply.ORG_INV)

	ply.ORG_INV = 0
	ply.ORG_INV_BY = 0
end

function GM.OrgInvite_Deny( ply, cmd, args )
	if !ply.ORG_INV then
		return false
	end
	if ply.ORG_INV_BY then
		ply.ORG_INV_BY:PrintMessage(HUD_PRINTTALK, "".. ply:Nick() .." denied your invitation.")
	end

	ply.ORG_INV = 0
	ply.ORG_INV_BY = 0
end

function GM.RemoveMember( ply, said )
	if ply:GetOrg() == nil or ply:GetOrg() == 0 then print("no org") return false end
	if GAMEMODE.Orgs[ply:GetOrg()].Owner != ply:SteamID() then
		return false
	end
	
	local TO_REMOVEID = said
	local TO_REMOVE_FOUND

	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == TO_REMOVEID then
			if v:GetOrg() == ply:GetOrg() then
				if v:SteamID() != GAMEMODE.Orgs[ply:GetOrg()].Owner then
					GAMEMODE.QuitOrg( v, ply:GetOrg(), true )
					ply:Hint( "You have kicked ".. v:Nick() .." out of your organization." )
				else
					bool = true
					ply:Hint( "You can't kick yourself!" )
					return false
				end
			else
				ply:Hint( "Player is not in your organization." )
			end
		return false
		end
	end
	
	
	for k, v in pairs(GAMEMODE.Orgs[ply:GetOrg()].Members) do
		if v.steamid == TO_REMOVEID then
			ply:Hint( "You have kicked ".. v.Name .." out of your organization." )
			GAMEMODE.Orgs[ply:GetOrg()].Members[k] = nil
			TO_REMOVE_FOUND = true
		end
	end
		
	if TO_REMOVE_FOUND then
		tmysql.query("UPDATE `ocrp_users` SET `org_id` = '0', `org_rank` = '0' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
	else
		ply:Hint( "Player is not in your organization" )
	end
end

-- PMETA
function PMETA:InOrg()
	if self:GetOrg() == 0 then
		return false
	else
		return true
	end
end

function PMETA:SetOrg(OrgID)
	self.Org = OrgID
	self:SetNWInt("orgid", OrgID)
end

function PMETA:GetOrg()
	if self.Org == nil then
		return 0
	else
		return self.Org
	end
end

-- USERMESSAGES
function SendOrg( ply )
	if ply.Org != 0 and ply.Org != nil then
		timer.Simple(1, function()
		umsg.Start( "ocrp_org_setup", ply )
			umsg.Long( ply.Org )
			umsg.String( GAMEMODE.Orgs[ply:GetOrg()].Name )
			umsg.String( GAMEMODE.Orgs[ply:GetOrg()].Owner )
			umsg.String( GAMEMODE.Orgs[ply:GetOrg()].Notes )
		umsg.End()
		end)
		timer.Simple(3, function()
			for k, v in pairs(GAMEMODE.Orgs[ply:GetOrg()].Members) do
				umsg.Start( "ocrp_org_members_update", ply )
					umsg.String(v.Name)
					umsg.String(v.SteamID)
				umsg.End()
			end
		end)
		timer.Simple(2, function()
		umsg.Start("ocrp_second_id", ply)
			umsg.Long(ply.Org)
		umsg.End()
		end)
	end
end

function SendSingleOrgUser( ply )
	for k, v in pairs(GAMEMODE.Orgs[ply:GetOrg()].Members) do
		if v:GetOrg() == ply:GetOrg() then
			umsg.Start( "ocrp_org_members_update", v )
				umsg.String(ply:Nick())
				umsg.String(ply:SteamID())
			umsg.End()
		end
	end
end

function SecondaryID( ply )
	umsg.Start("ocrp_second_id", ply)
		umsg.Long(ply:GetOrg())
	umsg.End()
end

function SecondaryIDLeave( ply )
	umsg.Start("ocrp_second_id_l", ply)
	umsg.End()
end

--Commands
concommand.Add("ocrp_no", function( ply, cmd, args ) GAMEMODE.NewOrg( ply, args[1] ) end)
concommand.Add("ocrp_uon", function( ply, cmd, args ) GAMEMODE.UpdateOrgName( ply, args[1]) end)
concommand.Add("ocrp_uono", function( ply, cmd, args ) GAMEMODE.UpdateOrgNotes( ply, args[1]) end)
concommand.Add("ocrp_orem", function( ply, cmd, args ) print("runnign command orem") print(args[1]) GAMEMODE.RemoveMember( ply, args[1] ) end)
concommand.Add("ocrp_qo", function( ply, cmd, args ) GAMEMODE.QuitOrg( ply, args[1] ) end)
concommand.Add("ocrp_oinv", GM.OrgInvite)
concommand.Add("ocrp_oinva", GM.OrgInvite_Accept)
concommand.Add("ocrp_oinvd", GM.OrgInvite_Deny)


