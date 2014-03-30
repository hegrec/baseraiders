local VehicleList = {}

VehicleList["Golf GTI"] = {
Description = "A standard car that can hold four people",
Class = "prop_vehicle_jeep",
Price = 35000,
MaxPassengers = 4,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/golf/golf.mdl",
Script = "scripts/vehicles/golf2.txt"
}
VehicleList["Corvette"] = {
Description = "A fast American sportscar",
Class = "prop_vehicle_jeep",
Price = 105000,
MaxPassengers = 2,
ExitPoints = {Vector(0, 150, 12),Vector(80, -20, 12),Vector(-80, -20, 12)},
Model = "models/corvette/corvette.mdl",
Script = "scripts/vehicles/corvette.txt"
}
VehicleList["360 Spyder"] = {
Description = "A small but fast Ferrari",
Class = "prop_vehicle_jeep",
Price = 115000,
MaxPassengers = 2,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/360spyder.mdl",
Script = "scripts/vehicles/360.txt"
}
VehicleList["Murcielago"] = {
Description = "A luxury Lamborghini",
Class = "prop_vehicle_jeep",
Price = 280000,
MaxPassengers = 2,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/murcielago.mdl",
Script = "scripts/vehicles/murcielago.txt"
}
VehicleList["Lotus Elise"] = {
Description = "A small English sportscar",
Class = "prop_vehicle_jeep",
Price = 50000,
MaxPassengers = 2,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/lotus_elise.mdl",
Script = "scripts/vehicles/elise.txt"
}
VehicleList["Hummer H2"] = {
Description = "A large American luxury SUV",
Class = "prop_vehicle_jeep",
Price = 90000,
MaxPassengers = 5,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/hummer-h2.mdl",
Script = "scripts/vehicles/hmrh2.txt"
}

VehicleList["BMW M5"] = {
Description = "A nice german car",
Class = "prop_vehicle_jeep",
Price = 55000,
MaxPassengers = 4,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/bmw-m5.mdl",
Script = "scripts/vehicles/bmwm5.txt"
}
VehicleList["Continental Mark IV"] = {
Description = "A nice antique car",
Class = "prop_vehicle_jeep",
Price = 65000,
MaxPassengers = 4,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/sickness/1972markiv.mdl",
Script = "scripts/vehicles/mk4.txt"
}
VehicleList["Mustang Fastback GT"] = {
Description = "A nice old American car",
Class = "prop_vehicle_jeep",
Price = 70000,
MaxPassengers = 4,
ExitPoints = {Vector(75, -10, 12),Vector(-75, -10, 12)},
Model = "models/mustang.mdl",
Script = "scripts/vehicles/Mustang_test.txt"
}


function GetRPVehicleList()
	return VehicleList
end


function GatherSkinInfo()
	if (CLIENT) then return end //ents.Create is serverside...
	for i,v in pairs(VehicleList) do 
		local ent = ents.Create("prop_physics")
		ent:SetModel(v.Model)
		ent:Spawn()
		VehicleList[i].SkinCount = ent:SkinCount()-1
		ent:Remove()
	end
end
hook.Add("InitPostEntity","GetSkinsInfo",GatherSkinInfo)

Dialog["Big Bill"] = {}
Dialog["Big Bill"][1] = {
	Text 		= "Hey there buddy, you look like you need a ride!",
	Replies 	= function(pl) local t = {1,3,2}  if IsValid(pl.Car) then table.insert(t,4) end return t end
}
Dialog["Big Bill"][2] = {
	Text 		= "Alright well if you ever want to get somewhere fast, come let me know",
	Replies 	= {5}
}
Dialog["Big Bill"][4] = {
	Text 		= "Which car are you trying to get?",
	Replies 	= function(pl)
				local t = {}
				if pl.Cars["Corvette"] then
					table.insert(t,6)
				end
				if pl.Cars["Spyder"] then
					table.insert(t,7)
				end
				if pl.Cars["Golf GTI"] then
					table.insert(t,8)
				end
				if pl.Cars["Murcielago"] then
					table.insert(t,10)
				end
				if pl.Cars["Hummer H2"] then
					table.insert(t,11)
				end
				if pl.Cars["Lotus Elise"] then
					table.insert(t,12)
				end
				if pl.Cars["Continental Mark IV"] then
					table.insert(t,13)
				end
				if pl.Cars["BMW M5"] then
					table.insert(t,14)
				end
				if pl.Cars["360 Spyder"] then
					table.insert(t,15)
				end
				if pl.Cars["Mustang Fastback GT"] then
					table.insert(t,16)
				end
				return t
				end
}
Dialog["Big Bill"][5] = {
	Text 		= "You don't seem to have one... Want to see my stock?",
	Replies 	= {1,2}
}
Dialog["Big Bill"][7] = {
	Text 		= "You don't even have a car. Perhaps you want to buy one?",
	Replies 	= {1,2}
}
Dialog["Big Bill"][8] = {
	Text 		= "You think I am going to go look for your car? Go bring it closer to my shop.",
	Replies 	= {9}
}
Dialog["Big Bill"][9] = {
	Text 		= "Your car is locked up nice and safe. You can buy a new one now if you like",
	Replies 	= {1,5}
}
Dialog["Big Bill"][10] = {
	Text 		= "You can only have one car at a time due to licensing issues...You can go get your old car and turn it into me and get out a different one though",
	Replies 	= {9,4}
}

