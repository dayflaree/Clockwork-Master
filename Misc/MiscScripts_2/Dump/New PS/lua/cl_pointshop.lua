LocalPlayer().PS_Points = 0
LocalPlayer().PS_Items = {}

function POINTSHOP.PostPlayerDraw(ply)
	-- Draw hats!
	if not ply:Alive() then return end
	--if not POINTSHOP.Config.AlwaysDrawHats and not hook.Call("ShouldDrawHats", GAMEMODE) and ply == LocalPlayer() and GetViewEntity():GetClass() == "player" then return end
	
	if POINTSHOP.Hats[ply] then
		for id, hat in pairs(POINTSHOP.Hats[ply]) do
			local pos = Vector()
			local ang = Angle()
			
			if not hat.Attachment and not hat.Bone then return end
			
			if hat.Attachment then
				local attach = ply:GetAttachment(ply:LookupAttachment(hat.Attachment))
				if not attach then return end
				pos = attach.Pos
				ang = attach.Ang
			elseif hat.Bone then
				pos, ang = ply:GetBonePosition(ply:LookupBone(hat.Bone))
			end
			
			hat.Model, pos, ang = hat.Modify(hat.Model, pos, ang)
			hat.Model:SetPos(pos)
			hat.Model:SetAngles(ang)
			
			hat.Model:SetRenderOrigin(pos)
			hat.Model:SetRenderAngles(ang)
			hat.Model:SetupBones()
			hat.Model:DrawModel()
			hat.Model:SetRenderOrigin()
			hat.Model:SetRenderAngles()
		end
	end
end

hook.Add("Think", "PS_Think", POINTSHOP.Think)
hook.Add("PostPlayerDraw", "PS_PostPlayerDraw", POINTSHOP.PostPlayerDraw)

-- Points and Items
function POINTSHOP.PS_Points(um)
	LocalPlayer().PS_Points = um:ReadLong()
end

function POINTSHOP.PS_Items(handler, id, encoded, decoded)
	LocalPlayer().PS_Items = decoded
end

-- Notify functions
function POINTSHOP.Notify(um)
	local text = um:ReadString()
	chat.AddText(Color(131, 255, 0), "[PS] ", Color(255, 255, 255), text)
end

