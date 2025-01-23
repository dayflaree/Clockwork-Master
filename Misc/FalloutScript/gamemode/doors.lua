----------------------------
-- LemonadeScript (March 29, 2008)
-- by LuaBanana
--
-- Alpha Version
-- doors.lua
----------------------------

LEMON.Doors = {}

function LEMON.LoadDoors()

	if(file.Exists("FalloutScript/MapData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read("FalloutScript/MapData/" .. game.GetMap() .. ".txt");
		local tabledata = util.KeyValuesToTable(rawdata);
		
		LEMON.Doors = tabledata;
		
	end
	
end

function LEMON.GetDoorGroup(entity)
		
	local pos = entity:GetPos();
	local doorgroups = {};

	for k, v in pairs(LEMON.Doors) do
		
		if(tonumber(v["x"]) == math.ceil(tonumber(pos.x)) and tonumber(v["y"]) == math.ceil(tonumber(pos.y)) and tonumber(v["z"]) == math.ceil(tonumber(pos.z))) then
			
			table.insert(doorgroups, v["group"]);
				
		end
			
	end

	return doorgroups;

end
