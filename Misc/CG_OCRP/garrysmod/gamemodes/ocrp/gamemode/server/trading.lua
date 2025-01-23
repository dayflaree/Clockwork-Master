function ORCP_Trade_Player( ply )
	local pos = ply:EyePos()
	local posang = ply:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(posang*160)
	tracedata.filter = ply
	local trace = util.TraceLine(tracedata)
	if trace.HitWorld then return end
	if trace.HitNonWorld then
		if trace.Entity:IsPlayer() then
		
			ply.Offer = {Money = 0,Items = {}}
			umsg.Start("OCRP_TradePlayer", ply)
			umsg.Entity(trace.Entity)
			umsg.End()
			
			trace.Entity.Offer = {Money = 0,Items = {}}
			umsg.Start("OCRP_TradePlayer", trace.Entity)
			umsg.Entity(ply)
			umsg.End()
		elseif trace.Entity:GetClass() == "item_base" && trace.Entity:GetNWInt("Owner") == ply:EntIndex() && trace.Entity.Drug == nil && ply:Team() == CLASS_CITIZEN then
			umsg.Start("CL_PriceItem", ply)
				umsg.Bool(true)
				umsg.Entity(trace.Entity)
				umsg.Long(0)
				umsg.String(GAMEMODE.OCRP_Items[trace.Entity:GetNWString("Class")].Name)			
			umsg.End()
		end
	end
end
hook.Add("ShowSpare2", "ORCP_Trade_Player", ORCP_Trade_Player)


function SV_SendTradeData( ply,money,item,amount,slot )
	umsg.Start("OCRP_RecieveTradeItem", ply)
		umsg.Long(money)
		umsg.Long(slot)
		umsg.String(item)
		umsg.Long(amount)
		umsg.Bool(tobool(ply.Confirmed))
	umsg.End()
end

function SV_RecieveTradeItem(ply,money,item,amount,slot,ply2index)
	if money then print( "Rounding money" ) money = math.Round( money ) end
	if amount then print( "Rounding amount" ) amount = math.Round( amount ) end
	//if money then print( "Rounding Money" ) math.Round( money ) end
	if ply2index then print( "Rounding pl2index" ) ply2index = math.Round( ply2index ) end
	local ply2 = player.GetByID(ply2index)
	ply.Confirmed = false
	ply2.Confirmed = false
	SV_SendTradeData( ply2,money,item,amount,slot )
	if money != nil then
		ply.Offer.Money = money
	end	
	if slot != nil && item != nil && amount != nil then
		ply.Offer.Items[slot] =  {Item = item,Amount = amount}
	end
end

concommand.Add("OCRP_SendTrade", function(ply, command, args)  SV_RecieveTradeItem(ply,args[2],args[3],args[4],args[5],args[1])  end)

function SV_EndTrade(ply,ply2index)
	local ply2 = player.GetByID(ply2index)
	umsg.Start("OCRP_EndTrade", ply2)
	umsg.End()
end
concommand.Add("OCRP_EndTrade", function(ply, command, args)  SV_EndTrade(ply,math.Round(args[1])) end)

