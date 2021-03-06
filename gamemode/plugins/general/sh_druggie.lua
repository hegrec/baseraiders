
local ITEM = items.DefineItem("Marijuana Seed")
ITEM.Group = "General"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Items/combine_rifle_ammo01.mdl"
ITEM.Description = "A marijuana seed. Add light + water"
ITEM.Size = {1,1}
ITEM.CamPos = Vector(0,0,10)
ITEM.LookAt = Vector(0,0,0)


local ITEM = items.DefineItem("Empty Pot")
ITEM.Group = "General"
ITEM.EntityClass = "empty_pot"
ITEM.Model = "models/nater/weedplant_pot.mdl"
ITEM.Description = "A pot for planting things in"
ITEM.Craftable = {"Clay",5}
ITEM.Size = {2,2}
ITEM.CamPos = Vector(15,15,30)
ITEM.LookAt = Vector(0,0,10)

local ITEM = items.DefineItem("Small Light")
ITEM.Group = "Lights"
ITEM.EntityClass = "darkland_light"
ITEM.Model = "models/props/de_train/floodlight.mdl"
ITEM.Description = "A weak light with little strength."
ITEM.Craftable = {"Glass",1,"Mechanical Parts",1,"Circuit Board",1}
ITEM.CamPos = Vector(18,0,-3)
ITEM.Size = {2,1}
ITEM.LightOffset = Vector(9.387984, -0.618240, -4.107276)
ITEM.LookAt = Vector(0,0,-3)
ITEM.Watts = 200
ITEM.LightFactor = 2

local ITEM = items.DefineItem("Large Grow Light")
ITEM.Group = "Lights"
ITEM.EntityClass = "darkland_light"
ITEM.Model = "models/props_c17/light_floodlight02_off.mdl"
ITEM.Description = "Professional 600W 3200K Daytime grow light"
ITEM.Craftable = {"Mechanical Parts",10,"Glass",5,"Advanced Electronics",1}
ITEM.CamPos = Vector(40,0,40)
ITEM.LookAt = Vector(0,0,40)
ITEM.LightOffset = Vector(2.071506, -9.571411, 76.210136)
ITEM.Size = {2,4}
ITEM.Watts = 500
ITEM.LightFactor = 10

WEED_HIGH = 120
local ITEM = items.DefineItem("Weed")
ITEM.Group = "Drugs"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl"
ITEM.Description = "Drugssssssssssssssssss..."
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,0,5)
ITEM.Size = {1,1}
ITEM.NoBuy = true
ITEM.Args = {}
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Smoke",function() RunConsoleCommand("use_drug",index) end)
end
ITEM.OnUse = function(pl)
	
end


SHROOM_HIGH = 60
local ITEM = items.DefineItem("Shrooms")
ITEM.Group = "Drugs"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/Fungi/sta_skyboxshroom2.mdl"
ITEM.Description = "Magic Mushrooms"
ITEM.LookAt = Vector(0,0,5)
ITEM.CamPos = Vector(25,35,30)
ITEM.Size = {1,1}
ITEM.NoBuy = true
ITEM.Args = {}
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Eat",function() RunConsoleCommand("use_drug",index) end)
end
ITEM.OnUse = function(pl)
	
end


Dialog["Drug Dealer"] = {}
Dialog["Drug Dealer"][1] = {
	Text 		= "What are you doin 'round here...",
	Replies 	= {1,2}
}
Dialog["Drug Dealer"][2] = {
	Text 		= "What are you packin'... Got anything sweet for me?",
	Replies 	= function(pl) 
		local t = {} 
		if pl:HasItem("Weed") then table.insert(t,5) end
		if pl:HasItem("Shrooms") then table.insert(t,6) end 
		table.insert(t,7)
		
			return t
	end
}
Dialog["Drug Dealer"][3] = {
	Text 		= "Yea you better be...",
	Replies 	= {4}
}
Dialog["Drug Dealer"][4] = {
	Text 		= "You ain't got shit man get out of here...",
	Replies 	= {4}
}
Dialog["Drug Dealer"][5] = {
	Text 		= "A'ight man later...",
	Replies 	= {4}
}
Dialog["Drug Dealer"][6] = {
	Text 		= "Nah man, I got plenty of that shit...Come back later",
	Replies 	= {8,4}
}

Replies["Drug Dealer"] = {}
Replies["Drug Dealer"][1] = {
	Text		= "I got some stuff I need to get rid of",
	OnUse		= function(pl) return 2 end
}
Replies["Drug Dealer"][2] = {
	Text		= "Nothin man, I'm going now.",
	OnUse		= function(pl) return 3 end
}
Replies["Drug Dealer"][3] = {
	Text		= "What do you have?",
	OnUse		= function(pl) OpenWeaponMenu(pl) end
}
Replies["Drug Dealer"][4] = {
	Text		= "(Leave)",
	OnUse		= function(pl) end
} 
Replies["Drug Dealer"][5] = {
	Text		= "I've got some of that homegrown...",
	OnUse		= function(pl) 
		if !pl:HasItem("Weed") then 
			return 4 
		else
			local myDrugs = pl:GetAmount("Weed")
			for i=1,myDrugs do
				pl:TakeItem("Weed")
			end
			pl:AddMoney(myDrugs*60)

			pl:SendNotify("You made $"..myDrugs*60 .." selling marijuana","NOTIFY_GENERIC",4)
			return 5
		end
	end
}
Replies["Drug Dealer"][6] = {
	Text		= "I have some nature snacks... the psychedelic kind.",
	OnUse		= function(pl) 
		if !pl:HasItem("Shrooms") then 
			return 4 
		elseif druggie.drugNeeds["Shrooms"] < MAX_DRUG_NEED then
			local myDrugs = pl:GetAmount("Shrooms")
			local drugAmount = math.min(MAX_DRUG_NEED - druggie.drugNeeds["Shrooms"] ,myDrugs)
			druggie.drugNeeds["Shrooms"] = math.min(druggie.drugNeeds["Shrooms"]+drugAmount,MAX_DRUG_NEED)
			pl:TakeItem("Shrooms",drugAmount)
			pl:AddMoney(drugAmount*150)

			pl:SendNotify("You made $"..drugAmount*150 .." selling psychedelic mushrooms","NOTIFY_GENERIC",4)
			if drugAmount != myDrugs then
				pl:SendNotify("Hey man, I only need "..drugAmount.." for now but I might need more later","NOTIFY_ERROR",5)
			end
			return 5
		else
			return 6
		end
	end
}
Replies["Drug Dealer"][7] = {
	Text		= "I don't have anything",
	OnUse		= function(pl) end
}
Replies["Drug Dealer"][8] = {
	Text		= "What about something else?",
	OnUse		= function(pl) return 2 end
}