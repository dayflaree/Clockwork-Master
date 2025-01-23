
function GM:Save(ply)
	if !ply.Loaded then return end
	local str_Steam = string.Replace(ply:SteamID(),":",";")
	for name,data in pairs(ply.OCRPData) do
		local path_FilePath = "OCRP/SAVES/"..str_Steam.."/"..tostring(name)..".txt"
		local StrindedItems = util.TableToKeyValues(data)
		file.Write(path_FilePath,StrindedItems)
	end
	local path_FilePathBank = "OCRP/SAVES/"..str_Steam.."/bank.txt"
	file.Write(path_FilePathBank,ply:GetMoney(BANK))
	
	local path_FilePathBank = "OCRP/SAVES/"..str_Steam.."/wallet.txt"
	file.Write(path_FilePathBank,ply:GetMoney(WALLET))
end

function SaveMoney( ply )
	tmysql.query( "UPDATE `ocrp_users` SET `bank` = '".. tonumber(ply:GetMoney(BANK)) .."', `wallet` = '".. tonumber(ply:GetMoney(WALLET)) .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'" )
end 

--[[function GM:SaveSQLSkill( ply, Skill )
	if 	!ply.Loaded  then return end
	ply.SaveSkills = ply.SaveSkills or {}
	local RandomNumber = math.random(1,40)
	ply.SaveSkills[Skill] = (CurTime() + 20) + RandomNumber
end]]--

function PMETA:UnCompileString( t, to_uncompile_string )
	local ExplodedStr = string.Explode( ";", to_uncompile_string )
	if t == "inv" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Items[ExplodedSecond[1]] != nil then
				if tonumber(ExplodedSecond[2]) >= 1 then
					if ExplodedSecond[1] != "item_ammo_cop" then
						self:GiveItem(ExplodedSecond[1],tonumber(ExplodedSecond[2]),"LOAD")
					end
				end
			end
		end
	elseif t == "car" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Cars[ExplodedSecond[1]] != nil then
				if !ExplodedSecond[3] then
					ExplodedSecond[3] = false
				end
				table.insert(self.OCRPData["Cars"], {car = ExplodedSecond[1], skin = tonumber(ExplodedSecond[2]), hydros = ExplodedSecond[3]})
			end
		end
		SendCarsClient( self )
	elseif t == "skill" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if string.lower(ExplodedSecond[1]) != "points" && GAMEMODE.OCRP_Skills[ExplodedSecond[1]] != nil then
				self.OCRPData["Skills"][ExplodedSecond[1]] = tonumber(ExplodedSecond[2])
				self:UpdateSkill( ExplodedSecond[1] )
				if GAMEMODE.OCRP_Skills[ExplodedSecond[1]].Function then
					GAMEMODE.OCRP_Skills[ExplodedSecond[1]].Function( self, ExplodedSecond[1] )
				end
			end
			if string.lower(ExplodedSecond[1]) == "points" then
				self.OCRPData["Skills"].Points = tonumber(ExplodedSecond[2])
			end
		end
	elseif t == "wardrobe" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ",", v )
			if ExplodedSecond and ExplodedSecond[1] and ExplodedSecond[2] and ExplodedSecond[3] then
				table.insert(self.OCRPData["Wardrobe"], {Key = tonumber(ExplodedSecond[1]), Model = string.lower(tostring(ExplodedSecond[2])), Outfit = ExplodedSecond[3], Choice = tostring(ExplodedSecond[4])})
			end
		end
		self:SendWardrobe()
	elseif t == "storage" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if ExplodedSecond and ExplodedSecond[1] then
				if GAMEMODE.OCRP_Items[ExplodedSecond[1]] != nil then
					if tonumber(ExplodedSecond[2]) >= 1 then
						self:GiveItem(ExplodedSecond[1],tonumber(ExplodedSecond[2]),"LOAD")
					end
				end
			end
		end
		tmysql.query("UPDATE `ocrp_users` SET `storage` = 'None' WHERE `STEAM_ID` = '".. self:SteamID() .."'")
	end
end

function PMETA:CompileString( t )
	local Compiled = ""
	if t == "inv" then
		for item, amt in pairs(self.OCRPData["Inventory"]) do
			if item != "WeightData" && !GAMEMODE.OCRP_Items[item].DoesntSave then
				Compiled = Compiled ..item.."."..tostring(amt)..";"
			end
		end
	elseif t == "car" then
		for _, d in pairs(self.OCRPData["Cars"]) do
			Compiled = Compiled ..d.car.."."..tostring(d.skin).."."..tostring(d.hydros)..";"
		end
	elseif t == "skill" then
		for skill, level in pairs(self.OCRPData["Skills"]) do
			Compiled = Compiled ..skill.."."..tostring(level)..";"
		end
	elseif t == "wardrobe" then
		for _, d in pairs(self.OCRPData["Wardrobe"]) do
			Compiled = Compiled .. tostring(d.Key) ..",".. d.Model ..",".. d.Outfit ..";"
		end
	elseif t == "storage" then
		for item, amt in pairs(self.OCRPData["Storage"]) do
			if !GAMEMODE.OCRP_Items[item].DoesntSave then
				Compiled = Compiled ..item.."."..tostring(amt)..";"
			end
		end
	end
	return Compiled
end

function GM:SaveSQLItemNow( ply, Item )
	if !ply.Loaded  then return end
	if !ply:IsValid() then return false end
	local ReturnedString = ply:CompileString("inv")
	tmysql.query("UPDATE `ocrp_users` SET `inv` = '".. ReturnedString .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
end

function GM:SaveSQLCar( ply, Car )
	if !ply.Loaded then return end
	if !ply:IsValid() then return false end
	local ReturnedString = ply:CompileString("car")
	tmysql.query("UPDATE `ocrp_users` SET `cars` = '".. ReturnedString .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
end

function GM:SaveSQLSkill( ply, Skill )
	if !ply.Loaded then return end
	if !ply:IsValid() then return false end
	local ReturnedString = ply:CompileString("skill")
	tmysql.query("UPDATE `ocrp_users` SET `skills` = '".. ReturnedString .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
end	

function GM:SaveSQLWardrobe( ply, Key, Mdl, Outfit, Choice )
	if !ply.Loaded then return end
	if !ply:IsValid() then return false end
	local ReturnedString = ply:CompileString("wardrobe")
	tmysql.query("UPDATE `ocrp_users` SET `wardrobe` = '".. ReturnedString .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
end	
			
