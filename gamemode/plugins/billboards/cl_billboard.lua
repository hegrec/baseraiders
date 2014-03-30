local entindex = nil
local manentindex = nil
function CreateBillboardTab()
	local bbs = vgui.Create("DPanelList")
	bbs:SetPadding(6)
	bbs:SetSpacing(4)
	bbs:EnableVerticalScrollbar()
	
	local buypan = vgui.Create("DPanel")
	buypan:SetTall(50)
	
	local buypanhelp = vgui.Create("DLabel",buypan)
	buypanhelp:SetText("Select an available billboard from the list below to buy")
	buypanhelp:SizeToContents()
	buypanhelp:SetPos(5,5)

	local buydropdown = vgui.Create("DComboBox",buypan)
	buydropdown:SetPos(5,25)
	buydropdown:SetWide(200)
	buydropdown:Clear() 
	buydropdown.OpenMenu = function() 
							buydropdown:Clear() 
							for k,v in pairs(ents.FindByClass("billboard"))do
								if(v:IsOwnable() == true and !v:GetOwn())then
									local cost = 1000
									if(v:GetNWInt("cost") > 0)then
										cost = v:GetNWInt("cost")
									end
									buydropdown:AddChoice(v:GetNWString("txt2").." - $"..cost,v:EntIndex())
								end
							end
						 	
							if(#buydropdown.Choices == 0)then buydropdown:AddChoice("None") end
						 	if(buydropdown.Menu)then 
						 		buydropdown.Menu:Remove() 
						 		buydropdown.Menu = nil 
						 		return		 
						 	end 	
						 	buydropdown.Menu = DermaMenu() 	 	 
						 	for k, v in pairs(buydropdown.Choices)do 
						 		buydropdown.Menu:AddOption(v, function() buydropdown:ChooseOption(v, k) end) 
						 	end 
						 	local x, y = buydropdown:LocalToScreen(0, buydropdown:GetTall()) 	 
						 	buydropdown.Menu:SetMinimumWidth(buydropdown:GetWide()) 
						 	buydropdown.Menu:Open(x, y, false, buydropdown)		 
						end
	buydropdown.OnSelect = function(wtf,index, value, data) --wtf, why does it pass itself?
							entindex = data
						end
						
	local buybtn = vgui.Create("DButton",buypan)
	buybtn:SetText("Purchase Billboard")
	buybtn:SetWide(100)
	buybtn:SetPos(210,25)
	buybtn.DoClick = function()
						if(!entindex)then return end
						if(ents.GetByIndex(entindex):GetClass() != "billboard")then return end
						RunConsoleCommand("purchasebb",entindex)
						entindex = nil
						buydropdown:SetText("")
					end
	
	bbs:AddItem(buypan)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local manpan = vgui.Create("DPanel") --lawl manpan lawl mangepanel
	manpan:SetTall(400)
	local manpanhelp = vgui.Create("DLabel",manpan)
	manpanhelp:SetText("Select a billboard from the list below to modify it")
	manpanhelp:SizeToContents()
	manpanhelp:SetPos(5,5)
	
	local mandropdown = vgui.Create("DComboBox",manpan)
	mandropdown:SetPos(5,25)
	mandropdown:SetWide(200)
	mandropdown.OpenMenu = function() 
							mandropdown:Clear() 
							for k,v in pairs(ents.FindByClass("billboard"))do
								if(v:IsOwnable() == true and v:GetOwn() == LocalPlayer())then
									mandropdown:AddChoice("TEXT",v:EntIndex())
								end
							end
						 	
							if(#mandropdown.Choices == 0)then mandropdown:AddChoice("None") end
						 	if(mandropdown.Menu)then 
						 		mandropdown.Menu:Remove() 
						 		mandropdown.Menu = nil 
						 		return		 
						 	end 	
						 	mandropdown.Menu = DermaMenu() 	 	 
						 		for k, v in pairs(mandropdown.Choices)do 
						 			mandropdown.Menu:AddOption(v, function() mandropdown:ChooseOption(v, k) end) 
						 		end 
						 		local x, y = mandropdown:LocalToScreen(0, mandropdown:GetTall()) 	 
						 		mandropdown.Menu:SetMinimumWidth(mandropdown:GetWide()) 
						 		mandropdown.Menu:Open(x, y, false, mandropdown)		 
						end
	
	local bgclrlbl = vgui.Create("DLabel",manpan)
	bgclrlbl:SetText("Background Color")
	bgclrlbl:SizeToContents()
	bgclrlbl:SetPos(65,50)
	
	local bgclrmix = vgui.Create("DColorMixer",manpan)
	bgclrmix:SetPos(5,70)
	bgclrmix:SetSize(225,150)
	
	local setbgclr = vgui.Create("DButton",manpan)
	setbgclr:SetText("Set Background Color")
	setbgclr:SetWide(150)
	setbgclr:SetPos(35,225)
	setbgclr.DoClick = function()
						if(!manentindex)then return end
						local bgclr = bgclrmix:GetColor() 
						RunConsoleCommand("bb_setbgclr",manentindex,bgclr.r,bgclr.g,bgclr.b)
					end
	
	local fgclrlbl = vgui.Create("DLabel",manpan)
	fgclrlbl:SetText("Text Color")
	fgclrlbl:SizeToContents()
	fgclrlbl:SetPos(315,50)
	
	local fgclrmix = vgui.Create("DColorMixer",manpan)
	fgclrmix:SetPos(230,70)
	fgclrmix:SetSize(225,150)
	
	local setfgclr = vgui.Create("DButton",manpan)
	setfgclr:SetText("Set Foreground Color")
	setfgclr:SetWide(150)
	setfgclr:SetPos(260,225)
	setfgclr.DoClick = function()
						if(!manentindex)then return end
						local fgclr = fgclrmix:GetColor() 
						RunConsoleCommand("bb_setfgclr",manentindex,fgclr.r,fgclr.g,fgclr.b)
					end
	
	local txthelp = vgui.Create("DLabel",manpan)
	txthelp:SetText("Set text for each line")
	txthelp:SizeToContents()
	txthelp:SetPos(5,250)
	
	local txthelp2 = vgui.Create("DLabel",manpan)
	txthelp2:SetText("(Note: depending on the billboard, not all text can be displayed)")
	txthelp2:SizeToContents()
	txthelp2:SetPos(10,265)
	
	local lines = {}
	for i=1,4 do
		lines[i] = {}
		lines[i].linelbl = vgui.Create("DLabel",manpan)
		lines[i].linelbl:SetText("Line "..i..":")
		lines[i].linelbl:SizeToContents()
		lines[i].linelbl:SetPos(5,(i-1)*20+293)
		
		lines[i].line = vgui.Create("DTextEntry",manpan)
		lines[i].line:SetWide(150) 
		lines[i].line:SetPos(40,(i-1)*20+290)
		lines[i].line.OnTextChanged = function()
								if(string.len(lines[i].line:GetValue()) > 20)then
									lines[i].line:SetValue(string.sub(lines[i].line:GetValue(),1,15))
								end
							end
		
		lines[i].linebtn = vgui.Create("DButton",manpan)
		lines[i].linebtn:SetText("Set Text")
		lines[i].linebtn:SetWide(100)
		lines[i].linebtn:SetPos(195,(i-1)*20+289)
		lines[i].linebtn.DoClick = function()
							if(!manentindex)then return end
							RunConsoleCommand("bb_settxt",manentindex,i,lines[i].line:GetValue())
						end
	end
	
	BtnSell = vgui.Create("DButton",manpan)
	BtnSell:SetText("Sell Billboard")
	BtnSell:SetWide(100)
	BtnSell:SetPos(130,374)
	BtnSell.DoClick = function() 
						if(!manentindex)then return end
						local cost = 1000
						if(ents.GetByIndex(manentindex):GetNWInt("cost") > 0)then
							cost = ents.GetByIndex(manentindex):GetNWInt("cost")
						end
						Derma_Query( "Are you sure you want to sell this for ".. cost/2 .."?", "Confirmation!",
						"Yes", 	function() RunConsoleCommand("bb_sell",manentindex) gui.EnableScreenClicker(false) end, 
						"No", function() end)	
					end
	
	mandropdown.OnSelect = function(wtf,index, value, data) --load settings from billboard
					manentindex = data
					
					if(manentindex)then
						local bgclr = string.Explode("|",ents.GetByIndex(manentindex):GetNWString("bgclr"))
						bgclr = Color(bgclr[1],bgclr[2],bgclr[3],255)	
						bgclrmix:SetColor(bgclr)
						local txtclr = string.Explode("|",ents.GetByIndex(manentindex):GetNWString("txtclr"))
						txtclr = Color(txtclr[1],txtclr[2],txtclr[3],255)	
						fgclrmix:SetColor(txtclr)
						
						for i=1,4 do
							lines[i].line:SetValue(ents.GetByIndex(manentindex):GetNWString("txt"..i))						
						end
					end
				end
	bbs:AddItem(manpan)
	
	Panels["Menu"].Sheet:AddSheet("Billboards",bbs,"gui/silkicons/wrench") 
end
hook.Add("OnMenusCreated","CreateBillboardTab",CreateBillboardTab)