--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]
SF.theme.name = "Pokemon";
SF.theme.author = "Spencer Sharkey";
SF.theme.version = "v1.0";

function SF.theme:Initialize()
	self:Init();
	SF:IncludeDirectory("theme/maps", "THEME");
end;
