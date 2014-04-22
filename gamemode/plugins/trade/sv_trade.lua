function SendTradeRequest(pl)

	pl.NextTrade = pl.NextTrade or 0

	if pl.HasTrade then return end

	local tr = pl:EyeTrace(MAX_INTERACT_DIST)
	
	if IsValid(tr.Entity) && tr.Entity:IsPlayer() && !tr.Entity.HasTrade then
	
		pl:ChatPrint("You have requested to trade with "..tr.Entity:Name().."!")
		RequestTrade(pl, tr.Entity)
	elseif IsValid(tr.Entity) && tr.Entity:IsPlayer() && tr.Entity.HasTrade then
	
		pl:ChatPrint("That player is currently trading with someone else.")
	end
	
	pl.NextTrade = CurTime() + 10
end
AddChatCommand("trade",SendTradeRequest)

function RequestTrade(req, rec)

	rec:ChatPrint(req:Name().." wants to trade with you! Type /accept or /deny.")

	req.HasTrade = true
	rec.HasTrade = true
	
	timer.Create("trade"..req:SteamID(),10,1,function()
		if IsValid(req) then
			req:ChatPrint("Trade Expired!")
			req.HasTrade = false
			req.TradeRequester = false
		end
		if IsValid(rec) then
			rec.HasTrade = false
			rec:ChatPrint("Trade Expired!")
		end
		
	end)
	req.TradeRequester = true
	rec.TradePartner = req
	req.TradePartner = rec
	
end

function DenyTrade(pl)
	if pl.HasTrade && !pl.TradeRequester then
		timer.Destroy("trade"..pl.TradePartner:SteamID())
		pl.HasTrade = false
		pl.TradePartner.HasTrade = false
		pl:ChatPrint("Trade Denied!")
		pl.TradePartner:ChatPrint("Trade Denied!")
		pl.TradePartner.TradeRequester = false
		pl.TradeRequester = false
		pl.TradePartner.TradePartner = nil
		pl.TradePartner = nil
	end
end
AddChatCommand("deny", DenyTrade)

function AcceptTrade(pl)
	if pl.HasTrade && !pl.TradeRequester then
		if !pl:HasLineOfSight(pl.TradePartner) then pl:SendNotify("You are not looking at your trade partner!",NOTIFY_ERROR,5) return end
		timer.Destroy("trade"..pl.TradePartner:SteamID())
		BeginTrade(pl,pl.TradePartner)
	end
end
AddChatCommand("accept",AcceptTrade)




function BeginTrade(trader1,trader2)
	trader1:ChatPrint("Trade Request Accepted")
	trader1.TradeList = {}
	trader1:SetNWBool("Trading",true)
	umsg.Start("OpenTradeMenu", trader1)
	umsg.End()

	trader1.tempTradeItems ={}
	trader2.tempTradeItems ={}

	trader1.TradeRequester = false
	trader2.TradeRequester = false

	trader2:ChatPrint("Trade Request Accepted")
	trader2.TradeList = {}
	trader2:SetNWBool("Trading",true)
	umsg.Start("OpenTradeMenu", trader2)
	umsg.End()
end

function AcceptTradeButton(pl)
	if !IsValid(pl.TradePartner) then return end
	pl.AcceptedTrade = true
	umsg.Start("OtherAccepted",pl.TradePartner)
	umsg.End()
	if pl.TradePartner.AcceptedTrade then
		FinalTrade(pl,pl.TradePartner)
	end
end
concommand.Add("accept_trade",AcceptTradeButton)

function DenyTradeButton(pl)
	if !IsValid(pl.TradePartner) then return end
	pl:ChatPrint("Trade Canceled!")
	pl.TradePartner:ChatPrint("Trade Canceled!")
	umsg.Start("CloseTradeMenu",pl)
	umsg.End()
	umsg.Start("CloseTradeMenu",pl.TradePartner)
	umsg.End()




	for i,v in pairs(pl.tempTradeItems) do
		pl:GiveItem(v[1],v[2],v[3])
	end

	for i,v in pairs(pl.TradePartner.tempTradeItems) do
		pl.TradePartner:GiveItem(v[1],v[2],v[3])
	end
	pl.tempTradeItems = {}
	pl.TradePartner.tempTradeItems = {}




	WipeList(pl)
	WipeList(pl.TradePartner)
	pl.AcceptedTrade = false
	pl.TradePartner.AcceptedTrade = false
	pl.HasTrade = false
	pl.TradePartner.HasTrade = false

	pl.HasTrade = false
	pl.TradePartner.HasTrade = false

	pl:SetNWBool("Trading",false)
	pl.TradePartner:SetNWBool("Trading",false)



	pl.TradePartner.TradePartner = nil
	pl.TradePartner = nil





end
concommand.Add("deny_trade",DenyTradeButton)





function SendPartnerItem(pl,cmd,args)
	if !IsValid(pl.TradePartner) then return end
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local item = pl:GetItem(x,y)
	if !GetItems()[item] then return end --this acts as a HasItem verification
	
	
	local amt = (pl.TradeList[item] or 0) + 1
	if pl:GetAmount(item) < amt then
		pl:SendNotify("You have no more of those to trade","NOTIFY_ERROR",4)
		return
	end




	if pl.TradeList[item] then
		pl.TradeList[item] = pl.TradeList[item] + 1
	else
		pl.TradeList[item] = 1
	end

	umsg.Start("add_partner_trade_item",pl.TradePartner)
		umsg.String(item)
		umsg.Long(pl.TradeList[item])
	umsg.End()

	umsg.Start("add_trade_item",pl)
		umsg.String(item)
		umsg.Long(pl.TradeList[item])
	umsg.End()

	pl.AcceptedTrade = false
	pl.TradePartner.AcceptedTrade = false
	umsg.Start("UnAccept",pl.TradePartner)
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("add_trade_item",SendPartnerItem)

