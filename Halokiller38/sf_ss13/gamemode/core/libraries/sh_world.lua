--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.world = {};

SF.world.stored = {
	name = "Default World",
	levels = {},
};

if (SERVER) then
	function SF.world:SaveWorld(name)
		file.Write("sf_"..name..".txt", Json.Encode(self.stored).." ");
	end;

	function SF.world:ReadWorld(name)
		return Json.Decode(file.Read("sf_"..name..".txt"));
	end;

	function SF.world:StreamToClient(player)
		SF:Net(player, "worldNetwork", {self.stored});
	end;

	SF:NetHook("worldLoad", function(player, data)
		SF.world.stored = SF.world:ReadWorld(data[1]);
		SF.world:StreamToClient(player);
	end);

else
	function SF.world:LoadWorld(name)
		SF:Net("worldLoad", {name});
	end;

	SF:NetHook("worldNetwork", function(data, len)
		SF.world.stored = data[1];
		print("Loaded World '"..data[1]['name'].."'");
	end);
	
end;


