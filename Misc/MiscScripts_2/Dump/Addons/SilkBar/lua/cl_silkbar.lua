if (SERVER) then return end

local SilkBar = nil

Msg("==== Loading SilkBar (Client) ====\n")
include("vgui/cl_silkbar_gui.lua")
   
function CreateSilkBar() 

 	if (SilkBar) then
		SilkBar:Remove()
 		SilkBar = nil
	end
	
	SilkBar = vgui.Create("SilkBar")
	
end

function ShowSilkBar()

 	gui.EnableScreenClicker(true)
 	 
 	if (!SilkBar) then
 		CreateSilkBar()
 	end
	
 	SilkBar:SetVisible(true)
	//timer.Simple(0, gui.SetMousePos, ScrW() / 2, 10)
	
end
concommand.Add("+silkbar", ShowSilkBar)

function HideSilkBar() 
   
 	gui.EnableScreenClicker(false) 
 	 
 	if (SilkBar) then
		SilkBar:SetVisible(false)
	end
	
	if (SilkBar.entityMenu and SilkBar.entityMenu:IsValid()) then SilkBar.entityMenu:Hide() end
	
	if (SilkBar.usersMenu and SilkBar.usersMenu:IsValid()) then SilkBar.usersMenu:Hide() end
	if (SilkBar.mapsMenu and SilkBar.mapsMenu:IsValid()) then SilkBar.mapsMenu:Hide() end
	if (SilkBar.gamemodesMenu and SilkBar.gamemodesMenu:IsValid()) then SilkBar.gamemodesMenu:Hide() end
 	 
end
concommand.Add("-silkbar", HideSilkBar)

function MouseMenu(mc)
	if mc == MOUSE_LEFT then
		traceRes = LocalPlayer():GetEyeTrace()
		if traceRes.Entity:IsValid() then
			local pos = traceRes.Entity:GetPos():ToScreen()
			SilkBar.entityMenu = DermaMenu()
			SilkBar.entityMenu:SetPos(pos.x, pos.y)
			if traceRes.Entity:GetClass() == "player" then
				SilkBar.entityMenu:AddOption("Kick", function() RunConsoleCommand("ass_kickplayer", traceRes.Entity:UniqueID()) end)
				SilkBar.entityMenu:AddOption("Ban", function() RunConsoleCommand("ass_banplayer", traceRes.Entity:UniqueID()) end)
			elseif traceRes.Entity:GetClass() == "prop_physics" then
				
				SilkBar.entityMenu:AddOption("Info", function() LocalPlayer():ChatPrint("Owned by: "..traceRes.Entity:GetNWString("owner").."\n") end) //RunConsoleCommand("SB_Fling", traceRes.Entity:EntIndex())
			end
			SilkBar.entityMenu:Open()
		end
	end
end
hook.Add("GUIMousePressed", "SBMouseMenu", MouseMenu)

function PChat(text)
	LocalPlayer():ChatPrint(text)
end

Msg("==== Finish Loading SilkBar (Client) ====\n")