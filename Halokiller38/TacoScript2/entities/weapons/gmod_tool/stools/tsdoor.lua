-- door stool by Zaubermuffin
-- developed for TacoScript 2.

TOOL.Category = "Construction"
TOOL.Name = "TacoDoor"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["class"] = "prop_dynamic"
TOOL.ClientConVar["model"] = "models/props_combine/combine_door01.mdl"
TOOL.ClientConVar["autoclose"] = 1
TOOL.ClientConVar["closetime"] = 5
TOOL.ClientConVar["skin"] = 1
TOOL.ClientConVar["open"] = 1
TOOL.ClientConVar["close"] = 2

cleanup.Register("tsdoors")

function TOOL:LeftClick(trace)
	if CLIENT then
		return true
	end
	
	if not self:GetSWEP():CheckLimit("tsdoors") then
		return false
	end
	
	if not trace.Entity:IsValid() and not trace.Entity:IsWorld() then
		return false
	end
	
	local ply = self:GetOwner()
	
	local model = self:GetClientInfo("model")
	local class = self:GetClientInfo("class")
	local ang = Angle(0, self:GetOwner():GetAimVector():Angle().Yaw, 0)
	local autoclose = self:GetClientNumber("autoclose")
	local closetime = self:GetClientNumber("closetime")
	local skin = self:GetClientNumber("skin")
	local open = self:GetClientNumber("open")
	local close = self:GetClientNumber("close")
	
	local door = CreateDoor(ply, trace, class, model, ang, autoclose, closetime, class, skin)
	if not door then
		return false
	end
	
	-- wire it, hahahaha...ha
	if SERVER then
		numpad.OnDown(ply, open, "tsdoor_open", door)
		numpad.OnDown(ply, close, "tsdoor_close", door)
	end
	
	return true
end

function TOOL.RightClick(trace)
	return true
end

function TOOL.BuildCPanel(panel)
	if not TS then -- no tacoscript?
		panel:AddControl("Label", { Text = "We need more Taco." })
		return
	end
	
	panel:AddControl("Header", { Text = "TacoDoor", Description = "Would you like some Muffin along with your door?"})
	
	panel:AddControl("ComboBox", {
		Label = "Presets",
		MenuButton = 1,
		Folder = "tsdoor",
		Options = {
			tsdoor_model = "models/prop_combine/combine_door01.mdl",
			tsdoor_skin = 0,
			tsdoor_open = 1,
			tsdoor_close = 2,
		},
		CVars = {
			"tsdoor_model",
			"tsdoor_open",
			"tsdoor_close",
		}
	})
	
	panel:AddControl("Numpad", {
		Label = "Open",
		Label2 = "Close",
		Command = "tsdoor_open",
		Command2 = "tsdoor_close",
		ButtonSize = 20
	})
	
	local params = { Label = "Models", Description = "Select a doormodel. Notice: Combine doormodels can only be opened by the CCA, COTA or a CA.", Height = 150, Options = {}}
	params.Options["tall combine door"] = { tsdoor_class = "prop_dynamic", tsdoor_model = "models/props_combine/combine_door01.mdl", tsdoor_skin = 0 }
	params.Options["huge combine door"] = { tsdoor_class = "prop_dynamic", tsdoor_model = "models/combine_gate_Vehicle.mdl", tsdoor_skin = 0 }
	params.Options["small combine door"] = { tsdoor_class = "prop_dynamic", tsdoor_model = "models/combine_gate_citizen.mdl", tsdoor_skin = 0 }
	params.Options["door #1"] = { tsdoor_skin = "1", tsdoor_class = "prop_door_rotating", tsdoor_model = "models/props_c17/door01_left.mdl" }
	params.Options["door #2"] = { tsdoor_skin = "2", tsdoor_class = "prop_door_rotating", tsdoor_model = "models/props_c17/door01_left.mdl" }
	params.Options["door #3"] = { tsdoor_skin = "3", tsdoor_class = "prop_door_rotating", tsdoor_model = "models/props_c17/door01_left.mdl" }
	params.Options["door #12"] = { tsdoor_skin = "12", tsdoor_class = "prop_door_rotating", tsdoor_model = "models/props_c17/door01_left.mdl" }
	
	panel:AddControl("ListBox", params)
	panel:AddControl("CheckBox", { 
		Label = "Autoclose?",
		Command = "tsdoor_autoclose",
		Description = "If checked, doors close automagically after a configurable delay.",
	})
	
	panel:AddControl("Slider", {
		Label = "Autoclose delay",
		Description = "After the door was opened for this amount of time (in seconds), it will close.",
		Type = "Integer",
		Min = 0,
		Max = 120,
		Command = "tsdoor_closetime"
	})
