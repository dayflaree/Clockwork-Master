
local meta = FindMetaTable( "Player" );

function meta:CreateProgressBar( id, text, duration, interval, think, done, remove )

	self:GetTable().ProgressBars[id] = {
	
		Text = text,
		Duration = duration,
		Interval = interval,
		NextThink = CurTime() + interval,
		StartTime = CurTime(),
		EndTime = CurTime() + duration,
		ThinkFunc = think or function() end,
		DoneFunc = done or function() end,
		RemoveFunc = remove or function() end,
	
	};
	
	umsg.Start( "CPB", self );
		umsg.String( id );
		umsg.String( text );
		umsg.Float( duration );
	umsg.End();

end

function meta:RemoveProgressBar( id )

	if( self:GetTable().ProgressBars[id].RemoveFunc ) then
	
		self:GetTable().ProgressBars[id].RemoveFunc( self:GetTable().ProgressBars[id] );
	
	end

	self:GetTable().ProgressBars[id] = nil;

	umsg.Start( "RPB", self );
		umsg.String( id );
	umsg.End();

end

function meta:ProgressBarThink()

	if( not self:GetTable().ProgressBars ) then return; end

	for k, v in pairs( self:GetTable().ProgressBars ) do
	
		if( CurTime() >= v.NextThink ) then
		
			local progress = ( CurTime() - v.StartTime ) / v.Duration;
		
			v.NextThink = v.NextThink + v.Interval;
			
			if( progress >= 1 ) then
			
				if( v.DoneFunc( self ) ) then
			
					self:RemoveProgressBar( k );
				
				end
			
			elseif( v.ThinkFunc( self, progress ) == false ) then

				self:RemoveProgressBar( k );			
			
			end
			
		end
	
	end

end
