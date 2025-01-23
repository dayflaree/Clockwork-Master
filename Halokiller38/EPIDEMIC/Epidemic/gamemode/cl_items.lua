
ItemData = { }

InvUniqueID = 1;

--Receive Item Data 
function msgs.RECID( msg )

	local id = msg:ReadString();
	local name = msg:ReadString();
	local flags = msg:ReadString();
	
	local data =
	{
	
		id = id,
		name = name,
		w = 0,
		h = 0,
		model = "",
		desc = "",
		flags = flags,
	
	}
	
	ItemData[id] = data;

end


--Receive Item Model Data
function msgs.RECMID( msg )

	local id = msg:ReadString();
	local model = msg:ReadString();
	local width = msg:ReadShort();
	local height = msg:ReadShort();
	
	ItemData[id].model = model;
	ItemData[id].w = width;
	ItemData[id].h = height;

end


--Receive Item Pos Data
function msgs.RECPID( msg )

	local id = msg:ReadString();
	local campos = msg:ReadVector();
	local lookat = msg:ReadVector();
	local fov = msg:ReadShort();
	
	ItemData[id].CamPos = campos;
	ItemData[id].LookAt = lookat;
	ItemData[id].Fov = fov;

end


--Append Item Desc
function msgs.APID( msg )

	local id = msg:ReadString();
	local desc = msg:ReadString();	

	ItemData[id].desc = ItemData[id].desc .. desc;

end
