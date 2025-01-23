texTechTree = surface.GetTextureID("jaanus/techtree")

HELP = {}
HELP.categories = {
	{
		name = "Main",
		text = {
			"This is an offspring of the gamemode Junk Empires which was originally by grippe.",
			"",
			"Created by Sassafrass and Jaanus",
			"",
			"Lua scripting by - Sassafrass",
			"Modeling/Materials by - Jaanus",
			"",
			"The main goal of the game is to be the first to achieve "..victory_limit.." gold.",
			"1 Gold is earned every "..(resource_tick).." seconds for every city you have.",
			"Additionally, killing opponents will earn you gold rewards alot faster than cities.",
			"", "",
			"Sassilization is a Real Time Strategy game where you control your armies and fight others",
			"You may even form an alliance with another player using the scoreboard.",
			"",
			"Player's are like gods amongst their small mortal men who obey everything they are told to do",
			"They sacrifice their citizens to gain creed or their belief.",
			"With that creed, they are able to cast a vast range of miracles to help aid their soldiers",
			"in battles against other gods.",
			"", "",
			"Press F2 to view the store",
			"Press F1 to exit"
		}
	},
	{
		name = "Buildings",
		text = {
			"To spawn buildings, crouch. While crouching, a menu will appear in the",
			"lower right hand corner of the screen. Click the building you wish to",
			"spawn and click somewhere in the world. The ghost will be red if the terrain",
			"is invalid, it doesn't fit, or you can't afford it.",
			"",
			"CITY",
			"{tab}The city is the first thing you will ever need to make.",
			"{tab}You need it to capture resource nodes and to make other things.",
			"WALL",
			"{tab}These are strictly defensive structures; they block enemy armies.",
			"{tab}They have a high health and prevent enemies from moving once they",
			"{tab}start attacking. Walls are easy to make. Just make two generally",
			"{tab}close together and the gap will automatically be filled for you.",
			"{tab}Placing a wall in the middle of an open gap will also fill it.",
			"TOWER",
			"{tab}This is an archer tower. It fires arrows at enemies in range.",
			"{tab}If enemies are too close it cannot fire at them.",
			"{tab}There are three upgrades available for this. Just build another",
			"{tab}tower next to a previous one to upgrade it.",
			"WORKSHOP",
			"{tab}This is souly a tech building. It does nothing; but, it's almost",
			"{tab}completely necessary to have. It's a step up the tech tree. Having",
			"{tab}this means that you can build shrines, archers, scallywags, or",
			"{tab}upgrade archer towers. Upgraded, this allows catapults and ballistas.",
			"SHRINE",
			"{tab}This is where you get to use miracles. Once the shrine is built, you",
			"{tab}can sacrifice units into it to get creed (mana) to cast miracles to aid",
			"{tab}you in battles. See the Miracles section for details.",
			"", "",
		}
	},
	{
		name = "Resources",
		text = {
			"Resources are the key to this and all strategy games alike.",
			"They provide you with the materials needed to do more things whether",
			"it be building buildings or making armies. In order to control a resource",
			"node, simply build a city next to it and it will automatically become yours.",
			"",
			"FARM",
			"{tab}Farms are the dirt patches you see spread around the land.",
			"{tab}Each farm must be owned in order for it to give you food.",
			"",
			"IRON MINE",
			"{tab}Iron mines are the rocks you see spread around the land.",
			"{tab}Eachmine must be owned in order for it to give you food.",
			"",
			"On certain maps, you will be required to spawn you own resources when the game",
			"beings. To do this, simply fire at the place you want your resource."
		}
	},
	{
		name = "Controls",
		text = {
			"Crouching (default 'ctrl')",
			"{tab} - This will bring up the spawn menu in the bottom right of your screen.",
			"Walking (default 'alt')",
			"{tab} - This will bring out the unit menu if you have a city.",
			"Secondary fire",
			"{tab} - All selected armies will be ordered to the location",
			"{tab}You have aimed at.",
			"Sprint + Primary fire [HOLD & DRAG]",
			"{tab} - Will begin a selection circle for your to drag over units.",
			"{tab}any units inside the circle will be selected. Only "..select_limit.." armies can be",
			"{tab}selected at once.",
			"Sprint + Reload",
			"{tab} - Will Deselect all selected armies.",
			"Reload",
			"{tab} - Refund the building or unit you are looking at. Only certain things can be refunded.",
			"Scoreboad",
			"{tab} - Here is where you can make alliances and see who is in the lead. To ally",
			"{tab}click the box to the left of the players name. If the box is yellow, you are",
			"{tab}allied to that person. If it is blue, they are allied to you. If green, you're",
			"{tab}both allied and a line is drawn to both of your boxes viewable by everyone."
		}
	},
	{
		name = "Miracles",
		text = {
			"To cast miracles, you must have bought them in the store, and you must have creed.",
			"creed is earned by sacrificing units in your shrine.",
			"",
			"Casting miracles is done with the number pad.",
			"Here is the key map:",
			"",
			"[ 1 ] Gravitate (launches enemy units into the air killing them on fall)",
			"[ 2 ] Bombard (hails arrows dealing damage to everything)",
			"[ 3 ] Heal (heals all friendly units in the area and nullifies decimate/paralysis)",
			"[ 4 ] Decimation (ignites all enemy units)",
			"[ 5 ] Blast (An explosion sending enemy units flying dealing no damage)",
			"[ 6 ] Paralysis (Freeze all enemy units for 6 seconds)",
			"[ 7 ] Plummet (Sink enemy walls into the ground)",
			"",
			"If at any moment you forget which spell is which, hold down 0 on your numpad."
		}
	}/*,
	{
		name = "Tech Tree",
		text = {
			""
		},
		image = ""
	}*/

}

PANEL={}

function PANEL:Init()
	self.tab = self.tab or 1
	self.pages = {}
end

function PANEL:PerformLayout()
	for i=1, #HELP.categories do
		local btn = vgui.Create("HelpButton", self)
		btn.tab = i
		btn.text = HELP.categories[i].name
		btn:SetSize(64, 16)
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
			if string.find( text, "{tab}" ) then
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
	for i, text in pairs( HELP.categories[self.tab].text ) do
		PanelList:AddItem(AddItem(text))
	end
	PanelList:PerformLayout()
end

function PANEL:Paint()
end

vgui.Register("p_help", PANEL, "Panel")

---------------
--Help Button--
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

vgui.Register( "HelpButton", PANEL, "Button")