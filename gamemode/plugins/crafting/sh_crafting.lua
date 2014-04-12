
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
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true


local ITEM = items.DefineItem("Silicon")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/hunter/blocks/cube025x025x025.mdl"
ITEM.Description = "Smelted from sand to use as a component"
ITEM.Size = {1,1}
ITEM.Smeltable = {"Sand",5}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Plastic")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_phx/construct/plastic/plastic_panel1x1.mdl"
ITEM.Description = "Smelted from crude oil to make things"
ITEM.Size = {1,1}
ITEM.Smeltable = {"Crude Oil",5}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,60)
ITEM.CanHold = true



local ITEM = items.DefineItem("Wood")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/baseraiders/log.mdl"
ITEM.Description = "Freshly gathered, dry wood. Can be used to built a fire."
ITEM.Size = {2,1}
ITEM.CanHeal = true
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
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "smelting_furnace"
ITEM.Model = "models/props_wasteland/kitchen_counter001b.mdl"
ITEM.Description = "Smelt items in your base with this"
ITEM.Size = {4,2}
ITEM.CanHeal = true
ITEM.Craftable = {"Metal",20}
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(10,70,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Wood Crafting Table")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "crafting_table"
ITEM.Model = "models/props/cs_militia/wood_table.mdl"
ITEM.Description = "Craft items in your base with this"
ITEM.Size = {4,2}
ITEM.CanHeal = true
ITEM.Craftable = {"Wood",20}
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(10,70,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Metal Crafting Table")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "crafting_table"
ITEM.Model = "models/props_wasteland/controlroom_desk001b.mdl"
ITEM.Description = "Craft items in your base with this"
ITEM.Size = {4,2}
ITEM.CanHeal = true
ITEM.Craftable = {"Metal",20}
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(90,10,20)
ITEM.Angle = Angle(0,0,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Oil Rig")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "oil_rig"
ITEM.Model = "models/props_combine/combinethumper001a.mdl"
ITEM.Description = "Can extract oil to use"
ITEM.Size = {2,5}
ITEM.Craftable = {"Crude Oil",5,"Circuit Board",5,"Metal Casing",5}
ITEM.CanHeal = true
ITEM.LookAt = Vector(0,0,160)
ITEM.CamPos = Vector(130,130,140)
ITEM.CanHold = true


local ITEM = items.DefineItem("Crude Oil")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/oildrum001.mdl"
ITEM.Description = "Raw material used with a lot of "
ITEM.Size = {1,2}
ITEM.CanHeal = true
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



local ITEM = items.DefineItem("Ore")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Picked from rocks, used for making items."
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Clay")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Description = "Muddy mess to make pottery"
ITEM.Size = {1,1}
ITEM.CanHeal = true
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
ITEM.CanHeal = true
ITEM.LookAt = Vector(5,0,0)
ITEM.CamPos = Vector(20,30,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Metal Plating")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_phx/construct/metal_plate1.mdl"
ITEM.Description = "Metal protection from the elements"
ITEM.Smeltable = {"Metal",3,"Ore",5}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,40)
ITEM.CanHold = true

local ITEM = items.DefineItem("Metal Casing")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/cs_office/computer_caseb_p1a.mdl"
ITEM.Description = "Used for technological advancement"
ITEM.Smeltable = {"Metal Plating",2}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = Vector(0,0,15)
ITEM.CamPos = Vector(0,20,20)
ITEM.CanHold = true

local ITEM = items.DefineItem("Circuit Board")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/cs_office/computer_caseb_p7a.mdl"
ITEM.Description = "Used for technological advancement"
ITEM.Smeltable = {"Silicon",5,"Plastic",5}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = Vector(-2,0,5)
ITEM.CamPos = Vector(-2,11,5)
ITEM.CanHold = true

local ITEM = items.DefineItem("Sensor Module")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/gibs/gunship_gibs_sensorarray.mdl"
ITEM.Description = "Adding some smarts to your crafting"
ITEM.Smeltable = {"Circuit Board",4}
ITEM.Size = {2,2}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(12,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Spring")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/trappropeller_lever.mdl"
ITEM.Description = "Hooke's law rules this one"
ITEM.Craftable = {"Metal",3}
ITEM.Size = {2,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,12)
ITEM.CanHold = true

local ITEM = items.DefineItem("Weapon Sights")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/items/combine_rifle_cartridge01.mdl"
ITEM.Description = "Because we can all use some help when aiming a shot."
ITEM.Craftable = {"Metal",3}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,10,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Weapon Barrel")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_lab/pipesystem03b.mdl"
ITEM.Description = "A chamber for the gunpowder to expand"
ITEM.Craftable = {"Metal Casing",3}
ITEM.Size = {2,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Wood Weapon Stock")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/mechanics/solid_steel/i_beam_4.mdl"
ITEM.Description = "A wooden based weapon mounting stock"
ITEM.Craftable = {"Wood",5,"Metal Plating",2}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.CanHold = true

local ITEM = items.DefineItem("Metal Weapon Stock")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/gibs/metal_gib5.mdl"
ITEM.Description = "A metal based weapon mounting stock"
ITEM.Craftable = {"Metal Plating",5}
ITEM.Size = {2,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,-12)
ITEM.CanHold = true

local ITEM = items.DefineItem("Spring Action Reloader")
ITEM.Group = "Raw Materials"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/gibs/manhack_gib03.mdl"
ITEM.Description = "Auto firing makes things easier"
ITEM.Craftable = {"Spring",5}
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,-10,0)
ITEM.CanHold = true

local ITEM = items.DefineItem("Hatchet")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_stone_hatchet.mdl"
ITEM.Description = "Helps gather wood"
ITEM.Size = {1,2}
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
ITEM.LookAt = Vector(0,0,15)
ITEM.Angle = Angle(0,30,90)
ITEM.CamPos = Vector(15,15,15)
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "shovel"