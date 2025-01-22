--[[ 
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local surface = surface;

Clockwork.fonts = Clockwork.kernel:NewLibrary("Fonts");
Clockwork.fonts.stored = Clockwork.fonts.stored or {};
Clockwork.fonts.sizes = Clockwork.fonts.sizes or {};

-- A function to add a new font to the system.
function Clockwork.fonts:Add(name, fontTable)
	self.stored[name] = fontTable;
	surface.CreateFont(name, self.stored[name]);
end;

-- A function to find a font by name.
function Clockwork.fonts:FindByName(name)
	return self.stored[name];
end;

-- A function to grab a font by size (creating what doesn't exist.)
function Clockwork.fonts:GetSize(name, size)
	local fontKey = name..size;
	
	if (self.sizes[fontKey]) then
		return fontKey;
	end;
	
	if (not self.stored[name]) then
		return name;
	end;
	
	self.sizes[fontKey] = table.Copy(self.stored[name]);
	self.sizes[fontKey].size = size;
	
	surface.CreateFont(fontKey, self.sizes[fontKey]);
	return fontKey;
end;

-- A function to grab a font by multiplier.
function Clockwork.fonts:GetMultiplied(name, multiplier)
	local fontTable = self:FindByName(name);
	if (fontTable == nil) then return name; end;

	if (Clockwork.config:Get("enable_chat_multiplier"):Get()) then
		return self:GetSize(name, fontTable.size * multiplier);
	else
		return self:GetSize(name, fontTable.size);
	end;
end;

Clockwork.fonts:Add("cwMainText", 
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(7),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwMenuTextBig",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(18),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwMenuTextTiny",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(7),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwMenuTextHuge",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(30),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwMenuTextSmall",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(10),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwIntroTextBig",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(18),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwIntroTextTiny",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(9),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwIntroTextSmall",
{
	font		= "Arial",
	size		= Clockwork.kernel:FontScreenScale(7),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwLarge3D2D",
{
	font		= "Arial",
	size		= Clockwork.kernel:GetFontSize3D(),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwCinematicText",
{
	font		= "Trebuchet",
	size		= Clockwork.kernel:FontScreenScale(8),
	weight		= 700,
	antialiase	= true,
	additive 	= false
});
Clockwork.fonts:Add("cwChatSyntax",
{
	font		= "Courier New",
	size		= Clockwork.kernel:FontScreenScale(7),
	weight		= 600,
	antialiase	= true,
	additive 	= false
});