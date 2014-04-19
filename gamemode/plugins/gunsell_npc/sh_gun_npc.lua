
Dialog["Achmed, the Gun Dealer"] = {}
Dialog["Achmed, the Gun Dealer"][1] = {
	Text 		= "Here’s my selection of firearms, if you’re interested...",
	Replies 	= {1,2}
}


Replies["Achmed, the Gun Dealer"] = {}
Replies["Achmed, the Gun Dealer"][1] = {
	Text		= "(View Store)",
	OnUse		= function(pl) ViewStore(pl,gun_npc.seller,gun_npc.GetStore()) end
}
Replies["Achmed, the Gun Dealer"][2] = {
	Text		= "Leave",
	OnUse		= function(pl) return nil end
}