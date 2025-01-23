if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 80
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Hand-cuffs"			
	SWEP.Author				= "Noobulater"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.Author			= "Noobulater"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/katharsmodels/handcuffs/handcuffs-1.mdl";
SWEP.WorldModel = "models/weapons/w_fists.mdl";

if CLIENT then
	function SWEP:GetViewModelPosition ( Pos, Ang )
		Ang:RotateAroundAxis(Ang:Forward(), 90);
		Pos = Pos + Ang:Forward() * 6;
		Pos = Pos + Ang:Right() * 2;
		
		return Pos, Ang;
	end 
end

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay			= 5.0

SWEP.HoldType = "melee"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then return false end

	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	tr.Entity:Freeze( true )
	if SERVER then
		if tr.Entity:GetNWBool("Handcuffed") then
			tr.Entity:Hint("You are being arrested, wait 5 seconds until you will be able to resist arrest.")
		else
			self.Owner:Hint("The player needs to be handcuffed before arresting them")
		end
		timer.Simple(5,function() tr.Entity:Freeze(false) end)
	elseif CLIENT then
		if tr.Entity:GetNWBool("Handcuffed") then
			GUI_ArrestOptions(tr.Entity)
		end
	end
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() && tr.Entity:GetClass() != "prop_ragdoll" then return false end
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	if SERVER then
		if tr.Entity:GetClass() == "prop_ragdoll" && !tr.Entity.player:IsValid() then return false end
		local player = tr.Entity
		if tr.Entity:GetClass() == "prop_ragdoll" && tr.Entity.player:IsValid() then
			player = tr.Entity.player
			player:SetNWBool("Handcuffed",true)
			self.Owner:Hint("You Handcuffed "..player:Nick())
		else
			if player:GetNWBool("Handcuffed") then
				player:SetNWBool("Handcuffed", false)
				self.Owner:Hint("You unHandcuffed "..player:Nick())
			end
		end
	end
	if CLIENT then
		if !tr.Entity:GetNWBool("Handcuffed") && tr.Entity:IsPlayer() then
			self.Target = tr.Entity
			self.JailTime = CurTime() + 1
		end
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
end

function SWEP:Think()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then return false end
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
end
	

if CLIENT then


