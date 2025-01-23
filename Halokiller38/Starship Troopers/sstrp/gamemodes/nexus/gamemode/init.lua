--[[
Name: "init.lua".
Product: "Nexus".
--]]

require("sourcenet");
require("tmysql");
require("json");
require("glon");

include("core/sv_auto.lua"); 

AddCSLuaFile("cl_init.lua");