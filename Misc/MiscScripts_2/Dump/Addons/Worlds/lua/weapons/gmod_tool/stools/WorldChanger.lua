TOOL.Category		= "Construction"
TOOL.Name			= "#World Changer"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add("Tool_WorldChanger_name", "World Changer")
	language.Add("Tool_WorldChanger_desc", "Changes the Worlds you or your props exist in.")
	language.Add("Tool_WorldChanger_0", "Left Click: Set your targets World. Right click: Set your World.")
end

TOOL.ClientConVar["world"] = 0

function TOOL:LeftClick(tr)
	local world = self:GetClientNumber("world", 0)
	if not tr.Entity then return false end
	if not tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() then return false end
	if tr.Entity:IsWorld() then return false end
	if CLIENT then return true end
	
	tr.Entity:SetWorld(world)
	hook.Call("EntityChangedWorld", tr.Entity)
	return true
end

function TOOL:RightClick(tr)
	if CLIENT then return false end
	local world = self:GetClientNumber("world", 0)
	local oldworld = self:GetOwner():GetWorld()
	if world == oldworld then return false end
	
	hook.Call("PlayerChangedWorld", GAMEMODE, self:GetOwner(), world)
	self:GetOwner():SendLua('hook.Call("PlayerChangedWorld", GAMEMODE, LocalPlayer(), '..world..', '..oldworld..')')
	self:GetOwner():SetWorld(world)
	return true
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {Text = "World Changer", Description = "Changes the current World"})
	CPanel:AddControl("Slider", {Label = "World", Description = "Changes the World.", Command = "WorldChanger_world", Type = "Integer", min = 0, max = 10})
end

function TOOL:RenderToolScreen()
	cam.Start2D()
		surface.SetDrawColor(25, 25, 25, 255)
		surface.DrawRect(0, 0, 256, 256)
		
		surface.SetFont("HUDNumber")
		surface.SetTextColor(200, 200, 200, 255)
		local w, h = surface.GetTextSize("Change To")
		surface.SetTextPos(128 - (w / 2), 10)
		surface.DrawText("Change To")
		
		surface.SetFont("WorldsToolFont")
		surface.SetTextColor(200, 200, 200, 255)
		local w, h = surface.GetTextSize(self:GetClientNumber("world", 0))
		surface.SetTextPos(128 - (w / 2), 50)
		surface.DrawText(self:GetClientNumber("world", 0))
		
		surface.SetFont("HUDNumber")
		surface.SetTextColor(200, 200, 200, 255)
		local w, h = surface.GetTextSize("Current World")
		surface.SetTextPos(128 - (w / 2), 128)
		surface.DrawText("Current World")
		
		surface.SetFont("WorldsToolFont")
		surface.SetTextColor(200, 200, 200, 255)
		local w, h = surface.GetTextSize(LocalPlayer():GetWorld())
		surface.SetTextPos(128 - (w / 2), 160)
		surface.DrawText(LocalPlayer():GetWorld())
	cam.End2D()
end