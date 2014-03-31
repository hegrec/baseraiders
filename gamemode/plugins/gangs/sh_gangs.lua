GANG_CREATION_COST = 10000


territories = {}
territories[1] = {
	Name = "Power Plant",
	HubSpawns = "Wood",
	Min = Vector(6053.164063, 5098.930664, -177.968750),
	Max = Vector(6455.944824, 6039.595703, -50.031250),
	MinFurnace = Vector(5924.120605, 5098.976563, -177.968750),
	MaxFurnace = Vector(6455.641602, 5291.199219, -50.031250)
}

territories[2] = {
	Name = "Oil Factory",
	HubSpawns = "Crude Oil",
	Min = Vector(-1486.823730, 6649.146973, -182.968750),
	Max = Vector(-707.747131, 7427.968750, 24.850937)
}
territories[3] = {
	Name = "Silicon Factory",
	HubSpawns = "Silicon",
	Min = Vector(-4770.882813, 588.223083, -2.031250),
	Max = Vector(-5280.166504, 89.927063, -191.968750)
}
territories[4] = {
	Name = "Metal Factory",
	HubSpawns = "Metal",
	Min = Vector(6180.249023, -2999.526367, -199.968750),
	Max = Vector(6689.968750, -2442.475342, 54.833847)
}





local ITEM = items.DefineItem("Gang Hub")
ITEM.Group = "Gang Stuff"
ITEM.EntityClass = "gang_hub"
ITEM.Model = "models/props_wasteland/gaspump001a.mdl"
ITEM.Description = "Raw material for making other materials"
ITEM.Size = {2,3}
ITEM.LookAt = Vector(0,0,20)
ITEM.CamPos = Vector(40,40,40)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Plant Hub",function() RunConsoleCommand("plant_hub") end)
end