--[[--
	-- Generic Incomplete Gamemode --

	File: cl_inventory.lua
	Purpose: Provides clientside gui for the inventory.
	Created: 18th August 2010 By: _Undefined
	Modified: 21st August 2010 By: Advert
	Assigned to: Advert
--]]--

return -- Uploaded to show progress, code will not run properly.

do -- Could be changed to a global var, but if its changed down it will cause issues.
	local x = 1
	function GM:GenerateInventoryRequestID()
		x = x + 1
		return x
	end
end



-- Request function.
-- Operations should not have many
do -- subfunctions
	local IRT = {} -- Keep track of requests

	function GM:GetInventoryRequestInfo(rID)
		-- returns arguments used when initiating the request
		-- Later on, i will make this function remove old inventory requests
		if IRT[rID] then
			return IRT[rID]
		end
	end

	local function AddIRT(rID, requestType, fCallback, ...)
		local t = {} -- Name some stuff to make it more concice
		t.request = requestType
		t.callback = fCallback
		t.arg = arg
		t.status = ITMS_UN
		IRT[rID] = t
	end

	-- Specific handler functions for usermessages and datastream, and their respective hooks.
	local function umcallbackhandler(um)
		--
		local rID, status = um:ReadShort(), um:ReadShort()
		callbackhandler(rID, status, um)
	end
	usermessage.Hook("InventoryRequest", umcallbackhandler)
	local function dscallbackhandler(h, id, enc, dec)
		--
		local rID, status = dec.rID, dec.status
		callbackhandler(rID, status, dec)
	end
	datastream.Hook("InventoryRequest", dscallbackhandler)

	-- Primary callback function

	local function callbackhandler(rID, status, data)
		-- This function will deal with returned datastream/usermessages,
		-- after the primary function converts the arguments.
		local ifo = GM:GetInventoryReqeuestInfo(rID)
		if not ifo then
			-- wtf dumb server
			return
		end
		local stat, res = pcall(ifo.callback, ifo, rID, status, data)

		local irtd = IRT[rID]
		irtd.status = status
		irtd.cbstatus = stat
		irtd.cbres = res

		if stat == false then
			-- function error'd
		end
	end

	function GM:InventoryRequest(requestType, fCallback, ...)
		local rID = GM:GenerateInventoryRequestID()
		AddIRT(rID, requestType, fCallback, ...) -- Add to log table to enable GetInventoryReqeuestInfo()

		-- Needs moar codes
		return rID
	end
end