function RemovePartnerItem(pl,cmd,args)
	if !IsValid(pl.TradePartner) then return end
	local item = args[1]
	if !pl.TradeList[item] or pl.TradeList[item] < 1 then return end
	pl.TradeList[item] = pl.TradeList[item] - 1

	umsg.Start("remove_partner_trade_item",pl.TradePartner)
		umsg.String(item)
		umsg.Long(pl.TradeList[item])
	umsg.End()

	umsg.Start("remove_trade_item",pl)
		umsg.String(item)
		umsg.Long(pl.TradeList[item])
	umsg.End()


	pl.AcceptedTrade = false
	pl.TradePartner.AcceptedTrade = false



	umsg.Start("UnAccept",pl.TradePartner)
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("remove_trade_item",RemovePartnerItem)

function TradeMoney(pl,cmd,args)
	local MyMoneyOffer = tonumber(args[1])
	if !IsValid(pl.TradePartner) then return end
	if pl:GetMoney() < MyMoneyOffer then
		pl:SentNotify("You don't have that money")
		return
	end
	pl.TradePartner.PartnerMoney = MyMoneyOffer
	umsg.Start("TradeMoney",pl.TradePartner)
		umsg.Long(MyMoneyOffer)
	umsg.End()
	pl.AcceptedTrade = false
	pl.TradePartner.AcceptedTrade = false
	umsg.Start("UnAccept",pl.TradePartner)
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("trademoney",TradeMoney)

function WipeList(pl)
	pl.TradeList = {}
	pl.PartnerMoney = nil
end

function FinalTrade(pl,trader) 

	local takenItems = {}
	local givenItems = {}
	local room1 = true
	for k,v in pairs(pl.TradeList) do
		if pl:GetAmount(k)<v then pl:SendNotify("You don't have that amount!","NOTIFY_ERROR",4) return end
		for i=1,v do
			local xpos1,ypos1 = trader:GiveItem(k)
			if xpos1 then
				local xpos,ypos = pl:TakeItem(k)
				table.insert(takenItems,{k,xpos,ypos})
				table.insert(givenItems,{k,xpos1,ypos1})
			else
				room1 = false
				break
			end
		end
	end
	if !room1 then
		pl:SendNotify("Your partner can not hold that many items!",NOTIFY_ERROR,5)
		trader:SendNotify("You can not hold that many items!",NOTIFY_ERROR,5)
		for i,v in pairs(takenItems) do
			pl:GiveItem(v[1],v[2],v[3])
		end
		for i,v in pairs(givenItems) do
			print(v[1],"282")
			trader:TakeItem(v[2],v[3])
		end
		return
	end

	local takenItems2 = {}
	local givenItems2 = {}
	local room2 = true
	for k,v in pairs(trader.TradeList) do
		if trader:GetAmount(k)<v then pl:SendNotify("Your partner doesn't have that amount!","NOTIFY_ERROR",4)  return end
		for i=1,v do
			local xpos1,ypos1 = pl:GiveItem(k)
			if xpos1 then
				local xpos,ypos = trader:TakeItem(k)
				table.insert(takenItems2,{k,xpos,ypos})
				table.insert(givenItems2,{k,xpos1,ypos1})
			else
				room2 = false
				break
			end
		end
	end
	if !room2 then
		print("takenItems")
		PrintTable(takenItems)
		print("takenItems2")
		PrintTable(takenItems2)

		print("givenItems")
		PrintTable(givenItems)
		print("givenItems2")
		PrintTable(givenItems2)

		trader:SendNotify("Your partner can not hold that many items!",NOTIFY_ERROR,5)
		pl:SendNotify("You can not hold that many items!",NOTIFY_ERROR,5)
		for i,v in pairs(takenItems) do
			pl:GiveItem(v[1],v[2],v[3])
		end
		for i,v in pairs(givenItems) do
			print(v[1],"313")
			trader:TakeItem(v[2],v[3])
		end
		for i,v in pairs(takenItems2) do
			trader:GiveItem(v[1],v[2],v[3])
		end
		for i,v in pairs(givenItems2) do
			print(v[1],"320")
			pl:TakeItem(v[2],v[3])
		end
		return
	end

	if pl.PartnerMoney then
		pl:AddMoney(tonumber(pl.PartnerMoney))
		trader:AddMoney(-1*tonumber(pl.PartnerMoney))
	end
	if trader.PartnerMoney then
		trader:AddMoney(tonumber(trader.PartnerMoney))
		pl:AddMoney(-1*tonumber(trader.PartnerMoney))
	end
	pl.TradePartner = nil
	trader.TradePartner = nil
	umsg.Start("CloseTradeMenu",pl)
	umsg.End()
	umsg.Start("CloseTradeMenu",trader)
	umsg.End()
	WipeList(pl)
	WipeList(trader)
	pl:SendNotify("Trade completed!",NOTIFY_GENERIC,5)
	trader:SendNotify("Trade completed!",NOTIFY_GENERIC,5)
	pl.AcceptedTrade = false
	trader.AcceptedTrade = false
	pl.HasTrade = false
	trader.HasTrade = false
	pl:SetNWBool("Trading",false)
	trader:SetNWBool("Trading",false)
end