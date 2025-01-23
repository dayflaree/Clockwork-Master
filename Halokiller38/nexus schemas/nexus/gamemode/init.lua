--[[
Name: "init.lua".
Product: "Nexus".
--]]

require("gamedescription");
require("sourcenet");
require("tmysql");
require("json");
require("glon");

include("core/sv_auto.lua"); 

AddCSLuaFile("cl_init.lua");