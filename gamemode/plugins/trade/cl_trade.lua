
function TradeMenu()
	TradeFrame = vgui.Create("DFrame")
	TradeFrame:SetPos(ScrW() / 2 - 200, ScrH() / 2 - 300)
	TradeFrame:SetSize(400, 600)
	TradeFrame:SetTitle("Trade Menu")
	TradeFrame:ShowCloseButton(false)
	TradeFrame:MakePopup()
	MyTradeList = {}
	PartnerTradeList = {}
	Accepted = false
	OtherAccepted = false
	TradeMoney = 0
	PartnerMoney = 0
	ShowInv()

	TradeFrame:SetVisible(true)

	TradePanel = vgui.Create("DPanel", TradeFrame)
	TradePanel:SetPos(10, 30)
	TradePanel:SetSize(380, 300)
	TradePanel.Paint = function()
		draw.RoundedBox(1, 0, 0, 380, 300, Color(0, 0, 0, 200))
		draw.RoundedBox(0, 190, 10, 1, 280, Color(0, 0, 0, 255))		
	end

	TradePanel.SendingPanel = vgui.Create("DPanelList", TradePanel)
	TradePanel.SendingPanel:SetPos(5, 40)
	TradePanel.SendingPanel:SetSize(180, 200)
	TradePanel.SendingPanel:SetSpacing(5)
	TradePanel.SendingPanel:EnableVerticalScrollbar(true)
	
	TradePanel.ReceivingPanel = vgui.Create("DPanelList", TradePanel)
	TradePanel.ReceivingPanel:SetPos(195, 40)
	TradePanel.ReceivingPanel:SetSize(180, 200)
	TradePanel.ReceivingPanel:SetSpacing(5)
	TradePanel.ReceivingPanel:EnableVerticalScrollbar(true)

	
	local NotifyPanel = vgui.Create("DPanel", TradeFrame)
	NotifyPanel:SetPos(TradeFrame:GetWide() / 2 - 62, 35)
	NotifyPanel:SetSize(125, 25)
	NotifyPanel.Paint = function()
		draw.RoundedBox(1, 0, 0, 125, 25, Color(61, 61, 61, 255))
		if OtherAccepted then
			draw.SimpleText("Partner Has Accepted", "default", 10, 5, Color(255, 0, 0, 255))
		elseif Accepted then
			draw.SimpleText("You Have Accepted", "default", 27, 5, Color(255, 0, 0, 255))
		end
	end
	
	local MoneyPanel = vgui.Create("DPanel", TradeFrame)
	MoneyPanel:SetPos(20, 300)
	MoneyPanel:SetSize(170, 20)
	MoneyPanel.Paint = function()
		draw.RoundedBox(1, 0, 0, 170, 20, Color(61, 61, 61, 255))
		draw.SimpleText("$"..TradeMoney..".00", "default", 3, 2, Color(0, 255, 0, 255))
	end
	
	
	local MoneyPanelPartner = vgui.Create("DPanel", TradeFrame)
	MoneyPanelPartner:SetPos(210, 300)
	MoneyPanelPartner:SetSize(170, 20)
	MoneyPanelPartner.Paint = function()
		draw.RoundedBox(1, 0, 0, 170, 20, Color(61, 61, 61, 255))
		draw.SimpleText("$"..PartnerMoney..".00", "default", 3, 2, Color(0, 255, 0, 255))
	end
	

	
	DrawSendingItems()
	DrawReceivingItems()
	
	local MoneyEntry = vgui.Create("DTextEntry", TradeFrame)
	MoneyEntry:SetText("Enter amount of money to offer here!")
	MoneyEntry:SetPos(10, 545)
	MoneyEntry:SetSize(380, 22)
	MoneyEntry:SetEditable(true)
	MoneyEntry.OnEnter = function()
		if !tonumber(MoneyEntry:GetValue()) then MoneyEntry:SetText("Please enter a valid number!") return end
		if GetMoney() >= tonumber(MoneyEntry:GetValue()) then
			TradeMoney = tonumber(MoneyEntry:GetValue())
			RunConsoleCommand("trademoney",TradeMoney)
		else
			MoneyEntry:SetText("You do not have that much money!")
		end
	end
	
	local Accept = vgui.Create("DButton", TradeFrame)
	Accept:SetPos(10, 572)
	Accept:SetText("Accept")
	Accept:SetSize(185, 22)
	Accept.DoClick = function()
		RunConsoleCommand("accept_trade")
		Accepted = true
	end
	
	local Deny = vgui.Create("DButton", TradeFrame)
	Deny:SetPos(205, 572)
	Deny:SetText("Deny")
	Deny:SetSize(185, 22)
	Deny.DoClick = function()
		MyTradeList = {}
		PartnerTradeList = {}
		RunConsoleCommand("deny_trade")
		TradeFrame:SetVisible(false)
	end
