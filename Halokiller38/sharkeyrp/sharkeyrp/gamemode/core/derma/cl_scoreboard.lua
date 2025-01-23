surface.CreateFont("Arial", 22, 700, true, false, "rpPlayerlistFont");
surface.CreateFont("Arial", 16, 700, true, false, "rpPlayerlistFontSmall");
RP.menu = {};

local PANEL = {};

function PANEL:Init()
	self:SetVisible(false);
	self:SetSize(ScrW()*0.5, ScrH()*0.75);
	self:SetSizable(true);
	self:SetMinimumSize(500, 700);
	self:SetPos((ScrW()/2)-self:GetWide()/2, (ScrH()/2)-self:GetTall()/2);
	
	self.playerList = vgui.Create("DPanelList", self);
	self.playerList:EnableVerticalScrollbar(true);
	self.playerList:SetPadding(3);
	self.playerList:SetSpacing(3);
	
	self:PerformLayout();
	self:Rebuild();
end;

function PANEL:Rebuild()
	self.playerList:Clear();
	local players = {};

	for k, player in pairs(_player.GetAll()) do
		if (IsValid(player) and player.steamName) then
			players[player] = vgui.Create("DPanel", self.playerList);
			players[player]:SetSize(300, 50);
			
			players[player].avatar = vgui.Create("AvatarImage", players[player]);
				players[player].avatar:SetPos(2, 2);
				players[player].avatar:SetSize(48, 48);
				players[player].avatar:SetPlayer(player, 48);
				
			players[player].textInfo = vgui.Create("DPanel", players[player]);
				players[player].textInfo:SetSize(self.playerList:GetWide(), 50);
				players[player].textInfo.Paint = function()
					draw.SimpleTextOutlined(player:Name(), "rpPlayerlistFont", 58, 5, RP.job:Get(player.job).Color, 0, 0, 1, Color(0, 0, 0));
					draw.SimpleTextOutlined(RP.job:Get(player.job).name, "rpPlayerlistFontSmall", 58, 28, Color(255, 255, 255), 0, 0, 1, Color(0, 0, 0));
					
					
					draw.SimpleTextOutlined("Ping: "..player:Ping(), "rpPlayerlistFontSmall", players[player]:GetWide()-5, 5, Color(255, 255, 255), 2, 2, 1, Color(0, 0, 0));
					draw.SimpleTextOutlined(player.steamName, "rpPlayerlistFontSmall", players[player]:GetWide()-5, 22, Color(255, 255, 255), 2, 2, 1, Color(0, 0, 0));
				end;
			
			players[player].Paint = function()
				surface.SetDrawColor(50, 50, 50);
				surface.DrawRect(0, 0, players[player]:GetWide(), players[player]:GetTall()); 
			end;
			
			self.playerList:AddItem(players[player]);
		end;
	end;
	timer.Simple(1, self.Rebuild, self);
end;

function PANEL:PerformLayout()
	self.playerList:StretchToParent(4, 26, 4, 4);
end;

function PANEL:DoWordWrap(text, width)
	local lines = string.Explode("<br>", text);
	for k, textSplit in pairs(lines) do
		surface.SetFont("rpInventoryFont");
		local w, h = surface.GetTextSize(textSplit)
		if (w >= width) then
			local words = string.Explode(" ", textSplit);
			local length = 0;
			local cumm = "";
			local splitChar = 0;
			local prevLength = 0;
			for k, v in pairs(words) do
				cumm = cumm.." "..v;
				length = length + string.len(v) + 1;
				local w, h = surface.GetTextSize(cumm);
				if (w >= width) then
					splitChar = prevLength;
					break;
				end;
				prevLength = prevLength + string.len(v) + 1;
			end;
			
			if (splitChar != 0) then
				textTable = string.ToTable(textSplit);
				table.insert(textTable, splitChar, "<br>");
				if (textTable[splitChar + 1] == " ") then
					textTable[splitChar + 1] = "";
				end;
				text = table.concat(textTable, "");
			end;
			
		end;
	end;
	return text;
end;

vgui.Register("rpScoreboard", PANEL, "DFrame");
	