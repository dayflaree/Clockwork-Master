
function CreateProcessBar( id, title, ply )

	local bar = { }

	bar.Title = title;
	bar.ThinkDelay = 1;
	bar.NextThink = 0;
	bar.Color = nil;
	bar.Linger = false;
	
	ply.ProcessBars[id] = bar;

	ply.ActiveProcessBar = id;

end
 
function SetColor( color, ply )

	ply.ProcessBars[ply.ActiveProcessBar].Color = color;
	
end

function SetThink( think, ply )

	ply.ProcessBars[ply.ActiveProcessBar].ThinkFunc = think;

end

function SetThinkDelay( delay, ply )

	ply.ProcessBars[ply.ActiveProcessBar].ThinkDelay = delay;

end

function SetEstimatedTime( time, ply )

	ply.ProcessBars[ply.ActiveProcessBar].TimeDone = time;

end

function SetLinger( bool, ply )

	ply.ProcessBars[ply.ActiveProcessBar].Linger = bool;

end

function EndProcessBar( ply )

	ply.ProcessBars[ply.ActiveProcessBar].Time = CurTime();

	if( ply.ProcessBars[ply.ActiveProcessBar].Color ) then
	
		umsg.Start( "CCPB", ply );
			umsg.String( ply.ActiveProcessBar );
			umsg.String( ply.ProcessBars[ply.ActiveProcessBar].Title );
			umsg.Float( ply.ProcessBars[ply.ActiveProcessBar].TimeDone );
			umsg.Short( ply.ProcessBars[ply.ActiveProcessBar].Color.r );
			umsg.Short( ply.ProcessBars[ply.ActiveProcessBar].Color.g );
			umsg.Short( ply.ProcessBars[ply.ActiveProcessBar].Color.b );
			umsg.Short( ply.ProcessBars[ply.ActiveProcessBar].Color.a );
		umsg.End();
	
	else

		umsg.Start( "CPB", ply );
			umsg.String( ply.ActiveProcessBar );
			umsg.String( ply.ProcessBars[ply.ActiveProcessBar].Title );
			umsg.Float( ply.ProcessBars[ply.ActiveProcessBar].TimeDone );
		umsg.End();
		
	end

end

function GetPercentage( id, ply )

	local totaltime = ply.ProcessBars[id].TimeDone;
	local timedone = CurTime() - ply.ProcessBars[id].Time;

	local perc = ( timedone / totaltime ) * 100;

	return perc;

end

function DestroyProcessBar( id, ply )

	ply.ProcessBars[id] = nil;

	umsg.Start( "RPB", ply );
		umsg.String( id );
	umsg.End();

end

