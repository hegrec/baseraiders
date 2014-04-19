local Commands = {}
Commands["Global"] = {
"// <msg> - OOC chat",
"/w <name> <msg> - Whisper to others",
"/me <msg> - Sends an ICC action",
"/pm <name> <msg> - Send a PM to another player",
"/reply <msg> - Replys to the last person to send you a PM",
"/holster - Put your active weapon into your inventory",
"/putaway - Alias of /holster",
"/advert <advertisement> - Advertise your products via chat",
"/givemoney <amount> - Aim at a player and use this to give money",
"/save - Saves your account manually (Auto saves every 5 minutes)"
}
Commands["Gang"] = {
"/g - talk to other gang members",
}

function CreateCmdsTab()
	local list = vgui.Create("DPanelList")
	list:EnableVerticalScrollbar()
	list:SetSpacing(1)
	list:SetPadding(7)
	for i,v in pairs(Commands) do
		local lab = Label(i)
		list:AddItem(lab)
		for q,w in pairs(v) do
			local lab = Label("     "..w)
			lab:SetWrap(true)
			list:AddItem(lab)
		end
	end
	
	Panels["Menu"].Sheet:AddSheet("Commands",list,"gui/silkicons/magnifier",nil,nil,nil,5) 
end
hook.Add("OnMenusCreated","CreateCmdsTab",CreateCmdsTab)



function CreateDonateTab()
	local list = vgui.Create("DPanelList")
	list:SetSpacing(4)
	list:SetPadding(7)
	list:EnableVerticalScrollbar()
	local p = vgui.Create("DPanel")
	p:SetTall(30)
	p.Paint = function()
	draw.RoundedBox(8,0,0,p:GetWide(),p:GetTall(),Color(100,100,100,255))
	draw.SimpleText("Why Donate?","ScoreboardSub",10,p:GetTall()*0.5,Color(0,0,0,255),0,1)
	end
	list:AddItem(p)
	local p2 = vgui.Create("DPanel")
	p2:SetTall(350)
	p2.Paint = function()
	draw.RoundedBox(8,0,0,p2:GetWide(),p2:GetTall(),Color(100,100,100,255))
	draw.SimpleText("Help CakeToast out!","ScoreboardSub",10,15,Color(0,0,0,255),0,1)
	draw.SimpleText("	CakeToast is very expensive to run. Donations help cover the cost of running the server","Default",10,30,Color(0,0,0,255),0,1)
	draw.SimpleText("	We offer perks to donators who donate a certain amount at once. They last forever too.","Default",10,42,Color(0,0,0,255),0,1)

	local num = 80
	
	draw.SimpleText("VIP - $10 USD","ScoreboardSub",10,80,Color(20,20,200,255),0,1)
	draw.SimpleText("Here are some of the benefits of VIP status:","Default",10,num+14,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Max ban of 7 days","Default",10,num+38,Color(0,0,0,255),0,1)
	draw.SimpleText("	-AFK Kicker Immunity","Default",10,num+50,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Props cost %50 less. $80 props cost $40 to a VIP.","Default",10,num+62,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Experience is gained twice as fast (+200%)","Default",10,num+74,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Inventory is %225 that of a regular inventory. 15x15 vs 10x10","Default",10,num+86,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Never expires, valid forever","Default",10,num+98,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Receive new benefits as they are added","Default",10,num+110,Color(0,0,0,255),0,1)
	
	num = 276
	
	draw.SimpleText("Base Raiders Cash - $1 USD = $2500 ingame ","ScoreboardSub",10,num,Color(20,200,20,255),0,1)
	draw.SimpleText("Head to www.CakeToast.com/donations.php","ScoreboardSub",10,num+35,Color(0,0,0,255),0,1)
	draw.SimpleText("You will instantly receive your perks upon rejoining after donating","HUDBars",10,num+55,Color(0,0,0,255),0,1)	
	end
	
	list:AddItem(p2)
	Panels["Menu"].Sheet:AddSheet("Donations",list,"gui/silkicons/heart",nil,nil,nil,6) 
end
hook.Add("OnMenusCreated","CreateDonateTab",CreateDonateTab)