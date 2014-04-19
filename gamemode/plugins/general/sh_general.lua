local ITEM = items.DefineItem("Lock Pick")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_crowbar.mdl"
ITEM.Description = "...because you forgot your key, right?"
ITEM.Size = {1,2}
ITEM.Craftable = {"Metal",1}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(0,0,10)
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.SWEPClass = "lockpick"


local ITEM = items.DefineItem("Breach Charge")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/dav0r/tnt/tnttimed.mdl"
ITEM.Description = "A sure fire way to get into a base."
ITEM.Size = {1,2}
ITEM.Craftable = {"Mechanical Parts",1,"Clay",5,"Gunpowder",20}
ITEM.RestoreHP = 25
ITEM.LookAt = Vector(0,0,7)
ITEM.CamPos = Vector(10,10,7)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index,x,y)
	local ent = LocalPlayer():GetEyeTrace(MAX_INTERACT_DIST).Entity
	if (ent:GetClass() == "prop_physics" or ent:IsDoor()) and LocalPlayer():CanReach(ent) then
		menu:AddOption("Plant Charge",function() RunConsoleCommand("plant_charge",x,y) end)
	end
end


local ITEM = items.DefineItem("Stim-pak")
ITEM.Group = "Edible Items"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/healthvial.mdl"
ITEM.Description = "Great for healing after a drunken brawl"
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.RestoreHP = 25
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(0,8,5)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index,x,y)
	menu:AddOption("Use",function() RunConsoleCommand("use_health",x,y) end)
end

local ITEM = items.DefineItem("Medkit")
ITEM.Group = "Edible Items"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_medkit.mdl"
ITEM.Description = "Will replenish a lot of health"
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.RestoreHP = 50
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(0,0,10)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index,x,y)
	menu:AddOption("Use",function() RunConsoleCommand("use_health",x,y) end)
end

local ITEM = items.DefineItem("Adrenaline")
ITEM.Group = "Edible Items"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_c17/trappropeller_lever.mdl"
ITEM.Description = "Temporarily replenishes your stamina much faster"
ITEM.Size = {1,1}
ITEM.CanHeal = true
ITEM.RestoreFunction = function(pl) print(pl) pl:SetNWInt("adrenaline_end",CurTime()+30) end
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,0,12)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index,x,y)
	menu:AddOption("Use",function() RunConsoleCommand("use_health",x,y) end)
end

local ITEM = items.DefineItem("Water")
ITEM.Group = "General"
ITEM.EntityClass = "darkland_item"
ITEM.Size = {1,2}
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.Description = "Good old H2O"
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(0,10,0)

local ITEM = items.DefineItem("Crowbar")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_crowbar.mdl"
ITEM.Description = "Great for opening crates...and heads."
ITEM.Size = {1,2}
ITEM.Craftable = {"Metal",3}
ITEM.LookAt = Vector(0,0,0)
ITEM.CamPos = Vector(0,0,10)

ITEM.CanHold = true

ITEM.SWEPClass = "weapon_crowbar"


local ITEM = items.DefineItem("AK-47")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_rif_ak47.mdl"
ITEM.Description = "Outlawed weapon that is very powerful"
ITEM.Size = {3,2}
ITEM.Craftable = {"Weapon Barrel",5,"Weapon Body",5,"Weapon Stock",5,"Weapon Sights",5}

ITEM.AmmoAmt = 90
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(0,30,0)
ITEM.Ammo = "SMG1"
ITEM.CanHold = true

ITEM.SWEPClass = "darkland_ak47"

local ITEM = items.DefineItem("FiveSeven")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_fiveseven.mdl"
ITEM.Description = "A light pistol good for close range."
ITEM.Craftable = {"Weapon Barrel",1,"Weapon Body",1,"Weapon Stock",2,"Weapon Sights",1}
ITEM.AmmoAmt = 45
ITEM.BulkAmt = 10
ITEM.Ammo = "pistol"
ITEM.Size = {2,1}
ITEM.LookAt = Vector(2,0,3)
ITEM.CamPos = Vector(2,12,3)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_fiveseven"

local ITEM = items.DefineItem("Desert Eagle")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_deagle.mdl"
ITEM.Description = "Very powerful handgun, at the cost of higher-then-usual recoil and it's limited clip size."
ITEM.Craftable = {"Weapon Barrel",3,"Weapon Body",2,"Weapon Stock",1,"Weapon Sights",1}
ITEM.AmmoAmt = 45
ITEM.BulkAmt = 10
ITEM.Size = {2,1}
ITEM.Ammo = "pistol"
ITEM.LookAt = Vector(2,0,3)
ITEM.CamPos = Vector(2,12,3)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_deagle"

