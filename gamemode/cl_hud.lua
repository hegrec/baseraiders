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
			draw.DrawText(hp.."/100","HUDBars",healthbar:GetWide()/2,-2,Color(255,255,255,255),1)
		end
	HUDBars:AddItem(healthbar)
end

if (!IsValid(Me)) then
	timer.Create("LoadbarsWhenPlayerReady", 0.001, 0, function()
		if (IsValid(Me)) then
			timer.Destroy("LoadbarsWhenPlayerReady");
			createHud()
			AddBarHealth()
		end
	end)
end