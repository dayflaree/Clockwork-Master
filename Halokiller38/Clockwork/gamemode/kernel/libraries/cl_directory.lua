--[[
	Free Clockwork!
--]]

Clockwork.directory = Clockwork:NewLibrary("Directory");
Clockwork.directory.tips = {};
Clockwork.directory.stored = {};
Clockwork.directory.sorting = {};
Clockwork.directory.formatting = {};
Clockwork.directory.friendlyNames = {};
Clockwork.directory.masterFormatting = [[
	<style type="text/css">
		body {
			background-image: url(http://script.cloudsixteen.com/bg.png);
			font-family: Arial;
		}
		
		.cwBackground {
			background-color: #83ADC4;
		}
		
		.cwInfoTitle {
			font-family: "Myriad Pro", "Lucida Grande", "Lucida Sans Unicode", Arial;
			background: #FFFFFF;
			font-weight: bold;
			border-bottom: 1px #555555 solid;
			font-size: 16px;
			color: #555555;
		}
		
		.cwInfoTip {
			background: #CFECFF;
			font-size: 12px;
			color: #666666;
		}
		
		.cwInfoText {
			font-weight: bold;
			font-size: 12px;
			padding: 2px;
			color: #FFFFFF;
		}
		
		.cwHeader {
			background: #FFFFFF;
			border-bottom: 1px #555555 solid;
			border-top: 2px #555555 solid;
			font-family: "Myriad Pro", "Lucida Grande", "Lucida Sans Unicode", Arial;
			font-weight: bold;
			font-size: 32px;
			color: #555555;
		}
		
		.cwTitle {
			font-family: "Myriad Pro", "Lucida Grande", "Lucida Sans Unicode", Arial;
			font-weight: bold;
			font-size: 16px;
			color: #FFFFFF;
		}
		
		.cwContent {
			background:#83ADC4;
			border-top: 2px #555555 solid;
			padding: 2px;
			color: #FFFFFF;
		}
	</style>
	
	<div class="cwHeader">
		{category}
	</div><br>
	
	<div class="cwContent">
		{information}
	</div>
]];

--[[ 
	A good idea for the master formatting, is to ensure the existance of default CSS classes.
	You can still customize them for use, though.
--]]

-- A function to get a category.
function Clockwork.directory:GetCategory(category)
	for k, v in pairs(self.stored) do
		if (v.category == category) then
			return v, k;
		end;
	end;
end;

-- A function to set a category tip.
function Clockwork.directory:SetCategoryTip(category, tip)
	self.tips[category] = tip;
end;

-- A function to get a category tip.
function Clockwork.directory:GetCategoryTip(category)
	return self.tips[category];
end;

-- A function to add a category page.
function Clockwork.directory:AddCategoryPage(category, parent, htmlCode, isWebsite)
	self:AddCategory(category, parent);
	self:AddPage(category, htmlCode, isWebsite);
end;

-- A function to set a friendly name.
function Clockwork.directory:SetFriendlyName(category, name)
	self.friendlyNames[category] = name;
end;

-- A function to get a friendly name.
function Clockwork.directory:GetFriendlyName(category)
	return self.friendlyNames[category] or category;
end;

-- A function to set the master formatting.
function Clockwork.directory:SetMasterFormatting(htmlCode)
	self.masterFormatting = htmlCode;
end;

-- A function to get the master formatting.
function Clockwork.directory:GetMasterFormatting()
	return self.masterFormatting;
end;

-- A function to set category formatting.
function Clockwork.directory:SetCategoryFormatting(category, htmlCode, noLineBreaks, noMasterFormatting)
	self.formatting[category] = {
		noMasterFormatting = noMasterFormatting,
		noLineBreaks = noLineBreaks,
		htmlCode = htmlCode
	};
end;

-- A function to get category formatting.
function Clockwork.directory:GetCategoryFormatting(category)
	return self.formatting[category];
end;

-- A function to set category sorting.
function Clockwork.directory:SetCategorySorting(category, Callback)
	self.sorting[category] = Callback;
end;

-- A function to get category sorting.
function Clockwork.directory:GetCategorySorting(category)
	return self.sorting[category];
end;

-- A function to get whether a category exists.
function Clockwork.directory:CategoryExists(category)
	for k, v in pairs(self.stored) do
		if (v.category == category) then
			return true;
		end;
	end;
end;

-- A function to add a category.
function Clockwork.directory:AddCategory(category, parent)
	if (parent) then
		self:AddCategory(parent, false);
	end;
	
	if (!self:CategoryExists(category)) then
		if (parent == false) then parent = nil; end;
		
		self.stored[#self.stored + 1] = {
			category = category,
			pageData = {},
			parent = parent
		};
	elseif (parent != false) then
		for k, v in pairs(self.stored) do
			if (v.category == category) then
				v.parent = parent;
			end;
		end;
	end;
	
	return category, parent;
end;

-- A function to add some code.
function Clockwork.directory:AddCode(category, htmlCode, noLineBreak, sortData, Callback)
	self:AddCategory(category, false);
	
	local categoryTable = self:GetCategory(category);
	local uniqueID = nil;
	local panel = self:GetPanel();
	
	if (categoryTable) then
		categoryTable.pageData[#categoryTable.pageData + 1] = {
			noLineBreak = noLineBreak,
			sortData = sortData,
			Callback = Callback,
			htmlCode = htmlCode
		};
		
		uniqueID = #categoryTable.pageData;
	end;
	
	if (panel) then
		panel:Rebuild();
	end;
	
	return uniqueID;
end;

-- A function to remove some code.
function Clockwork.directory:RemoveCode(category, uniqueID, forceRemove)
	local panel = self:GetPanel();
	
	if (category) then
		local categoryTable, categoryKey = self:GetCategory(category);
		
		if (categoryTable) then
			if (uniqueID and !categoryTable.isHTML) then
				if (categoryTable.pageData[uniqueID]) then
					categoryTable.pageData[uniqueID] = nil;
				end;
				
				if (#categoryTable.pageData == 0) then
					self:RemoveCode(category);
				end;
			else
				local removeCategory = true;
				
				if (!forceRemove and !categoryTable.isHTML) then
					for k, v in pairs(self.stored) do
						if (v.parent == category) then
							removeCategory = true;
							
							break;
						end;
					end;
				end;
				
				if (removeCategory) then
					self.stored[categoryKey] = nil;
				end;
			end;
		end;
	end;
	
	if (panel) then
		panel:Rebuild();
	end;
end;

-- A function to add a page.
function Clockwork.directory:AddPage(category, htmlCode, isWebsite)
	self:AddCategory(category, false);
	
	local categoryTable = self:GetCategory(category);
	local panel = self:GetPanel();
	
	if (categoryTable) then
		categoryTable.isWebsite = isWebsite;
		categoryTable.pageData = htmlCode;
		categoryTable.isHTML = true;
	end;
	
	if (panel) then
		panel:Rebuild();
	end;
end;

-- A function to get the directory panel.
function Clockwork.directory:GetPanel()
	return self.panel;
end;

Clockwork.directory:SetCategorySorting("Commands", function(a, b)
	return (a.sortData or a.htmlCode) < (b.sortData or b.htmlCode);
end);

Clockwork.directory:SetCategorySorting("Plugins", function(a, b)
	return (a.sortData or a.htmlCode) < (b.sortData or b.htmlCode);
end);

Clockwork.directory:SetCategorySorting("Flags", function(a, b)
	local hasA = Clockwork.player:HasFlags(Clockwork.Client, a.sortData);
	local hasB = Clockwork.player:HasFlags(Clockwork.Client, b.sortData);
	
	if (hasA and hasB) then
		return a.sortData < b.sortData;
	elseif (hasA) then
		return true;
	else
		return false;
	end;
end);

Clockwork.directory:SetCategoryFormatting("Flags", [[
	<style type="text/css">
		.cwTable
		{
			width: 100%;
		}

		.cwHeader
		{
			background-color: #FFF;
			font-size: 12px;
			padding: 2px;
			margin: 0;
			width: 50%;
		}
	</style>
	
	<table class="cwTable">
		<tr>
			<td class="cwBackground cloudHeader">
				<span class="cwTitle">FLAG</span>
			</td>
			<td class="cwBackground cloudHeader">
				<span class="cwTitle">DETAILS</span>
			</td>
		</tr>
		{information}
	</table>
]], true);

Clockwork.directory:SetCategoryTip("Clockwork", "Contains topics based on the Clockwork framework.");
Clockwork.directory:SetCategoryTip("Commands", "Contains a list of commands and their syntax.");

Clockwork.directory:AddCategoryPage("Changelog", nil, "http://mfwhen.com/changelog", true);
//Clockwork.directory:AddCategoryPage("Credits", "Clockwork", "http://script.cloudsixteen.com/credits/", true); because it's broken...
Clockwork.directory:AddCategory("Plugins", "Clockwork");
Clockwork.directory:AddCategory("Flags", "Clockwork");