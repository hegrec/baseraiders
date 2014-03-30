hook.Add("PlayerInitialSpawn","GiveTbl",function(pl) pl.AmmoReserves = {} pl.AmmoClips = {} end)
function UseGun(pl,cmd,args)
	if(!pl:Alive())then return end
	local posX = tonumber(args[1])
	local posY = tonumber(args[2])
	print(posX,posY)
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
	pl.holstertime = CurTime()
	pl:SelectWeapon(tbl.SWEPClass)
	wep.CanPutAway = true
	wep.WepType = index
	
end
concommand.Add("use_gun",UseGun)

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
	if(pl.holstertime + 2 > CurTime())then pl:SendNotify("You can't put that away yet","NOTIFY_ERROR",4) return end
	pl:GiveItem(w.WepType,1,true)
	local t = GetItems()[w.WepType].Ammo
	if t then
		pl.AmmoReserves[t] = pl:GetAmmoCount(t);
		pl.AmmoClips[w:GetClass()] = w:Clip1();
	end
	pl:StripWeapon(w:GetClass())
end
AddChatCommand("putaway",PutAway)
AddChatCommand("holster",PutAway)
DEFAULT_RESERVE = 10 --this is ten bulks of each gun and regens every 10 minutes, This creates demand and players will buy guns from other players


local gunReserves = {}
function CreateGunReserve()	
	local str = file.Read("darklandrp/guns/gunreserves.txt", "DATA")
	if !str then
		
		for i,v in pairs(GetItems()) do
			if v.Group == "Weapons" || v.Group == "Ammo" then
				gunReserves[i] = DEFAULT_RESERVE
			end
		end
	else
		local t = table.ToLoad(str)
		for i,v in pairs(GetItems()) do
			if v.Group == "Weapons" || v.Group == "Ammo" then
				local amt = DEFAULT_RESERVE
				for ii,vv in pairs(t) do
					if ii == i then
						amt = tonumber(vv)
						break
					end
				end
				gunReserves[i] = amt
			end
		end		
	end
end

hook.Add("Initialize","CreateGunReserve",CreateGunReserve)

function ReUpReserve()
	for i,v in pairs(gunReserves) do
		gunReserves[i] = math.min(gunReserves[i]+1,DEFAULT_RESERVE)
	end
end
timer.Create("upgunReserve",300,0,ReUpReserve)
		
function OpenWeaponMenu(pl)
	umsg.Start("weaponMenu",pl)
	umsg.End()
end
function BuyWeapon(pl,cmd,args)

	local WepT = GetItems()[args[1]]
	if !WepT || !pl:CanReach(pl.lastTalkEnt) || pl.lastTalkEnt:GetName() != "Weapon Dealer" || (WepT.Group != "Weapons" && WepT.Group != "Ammo") then return end --make sure you should be able to buy this
	if WepT.BulkPrice > pl:GetMoney() then pl:SendNotify("You can not afford those weapons!","NOTIFY_ERROR",4) return end
	if gunReserves[args[1]] < 1 then pl:SendNotify("Sorry man, I am all out of those","NOTIFY_ERROR",4) return end
	if !pl:GiveItem(args[1],WepT.BulkAmt) then return end
	pl:AddMoney(WepT.BulkPrice * -1)
	gunReserves[args[1]] = gunReserves[args[1]] - 1
	file.Write("darklandrp/guns/gunreserves.txt",table.ToSave(gunReserves))

end
concommand.Add("buygun",BuyWeapon)





local weps = {}
weps.seller = nil

function weps.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!weps.seller)then 
		weps.seller =  ents.Create("npc_generic")
		weps.seller:Spawn()
	end 
	
	weps.seller:SetModel("models/Eli.mdl")
	weps.seller:SetNPCName("Weapon Dealer")
	weps.seller:SetPos(ply:GetPos())
	weps.seller:SetAngles(ply:GetAngles())
	weps.seller:EnableChat()
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/guns/seller/"..game.GetMap()..".txt",str)
end
AddChatCommand("setgunseller",weps.SetSeller)

function weps.LoadSeller()
	if file.Exists("darklandrp/guns/seller/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/guns/seller/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		
		weps.seller =  ents.Create("npc_generic")

		weps.seller:SetModel("models/Eli.mdl")
		weps.seller:SetNPCName("Weapon Dealer")
		weps.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		weps.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6])) //It is an AimVector
		weps.seller:Spawn()
		weps.seller:EnableChat()
	end
end
hook.Add("InitPostEntity","LoadGunSeller",weps.LoadSeller)