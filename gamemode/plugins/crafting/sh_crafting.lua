
Dialog["Craftmaster Flex"] = {}
Dialog["Craftmaster Flex"][1] = {
	Text 		= "Hello sir, do you need some starter tools?",
	Replies 	= {1,2}
}
Dialog["Craftmaster Flex"][2] = {
	Text 		= "Have a good day sir",
	Replies 	= {5}
}



Replies["Craftmaster Flex"] = {}
Replies["Craftmaster Flex"][1] = {
	Text		= "Yes",
	OnUse		= function(pl) crafting.GiveStarterTools(pl) end
}
Replies["Craftmaster Flex"][2] = {
	Text		= "No thanks",
	OnUse		= function(pl) return 2 end
}

Replies["Craftmaster Flex"][5] = {
	Text		= "See you later",
	OnUse		= function(pl) return nil end
}


local ITEM = items.DefineItem("Sandblock")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/hunter/blocks/cube025x025x025.mdl"
ITEM.Description = "Raw material for making other materials"
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true



local ITEM = items.DefineItem("Wood")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/de_inferno/wood_fence_end.mdl"
ITEM.Description = "Freshly gathered, dry wood. Can be used to built a fire."
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Create Fire",function() RunConsoleCommand("make_fire") end)
end


local ITEM = items.DefineItem("Crude Oil")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/oildrum001.mdl"
ITEM.Description = "Raw materials used for crafting more refined fuel sources."
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Gasolinel")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/oildrum001.mdl"
ITEM.Description = "A cannister of refined gasoline."
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true



local ITEM = items.DefineItem("Ore")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Raw materials used for crafting"
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Scrap Metal")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_debris/metal_panel02a.mdl"
ITEM.Description = "Raw materials used for crafting"
ITEM.Smeltable = {"Ore",5}
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Hatchet")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_stone_hatchet.mdl"
ITEM.Description = "Helps gather wood"
ITEM.Weight = 0.8
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "axe"

local ITEM = items.DefineItem("pickaxe")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_stone_pickaxe.mdl"
ITEM.Description = "Allows you to gather ores at a greater pace."
ITEM.Weight = 0.8
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "pick"

local ITEM = items.DefineItem("Shovel")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_shovel.mdl"
ITEM.Description = "Helps gather stuff from the ground."
ITEM.Weight = 0.8
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "shovel"