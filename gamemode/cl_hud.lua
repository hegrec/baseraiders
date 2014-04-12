HUDBars = vgui.Create("DPanelList")
HUDBars:SetAutoSize(true) 
HUDBars:SetDrawBackground(false) 
HUDBars:SetWidth(300)
HUDBars:SetSpacing(5)

function createHud()
	HUDBars:SetPos(ScrW() - HUDBars:GetWide() - 5, 5)

	
end

function AddBarHealth()
	
	local healthbar = vgui.Create("DPanel")
	healthbar:SetSize(300,16)
	healthbar.Paint = function() 
			if(!Me)then return end
			local hp = math.Clamp(Me:Health(),0,100)
			draw.RoundedBox(0,0,0,healthbar:GetWide(),healthbar:GetTall(),Color(0,0,0,150))
			if hp > 0 then
				draw.RoundedBox(4,2,2,hp/100*healthbar:GetWide()-4,healthbar:GetTall()-4,Color(255,50,50,255))
			end
			draw.DrawText(hp.."/"..level_experience[LocalPlayer():GetLevel()+1],"HUDBars",healthbar:GetWide()/2,-2,Color(255,255,255,255),1)
		end
	HUDBars:AddItem(healthbar)
end

function AddBarXP()
	
	local xpbar = vgui.Create("DPanel")
	xpbar:SetSize(300,16)
	xpbar.Paint = function() 
			local frac = 1
			if level_experience[LocalPlayer():GetLevel()+1] then
				frac = CalculateExperienceThisLevel(LocalPlayer():GetExperience())/level_experience[LocalPlayer():GetLevel()+1]
			end
			draw.RoundedBox(0,0,0,xpbar:GetWide(),xpbar:GetTall(),Color(0,0,0,150))
			if frac > 0 then
				draw.RoundedBox(4,2,2,frac*xpbar:GetWide()-4,xpbar:GetTall()-4,Color(200,200,50,255))
			end
			if level_experience[LocalPlayer():GetLevel()+1] then
				draw.DrawText(CalculateExperienceThisLevel(LocalPlayer():GetExperience()).."/"..level_experience[LocalPlayer():GetLevel()+1].."xp","HUDBars",xpbar:GetWide()/2,-2,Color(255,255,255,255),1)
			else
				draw.DrawText("You have reached max level","HUDBars",xpbar:GetWide()/2,-2,Color(255,255,255,255),1)
			end
		end
	HUDBars:AddItem(xpbar)
end
 
if (!IsValid(Me)) then
	timer.Create("LoadbarsWhenPlayerReady", 0.001, 0, function()
		if (IsValid(Me)) then
			timer.Destroy("LoadbarsWhenPlayerReady");
			createHud()
			AddBarHealth()
			AddBarXP()
		end
	end)
end