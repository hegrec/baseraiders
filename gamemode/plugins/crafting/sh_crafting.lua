
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


local ITEM = items.DefineItem("Sand")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/hunter/blocks/cube025x025x025.mdl"
ITEM.Description = "Raw material dug from the ground."
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Glass")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_phx/construct/glass/glass_angle90.mdl"
ITEM.Description = "Smelted from sand to use as a component"
ITEM.Size = {1,1}
ITEM.Smeltable = {"Sand",5}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Silicon")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/hunter/blocks/cube025x025x025.mdl"
ITEM.Description = "Smelted from sand to use as a component"
ITEM.Size = {1,1}
ITEM.Smeltable = {"Sand",10}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Wood")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/baseraiders/log.mdl"
ITEM.Description = "Freshly gathered, dry wood. Can be used to built a fire."
ITEM.Size = {2,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,20,16)
ITEM.Angle = Angle(90,0,0)
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Create Fire",function() RunConsoleCommand("make_fire") end)
end
local ITEM = items.DefineItem("Smelting Furnace")
ITEM.Group = "Tools"
ITEM.EntityClass = "smelting_furnace"
ITEM.Model = "models/props_wasteland/kitchen_counter001b.mdl"
ITEM.Description = "Smelt items in your base with this"
ITEM.Size = {4,2}
ITEM.Craftable = {"Metal",5,"Brick",5}
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(10,70,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Wood Crafting Table")
ITEM.Group = "Tools"
ITEM.EntityClass = "crafting_table"
ITEM.Model = "models/props/cs_militia/table_shed.mdl"
ITEM.Description = "Craft items in your base with this"
ITEM.Size = {4,2}
ITEM.Craftable = {"Wood",15}
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(100,0,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Oil Rig")
ITEM.Group = "Extraction"
ITEM.EntityClass = "oil_rig"
ITEM.Model = "models/props_combine/combinethumper001a.mdl"
ITEM.Description = "Can extract oil to use"
ITEM.Size = {2,5}
ITEM.Craftable = {"Mechanical Parts",10,"Hydraulics",1,"Circuit Board",1}
ITEM.LookAt = Vector(0,0,160)
ITEM.CamPos = Vector(130,130,140)
ITEM.CanHold = true


local ITEM = items.DefineItem("Crude Oil")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/oildrum001.mdl"
ITEM.Description = "Raw material used with a lot of items"
ITEM.Size = {1,2}
ITEM.LookAt = Vector(0,0,24)
ITEM.CamPos = Vector(21,21,24)
ITEM.CanHold = true

local ITEM = items.DefineItem("Gasoline")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/gascan001a.mdl"
ITEM.Description = "A canister of refined gasoline."
ITEM.LookAt = Vector(0,0,3)
ITEM.Smeltable = {"Crude Oil",5}
ITEM.CamPos = Vector(12,12,16)
ITEM.Size = {1,1}
ITEM.CanHold = true

local ITEM = items.DefineItem("Charcoal")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Broken down wood"
ITEM.Smeltable = {"Wood",3}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.Size = {1,1}
ITEM.CanHold = true

local ITEM = items.DefineItem("Gunpowder")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/items/ar2_grenade.mdl"
ITEM.Description = "A canister of refined gasoline."
ITEM.LookAt = Vector(0,0,0)
ITEM.Smeltable = {"Charcoal",1,"Ore",1}
ITEM.CamPos = Vector(0,10,0)
ITEM.Size = {1,1}
ITEM.CanHold = true

local ITEM = items.DefineItem("Hydraulics")
ITEM.Group = "Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/mechanics/robotics/h2.mdl"
ITEM.Description = "Smelt items in your base with this"
ITEM.Size = {1,3}
ITEM.Craftable = {"Water",5,"Mechanical Parts",1}
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(0,0,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Ore")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Picked from rocks, used for making items."
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Clay")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Muddy mess to make pottery"
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Brick")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/de_inferno/cinderblock.mdl"
ITEM.Description = "Muddy mess to make pottery"
ITEM.Craftable = {"Clay",3}
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Metal")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/mechanics/solid_steel/i_beam_4.mdl"
ITEM.Description = "Sturdy I-Beams...part of a complete breakfast"
ITEM.Smeltable = {"Ore",5}
ITEM.Size = {2,1}
ITEM.LookAt = Vector(5,0,0)
ITEM.CamPos = Vector(20,30,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Mechanical Parts")
ITEM.Group = "Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_pipes/valve001.mdl"
ITEM.Description = "Refined metallic parts for producing items"
ITEM.Smeltable = {"Metal",3,"Ore",5}
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,40)
ITEM.CanHold = true
local ITEM = items.DefineItem("Circuit Board")
ITEM.Group = "Electronics"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/cs_office/computer_caseb_p2a.mdl"
ITEM.Description = "Used for technological advancement"
ITEM.Craftable = {"Silicon",5,"Metal",1}
ITEM.Size = {1,2}
ITEM.LookAt = Vector(-7,0,0)
ITEM.CamPos = Vector(-7,0,12.5)
ITEM.CanHold = true

local ITEM = items.DefineItem("Advanced Electronics")
ITEM.Group = "Electronics"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/cs_office/computer_caseb_p7a.mdl"
ITEM.Description = "Adding some smarts to your crafting"
ITEM.Size = {2,2}
ITEM.LookAt = Vector(-5,0,9)
ITEM.CamPos = Vector(-5,17,9)
ITEM.CanHold = true


local ITEM = items.DefineItem("Weapon Sights")
ITEM.Group = "Weapon Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/items/combine_rifle_cartridge01.mdl"
ITEM.Description = "Because we can all use some help when aiming a shot."
ITEM.Craftable = {"Metal",3,"Mechanical Parts",2}
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,10,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Weapon Barrel")
ITEM.Group = "Weapon Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_lab/pipesystem03b.mdl"
ITEM.Description = "A chamber for the gunpowder to expand"
ITEM.Craftable = {"Metal",5,"Mechanical Parts",1}
ITEM.Size = {2,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Weapon Stock")
ITEM.Group = "Weapon Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/mechanics/solid_steel/i_beam_4.mdl"
ITEM.Description = "A weapon mounting stock"
ITEM.Craftable = {"Metal",1,"Wood",5}
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Weapon Body")
ITEM.Group = "Weapon Parts"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/gibs/metal_gib5.mdl"
ITEM.Description = "A body part for a weapon"
ITEM.Craftable = {"Metal",5,"Mechanical Parts",5}
ITEM.Size = {1,1}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Hatchet")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_stone_hatchet.mdl"
ITEM.Description = "Helps gather wood"
ITEM.Size = {1,2}
ITEM.Craftable = {"Metal",2,"Wood",2}
ITEM.LookAt = Vector(0,0,7)
ITEM.Angle = Angle(0,30,90)
ITEM.CamPos = Vector(10,10,7)
ITEM.CanHold = true

ITEM.SWEPClass = "axe"

local ITEM = items.DefineItem("Pickaxe")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_stone_pickaxe.mdl"
ITEM.Description = "Allows you to gather ores."
ITEM.Size = {1,2}
ITEM.Craftable = {"Metal",3,"Wood",1}
ITEM.LookAt = Vector(0,0,5)
ITEM.Angle = Angle(-90,50,50)
ITEM.CamPos = Vector(7,7,5)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "pick"

local ITEM = items.DefineItem("Shovel")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Angle = Angle(0,0,90)
ITEM.Model = "models/weapons/w_shovel.mdl"
ITEM.Description = "Helps gather stuff from the ground."
ITEM.Size = {1,2}
ITEM.Craftable = {"Metal",1,"Wood",3}
ITEM.LookAt = Vector(0,0,15)
ITEM.Angle = Angle(0,30,90)
ITEM.CamPos = Vector(15,15,15)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "shovel"