function SV_ConfirmTrade(ply,ply2index)
	local ply2 = player.GetByID(ply2index)
	ply.Confirmed = true
	if ply.Confirmed && ply2.Confirmed then
		ply.Confirmed = false
		ply2.Confirmed = false
	
		local ply_itemslost = {}
		local ply2_itemslost = {}
		
		local ply_itemsgained = {}
		local ply2_itemsgained = {}

		umsg.Start("OCRP_EndTrade", ply)
		umsg.End()
		
		umsg.Start("OCRP_EndTrade", ply2)
		umsg.End()
	
		local TRADE = true
		
		for _,data in pairs(ply.Offer.Items) do
			for i = 1,data.Amount do
				print("Debug: ".. data.Item)
				print("Debug: ".. data.Amount)
				if data.Item != "empty" && data.Amount > 0 then
					ply:Inv_RemoveItem(data.Item)
					table.insert(ply_itemslost,data.Item)
				end
			end
		end
		for _,data in pairs(ply2.Offer.Items) do
			for i = 1,data.Amount do
				if data.Item != "empty" && data.Amount > 0 then
					ply2:Inv_RemoveItem(data.Item)
					table.insert(ply2_itemslost,data.Item)
				end
			end
		end
		for _,item in pairs(ply_itemslost) do
			if ply2:HasRoom(item) then
				ply2:Inv_GiveItem(item)
				table.insert(ply2_itemsgained,item)
			else 
				TRADE = false
				ply:Hint(ply2:Nick().." Doesn't have enough room for the items")
				ply2:Hint("You don't have the room for the items")
				break
			end
		end
		for _,item in pairs(ply2_itemslost) do
			if ply:HasRoom(item) then
				ply:Inv_GiveItem(item)
				table.insert(ply_itemsgained,item)		
			else
				TRADE = false
				ply:Hint("You don't have the room for the items")
				ply2:Hint(ply:Nick().." Doesn't have enough room for the items")
				break
			end
		end
		if TRADE then
			for _,data in pairs(ply_itemsgained) do
				if data != "empty" then
					ply:Inv_RemoveItem(data)
				end
			end
			for _,data in pairs(ply2_itemsgained) do
				if data != "empty" then
					ply2:Inv_RemoveItem(data)
				end
			end		
			for _,data in pairs(ply_itemslost) do
				if data != "empty" then
					ply:Inv_GiveItem(data)
				end
			end
			for _,data in pairs(ply2_itemslost) do
				if data != "empty" then
					ply2:Inv_GiveItem(data)
				end
			end	
			for _,data in pairs(ply.Offer.Items) do
				if data.Amount > 0 && data.Item != nil && data.Item != "empty" then
					ply2:GiveItem(data.Item,data.Amount)
					ply:RemoveItem(data.Item,data.Amount)
				end
			end
			
			for _,data in pairs(ply2.Offer.Items) do
				if data.Amount > 0 && data.Item != nil && data.Item != "empty" then
					ply:GiveItem(data.Item,data.Amount)
					ply2:RemoveItem(data.Item,data.Amount)
				end
			end
			
			if ply.Offer.Money < 0 then
				ply.Offer.Money = 0
			end
			
			if ply2.Offer.Money < 0 then
				ply2.Offer.Money = 0
			end
			
			if ply.Offer.Money > ply2.Offer.Money then
				ply:AddMoney(WALLET, ply2.Offer.Money-ply.Offer.Money)
				ply2:AddMoney(WALLET, ply.Offer.Money-ply2.Offer.Money)
			elseif ply.Offer.Money < ply2.Offer.Money then
				ply:AddMoney(WALLET, ply2.Offer.Money-ply.Offer.Money)
				ply2:AddMoney(WALLET, ply.Offer.Money-ply2.Offer.Money)
			end
		else
			for _,data in pairs(ply_itemsgained) do
				if data != "empty" then
					ply:Inv_RemoveItem(data)
				end
			end
			for _,data in pairs(ply2_itemsgained) do
				if data != "empty" then
					ply2:Inv_RemoveItem(data)
				end
			end		
			for _,data in pairs(ply_itemslost) do
				if data != "empty" then
					ply:Inv_GiveItem(data)
				end
			end
			for _,data in pairs(ply2_itemslost) do
				if data != "empty" then
					ply2:Inv_GiveItem(data)
				end
			end	
		end
		ply.Offer = {Money = 0,Items = {}}
		ply2.Offer = {Money = 0,Items = {}}
	end
end
concommand.Add("OCRP_ConfirmTrade", function(ply, command, args) local num = tonumber(args[1]) SV_ConfirmTrade(ply,math.Round(num)) end)
		

