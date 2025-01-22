-- (c) Khub 2012-2013.
-- VGUI Extension - DatafileFrame
-- The big grandma panel that holds all of the other Datafile controls.

function Datafiles:CreatePopup(data)
	Datafiles.DatafileFrame = vgui.Create("DatafileFrame");
	Datafiles.DatafileFrame:Setup(data);
	Datafiles.DatafileFrame:MakePopup();
end;

local DatafileFrame = {};
AccessorFunc(DatafileFrame, "IsDisabled", "Disabled", FORCE_BOOL);

function DatafileFrame:Init()
	self.btnMaxim:SetVisible(false);
	self.btnMinim:SetVisible(false);
	self.btnClose:SetVisible(false);
	self.lblTitle:SetVisible(false);

	self:SetDraggable(false);
	self:SetSize(800, 600);
	self:Center();

	self:CreateFonts();
	self:CreateCloseButton();
end;

function DatafileFrame:CreateActionButtons()
	self.ButtonsGrid = vgui.Create("DGrid", self);
	self.ButtonsGrid:SetSize(711, 250);
	self.ButtonsGrid:SetPos(60, 500);
	self.ButtonsGrid:SetCols(3);

	local ColumnSize = math.floor(self.ButtonsGrid:GetWide() / self.ButtonsGrid:GetCols());

	self.ButtonsGrid:SetColWide(ColumnSize);
	self.ButtonsGrid:SetRowHeight(30);

	local DummyPanel = self:CreateDummyPanel();

	for row = 1, 3 do
		for column = 1, 3 do
			local btn = DummyPanel;
			local btnData = self.ButtonsConfig[column][row];

			if (btnData) then
				if (type(btnData) == "function") then
					btnData = btnData(self.Data);
				end;

				btn = vgui.Create("DatafileButton");
				btn:AdjustSize(ColumnSize, 30);
				btn:SetText(string.upper(btnData.label));
				btn:SetButtonColor(btnData.color);

				if (type(btnData.disabled) == "boolean") then
					btn:SetButtonState(btnData.disabled ~= true);
				else
					btn:SetButtonState(btnData.disabled() ~= true);
				end;

				if (btnData.click) then
					btn.DoClick = function()
						if (btn:GetButtonState() == true) then
							btnData.click(self.Data);
						end;
					end;
				end;
			end;

			self.ButtonsGrid:AddItem(btn);
		end;
	end;
end;

-- Makes invisible dummy panel that's fed to DGrid as an item when a cell is supposed to be empty.
function DatafileFrame:CreateDummyPanel()
	local DummyPanel = vgui.Create("DPanel");
	DummyPanel:SetSize(1, 1);
	DummyPanel:SetPos(1, 1);

	function DummyPanel:Paint()
		return true;
	end;

	return DummyPanel;
end;

function DatafileFrame:FinishSetup()
	self.Data.NameColor = (self.Data.SubjectFaction == FACTION_MPF) and Color(12, 14, 76) or _team.GetColor(self.Data.SubjectClassID);
	self.Data.NameFont = self:GetEntityNameFont(self.Data.Name);	
	self.Data.Standing, self.Data.StandingColor = self:GetStandingData();
	self.Data.LastSpotted = Datafiles:GetDateFromTimestamp(self.Data.LastSpottedTimestamp);
end;

function DatafileFrame:GetStandingData()
	local faction = self.Data.SubjectFaction;

	if (faction) then
		local factionText = self.Data.Citizenship and "" or "ROGUE ";

		if (faction == FACTION_MPF) then
			return factionText .. "METROPOL UNIT";
		elseif (faction == FACTION_OTA) then
			return factionText .. "TRANSHUMAN ARM UNIT";
		elseif (faction == FACTION_CWU) then
			return factionText .. "CWU MEMBER";
		elseif (faction == FACTION_WI) then
			return factionText .. "WI MEMBER";
		elseif (faction == FACTION_UP) then
			return factionText .. "UP MEMBER";
		elseif (faction == FACTION_ADMIN) then
			return factionText .. "CIVIL ADMINISTRATION";
		end;
	end;

	local pts = tonumber(self.Data.LoyaltyPoints);

	if (!self.Data.Citizenship or pts <= -12) then
		return "ANTI-CITIZEN", Color(220, 0, 0);
	elseif (pts > -12 and pts < Datafiles.LoyalistTiers[1].pointsRequirement) then
		return "CITIZEN", Color(0, 0, 0);
	else
		for i = 1, #Datafiles.LoyalistTiers do
			local tierData = Datafiles.LoyalistTiers[i];

			if (self.Data.LoyaltyTier == i) then
				return string.upper(tierData.tierName .. " TIER LOYALIST"), tierData.tierColor;
			end;
		end;
	end;

	return "CITIZEN", Color(0, 0, 0);
