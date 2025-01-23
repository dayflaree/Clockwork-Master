
function PMETA:UpdateObjectItem(obj,item) 
	umsg.Start("OCRP_UpdateObjectItem", self)
		umsg.String(item)
		umsg.Short(obj.OCRPData["Inventory"][item])
		umsg.Short(obj.OCRPData["Inventory"].WeightData.Cur)
		umsg.Short(obj.OCRPData["Inventory"].WeightData.Max)
		umsg.Entity(obj)
	umsg.End()
end

function PMETA:UpdateObject(obj) 
	umsg.Start("OCRP_UpdateObject", self)
		umsg.Short(obj.OCRPData["Inventory"].WeightData.Cur)
		umsg.Short(obj.OCRPData["Inventory"].WeightData.Max)
		umsg.Entity(obj)
	umsg.End()
end

function Search_Request(ply,obj)
	local ply2 = player.GetByID(obj:GetNWInt( "Owner" ))
	if obj:IsPlayer() then
		ply2 = obj
	end
	umsg.Start("OCRP_AskSearch", ply2)
		if obj:IsPlayer() then
			umsg.String(ply:Nick().." wants to search your inventory")
		else
			umsg.String(ply:Nick().." wants to search your container")
		end
		umsg.Entity(obj)
		umsg.Entity(ply)
	umsg.End()
	
end
concommand.Add("OCRP_SearchRequest",function(ply,cmd,args) Search_Request(ply,tonumber(args[1])) end)

function Search_Reply(objid,plyid,bool) 
	local obj = ents.GetByIndex(objid)
	local ply2 = player.GetByID(plyid)
	if bool then
		ply2:Inv_View(obj)
	else
		ply2:Hint("Your search request has been denied")
	end	
end
concommand.Add("OCRP_SearchReply",function(ply,cmd,args) Search_Reply(math.Round(args[1]),math.Round(args[2]),tobool(args[3])) end)

function PMETA:Inv_View(obj)
	if obj.OCRPData["Inventory"] != nil then
		local empty = true
		for item,amount in pairs(obj.OCRPData["Inventory"]) do
			if item != "WeightData" && amount > 0 then
				self:UpdateObjectItem(obj,item)
				empty = false
			end	
		end
		if empty then
			self:UpdateObject(obj)
		end
		self:ConCommand("OCRP_Search")
	end
end
