include("sh_perks.lua")

surface.CreateFont("ScoreboardSub", {font='coolvetica', size=32, weight=500})

function CreatePerksTab()
	local pnl = vgui.Create("DPanel")
	
	local lbl = Label("You have 0 perk points available to spend (COMING SOON, YOU WILL RECEIVE 1 POINT PER LEVEL WHEN THIS IS IMPLEMENTED)",pnl)
	lbl:SetPos(5,-15)
	lbl:SetTextColor(Color(0,0,0,255))
	lbl:SetFont("HUDBars")
	lbl:SetWrap(true)
	lbl:SetSize(600,70)

	local list = vgui.Create("DPanelList",pnl)
	list:SetSpacing(1)
	list:EnableVerticalScrollbar()
	list:SetPadding(7)
	list.Paint = function(s)
		draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),Color(50,50,50,255))
	end
	list:StretchToParent(5,50,5,5)
	pnl.PerformLayout = function(s)
		list:StretchToParent(5,50,5,5)
	end
	
	for i,v in pairs(GetPerkList()) do
		local p = vgui.Create("DPanel")
		p:SetTall(48)
		


		local nameLabel = Label(i,p)
		nameLabel:SetPos(5,5)
		nameLabel:SetFont("HUDBars")
		nameLabel:SetTextColor(Color(0,0,0,255))
		nameLabel:SizeToContents()
		local descriptionLabel = Label(v.description,p)
		descriptionLabel:SetPos(5,5)
		descriptionLabel:SetTextColor(Color(0,0,0,255))
		descriptionLabel:SetWrap(true)
		descriptionLabel:SetSize(300,50)

		local chooseBtn = vgui.Create("DButton",p)
		chooseBtn:SetPos(5,5)
		chooseBtn:SetText("Choose Perk")
		chooseBtn:SetTextColor(Color(0,0,0,255))
		chooseBtn:SetWrap(true)
		chooseBtn:SetSize(75,30)

		p.PerformLayout = function(ppp) descriptionLabel:SetWide(ppp:GetWide()-85) chooseBtn:SetPos(ppp:GetWide()-80) end
		list:AddItem(p)
	end
	
	Panels["Menu"].Sheet:AddSheet("Perks",pnl,"gui/silkicons/pill",nil,nil,nil,3) 
end
hook.Add("OnMenusCreated","CreatePerksTab",CreatePerksTab)