--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local Color = Color;
local surface = surface;
local vgui = vgui;

local PANEL = {};

-- Called when the panel should be painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "PanelList", self, w, h);
end;

vgui.Register("cwPanelList", PANEL, "DPanelList");