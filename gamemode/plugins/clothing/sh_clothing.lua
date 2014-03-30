local Clothes = {}
Clothes["American Hat"] = {
Model = "models/americahat/americahat.mdl",
Description = "Good ole' Uncle Sam's hat",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["Beer Hat"] = {
Model = "models/beerhat/beerhat.mdl",
Description = "A hat to party with",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["Bunny Ears"] = {
Model = "models/bunnyears/bunnyears.mdl",
Description = "Headwear for whores",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
UpOffset = -2.5,
RightOffset = -7.2,
Type = "Hat"
}
Clothes["Captain Hat"] = {
Model = "models/captainshat/captainshat.mdl",
Description = "Hello Captain Jack",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["High Hat"] = {
Model = "models/highhat/highhat.mdl",
Description = "A bigass hat",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["Paper Bag"] = {
Model = "models/paperbag/paperbag.mdl",
Description = "A bag to cover your ugly face with",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["Mario Hat"] = {
Model = "models/mariohat/mariohat.mdl",
Description = "A hat that brings back memories",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["I Love Turtles Hat"] = {
Model = "models/props/de_tides/Vending_hat.mdl",
Description = "Show off your love for turtles",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}

Clothes["Head Crab Plush"] = {
Model = "models/headcrabclassic.mdl",
Description = "Head crab plush from Valve",
LookAt = vector_origin,
CamPos = Vector(10,40,20),
Price = 1000,
Type = "Hat"
}
Clothes["Resident Evil"] = {
Skin = 1,
Description = "Resident Evil fan shirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Black Jacket"] = {
Skin = 2,
Description = "Simple black leather jacket",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Green Jacket"] = {
Skin = 3,
Description = "Green jacket with a black undershirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Red Hoodie"] = {
Skin = 4,
Description = "A red hoodie",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Black Jacket 2"] = {
Skin = 5,
Description = "Black leather jacket with white undershirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Slayer"] = {
Skin = 6,
Description = "Shirt for the band Slayer",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Green Sweater"] = {
Skin = 7,
Description = "Simple green sweater",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Gray Jacket"] = {
Skin = 8,
Description = "Simple gray leather jacket",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Flannel Red Shirt"] = {
Skin = 9,
Description = "Flannel red shirt with grey long sleeve shirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Blue hoodie"] = {
Skin = 10,
Description = "Simple blue hoodie",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["I Got Wood"] = {
Skin = 11,
Description = "Shirt for wood lovers",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Misfits Hoodie"] = {
Skin = 12,
Description = "Hoodie for the band Misfits",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "MaleClothes"
}
Clothes["Green Pullover"] = {
Skin = 1,
Description = "Green pullover jacket",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "FemaleClothes"
}
Clothes["Playboy Bunny Shirt"] = {
Skin = 2,
Description = "A white playboy bunny shirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "FemaleClothes"
}
Clothes["Hello Kitty Shirt"] = {
Skin = 3,
Description = "White and pink Hello Kitty Shirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "FemaleClothes"
}
Clothes["Red Pin Stripe Shirt"] = {
Skin = 4,
Description = "A red pin stripe shirt with black jeans",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "FemaleClothes"
}
Clothes["Purple Long Sleeve"] = {
Skin = 5,
Description = "A simple long sleeve purple long sleeve shirt",
LookAt = Vector(0,0,35),
CamPos = Vector(10,60,35),
Price = 5000,
Type = "FemaleClothes"
}
function IsHat(str)
	if(!Clothes[str])then return false end
	return (Clothes[str].Type == "Hat")
end

function GetClothes()
	return table.Copy(Clothes)
end

Dialog["Hat Seller"] = {}
Dialog["Hat Seller"][1] = {
	Text 		= "Hello welcome to the Clothing store! Do ya want a hat?",
	Replies 	= {1,2,3}
}
Dialog["Hat Seller"][2] = {
	Text 		= "Alright well if you ever want one, come let me know",
	Replies 	= {5}
}
Dialog["Hat Seller"][3] = {
	Text 		= "Well it makes you cool duh...",
	Replies 	= {4,3}
}

Replies["Hat Seller"] = {}
Replies["Hat Seller"][1] = {
	Text		= "Why?",
	OnUse		= function(pl) return 3 end
}
Replies["Hat Seller"][2] = {
	Text		= "Yea",
	OnUse		= function(pl) OpenHatMenu(pl) end
}
Replies["Hat Seller"][3] = {
	Text		= "Nah, I'm alright",
	OnUse		= function(pl) return 2 end
}
Replies["Hat Seller"][4] = {
	Text		= "Alright, I guess so",
	OnUse		= function(pl) OpenHatMenu(pl) end
}
Replies["Hat Seller"][5] = {
	Text		= "See you later",
	OnUse		= function(pl) end
}

Dialog["Clothes Seller"] = {}
Dialog["Clothes Seller"][1] = {
	Text 		= "Welcome to the Clothing Store! Wanna buy some new threads?",
	Replies 	= {1,2}
}
Dialog["Clothes Seller"][2] = {
	Text 		= "Alright well if you ever want one, come let me know",
	Replies 	= {3}
}

Replies["Clothes Seller"] = {}
Replies["Clothes Seller"][1] = {
	Text		= "Sure, I could use a change in style",
	OnUse		= function(pl) OpenClothesMenu(pl) end
}
Replies["Clothes Seller"][2] = {
	Text		= "Nah, I'm alright",
	OnUse		= function(pl) return 2 end
}
Replies["Clothes Seller"][3] = {
	Text		= "See you later",
	OnUse		= function(pl) end
}