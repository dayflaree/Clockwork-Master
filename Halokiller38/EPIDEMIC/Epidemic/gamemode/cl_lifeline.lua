
LifeLineTable = nil;

local function GetLifePoints( curx, cury, endx, endy )

	local steptable = { }

	local xdiff = endx - curx;
	local ydiff = endy - cury;
	local xabs = math.abs( xdiff );
	local yabs = math.abs( ydiff );
	
	local len = math.sqrt( ( xdiff * xdiff ) + ( ydiff * ydiff ) );
	
	local steps = len / 2;
	local xsteps = xdiff / steps;
	local ysteps = ydiff / steps;
	
	local startx = curx;
	local starty = cury;

	for n = 1, math.ceil( steps ) do
	
		local x = curx + xsteps * n;
		local y = cury + ysteps * n;
		
		steptable[n] = { x = x, y = y, ydiff = y - ( ScrH() - 73 ), r = 0, g = 0, b = 0, alpha = 0 };
		
	end

	return steptable;

end

local function BuildLifeLineTable()

	LifeLineTable = { }
	
	local curx = 31;
	local cury = ScrH() - 73;
	local endx, endy;

	--All of the endpoints of the lifeline
	local endpoints =
	{
		
		{ y = 0, x = 5 },
		{ y = 15, x = 6 },
		{ y = -35, x = 14 },
		{ y = 30, x = 10 },
		{ y = -20, x = 10 },
		{ y = 15, x = 5 },
		{ y = -5, x = 5 },
		{ y = 0, x = 5 },
	
	}

	local steptables = { }
	
	for n = 1, #endpoints do
	
		endx = curx + endpoints[n].x;
		endy = cury + endpoints[n].y;
	
		local tbl = GetLifePoints( curx, cury, endx, endy );
		steptables[n] = tbl;
		
		curx = tbl[#tbl].x;
		cury = tbl[#tbl].y;
	
	end
	
	for k, v in pairs( steptables ) do
	
		for n, m in pairs( v ) do
		
			table.insert( LifeLineTable, m );
		
		end
	
	end

end

BuildLifeLineTable();