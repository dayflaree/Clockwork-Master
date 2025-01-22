
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;
local Schema = Schema;
local surface = surface;
local math = math;
local draw = draw;

local SCANNER_PIC_W = 550
local SCANNER_PIC_H = 380

local isInScannerCam = false;
local scannerEnt = nil;
PLUGIN.coolDownTime = 0;
-- followTarget = {Player target, string name}
PLUGIN.followTarget = {nil, "UNIDENTIFIED"};

surface.CreateFont("ScannerText", {
	font = "DebugFixed",
	weight = 800,
	size = 16,
	antialias = false,
	outline = true
})

function PLUGIN:CalcView(client, origin, angles, fov)
	if (isInScannerCam and scannerEnt and LocalPlayer():Alive()) then
		local pitch = client:GetAimVector():Angle().p;
		
		if pitch > 180 then
			pitch = 360 - pitch;
		else 
			pitch = -pitch;
		end
		
		pitch = -math.Clamp(pitch, -90, 60)
		
		local view = {};
		view.angles = angles + Angle(pitch/2, 0, 0);
		return view;
	end;
end;

-- Pain Scanner first-person HUD
function PLUGIN:HUDPaint()
	-- If in camera and the scanner entity exists
	if (isInScannerCam and scannerEnt and LocalPlayer():Alive()) then
		local curTime = CurTime();
		local player = LocalPlayer();
		local playerHealth = player:Health();
		local playerName = player:Name();
		
		local scannerPosition = scannerEnt:GetPos();
		
		local scrW, scrH = ScrW(), ScrH()
		local w, h = SCANNER_PIC_W, SCANNER_PIC_H
		local x, y = scrW*0.5 - (w * 0.5), scrH*0.5 - (h * 0.5)
		local x2, y2 = x + w*0.5, y + h*0.5
		
		surface.SetDrawColor(255, 255, 255, 10 + math.random(0, 1))
		surface.DrawRect(x, y, w, h)

		surface.SetDrawColor(255, 255, 255, 150 + math.random(-50, 50))
		surface.DrawOutlinedRect(x, y, w, h)

		surface.DrawLine(x2, 0, x2, y)
		surface.DrawLine(x2, y + h, x2, ScrH())
		surface.DrawLine(0, y2, x, y2)
		surface.DrawLine(x + w, y2, ScrW(), y2)

		x = x + 8
		y = y + 8
		
		draw.SimpleText("LOC: ("..tostring(scannerPosition)..")", "ScannerText", x, y, color_white, 0, 0)
		
		draw.SimpleText("UNIT: "..playerName, "ScannerText", x + w - surface.GetTextSize("UNIT: "..playerName) - 14, y, color_white, 0, 0)

		
		local targetPlayer = self.followTarget[1];
		local targetName = self.followTarget[2];
		
		if(type(targetPlayer) == "Player") then
			local targetPosition = targetPlayer:GetPos();
			-- If scanner got too far or
			if (targetPosition:Distance(scannerPosition) <= 700 and targetPosition:ToScreen().visible) then
				-- If target name unkown and target is facing the Local Player - set name. Otherwise it will be 'unkown'.
				if (targetName == "UNIDENTIFIED" and targetPlayer:GetAimVector():Dot(scannerPosition - targetPosition) > 0.9) then
					self.followTarget[2] = targetPlayer:GetName();
				end;
				draw.SimpleText("TARGET: "..targetName, "ScannerText", x + w - surface.GetTextSize("TARGET: "..targetName) - 14, y + 48, color_white, 0, 0)
			else
				self.followTarget = {nil, "UNIDENTIFIED"};
			end;
			draw.SimpleText("TRACE MODE", "ScannerText", x + w - surface.GetTextSize("TRACE MODE") - 14, y + 24, color_white, 0, 0)
		else
			draw.SimpleText("STANDBY MODE", "ScannerText", x + w - surface.GetTextSize("STANDBY MODE") - 14, y + 24, color_white, 0, 0)
		end;
		
		local playerAimVector = player:GetAimVector();
		
		local p = math.floor(-playerAimVector:Angle().p+360)
		if p > 180 then
			p = p - 360
		end
		
		draw.SimpleText("SPD.DR; YAW: "..math.floor(playerAimVector:Angle().y).."; PITCH: "..p, "ScannerText", x, y + 24, color_white, 0, 0);
		draw.SimpleText("HULL: "..math.floor(playerHealth).."%", "ScannerText", x, y + 48, Color(math.Clamp(100-(playerHealth*2)+100, 0, 100)*2.55, math.Clamp(playerHealth, 0, 100)*2.55, 0), 0, 0);
		local coolDown = self.coolDownTime;
		if (coolDown and coolDown + 3 > curTime) then
			local precentage = 100 - math.Clamp((coolDown - curTime) * (100/14), 0, 100);
			local color = Color(math.Clamp(100 - (precentage * 2) + 100, 0, 100) * 2.55, math.Clamp(precentage, 0, 100) * 2.55, 0);
			draw.SimpleText("RECHARGING: "..string.sub(tostring(precentage), 1, 5).." %", "ScannerText", x, y + h - 48, color, 0, 0);
		end;
	end;
