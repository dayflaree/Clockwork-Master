RP.player = {};

local playerMeta = FindMetaTable("Player");

function RP.player:GetSteamID(steamID)
	local match = nil;
	for _, v in pairs(_player.GetAll()) do
		if (v:SteamID() == steamID) then
			match = v;
		end;
	end;
	return match;
end;

function playerMeta:Notify(string)
	local icon = "gui/silkicons/wrench";
	local color = Color(150, 205, 255);
	if (string.sub(string, -1) == "!") then
		icon = "gui/silkicons/exclamation";
		color = Color(255, 140, 140);
	end;
	
	if (SERVER) then
		RP.chat:Add(self, {color, string}, icon, "npc/turret_floor/ping.wav");
	else 
		RP.chat:Add({color, string}, icon, "npc/turret_floor/ping.wav");
	end;
end;

function playerMeta:GetWeaponTable(isSecondary)
	local weaponID = self.primaryWeapon;
	if (isSecondary) then
		weaponID = self.secondaryWeapon;
	end;
	
	local weaponTable = RP.item:Get(weaponID);
	
	return weaponTable;
end;

