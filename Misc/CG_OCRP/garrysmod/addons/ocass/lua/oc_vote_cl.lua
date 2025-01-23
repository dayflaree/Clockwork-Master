
surface.CreateFont("Tahoma", 28, 1000, true, false, "PEVoteFont") 

surface.SetFont('PEVoteFont');
local TextSize_X, TextSize_Y = surface.GetTextSize('Test Vote Option...');

function PE_OPEN_VOTE_MENU ( )
	local VoteSize_X = 300;
	local VoteSize_Y = (PE_EXPECTING_VOTE_OPTIONS + 1) * TextSize_Y;
	
	local VotePanel = vgui.Create('DFrame');
	
	gui.EnableScreenClicker(true);

	VotePanel:SetSize(VoteSize_X * .5, VoteSize_Y * .5);
	VotePanel:SetPos((ScrW() * .5) - (VoteSize_X * .25), (ScrH() * .5) - (VoteSize_Y * .25));
	VotePanel:MakePopup();
	VotePanel:SetAlpha(0);
	VotePanel:ShowCloseButton(true);
	VotePanel:SetDraggable(false)
	VotePanel:SetTitle(string.gsub(PE_VOTE_NAME, '#039;', '"') or 'Pulsar Effect Vote Center');

	function VotePanel:Close ( )
		if self.Closing then return false; end
		
		gui.EnableScreenClicker(false);
		
		self.Closing = true;
		
		for i = 1, 50 do
			timer.Simple(i * .005, function ( ) 
				self:SetAlpha(225 - (i * 4.5)); 
				
				local PanelSize_X = (VoteSize_X) - (VoteSize_X * (i * .01));
				local PanelSize_Y = (VoteSize_Y) - (VoteSize_Y * (i * .01));
				
				self:SetSize(PanelSize_X, PanelSize_Y);
				self:SetPos((ScrW() * .5) - (PanelSize_X * .5), (ScrH() * .5) - (PanelSize_Y * .5));
				self:MakePopup();
				
				if i == 50 then self:Remove(); end
			end);
		end
	end

	for i = 1, 50 do
		timer.Simple(i * .005, function ( ) 
			VotePanel:SetAlpha(i * 4.5); 
			
			local PanelSize_X = (VoteSize_X * .5) + (VoteSize_X * (i * .01));
			local PanelSize_Y = (VoteSize_Y * .5) + (VoteSize_Y * (i * .01));
			
			VotePanel:SetSize(PanelSize_X, PanelSize_Y);
			VotePanel:SetPos((ScrW() * .5) - (PanelSize_X * .5), (ScrH() * .5) - (PanelSize_Y * .5));
		end);
	end
	
	for k, v in pairs(PE_VOTE_OPTIONS) do
		v.CheckBox = vgui.Create('DCheckBox', VotePanel);
		v.CheckBox:SetPos(10, k * TextSize_Y);
		v.CheckBox:SetSize(TextSize_Y * .75, TextSize_Y * .75);
		
		v.Label = vgui.Create('DLabel', VotePanel);
		v.Label:SetPos(10 + (TextSize_Y * 1.25), k * TextSize_Y);
		v.Label:SetSize(VoteSize_X - 100, TextSize_Y);
		v.Label:SetText(string.gsub(v.Name, '#039;', '"'));
										
		function v.CheckBox:DoClick ( )
			for k, l in pairs(PE_VOTE_OPTIONS) do
				if l.CheckBox:GetChecked() then
					l.CheckBox:Toggle();
				end
			end
						
			self:Toggle();
		end
	end
	
	local VoteButtonSize_X, VoteButtonSize_Y = 75, 25;
	
	PE_SUBMIT_VOTE = vgui.Create('DButton', VotePanel);
	PE_SUBMIT_VOTE:SetText('Submit Vote');
	PE_SUBMIT_VOTE:SetPos(VoteSize_X - (VoteSize_X * .3), (VoteSize_Y * .5) - (VoteButtonSize_Y * .75));
	PE_SUBMIT_VOTE:SetSize(VoteButtonSize_X, VoteButtonSize_Y);
	PE_SUBMIT_VOTE:SetAlpha(150);
	
	function PE_SUBMIT_VOTE:DoClick ( )
		VotePanel:Close();
		
		for k, l in pairs(PE_VOTE_OPTIONS) do
			if l.CheckBox:GetChecked() then
				RunConsoleCommand('pe_submit_vote', k);
				return false;
			end
		end
	end
	
	PE_ASK_LATER_VOTE = vgui.Create('DButton', VotePanel);
	PE_ASK_LATER_VOTE:SetText('Ask Me Later');
	PE_ASK_LATER_VOTE:SetPos(VoteSize_X - (VoteSize_X * .3), (VoteSize_Y * .5) + (VoteButtonSize_Y * .75));
	PE_ASK_LATER_VOTE:SetSize(VoteButtonSize_X, VoteButtonSize_Y);
	PE_ASK_LATER_VOTE:SetAlpha(150);
	
	function PE_ASK_LATER_VOTE:DoClick ( ) VotePanel:Close(); end
end

function PE_RECEIVE_VOTE_HEADER ( UMsg )
	PE_EXPECTING_VOTE_OPTIONS = UMsg:ReadShort();
	PE_ALLOWED_VOTE = UMsg:ReadBool();
	PE_VOTE_NAME = UMsg:ReadString();
	PE_VOTE_OPTIONS = {};
end
usermessage.Hook('PE_RECV_VOTE_HEAD', PE_RECEIVE_VOTE_HEADER)

function PE_RECEIVE_VOTE_OPTIONS ( UMsg )
	local NewTable = {};
	NewTable.Name = UMsg:ReadString();
	NewTable.Votes = UMsg:ReadShort();
		
	table.insert(PE_VOTE_OPTIONS, NewTable);
	
	if table.Count(PE_VOTE_OPTIONS) == PE_EXPECTING_VOTE_OPTIONS and PE_ALLOWED_VOTE then PE_OPEN_VOTE_MENU(); end
end
usermessage.Hook('PE_RECV_VOTE_OPTIONS', PE_RECEIVE_VOTE_OPTIONS);
