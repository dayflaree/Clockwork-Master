function SV_BuyClothes(ply,key,mdl,outfit)
	if ply:InVehicle() then return false end
	if ply:GetMoney(WALLET) >= 2500 then
		local TheKey = ply:FindKey(mdl)
		ply:AddToWardrobe(TheKey, mdl, outfit)
		ply:AddMoney(WALLET, 2500 * -1)
	end
end
concommand.Add("SV_BuyClothes", function(ply,cmd,args) if !ply:NearNPC( "KFC" ) then return false end SV_BuyClothes(ply,args[1],args[2],args[3]) end)

function SV_BuyItem(ply,item,ShopId,amt)
	if ply:InVehicle() then return false end
	if amt then
		if amt == 0 and item == "item_physgun" then
			return false
		end
	end
	local bool = false
	local taxbool = false
	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
		if v:IsNPC() then
			if v.Id == ShopId then
				bool = true
				break
			end 
		elseif v:GetClass() == "vendingmachines" && item == "item_nrg_drink" then
			bool = true
			taxbool = true
			break
		end
	end

	for _,v in pairs(GAMEMODE.OCRP_Shops[ShopId].Items) do 
		if v == item then 
			bool = true
		end
	end
	
	if ply:GetMoney(WALLET) >= (GAMEMODE.OCRP_Items[item].Price*amt) && bool && ply:HasRoom(item,amt) then
		ply:GiveItem(item,amt)
		ply:TakeMoney(WALLET,(GAMEMODE.OCRP_Items[item].Price*amt))
		if taxbool then
			Mayor_AddMoney((GAMEMODE.OCRP_Items[item].Price*amt)*(GetGlobalInt("Eco_Tax")/10))
		end
	end
end
concommand.Add("afawgfasegas4535tgsw33", function(ply, command, args)
	SV_BuyItem(ply,tostring(args[1]),tonumber(args[2]), math.Round(args[3]))
end)


function SV_SellItem(ply,item,ShopId,amount) 

	if ply:InVehicle() then return false end
	
	local bool = false
	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
		if v:IsNPC() then
			if v.Id == ShopId then
				bool = true
			end
		end
	end
	if ply:HasItem(item,tonumber(amount)) && bool then
		ply:RemoveItem(item,tonumber(amount))
		local div = 2
		if ShopId then
			if ShopId == 28 then
				div = 4
			end
		end
		ply:AddMoney(WALLET,(GAMEMODE.OCRP_Items[item].Price/div)*tonumber(amount))
	end
end 
concommand.Add("234rqw3tw4yw4yhew45yhws4gye", function(ply, command, args)  
	SV_SellItem(ply,tostring(args[1]),tonumber(args[2]),math.Round(args[3]))
end)

function META:PriceItem(price,desc)
	local num = 0
	local multi = 1
	local owner = player.GetByID(self:GetNWInt("Owner"))
	if owner:GetLevel() <= 4 then 
		multi = 2
	end
	for _,ent in pairs(ents.FindByClass("item_base")) do 
		if self:GetNWInt("Owner") == ent:GetNWInt("Owner") && ent.price != nil && ent.desc != nil then
			num = num + 1
		end
	end
	if num >= math.Round(OCRPCfg["Shop_Limit"]*multi) then
		player.GetByID(self:GetNWInt("Owner")):Hint("You have hit the shop limit")
		return
	end	
	self.DropTime = 0
	self.price = price
	self.desc = desc
	for _,ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			local amt = 0
			if self.Amount != nil && tonumber(self.Amount) > 1 then
				amt = self.Amount
			else
				amt = 1
			end		
			umsg.Start("CL_PriceItem", ply)
				umsg.Bool(false)
				umsg.Entity(self)
				umsg.Long(tonumber(price))
				umsg.String(tostring(desc))	
				umsg.Long(amt)
			umsg.End()
		end
	end
end
concommand.Add("OCRP_PriceItem",function(ply,cmd,args) ents.GetByIndex(math.Round(args[1])):PriceItem(tonumber(math.Round(args[2])),tostring(args[3])) end)