end;

function DatafileFrame:Setup(datatable)
	self.Data = datatable;
	self:FinishSetup();

	self:CreateNoteBoxes();
	self:CreateActionButtons();
	
	self:Center();
	self:MakePopup();
end;

function DatafileFrame:CreateNoteBoxes()
	self:CreateNotesBox(60, self.Data.Notes.Medical);
	self:CreateNotesBox(300, self.Data.Notes.Loyalty);
	self:CreateNotesBox(540, self.Data.Notes.Other);
end;

function DatafileFrame:CreateCloseButton()
	self.closeButton = vgui.Create("DButton", self);
	self.closeButton:SetPos(self:GetWide() - 80, 5);
	self.closeButton:SetSize(75, 20);
	self.closeButton:SetDrawOnTop(true);

	function self.closeButton:Paint(w, h)
		surface.SetDrawColor(self:IsHovered() and Color(0, 64, 255) or Color(0, 32, 128));
		surface.DrawRect(0, 0, w, h);

		surface.SetFont("DatafileEntityQuickDetails");
		surface.SetTextColor(Color(220, 220, 220));

		local tw, th = surface.GetTextSize("Close");
		surface.SetTextPos(0.5*w - 0.5*tw, 0.5*h - 0.5*th);
		surface.DrawText("Close");

		return true;
	end;

	self.closeButton.DoClick = function()
		self:Remove();
	end;
end;

function DatafileFrame:CreateFonts()
	for i = 50, 10, -1 do
		surface.CreateFont("DatafileEntityName_" .. i, {
			font = "Arial",
			size = i,
			weight = 700
		});
	end;

	surface.CreateFont("DatafileEntityQuickDetails", {
		font = "Arial",
		size = 20,
		weight = 800
	});
end;

-- Used to draw table-looking labels that are under each other (STANDING, LOYALTY POINTS, CITIZENSHIP etc.)
function DatafileFrame:DrawColumnText(columnX, textY, label, value, valueColor)
	if (!valueColor) then
		valueColor = Color(0, 0, 0);
	end;

	local w, h = surface.GetTextSize(label);
	local labelX = math.Clamp(columnX - w, 0, columnX);

	surface.SetTextPos(labelX, textY);
	surface.SetTextColor(Color(6, 7, 76));
	surface.DrawText(label);

	surface.SetTextPos(columnX + 5, textY);
	surface.SetTextColor(valueColor);
	surface.DrawText(value);
end;

-- Used to determine what font are we using for entity name label / character name heading, to make it not overflow out of the window.
function DatafileFrame:GetEntityNameFont(name)
	for i = 50, 10, -1 do
		surface.SetFont("DatafileEntityName_" .. i);
		local textWidth = surface.GetTextSize(name);

		if (textWidth <= 550) then -- Text size is now OK.
			return "DatafileEntityName_" .. i;
		end;
	end;

	return "DermaDefault";
end;	

function DatafileFrame:CreateNotesBox(x, population)
	local notesBox = vgui.Create("DPanelList", self);
	notesBox:SetPos(x, 215);
	notesBox:SetSize(225, 265);
	notesBox:SetPadding(5);
	notesBox:SetSpacing(5);
	notesBox:EnableVerticalScrollbar(true);

	-- Custom paint function for scrollbar's top button.
	function notesBox.VBar.btnUp:Paint(w, h) 		
		surface.SetTextColor(self:IsHovered() and Color(0, 64, 255) or Color(0, 32, 128));
		surface.SetFont("DermaDefault");

		local tw, th = surface.GetTextSize("˄");
		surface.SetTextPos(0.5*w - 0.5*tw, 0.5*h - 0.5*th);
		surface.DrawText("˄");

		return true;
	end;

	-- Custom paint function for scrollbar's bottom button.
	function notesBox.VBar.btnDown:Paint(w, h) 		
		surface.SetTextColor(self:IsHovered() and Color(0, 64, 255) or Color(0, 32, 128));
		surface.SetFont("DermaDefault");

		local tw, th = surface.GetTextSize("˅");
		surface.SetTextPos(0.5*w - 0.5*tw, 0.5*h - 0.5*th);
		surface.DrawText("˅");
		
		return true;
	end;

	-- Custom paint function for scrollbar's container / background.
	function notesBox.VBar:Paint(w, h)
		return true;
	end;

	-- Custom paint function for scrollbar's grip.
	function notesBox.VBar.btnGrip:Paint(w, h)
		surface.SetDrawColor(Color(0, 32, 128));
		surface.DrawRect(w / 4, 0, w / 2, h);

		return true;
	end;	

	for k, v in pairs(population) do
		local note = vgui.Create("NotePanel");
		note:SetWide(200);
		note:Setup(v);

		notesBox:InsertAtTop(note);
	end;