end

-- Render & send the screenshot to the server.
function PLUGIN:SendScreenshot(scannerEnt)
	local light = DynamicLight(0)
		light.Pos = scannerEnt:GetPos();
		light.r = 255
		light.g = 255
		light.b = 255
		light.Brightness = 4
		light.Size = 2000
		light.Decay = 4000
		light.DieTime = CurTime() + 2
		light.Style = 0

	timer.Simple(FrameTime(), function()
		local scrW, scrH = ScrW(), ScrH()
		local w, h = SCANNER_PIC_W, SCANNER_PIC_H
		local x, y = scrW*0.5 - (w * 0.5), scrH*0.5 - (h * 0.5)
		local data = util.Base64Encode(render.Capture({
			quality = 50,
			x = x,
			y = y,
			w = w,
			h = h,
			format = "jpeg"
		}))
		
		if (data) then
			Schema:AddCombineDisplayLine( "Pinging image data to server...", Color(255, 255, 10, 255) );
			Clockwork.datastream:Start("ScannerShot", data)
		end
	end)
end

-- Draw the received image on the player's screen.
function PLUGIN:CreateScannerImage(data)
	local function CreateImagePanel(x, y, w, h)
		local parent = vgui.Create("DPanel");
		parent:SetDrawBackground(false);
		parent:SetPos(x, y);
		parent:SetSize(w, h);
		
		local texture = Material("effects/tvscreen_noise002a");
		
		local panel = parent:Add("DHTML");
		panel:DockMargin(0, 0, 0, 0);
		panel:Dock(FILL);
		panel:SetHTML([[<html style="padding:0px;margin:0px;overflow:hidden;">
							<img width="100%" height="100%" src="data:image/jpeg;base64,]]..data..[[" alt="" />
						</html>]]);

		panel.PaintOver = function(panel, w, h)
			surface.SetDrawColor(255, 255, 255, 10);
			surface.SetMaterial(texture);
			surface.DrawTexturedRect(8, 8, w - 16, h);
				
			local flash = math.abs(math.sin(RealTime() * 3) * 150);
			surface.SetDrawColor(150, 150, 150, 255);
			
			for i = 1, 3 do
				surface.DrawOutlinedRect(7 + i, 7 + i, w - 14 - i*2, h - 6 - i*2);
			end;
		end;
		
		parent.html = panel;
		
		return parent;
	end;

	local width, height = SCANNER_PIC_W, SCANNER_PIC_H;
	local panel = CreateImagePanel(128, 16, width, height);
	local w, h = width * 0.75, height * 0.75;
	
	panel:SetPos(ScrW() + w + 16, 16);
	panel:SetSize(w, h);
	panel:MoveTo(ScrW() - (w*(IMAGE_ID or 1) + 16), 16, 0.35, 0.1, 0.33);

	IMAGE_ID = (IMAGE_ID or 1) + 1;
	
	Schema:AddCombineDisplayLine( "Downloading image packets...", Color(255, 255, 10, 255) );
	
	timer.Simple(14, function()
		IMAGE_ID = math.max(IMAGE_ID - 1, 0);
		if (IsValid(panel)) then
			panel:MoveTo(ScrW() + (w + 16), 16, 0.4, 0)
			
			timer.Simple(0.5, function()
				panel:Remove()
			end)
		end
	end)
end



-- Update the scanner camera state and scanner entity clientside, to draw the HUD.
Clockwork.datastream:Hook("scannerCamChanged", function(data) 
	isInScannerCam = data[1]; 
	scannerEnt = data[2]; 
end);

-- Called when the scanner takes a picture.
Clockwork.datastream:Hook("scannerTakePicture", function(data)
	PLUGIN.coolDownTime = data[2];
	PLUGIN:SendScreenshot(data[1]);
end);

-- Recieve the captured image
Clockwork.datastream:Hook("ScannerData", function(data) PLUGIN:CreateScannerImage(data) end);

Clockwork.datastream:Hook("scannerUpdateFollowTarget", function(data) PLUGIN.followTarget[1] = data; PLUGIN.followTarget[2] = "UNIDENTIFIED"; end);
