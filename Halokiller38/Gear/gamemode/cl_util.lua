

function event.ResetVariables()

	if( ClientVars ) then

		for k, v in pairs( PlayerVars ) do
		
			if( v.canreset ) then
		
				ClientVars[k] = v.default;
			
			end
			
		end
		
	end

end

function ScreenCenterInArea( x, y, w, h )

	local x2 = x + w;
	local y2 = y + h;
	
	local mx = ScrW() / 2;
	local my = ( ScrH() / 2 ) - 5;

	if( mx >= x and mx <= x2 ) then

		if( my >= y and my <= y2 ) then
			
			return true;
		
		end
	
	end
	
	return false;

end

function CursorInArea( x, y, w, h, mx, my )

	local x2 = x + w;
	local y2 = y + h;
	
	local mx = mx;
	local my = my;
	
	if( not mx ) then
	
		mx, my = gui.MousePos();

	end

	if( mx > x and mx < x2 ) then

		if( my > y and my < y2 ) then
			
			return true;
		
		end
	
	end
	
	return false;

end

function CursorLeftClickUp()

	if( input.IsMouseDown( MOUSE_LEFT ) ) then
	
		LeftClickDown = true;
	
	elseif( LeftClickDown ) then
	
		LeftClickDown = false;
		return true;
	
	end
	
	return false;

end

function CursorLeftClickedOn( x, y, w, h )

	if( input.IsMouseDown( MOUSE_LEFT ) ) then

		LeftClickDown = true;

	elseif( LeftClickDown ) then

		local x2 = x + w;
		local y2 = y + h;
		
		local mx, my = gui.MousePos();

		if( mx >= x and mx <= x2 ) then

			if( my >= y and my <= y2 ) then
				
				LeftClickDown = false;
				return true;
			
			end
		
		end

	end
	
	return false;

end