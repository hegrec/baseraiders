
Dialog["Dr. Ned"] = {}
Dialog["Dr. Ned"][1] = {
	Text 		= "Oh, you’ve injured yourself? We better fix that right up!",
	Replies 	= {1,2}
}


Replies["Dr. Ned"] = {}
Replies["Dr. Ned"][1] = {
	Text		= "(View Store)",
	OnUse		= function(pl) ViewStore(pl,doc_npc.seller,doc_npc.GetStore()) end
}
Replies["Dr. Ned"][2] = {
	Text		= "Leave",
	OnUse		= function(pl) return nil end
}