function GUI_ArrestOptions(ply)
	if GUI_Arrest_Frame != nil && GUI_Arrest_Frame:IsValid() then return end
	GUI_Arrest_Frame = vgui.Create("DFrame")
	GUI_Arrest_Frame:SetTitle("")
	GUI_Arrest_Frame:SetSize(250 ,150)
	GUI_Arrest_Frame:Center()
	GUI_Arrest_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Arrest_Frame:GetWide(),GUI_Arrest_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Arrest_Frame:GetWide()-2,GUI_Arrest_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UIBold")
								local x,y = surface.GetTextSize("Arrest Options")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Arrest Options")
							end
	GUI_Arrest_Frame:MakePopup()
	GUI_Arrest_Frame:ShowCloseButton(false)
				
	local GUI_Arrest_Exit = vgui.Create("DButton")
	GUI_Arrest_Exit:SetParent(GUI_Arrest_Frame)	
	GUI_Arrest_Exit:SetSize(10,10)
	GUI_Arrest_Exit:SetPos(235,5)
	GUI_Arrest_Exit:SetText("")
	GUI_Arrest_Exit.Paint = function()
										surface.SetMaterial(OC_Alert)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Arrest_Exit:GetWide(),GUI_Arrest_Exit:GetTall())
									end
	GUI_Arrest_Exit.DoClick = function()
								GUI_Arrest_Frame:Remove()
							end
							
	local GUI_Arrest_Panel = vgui.Create("DPropertySheet")
	GUI_Arrest_Panel:SetParent(GUI_Arrest_Frame)
	GUI_Arrest_Panel:SetPos(10,20)
	GUI_Arrest_Panel:SetSize(230,120)
	GUI_Arrest_Panel.Paint = function() 
									draw.RoundedBox(8,0,0,GUI_Arrest_Panel:GetWide(),GUI_Arrest_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end						

	local GUI_Time_Slider = vgui.Create( "DNumSlider", GUI_Arrest_Panel )
	GUI_Time_Slider:SetPos( 5,5 )
	GUI_Time_Slider:SetWide( 220 )
	GUI_Time_Slider:SetText( "Arrest Time" )
	GUI_Time_Slider:SetMin( 30 ) -- Minimum number of the slider
	GUI_Time_Slider:SetMax( 120 ) -- Maximum number of the slider
	GUI_Time_Slider:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
	GUI_Time_Slider:SetValue(30)
							
								
	local GUI_Arrest_Label = vgui.Create( "DLabel" )
	GUI_Arrest_Label:SetParent(GUI_Arrest_Panel)
	GUI_Arrest_Label:SetFont("UIBold")
	GUI_Arrest_Label:SetText( "Bail Price" )
	GUI_Arrest_Label:SizeToContents()
	GUI_Arrest_Label:SetPos(10,45)
	
	GUI_Bail_Entry = vgui.Create("DTextEntry")
	GUI_Bail_Entry:SetFont("UIBold")
	GUI_Bail_Entry:SetValue(0)
	GUI_Bail_Entry:SetSize(150,15)
	GUI_Bail_Entry:SetEditable(true)
	GUI_Bail_Entry:SetUpdateOnType(true)
	GUI_Bail_Entry:SetNumeric(true)
	GUI_Bail_Entry:SetParent(GUI_Arrest_Panel)
	GUI_Bail_Entry:SetPos(42 ,60)	

	local bailprice = 0 
	
	GUI_Bail_Entry.OnEnter = function()
								local price = math.Round(tonumber(GUI_Bail_Entry:GetValue()))
								if price >= 1000 then
									GUI_Bail_Entry:SetValue(1000)
								elseif price <= 0 then
									GUI_Bail_Entry:SetValue(0)
								end
							end

	local GUI_Arrest_Button = vgui.Create("DButton")
	GUI_Arrest_Button:SetParent(GUI_Arrest_Panel)
	GUI_Arrest_Button:SetPos(20,90)
	GUI_Arrest_Button:SetSize(190,20)
	GUI_Arrest_Button:SetTextColor(Color(0,0,0,255))
	GUI_Arrest_Button:SetText("Confirm Arrest")
	
	GUI_Arrest_Button.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Arrest_Button:GetWide(),GUI_Arrest_Button:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Arrest_Button:GetWide()-2,GUI_Arrest_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
							
	GUI_Arrest_Button.DoClick = function()
									RunConsoleCommand("OCRP_Arrest_Player",math.Clamp(math.Round(tonumber(GUI_Bail_Entry:GetValue())),30,120),math.Clamp(math.Round(tonumber(GUI_Bail_Entry:GetValue())),0,1000),ply:EntIndex())
									GUI_Arrest_Frame:Remove()
								end
	
end


function SWEP:DrawHUD()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then self.Target = nil self.JailTime = nil end

	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then self.Target = nil self.JailTime = nil return false end
	
	if tr.Entity == self.Target then
		if self.JailTime <= CurTime() then
			RunConsoleCommand("OCRP_Handcuffplayer",self.Target:EntIndex())
			self.Target = nil
			self.JailTime = nil
			return
		else
			
			surface.SetDrawColor(50,50,50,155)
			surface.DrawRect(ScrW()/2 - 101,ScrH()/2 - 11,202,22)

			surface.SetDrawColor(200,200,200,155)
			surface.DrawRect(ScrW()/2 - 100,ScrH()/2 - 10,200*(((self.JailTime-CurTime())/1)),20)
			
			surface.SetTextColor(255,255,255,255)
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize("Hand-Cuffing")
			surface.SetTextPos(ScrW()/2 -x/2,ScrH()/2-y/2)
			surface.DrawText("Hand-Cuffing")
			
		end
	end
	
end

end
