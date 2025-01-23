local PANEL = {};

function PANEL:Init()
	self:SetSize(200, 90);
	self:SetSizable(false);
	self:ShowCloseButton(false);
	self:SetPos(0, (ScrH()/2)-self:GetTall()/2);
	
	self:SetTitle("Vote!");
	
	self.label = vgui.Create("DLabel", self);
	self.label:SetPos(5, 25);

	self.help = vgui.Create("DLabel", self);
	self.help:SetPos(5, 40);
	self.help:SetText("Please lock in your entry below.");
	self.help:SizeToContents();
	
	self.yesButton = vgui.Create("DButton", self);
	self.yesButton:SetSize((self:GetWide()/2)-30, 18);
	self.yesButton:SetPos(15, self:GetTall()-33);
	self.yesButton:SetText("Yes");
	function self.yesButton.DoClick()
		RP.command:Run("vote", "yes");
		self:Remove();
	end;
	
	self.noButton = vgui.Create("DButton", self);
	self.noButton:SetSize((self:GetWide()/2)-30, 18);
	self.noButton:SetPos((self:GetWide()/2) + 15, self:GetTall()-33);
	self.noButton:SetText("No");
	function self.noButton.DoClick()
		RP.command:Run("vote", "no");
		self:Remove();
	end;
end;


function PANEL:SetInfo(data)
	self.label:SetText(data.question)
	self.label:SizeToContents();
end;

vgui.Register("rpVote", PANEL, "DFrame");
	