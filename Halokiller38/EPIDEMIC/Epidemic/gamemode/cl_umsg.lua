
function msgs.RIHI( msg )

	local id = msg:ReadShort();
	local name = msg:ReadString();
	
	local ent = ents.GetByIndex( id );
	
	ent:GetTable().ItemName = name;

end

function msgs.RRL( msg )

	for k, v in pairs( player.GetAll() ) do
	
		v:GetTable().Title = nil;
	
	end

end

function msgs.RPRO( msg )

	local id = msg:ReadShort();
	local ent = ents.GetByIndex( id );

	if( ent and ent:IsValid() ) then

		ent:GetTable().CreatorName = string.gsub( msg:ReadString(), " ", "  " );

	end		

end

function msgs.RPRD( msg )

	local id = msg:ReadShort();
	local ent = ents.GetByIndex( id );

	if( ent and ent:IsValid() ) then

		ent:GetTable().PropDesc = string.gsub( msg:ReadString(), " ", "  " );

	end		

end

function msgs.RPR( msg )

	local id = msg:ReadShort();
	local ent = ents.GetByIndex( id );

	if( ent and ent:IsValid() ) then

		ent:GetTable().ChangedTitleInfo = true;

		if( ent == LocalPlayer() ) then
		
			for k, v in pairs( player.GetAll() ) do
			
				v:GetTable().Title = nil;
			
			end
		
		end

	end	

end

function msgs.PCT( msg )

	local id = msg:ReadShort();
	local ent = ents.GetByIndex( id );

	if( ent and ent:IsValid() ) then

		ent:GetTable().ChangedTitleInfo = true;

	end
	
end


function msgs.RPHI( msg )

	local id = msg:ReadShort();
	local title = msg:ReadString();

	local ent = ents.GetByIndex( id );
	
	ent:GetTable().Title = FormatLine( title, "PlayerDisp", 300 );
	ent:GetTable().ChangedTitleInfo = false;
	
	if( TargetEnts[id] ) then
	
		TargetEnts[id] = nil;
	
	end
	
	for k, v in pairs( TargetDisplays ) do
	
		if( v.EntIndex == id ) then
		
			TargetDisplays[k] = nil;
		
		end
	
	end

end

local function shrink( ent, bone )
	
	local boneent = ent:LookupBone( bone );
	local bonematrix = ent:GetBoneMatrix( boneent );
	bonematrix:Scale( Vector( 0, 0, 0 ) );
	ent:SetBoneMatrix( boneent, bonematrix );

end

function msgs.FindMyRagEnt( msg )
	
	local ent = msg:ReadEntity();
	local t = CurTime();
	local bestTime = math.huge;
	local bestRag = nil;
	
	for _, v in pairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
		
		local ragtime = v.Created;
		local disp = t - ragtime;
		
		if( disp < bestTime ) then
			
			bestTime = disp;
			bestRag = v;
			
		end
		
	end
	
	if( bestRag ) then
		
		ent.ClientRag = bestRag;
		bestRag.Zombie = ent;
		
	end

end

function msgs.DRH( msg )
	
	local ent = msg:ReadEntity();
	local clrag = ent.ClientRag;
	
	local func = function()
		
		if( clrag ) then
			
			clrag.BuildBonePositions = function( self )
			
				shrink( self, "ValveBiped.Bip01_Head1" );

			end
			
		end
		
	end
	
	if( clrag ) then
		
		func();
		
	else
		
		timer.Simple( 0.2, func );
		
	end
	
end

function msgs.DRA( msg )

	local ent = msg:ReadEntity();
	local clrag = ent.ClientRag;
	
	local arm = table.Random( { "R", "L" } );
	
	local func = function()
		
		if( clrag ) then
			
			clrag.BuildBonePositions = function( self )
			
				shrink( self, "ValveBiped.Bip01_" .. arm .. "_Hand" );
				shrink( self, "ValveBiped.Bip01_" .. arm .. "_Forearm" );

			end
			
		end
		
	end
	
	if( clrag ) then
		
		func();
		
	else
		
		timer.Simple( 0.2, func );
		
	end
	
end

function msgs.DRL( msg )
	
	local ent = msg:ReadEntity();
	local clrag = ent.ClientRag;
	
	local arm = table.Random( { "R", "L" } );
	
	local func = function()
		
		if( clrag ) then
			
			clrag.BuildBonePositions = function( self )

				shrink( self, "ValveBiped.Bip01_" .. arm .. "_Calf" );
				shrink( self, "ValveBiped.Bip01_" .. arm .. "_Foot" );
				shrink( self, "ValveBiped.Bip01_" .. arm .. "_Toe0" );
				
			end
			
		end
		
	end
	
	if( clrag ) then
		
		func();
		
	else
		
		timer.Simple( 0.2, func );
		
	end
	
end

