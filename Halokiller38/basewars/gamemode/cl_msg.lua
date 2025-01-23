
local HUDNote_c = 0
local HUDNote_i = 1
HUDNotesm = {}

function GM:AddMessage( str, type, length )

	local tab = {}
	tab.text 	= str
	tab.recv 	= SysTime()
	tab.len 	= length
	tab.velx	= 0
	tab.vely	= 0
	tab.x		= 20
	tab.y		= 0
	tab.a		= 255
	tab.type	= type
	
	table.insert(HUDNotesm, 1, tab)
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
	
end


local function DrawMessagem( self, k, v, i )

	local H = ScrH() / 1024
	local x = v.x
	local y = v.y
	
	if ( !v.w ) then
	
		surface.SetFont( "MessageFont" )
		v.w, v.h = surface.GetTextSize( v.text )
	
	end
	
	local w = v.w
	local h = v.h
	
	w = w + 16
	h = h+((i-1)*v.h)
	y=y+h
	
	surface.SetDrawColor( 255, 255, 255, v.a )
	local textcolor = Color(0,250,0,255)
	if v.type==1 then
		textcolor = Color(250,0,0,255)
	elseif v.type==2 then
		textcolor = Color(0,100,0,255)
	elseif v.type==3 then
		textcolor = Color(150,150,0,255)
	elseif v.type==4 then
		textcolor = Color(150,0,0,255)
	end
	if LocalPlayer():GetInfoNum("bw_showmessages")==1 then
		draw.SimpleText( v.text, "MessageFont", x+1, y+1, Color(0,0,0,150), TEXT_ALIGN_LEFT )
		draw.SimpleText( v.text, "MessageFont", x, y, textcolor, TEXT_ALIGN_LEFT )
	end
end

function MsgManageMessages(msg)
	local text = msg:ReadString()
	local type = msg:ReadShort()
	local time = msg:ReadShort()
	if LocalPlayer():GetInfoNum("bw_showmessages")==nil then
		CreateClientConVar("bw_showmessages", 1, true, false)
	end
	if LocalPlayer():GetInfoNum("bw_shownotify")==nil then
		CreateClientConVar("bw_shownotify", 0, true, false)
	end
	if LocalPlayer():GetInfoNum("bw_messages_warningnotify")==nil then
		CreateClientConVar("bw_messages_warningnotify", 1, true, false)
	end
	if LocalPlayer():GetInfoNum("bw_messages_dontshowincome")==nil then
		CreateClientConVar("bw_messages_dontshowincome", 0, true, false)
	end
	local mode = LocalPlayer():GetInfoNum("bw_showmessages")
	local both = LocalPlayer():GetInfoNum("bw_shownotify")
	local warn = LocalPlayer():GetInfoNum("bw_messages_warningnotify")
	local inc = LocalPlayer():GetInfoNum("bw_messages_dontshowincome")
	
	if mode==0 then
		GAMEMODE:AddNotify(text,type,time)
	elseif mode==1 then
		if inc==0 || type!=2 then
			GAMEMODE:AddMessage(text,type,time)
		end
	end
	if both==1 && mode==1 then
		GAMEMODE:AddNotify(text,type,time)
	end
	if warn==1 && mode==1 && both==0 && type==1 then
		GAMEMODE:AddNotify(text,type,time)
	end
end
usermessage.Hook("RPDMNotify", MsgManageMessages)