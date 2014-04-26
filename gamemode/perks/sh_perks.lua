local perks = {}


function AddPerk(name)
	perks[name] = {}
	return perks[name]
end
 
local meta = FindMetaTable("Player")

function meta:HasPerk(perk)
	return self.Perks[perk] == true
end


function GetPerkList()
	return perks
end

perks["Gold Digger"] = {
description = "When mining for ores, there's a small chance you'll find a full Metal bar instead of Metal ore."
} 

perks["Picky Axe"] = {
description = "When mining for ores, there's a chance you'll drop twice the amount of whatever resource you get."
} 

perks["Treasure Hunter"] = {
description = "When digging in terrain, there's a small chance you'll find a valuable item."
} 

perks["Everyday I'm shoveling"] = {
description = "When digging in terrain, there's a chance you'll drop twice the amount of whatever resource you get."
} 

perks["Timberrr."] = {
description = "When chopping trees, there's a chance of dropping two blocks of wood."
} 

perks["Sleight of hand"] = {
description = "Reloading weapons just got that a bit faster."
} 

perks["Master Craftsman"] = {
description = "Decrease your crafting times!"
} 

perks["Shady Connections"] = {
description = "You're able to sell your drugs at higher rates."
} 

perks["Commercial Talent"] = {
description = "You get lower rates when buying something from the store."
} 

perks["Knapsack"] = {
description = "You get 1 row of extra inventory space."
} 

perks["Resurrection"] = {
description = "Your respawn times are shorter."
} 

perks["Architect"] = {
description = "Props cost a few bucks less!"
} 

perks["Power trip"] = {
description = "Standing near an energy outlet greatly increases your health regeneration rate."
} 

perks["Survivor"] = {
description = "Whenever you fall below 50HP, you're health regeneration increases dramatically."
} 

perks["Athlete"] = {
description = "Jumping and running now costs less stamina."
} 

perks["A good mugging"] = {
description = "Hitting rivaling gang members with a crowbar or fists has a chance of stealing some of their cash."
} 

perks["Burglar"] = {
description = "Lock picking has a slightly higher chance of succeeding."
} 

perks["420 Blazin"] = {
description = "Harvesting Marijuana has a chance of creating an extra bag."
} 

perks["Savings Account"] = {
description = "You gain 15% extra space in your bank account."
} 
perks["Trained to kill"] = {
description = "Your guns do a tiny bit more damage."
} 
perks["Fleet"] = {
description = "You run a tad bit faster."
} 
perks["Lay low"] = {
description = "Your notoriety decreases somewhat faster"
} 
perks["Doctor, please!"] = {
description = "Stimpacks heal you for a bit more then usual."
} 
perks["Brass Knuckles"] = {
description = "Unarmed attacks are 5 times as lethal!"
} 
perks["Layers of fat"] = {
description = "You spawn with a chunk more health."
} 
perks["Harder Better Faster Stronger"] = {
description = "You swing your basic tools and crowbar a tad bit faster"
} 

perks["Pyromaniac"] = {
description = "Wooden logs you ignite last quite a bit longer"
} 