local meta = FindMetaTable( "Player" );

-- Todo: Replace PrintMessage with something else
-- Maybe client-sided?

function meta:SayLocalOOCChat( text )

	local tbl = ents.FindInSphere( self:GetPos(), 180 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );
	
		end
	
	end

	self:SendOverlongMessage(TS.MessageTypes.LOOC.id, text, rec)
end

function meta:SayICAction( text )

	if( not self:Alive() or not self:GetPlayerConscious() ) then
		return;
	end
	
	text = string.Trim(text)
	
	if( string.len( text ) < 1 ) then return; end
	
	local tbl = ents.FindInSphere( self:GetPos(), 180 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );

		
		end
	
	end

	self:SendOverlongMessage(TS.MessageTypes.ICACTION.id, text, rec)
end

function meta:DoICAction( text )

	if( not self:Alive() or not self:GetPlayerConscious() ) then
		return;
	end
	
	if( string.len( text ) < 1 ) then return; end
	if( string.gsub( text, " ", "" ) == "" ) then return; end
	
	local tbl = ents.FindInSphere( self:GetPos(), 180 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );
			--v:PrintMessage( 2, self:GetRPName() .. text );
		
		end
	
	end

	-- Why isn't this logged?
	self:SendOverlongMessage(TS.MessageTypes.EMOTE.id, text, rec)
end

function meta:WhisperLocalChat( text )

	if( not self:Alive() or not self:GetPlayerConscious() ) then
		return;
	end
	
	local tbl = ents.FindInSphere( self:GetPos(), 90 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );
		
		end
	
	end

	self:SendOverlongMessage(TS.MessageTypes.WHISPER.id, text, rec)
end

function meta:YellLocalChat( text )

	if( not self:Alive() or not self:GetPlayerConscious() ) then
		return;
	end
	
	local tbl = ents.FindInSphere( self:GetPos(), 600 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );		
		end
	
	end

	self:SendOverlongMessage(TS.MessageTypes.YELL.id, text, rec)
end

function meta:SayLocalChat( text )

	if( not self:Alive() or not self:GetPlayerConscious() ) then
		return;
	end

	local tbl = ents.FindInSphere( self:GetPos(), 180 );
	
	local rec = RecipientFilter();
	
	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			rec:AddPlayer( v );
			--v:PrintMessage( 2, self:GetRPName() .. ": " .. text );
		
		end
	
	end

	TS.WriteToChatLog( self:GetRPName() .. "( " .. self:SteamID() .. " ) [IC]: " .. text );
	self:SendOverlongMessage(TS.MessageTypes.SAY.id, text, rec)
end

function meta:SayGlobalChat( text )

	if( self.Muted ) then
	
		self:PrintMessage( 3, "You are muted!" );
		return "";
	
	end

	self:SendOverlongMessage(TS.MessageTypes.GOOC.id, text, nil)
end

function meta:TalkToCCARadio( text )

	-- Can't talk when ded
	if not self:Alive() or not self:GetPlayerConscious() then
		return
	end
	
	-- I assume UDP can use broadcast stuff
	-- anyway, use recipient filters
	local rp = RecipientFilter()
	
	for k, v in pairs( player.GetAll() ) do
		if v.Initialized and v.Frequency == 89.64  then
			rp:AddPlayer(v)
		end
	end
	
	self:SendOverlongMessage(TS.MessageTypes.RADIO.id, text, rp)
end

function meta:RadioDis( text )
	-- HURRWT
	if not self:Alive() or not self:GetPlayerConscious() then
		return
	end
	
	local rp = RecipientFilter()
	for k, v in pairs( player.GetAll() ) do
	
		if( v.Initialized and v.Frequency == 89.64 and not v.CharacterMenu ) then
			rp:AddPlayer(v)
		end
	end
	
	self:SendOverlongMessage(TS.MessageTypes.RADIODISPATCH.id, text, rp)
end

function meta:CPDeathDis()
	
	local rp = RecipientFilter()
	for k, v in pairs( player.GetAll() ) do
	
		if( v.Initialized and v.Frequency == 89.64 and not v.CharacterMenu ) then
			rp:AddPlayer(v)
		end
	end

	self:EmitSound( "HL1/fvox/flatline.wav", 100, 100);
	self:EmitSound( "npc/overwatch/radiovoice/lostbiosignalforunit.wav", 100, 100);
	
	self:SendOverlongMessage(TS.MessageTypes.RADIODISPATCH.id, "Vital signs for CCA unit " .. self:GetRPName() .. " have ceased.", rp)
	
