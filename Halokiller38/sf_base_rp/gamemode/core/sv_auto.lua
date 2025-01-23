--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

function SF:Initialize()
	SF.DB:Init();
end;

function SF:Query(...)
	return SF.DB:Query(...);
end

function SF:Esc(...)
	return SF.DB:Esc(...);
end;

function SF:ContentFolder(dir)
	local list = file.FindDir(dir.."/*", "GAME")
	for _, fdir in pairs(list) do
		if fdir != ".svn" then // Don't spam people with useless .svn folders
			self:ContentFolder(dir.."/"..fdir)
		end
	end
 
	for k,v in pairs(file.Find(dir.."/*.*", "GAME")) do
		resource.AddSingleFile(dir.."/"..v)
	end
end;

function SF:GetGameDescription()
	if (SF.theme) then
		return self.theme.name.." "..self.theme.version;
	else
		return "Slidefuse Base "..self.version;
	end;
end;