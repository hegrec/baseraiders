function ReadBook(pl,cmd,args)
	local index = table.concat(args," ")
	local tbl = GetItems()[index]
	if !tbl then return end
	if !pl:HasItem(index) then return end
	for i=1,tbl.KnowledgeGained do
		hook.Call("OnIntelligenceUp",GAMEMODE,pl)
	end
	pl:SendNotify("You have earned "..tbl.KnowledgeGained.." intelligence points from reading the book entitled \""..index.."\"!",NOTIFY_GENERIC,5)
	pl:TakeItem(index)
end
concommand.Add("read_book",ReadBook)

book = {}

function book.SetSalesman(ply)
	if !ply:IsSuperAdmin() and !ply:IsDev() then return end
	local booksalesman = ents.Create("npc_generic")
	booksalesman:SetNPCName("Book Salesman")
	booksalesman:SetNWString("NPCName","Book Salesman")
	booksalesman:SetModel("models/mossman.mdl")
	booksalesman:Spawn()
	booksalesman:SetPos(ply:GetPos())
	booksalesman:SetAngles(ply:GetAngles())
	booksalesman:EnableChat()
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/book/"..game.GetMap()..".txt",str)
end
AddChatCommand("setbooknpc",book.SetSalesman)

function book.LoadSalesman()
	if file.Exists("darklandrp/book/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/book/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		local booksalesman = ents.Create("npc_generic")
		booksalesman:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		booksalesman:SetNPCName("Book Salesman")
		booksalesman:SetNWString("NPCName","Book Salesman")
		booksalesman:SetModel("models/mossman.mdl")
		booksalesman:SetAngles(Vector(tbl[4],tbl[5],tbl[6])) //It is an AimVector
		booksalesman:Spawn()
		booksalesman:EnableChat()
	end
end
hook.Add("InitPostEntity","LoadBookSalesman",book.LoadSalesman)

function OpenBookMenu(pl)
	umsg.Start("bookMenu",pl)
	umsg.End()
end

function BuyBook(pl,cmd,args)
	local index = args[1]
	if !index then return end
	local tbl = GetItems()[index]
	if !tbl || tbl.Group != "Books" then return end
	if pl:GetMoney() < tbl.BulkPrice then pl:SendNotify("You can not afford this item!",NOTIFY_ERROR,4) return end
	if !pl:CanHold(tbl.BulkAmt,tbl.Weight) then pl:SendNotify("You are carrying too much already!",NOTIFY_ERROR,4) return end
	pl:AddMoney(tbl.BulkPrice*-1)
	pl:GiveItem(index,tbl.BulkAmt)
	hook.Call("ControlEconomy",GAMEMODE,1)
end
concommand.Add("buybook",BuyBook)