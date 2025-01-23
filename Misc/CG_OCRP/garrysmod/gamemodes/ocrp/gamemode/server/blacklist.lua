IsSeriousRP = true;

function GM.IsSeriousRP ( )
	--return false;
	return IsSeriousRP;
end

function GM.Blacklist ( Player, Command, Args )
	if !Player:IsAdmin() then Player:Hint("You're not an admin -.-") return false; end
	
	local From = math.Round(tonumber(Args[1]));
	local User = Args[2];
	local Reason = Args[3];
	
	local UsUser;
	for k, v in pairs(player.GetAll()) do
		if tonumber(v:UniqueID()) == tonumber(User) then
			UsUser = v;
		end
	end
	
	if !UsUser then Player:Hint('Could not find that player.'); return false; end
	
	if From == 999 then
		if GAMEMODE.IsSeriousRP() then
			--if !string.find(UsUser:GetTable().RoleplayData.Blacklist, tostring(From)) then
				--UsUser:GetTable().RoleplayData.Blacklist = UsUser:GetTable().RoleplayData.Blacklist .. '999';
				tmysql.query("UPDATE `OCrp_users` SET `bl_srs`='999' WHERE `STEAM_ID`='" .. UsUser:SteamID() .. "'");
				Player:Hint('He has been blacklisted from the serious RP server.');
				
				for k, v in pairs(player.GetAll()) do
					if v then
						v:PrintMessage(HUD_PRINTTALK, UsUser:Name() .. ' has been blacklisted from the Serious RP server.');
					end
				end
				
				gatekeeper.Drop(UsUser:UserID(), 'Blacklisted from Serious RP - Reason: ' .. Reason);
			--else
				--Player:Hint('He is already blacklisted from the Serious RP server.');
			--end
		else
			Player:Hint('This is not the Serious RP server -.-');
		end
		
		return false;
	end
	
end
concommand.Add('ocrp_bl_srs', GM.Blacklist);

function GM.UnBlacklist ( Player, Command, Args )
	if !Player:IsAdmin() then return false; end
	
	local From = math.Round(tonumber(Args[1]));
	local User = Args[2];
	
	local UsUser;
	for k, v in pairs(player.GetAll()) do
		if tonumber(v:UniqueID()) == tonumber(User) then
			UsUser = v;
		end
	end
	
	if From == 999 then
		--if !string.find(UsUser:GetTable().RoleplayData.Blacklist, tostring(From)) then
			--Player:Hint('He is not blacklisted from the Serious RP server.');
		--else
			--UsUser:GetTable().RoleplayData.Blacklist = string.gsub(UsUser:GetTable().RoleplayData.Blacklist, From, '');
			Player:Hint('He has been unblacklisted from the Serious RP server.');
			UsUser:Hint('You have been unblacklisted from the Serious RP server.');
			tmysql.query("UPDATE `ocrp_users` SET `bl_srs`=NULL WHERE `STEAM_ID`='" .. UsUser:SteamID() .. "'");
		--end
		
		return false;
	end
	
	if !UsUser then return false; end
	
end
concommand.Add('ocrp_ubl_srs', GM.UnBlacklist);

-- local PlayerMetaTable = FindMetaTable("Player");

-- function PlayerMetaTable:IsBlackListed ( TeamID ) 
	-- return string.find(self:GetTable().RoleplayData.Blacklist, tostring(TeamID));
-- end

