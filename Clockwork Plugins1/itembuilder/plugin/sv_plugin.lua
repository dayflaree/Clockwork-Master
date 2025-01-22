local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

-- A function to save the items.
function PLUGIN:SaveCustomItems()
	Clockwork.kernel:SaveClockworkData("customitems", self.customItems);
end;

function PLUGIN:CreateItem(data)
	local ITEM;
	local regItem = {};
	local itemCheck = Clockwork.item:FindByID(data.name);
	if (itemCheck) then
		if (!itemCheck.customnumber) then
			return false
		else
			ITEM = itemCheck;
			print("[IB] '"..ITEM.name.."' edited...")
			
			ITEM.name = data.name;
			ITEM.cost = tonumber(data.cost);
			ITEM.model = data.model;
			ITEM.weight = tonumber(data.weight);
			ITEM.access = data.access;
			ITEM.useText = data.useText;
			ITEM.category = data.category;
			ITEM.description = data.description;
			ITEM.customnumber = data.customnumber;

			regItem.name = ITEM.name;
			regItem.cost = ITEM.cost;
			regItem.model = ITEM.model;
			regItem.weight = ITEM.weight;
			regItem.access = ITEM.access;
			regItem.useText = ITEM.useText;
			regItem.category = ITEM.category;
			regItem.description = ITEM.description;
			regItem.customnumber = ITEM.customnumber;

			self.customItems[regItem.customnumber] = regItem;		
		end;
	else
		ITEM = Clockwork.item:New();
			
		ITEM.name = data.name;
		ITEM.cost = tonumber(data.cost);
		ITEM.model = data.model;
		ITEM.weight = tonumber(data.weight);
		ITEM.access = data.access;
		ITEM.useText = data.useText;
		ITEM.category = data.category;
		ITEM.description = data.description;
		ITEM.customnumber = data.customnumber or (#self.customItems + 1);
		
		function ITEM:OnDrop(player, position) end;		
		
		Clockwork.item:Register(ITEM)
		
		regItem.name = ITEM.name;
		regItem.cost = ITEM.cost;
		regItem.model = ITEM.model;
		regItem.weight = ITEM.weight;
		regItem.access = ITEM.access;
		regItem.useText = ITEM.useText;
		regItem.category = ITEM.category;
		regItem.description = ITEM.description;
		regItem.customnumber = ITEM.customnumber;

		self.customItems[regItem.customnumber] = regItem;
		print("[IB] '"..ITEM.name.."' loaded...")
	end;
	
	for k, v in ipairs(player.GetAll()) do
		Clockwork.datastream:Start(v, "RegisterItem", regItem);
	end;
end;

function PLUGIN:RemoveItem(data)
	self.customItems[data.customnumber] = nil;
	print("[IB] '"..data.name.."' will be unloaded next restart!")
end;

Clockwork.datastream:Hook("RemoveItem", function(player, data)
	PLUGIN:RemoveItem(data)
end);

Clockwork.datastream:Hook("CreateItem", function(player, data)
	PLUGIN:CreateItem(data)
end);

-- A function to load the items.
function PLUGIN:LoadCustomItems()
	if (SERVER) then
		self.customItems = Clockwork.kernel:RestoreClockworkData("customitems");
		
		if (!self.customItems) then
			self.customItems = {};
			print("[IB] No items to load!")
		else
			for k, v in ipairs(self.customItems) do
				local ITEM = Clockwork.item:New();
				data = self.customItems[k];
				
				ITEM.name = data.name;
				ITEM.cost = tonumber(data.cost);
				ITEM.model = data.model;
				ITEM.weight = tonumber(data.weight);
				ITEM.access = data.access
				ITEM.useText = data.useText;
				ITEM.category = data.category;
				ITEM.description = data.description;
				ITEM.customnumber = data.customnumber;
				
				-- Called when a player drops the item.
				function ITEM:OnDrop(player, position) end;

				Clockwork.item:Register(ITEM)
				print("[IB] '"..ITEM.name.."' loaded...")
			end;
		end;		
	end;			
end;