-- Menu functions
function POINTSHOP.ShowShop(um)
	if um:ReadBool() then
		POINTSHOP.Menu = vgui.Create("DFrame")
		POINTSHOP.Menu:SetSize(475, 475)
		POINTSHOP.Menu:SetTitle("PointShop - " .. LocalPlayer():PS_GetPoints() .. " Points!")
		POINTSHOP.Menu:SetVisible(true)
		POINTSHOP.Menu:SetDraggable(true)
		POINTSHOP.Menu:ShowCloseButton(true)
		POINTSHOP.Menu:MakePopup()
		POINTSHOP.Menu:Center()
		POINTSHOP.Menu:SizeToContents()
		
		local Tabs = vgui.Create("DPropertySheet", POINTSHOP.Menu)
		Tabs:SetPos(5, 30)
		Tabs:SetSize(POINTSHOP.Menu:GetWide() - 10, POINTSHOP.Menu:GetTall() - 35)
		
		-- Feel free to add your own tabs.
		
		local ShopCategoryTabs = vgui.Create("DColumnSheet")
		ShopCategoryTabs:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 10)
        ShopCategoryTabs.Navigation:SetWidth(24)
        ShopCategoryTabs.Navigation:DockMargin(0, 0, 4, 0)
		
		local npc_id = um:ReadLong()
		local is_npc_menu = false
		
		if npc_id > 0 then
			is_npc_menu = true
			npcs = POINTSHOP.Config.Sellers[game.GetMap()]
			npc = npcs[npc_id]
			npc_categories = npc.Categories
		end
		
		for c_id, category in pairs(POINTSHOP.Items) do
			if category.Enabled then
				if (is_npc_menu and table.HasValue(npc_categories, category.Name)) or not is_npc_menu then
					local CategoryTab = vgui.Create("DPanelList", ShopCategoryTabs)
					CategoryTab:SetSpacing(5)
					CategoryTab:SetPadding(5)
					CategoryTab:EnableHorizontal(true)
					CategoryTab:EnableVerticalScrollbar(true)
					CategoryTab:Dock(FILL)
					
					for item_id, item in pairs(category.Items) do
						if item.Enabled then
							if not table.HasValue(LocalPlayer():PS_GetItems(), item_id) then
								if item.Model then
									local Icon = vgui.Create("DShopModel")
									Icon:SetData(item)
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function() RunConsoleCommand("pointshop_buy", item_id) end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
										end
									end
									CategoryTab:AddItem(Icon)
								elseif item.Material then
									local Icon = vgui.Create("DShopMaterial")
									Icon:SetData(item)
									Icon:SetSize(96, 96)
									Icon.DoClick = function()
										if LocalPlayer():PS_CanAfford(item.Cost) then
											Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " points?", "Buy Item",
												"Yes", function() RunConsoleCommand("pointshop_buy", item_id) end,
												"No", function() end
											)
										else
											Derma_Message("You can't afford this item!", "PointShop", "Close")
										end
									end
									CategoryTab:AddItem(Icon)
								end
							end
						end
					end
					ShopCategoryTabs:AddSheet(category.Name, CategoryTab, "gui/silkicons/" .. category.Icon, category.Name)
				end
			end
		end
		
		Tabs:AddSheet("Shop", ShopCategoryTabs, "gui/silkicons/application_view_tile", false, false, "Browse the shop!")
		
		-- Inventory Tab
		
		local InventoryContainer = vgui.Create("DPanelList", POINTSHOP.Menu)
		InventoryContainer:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 30)
		InventoryContainer:SetSpacing(5)
		InventoryContainer:SetPadding(5)
		InventoryContainer:EnableHorizontal(true)
		InventoryContainer:EnableVerticalScrollbar(false)
		
		for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
			
			local item = POINTSHOP.FindItemByID(item_id)
			
			if item then
				if item.Model then
					local Icon = vgui.Create("DShopModel")
					Icon:SetData(item)
					Icon:SetSize(96, 96)
					Icon.Sell = true
					Icon.DoClick = function()
						local menu = DermaMenu()
						menu:AddOption("Sell", function()
							Derma_Query("Do you want to sell '" .. item.Name .. "' for " .. POINTSHOP.Config.SellCost(item.Cost) .. " points?", "Sell Item",
								"Yes", function() RunConsoleCommand("pointshop_sell", item_id) end,
								"No", function() end
							)
						end)
						if item.Respawnable then
							menu:AddOption("Respawn", function()
								RunConsoleCommand("pointshop_respawn", item_id)
							end)
						end
						menu:Open()
					end
					
					InventoryContainer:AddItem(Icon)
				elseif item.Material then
					Icon = vgui.Create("DShopMaterial")
					Icon:SetData(item)
					Icon:SetSize(96, 96)
					Icon.Sell = true
					Icon.DoClick = function()
						local menu = DermaMenu()
						menu:AddOption("Sell", function()
							Derma_Query("Do you want to sell '" .. item.Name .. "' for " .. POINTSHOP.Config.SellCost(item.Cost) .. " points?", "Sell Item",
								"Yes", function() RunConsoleCommand("pointshop_sell", item_id) end,
								"No", function() end
							)
						end)
						if item.Respawnable then
							menu:AddOption("Respawn", function()
								RunConsoleCommand("pointshop_respawn", item_id)
							end)
						end
						menu:Open()
					end
					
					InventoryContainer:AddItem(Icon)
				end
			end
		end
		
		Tabs:AddSheet("Inventory", InventoryContainer, "gui/silkicons/box", false, false, "Browse your inventory!")
	else
		if POINTSHOP.Menu then
			POINTSHOP.Menu:Remove()
		end
	end
end

-- Hats functions
function POINTSHOP.AddHat(um)
	local ply = um:ReadEntity()
	local item_id = um:ReadString()
	
	if not ply and ValidEntity(ply) then return end
	if not item_id and not POINTSHOP.IsValidItemID(item_id) then return end
	
	if not POINTSHOP.Hats[ply] then POINTSHOP.Hats[ply] = {} end
	
	local item = POINTSHOP.FindItemByID(item_id)
	
	if not item then return end
	
	if not POINTSHOP.Hats[ply][item_id] then
		local mdl = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)
		mdl:SetNoDraw(true)
		
		POINTSHOP.Hats[ply][item_id] = {
			Model = mdl,
			Attachment = item.Attachment or nil,
			Bone = item.Bone or nil,
			Modify = item.Functions.ModifyHat or function(ent, pos, ang) return ent, pos, ang end
		}
	end
end

function POINTSHOP.RemoveHat(um)
	local ply = um:ReadEntity()
	local item_id = um:ReadString()
	
	if not ply and ValidEntity(ply) then return end
	if not item_id and not POINTSHOP.IsValidItemID(item_id) then return end
	
	if not POINTSHOP.Hats[ply] then POINTSHOP.Hats[ply] = {} return end
	
	if POINTSHOP.Hats[ply][item_id] then POINTSHOP.Hats[ply][item_id] = nil end
end

usermessage.Hook("PS_Points", POINTSHOP.PS_Points)
datastream.Hook("PS_Items", POINTSHOP.PS_Items)
usermessage.Hook("PS_Notify", POINTSHOP.Notify)
usermessage.Hook("PS_ShowShop", POINTSHOP.ShowShop)
usermessage.Hook("PS_AddHat", POINTSHOP.AddHat)
usermessage.Hook("PS_RemoveHat", POINTSHOP.RemoveHat)

local Player = FindMetaTable("Player")

--function Player:PS_GetPoints(