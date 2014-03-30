TradeMoney = 0
PartnerMoney = 0
MenuCreated = false
Accepted = false
OtherAccepted = false
TradeFrame = vgui.Create("DFrame")
TradeFrame:SetPos(ScrW() / 2 - 200, ScrH() / 2 - 300)
TradeFrame:SetSize(400, 600)
TradeFrame:SetTitle("Trade Menu")
TradeFrame:ShowCloseButton(false)
TradeFrame:SetDraggable(false)
TradeFrame:MakePopup()
TradeFrame:SetVisible(false)

function TradeMenu()
	MyTradeList = {}
	PartnerTradeList = {}
	MyItems = table.Copy(Inventory)
	Accepted = false
	OtherAccepted = false
	TradeMoney = 0
	PartnerMoney = 0
	
	if MenuCreated then
		DrawSendingItems()
		DrawReceivingItems()
		DrawInventory()
		MoneyEntry:SetText("Enter amount of money to offer here!")
	end
	
	TradeFrame:SetVisible(true)
	if !MenuCreated then
		TradePanel = vgui.Create("DPanel", TradeFrame)
		TradePanel:SetPos(10, 30)
		TradePanel:SetSize(380, 300)
		TradePanel.Paint = function()
			draw.RoundedBox(1, 0, 0, 380, 300, Color(0, 0, 0, 200))
			draw.RoundedBox(0, 190, 10, 1, 280, Color(0, 0, 0, 255))		
		end

		SendingPanel = vgui.Create("DPanelList", TradePanel)
		SendingPanel:SetPos(5, 5)
		SendingPanel:SetSize(180, 300)
		SendingPanel:SetSpacing(5)
		SendingPanel:EnableHorizontal(true)
		SendingPanel:EnableVerticalScrollbar(true)
		
		ReceivingPanel = vgui.Create("DPanelList", TradePanel)
		ReceivingPanel:SetPos(195, 5)
		ReceivingPanel:SetSize(180, 300)
		ReceivingPanel:SetSpacing(5)
		ReceivingPanel:EnableHorizontal(true)
		ReceivingPanel:EnableVerticalScrollbar(true)
		
		InventoryPanel = vgui.Create("DPanel", TradeFrame)
		InventoryPanel:SetPos(10, 340)
		InventoryPanel:SetSize(380, 200)
		InventoryPanel.Paint = function()
			draw.RoundedBox(1, 0, 0, 380, 200, Color(0, 0, 0, 200))
			draw.SimpleTextOutlined("Inventory","ScoreboardSub",145,15,Color(50,180,255,255),0,1,1,Color(29,128,156,255))
		end
		
		NotifyPanel = vgui.Create("DPanel", TradeFrame)
		NotifyPanel:SetPos(TradeFrame:GetWide() / 2 - 62, 35)
		NotifyPanel:SetSize(125, 25)
		NotifyPanel.Paint = function()
			draw.RoundedBox(1, 0, 0, 125, 25, Color(61, 61, 61, 255))
			if OtherAccepted then
				draw.SimpleText("Partner Has Accepted", "default", 10, 5, Color(255, 0, 0, 255))
			elseif Accepted then
				draw.SimpleText("Ready To Trade", "default", 27, 5, Color(255, 0, 0, 255))
			end
		end
		
		MoneyPanel = vgui.Create("DPanel", TradeFrame)
		MoneyPanel:SetPos(20, 300)
		MoneyPanel:SetSize(170, 20)
		MoneyPanel.Paint = function()
			draw.RoundedBox(1, 0, 0, 170, 20, Color(61, 61, 61, 255))
			draw.SimpleText("$"..TradeMoney..".00", "default", 3, 2, Color(0, 255, 0, 255))
		end
		
		
		MoneyPanelPartner = vgui.Create("DPanel", TradeFrame)
		MoneyPanelPartner:SetPos(210, 300)
		MoneyPanelPartner:SetSize(170, 20)
		MoneyPanelPartner.Paint = function()
			draw.RoundedBox(1, 0, 0, 170, 20, Color(61, 61, 61, 255))
			draw.SimpleText("$"..PartnerMoney..".00", "default", 3, 2, Color(0, 255, 0, 255))
		end
		
		InventoryList = vgui.Create("DPanelList", InventoryPanel)
		InventoryList:SetPos(15, 25)
		InventoryList:SetSize(370, 170)
		InventoryList:SetSpacing(5)
		InventoryList:EnableHorizontal(true)
		InventoryList:EnableVerticalScrollbar(true)
		
		DrawSendingItems()
		DrawReceivingItems()
		DrawInventory()
		
		MoneyEntry = vgui.Create("DTextEntry", TradeFrame)
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
		
		Accept = vgui.Create("DButton", TradeFrame)
		Accept:SetPos(10, 572)
		Accept:SetText("Accept")
		Accept:SetSize(185, 22)
		Accept.DoClick = function()
			RunConsoleCommand("accept")
			Accepted = true
		end
		
		Deny = vgui.Create("DButton", TradeFrame)
		Deny:SetPos(205, 572)
		Deny:SetText("Deny")
		Deny:SetSize(185, 22)
		Deny.DoClick = function()
			MyTradeList = {}
			PartnerTradeList = {}
			RunConsoleCommand("deny")
			TradeFrame:SetVisible(false)
		end
		MenuCreated = true
	end
