Stamina = 100
stopstaminaspawm = false

timer.Create("stamina_process",0.1,0,function() 
	if !IsValid(Me) || Me:InVehicle() then return end
	if !Me:Alive() then Stamina = 100 end
	
	if(Me:GetVelocity().z > 0 and Me:KeyDown(IN_JUMP))then
		Stamina = math.Clamp(Stamina - DECREASE_RATE * 2,0,100)
	elseif(Me:GetVelocity():Length() > 1)then
		if Me:KeyDown(IN_SPEED)then
			Stamina = math.Clamp(Stamina - DECREASE_RATE,0,100)
		else
			Stamina = math.Clamp(Stamina + INCREASE_RATE,0,100) 
		end
	else
		Stamina = math.Clamp(Stamina + INCREASE_RATE,0,100) 
	end
end)

function AddStaminaBar()
	local staminabar = vgui.Create("DPanel")
	staminabar:SetSize(300,16)
	staminabar.Paint = function() 
			if(!Me)then return end
			draw.RoundedBox(4,0,0,staminabar:GetWide(),staminabar:GetTall(),Color(0,0,0,150))
			if Stamina > 0 then
				draw.RoundedBox(4,2,2,math.Round(Stamina)/100*staminabar:GetWide()-4,staminabar:GetTall()-4,Color(50,50,255,255))
			end
			draw.DrawText(math.Round(Stamina).."/100","HUDBars",staminabar:GetWide()/2,-2,Color(255,255,255,255),1)
		end
	HUDBars:AddItem(staminabar)
end 
hook.Add("InitPostEntity","roflerstamleeatherbelt",function()

AddStaminaBar()

end)