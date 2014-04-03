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
Commands["Mayor"] = {
"/warrant <name> - put a warrant on a player",
"/unwarrant <name> - remove a warrant of a player",
"/demote <name> - demote a player",
"/broadcast - send a message to all players"
}
Commands["Cop"] = {
"/request - send a request to mayor for a warrant",
"/radio - talk to other law enforcement officials"
}
Commands["Mobboss"] = {
"/hit - puts a hit out on mayor",
"/gang - talk to other gang members",
}
Commands["Gang"] = {
"/gang - talk to other gang members",
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
	draw.SimpleText("Help Darkland out!","ScoreboardSub",10,15,Color(0,0,0,255),0,1)
	draw.SimpleText("	Darkland is very expensive to run. Donations help cover the cost of running the server","Default",10,30,Color(0,0,0,255),0,1)
	draw.SimpleText("	We offer perks to donators who donate a certain amount at once. They last forever too.","Default",10,42,Color(0,0,0,255),0,1)
	draw.SimpleText("Premium - $5 USD","ScoreboardSub",10,80,Color(0,200,0,255),0,1)
	draw.SimpleText("Here are some of the benefits of Premium status:","Default",10,94,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Increased payroll (+25%). A 50$ payroll would get 62.50$ per payday with premium!","Default",10,106,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Max ban of 7 days","Default",10,118,Color(0,0,0,255),0,1)
	draw.SimpleText("	-AFK Kicker Immunity","Default",10,130,Color(0,0,0,255),0,1)
	
	local num = 160
	
	draw.SimpleText("Platinum - $15 USD","ScoreboardSub",10,num,Color(20,20,200,255),0,1)
	draw.SimpleText("Here are some of the benefits of Platinum status:","Default",10,num+14,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Increased payroll (+50%). A 50$ payroll would get 75$ per payday with platinum!","Default",10,num+26,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Max ban of 4 days","Default",10,num+38,Color(0,0,0,255),0,1)
	draw.SimpleText("	-AFK Kicker Immunity","Default",10,num+50,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Physgun","Default",10,num+62,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Prop Spawning","Default",10,num+74,Color(0,0,0,255),0,1)
	draw.SimpleText("	-Toolgun","Default",10,num+86,Color(0,0,0,255),0,1)
	
	num = 276
	
	draw.SimpleText("RP Cash - $1 USD = $10k ingame ","ScoreboardSub",10,num,Color(200,20,20,255),0,1)
	draw.SimpleText("Need some money for that new car? Donating can get you there faster","Default",10,num+14,Color(0,0,0,255),0,1)	
	end
	
	list:AddItem(p2)
	Panels["Menu"].Sheet:AddSheet("Donations",list,"gui/silkicons/heart",nil,nil,nil,6) 
end
--hook.Add("OnMenusCreated","CreateDonateTab",CreateDonateTab)