end
usermessage.Hook("OpenTradeMenu", TradeMenu)

usermessage.Hook("CloseTradeMenu",function() TradeFrame:SetVisible(false) end)

usermessage.Hook("OtherAccepted",function() OtherAccepted = true end)

usermessage.Hook("TradeMoney",function(um) PartnerMoney = um:ReadLong() end)

usermessage.Hook("UnAccept",function() Accepted = false OtherAccepted = false end)

function DrawInventory()
	InventoryList:Clear()
	for k,v in pairs(MyItems) do
		local item = GetItems()[k]
		if v > 0 then
			local panel = vgui.Create("DModelPanel")
			panel:SetModel(item.Model)
			panel:SetTooltip(k) 
			panel:SetSize(80,80)
			panel.amt = v
			panel.itemType = k
			panel:SetCamPos(item.CamPos)
			panel:SetLookAt(item.LookAt)
			panel.PaintOver = function() draw.SimpleText(panel.amt,"ScoreboardSub",60,60,Color(255,255,255,255),2,4) end
			panel.OnMousePressed = function()
				local menu = DermaMenu()
				menu:AddOption("Add To Trade", function() 
					RunConsoleCommand("sendPartnerItem",1,panel.itemType)		
					if MyTradeList[panel.itemType] then
						MyTradeList[panel.itemType] = MyTradeList[panel.itemType] + 1
					else
						MyTradeList[panel.itemType] = 1
					end
					MyItems[panel.itemType] = MyItems[panel.itemType] - 1
					Accepted = false
					DrawSendingItems()
				end)
				menu:Open()
			end
			InventoryList:AddItem(panel)
		end
	end
end

function DrawSendingItems()
	SendingPanel:Clear()
	InventoryList:Clear()
	for k,v in pairs(MyTradeList) do
		local item = GetItems()[k]
		if v > 0 then
			local panel = vgui.Create("DModelPanel")
			panel:SetModel(item.Model)
			panel:SetTooltip(k) 
			panel:SetSize(80,80)
			panel.amt = v
			panel.itemType = k
			panel:SetCamPos(item.CamPos)
			panel:SetLookAt(item.LookAt)
			panel.PaintOver = function() draw.SimpleText(panel.amt,"ScoreboardSub",60,60,Color(255,255,255,255),2,4) end
			panel.OnMousePressed = function()
				local menu = DermaMenu()
				menu:AddOption("Remove From Trade",function()
					RunConsoleCommand("removePartnerItem",1,panel.itemType)
					MyTradeList[panel.itemType] = MyTradeList[panel.itemType] - 1
					if MyItems[panel.itemType] then
						MyItems[panel.itemType] = MyItems[panel.itemType] + 1
					else
						MyItems[panel.itemType] = 1
					end
					Accepted = false
					DrawSendingItems()
				end)
				menu:Open()
			end
			SendingPanel:AddItem(panel)
		end
	end
	DrawInventory()
end

function DrawReceivingItems()
	ReceivingPanel:Clear()
	for k,v in pairs(PartnerTradeList) do
		local item = GetItems()[k]
		if v > 0 then
			local panel = vgui.Create("DModelPanel")
			panel:SetModel(item.Model)
			panel:SetTooltip(k) 
			panel:SetSize(80,80)
			panel.amt = v
			panel.itemType = k
			panel:SetCamPos(item.CamPos)
			panel:SetLookAt(item.LookAt)
			panel.PaintOver = function() draw.SimpleText(panel.amt,"ScoreboardSub",60,60,Color(255,255,255,255),2,4) end
			ReceivingPanel:AddItem(panel)
		end
	end
end

usermessage.Hook("sendPartnerItem",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()
	if PartnerTradeList[item] then
		PartnerTradeList[item] = PartnerTradeList[item]+number
	else
		PartnerTradeList[item] = number
	end
	DrawReceivingItems()
end)

usermessage.Hook("removePartnerItem",function(um)
	local item = um:ReadString()
	local number = um:ReadLong()
	PartnerTradeList[item] = PartnerTradeList[item] - 1
	DrawReceivingItems()
end)