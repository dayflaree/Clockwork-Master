--=============
--	Popup Menu
--=============
local PLUGIN = PLUGIN;
surface.CreateFont("Arial", 24, 600, true, false, "popup_title", false, false, 0);
surface.CreateFont("Arial", 16, 600, true, false, "popup_option", false, false, 0);

RP.popup.stored = {};

-- Add a new popup menu.
function RP.popup:New(data)
	self.stored[data.entity] = data;
end;

-- Draw the popup menus.
function RP.popup:Draw()
	for k,v in pairs(self.stored) do
		local pos = v.origin:ToScreen();
		
		if (pos.visible) then
			local y = pos.y - 28;
			local x = pos.x - v.width / 2;
			
			surface.SetFont("popup_title");
			local titleWidth = surface.GetTextSize(v.title);
			v.width = math.max(v.width, titleWidth + 4);
			
			y = RP.menu:DrawSimpleText(v.title, "popup_title", x, y, Color(255, 255, 255, 255), 0, 0)
			
			draw.RoundedBox(4, x, y, v.width + 4, v.height + 4, Color(20, 20, 30, 255));
			y = y + 2;
			
			for a,b in ipairs(v.options) do
				surface.SetFont("popup_option");
				local textWidth = surface.GetTextSize(b.text);
				if (textWidth > v.width) then
					v.width = textWidth + 4;
				end;
				
				local colour = Color(40, 50, 70, 255);
				if (self.selected and self.selected.id and self.selected.id == b.id) then
					colour = Color(120, 120, 140, 255);
				end;
				
				if (a == 1) then
					draw.RoundedBoxEx(4, x+2, y, v.width, 16, colour, true, true, false, false);
				elseif (a == #v.options) then
					draw.RoundedBoxEx(4, x+2, y, v.width, 16, colour, false, false, true, true);
				else
					draw.RoundedBoxEx(4, x+2, y, v.width, 16, colour, false, false, false, false);
				end;
				
				RP.menu:DrawSimpleText(b.text, "popup_option", x + v.width / 2, y + 8, Color(240, 240, 240, 255), 1, 1);
				
				y = y + 16;
				
				v.height = a * 16
			end;
		else
			self.stored[k] = nil;
		end;
	end;
end;

function RP.popup:HandleSelection()
	
	for k,v in pairs(self.stored) do
		if (LocalPlayer():GetPos():Distance(v.origin) > v.distance) then
			self.stored[k] = nil;
		end;
		
		local mousePos = LocalPlayer():GetEyeTrace().HitPos:ToScreen();
		local originPos = v.origin:ToScreen();
		local y = originPos.y;
		local x = originPos.x - v.width / 2;
		
		if (y < 0 or y > ScrH() or x < 0 or x > ScrW()) then
			self.stored[k] = nil;
		end;
		
		if ((mousePos.x >= x and mousePos.x <= (x + v.width)) and (mousePos.y >= y and mousePos.y <= (y + v.height))) then
			for a,b in ipairs(v.options) do
				local newY = y + (a-1)*16;

				if (mousePos.y >= newY and mousePos.y <= (newY + 16)) then
					self.selected = {parent = v.entity, id = b.id};
				end;
			end;
			
			break;
		else
			self.selected = nil;
		end;
	end;

end;

-- Draw the cursor when a popup is active.
function RP.popup:DrawCursor()
	local origin = LocalPlayer():GetEyeTrace().HitPos:ToScreen();
	if (table.Count(self.stored) > 0) then
		surface.SetDrawColor(20, 20, 20, 255);
		surface.DrawRect(origin.x - 3, origin.y - 3, 6, 6);
		surface.SetDrawColor(240, 240, 240, 255);
		surface.DrawRect(origin.x - 2, origin.y - 2, 4, 4);
	end;
end;

RP:DataHook("newPopup", function(data)
	local entity = data[1];
	local title = data[2]
	local origin = data[3];
	local distance = data[4]
	local options = data[5];
	
	local create = {
		entity = entity,
		title = title,
		origin = origin,
		distance = distance,
		options = options,
		width = 40,
		height = 0
	};
	
	for k,v in ipairs(create.options) do
		v.parent = entity;
	end;
	
	RP.popup:New(create);
end);

function PLUGIN:PlayerBindPress(ply, bind, pressed)
	if (table.Count(RP.popup.stored) > 0) then
		if (bind == "+attack") then
			if (RP.popup.selected) then
				RP:DataStream("pressOption", {RP.popup.selected.id, RP.popup.selected.parent});
				RP.popup.stored[RP.popup.selected.parent] = nil;
				RP.popup.selected = nil;
				
				return true;
			end;
		end;
	end;
end;

function PLUGIN:HUDPaint()
	RP.popup:Draw();
	RP.popup:DrawCursor();
end;

function PLUGIN:Think()
	RP.popup:HandleSelection();
end;