end

function TOOL:UpdateGhostDoor(ent, player)
	if not ent or not ent:IsValid() then
		return
	end
	
	local tr = utilx.GetPlayerTrace(player, player:GetCursorAimVector())
	local trace = utilx.TraceLine(tr)
	
	if not trace.Hit then
		return
	end
		
	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(Angle(0, self:GetOwner():GetAimVector():Angle().Yaw, 0))
	ent:SetNoDraw(false)
end

function TOOL:Think()
    if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
        self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
    end
    self:UpdateGhostDoor( self.GhostEntity, self:GetOwner() )
end

if not ConVarExists("sbox_maxtsdoors") then 
	CreateConVar("sbox_maxtsdoors", 5, FCVAR_NOTIFY)
end

if SERVER then
	function CreateDoor(ply, trace, class, model, ang, autoclose, closetime, class, skin)
		if not ply:CheckLimit("tsdoors") then
			return nil
		end
		
		if tostring(class) == "prop_dynamic" and not ply:CanOpenCombineDoors() then
			return nil
		end
		
		local ent = ents.Create(class)
		if not ent:IsValid() then
			return nil
		end
		
		ent:SetModel(model)
		ent:SetAngles(ang)
		ent:SetPos(Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z - (trace.HitNormal.z * ent:OBBMins().z)))
		
		if tostring(class) == "prop_dynamic" then			
			ent:SetKeyValue("solid", "6")
			ent:SetKeyValue("MinAnimTime", "1")
			ent:SetKeyValue("MaxAnimTime", "5")
			ent.IsDoor = true
			ent.IsSpecialDoor = true
			ent.Locked = false
			ent.DoorFlags = "n" -- harhar
			ent.DoorOpened = false
			if autoclose == 1 then
				ent.DoorCloseTime = closetime
			end			
		elseif tostring(class) == "prop_door_rotating" then
			ent:SetKeyValue("hardware", skin)
			ent:SetKeyValue("distance", "90")
			ent:SetKeyValue("speed", "100")
			ent:SetKeyValue("spawnflags", "8192")
			ent:SetKeyValue("forceclosed", "0")
			if autoclose then
				ent:SetKeyValue("returndelay", closetime)
			else
				ent:SetKeyValue("returndelay", "-1")
			end
			ent.Locked = false
		else
			MsgN("TacoDoor: Unable to spawn class '" .. tostring(class) .. "'.")
			return nil
		end
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount("tsdoors", ent)
		ply:AddCleanup("tsdoors", ent)
		
		undo.Create("TacoDoor")
			undo.AddEntity(ent)
			undo.SetPlayer(ply)
		undo.Finish()
		
		return ent
	end
end

if CLIENT then
	language.Add("Tool_tsdoor_name", "TacoDoor")
	language.Add("Tool_tsdoor_desc", "Spawns a TacoScript door")
	language.Add("Tool_tsdoor_0", "Click somewhere to spawn a door.")
end

if SERVER then

	local function OpenDoor(ply, ent)
		if not ent:IsValid() or not ent.IsSpecialDoor or not ply:CanOpenCombineDoors() or ent.DoorOpened then
			return
		end
		ent:Fire("setanimation", "open", 0)
		
		if ent.DoorCloseTime then
			timer.Simple(ent.DoorCloseTime, 
				function() 
					if ent:IsValid() and ent.DoorOpened then 
						ent:Fire("setanimation", "close", 0) 
						ent.DoorOpened = false
					end 
				end
			)
		end		
	end
	numpad.Register("tsdoor_open", OpenDoor)
		
	local function CloseDoor(ply, ent)
		if ent:IsValid() and ent.IsSpecialDoor and ply:CanOpenCombineDoors() and ent.DoorOpened then
			ent:Fire("setanimation", "close", 0)
			ent.DoorOpened = false
		end
	end
	numpad.Register("tsdoor_close", CloseDoor)
end