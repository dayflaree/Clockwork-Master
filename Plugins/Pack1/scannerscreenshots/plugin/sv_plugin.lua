local Clockwork = Clockwork;
local Schema = Schema;
local PLUGIN = PLUGIN;


function PLUGIN:KeyPress(player, char)
	if (Schema.scanners[player]) then
		local curTime = CurTime();
		if (char == IN_RELOAD) then
			local scanner = Schema.scanners[player][1];
			local marker = Schema.scanners[player][2];
			if (IsValid(scanner)) then
				-- Send screencap and update next capture time
				scanner:EmitSound("npc/scanner/scanner_photo1.wav");
				if (player.inScnCam and (!player.scannerCoolDown or player.scannerCoolDown <= curTime)) then
					player.scannerCoolDown = curTime + 14;
					Clockwork.datastream:Start(player, "scannerTakePicture", {scanner, player.scannerCoolDown});
					Schema:AddCombineDisplayLine( "Prepare for visual download...", Color(255, 255, 10, 255));
				else
					return;
				end;
				
				-- Blind anyone looking at the scanner as it emits the flash
				local position = scanner:GetPos();

				for k, v in ipairs( ents.FindInSphere(position, 384) ) do
					if (v:IsPlayer() and v:HasInitialized() and !Schema:PlayerIsCombine(v)) then
						local playerPosition = v:GetPos();
						local scannerDot = scanner:GetAimVector():Dot( (playerPosition - position):GetNormal() );
						local playerDot = v:GetAimVector():Dot( (position - playerPosition):GetNormal() );
						local threshold = 0.2 + math.Clamp( (0.6 / 384) * playerPosition:Distance(position), 0, 0.6 );

						if (Clockwork.player:CanSeeEntity( v, scanner, 0.9, {marker} ) and playerDot >= threshold and scannerDot >= threshold) then
							if (player != v) then
								if (v:GetFaction() == FACTION_CITIZEN) then
									if (!v:GetForcedAnimation()) then
										v:SetForcedAnimation("photo_react_blind", 2, function(player)
											player:Freeze(true);
										end, function(player)
											player:Freeze(false);
										end);
									end;
								end;

								Clockwork.datastream:Start(v, "cwStunned", 3);
							end;
						end;
					end;
				end;
			end;
			
		elseif (char == IN_USE) then
			player.inScnCam = !player.inScnCam;
			
			local scannerEnt = nil;
			if (!player.inScnCam) then
				player:SetViewEntity(player)
				player:Spectate(OBS_MODE_CHASE)
			else
				scannerEnt = Schema.scanners[player][1];
				player:SetViewEntity(scannerEnt)
				player:Spectate(OBS_MODE_NONE)
			end
			
			Clockwork.datastream:Start(player, "scannerCamChanged", {player.inScnCam, scannerEnt});
			
		elseif (char == IN_WALK) then
			Clockwork.player:RunClockworkCommand(player, "CharFollow");
			Clockwork.datastream:Start(player, "scannerUpdateFollowTarget", Schema.scanners[player][1].followTarget);
		end
	end
end

function PLUGIN:PlayerCharacterUnloaded(player)
	if(Schema.scanners[player]) then
		player:SetViewEntity(player)
		player:Spectate(OBS_MODE_CHASE)
		player.inScnCam = false;
		Clockwork.datastream:Start(player, "scannerCamChanged", {false, nil});
	end;
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if(Schema.scanners[player]) then
		player:SetViewEntity(player)
		player:Spectate(OBS_MODE_CHASE)
		player.inScnCam = false;
		Clockwork.datastream:Start(player, "scannerCamChanged", {false, nil});
	end;
end;

function PLUGIN:DoPlayerDeath(player, attacker, damageInfo)
	if(Schema.scanners[player]) then
		player:SetViewEntity(player)
		player:Spectate(OBS_MODE_CHASE)
		player.inScnCam = false;
		Clockwork.datastream:Start(player, "scannerCamChanged", {false, nil});
	end;
end;

Clockwork.datastream:Hook("ScannerShot", function(client, data)
	local scannerTable = Schema.scanners[client];
	
	if (scannerTable and client.inScnCam) then
		timer.Simple(0.1, function()
			if (!IsValid(client)) then
				return
			end

			local receivers = {}

			for k, v in pairs(player.GetAll()) do
				if (Schema:PlayerIsCombine(v)) then
					receivers[#receivers + 1] = v
				end
			end

			if (#receivers > 0) then
				Clockwork.datastream:Start(receivers, "ScannerData", data)
			end
		end)
	end
end)