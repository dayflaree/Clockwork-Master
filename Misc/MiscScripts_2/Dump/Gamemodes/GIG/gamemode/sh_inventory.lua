--[[--
	-- Generic Incomplete Gamemode --

	File: cl_inventory.lua
	Purpose: Provides clientside gui for the inventory.
	Created: 21th August 2010 By: Advert
	Modified: 21st August 2010 By: Advert
	Assigned to: Advert
--]]--
return -- not working
do -- Constants

	-- Note: Very much inconclusive as of now.

	-- Request Type
	ITM_SWAP = 1
	ITM_DROP = 2
	ITM_PICKUP = 3
	ITM_USE = 4
	ITM_CRAFT = 5
	-- Admin only:
	ITMA_CREATE = 100
	ITMA_CLEAN  = 101 -- clean player's inventory

	-- Callbacks
	ITMS_UN = 0 -- Unprocessed
	ITMs_OK = 1 -- OK
	ITMF_WAT = 2 -- Client fault: Wrong arguments, etc.
	ITMF_ACC = 3 -- Access denied
	ITMF_ADM = 4 -- Administrative reasons
	ITMF_UNK = 5 -- Unknown
	ITMF_RNS = 6 -- Reason Not Specified
	ITMF_AREA = 7 -- Cannot do that in this area
	ITMF_QUF = 8 -- Queue full
end




-- Shared file done loading, do specific file
include((SERVER and "sv" or "cl") .. "_inventory.lua")
