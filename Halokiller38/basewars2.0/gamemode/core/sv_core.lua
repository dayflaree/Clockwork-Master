--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

-- A method called as the gamemode finishes loading
function RP:Initialize()
	if (self.InitCore) then
		self:InitCore();
	end;
	
	self.Data:Connect();
	
	//Some global variables
	self.lastSave = SysTime();
end;

-- A function to make an entity flush with the ground. Thanks Conna, again :3
function RP:MakeFlushToGround(entity, position, normal)
	entity:SetPos( position + ( entity:GetPos() - entity:NearestPoint( position - (normal * 512) ) ) );
end;

//Called every think hook
function RP:Think()
	if ((SysTime() - self.lastSave) >= 10) then
		self.lastSave = SysTime();
		self.Plugin:Call("GlobalSaveData");
	end;
end;

//Called when a player says something in the chatbox
function RP:PlayerSay(player, text, team)
	if (self.Plugin:Call("PlayerChatPreCommand", player, text, team) == false) then
		return "";
	end;

	if (RP.Command) then
		if (RP.Command:ParseSayText(player, text)) then
			return "";
		end;
	end;
	
	if (self.Plugin:Call("PlayerChat", player, text, team) == false) then
		return ""
	end;
	
	if (RP.chat) then
		RP.chat:ParseSayText(player, text, team);
	end;
	
	return "";
end;


//Called when shit
function RP:GetGameDescription()
	return self.Name.." ".."v"..self.Version..self.Hotfix;
end;