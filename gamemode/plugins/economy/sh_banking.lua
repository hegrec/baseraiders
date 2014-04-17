BANK_SPACE = 300
Dialog["Banker Joe"] = {}
Dialog["Banker Joe"][1] = {
	Text 		= "Hello sir, would you like to see your bank account?",
	Replies 	= {1,2}
}
Dialog["Banker Joe"][2] = {
	Text 		= "Have a good day sir",
	Replies 	= {5}
}



Replies["Banker Joe"] = {}
Replies["Banker Joe"][1] = {
	Text		= "Yes",
	OnUse		= function(pl) umsg.Start("openBank",pl) umsg.End() end
}
Replies["Banker Joe"][2] = {
	Text		= "No thanks",
	OnUse		= function(pl) return 2 end
}

Replies["Banker Joe"][5] = {
	Text		= "See you later",
	OnUse		= function(pl) return nil end
}