
local PLUGIN = PLUGIN;

-- A function to load the static props.
function PLUGIN:LoadTerminals()
	local terminals = Clockwork.kernel:RestoreSchemaData("plugins/terminals/"..game.GetMap());
	
	for k, v in pairs(terminals) do
		local entity = ents.Create("cw_terminal");
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();

		local physicsObject = entity:GetPhysicsObject();		
		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false);
		end;
	end;
end;

-- A function to save the static props.
function PLUGIN:SaveTerminals()
	local terminals = {};
	
	for k, v in pairs(ents.FindByClass("cw_terminal")) do
		terminals[#terminals + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/terminals/"..game.GetMap(), terminals);
end;

	
	local spawnData = {	
		-- Terminals
		[ "cw_terminal" ] = {	
			[ "rp_industrial17_beta8" ] = {
			
				{ Vector( -3358.416015625, 2809.1057128906, 464.42791748047 ), Angle( 0, -90, 0 ) },
				{ Vector( -405.80630493164, 2728.1623535156, 136.42799377441 ), Angle( 0, -90, 0 ) },
				{ Vector( 795.32836914063, 3874.1857910156, 136.42797851563 ), Angle( 0, -45, 0 ) },
				{ Vector( 101.00797271729, 4163.4287109375, 176.4280090332 ), Angle( 0, 135, 0 ) },
				{ Vector( 642.19372558594, 4058.708984375, 200.42796325684 ), Angle( 0, -90, 0 ) },
				{ Vector( 2346.1936035156, 3828.4443359375, 128.42797851563 ), Angle( 0, -90, 0 ) },
				{ Vector( 1754.1937255859, 4351.20703125, 384.42788696289 ), Angle( 0, -90, 0 ) },
				{ Vector( 2511.1115722656, 5107.3081054688, 328.42797851563 ), Angle( 0, 0, 0 ) },
				{ Vector( 2825.1337890625, 4605.64453125, 328.42797851563 ), Angle( 0, -135, 0 ) },
				{ Vector( 3205.2722167969, 4337.5693359375, 328.42788696289 ), Angle( 0, 135, 0 ) },
				{ Vector( 3088.0153808594, 2136.8500976563, 136.42797851563 ), Angle( 0, 90, 0 ) },
				{ Vector( 3946.1936035156, 4451.1533203125, 328.42797851563 ), Angle( 0, -90, 0 ) },
				{ Vector( 4224.6430664063, 5347.3022460938, 384.42785644531 ), Angle( 0, 0, 0 ) },
				{ Vector( 2880.0153808594, 1551.4183349609, 136.42794799805 ), Angle( 0, 90, 0 ) },
				{ Vector( 3802.4294433594, 1387.3240966797, 200.4280090332 ), Angle( 0, 0, 0 ) }
				
			},
			[ "rp_lp_industrial17_v1a" ] = {
			
				{ Vector( -3358.416015625, 2809.1057128906, 464.42791748047 ), Angle( 0, -90, 0 ) },
				{ Vector( -405.80630493164, 2728.1623535156, 136.42799377441 ), Angle( 0, -90, 0 ) },
				{ Vector( 795.32836914063, 3874.1857910156, 136.42797851563 ), Angle( 0, -45, 0 ) },
				{ Vector( 101.00797271729, 4163.4287109375, 176.4280090332 ), Angle( 0, 135, 0 ) },
				{ Vector( 642.19372558594, 4058.708984375, 200.42796325684 ), Angle( 0, -90, 0 ) },
				{ Vector( 2346.1936035156, 3828.4443359375, 128.42797851563 ), Angle( 0, -90, 0 ) },
				{ Vector( 1754.1937255859, 4351.20703125, 384.42788696289 ), Angle( 0, -90, 0 ) },
				{ Vector( 2511.1115722656, 5107.3081054688, 328.42797851563 ), Angle( 0, 0, 0 ) },
				{ Vector( 2825.1337890625, 4605.64453125, 328.42797851563 ), Angle( 0, -135, 0 ) },
				{ Vector( 3205.2722167969, 4337.5693359375, 328.42788696289 ), Angle( 0, 135, 0 ) },
				{ Vector( 3088.0153808594, 2136.8500976563, 136.42797851563 ), Angle( 0, 90, 0 ) },
				{ Vector( 3946.1936035156, 4451.1533203125, 328.42797851563 ), Angle( 0, -90, 0 ) },
				{ Vector( 4224.6430664063, 5347.3022460938, 384.42785644531 ), Angle( 0, 0, 0 ) },
				{ Vector( 2880.0153808594, 1551.4183349609, 136.42794799805 ), Angle( 0, 90, 0 ) },
				{ Vector( 3802.4294433594, 1387.3240966797, 200.4280090332 ), Angle( 0, 0, 0 ) }
				
			},
			[ "gm_construct" ] = {
				{ Vector( 527.987122, -138.632095, -148.091904), Angle( 0, -90, 0 ) }
			}
		
		}
	}

	local function SpawnEntities( pl )
		if not pl or pl:IsAdmin() then
			for class, _ in pairs( spawnData ) do
				for _, panel in pairs( ents.FindByClass( class ) ) do					
					panel:Remove()
				end
			end

			timer.Simple( 1, function()				
				for class, maps in pairs( spawnData ) do
					local spawns = maps[ game.GetMap() ]
					if spawns then
						for _, data in pairs( spawns ) do
							local ent = ents.Create( class )
							
							if (IsValid(ent)) then
								ent:SetPos( data[1] )
								ent:SetAngles( data[2] )
								ent:Spawn()
							end
						end
					end
				end
			end )
		end
	end
	--hook.Add( "InitPostEntity", "thermentities_spawn", SpawnEntities )
	concommand.Add( "reload_thermaentities", SpawnEntities )
