
myBank = {}
local bankPanel
function ShowBank( um )
	local name = um:ReadString()
	bankPanel = vgui.Create("DFrame")
	bankPanel:SetTitle("Personal Bank Account")
	bankPanel:SetSize(300,600)
	local lblName = vgui.Create("DLabel",bankPanel)
	lblName:SetText("Your Personal Bank")
	lblName:SetFont("HUDBars")
	lblName:SizeToContents()
	lblName:SetPos(5,25)
	
	bankPanel.weight = vgui.Create("DPanelList",bankPanel)
	bankPanel.weight:SetPos(5,50)
	bankPanel.weight:SetSize(bankPanel:GetWide()-10,20)
	bankPanel.weight.Paint = function(s)
	
	
		local tot = 0
		for i,v in pairs(myBank) do
			local xs,ys = 2,2
			if GetItems()[i].Size then
			
				xs,ys = unpack(GetItems()[i].Size)
			end
			tot = tot + xs*ys*v
		end
	
	
		draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),Color(0,0,0,255))
		
		local frac = tot/BANK_SPACE
		
		draw.RoundedBox(0,1,1,frac*(s:GetWide()-2),s:GetTall()-2,Color(frac*255,255-frac*255,0,255))
	end
	
	
	
	bankPanel.list = vgui.Create("DPanelList",bankPanel)
	bankPanel.list:StretchToParent(5,80,5,5)
	bankPanel.list:EnableVerticalScrollbar(true)
	bankPanel:Center()
	bankPanel:MakePopup()
	ShowInv()
	bankPanel.Close = function(p) p:Remove() HideInv() RunConsoleCommand("bankFinished") end
	RunConsoleCommand("requestBank")
end
usermessage.Hook("openBank",ShowBank)

function UpdateBankItem(um)
	
	local name = um:ReadString()
	local current_amt = um:ReadLong()
	
	

	myBank = myBank or {}
	if current_amt == 0 then
		myBank[name] = nil
	else
		myBank[name] = current_amt
	end
	

	
	
	
	local alt = false
	if ValidPanel(bankPanel) then
		bankPanel.list:Clear()
		
		for i,v in pairsByKeys(myBank) do
			
			local name = i
			tbl = GetItems()[name]
			local pnl = vgui.Create("DPanel")
			pnl:SetTall(32)
			
			local lblName = vgui.Create("DLabel",pnl)
			lblName:SetPos(5,5)
			lblName:SetText(name)
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
			
			pnl:SetToolTip(tbl.Description)
			create:SetSize(50,25)
			pnl:SizeToContents()
			create:SetText("Take")
			create.DoClick = function() RunConsoleCommand("bank_to_inv",name) end
			create:SetPos(200,5)
			pnl.PerformLayout = function(p) create:SetPos(p:GetWide()-55,5) end
			bankPanel.list:AddItem(pnl)
	
	
		end
	end

end
usermessage.Hook("getBankItem",UpdateBankItem)