ITEM.Name = "Radio";
ITEM.Desc = "A device that lets you communicate over large distances.";
ITEM.Model = "models/props_junk/garbage_newspaper001a.mdl";
//"models/lazarusroleplay/props/handradio.mdl";
ITEM.UseSound = "buttons/button14.wav"
ITEM.W = 1;
ITEM.H = 2;
ITEM.Category = CATEGORY_MISC;
ITEM.BasePrice = 999;
ITEM.Vars.power = 0;
ITEM.Vars.freq = "000,0";

function ITEM:ToggleFunc(item)
	if (item.Vars.power == 1) then
		item.Vars.power = 0
	else
		item.Vars.power = 1
	end
	
	if(SERVER) then
		item.Owner:UpdateItemVars( item.Key );
	end
end

function ITEM:OnUse(item, ply)
	if (SERVER) then
		net.Start("cl_radioAdjust")
			net.WriteFloat(item.Key)
			net.WriteString(item.Vars.freq or "000.0")
		net.Send(ply)
	end
end

function ITEM:GetToggleText()
	return "Toggle"
end

function ITEM:GetUseText()
	return "Set Frequency"
end

function ITEM:GetDesc(item)
	local str = "A radio. \nOn/Off: %s \nFrequency: %s"
	return Format(str, (item.Vars.power == 1 and "On" or "Off"), item.Vars.freq or "000.0")
end

if (CLIENT) then
	local PANEL = {}
	function PANEL:Init()
		self.number = 0
		self:SetWide(70)

		local up = self:Add("DButton")
		up:SetFont("Marlett")
		up:SetText("t")
		up:Dock(TOP)
		up:DockMargin(2, 2, 2, 2)
		up.DoClick = function(this)
			self.number = (self.number + 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local down = self:Add("DButton")
		down:SetFont("Marlett")
		down:SetText("u")
		down:Dock(BOTTOM)
		down:DockMargin(2, 2, 2, 2)
		down.DoClick = function(this)
			self.number = (self.number - 1)% 10
			surface.PlaySound("buttons/lightswitch2.wav")
		end

		local number = self:Add("Panel")
		number:Dock(FILL)
		number.Paint = function(this, w, h)
			draw.SimpleText(self.number, "Infected.AmmoClip", w/2, h/2, Color( 252, 178, 69 ), 1, 1)
		end
	end

	vgui.Register("radioDial", PANEL, "DPanel")

	PANEL = {}

	function PANEL:Init()
		self:SetTitle("Frequency")
		self:SetSize(330, 220)
		self:Center()
		self:MakePopup()

		self.submit = self:Add("DButton")
		self.submit:Dock(BOTTOM)
		self.submit:DockMargin(0, 5, 0, 0)
		self.submit:SetTall(25)
		self.submit:SetText("Submit")
		self.submit.DoClick = function()
			local str = ""
			for i = 1, 5 do
				if (i != 4) then
					str = str .. tostring(self.dial[i].number or 0)
				else
					str = str .. "."
				end
			end
			
			net.Start("sv_radioAdjust")
				net.WriteFloat(self.itemID)
				net.WriteString(str)
			net.SendToServer()
			
			LocalPlayer().Inventory[self.itemID].Vars.freq = str

			self:Close()
		end

		self.dial = {}
		for i = 1, 5 do
			if (i != 4) then
				self.dial[i] = self:Add("radioDial")
				self.dial[i]:Dock(LEFT)
				if (i != 3) then
					self.dial[i]:DockMargin(0, 0, 5, 0)
				end
			else
				local dot = self:Add("Panel")
				dot:Dock(LEFT)
				dot:SetWide(30)
				dot.Paint = function(this, w, h)
					draw.SimpleText(".", "Infected.AmmoClip", w/2, h - 10, color_white, 1, 4)
				end
			end
		end
	end

	function PANEL:Think()
		self:MoveToFront()
	end

	vgui.Register("radioMenu", PANEL, "DFrame")

	local function nRadioAdjust()
		local key = net.ReadFloat()
		local freq = net.ReadString()
		local adjust = vgui.Create("radioMenu")
		
		if (key) then
			adjust.itemID = key
		end
		
		if (freq) then
			for i = 1, 5 do
				if (i != 4) then
					adjust.dial[i].number = tonumber(freq[i])
				end
			end
		end
	end
	net.Receive("cl_radioAdjust", nRadioAdjust)
	
	local function nGetFreq()
		local ply = net.ReadEntity()
		local key = net.ReadFloat()
		local freq = net.ReadString()
		
		ply.Inventory = ply.Inventory or {}
		ply.Inventory[key] = ply.Inventory[key] or {}
		ply.Inventory[key].Vars = ply.Inventory[key].Vars or {}
		ply.Inventory[key].Vars.freq = freq
	end
	net.Receive("cl_getFreq", nGetFreq)
else
	local function nRadioAdjust(len, ply)
		local key = net.ReadFloat()
		local freq = net.ReadString()
		local item = ply.Inventory[key]
		
		if (item) then
			item.Vars.freq = freq
			ply:UpdateItemVars( key )
			
			ply:SetRadioFreq( tonumber( freq ) );
		end
	end
	net.Receive("sv_radioAdjust", nRadioAdjust)
end