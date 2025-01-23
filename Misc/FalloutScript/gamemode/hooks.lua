-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- hooks.lua
-- A hook system for plugins and other things.
-------------------------------

LEMON.Hooks = {  };
LEMON.TeamHooks = { };

function LEMON.CallTeamHook( hook_name, ply, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 ) -- Holy shit what a hacky method fo sho.
	
	local team = LEMON.NilFix(LEMON.Teams[ply:Team()], nil);
	if( team == nil ) then

		return; -- Team hasn't even been set yet!
		
	end
	
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs( LEMON.TeamHooks ) do
	
		if( hook.hook_name == hook_name and team.flag_key == hook.flag_key) then
			
			local unique = LEMON.NilFix(hook.unique_name, "");
			local func = LEMON.NilFix(hook.callback, function() end);
			
			--LEMON.DayLog( "script.txt", "Running team hook " .. unique );
			
			local override = LEMON.NilFix(func( ply, LEMON.NilFix(arg1, nil), LEMON.NilFix(arg2, nil), LEMON.NilFix(arg3, nil), LEMON.NilFix(arg4, nil), LEMON.NilFix(arg5, nil), LEMON.NilFix(arg6, nil), LEMON.NilFix(arg7, nil), LEMON.NilFix(arg8, nil), LEMON.NilFix(arg9, nil), LEMON.NilFix(arg10, nil)), 1);
			
			if( override == 0 ) then return 0; end
			
		end
		
	end
	
	return 1;
	
end

function LEMON.AddTeamHook( hook_name, unique_name, callback, flagkey )
	
	local hook = {  };
	hook.hook_name = hook_name;
	hook.unique_name = unique_name;
	hook.callback = callback;
	hook.flag_key = flagkey;
	
	table.insert(LEMON.TeamHooks, hook);
	
	--LEMON.DayLog( "script.txt", "Adding team hook " .. unique_name .. " ( " .. hook_name .. " | " .. flagkey .. " )" );
	
end

-- This is to be called within LEMON functions
-- It will basically run through a table of hooks and call those functions if it matches the hook name.
-- If the hook returns a value of 0, it will not call any more hooks.
function LEMON.CallHook( hook_name, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 ) -- Holy shit what a hacky method fo sho.
	
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs( LEMON.Hooks ) do
	
		if( hook.hook_name == hook_name ) then
			
			local unique = LEMON.NilFix(hook.unique_name, "");
			local func = LEMON.NilFix(hook.callback, function() end);
			
			--LEMON.DayLog( "script.txt", "Running hook " .. unique );
			
			LEMON.NilFix(func( LEMON.NilFix(arg1, nil), LEMON.NilFix(arg2, nil), LEMON.NilFix(arg3, nil), LEMON.NilFix(arg4, nil), LEMON.NilFix(arg5, nil), LEMON.NilFix(arg6, nil), LEMON.NilFix(arg7, nil), LEMON.NilFix(arg8, nil), LEMON.NilFix(arg9, nil), LEMON.NilFix(arg10, nil)), 1);
			
			if( override == 0 ) then return 0; end
			
		end
		
	end
	
	return 1;
	
end

function LEMON.AddHook( hook_name, unique_name, callback )
	
	local hook = {  };
	hook.hook_name = hook_name;
	hook.unique_name = unique_name;
	hook.callback = callback;
	
	table.insert(LEMON.Hooks, hook);
	
	--LEMON.DayLog( "script.txt", "Adding hook " .. unique_name .. " ( " .. hook_name .. " )" );
	
end