function msgs.DRRP( msg )

	local ent = msg:ReadEntity();
	local clrag = ent.ClientRag;
	
	local function randomb()
	
		if( math.random( 1, 5 ) <= 3 ) then
		
			return true;
		
		end
		
		return false;
	
	end
	
	local headoff = randomb();
	local rlegoff = randomb();
	local llegoff = randomb();
	local larmoff = randomb();
	local rarmoff = randomb();
	
	local func = function()
		
		if( clrag ) then
			
			clrag.BuildBonePositions = function( self )

				if( headoff ) then
				
					shrink( self, "ValveBiped.Bip01_Head1" );
				
				end

				if( larmoff ) then

					shrink( self, "ValveBiped.Bip01_L_Hand" );
					shrink( self, "ValveBiped.Bip01_L_Forearm" );
					
				end

				if( rarmoff ) then

					shrink( self, "ValveBiped.Bip01_R_Hand" );
					shrink( self, "ValveBiped.Bip01_R_Forearm" );
					
				end

				if( rlegoff ) then

					shrink( self, "ValveBiped.Bip01_R_Calf" );
					shrink( self, "ValveBiped.Bip01_R_Foot" );
					shrink( self, "ValveBiped.Bip01_R_Toe0" );
					
				end

				if( llegoff ) then

					shrink( self, "ValveBiped.Bip01_L_Calf" );
					shrink( self, "ValveBiped.Bip01_L_Foot" );
					shrink( self, "ValveBiped.Bip01_L_Toe0" );
					
				end
				
			end
			
		end
		
	end
	
	if( clrag ) then
		
		func();
		
	else
		
		timer.Simple( 0.2, func );
		
	end
	
end

function msgs.ZG( msg )
	
	local dmgpos = msg:ReadVector();
	local self = msg:ReadEntity();
	
	if( not self or not self:IsValid() ) then return; end
	
	local effectdata = EffectData();
	effectdata:SetOrigin( dmgpos + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) );
	
	for k = 1, 2 do
		util.Effect( "BloodImpact", effectdata );
	end
	
	local trace = { }
	
	trace.start = dmgpos;
	trace.endpos = trace.start + self:GetRight() * math.random( -90, 90 ) + self:GetForward() * math.random( -90, 90 ) + self:GetUp() * -60;
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	local pos = tr.HitPos;
	local norm = tr.HitNormal;
	
	util.Decal( "Blood", pos + norm, pos - norm );
	
end

function msgs.D( msg )

	local type = msg:ReadShort();
	
	if( type == 1 ) then
	
		DeathMessage = string.gsub( "You have died by your own hands.", " ", "   " );
	
	elseif( type == 2 ) then
	
		DeathMessage = string.gsub( "You have been killed.", " ", "   " );
	
	elseif( type == 3 ) then
	
		DeathMessage = string.gsub( "You were shot in the head.", " ", "   " );
	
	elseif( type == 4 ) then
	
		DeathMessage = string.gsub( "You have bled to death.", " ", "   " );
	
	elseif( type == 5 ) then
	
		DeathMessage = string.gsub( "You have been mauled to death.", " ", "   " );
	
	elseif( type == 6 ) then
	
		DeathMessage = string.gsub( "You have been beaten to death.", " ", "   " );
	
	elseif( type == 7 ) then
	
		DeathMessage = string.gsub( "You have been grinded to death.", " ", "   " );
	
	elseif( type == 8 ) then
	
		DeathMessage = string.gsub( "You have died in a violent helicopter crash.", " ", "   " );
	
	end

end

function msgs.HMC( msg )

	local mdl = msg:ReadString();

end

function msgs.AST( msg )

	local steamid = msg:ReadString();
	local text = msg:ReadString();
	local color = msg:ReadVector();
	
	color = Color( color.x, color.y, color.z, 255 );

	AddScoreboardTitle( steamid, text, color );

end

function msgs.ASI( msg )

	local steamid = msg:ReadString();
	local date = msg:ReadString();
	local infk = msg:ReadShort();
	local humk = msg:ReadShort();
	local diedc = msg:ReadShort();
	local bannedc = msg:ReadShort();
	local kickedc = msg:ReadShort();

	if( steamid == "UNKNOWN" ) then
	
		steamid = "STEAM_0:1:4976333";
	
	elseif( steamid == "BOT" ) then
	
		steamid = "NULL";
	
	end
	
	AddScoreboardInfoForPlayer( steamid, date, "", infk, humk, diedc, bannedc, kickedc );

end

function msgs.ASD( msg )

	local steamid = msg:ReadString();
	local desc = msg:ReadString();
	
	if( steamid == "UNKNOWN" ) then
	
		steamid = "STEAM_0:1:4976333";
	
	elseif( steamid == "BOT" ) then
	
		steamid = "NULL";
	
	end
	
	
	if( ScoreboardPlayerInfo[steamid] ) then
	
		ScoreboardPlayerInfo[steamid].Desc = desc;
	
	end

end

