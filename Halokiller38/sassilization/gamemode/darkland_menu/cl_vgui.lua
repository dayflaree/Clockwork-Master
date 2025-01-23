menu_on = false

donatetable = "Please visit www.darklandservers.com and nagivate to the donations page."

rulestable = "1. No spamming mics or chat.^2. No Racial Slurs.^3. Do not post/spray obscene images such as goatse or other shock images.^4. Saying Sass is not cool (In any circumstance) results in a kick."

PANEL={}

function PANEL:Init()
	self.tab = self.tab or 1
	self.classtab = 1
	self.helptab = 1
	self.shoptab = 1
	self.statstab = 1
	self.purchasebtn = false
	self.headerheight = 96
	self.tabs = {"Help", "Donate", "Rules", "Store", "Stats", "Credits"}
	self.buttons = {}
	self.pages = {}
	self.leaderboardbuttons = {}
	self.statsbuttons = {}
	for i=1, #self.tabs do
		self.buttons[i] = {}
	end
	for i=1, #Stats do
		self.statsbuttons[i] = {}
	end
end

local donatetext = string.Explode("^",donatetable)
local rulestext = string.Explode("^",rulestable)

function PANEL:Paint()

	//Background
	draw.RoundedBox(0,4,4,self:GetWide() - 8,self:GetTall() - 8, Color(200,200,200,215))
	draw.RoundedBox(0,4,4,self:GetWide() - 8,self.headerheight, Color(255,255,255,255))

	//Outline
	draw.Border( 4,4,self:GetWide() - 8,self:GetTall() - 8 )

	local logo = surface.GetTextureID("darkland/logo")
	surface.SetTexture(logo)
	surface.SetDrawColor(255,255,255,215)
	surface.DrawTexturedRect(5,5,self:GetWide() * 0.1 * 4, self.headerheight)
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawLine( 5, math.ceil( self.headerheight ) + 5, self:GetWide()-5, math.ceil( self.headerheight ) + 5 )

	draw.RoundedBox(0,9,yPosition+1,self:GetWide() - 18,self:GetTall() - yPosition - 9, Color(0, 0, 0, 200))
	draw.RoundedBox(0,10,yPosition+1,self:GetWide() - 20,self:GetTall() - yPosition - 10, Color(200, 200, 200, 255))

	if self.tabs[self.tab] == "Help" then

		local hty = yPosition + 20
		if HELP.categories[self.helptab].name == "Tech Tree" then
			draw.RoundedBox( 0, 64, hty, 512, 512, Color( 40, 40, 40, 150 ))
			draw.Border( 64, hty, 512, 512 )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( texTechTree )
			surface.DrawTexturedRect( 64, hty, 512, 512 )
		end

	elseif self.tabs[self.tab] == "Donate" then

		local hty = yPosition + 128

		for i=1,#donatetext do
			draw.SimpleText(donatetext[i], "money", self:GetWide()*0.5, hty + i * 15, Color(0,155,0,255), 1, 1)
		end
	
		draw.SimpleText("http://www.darklandservers.com/", "health", self:GetWide()*0.5, self:GetTall() * 0.25, Color(0,155,0,255), 1, 1)

	elseif self.tabs[self.tab] == "Rules" then

		local hty = yPosition + 96

		draw.SimpleText("Server Rules", "money", self:GetWide() * 0.5, self:GetTall() * 0.2, Color(255,0,0,255), 1, 1)
		draw.SimpleText("Follow or be banned!", "money", self:GetWide() * 0.5, self:GetTall() * 0.23, Color(255,0,0,255), 1, 1)
		for i=1, #rulestext do
			draw.SimpleText(rulestext[i], "money", self:GetWide() * 0.5, hty + i * 15, Color(0,0,0,255), 1, 1)
		end

	elseif self.tabs[self.tab] == "Store" then
		
		local hty = yPosition + 16
		local wtx = 0

		draw.RoundedBox( 0, 48, hty-2, self:GetWide()-256, 19, Color( 80, 80, 80, 150 ))
		draw.Border( 48, hty-2, self:GetWide()-256, 19 )

		if ALLOWALL then
			draw.SimpleText("The store is currently closed.", "money", 56, hty+1, Color(255,0,0,255))
			draw.SimpleText("The store is currently closed.", "money", 55, hty, Color(80,40,40,80))
			return
		end

		if LocalPlayer():GetMoney() then

			draw.SimpleText("You have $"..LocalPlayer():GetMoney().." to spend.", "money", 56, hty+1, Color(0,0,0,230))
			draw.SimpleText("You have $"..LocalPlayer():GetMoney().." to spend.", "money", 55, hty, Color(0,255,0,255))

			draw.RoundedBox( 0, self:GetWide()-180, hty-2, 138, 49, Color( 80, 80, 80, 150 ))
			draw.Border( self:GetWide()-180, hty-2, 138, 49 )

			draw.SimpleText("Unaffordable", "money", self:GetWide()-175, hty, Color(255,0,0,255))
			draw.SimpleText("Affordable", "money", self:GetWide()-174, hty+16, Color(0,0,0,230))
			draw.SimpleText("Affordable", "money", self:GetWide()-175, hty+15, Color(0,255,0,255))
			draw.SimpleText("Already Purchased", "money", self:GetWide()-175, hty+30, Color(0,0,255,255))

			hty = hty + 17 + 24

			//DRAW TITLE BOX
			draw.RoundedBox( 0, 48, hty, self:GetWide()-256, 68, Color( 80, 80, 80, 150 ))
			draw.Border( 48, hty, self:GetWide()-256, 68 )

			
			hty = hty + 68 + 24

			//DRAW INFO BOX
			draw.RoundedBox( 0, 48, hty, self:GetWide()-256, self:GetTall() - hty - 24, Color( 80, 80, 80, 150 ))
			draw.Border( 48, hty, self:GetWide()-256, self:GetTall() - hty - 24 )
			
			hty = hty - 64
			draw.RoundedBox( 0, self:GetWide()-180, hty, 138, self:GetTall() - hty - 24, Color( 80, 80, 80, 150 ))
			draw.Border( self:GetWide()-180, hty, 138, self:GetTall() - hty - 24 )


			if !self.shoptab or self.shoptab < 1 then return end

			hty = hty - 30
			wtx = 64

			getShoppingList(ITEMS)

			local title = string.Left( shopitems[self.shoptab].name, string.find( shopitems[self.shoptab].name, "-" )-2 )

			draw.SimpleText(title, "heading01", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText(title, "heading01", wtx, hty, Color(255,255,255,255))
			
			hty = hty + 54

			draw.RoundedBox( 0, 56, hty - 3, self:GetWide()-272, 1, Color( 0, 0, 0, 255 ))
			draw.RoundedBox( 0, 56, hty - 5, self:GetWide()-272, 2, Color( 255, 255, 255, 255 ))
			draw.RoundedBox( 0, 80, hty , self:GetWide()-296, 1, Color( 0, 0, 0, 255 ))
			draw.RoundedBox( 0, 80, hty - 1, self:GetWide()-296, 1, Color( 255, 255, 255, 255 ))
			
			if shopitems[self.shoptab].max > 1 then
				local amount = shopitems[self.shoptab].bought
				local total = shopitems[self.shoptab].max
				if !amount then
					draw.SimpleText("You have 0 / "..total.." of this item.", "money", wtx+1, hty+1, Color(0,0,0,255))
					draw.SimpleText("You have 0 / "..total.." of this item.", "money", wtx, hty, Color(255,255,255,255))
				elseif amount < total then
					draw.SimpleText("You have "..amount.." / "..total.." of this item.", "money", wtx+1, hty+1, Color(0,0,0,255))
					draw.SimpleText("You have "..amount.." / "..total.." of this item.", "money", wtx, hty, Color(255,255,255,255))
				else
					draw.SimpleText("You have purchased all "..total.." of this item.", "money", wtx+1, hty+1, Color(0,0,0,255))
					draw.SimpleText("You have purchased all "..total.." of this item.", "money", wtx, hty, Color(255,255,255,255))
				end
			else
				if shopitems[self.shoptab].bought then
					draw.SimpleText("You already have this item.", "money", wtx+1, hty+1, Color(0,0,0,255))
					draw.SimpleText("You already have this item.", "money", wtx, hty, Color(255,255,255,255))
				else
					draw.SimpleText("You have not purchased this item yet.", "money", wtx+1, hty+1, Color(0,0,0,255))
					draw.SimpleText("You have not purchased this item yet.", "money", wtx, hty, Color(255,255,255,255))
				end
			end
			
			hty = hty + 56

			draw.RoundedBox( 8, wtx - 6, hty - 6, 140, 140, Color( 80, 80, 80, 100 ))

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( shopitems[self.shoptab].tex )
			surface.DrawTexturedRect( wtx, hty, 128, 128 )

			wtx = 216

			draw.RoundedBox( 8, wtx - 6, hty - 6, self:GetWide()-256 - wtx + 48, 140, Color( 80, 80, 80, 100 ))

			draw.SimpleText("Type", "heading02", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText("Type", "heading02", wtx, hty, Color(255,255,255,255))

			hty = hty + 24

			title = string.Right( shopitems[self.shoptab].name, string.len( shopitems[self.shoptab].name ) - string.find( shopitems[self.shoptab].name, "-" ) )

			draw.SimpleText(title, "money", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText(title, "money", wtx, hty, Color(255,255,255,255))

			hty = hty + 16 + 4

			draw.SimpleText("Max", "heading02", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText("Max", "heading02", wtx, hty, Color(255,255,255,255))

			hty = hty + 24

			if shopitems[self.shoptab].max > 0 then
				title = shopitems[self.shoptab].max
			else
				title = "Only once"
			end

			draw.SimpleText(title, "money", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText(title, "money", wtx, hty, Color(255,255,255,255))

			hty = hty + 16 + 4

			draw.SimpleText("Cost", "heading02", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText("Cost", "heading02", wtx, hty, Color(255,255,255,255))

			hty = hty + 24

			draw.SimpleText(shopitems[self.shoptab].cost, "money", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText(shopitems[self.shoptab].cost, "money", wtx, hty, Color(255,255,255,255))

			hty = hty + 62
			wtx = 64

			draw.RoundedBox( 8, wtx - 6, hty - 6, self:GetWide()-256 - wtx + 48, 24, Color( 80, 80, 80, 100 ))
			
			draw.SimpleText(shopitems[self.shoptab].description, "money", wtx+1, hty+1, Color(0,0,0,255))
			draw.SimpleText(shopitems[self.shoptab].description, "money", wtx, hty, Color(255,255,255,255))

		else
			draw.SimpleText("You must be on the darkland server's Sassilization to purchase things.", "money", 49, hty+1, Color(0,0,0,255))
			draw.SimpleText("You must be on the darkland server's Sassilization to purchase things.", "money", 48, hty, Color(255,255,255,255))
		end
	
	elseif self.tabs[self.tab] == "Stats" then 
		for i=1,#Stats do
			surface.SetDrawColor(0,0,0,255)
			surface.DrawLine(32, self:GetTall() * 0.2 + 8,self:GetWide() - 64,self:GetTall() * 0.2 + 8)
			if self.statstab == 1 then
				draw.SimpleText("Rank","money",self:GetWide() * 0.1, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.3, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Name","money",self:GetWide() * 0.6, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Kills","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#FW_Kills[1] do
					draw.SimpleText("Rank "..q,"money",self:GetWide() * 0.1, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Kills[1][q],"money",self:GetWide() * 0.3, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Kills[2][q],"money",self:GetWide() * 0.6, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Kills[3][q],"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			elseif self.statstab == 2 then
				draw.SimpleText("Rank","money",self:GetWide() * 0.1, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.3, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Name","money",self:GetWide() * 0.6, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Wins","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#SA_Wins[1] do
					draw.SimpleText("Rank "..q,"money",self:GetWide() * 0.1, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(SA_Wins[1][q],"money",self:GetWide() * 0.3, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(SA_Wins[2][q],"money",self:GetWide() * 0.6, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(SA_Wins[3][q],"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			elseif self.statstab == 3 then
				draw.SimpleText("Rank","money",self:GetWide() * 0.1, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.3, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Name","money",self:GetWide() * 0.6, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Wins","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#FW_Wins[1] do
					draw.SimpleText("Rank "..q,"money",self:GetWide() * 0.1, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Wins[1][q],"money",self:GetWide() * 0.3, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Wins[2][q],"money",self:GetWide() * 0.6, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Wins[3][q],"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			elseif self.statstab == 4 then
				draw.SimpleText("Rank","money",self:GetWide() * 0.1, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.3, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Name","money",self:GetWide() * 0.6, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Losses","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#FW_Losses[1] do
					draw.SimpleText("Rank "..q,"money",self:GetWide() * 0.1, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Losses[1][q],"money",self:GetWide() * 0.3, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Losses[2][q],"money",self:GetWide() * 0.6, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_Losses[3][q],"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			elseif self.statstab == 5 then
				draw.SimpleText("Rank","money",self:GetWide() * 0.1, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.3, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Name","money",self:GetWide() * 0.6, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Flagtime","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#FW_FlagTime[1] do
					draw.SimpleText("Rank "..q,"money",self:GetWide() * 0.1, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_FlagTime[1][q],"money",self:GetWide() * 0.3, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(FW_FlagTime[2][q],"money",self:GetWide() * 0.6, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(math.time(tonumber(FW_FlagTime[3][q])),"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			elseif self.statstab == 6 then
				draw.SimpleText("Name","money",self:GetWide() * 0.03, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Steamid","money",self:GetWide() * 0.2, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Reason","money",self:GetWide() * 0.4, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				draw.SimpleText("Expiry","money",self:GetWide() * 0.8, self:GetTall() * 0.2, Color(0,0,0,255),0,1)
				for q=1,#Bans[1] do
					draw.SimpleText(tostring(Bans[1][q]),"money",self:GetWide() * 0.2, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(tostring(Bans[2][q]),"money",self:GetWide() * 0.03, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					draw.SimpleText(tostring(Bans[3][q]),"money",self:GetWide() * 0.4, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
					if tonumber(Bans[4][q]) then
						whattouse = os.date("%c",Bans[4][q])
					else
						whattouse = Bans[4][q]
					end
					draw.SimpleText(tostring(whattouse),"money",self:GetWide() * 0.8, self:GetTall() * 0.3 + (q * 15), Color(0,0,0,255),0,1)
				end
			end
		end
	end
end

function PANEL:PerformLayout()
	if self.Setup then return end
	self.Setup = true
	self:SetSize(640,ScrH()-147*2)
	self:SetPos(ScrW()*0.5-self:GetWide()*0.5, 147)
	close = vgui.Create("Close", self)
	close:SetPos(self:GetWide() - 20, 10)
	close:SetSize(12, 12)
	yPosition = math.ceil( self.headerheight ) + 5
	for i=1, #self.tabs do
		local menu = vgui.Create("MenuButton", self)
		menu.tab = i
		menu.text = self.tabs[i]
		menu:SetSize( self:GetWide() * 0.08, 12 )
		local xOffset = self:GetWide() * 0.1 * 4 + 5
		local yOffset = yPosition - menu:GetTall() + 1
		menu:SetPos(xOffset + math.ceil( menu:GetWide() * (i-1) ) + i, yOffset)
	end

	self:ChangePage( self.tab )
	CloseMenu()
end

function PANEL:ChangePage( tab )

	if !self.Setup then return end
	
	for i, button in pairs(self.buttons[self.tab]) do
		button:Remove()
	end

	self.tab = tab
	self.buttons[self.tab] = {}

	for _, page in pairs( self.pages ) do
		if page and page:IsValid() and _ != self.tab then
			page:SetVisible(false)
		end
	end

	if self.tabs[self.tab] == "Help" then
		if !self.pages[self.tab] then
			local Page = vgui.Create("p_help", self)
			Page:SetPos( 32, self.headerheight + 32 )
			Page:SetSize( self:GetWide() - 64, self:GetTall() - self.headerheight - 64 )
			Page:SetVisible(true)
			self.pages[self.tab] = Page
		else
			self.pages[self.tab]:SetVisible(true)
		end
	end

	if self.tabs[self.tab] == "Credits" then
		if !self.pages[self.tab] then
			local Page = vgui.Create("p_credit", self)
			Page:SetPos( 32, self.headerheight + 32 )
			Page:SetSize( self:GetWide() - 64, self:GetTall() - self.headerheight - 64 )
			Page:SetVisible(true)
			self.pages[self.tab] = Page
		else
			self.pages[self.tab]:SetVisible(true)
		end
	end

	if self.tabs[self.tab] == "Store" then

		LastRetrieve = LastRetrieve or CurTime()

		if CurTime() >= LastRetrieve then
			RunConsoleCommand("sa_~_retrieve")
			LastRetrieve = CurTime() + 5
		end

		if !LocalPlayer():GetMoney() then return end
		if ALLOWALL then return end

		getShoppingList(ITEMS)


		if !self.purchasebtn then
			
			local item = shopitems[self.shoptab]
			if item.max > 1 then
				local amount = item.bought
				local total = item.max
				if !amount then
					bought = false
				elseif amount < total then
					bought = false
				else
					bought = true
				end
			else
				if item.bought then
					bought = true
				else
					bought = false
				end
			end

			if !bought then
				local btn = vgui.Create("BuyButton", self)
				btn.bought = false
				btn.id = shopitems[self.shoptab].id
				btn.cost = shopitems[self.shoptab].cost
				btn:SetPos(64, self:GetTall() - 64)
				btn:SetSize(128, 24)
				self.purchasebtn = btn
			end

		end

		if self.shopframe then
			self.shopframe:SetVisible(true)
			return
		end

		local function AddItem( i,item )
			local btn = vgui.Create("ShopButton", PanelList)
			btn.parent = self
			btn.tab = i
			btn.id = item.id
			btn.text = item.name
			btn.cost = item.cost
			btn.bought = false
			btn:SetTall(32)
			return btn
		end

		local PanelList = vgui.Create("DPanelList", self)
			PanelList:EnableVerticalScrollbar()
			PanelList:EnableHorizontal(false)
			PanelList:SetSize(120, self:GetTall() - self.headerheight - 110 - 16)
			PanelList:SetPos(self:GetWide()-171, self.headerheight + 96)
			PanelList:SetVisible(true)
			self.shopframe = PanelList

		function PanelList:Paint()
		end

		for i, item in pairs( shopitems ) do
			PanelList:AddItem(AddItem(i,item))
		end

		PanelList:PerformLayout()
	else
		if self.shopframe then self.shopframe:SetVisible(false) end
		if self.purchasebtn then self.purchasebtn:Remove() self.purchasebtn = nil end
	end

	if self.tabs[self.tab] == "Stats" then
		for i=1,#Stats do
			stats = vgui.Create("WhatStat", self)
			stats.statstab = i
			stats.text = Stats[i]
			stats:SetSize(80, 16)
			stats:SetPos((self:GetWide() * 0.5 / (#Stats * 80)) + i * 80, self.headerheight + 32)
			table.insert(self.buttons[self.tab], stats)
		end
	end

end
vgui.Register("Menu",PANEL, "Panel")

----------------
--Close Button--
----------------

PANEL={}

function PANEL:Init()
end

function PANEL:DoClick()
	CloseMenu()
end

function PANEL:Paint()
	local bgColor = Color( 50, 50, 50, 255 )
	local fgColor = Color( 255, 255, 255, 255 )
	
	if self.Selected then
		bgColor = Color(250, 250, 250, 200)
		fgColor = color_black
	elseif self.Armed then
		bgColor = Color(200, 220, 220, 200)
		fgColor = color_white
	end
	
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), bgColor)
	draw.SimpleText("X", "teamname", self:GetWide() * 0.5, self:GetTall() * 0.5, fgColor, 1,1)
	return true
end
vgui.Register("Close", PANEL, "Button")

--------------
--Tab Button--
--------------

PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
	if self:GetParent().tab == self.tab then return end
	self:GetParent():ChangePage( self.tab )
	surface.PlaySound("buttons/button1.wav")
end
  
function PANEL:Paint()
	local bgColor = Color( 50, 50, 50, 255 )
	local fgColor = Color( 255, 255, 255, 255 )
	local round = 0
	
	local x, y = self:GetPos()
	local parentx, parenty = self:GetParent():GetPos()
	x, y = x + parentx, y + parenty
	local mx, my = gui.MousePos()
	local wid, hei = self:GetSize()
	self.Armed = false
	if mx >= x and mx <= x + wid and my >= y and my <= y + hei then self.Armed = true end

	if self:GetParent().tab == self.tab then
		bgColor = Color(200, 200, 200, 255)
		fgColor = color_black
		round = 6
	elseif self.Selected then
		bgColor = Color(250, 250, 250, 200)
		fgColor = color_black
	elseif self.Armed then
		bgColor = Color(200, 220, 220, 200)
		fgColor = color_white
	end

	draw.RoundedBox(round,0,0,self:GetWide(),self:GetTall(), bgColor)
	if round > 0 then
		draw.RoundedBox(0,0,self:GetTall()*0.5,self:GetWide(),self:GetTall()*0.5, Color(200, 200, 200, 255))
	else
		draw.RoundedBox(0,0,self:GetTall()-1,self:GetWide(),1, Color(0, 0, 0, 255))
	end
	draw.SimpleText(self.text, "teamname", self:GetWide() * 0.5, 0, fgColor, 1)
	return true
end

vgui.Register("MenuButton",PANEL, "Button")

---------------
--Shop Button--
---------------

PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
	if self.parent.shoptab == self.tab then return end
	if self.parent.purchasebtn then
		self.parent.purchasebtn:Remove()
		self.parent.purchasebtn = nil
	end
	if !self.bought and LocalPlayer():GetMoney() >= self.cost and !self.parent.purchasebtn then
		local btn = vgui.Create("BuyButton", self.parent)
		btn.bought = self.bought
		btn.id = self.id
		btn.cost = self.cost
		btn:SetPos(64, self.parent:GetTall() - 64)
		btn:SetSize(128, 24)
		self.parent.purchasebtn = btn
	end
	self.parent.shoptab = self.tab
	surface.PlaySound("buttons/button1.wav")
end

function PANEL:Paint()
	local bgColor = Color( 50, 50, 50, 255 )
	local OColor = Color( 50, 50, 180, 80 )
	local fgColor = Color( 255, 255, 255, 255 )

	
	if !self.bought then
		if LocalPlayer():GetMoney() >= self.cost then
			OColor = Color( 50, 128, 50, 100 )
		elseif LocalPlayer():GetMoney() < self.cost then
			OColor = Color( 128, 20, 20, 60 )
		end
		if self.Selected then
			bgColor = Color(250, 250, 250, 100)
			fgColor = color_black
		elseif self.Armed then
			bgColor = Color(200, 220, 220, 100)
			fgColor = color_white
		end
	end

	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), bgColor)
	draw.Outline(0,0,self:GetWide(),self:GetTall())
	draw.SimpleText(self.text, "teamname", self:GetWide() * 0.5, self:GetTall() * 0.3, fgColor, 1,1)
	draw.SimpleText("$"..self.cost, "teamname", self:GetWide() * 0.5, self:GetTall() * 0.7, fgColor, 1,1)
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), OColor)
	if self.parent.shoptab == self.tab then
		draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), Color( 255, 255, 255, 90 ))
	end
	return true
end

function PANEL:Think()
	if !self.bought then
		self:Update()
	end
end

function PANEL:Update()
	for _, item in pairs( shopitems ) do
		if self.id == item.id then
			if item.max > 1 then
				local amount = item.bought
				local total = item.max
				if !amount then
					self.bought = false
				elseif amount < total then
					self.bought = false
				else
					self.bought = true
				end
			else
				if item.bought then
					self.bought = true
				else
					self.bought = false
				end
			end
		end
	end
end

vgui.Register( "ShopButton", PANEL, "Button")

-------------------
--Purchase Button--
-------------------

PANEL = {}

function PANEL:Init()
end

function PANEL:DoClick()
	if LocalPlayer().wait then return end
	if self.bought then return end
	if LocalPlayer():GetMoney() >= self.cost then
		RunConsoleCommand( "sa_~_purchase",string.lower(self.id) )
		LocalPlayer().wait = true
	end
	surface.PlaySound("buttons/button1.wav")
end

function PANEL:Paint()

	if self.bought then return true end

	local bgColor = Color( 50, 50, 50, 255 )
	local OColor = Color( 50, 50, 180, 80 )
	local fgColor = Color( 255, 255, 255, 255 )


	if !self.bought then
		if LocalPlayer():GetMoney() >= self.cost then
			OColor = Color( 50, 128, 50, 100 )
		elseif LocalPlayer():GetMoney() < self.cost then
			OColor = Color( 128, 20, 20, 60 )
		end
		if self.Selected then
			bgColor = Color(250, 250, 250, 100)
			fgColor = color_black
		elseif self.Armed then
			bgColor = Color(200, 220, 220, 100)
			fgColor = color_white
		end
	end

	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), bgColor)
	draw.Outline(0,0,self:GetWide(),self:GetTall())
	if LocalPlayer().wait then
		draw.SimpleText("Transaction in progress...", "teamname", self:GetWide() * 0.5, self:GetTall() * 0.5, fgColor, 1,1)
	else
		draw.SimpleText("Buy It!", "teamname", self:GetWide() * 0.5, self:GetTall() * 0.5, fgColor, 1,1)
	end
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), OColor)
	return true

end

function PANEL:Think()
	if !self.bought then
		self:Update()
	end
end

function PANEL:Update()
	getShoppingList( ITEMS )
	for _, item in pairs( shopitems ) do
		if self.id == item.id then
			if item.max > 1 then
				local amount = item.bought
				local total = item.max
				if !amount then
					self.bought = false
				elseif amount < total then
					self.bought = false
				else
					self.bought = true
				end
			else
				if item.bought then
					self.bought = true
				else
					self.bought = false
				end
			end
		end
	end
end

vgui.Register( "BuyButton", PANEL, "Button")





local PANEL = {}

AccessorFunc( PANEL, "m_bSizeToContents", 		"AutoSize" )
AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground" )

AccessorFunc( PANEL, "Spacing", 	"Spacing" )
AccessorFunc( PANEL, "Padding", 	"Padding" )

function PANEL:Init()

	self.pnlCanvas 	= vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end
	
	self.YOffset = 0
	
	self:SetSpacing( 0 )
	self:SetPadding( 0 )
	self:SetAutoSize( false )
	self:SetDrawBackground( true )
	
	self:SetMouseInputEnabled( true )
	
	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )
	
end

function PANEL:EnableVerticalScrollbar()

	if (self.VBar) then return end
	
	self.VBar = vgui.Create( "DVScrollBar", self )
	
end

function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:SetContent( item )

	if !(item and item:IsValid()) then return end

	item:SetVisible( true )
	item:SetParent( self:GetCanvas() )
	self.Item = item
	
	self:InvalidateLayout()

end

function PANEL:OnMouseWheeled( dlta )

	if ( self.VBar ) then
		return self.VBar:OnMouseWheeled( dlta )
	end
	
end

function PANEL:Paint()
	
	derma.SkinHook( "Paint", "PanelList", self )
	return true
	
end

function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )
	
end

function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local YPos = 0

	self:GetCanvas():SetTall( self.Item:GetTall() )
	
	if ( self.VBar && !m_bSizeToContents ) then

		self.VBar:SetPos( self:GetWide() - 16, 0 )
		self.VBar:SetSize( 16, self:GetTall() )
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
		YPos = self.VBar:GetOffset()
		
		if ( self.VBar.Enabled ) then Wide = Wide - 16 end

	end
	
	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:GetCanvas():SetTall( self.Item:GetTall() )
	
	if ( self:GetAutoSize() ) then
	
		self:SetTall( self.pnlCanvas:GetTall() )
		self.pnlCanvas:SetPos( 0, 0 )
	
	end

end

function PANEL:OnMousePressed( mcode )

	if ( !self.VBar && self:GetParent().OnMousePressed ) then
		return self:GetParent():OnMousePressed( mcode )
	end

	if ( mcode == MOUSE_RIGHT && self.VBar ) then
		self.VBar:Grip()
	end
	
end

vgui.Register( "ScrollPanel", PANEL, "Panel" )







/*







function showhelp(ply, cmd, args)
	if !START then return end
	if !menu_on then
		gui.EnableScreenClicker( true )
		menu_on = true
		menu:SetVisible(true)
	elseif menu.tab ~= 1 then
		menu:ChangePage( 1 )
	elseif menu.tab == 1 then
		CloseMenu()
	end
end
usermessage.Hook( "showhelp", showhelp )
concommand.Add( "helpme2", showhelp )

function showstore(ply, cmd, args)
	if !START then return end
	if !menu_on then
		menu:SetVisible(true)
		gui.EnableScreenClicker( true )
		menu_on = true
	end
	if menu.tab ~= 4 then
		menu:ChangePage( 4 )
	end
end
concommand.Add( "helpme3", showstore )

function CloseMenu()
	menu:SetVisible(false)
	gui.EnableScreenClicker(false)
	menu_on = false
end

menu = vgui.Create("Menu")

*/