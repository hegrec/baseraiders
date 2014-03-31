local ITEM = items.DefineItem("Generator")
ITEM.Group = "Items"
ITEM.EntityClass = "darkland_generator"
ITEM.Model = "models/props_vehicles/generatortrailer01.mdl"
ITEM.Description = "Go off the grid"
ITEM.Size = {5,5}
ITEM.LookAt = Vector(0,0,35)
ITEM.CamPos = Vector(70,70,50)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end

local ITEM = items.DefineItem("Tiny Money Printer")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_lab/reciever01d.mdl"
ITEM.Description = "Creates Money"
ITEM.MaxMoney = 100
ITEM.Watts = 100
ITEM.MoneyIncrement = 1
ITEM.Size = {2,1}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(10,10,10)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end


local ITEM = items.DefineItem("Small Money Printer")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_lab/reciever01b.mdl"
ITEM.Description = "Creates Money"
ITEM.MaxMoney = 250
ITEM.Watts = 200
ITEM.MoneyIncrement = 2
ITEM.Size = {2,1}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(10,10,10)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end


local ITEM = items.DefineItem("Medium Money Printer")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_lab/reciever01a.mdl"
ITEM.Description = "Creates Money"
ITEM.MaxMoney = 500
ITEM.Watts = 550
ITEM.MoneyIncrement = 5
ITEM.Size = {2,1}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(10,10,10)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end


local ITEM = items.DefineItem("Large Money Printer")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_c17/consolebox01a.mdl"
ITEM.Description = "Creates Money"
ITEM.MaxMoney = 1000
ITEM.Watts = 1000
ITEM.MoneyIncrement = 20
ITEM.Size = {2,1}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(10,10,10)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end