WOOD_BOOST = 500
MAX_WOOD_BOOST = 5
BASE_POWER = 2000

power = {}
function power.GetCityMaxPower()
	return BASE_POWER+GetGlobalInt("PowerBoost")
end
function power.GetCityPowerLeft()
	return power.GetCityMaxPower()-GetGlobalInt("PowerUsed")
end
function power.GetCityPowerUsed()
	return GetGlobalInt("PowerUsed")
end


local ITEM = items.DefineItem("Generator")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_generator"
ITEM.Model = "models/props_vehicles/generatortrailer01.mdl"
ITEM.Description = "Go off the grid"
ITEM.Size = {5,5}
ITEM.Craftable = {"Mechanical Parts",10,"Circuit Board",5,"Gasoline",5}
ITEM.LookAt = Vector(-20,0,35)
ITEM.CamPos = Vector(-20,100,50)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	draw.SimpleTextOutlined(ent:GetGallons().." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end

local ITEM = items.DefineItem("Money Printer")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_c17/consolebox01a.mdl"
ITEM.Description = "Creates counterfeit money to use in game"
ITEM.MaxMoney = 500
ITEM.Watts = 550
ITEM.MoneyIncrement = 5
ITEM.Craftable = {"Mechanical Parts",5,"Circuit Board",5,"Advanced Electronics",1}
ITEM.Size = {3,2}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(30,30,15)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end

local ITEM = items.DefineItem("Money Press")
ITEM.Group = "Money Printers"
ITEM.EntityClass = "money_printer"
ITEM.Model = "models/props_lab/reciever_cart.mdl"
ITEM.Description = "Creates Money at an alarming rate"
ITEM.MaxMoney = 1000
ITEM.Watts = 1000
ITEM.Craftable = {"Mechanical Parts",20,"Circuit Board",5,"Advanced Electronics",3}
ITEM.MoneyIncrement = 15
ITEM.Size = {2,5}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(0,45,0)
ITEM.CanHold = true 
ITEM.ExtraHUD = function(ent,pos,alpha)

	--draw.SimpleTextOutlined(ent:GetWattsLeft().." Watts","HUDBars",pos.x,pos.y-55,Color(0,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	--draw.SimpleTextOutlined(ent:GetNWInt("Gallons").." Gallons Left","HUDBars",pos.x,pos.y-30,Color(255,255,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))

end