end
usermessage.Hook("OpenTradeMenu", TradeMenu)

usermessage.Hook("CloseTradeMenu",function()  TradeFrame:Remove() timer.Simple(0.1,function()HideInv()end) end)

usermessage.Hook("OtherAccepted",function() OtherAccepted = true end)

usermessage.Hook("TradeMoney",function(um) PartnerMoney = um:ReadLong() end)

usermessage.Hook("UnAccept",function() Accepted = false OtherAccepted = false end)

function DrawSendingItems()
	TradePanel.SendingPanel:Clear()
	local alt = false
	for k,v in pairs(MyTradeList) do
		local item = GetItems()[k]
		if v > 0 then
			local pnl = vgui.Create("DPanel")
			pnl:SetTall(32)
			
			local lblName = vgui.Create("DLabel",pnl)
			lblName:SetPos(5,5)
			lblName:SetText(k)
			lblName:SetFont("HUDBars")
			lblName:SizeToContents()
			lblName:SetTextColor(Color(0,0,0,255))
			local lblAmt = vgui.Create("DLabel",pnl)
			lblAmt:SetPos(5+lblName:GetWide()+5,5)
			lblAmt:SetText("("..v..")")
			lblAmt:SetFont("HUDBars")
			lblAmt:SizeToContents()
			lblAmt:SetTextColor(Color(0,0,0,255))
			
			alt = !alt
			
			local color = Color(200,200,200,255)
			if (!alt) then
				color = Color(170,170,170,255)
			end
			pnl.Paint = function(s)
				draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),color)
			end
			
			local create = vgui.Create("DButton",pnl)
			
			pnl:SetToolTip(item.Description)
			create:SetSize(50,25)
			pnl:SizeToContents()
			create:SetText("Remove From Trade")
			create.DoClick = function()
			RunConsoleCommand("remove_trade_item",k) end
			create:SetPos(200,5)
			pnl.PerformLayout = function(p) create:SetPos(p:GetWide()-55,5) end
			TradePanel.SendingPanel:AddItem(pnl)
		end
	end
end

function DrawReceivingItems()
	TradePanel.ReceivingPanel:Clear()
	for k,v in pairs(PartnerTradeList) do
		local item = GetItems()[k]
		if v > 0 then
						local pnl = vgui.Create("DPanel")
			pnl:SetTall(32)
			pnl:SetToolTip(item.Description)
			local lblName = vgui.Create("DLabel",pnl)
			lblName:SetPos(5,5)
			lblName:SetText(k)
			lblName:SetFont("HUDBars")
			lblName:SizeToContents()
			lblName:SetTextColor(Color(0,0,0,255))
			local lblAmt = vgui.Create("DLabel",pnl)
			lblAmt:SetPos(5+lblName:GetWide()+5,5)
			lblAmt:SetText("("..v..")")
			lblAmt:SetFont("HUDBars")
			lblAmt:SizeToContents()
			lblAmt:SetTextColor(Color(0,0,0,255))
			
			alt = !alt
			
			local color = Color(200,200,200,255)
			if (!alt) then
				color = Color(170,170,170,255)
			end
			pnl.Paint = function(s)
				draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),color)
			end
			TradePanel.ReceivingPanel:AddItem(pnl)
		end
	end
end

usermessage.Hook("add_trade_item",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()
	MyTradeList[item] = number
	DrawSendingItems()
end)

usermessage.Hook("add_partner_trade_item",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()

	PartnerTradeList[item] = number
	DrawReceivingItems()
end)

usermessage.Hook("remove_trade_item",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()
	MyTradeList[item] = number
	DrawSendingItems()
end)


usermessage.Hook("remove_partner_trade_item",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()
	PartnerTradeList[item] = number
	DrawReceivingItems()
end)