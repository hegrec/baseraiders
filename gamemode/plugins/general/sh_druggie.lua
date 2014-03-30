
local ITEM = items.DefineItem("Marijuana Plant")
ITEM.Group = "General"
ITEM.EntityClass = "weed_plant"
ITEM.Model = "models/props_c17/pottery09a.mdl"
ITEM.Description = "Classic drug Marijuana used by a lot of people"
ITEM.BulkPrice = 600
ITEM.BulkAmt = 1
ITEM.Weight = 0


local ITEM = items.DefineItem("Small Light")
ITEM.Group = "General"
ITEM.EntityClass = "darkland_light"
ITEM.Model = "models/props/cs_office/light_security.mdl"
ITEM.Description = "Classic drug Marijuana used by a lot of people"
ITEM.Weight = 1
ITEM.Args = {}

local ITEM = items.DefineItem("Mushrooms")
ITEM.Group = "General"
ITEM.EntityClass = "mushroom_plant"
ITEM.Model = "models/props_c17/pottery09a.mdl"
ITEM.Description = "Prepare to be trippin' balls"
ITEM.BulkPrice = 600
ITEM.BulkAmt = 1
ITEM.Weight = 0
ITEM.Args = {}


WEED_HIGH = 120
local ITEM = items.DefineItem("Weed")
ITEM.Group = "Drugs"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl"
ITEM.Description = "Drugssssssssssssssssss..."
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(5,10,5)
ITEM.Weight = 0.5
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
ITEM.Weight = 0.5
ITEM.NoBuy = true
ITEM.Args = {}
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Eat",function() RunConsoleCommand("use_drug",index) end)
end
ITEM.OnUse = function(pl)
	
end


Dialog["Drug Dealer"] = {}
Dialog["Drug Dealer"][1] = {
	Text 		= "What are you doin round' here...",
	Replies 	= {1,2}
}
Dialog["Drug Dealer"][2] = {
	Text 		= "What do you have?",
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
	Text		= "I have some weed",
	OnUse		= function(pl) 
		if !pl:HasItem("Weed") then 
			return 4 
		elseif druggie.drugNeeds["Weed"] < MAX_DRUG_NEED then
			local myDrugs = pl:GetAmount("Weed")
			local drugAmount = math.min(MAX_DRUG_NEED - druggie.drugNeeds["Weed"] ,myDrugs)
			druggie.drugNeeds["Weed"] = math.min(druggie.drugNeeds["Weed"]+drugAmount,MAX_DRUG_NEED)
			pl:TakeItem("Weed",drugAmount)
			pl:AddMoney(drugAmount*150)

			pl:SendNotify("You made $"..drugAmount*150 .." selling marijuana","NOTIFY_GENERIC",4)
			if drugAmount != myDrugs then
				pl:SendNotify("Hey man, I only need "..drugAmount.." for now but I might need more later","NOTIFY_ERROR",5)
			end
			return 5
		else
			return 6
		end
	end
}
Replies["Drug Dealer"][6] = {
	Text		= "I have some shrooms",
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