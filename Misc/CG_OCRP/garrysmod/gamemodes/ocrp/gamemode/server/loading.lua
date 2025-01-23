--LOAD THE PLAYERS STUFF
function GM:Load(ply)
	local str_Steam = string.Replace(ply:SteamID(),":",";")
	local path_FilePathbank = "OCRP/SAVES/"..str_Steam.."/bank.txt"
	local path_FilePathwallet = "OCRP/SAVES/"..str_Steam.."/wallet.txt"
	if file.Exists(path_FilePathbank) && file.Exists(path_FilePathwallet)  then
		ply:SetNWInt("bank",tonumber(file.Read(path_FilePathbank))) 	
		ply:SetNWInt("wallet",tonumber(file.Read(path_FilePathwallet)))
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePathbank) file.Delete(path_FilePathwallet) end end)		
	end
	
	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/inventory.txt"
	print(file.Exists(path_FilePath))
	if file.Exists(path_FilePath) then
		local inv = util.KeyValuesToTable(file.Read(path_FilePath))
		for k, v in pairs(inv) do
			if k != "weightdata" && v > 0 then
				ply:GiveItem(k,v)
			end
		end
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePath) end end)
	end
	PrintTable(ply.OCRPData["Inventory"])
	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/skills.txt"
	if file.Exists(path_FilePath) then
		local skill = util.KeyValuesToTable(file.Read(path_FilePath))
		for k,v in pairs(skill) do
			if k != "points" then
				ply.OCRPData["Skills"][k] = tonumber(v)
				ply:UpdateSkill(k)
				if GAMEMODE.OCRP_Skills[skill].Function != nil then
					GAMEMODE.OCRP_Skills[skill].Function(ply,skill)
				end
			else
				ply.OCRPData["Skills"].Points = v
			end
		end
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePath) end end)
	end

	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/cars.txt"
	if file.Exists(path_FilePath) then
		local Car = util.KeyValuesToTable(file.Read(path_FilePath))
		for k,v in pairs(Car) do
			table.insert(ply.OCRPData["Cars"], {car = v["car"],skin = tonumber(v["skin"])})
		end
		SendCarsClient(ply)
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePath) end end)
	end
	
	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/blacklists.txt"
	if file.Exists(path_FilePath) then
		local black = util.KeyValuesToTable(file.Read(path_FilePath))
		for k,v in pairs(black) do
			if tobool(v["cop"]) then
				ply.OCRPData["Blacklists"].Cop = true
			elseif tobool(v["medic"]) then
				ply.OCRPData["Blacklists"].Medic = true
			end
		end
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePath) end end)
	end
	
	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/wardrobe.txt"
	if file.Exists(path_FilePath) then
		local wardrobe = util.KeyValuesToTable(file.Read(path_FilePath))
		for k,v in pairs(wardrobe) do
			table.insert(ply.OCRPData["Wardrobe"], {Key = v["key"], Model = v["model"], Outfit = v["outfit"], Choice = tostring(v["choice"]) or tostring(false)})
		end
		ply:SendWardrobe()
		timer.Simple(60,function() if ply:IsValid() then file.Delete(path_FilePath) end end)
	else
		table.insert(ply.OCRPData["Wardrobe"], {Key = 1, Model = "models/player/Group01/male_01.mdl", Outfit = "Regular", Choice = tostring(true)})
		ply:SendWardrobe()
	end
	
	local toset_mdl
	PrintTable(ply.OCRPData["Wardrobe"])
	for k, v in pairs(ply.OCRPData["Wardrobe"]) do
		if tostring(v.Choice) == tostring(true) then
			toset_mdl = v.Model
		end
	end
	print("toset_mdl = "..toset_mdl)
	ply:ModelSet( toset_mdl )
	/* -- I gotta fix this, - Jake
	local path_FilePath = "OCRP/SAVES/"..str_Steam.."/challenges.txt"
	if file.Exists( path_FilePath ) then
		local Challenge = util.KeyValuesToTable(file.Read(path_FilePath))
		for k, v in pairs(Challenge) do
			ply.OCRPData["Challenges"][k].Num = tonumber(v['Num'])
			if v['CanDo'] then
				ply.OCRPData["Challenges"][k].CanDo = tobool(v['CanDo'])
			end
			if v['Complete'] then
				ply.OCRPData["Challenges"][k].Complete = tobool(v['Complete'])
			end
		end
	end*/
			

	tmysql.query( "SELECT org_id FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
	function( results )
		if #results >= 1 then
			print( "OCRP: Loading ".. ply:Nick() .."'s account" )
			print(results[1][1])
			ply:SetOrg(results[1][1])
			if tonumber(results[1][1]) != 0 then
				if !GAMEMODE.Orgs[ply:GetOrg()] then
					tmysql.query("SELECT org_name, org_owner, org_notes FROM `ocrp_orgs` WHERE `org_id` = '".. ply:GetOrg() .."'",
					function( Results )
						if #Results == 0 then return false end
						GAMEMODE.Orgs[ply:GetOrg()] = {}
						GAMEMODE.Orgs[ply:GetOrg()].Members = {}
						GAMEMODE.Orgs[ply:GetOrg()].Name = Results[1][1]
						GAMEMODE.Orgs[ply:GetOrg()].Owner = Results[1][2]
						GAMEMODE.Orgs[ply:GetOrg()].Notes = Results[1][3]
						tmysql.query("SELECT `STEAM_ID`, `nick` FROM `ocrp_users` WHERE `org_id` = '".. ply:GetOrg() .."'",
						function( Res )
							for k, v in pairs(Res) do
								table.insert(GAMEMODE.Orgs[ply:GetOrg()].Members, {Name = Res[k][2], SteamID = Res[k][1]})
							end
							SendOrg( ply )
						end)
					end)
					timer.Simple(.7, function()
						if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
							ply:SetNWString("OrgName", "Org name exceeds 25 chars")
						else
							ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
						end
						SecondaryID( ply )
					end)
				else
					SendOrg( ply )
					if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
						ply:SetNWString("OrgName", "Org name exceeds 25 chars")
					else
						ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
					end
					timer.Simple(1, function()
						SecondaryID( ply )
					end)
				end
			end
			print( "OCRP: Loaded ".. ply:Nick() .."'s account" )
		else
			print( "OCRP: ".. ply:Nick() .." Needs a new account, running the function..." )
			NewRPUser( ply )
		end
	end)

