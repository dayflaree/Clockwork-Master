INVENTORY = {}
INVENTORY.ITEMS = {}

function INVENTORY:RegisterItem(ITEM)
	INVENTORY.ITEMS[ITEM.UniqueName] = ITEM
end

function INVENTORY.PrintItems()
	for _, ITEM in pairs(INVENTORY.ITEMS) do
		Msg(ITEM.UniqueName.." -> "..ITEM.Name.."\n")
	end
end
concommand.Add("PrintItems", INVENTORY.PrintItems)

-- From Garryware
local path = string.Replace(GM.Folder, "gamemodes/", "").."/gamemode/items/"
for k, v in pairs(file.FindInLua(path.."*.lua")) do
	include("Lounge/gamemode/items/"..v)
end
