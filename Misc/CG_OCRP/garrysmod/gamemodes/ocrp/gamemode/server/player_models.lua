 
function OCRP_SetModelUpdate( ply,id,male)
	ply:SetNWInt( "myRPModel", id)
	if male then
		ply:ModelSet(GAMEMODE.OCRP_Models["Males"][ply:GetNWInt("myRPModel")].Outfits.Regular)
	else
		ply:ModelSet(GAMEMODE.OCRP_Models["Females"][ply:GetNWInt("myRPModel")].Outfits.Regular)
	end
end
concommand.Add( "OCRP_SetModelUpdate", function(ply,cmd,args) OCRP_SetModelUpdate(ply,math.Round(args[1]),tobool(args[2])) end )

function PMETA:ModelSet(mdlpath)
	self:SetModel(mdlpath)
end

function PMETA:SendWardrobe()
	local MyKey = self:FindKey( self:GetModel() )
	for k, v in pairs(self.OCRPData["Wardrobe"]) do
		print(v.Outfit)
		umsg.Start( "ocrp_wardrobe_update", self )
			umsg.Long( v.Key )
			umsg.String( v.Model )
			umsg.String( v.Outfit )
			umsg.Long( MyKey )
		umsg.End()
	end
end
			
function PMETA:AddToWardrobe(key,mdl,outfit)
	table.insert(self.OCRPData["Wardrobe"], {Key = tonumber(key), Model = mdl, Outfit = outfit})
	self:SendWardrobe()
	timer.Simple(1, function()
		GAMEMODE:SaveSQLWardrobe( self, key, mdl, outfit )
	end)
end

concommand.Add("AddToWardrobe",
	function(ply,cmd,args)
	print(args[1])
	print(args[2])
	print(args[3])
	PrintTable(args)
	if !args[4] then
		ply:AddToWardrobe(math.Round(args[1]),args[2],args[3])
	else
		ply:AddToWardrobe(math.Round(args[1]),args[2],args[3])
		ply:PickWardrobeChoice( args[2], args[1] )
	end
end)
	
function PMETA:FindKey( mdl )
	local key = 0
	if string.find(mdl, "_01") then
		key = 1
	elseif string.find(mdl, "_02") then
		key = 2
	elseif string.find(mdl, "_03") then
		key = 3
	elseif string.find(mdl, "_04") then
		key = 4
	elseif string.find(mdl, "_05") then
		key = 5
	elseif string.find(mdl, "_06") then
		key = 6
	elseif string.find(mdl, "_07") then
		key = 7
	elseif string.find(mdl, "_08") then
		key = 8
	elseif string.find(mdl, "_09") then
		key = 9
	end
	return key
end

function PMETA:PickWardrobeChoice( mdl, key )
	local bool = false
	for k, v in pairs( self.OCRPData["Wardrobe"] ) do
		if v.Model == mdl then
			bool = true
			break
		end
	end
	if !bool then return false end
	self:ModelSet( mdl )
	self.OCRPData["MyModel"] = mdl
	tmysql.query( "UPDATE `ocrp_users` SET `model` = '".. mdl .."', `key` = '".. key .."' WHERE `STEAM_ID` = '".. self:SteamID() .."'" )
end
concommand.Add("OCRP_PickWardrobeChoice", function(ply,cmd,args) ply:PickWardrobeChoice( args[1], args[2] ) end )

function PMETA:ChangeFace( Face )
	print(Face)
	Face = math.Round(Face)
	for k, v in pairs(self.OCRPData["Wardrobe"]) do
		print("HEH")
		if v.Key == Face then
			self:ModelSet( v.Model )
			self:PickWardrobeChoice( v.Model, Face )
			self:SendWardrobe()
			break
		else
			print("HEH2")
			for k, v in pairs(GAMEMODE.OCRP_Models[self:GetSex() .."s"][tonumber(Face)]) do
				table.insert(self.OCRPData["Wardrobe"], {Key = Face, Model = v, Outfit = k})
				self.OCRPData["MyModel"] = v
				self:ModelSet( v )
				self:PickWardrobeChoice( v, Face )
				self:SendWardrobe()
				GAMEMODE:SaveSQLWardrobe( self, Face, v, k )
				break
			end
		end
	end
end
concommand.Add("OCRP_ChangeFace", function(ply,cmd,args) ply:ChangeFace( args[1] ) end )
