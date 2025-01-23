CREDIT = {}
CREDIT.categories = {
	{
		name = "Main",
		text = {
			"This is a section dedicated to putting credit where it is due.",
			"Nagivate the tabs to find out who helped create this god-like gamemode.",
			"",
			"Interesting Facts:",
			"{tab}Over 6 months of hard work went into creating Sassilization",
			"{tab}This gamemode is created by Sassafrass",
			"{tab}This gamemode is hosted by Darkspider at darkland servers",
			"{tab}This gamemode is modeled by Jaanus",
			"{tab}Sassafrass can't make effects for his life",
			"{tab}Over 5000 Diet Cokes were drunk in the process",
			""
		}
	},
	{
		name = "Lua Scriptors",
		text = {
			"Gamemode Coders:",
			"{tab}Sassafrass",
			"",
			"Helpers:",
			"{tab}JetBoom",
			"{tab}Darkspider",
			"{tab}Mahalis",
			"{tab}Solthar",
			""
		}
	},
	{
		name = "Effects",
		text = {
			"Scriptors:",
			"{tab}Solthar",
			"{tab}Sassafrass",
			"{tab}Mahalis",
			"{tab}JetBoom",
			"",
			"Materials/Models/Sounds:",
			"{tab}Jaanus",
			""
		}
	},
	{
		name = "Modelers",
		text = {
			"Modelers:",
			"{tab}Jaanus - Super thanks for all your superb work!",
			"{tab}{tab}He modeled everything you see except the grav gloves.",
			"{tab}{tab}Jaanus Jaanus Jaanus Jaanus Jaanus",
			"{tab}Bonehead - For the ballista and sexytime.",
			""
		}
	},
	{
		name = "Extra/Misc:",
		text = {
			"{tab}Bro_21 - grav gloves view model",
			"{tab}JetBoom - For all the extra Lua help",
			"{tab}Darkspider - For hosting sassilization through its growing period",
			"{tab}grippe - the original inspiration, the original dickface",
			"{tab}blackops7799 - Teaching me how to get custom decals in gmod",
			"{tab}NetStorm - Miracle / Misc. Sounds",
			"{tab}Dark Messiah - Unit / Misc. Sounds",
			"{tab}http:www.darklandservers.com/",
			""
		}
	}
}

PANEL={}

function PANEL:Init()
	self.tab = self.tab or 1
	self.pages = {}
end

function PANEL:PerformLayout()
	for i=1, #CREDIT.categories do
		local btn = vgui.Create("CreditButton", self)
		btn.tab = i
		btn.text = CREDIT.categories[i].name
		btn:SetSize(96, 16)
		btn:SetPos( 38 + math.ceil( btn:GetWide() * (i-1)) + i, 10)
	end
	self:UpdatePage()
end

function PANEL:UpdatePage()
	local hty = 32
	
	for k, v in pairs( self.pages ) do
		if v and k != self.tab then v:SetVisible(false) end
	end
	
	if self.pages[self.tab] then
		self.pages[self.tab]:SetVisible(true)
		return
	end
	
	local function AddItem( text )
		local Panel = vgui.Create("Panel", PanelList)
		local Label = vgui.Create("DLabel", Panel)
			if string.find( text, "{tab}{tab}" ) then
				text = string.gsub( text, "{tab}{tab}", "" )
				Label:SetPos( 96, 0 )
			elseif string.find( text, "{tab}" ) then
				text = string.gsub( text, "{tab}", "" )
				Label:SetPos( 64, 0 )
			else
				Label:SetPos( 32, 0 )
			end
			Label:SetText(text)
			Label:SetTextColor(Color(255,255,255,255))
			Label:SizeToContents()
		Panel:SetTall(15)
		return Panel
	end
	
	local PanelList = vgui.Create("DPanelList", self)
		PanelList:EnableVerticalScrollbar()
		PanelList:EnableHorizontal(false)
		PanelList:SetSize(self:GetWide(), self:GetTall() - hty)
		PanelList:SetPos(0, hty)
		PanelList:SetVisible(true)
		self.pages[self.tab] = PanelList

	PanelList:AddItem(AddItem(""))
	for i, text in pairs( CREDIT.categories[self.tab].text ) do
		PanelList:AddItem(AddItem(text))
	end
	PanelList:PerformLayout()
end

function PANEL:Paint()
end

vgui.Register("p_credit", PANEL, "Panel")

---------------
--Credit Button--
---------------

PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
	if self:GetParent().tab == self.tab then return end
	self:GetParent().tab = self.tab
	self:GetParent():UpdatePage()
	surface.PlaySound("buttons/button1.wav")
end

function PANEL:Paint()
	local bgColor = Color( 50, 50, 50, 255 )
	local fgColor = Color( 255, 255, 255, 255 )

	local x, y = self:GetPos()
	local parentx, parenty = self:GetParent():GetPos()
	x, y = x + parentx, y + parenty
	local parentx, parenty = self:GetParent():GetParent():GetPos()
	x, y = x + parentx, y + parenty
	local mx, my = gui.MousePos()
	local wid, hei = self:GetSize()
	self.Armed = false
	if mx >= x and mx <= x + wid and my >= y and my <= y + hei then self.Armed = true end

	if self:GetParent().tab == self.tab then
		bgColor = Color(220, 220, 220, 255)
		fgColor = color_black
	elseif self.Selected then
		bgColor = Color(250, 250, 250, 200)
		fgColor = color_black
	elseif self.Armed then
		bgColor = Color(200, 220, 220, 200)
		fgColor = color_white
	end

	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), bgColor)
	draw.Outline(0,0,self:GetWide(),self:GetTall())
	draw.SimpleText(self.text, "teamname", self:GetWide() * 0.5, self:GetTall() * 0.5, fgColor, 1,1)
	return true
end

vgui.Register( "CreditButton", PANEL, "Button")