-- (c) Khub 2012-2013.
-- VGUI Extension - DatafilePopup
-- A popup component that shows up custom content, this is what pops up whenever one of the buttons in the DatafileFrame is pressed.

if (!Datafiles) then
	error("The DatafilePopup VGUI component couldn't be registered - Datafiles table is non-existant!");
	return;
end;

local CreateLoadingScreen = function()
	if (IsValid(Datafiles.ModalDialog)) then
		Datafiles.ModalDialog:Close();
		Datafiles:CreateModalDialog("loading");
	end;
end;

function Datafiles:CreateModalDialog(identifier, data)
	Datafiles.ModalDialog = vgui.Create("DatafilePopup");

	if (!identifier or type(identifier) ~= "string" or identifier:len() == 0) then
		Error("Invalid/none identifier supplied to modal dialog constructor!");
		Datafiles.ModalDialog:Remove();
		return;
	end;

	if (identifier == "addnote") then
		Datafiles.ModalDialog:SetTitle(data.ismedical and "ADD MEDICAL NOTE" or "ADD NOTE");

		Datafiles.ModalDialog.noteContainer = vgui.Create("DTextEntry", Datafiles.ModalDialog);
		Datafiles.ModalDialog.noteContainer:SetPos(10, 30);
		Datafiles.ModalDialog.noteContainer:SetSize(Datafiles.ModalDialog:GetWide() - 20, Datafiles.ModalDialog:GetTall() - 65);
		Datafiles.ModalDialog.noteContainer:SetMultiline(true);
		Datafiles.ModalDialog.noteContainer:SetAllowNonAsciiCharacters(true);
		Datafiles.ModalDialog.noteContainer:SetText("");

		Datafiles.ModalDialog.sendButton = vgui.Create("DatafileButton", Datafiles.ModalDialog);
		Datafiles.ModalDialog.sendButton:SetSize(100, 20);
		Datafiles.ModalDialog.sendButton:SetPos(Datafiles.ModalDialog:GetWide() - 10 - 100, Datafiles.ModalDialog:GetTall() - 30);
		Datafiles.ModalDialog.sendButton:SetButtonColor("green");
		Datafiles.ModalDialog.sendButton:SetButtonState(false);
		Datafiles.ModalDialog.sendButton:SetText("Note too short!");
		function Datafiles.ModalDialog.sendButton:DoClick()
			if (self:GetButtonState()) then
				Datafiles.Network:AddNote(data.CharacterKey, Datafiles.ModalDialog.noteContainer:GetText(), data.ismedical);
				CreateLoadingScreen();
			end;
		end;

		function Datafiles.ModalDialog.noteContainer:OnChange()
			if (self:GetText():len() < 16) then
				Datafiles.ModalDialog.sendButton:SetButtonState(false);
				Datafiles.ModalDialog.sendButton:SetText("Note too short!");
			elseif (self:GetText():len() > 512) then
				Datafiles.ModalDialog.sendButton:SetButtonState(false);
				Datafiles.ModalDialog.sendButton:SetText("Note too long!");
			else
				Datafiles.ModalDialog.sendButton:SetButtonState(true);
				Datafiles.ModalDialog.sendButton:SetText("Continue");
			end;
		end;
	elseif (identifier == "loyaltyact") then
		Datafiles.ModalDialog:SetTitle(data.loyalist and "NEW LOYALIST ACT RECORD" or "NEW CRIMINAL ACT RECORD");
		Datafiles.ModalDialog.ValueLabel = vgui.Create("DLabel", Datafiles.ModalDialog);
		Datafiles.ModalDialog.ValueLabel:SetFont("DatafileEntityQuickDetails");
		Datafiles.ModalDialog.ValueLabel:SetText("0 points");
		Datafiles.ModalDialog.ValueLabel:SetTextColor(Color(0, 64, 255));
		Datafiles.ModalDialog.ValueLabel:SizeToContents();
		Datafiles.ModalDialog.ValueLabel:SetPos(10, 40);
		Datafiles.ModalDialog.ValueLabel:CenterHorizontal();

		local min, max;

		if (data.loyalist) then
			min = 0;
			max = 5;
		else
			min = -10;
			max = 0;
		end;

		Datafiles.ModalDialog.ValueSelection = vgui.Create("DGrid", Datafiles.ModalDialog);
		Datafiles.ModalDialog.ValueSelection:SetCols(math.abs(min - max) + 1);
		Datafiles.ModalDialog.ValueSelection:SetColWide((Datafiles.ModalDialog:GetWide() - 10) / Datafiles.ModalDialog.ValueSelection:GetCols());
		Datafiles.ModalDialog.ValueSelection:SetPos(6, 65);
		Datafiles.ModalDialog.ValueSelection:SetSize(Datafiles.ModalDialog:GetWide() - 10, 30);

		for i = min, max, 1 do
			local btn = vgui.Create("DatafileButton");
			btn:AdjustSize(Datafiles.ModalDialog.ValueSelection:GetColWide() + 5, 25);

			local color = "blue";
			if (i < -5) then
				btn:SetText(i);
				color = "red";
			elseif (i < 0) then
				btn:SetText(i);
				color = "orange";
			elseif (i == 0) then
				btn:SetText(i);
				color = "blue";
			elseif (i > 0) then
				btn:SetText("+" .. i);
				color = "green";
			end;

			btn:SetButtonColor(color);
			btn:SetButtonState(true);
			

			function btn:DoClick(btn)
				if (IsValid(Datafiles.ModalDialog.ValueLabel)) then
					Datafiles.ModalDialog.ValueLabel:SetText(self:GetText() .. " points");
					Datafiles.ModalDialog.ValueLabel:SetTextColor(self.Colors[self.Color]);
					Datafiles.ModalDialog.ValueLabel:SizeToContents();
					Datafiles.ModalDialog.ValueLabel:CenterHorizontal();
				end;
			end;

			Datafiles.ModalDialog.ValueSelection:AddItem(btn);
		end;

		Datafiles.ModalDialog.noteContainer = vgui.Create("DTextEntry", Datafiles.ModalDialog);
		Datafiles.ModalDialog.noteContainer:SetPos(10, 90);
		Datafiles.ModalDialog.noteContainer:SetSize(Datafiles.ModalDialog:GetWide() - 20, Datafiles.ModalDialog:GetTall() - 120);
		Datafiles.ModalDialog.noteContainer:SetMultiline(true);
		Datafiles.ModalDialog.noteContainer:SetAllowNonAsciiCharacters(true);
		Datafiles.ModalDialog.noteContainer:SetText("");

		Datafiles.ModalDialog.sendButton = vgui.Create("DatafileButton", Datafiles.ModalDialog);
		Datafiles.ModalDialog.sendButton:SetSize(100, 20);
		Datafiles.ModalDialog.sendButton:SetPos(Datafiles.ModalDialog:GetWide() - 10 - 100, Datafiles.ModalDialog:GetTall() - 27);
		Datafiles.ModalDialog.sendButton:SetButtonColor("green");
		Datafiles.ModalDialog.sendButton:SetButtonState(false);
		Datafiles.ModalDialog.sendButton:SetText("Note too short!");
		function Datafiles.ModalDialog.sendButton:DoClick()
			Datafiles.Network:LoyaltyActRecord(data.CharacterKey, tonumber(string.sub(Datafiles.ModalDialog.ValueLabel:GetText(), 0, 2)), Datafiles.ModalDialog.noteContainer:GetText());
			CreateLoadingScreen();
		end;

		function Datafiles.ModalDialog.noteContainer:OnChange()
			if (self:GetText():len() < 16) then
				Datafiles.ModalDialog.sendButton:SetButtonState(false);
				Datafiles.ModalDialog.sendButton:SetText("Note too short!");
			elseif (self:GetText():len() > 512) then
				Datafiles.ModalDialog.sendButton:SetButtonState(false);
				Datafiles.ModalDialog.sendButton:SetText("Note too long!");
			else
				Datafiles.ModalDialog.sendButton:SetButtonState(true);
				Datafiles.ModalDialog.sendButton:SetText("Continue");
			end;
		end;
	elseif (identifier == "loyalisttier") then
		Datafiles.ModalDialog:SetTitle("CHANGE LOYALIST TIER");

		local tiersBox = vgui.Create("DPanelList", Datafiles.ModalDialog);
		tiersBox:SetPos(10, 45);
		tiersBox:SetSize(Datafiles.ModalDialog:GetWide() - 20, Datafiles.ModalDialog:GetTall() - 60);
		tiersBox:SetPadding(5);
		tiersBox:SetSpacing(5);

		for tierKey = 1, #Datafiles.LoyalistTiers do
			local tierData = Datafiles.LoyalistTiers[tierKey];

			local p = vgui.Create("DPanel");
			p:SetPaintBackground(false);
			p:SetSize(tiersBox:GetWide(), 30);

			local l = vgui.Create("DLabel", p);
			l:SetPos(10, 10);
			l:SetFont("DatafilePopupTitle");
			l:SetTextColor(tierData.tierColor);
			l:SetText(tierData.tierName);

			local plimit = vgui.Create("DLabel", p);
			plimit:SetPos(100, 10);
			plimit:SetFont("DatafilePopupTitle");
			plimit:SetTextColor(tierData.tierColor);
			plimit:SetText(tierData.pointsRequirement);

			local btn = vgui.Create("DatafileButton", p);
			btn:SetWide(90);
			btn:SetTall(20);
			btn:SetText("Select");
			btn:SetButtonColor("green");
			btn.TierID = tierKey;

			if (tierKey == data.LoyaltyTier) then
				btn:SetText("Current");
				btn:SetButtonState(false);
			end;

			if (Datafiles.Privileges:GetPlayerRank(LocalPlayer()) < tierData.canManipulate) then
				btn:SetText("No access!");
				btn:SetButtonState(false);
			end;

			function btn:DoClick()
				Datafiles.Network:ChangeLoyaltyTier(data.CharacterKey, self.TierID);
				CreateLoadingScreen();
			end;

			btn.x = p:GetWide() - 110;
			btn.y = 10;

			tiersBox:AddItem(p);
		end;

	elseif (identifier == "loading") then
		Datafiles.ModalDialog:SetTitle("PROCESSING REQUEST..");
		Datafiles.ModalDialog:SetTall(70);
		Datafiles.ModalDialog.closeButton:Remove();
		Datafiles.ModalDialog:Center();
		Datafiles.ModalDialog:SetDraggable(false);

		local random = math.random(1, 1000);
		Datafiles.ModalDialog.RandomHash = random;

		timer.Simple(2.5, function()
			if (IsValid(Datafiles.ModalDialog) and Datafiles.ModalDialog.RandomHash == random) then
				Datafiles.ModalDialog:Close();
			end;
		end);

		local animationPanel = vgui.Create("DPanel", Datafiles.ModalDialog);
		animationPanel:SetPos(5, 30);
		animationPanel:SetSize(Datafiles.ModalDialog:GetWide() - 10, Datafiles.ModalDialog:GetTall() - 40);
		
		animationPanel.StartTime = RealTime();
		animationPanel.BubbleWidth = (animationPanel:GetWide() - 20 - 20) / 4;

		function animationPanel:Paint(w, h)
			local bubbletime = RealTime() - self.StartTime;
			bubbletime = (bubbletime - math.floor(bubbletime)) / 2;

			for i = 1, 4 do
				local bubbleclr = Color(100, 100, 100);

				if (bubbletime > math.Clamp((i - 1)*0.12, 0, 1) and bubbletime < (i * 0.12)) then
					bubbleclr = Color(0, 0, 255);
				end;

				surface.SetDrawColor(bubbleclr);
				surface.DrawRect(10 + (i - 1)*self.BubbleWidth + (i - 1)*5, (h / 2) - 10, self.BubbleWidth, 20);
			end;

			return true;
		end;
	elseif (identifier == "confirmation") then
		Datafiles.ModalDialog:SetTitle("CONFIRMATION");
		Datafiles.ModalDialog:SetTall(150);

		local yesButton = vgui.Create("DatafileButton", Datafiles.ModalDialog);
		yesButton:SetButtonColor("green");
		yesButton.x = 10;
		yesButton.y = Datafiles.ModalDialog:GetTall() - 35;
		yesButton:SetText(data.yesText);
		yesButton:SetWide(data.yesWidth);

		function yesButton:DoClick()
			if (data.yesCallback) then
				local success, errorMessage = pcall(data.yesCallback);
				
				if (!success) then
					MsgC(Color(255,0,0), "[DatafilePopup] Confirmation popup yesCallback pcall failed with message:\n");
					MsgC(Color(255,255,0), errorMessage .. "\n");
				end;
			end;

			CreateLoadingScreen();
		end;

		local noButton = vgui.Create("DatafileButton", Datafiles.ModalDialog);
		noButton:SetButtonColor("red");
		noButton.x = Datafiles.ModalDialog:GetWide() - data.noWidth - 10;
		noButton.y = Datafiles.ModalDialog:GetTall() - 35;
		noButton:SetText(data.noText);
		noButton:SetWide(data.noWidth);

		function noButton:DoClick()
			if (data.noCallback) then
				local success, errorMessage = pcall(data.noCallback);

				if (!success) then
					MsgC(Color(255,0,0), "[DatafilePopup] Confirmation popup yesCallback pcall failed with message:\n");
					MsgC(Color(255,255,0), errorMessage .. "\n");
				end;
			end;

			Datafiles.ModalDialog:Close();
		end;

		local textLabel = vgui.Create("DLabel", Datafiles.ModalDialog);
		textLabel:SetFont("DatafileButton");
		textLabel:SetText(string.upper(data.description));
		textLabel:SetColor(Color(20, 20, 20));

		textLabel:SizeToContents();
		textLabel:Center();
	else
		Error("Invalid dialog type supplied to modal dialog constructor!");
		
		if (Datafiles.ModalDialog.Remove) then -- Remove bugged VGUI component if possible.
			Datafiles.ModalDialog:Remove();
		end;

		return;
	end;

	Datafiles.ModalDialog:DoModal();
	Datafiles.ModalDialog:MakePopup();
