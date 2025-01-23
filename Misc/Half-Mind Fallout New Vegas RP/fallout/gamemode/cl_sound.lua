GM.Music = { };
GM.Music.Menus = {
	{ "fallout/music/MainTitle.wav", 34 },
	{ "fallout/music/mus_exitthevault.ogg", 37 },
	{ "fallout/music/mus_death.mp3", 11 },
}
GM.Music.Light = {
	{ "fallout/music/day/mus_inc_day-001.wav", 17 },
	{ "fallout/music/day/mus_inc_day-002.wav", 10 },
	{ "fallout/music/day/mus_inc_day-003.wav", 13 },
	{ "fallout/music/day/mus_inc_day-004.wav", 10 },
	{ "fallout/music/day/mus_inc_day-005.wav", 13 },
	{ "fallout/music/day/mus_inc_day-006.wav", 8 },
	{ "fallout/music/day/mus_inc_day-007.wav", 12 },
	{ "fallout/music/day/mus_inc_day-008.wav", 17 },
	{ "fallout/music/day/mus_inc_day-009.wav", 7 },
	{ "fallout/music/day/mus_inc_day-010.wav", 10 },
}
GM.Music.Alert = {
	{ "infected/music/ghosts_03.mp3", 231 },
}

function GM:PlayRandomLight()
	
	self:PlaySong( table.Random( self.Music.Light ), 1, 25 );
	
end

function GM:PlayRandomAlert()
	
	self:PlaySong( table.Random( self.Music.Alert ) );
	
end

function GM:PlaySong( song, f, vol )
	
	if( type( song ) == "string" ) then
		
		for _, v in pairs( self.Music.Light ) do
			
			if( v[1] == song ) then
				
				song = v;
				break;
				
			end
			
		end
		
		for _, v in pairs( self.Music.Alert ) do
			
			if( v[1] == song ) then
				
				song = v;
				break;
				
			end
			
		end
		
	end
	
	f = f or 1;
	
	if( !self.MusicSound ) then
		
		self.MusicSound = CreateSound( LocalPlayer(), song[1] );
		
		if( vol ) then
			
			self.MusicSound:PlayEx( vol, 100 );
			
		else
			
			self.MusicSound:Play();
			
		end
		
		self.NextIdleTime = CurTime() + math.random( 30, 60 );
		self.CurrentSongEnd = CurTime() + song[2];
		
	else
		
		if( self.CurrentSongEnd and CurTime() < self.CurrentSongEnd - f ) then
			
			self.NextSongTime = CurTime() + f;
			self.NextSong = song;
			self.NextVolume = vol;
			
			self.MusicSound:FadeOut( f );
			
			self.SongStopTime = CurTime() + f;
			
		elseif( self.MusicSound:IsPlaying() ) then
			
			self.NextSongTime = CurTime() + f;
			self.NextSong = song;
			self.NextVolume = vol;
			
		else
			
			self.MusicSound = CreateSound( LocalPlayer(), song[1] );
			
			if( vol ) then
				
				self.MusicSound:PlayEx( vol, 100 );
				
			else
				
				self.MusicSound:Play();
				
			end
			
			self.CurrentSongEnd = CurTime() + song[2];
			self.NextIdleTime = CurTime() + math.random( 30, 60 );
			
		end
		
	end
	
end

function GM:StopSong( f )
	
	f = f or 0;
	
	if( self.MusicSound ) then
		
		if( f == 0 ) then
			
			self.MusicSound:Stop();
			self.CurrentSongEnd = nil;
			
		elseif( CurTime() < self.CurrentSongEnd - f ) then
			
			self.MusicSound:FadeOut( f );
			self.SongStopTime = CurTime() + f;
			
		end
		
	end
	
end

function GM:MusicThink()
	
	if( self.SongStopTime and CurTime() >= self.SongStopTime ) then
		
		if( self.MusicSound ) then
			
			self.MusicSound:Stop();
			self.CurrentSongEnd = nil;
			
		end
		
		self.SongStopTime = nil;
		
	end
	
	if( self.NextSongTime and self.NextSong and CurTime() >= self.NextSongTime ) then
		
		self.MusicSound = CreateSound( LocalPlayer(), self.NextSong[1] );
		
		if( self.NextVolume ) then
			
			self.MusicSound:PlayEx( self.NextVolume, 100 );
			
		else
			
			self.MusicSound:Play();
			
		end
		
		self.CurrentSongEnd = CurTime() + self.NextSong[2];
		self.NextIdleTime = CurTime() + math.random( 30, 60 );
		
		self.NextSongTime = nil;
		self.NextSong = nil;
		self.NextVolume = nil;
		
	end
	
	if( self.NextIdleTime and CurTime() >= self.NextIdleTime ) then
		
		self:PlayRandomLight();
		
	end
	
end
