function SendTradeRequest(pl)

	pl.NextTrade = pl.NextTrade or 0

	if pl.NextTrade > CurTime() then return end

	local tr = pl:EyeTrace(MAX_INTERACT_DIST)
	
	if IsValid(tr.Entity) && tr.Entity:IsPlayer() && !tr.Entity.HasTrade then
	
		pl:ChatPrint("You have requested to trade with "..tr.Entity:Name().."!")
		RequestTrade(pl, tr.Entity)
		
	end
	
	pl.NextTrade = CurTime() + 10
end
AddChatCommand("trade",SendTradeRequest)

function RequestTrade(req, rec)

	rec:ChatPrint(req:Name().." wants to trade with you! Type /accept or /deny or press F3 on them.")

	req.HasTrade = true
	rec.HasTrade = true
	
	timer.Create("trade"..req:SteamID(),20,1,function()
		req:ChatPrint("Trade Expired!")
		req.HasTrade = false
		rec.HasTrade = false
		rec:ChatPrint("Trade Expired!")
	end)
	
	rec.TradePlayer = req:SteamID()
	req.TradePlayer = rec:SteamID()
	
end

function AcceptTrade(pl)
	if pl.HasTrade then
		if !pl:HasLineOfSight(pl:TradePartner()) then pl:SendNotify("You are not looking at your trade partner!",NOTIFY_ERROR,5) return end
		if timer.IsTimer("trade"..pl.TradePlayer) then
			timer.Destroy("trade"..pl.TradePlayer)
		end
		pl:Trade()
		pl:TradePartner():Trade()
	end
end
AddChatCommand("accept",AcceptTrade)

function AcceptTradeButton(pl)
	if !IsValid(pl:TradePartner()) then return end
	pl.AcceptedTrade = true
	umsg.Start("OtherAccepted",pl:TradePartner())
	umsg.End()
	if pl:TradePartner().AcceptedTrade then
		FinalTrade(pl,pl:TradePartner())
	end
end
concommand.Add("accept",AcceptTradeButton)

function FinalTrade(pl,trader)
	local plweight = 0
	local traderweight = 0
	local plamount = 0
	local traderamount = 0
	for k,v in pairs(pl.TradeList) do
		local item = GetItems()[k]
		traderamount = traderamount + v
		traderweight = traderweight + item.Weight
		if !trader:CanHold(traderamount,traderweight) then
			pl:SendNotify("Your partner can not hold that many items!",NOTIFY_ERROR,5)
			trader:SendNotify("You can not hold that many items!",NOTIFY_ERROR,5)
			return
		end
	end
	for k,v in pairs(trader.TradeList) do
		local item = GetItems()[k]
		plamount = plamount + v
		plweight = plweight + item.Weight
		if !pl:CanHold(plamount,plweight) then
			trader:SendNotify("Your partner can not hold that many items!",NOTIFY_ERROR,5)
			pl:SendNotify("You can not hold that many items!",NOTIFY_ERROR,5)
			return
		end
	end
	for k,v in pairs(pl.TradeList) do
		trader:GiveItem(k,v)
		pl:TakeItem(k,v)
	end
	for k,v in pairs(trader.TradeList) do
		pl:GiveItem(k,v)
		trader:TakeItem(k,v)
	end
	if pl.PartnerMoney then
		pl:AddMoney(tonumber(pl.PartnerMoney))
		trader:TakeMoney(tonumber(pl.PartnerMoney))
	end
	if trader.PartnerMoney then
		trader:AddMoney(tonumber(trader.PartnerMoney))
		pl:TakeMoney(tonumber(trader.PartnerMoney))
	end
	pl.TradePlayer = ""
	trader.TradePlayer = ""
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
end

function WipeList(pl)
	pl.TradeList = {}
	pl.PartnerMoney = nil
end

function DenyTradeButton(pl)
	if !IsValid(pl:TradePartner()) then return end
	WipeList(pl)
	WipeList(pl:TradePartner())
	pl:ChatPrint("Trade Canceled!")
	pl:TradePartner():ChatPrint("Trade Canceled!")
	umsg.Start("CloseTradeMenu",pl)
	umsg.End()
	umsg.Start("CloseTradeMenu",pl:TradePartner())
	umsg.End()
	WipeList(pl)
	WipeList(pl:TradePartner())
	pl.AcceptedTrade = false
	pl:TradePartner().AcceptedTrade = false
	pl.HasTrade = false
	pl:TradePartner().HasTrade = false
	pl:TradePartner().TradePlayer = ""
	pl.TradePlayer = ""
end
concommand.Add("deny",DenyTradeButton)

function DenyTrade(pl)
	if pl.HasTrade then
		if timer.IsTimer("trade"..pl.TradePlayer) then
			timer.Destroy("trade"..pl.TradePlayer)
		end
		pl.HasTrade = false
		pl:TradePartner().HasTrade = false
		pl:ChatPrint("Trade Denied!")
		pl:TradePartner():ChatPrint("Trade Denied!")
		pl:TradePartner().TradePlayer = ""
		pl.TradePlayer = ""
	end
end
AddChatCommand("deny", DenyTrade)

local meta = FindMetaTable("Player")

function meta:Trade(trader)
	self:ChatPrint("Trade Accepted")
	self.TradeList = {}
	umsg.Start("OpenTradeMenu", self)
	umsg.End()
end

function SendPartnerItem(pl,cmd,args)
	if !IsValid(pl:TradePartner()) then return end
	local number = tonumber(args[1])
	table.remove(args,1)
	local item = table.concat(args," ")
	if !pl:HasItem(item) then return end
	umsg.Start("sendPartnerItem",pl:TradePartner())
		umsg.String(item)
		umsg.Long(number)
	umsg.End()
	if pl.TradeList[item] then
		pl.TradeList[item] = pl.TradeList[item] + number
	else
		pl.TradeList[item] = number
	end
	pl.AcceptedTrade = false
	pl:TradePartner().AcceptedTrade = false
	umsg.Start("UnAccept",pl:TradePartner())
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("sendPartnerItem",SendPartnerItem)

function RemovePartnerItem(pl,cmd,args)
	if !IsValid(pl:TradePartner()) then return end
	local number = tonumber(args[1])
	table.remove(args,1)
	local item = table.concat(args," ")
	umsg.Start("removePartnerItem",pl:TradePartner())
		umsg.String(item)
		umsg.Long(number)
	umsg.End()
	pl.TradeList[item] = pl.TradeList[item] - number
	pl.AcceptedTrade = false
	pl:TradePartner().AcceptedTrade = false
	umsg.Start("UnAccept",pl:TradePartner())
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("removePartnerItem",RemovePartnerItem)

function meta:TradePartner()
	local partner = nil
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == self.TradePlayer then
			partner = v
			break
		end
	end
	return partner
end

function TradeMoney(pl,cmd,args)
	local MyMoneyOffer = tonumber(args[1])
	if !IsValid(pl:TradePartner()) then return end
	pl:TradePartner().PartnerMoney = MyMoneyOffer
	umsg.Start("TradeMoney",pl:TradePartner())
		umsg.Long(MyMoneyOffer)
	umsg.End()
	pl.AcceptedTrade = false
	pl:TradePartner().AcceptedTrade = false
	umsg.Start("UnAccept",pl:TradePartner())
	umsg.End()
	umsg.Start("UnAccept",pl)
	umsg.End()
end
concommand.Add("trademoney",TradeMoney)