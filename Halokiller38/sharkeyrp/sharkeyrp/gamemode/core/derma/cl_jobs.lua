surface.CreateFont("Arial", math.min(math.max(ScreenScale(14 / 2.62467192), math.min(14, 16)), 14), 700, true, false, "rpInventoryFont");

RP.menu = {};

local PANEL = {};

function PANEL:Init()
	self:SetVisible(false);
	self:SetSize(ScrW()*0.5, ScrH()*0.75);
	self:SetSizable(true);
	self:SetMinimumSize(500, math.Clamp(ScrH()*0.75, 0, ScrH()-50));
	self:ShowCloseButton(false);
	self:SetPos((ScrW()/2)-self:GetWide()/2, (ScrH()/2)-self:GetTall()/2);
	
	self.jobList = vgui.Create("DPanelList", self);
	self.jobList:EnableVerticalScrollbar(true);
	self.jobList:EnableHorizontal(true);
	self.jobList:SetSpacing(3);
	self.jobList:SetPadding(3);
	self.jobList:SetAutoSize(true);
	
	self.rightPane = vgui.Create("DPanelList", self);
	self.rightPane:EnableVerticalScrollbar(true);
	self.rightPane:SetSpacing(6);
	
	self:PerformLayout();
	timer.Simple(2, self.Rebuild, self);
end;


function PANEL:Rebuild()
	if (RP.job.jobs) then
		self.jobList:Clear();
		local jobs = {}
		for k, jobTable in pairs(RP.job.jobs) do
			jobs[k] = vgui.Create("SpawnIcon", self.jobList)
			jobs[k]:SetModel(table.Random(jobTable.models));	
			jobs[k]:SetIconSize(48);
			jobs[k]:SetToolTip(jobTable.name);
			jobs[k].DoClick = function()
				self:SetPane(k);
				self.currentJob = k;
			end;

			self.jobList:AddItem(jobs[k]);
		end;
	end;
end;

function PANEL:PerformLayout()
	self.jobList:StretchToParent(4, 26, 300, 4);
	self.rightPane:StretchToParent(self.jobList:GetWide()+8, 26, 4, 4);
	
	local gradient = surface.GetTextureID("VGUI/gradient_down");
	local quadObj = {
		texture = gradient,
		color = Color(0, 0, 0, 200),
		x = 0,
		y = 0,
		w = ScrW()
	};
	
	function self.rightPane:Paint()
		quadObj.h = self:GetTall();
		draw.TexturedQuad(quadObj);
	end;
	
	function self.jobList:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(50, 50, 50, 255));
	end;
	
	if (self.currentJob and RP.job:Get(self.currentJob)) then
		self:SetPane(self.currentJob)
	end;
end;

function PANEL:SetPane(itemID)
	local jobTable = RP.job:Get(itemID);
	self.rightPane:Clear();									
		
	local titleObj = vgui.Create("DLabel");
		titleObj:SetText(jobTable.name);
		titleObj:SetFont("MenuLarge");
		titleObj:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	self.rightPane:AddItem(titleObj);
	
	local modelObj = vgui.Create("DModelPanel");
		modelObj:SetSize(self.rightPane:GetWide(), self.rightPane:GetWide());
		modelObj:SetModel(table.Random(jobTable.models));
		modelObj:SetLookAt(Vector(0, 0, 50));
	self.rightPane:AddItem(modelObj);	
		
	local textObj = vgui.Create("DPanel");
		textObj:SetSize(self.rightPane:GetWide(), self.rightPane:GetTall()-375);
		local gradient = surface.GetTextureID("VGUI/gradient_down");
		local quadObj = {
			texture = gradient,
			color = Color(0, 0, 0, 50),
			x = 0,
			y = 0,
			w = textObj:GetWide(),
			h = textObj:GetTall()
		};
		textObj.Paint = function()
			draw.TexturedQuad(quadObj)
			
			if (type(jobTable.Description) == "function") then
				local currentColor = Color(255, 255, 255);
				local y = 5;
				local lastX = 5;
				for k, v in pairs(jobTable:Description(RP:NewDescMeta())) do
					if (type(v) == "table") then
						currentColor = v;
					elseif (type(v) == "string") then
						if (v == "<hr>") then
							lastX = 3;
							y = y + 18;
							surface.SetDrawColor(Color(175, 175, 175));
							surface.DrawRect(lastX, y, self.rightPane:GetWide()-6, 1);
							y = y + 3;
						elseif (v == "<br>") then
							lastX = 5;
							y = y + 16 + 2;
						else
							local text = self:DoWordWrap(v, self.rightPane:GetWide()-10);
							local lines = string.Explode("<br>", text);
							for _, lineText in pairs(lines) do
								if (lastX == 5) then
									lineText = string.TrimLeft(lineText);
								end;
								surface.SetFont("rpInventoryFont");
								local w, h = surface.GetTextSize(lineText);
								draw.SimpleTextOutlined(lineText, "rpInventoryFont", lastX, y, currentColor, 0, 0, 1, Color(0, 0, 0));	
								if (!string.find(text, "<br>")) then
									lastX = lastX + w;
								else
									lastX = 5;
									y = y + h + 2;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	self.rightPane:AddItem(textObj);	
	
	local buttonPanel = vgui.Create("DPanel");
		buttonPanel:SetTall(30);
		buttonPanel.useButton = vgui.Create("DButton", buttonPanel);
		buttonPanel.useButton:SetSize(self.rightPane:GetWide(), 30);
		
		buttonPanel.useButton:SetText("Apply!");
		buttonPanel.useButton.DoClick = function()
			RP.command:Run("jobApply", jobTable.uniqueID, table.Random(jobTable.models));
			self:ClearPane();
		end;
		
	self.rightPane:AddItem(buttonPanel);
end;

function PANEL:ClearPane()
	self.rightPane:Clear();
	self.currentJob = "";
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

vgui.Register("rpJobs", PANEL, "DFrame");