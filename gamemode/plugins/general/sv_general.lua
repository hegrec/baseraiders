hook.Add("PlayerInitialSpawn","GiveTbl",function(pl) pl.AmmoReserves = {} pl.AmmoClips = {} end)
function UseGun(pl,cmd,args)
	if(!pl:Alive())then return end
	local posX = tonumber(args[1])
	local posY = tonumber(args[2])
	local index = pl:GetItem(posX,posY)
	if !index then return end
	local tbl = GetItems()[index]
	if !tbl then return end
	if pl:HasWeapon(tbl.SWEPClass) then return end --Don't waste them
	local t = {}
	t.start = pl:GetPos()+Vector(0,0,10)
	t.endpos = pl:GetPos()-Vector(0,0,10)
	t.filter = pl
	t = util.TraceLine(t)
	if IsValid(t.Entity) && t.Entity:GetClass() == "func_tracktrain" then pl:SendNotify("It is a sin to pull a weapon out in an elevator","NOTIFY_ERROR",5) return end
	pl:SelectWeapon("hands")
	local wep = pl:Give(tbl.SWEPClass)
	if tbl.Ammo then
		if !IsValid(wep) then return end
		pl:RemoveAmmo(pl:GetAmmoCount(tbl.Ammo),tbl.Ammo)
		wep:SetClip1(0)
		wep:SetClip2(1)
		local clipSize = wep.Primary.ClipSize
		
		if pl.AmmoReserves[tbl.Ammo] then 
		
		
			if pl.AmmoClips[tbl.SWEPClass] then
				wep:SetClip1(pl.AmmoClips[tbl.SWEPClass])
				pl:GiveAmmo(pl.AmmoReserves[tbl.Ammo],tbl.Ammo)
			else
				wep:SetClip1(clipSize)
				pl:GiveAmmo(pl.AmmoReserves[tbl.Ammo],tbl.Ammo)
			end
			
			
		else 
			wep:SetClip1(clipSize)
			pl:GiveAmmo(tbl.AmmoAmt-clipSize,tbl.Ammo) 
			
		end
	end
	pl.holstertime = CurTime()+2
	pl:SelectWeapon(tbl.SWEPClass)
	wep.CanPutAway = true
	wep.WepType = index
	
end
concommand.Add("use_gun",UseGun)


function HolsterGun(pl,cmd,args)

	local posX = tonumber(args[1])
	local posY = tonumber(args[2])
	local index = pl:GetItem(posX,posY)
	if !index then return end
	local tbl = GetItems()[index]
	if !tbl || !tbl.SWEPClass then return end
	if !pl:HasWeapon(tbl.SWEPClass) then return end --Don't waste them
	pl:StripWeapon(tbl.SWEPClass)
	pl:SelectWeapon("hands")

	
end
concommand.Add("holster_gun",HolsterGun)


function healthaugment(pl,cmd,args)
	
	
	local posX = tonumber(args[1])
	local posY = tonumber(args[2])
	local index = pl:GetItem(posX,posY)
	if !index then return end
	local tbl = GetItems()[index]
	if !tbl then return end
	if !tbl.CanHeal then return end
	if(!pl:Alive() || (pl:Health()>=100 && tbl.RestoreHP)) then return end
	pl:TakeItem(posX,posY)
	pl:EmitSound("items/medshot4.wav")
	if (tbl.RestoreHP) then
		pl:SetHealth( math.Clamp(pl:Health()+tbl.RestoreHP,0,100))
	else
		tbl.RestoreFunction(pl)
	end
end
concommand.Add("use_health",healthaugment)

function UseAmmo(pl,cmd,args)
	local index = table.concat(args," ")
	if !pl:HasItem(index) then return end
	local tbl = GetItems()[index]
	
	local t = {}
	t["Pistol Ammo"] = "pistol"
	t["Rifle Ammo"] = "SMG1"
	t["Shotgun Ammo"] = "buckshot"
	pl:GiveAmmo(60,t[index])
	pl:TakeItem(index)
end
concommand.Add("use_ammo",UseAmmo)

function PutAway(pl,txt,wep)
	local w = pl:GetActiveWeapon()
	if IsValid(wep) then w = wep end
	if !w.CanPutAway then pl:SendNotify("You can't put that into your inventory","NOTIFY_ERROR",4) return end
	if(pl.holstertime > CurTime())then pl:SendNotify("You can't put that away yet","NOTIFY_ERROR",4) return end
	local t = GetItems()[w.WepType].Ammo
	if t then
		pl.AmmoReserves[t] = pl:GetAmmoCount(t);
		pl.AmmoClips[w:GetClass()] = w:Clip1();
	end
	pl:StripWeapon(w:GetClass())
end
AddChatCommand("putaway",PutAway)
AddChatCommand("holster",PutAway)


function AlarmOff(pl,txt,wep)
	local alarms = ents.FindByClass("alarm_system")

	for i,v in pairs(alarms) do
		if v.pOwner == pl then
			v:AlarmOff()
		end
	end
	pl:SendNotify("Any alarms you have placed down have been reset and armed","NOTIFY_GENERIC",3)

end
AddChatCommand("alarmoff",AlarmOff)

function PlantBreachCharge(pl,cmd,args)
	
	local posX = tonumber(args[1])
	local posY = tonumber(args[2])
	local index = pl:GetItem(posX,posY)
	if !index then return end
	local tbl = GetItems()[index]
	if !tbl then return end
	if index != "Breach Charge" then return end
	local tr = pl:GetEyeTrace()
	local parEnt = tr.Entity
	if !pl:CanReach(parEnt) then return end
	if (parEnt:GetClass() == "prop_physics" or parEnt:IsDoor()) then
		local charge = ents.Create("breach_charge")
		charge:SetPos(tr.HitPos)
		charge:SetAngles(tr.HitNormal:Angle()+Angle(0,-90,0))
		charge:SetParent(parEnt)
		charge:Spawn()
	end



	pl:TakeItem(posX,posY)
end
concommand.Add("plant_charge",PlantBreachCharge)