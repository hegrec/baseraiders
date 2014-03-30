local ITEM = items.DefineItem("Lock Pick")
ITEM.Group = "Tools"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_crowbar.mdl"
ITEM.Description = "Helps unlock doors"
ITEM.Weight = 0.8
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.TeamOnly = TEAM_MOBBOSS
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "lockpick"


local ITEM = items.DefineItem("Stim-pak")
ITEM.Group = "Edible Items"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/healthvial.mdl"
ITEM.Description = "Great for healing after a drunken brawl"
ITEM.Weight = 1
ITEM.CanHeal = true
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,12,16)
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.Args = {
	RestoreHP = 20
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Use",function() RunConsoleCommand("use_health",index) end)
end

local ITEM = items.DefineItem("Water")
ITEM.Group = "General"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.Description = "Good old H2O"
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.Weight = 1
ITEM.NoBuy = true
ITEM.Args = {}

local ITEM = items.DefineItem("Crowbar")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_crowbar.mdl"
ITEM.Description = "Great for opening crates...and heads."
ITEM.Weight = 1.5
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.BulkPrice = 2500
ITEM.BulkAmt = 10
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "weapon_crowbar"


local ITEM = items.DefineItem("AK-47")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_rif_ak47.mdl"
ITEM.Description = "Outlawed weapon that is very powerful"
ITEM.Weight = 1.3
ITEM.AmmoAmt = 90
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.Ammo = "SMG1"
ITEM.BulkPrice = 30000
ITEM.BulkAmt = 10
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_ak47"

local ITEM = items.DefineItem("FiveSeven")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_fiveseven.mdl"
ITEM.Description = "A light pistol good for close range"
ITEM.BulkPrice = 3000
ITEM.AmmoAmt = 45
ITEM.BulkAmt = 10
ITEM.Ammo = "pistol"
ITEM.Weight = 1.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,20,10)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_fiveseven"

local ITEM = items.DefineItem("Deagle")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_deagle.mdl"
ITEM.Description = "Powerful pistol; good for short range combat"
ITEM.BulkPrice = 4500
ITEM.AmmoAmt = 45
ITEM.BulkAmt = 10
ITEM.Ammo = "pistol"
ITEM.Weight = 1.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,20,10)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_deagle"

local ITEM = items.DefineItem("Glock")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_pist_glock18.mdl"
ITEM.Description = "Standard pistol used all over the world"
ITEM.BulkPrice = 3000
ITEM.AmmoAmt = 45
ITEM.BulkAmt = 10
ITEM.Ammo = "pistol"
ITEM.Weight = 1.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,20,10)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_glock"

local ITEM = items.DefineItem("M4A1")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_rif_m4a1.mdl"
ITEM.Description = "Powerful rifle used by the military"
ITEM.BulkPrice = 25000
ITEM.AmmoAmt = 90
ITEM.Ammo = "SMG1"
ITEM.BulkAmt = 10
ITEM.Weight = 1.6
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_m4"

local ITEM = items.DefineItem("Mac10")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_smg_mac10.mdl"
ITEM.Description = "SMG popular among lower class thugs"
ITEM.BulkPrice = 15000
ITEM.AmmoAmt = 90
ITEM.Ammo = "SMG1"
ITEM.BulkAmt = 10
ITEM.Weight = 1.1
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_mac10"

local ITEM = items.DefineItem("MP5")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_smg_mp5.mdl"
ITEM.Description = "Accurate sub-machine gun with a decent range"
ITEM.BulkPrice = 20000
ITEM.Ammo = "SMG1"
ITEM.AmmoAmt = 90
ITEM.BulkAmt = 10
ITEM.Weight = 1.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_mp5"

local ITEM = items.DefineItem("Pump Shotgun")
ITEM.Group = "Weapons"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/weapons/w_shot_m3super90.mdl"
ITEM.Description = "Powerful weapon but not very accurate"
ITEM.BulkPrice = 25000
ITEM.AmmoAmt = 20
ITEM.Ammo = "buckshot"
ITEM.BulkAmt = 10
ITEM.Weight = 1.6
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,40,20)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Equip",function() RunConsoleCommand("use_gun",index) end)
end
ITEM.SWEPClass = "darkland_pumpshotgun"


local ITEM = items.DefineItem("Pistol Ammo")
ITEM.Group = "Ammo"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Items/357ammo.mdl"
ITEM.Description = "Ammo for pistols"
ITEM.BulkPrice = 750
ITEM.BulkAmt = 10
ITEM.Weight = 0.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,20,10)
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
ITEM.BulkPrice = 1000
ITEM.BulkAmt = 10
ITEM.Weight = 0.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,20,10)
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
ITEM.BulkPrice = 1250
ITEM.BulkAmt = 10
ITEM.Weight = 0.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(7,26,10)
ITEM.NoBuy = true
ITEM.Args = {
	CanPutAway = true
}
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Use",function() RunConsoleCommand("use_ammo",index) end)
end


Dialog["Weapon Dealer"] = {}
Dialog["Weapon Dealer"][1] = {
	Text 		= "Hey man, what do you want?",
	Replies 	= {1,2}
}
Dialog["Weapon Dealer"][2] = {
	Text 		= "Aight man, I can hook you up bro. I only sell in bulk amounts though. You can buy stuff from me in bulks of ten",
	Replies 	= {3}
}
Dialog["Weapon Dealer"][3] = {
	Text 		= "I don't like you hangin' around man",
	Replies 	= {5}
}

Replies["Weapon Dealer"] = {}
Replies["Weapon Dealer"][1] = {
	Text		= "I am looking for some weapons",
	OnUse		= function(pl) return 2 end
}
Replies["Weapon Dealer"][2] = {
	Text		= "I'm just exploring",
	OnUse		= function(pl) return 3 end
}
Replies["Weapon Dealer"][3] = {
	Text		= "What do you have?",
	OnUse		= function(pl) OpenWeaponMenu(pl) end
}
Replies["Weapon Dealer"][5] = {
	Text		= "See you later",
	OnUse		= function(pl) end
}

