
function GetContainerInventory( id )
local curmap = game.GetMap();

local inventory = util.KeyValuesToTable( "FalloutScript/mapdata/containers/".. id ..".txt" );

return inventory;
end


TS.MapContainers = nil;
TS.MapContainers = { }

function LoadContainers()
local curmap = game.GetMap();
local filedata = file.Read( "FalloutScript/MapData/"..curmap.."_containers.txt" ) or "";
TS.MapContainers = TS.GetArgumentLists( filedata );
local theinventory = { };

for k,v in pairs( TS.MapContainers ) do
if( v[5] != nil ) then
theinventory = GetContainerInventory( v[1] );

CreateContainer( v[2], Vector( v[3], v[4], v[5] ), Vector( v[5], v[6], v[7] ), theinventory, v[8] )
end
end


end

ContainerInventory = nil;
ContainerInventory = { };
function SaveContainers()

local curmap = game.GetMap();
local bigstring = "";
local ContainerID = math.random(1,9999);

for k,v in pairs( ents.GetAll() ) do


if( v:GetNWBool( "container" ) == true and v.inventory != "" and v.inventory != nil and !v.ply and table.HasValue(Containers, v:GetModel())) then
  ContainerInventory = v.inventory;

  bigstring = bigstring .. tostring(ContainerID) .. " " .. tostring(v:GetModel()) .. " " .. tostring(v:GetPos()) .. " " .. tostring(v:GetAngles()) .. " " .. tostring(v:GetNWInt("limit")) .. "\n";


end


end

file.Write("FalloutScript/MapData/"..curmap.."_containers.txt", bigstring )
util.TableToKeyValues( "FalloutScript/MapData/Containers/".. tostring(ContainerID) ..".txt", ContainerInventory )
end


TS.MapItems = nil;
TS.MapItems = { }

function LoadMapItems()
    local curmap = game.GetMap();
	local filedata = file.Read( "FalloutScript/MapData/"..curmap.."_items.txt" ) or "";
	TS.MapItems = TS.GetArgumentLists( filedata );	

	print("\n\n--LOADING ITEMS FROM MAP "..curmap.."\n");
	for k,v in pairs(TS.MapItems) do
    if( v[1] != nil ) then
    LEMON.CreateItem( v[1], Vector(v[2],v[3],v[4]), Vector(v[5], v[6], v[7]) )
    end
	end
	print("\n");
end

function SaveItems()

local curmap = game.GetMap();
local bigstring = "";

for k,v in pairs(ents.GetAll()) do

   if( v:GetClass() == "item_prop" ) then

   bigstring = bigstring .. v:GetNWString("Class") .." "..tostring(v:GetPos()).." "..tostring(v:GetAngles()).."\n";

   end
end

file.Write("FalloutScript/mapdata/"..curmap.."_items.txt", bigstring )
end

function TS.NewLineFix( str )

	str = string.gsub( str, "\r", "\n" );
	str = string.gsub( str, "\n\n", "\n" );
	
	return str;

end

function TS.MergeArgs( tbl, arg )

	arg = arg or 1;	
	local newtbl = { }
	local num = 1;
	
	for n = arg, #tbl do

		if( tbl[n] ) then

			newtbl[num] = tbl[n];
			num = num + 1;
			
		else
		
			break;
		
		end

	end
	
	return newtbl;

end

--Use this function to "parse" data files
--It'll a return a big table of each line of a data file, broken up into seperate arguments

--Example:
--"Hi this is line 1
--And this is line 2"
--will turn into this:
--[ [hi] [this] [is] [line] [1] ]
--[ [And] [this] [is] [line] [2] ]
--The [] represents a table cell
function TS.GetArgumentLists( str, includecomments )

	str = TS.NewLineFix( str );
	
	if( not includecomments ) then
	--	str = TS.RemoveComments( str );
	end
	
	local lines = string.Explode( "\n", str );
	
	local list = { }
	
	for k, v in pairs( lines ) do
	
		local listline = string.Explode( " ", v );
		listline = TS.FormatStringTable( listline );
		
		local newlistline = { }
		
		for n, m in pairs( listline ) do
		
			local add = true;
			
			if( not includecomments ) then
			
				if( string.find( m, "//" ) ) then
					
					add = false;
					break;
					
				end
			
			end
			
			if( add ) then
				
				local newm = string.gsub( string.gsub( m, "\r", "" ), "\n", "" );
				table.insert( newlistline, newm );
			
			end
		
		end
		
		if( #newlistline > 0 ) then
			table.insert( list, newlistline );
		end
		
	end
	
	return list;

end

function TS.RemoveComments( str )

	str = TS.NewLineFix( str );
	
	local newstr = "";
	local pos = string.find( str, "//" );
	
	if( not pos ) then newstr = str; end
	
	while( pos ) do
	
		newstr = newstr .. string.sub( str, 1, pos - 1 )
	
		local endline = string.find( str, "\n", pos );
		
		if( endline ) then
		
			newstr = newstr .. string.sub( str, endline );
			
		end
		
		pos = string.find( str, "//", pos + 2 );
	
	end
	
	return newstr;

end

function TS.FormatStringTable( strtable )

	local qs = false;
	local newtable = { }
	local n = 1;
	
	for k, v in pairs( strtable ) do
	
		if( string.find( v, "\"" ) ) then
		
			local posf = string.find( v, "\"" );
			local posl = string.find( v, "\"", posf + 1 );
		
			if( not qs ) then
				
				newtable[n] = string.sub( v, posf + 1 );
				qs = true;
				
				if( posl ) then
			
					newtable[n] = string.sub( v, posf + 1, posl - 1 );
					n = n + 1;
					qs = false;
				
				end
				
			else
				
				newtable[n] = newtable[n] .. " " .. string.sub( v, 1, posf - 1 );
				qs = false;
				n = n + 1;
			
			end
		
		elseif( not qs ) then
		
			newtable[n] = v;
			n = n + 1;
			
		else
		
			newtable[n] = newtable[n] .. " " .. v;
		
		end
	
	end
	
	return newtable;

end
