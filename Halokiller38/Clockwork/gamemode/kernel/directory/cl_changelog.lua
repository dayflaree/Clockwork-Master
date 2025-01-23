--[[
	Free Clockwork!
--]]

local REMOVED = "http://script.cloudsixteen.com/icons/removed.gif";
local FIXED = "http://script.cloudsixteen.com/icons/fixed.gif";
local ADDED = "http://script.cloudsixteen.com/icons/added.gif";
local TIP = "http://script.cloudsixteen.com/icons/tip.gif";

local changelog = "";

local function AddVersion(version, changes)
	local explodedChanges = string.Explode("\n", changes);
	local tblChanges = {};
	
	for k, v in ipairs(explodedChanges) do
		local tblValue = string.Explode("|", (string.gsub(v, "\t", "")));
		
		if (tblValue[1] and tblValue[2]) then
			if (tblValue[1] == "A") then
				tblValue[1] = ADDED;
			elseif (tblValue[1] == "F") then
				tblValue[1] = FIXED;
			elseif (tblValue[1] == "R") then
				tblValue[1] = REMOVED;
			elseif (tblValue[1] == "T") then
				tblValue[1] = TIP;
			end;
			
			tblChanges[#tblChanges + 1] = tblValue;
		end;
	end;
	
	changelog = changelog..[[
		<div class="cwInfoTitle">]]..version..[[</div>
	]];
	
	for k, v in ipairs(tblChanges) do
		local text = v[2];
		local icon = v[1];
		
		changelog = changelog..[[
			<div class="cwInfoText">
				<img src="]]..icon..[[" style="vertical-align:text-bottom;"/>
				]]..text..[[
			</div>
		]];
	end;
end;

AddVersion("1.0", [[
	T|Began work on Clockwork, and added Linux support.
]]);

//Clockwork.directory:AddCategoryPage("Changelog", nil, changelog); because it's useless