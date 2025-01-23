POINTSHOP = {}

POINTSHOP.Items = {}
POINTSHOP.Hats = {}

function POINTSHOP.FindItemByID(ITEM_ID)
	for c_name, category in pairs(POINTSHOP.Items) do
		for item_id, item in pairs(category.Items) do
			if item_id == ITEM_ID then
				return item
			end
		end
	end
	
	return false
end

function POINTSHOP.FindPlayerByName(part)
	for _, ply in pairs(player.GetAll()) do
		if string.find(string.lower(ply:Nick()), part) then
			return ply
		end
	end
	return false
end

function POINTSHOP.ValidateItems(items)
	local ret = {}
	
	for k, ITEM_ID in pairs(items) do
		for c_name, category in pairs(POINTSHOP.Items) do
			for item_id, item in pairs(category.Items) do
				if item_id == ITEM_ID then
					ret[item_id] = item
				end
			end
		end
	end
	
	return ret
end

function POINTSHOP.IsValidItemID(ITEM_ID)
	for c_name, category in pairs(POINTSHOP.Items) do
		for item_id, item in pairs(category.Items) do
			if item_id == ITEM_ID then
				return true
			end
		end
	end
	
	return false
end

for _, fname in pairs(file.FindInLua("items/*")) do
	if #file.FindInLua("items/" .. fname .. "/__category.lua") > 0 then
		CATEGORY = {}
		AddCSLuaFile("items/" .. fname .. "/__category.lua")
		include("items/" .. fname .. "/__category.lua")
		
		if not POINTSHOP.Items[CATEGORY.Name] then
			CATEGORY.Items = {}
			POINTSHOP.Items[CATEGORY.Name] = CATEGORY
		end
		
		for _, name in pairs(file.FindInLua("items/" .. fname .. "/*.lua")) do
			if name ~= "__category.lua" then
				ITEM = {}
				AddCSLuaFile("items/" .. fname .. "/" .. name)
				include("items/" .. fname .. "/" .. name)
				ITEM.ID = string.sub(name, 1, -5)
				POINTSHOP.Items[CATEGORY.Name].Items[ITEM.ID] = ITEM
			end
		end
	end
end