end;

function DatafileFrame:PaintNotesContainer(x, y, w, h, borderColor, label, labelColor)
	surface.SetDrawColor(borderColor);
	surface.DrawRect(x, y, w, 25);
	surface.DrawOutlinedRect(x, y, w, h);

	surface.SetFont("DatafileEntityQuickDetails");

	local labelTextW, labelTextH = surface.GetTextSize(label);
	surface.SetTextPos(x + 0.5*w - 0.5*labelTextW, y + 0.5*25 - 0.5*labelTextH);
	surface.SetTextColor(labelColor);
	surface.DrawText(label);
end;

function DatafileFrame:Paint(w, h)
	surface.SetDrawColor(Color(124,175,202)); -- Darkening it a little bit.
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(6, 7, 76));
	surface.DrawOutlinedRect(1, 1, w - 1, h - 1);
	surface.DrawOutlinedRect(2, 2, w - 3, h - 3);

	surface.SetFont(self.Data.NameFont);
	
	if (self.Data and self.Data.Warrant == true) then
		if ((CurTime() - math.floor(CurTime())) >= 0.3) then
			surface.SetTextColor(Color(200, 0, 0));
		else
			surface.SetTextColor(Color(100, 30, 30));
		end;
	else
		surface.SetTextColor(self.Data.NameColor);
	end;

	surface.SetTextPos(70, 30);
	surface.DrawText(self.Data.Name);

	surface.SetFont("DatafileEntityQuickDetails");
	surface.SetTextColor(Color(6, 7, 76));

	self:DrawColumnText(220, 80, "STANDING:", self.Data.Standing, self.Data.StandingColor);
	self:DrawColumnText(220, 100, "LOYALTY POINTS:", tostring(self.Data.LoyaltyPoints), self.Data.StandingColor);
	self:DrawColumnText(220, 120, "CITIZENSHIP:", self.Data.Citizenship and "active" or "INACTIVE", self.Data.Citizenship and Color(0,0,0) or Color(200, 0, 0));
	self:DrawColumnText(220, 140, "CITIZENSHIP ID:", tostring(self.Data.CitizenID), Color(0, 0, 0));

	self:DrawColumnText(575, 80, "LOCATION:", self.Data.Location);
	self:DrawColumnText(575, 100, "LAST SPOTTED:", self.Data.LastSpotted);
	self:DrawColumnText(575, 120, "AT:", self.Data.LastSpottedLocation);

	self:PaintNotesContainer(60, 190, 225, 300, Color(6, 7, 76), "MEDICAL RECORDS", Color(220, 220, 220));
	self:PaintNotesContainer(300, 190, 225, 300, Color(0, 90, 20), "LOYALIST ACTIVITY", Color(220, 220, 220));
	self:PaintNotesContainer(540, 190, 225, 300, Color(20, 20, 20), "NOTES", Color(220, 220, 220));
end;

