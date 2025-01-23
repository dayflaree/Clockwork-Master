FW_Wins = {}
FW_Wins[1] = {}
FW_Wins[2] = {}
FW_Wins[3] = {}

FW_Losses = {}
FW_Losses[1] = {}
FW_Losses[2] = {}
FW_Losses[3] = {}

SA_Wins = {}
SA_Wins[1] = {}
SA_Wins[2] = {}
SA_Wins[3] = {}

Bans = {}
Bans[1] = {}
Bans[2] = {}
Bans[3] = {}
Bans[4] = {}

FW_Kills = {}
FW_Kills[1] = {}
FW_Kills[2] = {}
FW_Kills[3] = {}

FW_FlagTime = {}
FW_FlagTime[1] = {}
FW_FlagTime[2] = {}
FW_FlagTime[3] = {}


Stats = {}
Stats[1] = "FW Kills"
Stats[2] = "SA Wins"
Stats[3] = "FW Wins"
Stats[4] = "FW Losses"
Stats[5] = "FW FlagTime"
Stats[6] = "Ban List"

/*
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
*/
PANEL={}
 
function PANEL:Init()
end

function PANEL:DoClick()
	if self:GetParent().statstab == self.statstab then return end
	self:GetParent().statstab = self.statstab
	surface.PlaySound("buttons/button4.wav")
	local tab = self.statstab
	RunConsoleCommand("getstat",tab)	
end
  
function PANEL:Paint()
	local bgColor = Color( 50, 50, 50, 255 )
	local fgColor = Color( 255, 255, 255, 255 )
	
	if self:GetParent().statstab == self.statstab then
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
vgui.Register("WhatStat",PANEL, "Button")

--------------
--This is my stats stuff
------------

function clearkills()
	for i=1,#FW_Kills[1] do
		table.remove(FW_Kills[1],i)
		table.remove(FW_Kills[2],i)
		table.remove(FW_Kills[3],i)
	end
end
usermessage.Hook("clearkills",clearkills)
function clearfwwins()
	for i=1,#FW_Wins[1] do
		table.remove(FW_Wins[1],i)
		table.remove(FW_Wins[2],i)
		table.remove(FW_Wins[3],i)
	end
end
usermessage.Hook("clearfwwins",clearfwwins)
function clearsawins()
	for i=1,#SA_Wins[1] do
		table.remove(SA_Wins[1],i)
		table.remove(SA_Wins[2],i)
		table.remove(SA_Wins[3],i)
	end
end
usermessage.Hook("clearsawins",clearsawins)
function clearlosses()
	for i=1,#FW_Losses[1] do
		table.remove(FW_Losses[1],i)
		table.remove(FW_Losses[2],i)
		table.remove(FW_Losses[3],i)
	end
end
usermessage.Hook("clearlosses",clearlosses)
function clearbans()
	for i=1,#Bans[1] do
		table.remove(Bans[1],i)
		table.remove(Bans[2],i)
		table.remove(Bans[3],i)
		table.remove(Bans[4],i)
	end
end
usermessage.Hook("clearbans",clearbans)
function clearflagtime()
	for i=1,#FW_FlagTime[1] do
		table.remove(FW_FlagTime[1],i)
		table.remove(FW_FlagTime[2],i)
		table.remove(FW_FlagTime[3],i)
	end
end
usermessage.Hook("clearflagtime",clearflagtime)
function GetKills( um )
	table.insert(FW_Kills[1], um:ReadString())
	table.insert(FW_Kills[2], um:ReadString())
	table.insert(FW_Kills[3], um:ReadLong())
end
usermessage.Hook("GetKills",GetKills)
function GetFWWins( um )
	table.insert(FW_Wins[1], um:ReadString())
	table.insert(FW_Wins[2], um:ReadString())
	table.insert(FW_Wins[3], um:ReadLong())
end
usermessage.Hook("GetFWWins",GetFWWins)
function GetSAWins( um )
	table.insert(SA_Wins[1], um:ReadString())
	table.insert(SA_Wins[2], um:ReadString())
	table.insert(SA_Wins[3], um:ReadLong())
end
usermessage.Hook("GetSAWins",GetSAWins)
function GetBans( um )
	table.insert(Bans[1], um:ReadString())
	table.insert(Bans[2], um:ReadString())
	table.insert(Bans[3], um:ReadString())
	table.insert(Bans[4], um:ReadString())
end
usermessage.Hook("GetBans",GetBans)
function GetFlagTime( um )
	table.insert(FW_FlagTime[1], um:ReadString())
	table.insert(FW_FlagTime[2], um:ReadString())
	table.insert(FW_FlagTime[3], um:ReadLong())
end
usermessage.Hook("GetFlagTime",GetFlagTime)
function GetFWLosses( um )
	table.insert(FW_Losses[1], um:ReadString())
	table.insert(FW_Losses[2], um:ReadString())
	table.insert(FW_Losses[3], um:ReadLong())
end
usermessage.Hook("GetFWLosses",GetFWLosses)