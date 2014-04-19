function AddStamToPly(ply)
	ply.Stamina = 100
	ply.stopstaminaspawm = falsed
end
hook.Add("PlayerInitialSpawn","stamina_plyspawn",AddStamToPly)
timer.Create("stamina_process",0.1,0,function() 
	for k,v in pairs(player.GetAll())do
		if(!v:Alive())then v.Stamina = 100 end
		if v:InVehicle() then break end
		if v:GetVelocity().z > 0 and v:KeyDown(IN_JUMP) then 
			v.Stamina = math.Clamp(v.Stamina - DECREASE_RATE * 2,0,100)
		end
		
		if v:GetVelocity():Length() > 1 and v:KeyDown(IN_SPEED) then
			v.Stamina = math.Clamp(v.Stamina - DECREASE_RATE,0,100)
		else
			if ( v:GetNWInt("adrenaline_end")>CurTime()) then
				v.Stamina = math.Clamp(v.Stamina + INCREASE_RATE*10,0,100) 
			else
				v.Stamina = math.Clamp(v.Stamina + INCREASE_RATE,0,100) 
			end
		end
		
											
		if(v.Stamina <= 0) then 							
			if(!v.stopstaminaspawm)then
				v:SetRunSpeed(WALK_SPEED)
				v.stopstaminaspawm = true
			end
		else
			if(v.stopstaminaspawm)then
				v:SetRunSpeed(RUN_SPEED+v:GetSkillLevel("Stamina")*2)
				v.stopstaminaspawm = false
			end
		end
	end
end)