local ITEM = items.DefineItem("Glock")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_glock18.mdl"
ITEM.Description = "Standard issue firearm, used  by law enforcement across the globe."
ITEM.Craftable = {"Weapon Barrel",1,"Weapon Body",1,"Weapon Stock",1,"Weapon Sights",1}
ITEM.AmmoAmt = 45
ITEM.Ammo = "pistol"
ITEM.Size = {2,1}
ITEM.LookAt = Vector(2,0,3)
ITEM.CamPos = Vector(2,12,3)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_glock"

local ITEM = items.DefineItem("M4A1")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_rif_m4a1.mdl"
ITEM.Description = "Military grade rifle."
ITEM.Craftable = {"Weapon Barrel",5,"Weapon Body",6,"Weapon Stock",4,"Weapon Sights",7}
ITEM.AmmoAmt = 90
ITEM.Ammo = "SMG1"
ITEM.BulkAmt = 10
ITEM.Size = {5,2}
ITEM.LookAt = Vector(-3,0,5)
ITEM.CamPos = Vector(-3,30,0)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_m4"

local ITEM = items.DefineItem("Mac10")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_smg_mac10.mdl"
ITEM.Description = "SMG popular among lower class thugs"
ITEM.Craftable = {"Weapon Barrel",4,"Weapon Body",2,"Weapon Stock",3,"Weapon Sights",2}
ITEM.AmmoAmt = 90
ITEM.Ammo = "SMG1"
ITEM.Size = {2,2}
ITEM.BulkAmt = 10
ITEM.Weight = 1.1
ITEM.LookAt = Vector(2,0,3)
ITEM.CamPos = Vector(10,10,10)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_mac10"

local ITEM = items.DefineItem("MP5")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_smg_mp5.mdl"
ITEM.Description = "Accurate sub-machine gun with a decent range"
ITEM.Craftable = {"Weapon Barrel",5,"Weapon Body",6,"Weapon Stock",4,"Weapon Sights",3}
ITEM.Ammo = "SMG1"
ITEM.AmmoAmt = 90
ITEM.BulkAmt = 10
ITEM.Size = {3,2}
ITEM.LookAt = Vector(3,0,5)
ITEM.CamPos = Vector(3,27,15)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_mp5"

local ITEM = items.DefineItem("Pump Shotgun")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_shot_m3super90.mdl"
ITEM.Description = "Powerful weapon but not very accurate"
ITEM.Craftable = {"Weapon Barrel",5,"Weapon Body",6,"Weapon Stock",4,"Weapon Sights",1}
ITEM.AmmoAmt = 20
ITEM.Ammo = "buckshot"
ITEM.BulkAmt = 10
ITEM.Size = {5,2}
ITEM.LookAt = Vector(-5,0,5)
ITEM.CamPos = Vector(-5,30,5)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.SWEPClass = "darkland_pumpshotgun"


local ITEM = items.DefineItem("Pistol Ammo")
ITEM.Group = "Ammo"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Items/357ammo.mdl"
ITEM.Description = "Ammo for pistols"
ITEM.Craftable = {"Metal",1,"Gunpowder",1}
ITEM.BulkAmt = 10
ITEM.Size = {1,1}
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(15,0,5)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Use",function() RunConsoleCommand("use_ammo",index) end)
end

local ITEM = items.DefineItem("Shotgun Ammo")
ITEM.Group = "Ammo"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Items/BoxBuckshot.mdl"
ITEM.Description = "Ammo for shotguns"
ITEM.Craftable = {"Metal",2,"Gunpowder",1}
ITEM.Size = {1,1}
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(18,0,5)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Use",function() RunConsoleCommand("use_ammo",index) end)
end

local ITEM = items.DefineItem("Rifle Ammo")
ITEM.Group = "Ammo"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Items/BoxSRounds.mdl"
ITEM.Description = "Ammo for rifles"
ITEM.Craftable = {"Metal",1,"Gunpowder",2}
ITEM.BulkAmt = 10
ITEM.Size = {1,1}
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(18,0,5)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Use",function() RunConsoleCommand("use_ammo",index) end)
end