DatafileFrame.ButtonsConfig = {
	[1] = {
		{
			label = "Add a medical note",
			disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.AddMedicalRecord); end,
			color = "blue",
			click = function(data)
				data.ismedical = true;
				Datafiles:CreateModalDialog("addnote", data);
			end
		},
		{
			label = "Add a note",
			disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.AddNote); end,
			color = "blue",
			click = function(data)
				data.ismedical = false;
				Datafiles:CreateModalDialog("addnote", data);
			end
		},
		function(data)
			return {
				label = "Update last-seen",
				color = "blue",
				disabled = function() return (data.LastSpottedTimestamp + 300) > data.ServerTime end,
				click = function(data)
					Datafiles:CreateModalDialog("loading");
					Datafiles.Network:UpdateLastSeen(data.CharacterKey);
				end
			};
		end
	},
	[2] = {
		function (data)
			if (!Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.AddLoyaltyRecord)) then
				return {
					label = "Record loyalist act",
					disabled = true,
					color = "green",
				};
			end;

			local tier = data.LoyaltyTier;
			local allowed = true;
			local tierData = nil;

			if (allowed and tier > 0) then
				tierData = Datafiles.LoyalistTiers[tier];

				if (tierData) then
					if (Datafiles.Privileges:GetPlayerRank(LocalPlayer()) < tierData.canGivePoints) then
						allowed = false;
					end;
				end;
			end;

			if (allowed) then
				return {
					label = "Record loyalty act",
					disabled = false,
					color = "green",
					click = function(data)
						data.loyalist = true
						Datafiles:CreateModalDialog("loyaltyact", data);
					end;
				};		
			else
				return {
					label = Datafiles.Privileges.Ranks[tierData.canGivePoints].label .. "+ can add loyalty records!",
					disabled = true,
					color = "green"
				};
			end;	
		end,
		{
			label = "Record criminal act",
			disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.AddLoyaltyRecord); end,
			color = "orange",
			click = function(data)
				data.loyalist = false;
				Datafiles:CreateModalDialog("loyaltyact", data);
			end
		},
		function(data)
			local tier = data.LoyaltyTier;
			local allowed = true;

			if (tier > 0 and Datafiles.LoyalistTiers[tier]) then
				if (Datafiles.Privileges:GetPlayerRank(LocalPlayer()) < Datafiles.LoyalistTiers[tier].canManipulate) then
					allowed = false;
				end;
			end;

			return {
				label = "Change loyalist tier",
				disabled = !allowed,
				color = "blue",
				click = function(data)
					Datafiles:CreateModalDialog("loyalisttier", data);
				end
			};

		end
	},
	[3] = {
		function(data) 
			return {
				label = "Revoke loyalist status",
				disabled = function()
					if (Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.RevokeLoyaltyStatus)) then
						if (data.LoyaltyTier > 0) then
							return false;
						end;
					end;

					return true;
				end,
				color = "orange",
				click = function(data)
					data.yesText = "REVOKE";
					data.yesWidth = 150;
					data.yesCallback = function()
						Datafiles.Network:RevokeLoyalistStatus(data.CharacterKey);
					end;

					data.noText = "CANCEL";
					data.noWidth = 150;
					data.noCallback = function()
						return;
					end;

					data.description = "Are you sure to revoke this citizen's loyalty status?";

					Datafiles:CreateModalDialog("confirmation", data);
				end;
			};
		end,
		function(data)
			if (data.Citizenship) then
				return {
					label = "Revoke citizenship",
					disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.ManipulateCitizenship); end,
					color = "red",
					click = function(data)
						data.yesText = "REVOKE CITIZENSHIP";
						data.yesWidth = 150;
						data.yesCallback = function()
							Datafiles.Network:RevokeCitizenship(data.CharacterKey);
						end;

						data.noText = "CANCEL";
						data.noWidth = 150;
						data.noCallback = function()
							return;
						end;

						data.description = "Are you sure to revoke this entity's citizenship?";

						Datafiles:CreateModalDialog("confirmation", data);
					end;
				};
			else
				return {
					label = "Issue citizenship",
					disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.ManipulateCitizenship); end,
					color = "blue",
					click = function(data)
						data.yesText = "ISSUE CITIZENSHIP";
						data.yesWidth = 150;
						data.yesCallback = function()
							Datafiles.Network:IssueCitizenship(data.CharacterKey);
						end;

						data.noText = "CANCEL";
						data.noWidth = 150;
						data.noCallback = function()
							return;
						end;

						data.description = "Are you sure to award this entity with a citizenship?";

						Datafiles:CreateModalDialog("confirmation", data);
					end;
				};
			end;
		end,
		function (data)
			if (data.Warrant) then
				return {
					label = "Revoke BOL",
					disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.ManipulateBOL); end,
					color = "red",
					click = function(data)
						data.yesText = "REVOKE BOL";
						data.yesWidth = 150;
						data.yesCallback = function()
							Datafiles.Network:RevokeBOL(data.CharacterKey);
						end;

						data.noText = "CANCEL";
						data.noWidth = 150;
						data.noCallback = function()
							return;
						end;

						data.description = "Are you sure to revoke this entity's BOL?";

						Datafiles:CreateModalDialog("confirmation", data);
					end;
				};
			else
				return {
					label = "Place a BOL",
					disabled = function() return !Datafiles.Privileges:Verify(LocalPlayer(), Datafiles.Privileges.Config.ManipulateBOL); end,
					color = "red",
					click = function(data)
						data.yesText = "ACTIVATE BOL";
						data.yesWidth = 150;
						data.yesCallback = function()
							Datafiles.Network:PlaceBOL(data.CharacterKey);
						end;

						data.noText = "CANCEL";
						data.noWidth = 150;
						data.noCallback = function()
							return;
						end;

						data.description = "Are you sure to activate a BOL for this entity?";

						Datafiles:CreateModalDialog("confirmation", data);
					end;
				};
			end;
		end
	}
};

vgui.Register("DatafileFrame", DatafileFrame, "DFrame");