end

function GM:LoadSQL( ply )
	if !ply:IsValid() then return end
	timer.Simple(4, function()
		if !ply:IsValid() then return end
		tmysql.query( "SELECT `wallet`, `bank`, `bl_medic`, `bl_police`,`inv`, `cars`, `skills`, `wardrobe`, `model` FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
		function( Results)
		
			if #Results >= 1 and Results[1][1] and Results[1][1] != "" then
				if Results[1][9] then ply:ModelSet( Results[1][9] ) ply.OCRPData["MyModel"] = Results[1][9] end
				ply:SetMoney( WALLET, tonumber(Results[1][1]) )
				ply:SetMoney( BANK, tonumber(Results[1][2]) )
				ply.OCRPData["Blacklists"].Medic = tostring(Results[1][3]) or false
				ply.OCRPData["Blacklists"].Cop = tostring(Results[1][4]) or false
				timer.Simple(.3, function()
					tmysql.query( "UPDATE `ocrp_users` SET `nick` = '".. tmysql.escape(ply:Nick()) .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'" )
				end)
				ply:UnCompileString("inv", Results[1][5])
				ply:UnCompileString("car", Results[1][6])
				ply:UnCompileString("skill", Results[1][7])
				print("Wardrobe :".. Results[1][8])
				if Results[1][8] == "N" then
					print("Wardrobe: isnil")
					umsg.Start("ocrp_showstartmodel", ply)
					umsg.End()
				else
					print("Wardrobe: isNOTnil")
					ply:UnCompileString("wardrobe", Results[1][8])
				end
				ply.Loaded = true
			else
				NewRPUser( ply )
				ply.Loaded = true
			end
		end)
	end)
	timer.Simple(5, function()
		if !ply:IsValid() then return end
		tmysql.query( "SELECT org_id FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
		function( results )
			if #results >= 1 then
				ply:SetOrg(results[1][1])
				if results and results[1][1] then
					ply.Org = results[1][1]
					ply:SetNWInt("org_id", results[1][1])
				end
				if tonumber(results[1][1]) != 0 then
					if !GAMEMODE.Orgs[ply.Org] then
						tmysql.query("SELECT org_name, org_owner, org_notes FROM `ocrp_orgs` WHERE `org_id` = '".. ply:GetOrg() .."'",
						function( Results )
							if #Results == 0 then return false end
							GAMEMODE.Orgs[ply:GetOrg()] = {}
							GAMEMODE.Orgs[ply:GetOrg()].Members = {}
							GAMEMODE.Orgs[ply:GetOrg()].Name = Results[1][1]
							GAMEMODE.Orgs[ply:GetOrg()].Owner = Results[1][2]
							GAMEMODE.Orgs[ply:GetOrg()].Notes = Results[1][3]
							tmysql.query("SELECT `STEAM_ID`, `nick` FROM `ocrp_users` WHERE `org_id` = '".. ply:GetOrg() .."'",
							function( Res )
								for k, v in pairs(Res) do
									table.insert(GAMEMODE.Orgs[ply:GetOrg()].Members, {Name = Res[k][2], SteamID = Res[k][1]})
								end
								SendOrg( ply )
							end)
						end)
						timer.Simple(.7, function()
							if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
								ply:SetNWString("OrgName", "Org name exceeds 25 chars")
							else
								ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
							end
							SecondaryID( ply )
						end)
					else
						SendOrg( ply )
						if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
							ply:SetNWString("OrgName", "Org name exceeds 25 chars")
						else
							ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
						end
						timer.Simple(1, function()
							SecondaryID( ply )
						end)
					end
				end
				ply.Loaded = true
			else
				ply.Loaded = true
			end
		end)
	end)
	SendOrg(ply)
end



