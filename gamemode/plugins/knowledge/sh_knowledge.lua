Dialog["Book Salesman"] = {}
Dialog["Book Salesman"][1] = {
	Text 		= "Hello sir, what can I help you with today?",
	Replies 	= {1,2}
}
Dialog["Book Salesman"][2] = {
	Text 		= "Okay, I'll show you my wares.",
	Replies 	= {3}
}
Dialog["Book Salesman"][3] = {
	Text		= "Get out of my store you damned felon!",
	Replies		= {5}
}
Dialog["Book Salesman"][4] = {
	Text		= "Goodbye sir.",
	Replies		= {5}
}

Replies["Book Salesman"] = {}
Replies["Book Salesman"][1] = {
	Text		= "I would like to buy some stuff.",
	OnUse		= function(pl) if !pl:IsFelon() and !pl:IsWarranted() then return 2 else return 3 end end
}
Replies["Book Salesman"][2] = {
	Text		= "I'm just exploring.",
	OnUse		= function(pl) return 4 end
}
Replies["Book Salesman"][3] = {
	Text		= "What do you have?",
	OnUse		= function(pl) OpenBookMenu(pl) end
}
Replies["Book Salesman"][5] = {
	Text		= "Bye bye.",
	OnUse		= function(pl) end
}

local ITEM = items.DefineItem("Book of Knowledge")
ITEM.Group = "Books"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props/cs_office/offinspb.mdl"
ITEM.Description = "A book to learn things."
ITEM.BulkPrice = 25
ITEM.BulkAmt = 1
ITEM.Weight = 0.2
ITEM.LookAt = vector_origin
ITEM.CamPos = Vector(10,10,10)
ITEM.NoBuy = true
ITEM.KnowledgeGained = 2
ITEM.Args = {}
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Read",function() RunConsoleCommand("read_book",index) end)
end