end

function meta:SendToRadio(id, text)
	-- didn't I do this already?
	if not self.Initialized or not self:GetPlayerConscious() then
		return
	end
	
	local rp = RecipientFilter()
	
	for k, v in pairs( player.GetAll() ) do
		if( v.Initialized and v.Frequency == self.Frequency ) then
			rp:AddPlayer(v)
		end
	end
	
	self:SendOverlongMessage(id, text, rp)
end

function meta:TalkToRadio(text)
	self:SendToRadio(TS.MessageTypes.RADIO.id, text)
end

function meta:YellToRadio(text)
	self:SendToRadio(TS.MessageTypes.RADIOYELL.id, text)
end

function meta:WhisperToRadio(text)
	self:SendToRadio(TS.MessageTypes.RADIOWHISPER.id, text)
end

function meta:SayGlobalEvent( text )
	self:SendOverlongMessage(TS.MessageTypes.EVENT.id, text, nil)
end

if( not meta.OrigPrintMessage ) then
	meta.OrigPrintMessage = meta.PrintMessage;
end

function meta:PrintMessage( type, msg )

	if( type == 2 ) then
	
		meta.OrigPrintMessage( self, type, msg );
	
	else
		self:SendOverlongMessage(TS.MessageTypes.BLUEMSG.id, msg, self)
	end

end


-- OLM Handling
-- OLM has three part messages:
-- START: tsb; declares the BEGINNING of a message. Contains player id and message id (server)
-- DATA: as many data parts as necessary. Contain the index and the string.
-- END: contain the index and a string.
-- There is ABSOLUTELY NO GUARANTEE that every packet is filled completely
-- or that the first packet is full, etc.
--
-- The protocol was improved. Let's call it OLM 2.0

ChatCache = {}

-- Keep this synced with cl_chat.lua!
-- DO NOT UN-GLOBAL THIS
OLM_BEGINLENGTH = 236
OLM_DATALENGTH = 240
OLM_MAXLENGTH = 710

-- Redirect the olm
function meta:ProcessOLM(index)
	if not ChatCache[index] then
		return
	end
	
	OLM_PlayerSay(self, ChatCache[index].Message)
	ChatCache[index] = nil
end

function BeginOLM(ply, cmd, args)
	local index = ply:EntIndex()
	local msg = table.concat(args, ' ') -- damnit, Zauber, use semicolons! -- what? No.
	
	-- Begin the transmission report
	ChatCache[index] = {}
	ChatCache[index].Message = msg
	ChatCache[index].Receivers = {}
	
	-- wait for data.
	ChatCache[index].Message = msg
	-- Or do we?
	if #msg < OLM_BEGINLENGTH then
		ply:ProcessOLM(index)
	end
end
concommand.Add("tsb", BeginOLM)

-- Data and End are pretty much the same
function HandleOLM(ply, cmd, args)
	local index = ply:EntIndex()
	local msg = table.concat(args, ' ')

	-- WE WON'T GET FOOLED AGAIN
	if not ChatCache[index] then
		return
	end
	
	ChatCache[index].Message = ChatCache[index].Message .. msg
	
	-- although END does a bit differ
	if #msg < OLM_DATALENGTH then
		ply:ProcessOLM(index)
	end	
end
concommand.Add("tsd", HandleOLM)

-- Send them to client(s)
function meta:SendOverlongMessage(id, text, rec)
	SendOverlongMessage(self:EntIndex(), id, text, rec)
end

function SendOverlongMessage(entIndex, id, text, rec)
	-- get our first packet
	local subtext = string.sub(text, 0, OLM_BEGINLENGTH)
	-- cut off text
	text = string.sub(text, #subtext+1)
	
	-- begin transaction
	umsg.Start("tsb", rec)
		umsg.Long(entIndex)
		umsg.Char(id)
		umsg.String(subtext)
	umsg.End()

	if #subtext < OLM_BEGINLENGTH then
		return
	end
	
	while #text >= OLM_DATALENGTH do -- bytes.
		subtext = string.sub(text, 0, OLM_DATALENGTH)
		text = string.sub(text, #subtext+1)
		
		umsg.Start("tsd", rec)
			umsg.Long(entIndex)
			umsg.String(subtext)
		umsg.End()
		
	end
	
	umsg.Start("tsd", rec)
		umsg.Long(entIndex)
		umsg.String(text)
	umsg.End()	
end
