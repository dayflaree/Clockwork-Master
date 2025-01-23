/*
surface.CreateFont("Tahoma", 14, 1000, true, false, "PEChatFont") 

local IsTeamChat = false;
local IsChatOn = false;
local ChatLog = {};
local LinesToShow = 10;
local CurrentText = "";

local ChatColors_PrintMessage = Color(75, 255, 75, 255);
local ChatColors_Normal = Color(255, 100, 100, 255);
local ChatColors_OffServer = Color(150, 100, 255, 255);
local ChatColors_LocalChat = Color(200, 200, 200, 255);
local ChatColors_YourLocalChat = Color(255, 255, 255, 255);
local ChatColors_YourTalk = Color(255, 150, 150, 255);
local ChatColors_ServerBroadcast = Color(255, 0, 0, 255);
local ConsoleColor = Color(255, 51, 255);

local function AddMessage ( FromText, FromColor, Message, Type )
	if string.find(Message, "Kicked by Console") then return false; end
	if string.find(Message, "RETSASIRHC") or string.find(Message, "@@@@@@@") then return false; end
	if string.find(Message, "MINGEBAGS ARE TAKING OVER GMOD") then return false; end
	
	if string.find(Message, "left the game") then
		local UserName = string.Explode(Message, " ")[2];
		
		if !UserName or UserName == "" then return false; end
		
		Message = UserName .. " has left the game.";
	end
	
	if string.find(Message, "joined the game") then Message = Message .. "."; end
	
	if (Type == 1 or Type == 0 or Type == 4 or Type == 5) and string.len(FromText) > 20 then
		FromText = string.sub(FromText, 1, 18) .. "...";
	end
	
	if FromText != '' then
		Msg(FromText .. ": " .. Message .. "\n");
	else
		Msg(Message .. "\n");
	end

	local FormTable = {};
	
	FormTable.DrawColor = ChatColors_Normal;
	
	if Type == 1 then
		FormTable.DrawColor = ChatColors_YourTalk;
	elseif Type == 2 then
		FormTable.DrawColor = ChatColors_PrintMessage;
	elseif Type == 3 then
		FormTable.DrawColor = ChatColors_OffServer;
	elseif Type == 4 then
		FormTable.DrawColor = ChatColors_LocalChat;
	elseif Type == 5 then
		FormTable.DrawColor = ChatColors_YourLocalChat;
	elseif Type == 6 then
		FormTable.DrawColor = ChatColors_ServerBroadcast;
	end
	
	FormTable.FromText = string.Trim(tostring(FromText));
	FormTable.FromColor = FromColor;
	FormTable.Message = Message;
	FormTable.Time = CurTime();
	
	table.insert(ChatLog, FormTable);
end

local CustomChatColors = {};
function AddCustomChatID ( ID, Color2 )
	CustomChatColors[ID] = {};
	CustomChatColors[ID].TextColor = Color2;
end

local function GetCustomChat ( UMsg )
	local Player = UMsg:ReadEntity()
	local Text = UMsg:ReadString();
	local SetupID = UMsg:ReadShort();
	
	if Text == '' or Text == ' ' or Text == '   ' then return false; end
	
	local FormTable = {};
	local Suffix;
	if !Player or !Player:IsValid() or !Player:IsPlayer() then 
		Suffix = ''
	else
		FormTable.FromColor = team.GetColor(Player:Team());
		Suffix = Player:Nick();
		
		if !Player:GetNetworkedBool('pe_dis', false) then
			if Player:HasLevel(3) then
				FormTable.IsTemp = true;
			end
			if Player:HasLevel(2) then
				FormTable.IsAdmin = true;
			end
			if Player:HasLevel(1) then
				FormTable.IsSuperAdmin = true;
			end
			if Player:HasLevel(0) then
				FormTable.IsOwner = true;
			end
		end
	end
		
	if !CustomChatColors[SetupID] then Msg('CUSTOM CHAT COLOR ID ' .. SetupID .. ' NOT FOUND.\n'); end
	
	FormTable.FromText = Suffix;
	FormTable.Message = Text;
	FormTable.DrawColor = CustomChatColors[SetupID].TextColor;
	FormTable.Time = CurTime();
	
	if Suffix != '' then
		Msg(Suffix .. ": " .. Text .. "\n");
	else
		Msg(Text .. "\n");
	end
	
	table.insert(ChatLog, FormTable);
	
	surface.PlaySound(Sound('common/talk.wav'));
end
usermessage.Hook('PE_CUSTOMCHAT', GetCustomChat);

local function GetLocalChat ( UMsg )
	local Player = UMsg:ReadEntity();
	local Text = UMsg:ReadString();
		
	local MessageType = 4;
	
	surface.PlaySound(Sound('common/talk.wav'));

	if Player == LocalPlayer() then MessageType = 5; end
		
	if Player and Player:IsValid() then
		AddMessage(Player:Name(), team.GetColor(Player:Team()), Text, MessageType);
	end
end
usermessage.Hook('PE_LOCALCHAT', GetLocalChat);

local function GetGlobalChat ( UMsg )
	local Player = UMsg:ReadEntity();
	local Text = UMsg:ReadString();
		
	local MessageType = 0;
	
	surface.PlaySound(Sound('common/talk.wav'));

	if Player == LocalPlayer() then MessageType = 1; end
		
	if Player and Player:IsValid() then
		AddMessage(Player:Name(), team.GetColor(Player:Team()), Text, MessageType);
	end
end
usermessage.Hook('PE_GLOBALCHAT', GetGlobalChat);

local function GetOffServerChat ( UMsg )
	local PlayerName = UMsg:ReadString();
	local Text = UMsg:ReadString();
	local ServerName = UMsg:ReadString();
	
	surface.PlaySound(Sound('common/talk.wav'));
	
	if ServerName == "SVRBRD" then
		AddMessage("", Color(255, 255, 255, 255), Text, 6);
	else
		local MessageType = 3;
			
		if string.len(PlayerName) > 10 then
			PlayerName = string.sub(PlayerName, 1, 8) .. "...";
		end
			
		AddMessage(PlayerName .. " [ " .. ServerName .. " ]", Color(255, 255, 255, 255), Text, MessageType);
	end
end
usermessage.Hook('PE_OFFSERVER_CHAT', GetOffServerChat);

local function AddChatPaintInit ( )
	function GAMEMODE:ChatText ( PlayerIndex, PlayerName, Text, MessageType )
		if tonumber(PlayerIndex) == 0 then
			//if MessageType == 'none' then
				AddMessage('', ConsoleColor, Text, 2);
			//else
			//	AddMessage("Console", ConsoleColor, Text, 0);
			//end
		else
			return false;
		end
	end

	function GAMEMODE.ChatPaint ( )
		local x, y = 160, math.Round(ScrH() - (ScrH() * .25));
		
		local Number = 0;
		local Total = 0;
		
		local Cos = math.abs(math.sin(CurTime() * 2));
		
		for k, v in pairs(ChatLog) do
			if (v.Time + 15 > CurTime() or IsChatOn) and k > #ChatLog - LinesToShow then
				Total = Total + 1
			end
		end
		
		for k, v in pairs(ChatLog) do

			if (v.Time + 15 > CurTime() or IsChatOn) and k > #ChatLog - LinesToShow then	
				local Alpha = 255;
				
				if !IsChatOn and v.Time + 10 < CurTime() then
					local TimeLeft = v.Time + 15 - CurTime();
					
					Alpha = (255 / 5) * TimeLeft;
				end
				
				if v.FromText != '' then					
					if v.FromColor.r == 0 and v.FromColor.g == 0 and v.FromColor.b == 0 then
						draw.SimpleText(v.FromText .. ": ", "PEChatFont", x + 1, y - Total * 15 + Number * 15 + 1, Color(255, 255, 255, Alpha), 2);
					else
						draw.SimpleText(v.FromText .. ": ", "PEChatFont", x + 1, y - Total * 15 + Number * 15 + 1, Color(0, 0, 0, Alpha), 2);
					end
					
					if v.IsOwner then
						draw.SimpleTextOutlined(v.FromText .. ": ", "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.FromColor.r, v.FromColor.g, v.FromColor.b, Alpha), 2, 0, 1, Color(Cos * 255, 0, 0, Alpha * Cos));
					elseif v.IsSuperAdmin then
						draw.SimpleTextOutlined(v.FromText .. ": ", "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.FromColor.r, v.FromColor.g, v.FromColor.b, Alpha), 2, 0, 1, Color(Cos * 0, 255, 0, Alpha * Cos));
					elseif v.IsAdmin then
						draw.SimpleTextOutlined(v.FromText .. ": ", "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.FromColor.r, v.FromColor.g, v.FromColor.b, Alpha), 2, 0, 1, Color(Cos * 0, 0, 255, Alpha * Cos));
					elseif v.IsTemp then
						draw.SimpleTextOutlined(v.FromText .. ": ", "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.FromColor.r, v.FromColor.g, v.FromColor.b, Alpha), 2, 0, 1, Color(Cos * 255, 51, 255, Alpha * Cos));
					else
						draw.SimpleText(v.FromText .. ": ", "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.FromColor.r, v.FromColor.g, v.FromColor.b, Alpha), 2);
					end
				end

				draw.SimpleText(v.Message, "PEChatFont", x + 1, y - Total * 15 + Number * 15 + 1, Color(0, 0, 0, Alpha));
				draw.SimpleText(v.Message, "PEChatFont", x, y - Total * 15 + Number * 15, Color(v.DrawColor.r, v.DrawColor.g, v.DrawColor.b, Alpha));

				Number = Number + 1
			end
		end
		
		if IsChatOn then
			local Prefix = "Local: ";
			local Suffix = CurrentText .. ' ';
			
			if string.find(CurrentText, "!") == 1 or string.find(CurrentText, "/") == 1 then
				if GAMEMODE.Name == 'PERP' then
					if string.find(CurrentText, "///") == 1 then
						Prefix = "Local OOC: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-3);
					elseif string.find(CurrentText, "//") == 1 then
						Prefix = "OOC: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-2);
					elseif string.find(CurrentText, "/ooc") == 1 then
						Prefix = "OOC: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-4);
					elseif string.find(CurrentText, "/looc") == 1 then
						Prefix = "Local OOC: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-5);
					elseif string.find(CurrentText, "/whisper") == 1 then
						Prefix = "Whisper: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-8);
					elseif string.find(CurrentText, "/warrant") == 1 then
						Prefix = "Warrant: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-8);
					elseif string.find(CurrentText, "/yell") == 1 then
						Prefix = "Yell: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-5);
					elseif string.find(CurrentText, "/y") == 1 then
						Prefix = "Yell: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-2);
					elseif string.find(CurrentText, "/pm") == 1 then
						Prefix = "Private Message: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-3);
					elseif string.find(CurrentText, "/radio") == 1 then
						Prefix = "Police Radio: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-6);
					elseif string.find(CurrentText, "/r") == 1 then
						Prefix = "Reply to PM: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-2);
					elseif string.find(CurrentText, "/me") == 1 then
						Prefix = "Action: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-3);
					elseif string.find(CurrentText, "/advert") == 1 then
						Prefix = "Advert: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-7);
					elseif string.find(CurrentText, "/broadcast") == 1 then
						Prefix = "Broadcast: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-10);
					elseif string.find(CurrentText, "/broad") == 1 then
						Prefix = "Broadcast: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-6);
					elseif string.find(CurrentText, "/organization") == 1 then
						Prefix = "Organization: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-13);
					elseif string.find(CurrentText, "/org") == 1 then
						Prefix = "Organization: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-4);
					elseif string.find(CurrentText, "/911") == 1 or string.find(CurrentText, "/999") == 1 or string.find(CurrentText, "/000") == 1 or string.find(CurrentText, "/112") == 1 then
						Prefix = "Emergency Call: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-4);
					else
						Prefix = "Command: ";
						Suffix = string.Right(Suffix, string.len(Suffix)-1);
					end
				else
					Prefix = "Command: ";
					Suffix = string.Right(Suffix, string.len(Suffix)-1);
				end
			elseif IsTeamChat then
				Prefix = "Global: ";
			end
			
			surface.SetFont("PEChatFont");
			local w, h = surface.GetTextSize(Prefix .. string.sub(Suffix, 0, string.len(Suffix)-1))
			
			draw.RoundedBox(4, x - 5, y + 5, w + 14, h + 1, Color(255, 255, 255, 150))
			
			surface.SetTextColor(0, 0, 0, 150)
			surface.SetTextPos(x + 2, y + 5);
			surface.DrawText(Prefix .. Suffix);
			
			if (math.sin(CurTime() * 5) * 10) > 0 then
				surface.SetTextPos(x + w + 1, y + 5)
				surface.DrawText('|');
			end
		end
	end
	hook.Add("HUDPaint", "ZZGM.ChatPaint", GAMEMODE.ChatPaint);

	function GAMEMODE:StartChat() IsChatOn = true; return true; end
	function GAMEMODE:FinishChat() IsChatOn = false; IsTeamChat = false; CurrentText = ""; end
	function GAMEMODE:ChatTextChanged ( Text ) CurrentText = Text; end
	function GAMEMODE.StartTeamChat ( Player, Bind ) if string.find(Bind, "messagemode2") then IsTeamChat = true; end end
	hook.Add("PlayerBindPress", "GM.StartTeamChat", GAMEMODE.StartTeamChat)
end
hook.Add("Initialize", "GAMEMODE.AddChatPaintInit", AddChatPaintInit);

*/
