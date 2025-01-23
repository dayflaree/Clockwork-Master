local maps = {
	gm_flatgrass = {
		["nature/snowfloor001a"] = {
			"maps/gm_flatgrass/concrete/concretefloor019a_1792_0_32",
			"maps/gm_flatgrass/concrete/concretefloor028a_1792_0_32",
			"maps/gm_flatgrass/concrete/concretefloor028a_1024_-1024_32",
			"maps/gm_flatgrass/concrete/concretefloor028a_239_0_32",
			"maps/gm_flatgrass/concrete/concretefloor028a_1024_1024_32",
			"nature/grassfloor002a"
		}
	},
	gm_construct = {
		["nature/snowfloor001a"] = {
			"gm_construct/grass",
			"gm_construct/grass-sand",
			"building_template/roof_template001a",
			"maps/gm_construct/concrete/concretefloor019a_872_544_-103",
			"maps/gm_construct/concrete/concretefloor019a_1264_1184_-71",
			"maps/gm_construct/concrete/concretefloor019a_1032_-348_-84",
			"maps/gm_construct/concrete/concretefloor019a_864_-488_-95",
			"maps/gm_construct/concrete/concretefloor019a_1032_-600_-84",
			"maps/gm_construct/concrete/concretefloor028a_-296_-968_-103",
			"maps/gm_construct/concrete/concretefloor028a_864_-488_-95",
			"CONCRETE/CONCRETEFLOOR009A",
			"CONCRETE/CONCRETEFLOOR026A",
			"CONCRETE/CONCRETECEILING001A",
			"maps/gm_construct/concrete/concretefloor028a_-1824_-1504_-103",
			"maps/gm_construct/concrete/concretefloor028a_-2960_-1472_80",
			"maps/gm_construct/concrete/concretefloor028a_-2912_96_208",
			"maps/gm_construct/concrete/concretefloor028a_-3014_4510_104",
			"maps/gm_construct/concrete/concretefloor019a_1240_560_-95",
			"maps/gm_construct/concrete/concretefloor028a_1240_560_-95",
			"maps/gm_construct/concrete/concretefloor028a_1264_1184_-71",
			"maps/gm_construct/concrete/concretefloor028a_1032_-348_-84",
			"maps/gm_construct/concrete/concretefloor028a_1032_-600_-84",
			"maps/gm_construct/concrete/concretefloor028a_-320_-1488_-103",
			"maps/gm_construct/concrete/concretefloor028a_224_32_-103",
			"maps/gm_construct/concrete/concretefloor028a_872_544_-103",
			"maps/gm_construct/concrete/concretefloor028a_928_1644_13",
			"maps/gm_construct/concrete/concretefloor028a_912_4160_13",
			"nature/blendsandgrass008a"
		}
	},
	gm_bigcity = {
		["nature/snowfloor001a"] = {
			"building_template/concretefloor033az",
			"building_template/concretefloor033kz",
			"building_template/concretefloor033cz",
			"building_template/concretefloor033yz",
			"building_template/concretefloor033bz",
			"building_template/concretefloor028cz",
			"building_template/concretefloor028dz",
			"props/tarpaperroof002a",
			"de_cbble/grassfloor01",
			"maps/gm_bigcity67d3/stone/stonefloor006a_-7808_-5952_-10816",
			"maps/gm_bigcity67d3/cs_assault/pavement001a_-7808_-5952_-10816",
			"maps/gm_bigcity67d3/cs_assault/pavement001_-7808_-5952_-10816",
			"de_train/train_cementwear_01",
			"de_train/train_cement_floor_01",
			"concrete/concretewall064a",
			"concrete/concretewall064c",
			"nature/blendtoxictoxic004a",
			"concrete/concretefloor027a",
			"maps/gm_bigcity67d3/stone/stonefloor006a_-7808_-5952_-10816",
			"concrete/concretefloor023a",
			"concrete/concretefloor001a",
			"building_template/metalroof005az",
			"maps/gm_bigcity67d3/stone/stonefloor006b_-7808_-5952_-10816",
			"maps/gm_bigcity67d3/tile/tileroof004a_-7808_-5952_-10816",
			"building_template/metalroof006az",
			"building_template/concretefloor028cz",
			"nature/blendtoxictoxic002a"










		}
	}
}

for map, replacements in pairs(maps) do
	if map == game.GetMap() then
		MsgN("Replacing textures on " .. map)
		
		for rep, t_orig in pairs(replacements) do
			local s = Material(rep)
			for _, o in pairs(t_orig) do
				local m = Material(o)
				m:SetMaterialTexture("$basetexture", s:GetMaterialTexture("$basetexture"))
			end
		end
	end
end

local t = {}

concommand.Add("get_replacement", function(ply, cmd, args)
	local tex = ply:GetEyeTrace().HitTexture
	MsgN(tex)
	table.insert(t, tex)
end)

concommand.Add("output_replacement", function(ply, cmd, args)
	MsgN('\t\t["' .. "nature/snowfloor001a" .. '"]')
	for _, v in pairs(t) do
		MsgN('\t\t\t' .. v)
	end
end)