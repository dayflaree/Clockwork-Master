local path = string.Replace(GM.Folder, "gamemodes/", "").."/gamemode/items/"
for k, v in pairs(file.FindInLua(path.."*.lua")) do
	AddCSLuaFile("Lounge/gamemode/items/"..v)
end

INVENTORYDATA = {}

function INVENTORY:Save(ply)
	local Data = util.TableToKeyValues(INVENTORYDATA[ply:UniqueID()])
	file.Write("INVENTORYDATA/"..ply:UniqueID()..".txt", Data)
end

function INVENTORY.DisconnectSave(ply)
	INVENTORY:Save(ply)
end
hook.Add("PlayerDisconnected", "INVENTORY.Save", INVENTORY.DisconnectSave)

function INVENTORY.Load(ply)
	if file.Exists("INVENTORYDATA/"..ply:UniqueID()..".txt") then
		local Data = util.KeyValuesToTable(file.Read("INVENTORYDATA/"..ply:UniqueID()..".txt"))
		INVENTORYDATA[ply:UniqueID()] = Data
		ply:RefreshInventory()
	else
		INVENTORYDATA[ply:UniqueID()] = {}
		INVENTORY:Save(ply)
	end
end
hook.Add("PlayerInitialSpawn", "INVENTORY.Load", INVENTORY.Load)

local Player = FindMetaTable("Player")

function Player:RefreshInventory()
	datastream.StreamToClients(self, "RefreshInventory", {INVENTORYDATA[self:UniqueID()]})
	return self
end
concommand.Add("INVENTORY_Refresh", function(ply, cmd, args) ply:RefreshInventory() end)

function Player:GiveItem(UniqueName, amount)
	if INVENTORYDATA[self:UniqueID()][UniqueName] then
		INVENTORYDATA[self:UniqueID()][UniqueName] = INVENTORYDATA[self:UniqueID()][UniqueName] + amount
	else
		INVENTORYDATA[self:UniqueID()][UniqueName] = amount
	end
	self:RefreshInventory()
end

function Player:TakeItem(UniqueName, amount)
	if INVENTORYDATA[self:UniqueID()][UniqueName] > 0 then
		INVENTORYDATA[self:UniqueID()][UniqueName] = INVENTORYDATA[self:UniqueID()][UniqueName] - amount
		if INVENTORYDATA[self:UniqueID()][UniqueName] < 0 then
			INVENTORYDATA[self:UniqueID()][UniqueName] = 0
		end
	else
		INVENTORYDATA[self:UniqueID()][UniqueName] = 0
	end
	self:RefreshInventory()
end

function INVENTORY:SpawnItem(ply, UniqueName)
	if not INVENTORY.ITEMS[UniqueName] then
		Msg(UniqueName.." does not exist...\n")
		if ply:IsPlayer() then ply:ChatPrint("What are you doing.") end
		return
	end
	
	local pos = ply:LocalToWorld(Vector(50, 0, 50))
	
	if INVENTORY.ITEMS[UniqueName].ClassName != "" then
		Item = ents.Create(INVENTORY.ITEMS[UniqueName].ClassName)
	else
		Item = ents.Create("lou_base_item")
	end
	Item:SetModel(INVENTORY.ITEMS[UniqueName].Model)
	Item:SetSkin(INVENTORY.ITEMS[UniqueName].Skin)
	Item:SetPos(pos)
	Item.InfoTable = INVENTORY.ITEMS[UniqueName]
	Item:Spawn()
	Item:HoverInfo({info = INVENTORY.ITEMS[UniqueName].Name, icon = INVENTORY.ITEMS[UniqueName].Icon, colourr = 255, colourg = 255, colourb = 255, coloura = 255})
	Item:Activate()
	ply:ConCommand("HideInventory")
end

function INVENTORY.DropItem(ply, cmd, args)
	if not ply:Alive() then return end
	
	for k, v in pairs(INVENTORYDATA[ply:UniqueID()]) do
		if k == args[1] then
			INVENTORY:SpawnItem(ply, args[1])
			ply:TakeItem(args[1], 1)
			ply:ConCommand("HideInventory")
			return
		end
	end
end
concommand.Add("INVENTORY_DropItem", INVENTORY.DropItem)

function INVENTORY.UseItem(ply, cmd, args)
	if not ply:Alive() then return end
	
	for k, v in pairs(INVENTORYDATA[ply:UniqueID()]) do
		if k == args[1] then
			INVENTORY.ITEMS[args[1]]:Use(ply)
			
			if INVENTORY.ITEMS[args[1]].RemoveOnUse then
				ply:TakeItem(args[1], 1)
			end
			
			ply:RefreshInventory()
			ply:ConCommand("HideInventory")
			return
		end
	end
end 
concommand.Add("INVENTORY_UseItem", INVENTORY.UseItem)

function INVENTORY.DropCurrentWeapon(ply, cmd, args)
	if not ply:Alive() then return end
	
	CurrentWeaponClass = ply:GetActiveWeapon()
	if CurrentWeaponClass then CurrentWeaponClass = CurrentWeaponClass:GetClass() end
	if not INVENTORY.ITEMS[CurrentWeaponClass] then Msg("Item "..CurrentWeaponClass.." doesn't exist!\n") return end
	INVENTORY:SpawnItem(ply, CurrentWeaponClass)
	ply:StripWeapon(CurrentWeaponClass)
	ply:ConCommand("HideInventory")
end
concommand.Add("INVENTORY_DropCurrentWeapon", INVENTORY.DropCurrentWeapon)