Replies["Big Bill"] = {}
Replies["Big Bill"][1] = {
	Text		= "Of course!",
	OnUse		= function(pl) if IsValid(pl.Car) then return 10 else SendCarMenu(pl) end end
}
Replies["Big Bill"][2] = {
	Text		= "Nah man, I'm saving up right now",
	OnUse		= function(pl) return 2 end
}
Replies["Big Bill"][3] = {
	Text		= "I need to take out one of my cars",
	OnUse		= function(pl) if table.Count(pl.Cars) == 0 then return 5 elseif IsValid(pl.Car) then return 10 else return 4 end end
}
Replies["Big Bill"][4] = {
	Text		= "I want to turn in my car",
	OnUse		= function(pl,ent) if !IsValid(pl.Car) then return 7 elseif pl.Car:GetPos():Distance(ent:GetPos()) > 1000 then return 8 else pl.Car:Remove() pl.Car = nil return 9 end end
}
Replies["Big Bill"][5] = {
	Text		= "See you later",
	OnUse		= function(pl) end
}
Replies["Big Bill"][6] = {
	Text		= "I'm gonna need my Corvette",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Corvette") end
}
Replies["Big Bill"][7] = {
	Text		= "I want my Spyder",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"360 Spyder") end
}
Replies["Big Bill"][8] = {
	Text		= "I'll take my Golf GTI",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Golf GTI") end
}
Replies["Big Bill"][9] = {
	Text		= "Alright, I'll go get it",
	OnUse		= function(pl) end
}
Replies["Big Bill"][10] = {
	Text		= "I want my Murcielago",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Murcielago") end
}
Replies["Big Bill"][11] = {
	Text		= "I want my Hummer",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Hummer H2") end
}
Replies["Big Bill"][12] = {
	Text		= "I want my Lotus Elise",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Lotus Elise") end
}
Replies["Big Bill"][13] = {
	Text		= "I want my Continental Mark IV",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Continental Mark IV") end
}
Replies["Big Bill"][14] = {
	Text		= "I want my BMW M5",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"BMW M5") end
}
Replies["Big Bill"][15] = {
	Text		= "I want my 360 Spyder",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"360 Spyder") end
}
Replies["Big Bill"][16] = {
	Text		= "I want my Mustang",
	OnUse		= function(pl) vehicles.CreatePlayerCar(pl,"Mustang Fastback GT") end
}

Dialog["Big Al"] = {}
Dialog["Big Al"][1] = {
	Text 		= "Hello there",
	Replies 	= {1,2,3}
}
Dialog["Big Al"][2] = {
	Text 		= "Hahaha. Nope. I'm his twin brother Big Al. He sells them, I paint them.",
	Replies 	= {2,3}
}
Dialog["Big Al"][3] = {
	Text 		= "I can't see to locate your car, are you sure you own one?",
	Replies 	= {5}
}
Dialog["Big Al"][4] = {
	Text 		= "I have several different colors depending on the car. Go ahead and take a look",
	Replies 	= {6,7}
}
Dialog["Big Al"][5] = {
	Text 		= "Your car is ready in the garage, hope you like it.",
	Replies 	= {8}
}
Dialog["Big Al"][6] = {
	Text 		= "I will be here when you get enough money. Be sure to come back.",
	Replies 	= {5}
}
Dialog["Big Al"][7] = {
	Text 		= "Where is your car? Go get it and bring it over here.",
	Replies 	= {5}
}

Replies["Big Al"] = {}
Replies["Big Al"][1] = {
	Text		= "Hey, aren't you Big Bill?",
	OnUse		= function(pl) return 2 end
}
Replies["Big Al"][2] = {
	Text		= "I am looking to get my car painted.",
	OnUse		= function(pl) return 4 end
}
Replies["Big Al"][3] = {
	Text		= "Goodbye",
	OnUse		= function(pl) end
}
Replies["Big Al"][5] = {
	Text		= "Oh, oops.",
	OnUse		= function(pl) end
}
Replies["Big Al"][6] = {
	Text		= "Alright, Wha'cha got!",
	OnUse		=  function(pl,ent) if !IsValid(pl.Car) then return 3 elseif pl.Car:GetPos():Distance(ent:GetPos()) > 1000 then return 7 else SendPaintMenu(pl) end end
}
Replies["Big Al"][7] = {
	Text		= "Never mind.",
	OnUse		= function(pl) end
}
Replies["Big Al"][8] = {
	Text		= "Thank you",
	OnUse		= function(pl) end
}