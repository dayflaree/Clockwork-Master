-- (c) Khub 2012-2013.
-- VGUI Extension - NotePanel
-- This is the VGUI component that is set up with note data, that takes those and auto-wraps the text onto lines, and that's displayed in the DPanelList with scrollbar.

local NotePanel = {};

surface.CreateFont("DatafileNoteText", {
	font = "Arial",
	size = 15,
	weight = 500
});

function NotePanel:Init()
	self.ContentLines = {"- error -"};
	self.Author = "ERROR";
	self.Timestamp = "####-##-## ##:##";
	self.NoteType = "textnote";
	self.CustomData = nil;

	self.LineHeight = 15;
end;

function NotePanel:Setup(noteData)
	self.Author = noteData.author;
	self.Timestamp = Datafiles:GetDateFromTimestamp(tonumber(noteData.time or 0) or 0);

	if (noteData.notetype) then
		self.NoteType = noteData.notetype;
		
		if (self.NoteType == "LoyaltyRecord") then
			self.CustomData = noteData.content.points;
			self.ContentLines = self:GetNoteContentAsLines(noteData.content.note);
		elseif (self.NoteType == "NoteRecord" or self.NoteType == "MedicalRecord" or self.NoteType == "HistoryRecord") then
			self.ContentLines = self:GetNoteContentAsLines(noteData.content);
		end;
	else
		error("NotePanel:Setup failed - note had no NoteType set!");
	end;
end;

function NotePanel:GetNoteContentAsLines(notetext)
	surface.SetFont("DatafileNoteText");

	local maxSize = self:GetWide() - 11;
	local contentWidth = surface.GetTextSize(notetext);

	local lines = {
		[1] = notetext:gsub("\\'", "'"):gsub("\\\"", "\""):gsub("\\\\", "\\"):gsub("\\n", "\n")
	};

	if (contentWidth > maxSize) then

		for line = 1, 50 do -- We're not going over fifty lines, whoever makes so long notes is dumb.

			if (!lines[line] or string.len(tostring(lines[line])) == 0) then -- We're done here.
				break;
			end;

			for i = string.len(lines[line]), 1, -1 do
				local newLineText = string.sub(lines[line], 1, i);
				local newTextWidth = surface.GetTextSize(newLineText);
				
				if (newTextWidth < maxSize) then
					lines[line + 1] = string.sub(lines[line], i + 1);
					lines[line] = newLineText;
					break;
				end;
			end;
		end;

	end;

	local filteredLines = {};
	for k, v in pairs(lines) do
		if (v:len() > 0 and !v:find("^[%s]+$")) then
			table.insert(filteredLines, v);
		end;
	end;

	return filteredLines;
end;

function NotePanel:PerformLayout()
	surface.SetFont("DatafileNoteText");
	local lineW, lineH = surface.GetTextSize("yes");
	local textW, textH = surface.GetTextSize(string.Implode("\n", self.ContentLines));

	self:SetTall(textH + lineH * (self.NoteType == "HistoryRecord" and 2 or 3));
end;

function NotePanel:Paint(w, h)
	if (self.NoteType == "HistoryRecord") then
		surface.SetDrawColor(Color(175, 175, 175, 100));
	else
		surface.SetDrawColor(Color(115, 200, 230, 100));
	end;

	surface.DrawRect(0, 0, w, h);

	surface.SetFont("DermaDefaultBold");
	surface.SetTextColor(Color(50, 50, 255));
	surface.SetTextPos(5, 5);
	surface.DrawText(self.Timestamp);

	if (self.NoteType == "LoyaltyRecord") then
		if (self.CustomData > 0) then
			surface.SetTextColor(Color(0, 128, 0));
		else
			surface.SetTextColor(Color(128, 0, 0));
		end;

		local changeLabel = (self.CustomData > 0 and "+" or "") .. self.CustomData .. " pts";
		local changeLabelW, changeLabelH = surface.GetTextSize(changeLabel);

		surface.SetTextPos(w - 5 - changeLabelW, 5);
		surface.DrawText(changeLabel);
	end;

	surface.SetFont("DatafileNoteText");
	surface.SetTextColor(Color(20, 20, 20));

	local textY = 18;

	for k, v in pairs(self.ContentLines) do
		surface.SetTextPos(5, textY);
		surface.DrawText(v);

		local textWidth, textHeight = surface.GetTextSize(v);
		textY = textY + textHeight;
	end;

	if (self.NoteType != "HistoryRecord") then
		surface.SetFont("DermaDefaultBold");
		surface.SetTextColor(Color(127, 10, 10));
		surface.SetTextPos(5, textY + 5);
		surface.DrawText("~ " .. self.Author);
	end;
end;

vgui.Register("NotePanel", NotePanel, "DPanel");