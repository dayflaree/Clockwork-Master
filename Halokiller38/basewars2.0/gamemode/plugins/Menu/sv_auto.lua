local PLUGIN = PLUGIN;

function PLUGIN:ShowHelp(ply)
	RP:DataStream(ply, "rpShowMenu", {});
	return false;
end;

-- function PLUGIN:PlayerNoClip(player)
	-- print("Sp");
	-- RP:DataStream(player, "rpShowMenu", {});
	-- return false;
-- end;
function RP.menu:HideMenu(player)
	RP:DataStream(player, "rpHideMenu", {});
end;