end;

local DatafilePopup = {};

function DatafilePopup:Init()
	self.btnMaxim:SetVisible(false);
	self.btnMinim:SetVisible(false);
	self.btnClose:SetVisible(false);
	self.lblTitle:SetVisible(false);

	self:SetSize(400, 300);
	self:Center();

	surface.CreateFont("DatafilePopupTitle", {
		font = "Arial",
		size = 20,
		weight = 800
	});

	self:CreateCloseButton();
	self:SetTitle("Modal Dialog");
end;

function DatafilePopup:CreateCloseButton()
	self.closeButton = vgui.Create("DButton", self);
	self.closeButton:SetPos(self:GetWide() - 80, 3);
	self.closeButton:SetSize(75, 20);
	self.closeButton:SetDrawOnTop(true);

	function self.closeButton:Paint(w, h)
		surface.SetDrawColor(self:IsHovered() and Color(20, 84, 255) or Color(20, 52, 148));
		surface.DrawRect(0, 0, w, h);

		surface.SetFont("DatafileEntityQuickDetails");
		surface.SetTextColor(Color(220, 220, 220));

		local tw, th = surface.GetTextSize("Cancel");
		surface.SetTextPos(0.5*w - 0.5*tw, 0.5*h - 0.5*th);
		surface.DrawText("Cancel");

		return true;
	end;

	self.closeButton.DoClick = function()
		self:Remove();
	end;
end;

function DatafilePopup:Paint(w, h)
	surface.SetDrawColor(Color(128, 182, 255));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(6, 7, 76));
	surface.DrawOutlinedRect(1, 1, w - 2, h - 2);
	surface.DrawOutlinedRect(2, 2, w - 4, h - 4);

	surface.DrawRect(0, 0, w, 25);

	surface.SetTextColor(Color(220, 220, 220));
	surface.SetFont("DatafilePopupTitle");
	surface.SetTextPos(10, 3);
	surface.DrawText(self.lblTitle:GetText());

	return true;
end;

vgui.Register("DatafilePopup", DatafilePopup, "DFrame");