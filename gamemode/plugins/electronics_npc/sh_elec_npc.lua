
Dialog["Arnold, The Hardware Guy"] = {}
Dialog["Arnold, The Hardware Guy"][1] = {
	Text 		= "I sell everything and anything, really - take a gander!",
	Replies 	= {1,2}
}


Replies["Arnold, The Hardware Guy"] = {}
Replies["Arnold, The Hardware Guy"][1] = {
	Text		= "(View Store)",
	OnUse		= function(pl) ViewStore(pl,elec_npc.seller,elec_npc.GetStore()) end
}
Replies["Arnold, The Hardware Guy"][2] = {
	Text		= "Leave",
	OnUse		= function(pl) return nil end
}