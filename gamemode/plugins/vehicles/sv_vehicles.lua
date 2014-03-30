resource.AddFile("sound/vehicles/screech.mp3")
resource.AddFolder("sound/vehicles/small/")
resource.AddFolder("sound/vehicles/med/")
resource.AddFolder("sound/vehicles/massive/")
resource.AddFolder("sound/vehicles/muscle/")
--corvette
resource.AddFolder("models/corvette/")
resource.AddFolder("materials/corvette/")

--golf
resource.AddFolder("models/golf/")
resource.AddFolder("materials/golf/")


--new cars
resource.AddModel("models/Mustang")
resource.AddFolder("materials/models/lee/mustang/")

resource.AddModel("models/sickness/360spyder")
resource.AddFolder("materials/models/sickness/modena/")

resource.AddModel("models/sickness/hummer-h2")
resource.AddFolder("materials/models/sickness/hummerh2/")

resource.AddModel("models/sickness/1972markiv")
resource.AddFolder("materials/models/sickness/markiv/")

resource.AddModel("models/sickness/bmw-m5")
resource.AddFolder("materials/models/sickness/m5/")

resource.AddModel("models/sickness/lotus_elise")
resource.AddFolder("materials/models/sickness/elise/")

resource.AddModel("models/sickness/murcielago")
resource.AddMaterial("materials/models/sickness/0000")
resource.AddMaterial("materials/models/sickness/0001")
resource.AddMaterial("materials/models/sickness/00011")
resource.AddMaterial("materials/models/sickness/00021")
resource.AddMaterial("materials/models/sickness/00031")
resource.AddMaterial("materials/models/sickness/0004")
resource.AddMaterial("materials/models/sickness/0005")
resource.AddMaterial("materials/models/sickness/0006")
resource.AddMaterial("materials/models/sickness/0007")
resource.AddMaterial("materials/models/sickness/murcigla")
resource.AddMaterial("materials/models/sickness/murciglass")


--register the object
function RemoveJeep(jeep)
	jeep:Remove()
end
//AddRemoveFunction("prop_vehicle_jeep",RemoveJeep)

vehicles = {}
vehicles.positions = {}
vehicles.seller = nil

painter = {}
painter.positions = {}
painter.seller = nil

function vehicles.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!vehicles.seller)then 
		vehicles.seller =  ents.Create("npc_generic")
		vehicles.seller:SetNPCName("Big Bill")
		vehicles.seller:SetModel("models/odessa.mdl")
		vehicles.seller:Spawn()
	end 
	vehicles.seller:SetPos(ply:GetPos())
	vehicles.seller:SetAngles(ply:GetAngles())
	vehicles.seller:EnableChat()
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/vehicles/seller/"..game.GetMap()..".txt",str)
end
AddChatCommand("setcarseller",vehicles.SetSeller)

function vehicles.LoadSeller()
	if file.Exists("darklandrp/vehicles/seller/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/vehicles/seller/"..game.GetMap()..".txt", "DATA")

		local tbl = string.Explode(" ",str)
		vehicles.seller =  ents.Create("npc_generic")
		vehicles.seller:SetModel("models/odessa.mdl")
		vehicles.seller:SetNPCName("Big Bill")
		vehicles.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		vehicles.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6]))
		vehicles.seller:Spawn()
		vehicles.seller:EnableChat()
	end
end
hook.Add("InitPostEntity","LoadCarSeller",vehicles.LoadSeller)

function vehicles.AddSpawn(ply,args)
	if !ply:IsSuperAdmin() then return end
	local pos = ply:GetPos()
	local ang = ply:GetAngles()
	
	table.insert(vehicles.positions,{pos,ang})
	vehicles.SaveSpawns()
	ply:SendNotify("You added a spawnpoint for cars","NOTIFY_ERROR",4)
end
AddChatCommand("addvehiclespawn",vehicles.AddSpawn)


function vehicles.SaveSpawns()
	local t = {}
	for i,v in pairs(vehicles.positions) do
		local str = v[1].x .. " " .. v[1].y .. " " .. v[1].z .. " " .. v[2].pitch .. " " .. v[2].yaw .. " " .. v[2].roll
		table.insert(t,str)
	end
	local str = util.TableToKeyValues(t)
	file.Write("darklandrp/vehicles/spawns/"..game.GetMap()..".txt",str)
end

function vehicles.LoadSpawns()
	if file.Exists("darklandrp/vehicles/spawns/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/vehicles/spawns/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		for i,v in pairs(tbl) do
			local t = string.Explode(" ",v)
			table.insert(vehicles.positions,{Vector(t[1],t[2],t[3]),Angle(t[4],t[5],t[6])})
		end
	end
end
hook.Add("InitPostEntity","LoadVehicleSpawn",vehicles.LoadSpawns)

local Offsets = {}
Offsets["models/buggy.mdl"] = {Vector(16,-37,19)}
Offsets["models/corvette/corvette.mdl"] = {Vector(22, -20, 8)}
Offsets["models/golf/golf.mdl"] = {Vector(20, -6, 14),Vector(20, -55, 15),Vector(-20, -55, 15)}
Offsets["models/sickness/hummer-h2.mdl"] = {Vector(20, 16, 25),Vector(20, -25, 20),Vector(-20, -25, 20),Vector(0, -25, 20)}
Offsets["models/sickness/murcielago.mdl"] = {Vector(50, 0, 8)}
Offsets["models/sickness/360spyder.mdl"] = {Vector(20, 10, 7)}
Offsets["models/sickness/lotus_elise.mdl"] = {Vector(15, -10, 4)}
Offsets["models/sickness/1972markiv.mdl"] = {Vector(17, 0, 12),Vector(20, -35, 12),Vector(-20, -35, 12)}
Offsets["models/sickness/bmw-m5.mdl"] = {Vector(20, 0, 12),Vector(16, -35, 8),Vector(-16, -35, 8)}
Offsets["models/mustang.mdl"] = {Vector(20, -5, 15),Vector(16, -45, 15),Vector(-16, -45, 15)}

local meta = FindMetaTable("Vehicle")
function meta:MakePassengerSeat()
	local offset = Offsets[self:GetModel()][table.getn(self.PassengerSeats)+1]
	if !offset then return end
	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetAngles(self:GetAngles())
	ent:SetKeyValue("VehicleScript","scripts/vehicles/prisoner_pod.txt")
	ent:SetModel("models/nova/jeep_seat.mdl")
	ent.HandleAnimation = function(vec,ply) return ply:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) end,
	ent:SetPos(self:LocalToWorld(offset))
	ent:SetNoDraw(true)
	ent.IsPassSeat = true
	ent:Spawn()
	ent:SetParent(self)
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	table.insert(self.PassengerSeats,ent)
end

function SendCarMenu(pl)
	umsg.Start("carMenu",pl)
	umsg.End()
end

function SendPaintMenu(pl)
	umsg.Start("carPaintMenu",pl)
	umsg.Short(pl.Car:EntIndex())
	umsg.End()
end

function vehicles.CreatePlayerCar(ply,index)
	local skin = ply.Cars[index]
	local tbl = GetRPVehicleList()[index]
	if !tbl || !skin then return end --validate you have it and it is valid
	
	--check if they somehow have two cars..DELETE ONE BITCHES	
	if(Owned[ply:SteamID()])then
		for k,v in pairs(Owned[ply:SteamID()])do
			if(k:IsValid() && k:IsVehicle())then 
				k:Remove()
				k = nil
			end
		end
	end
	
	ply.Car = ents.Create(tbl.Class)
	ply.Car.Type = index
	ply.Car.PassengerSeats = {}
	ply.Car:SetModel(tbl.Model)
	
	ply.Car:SetKeyValue("VehicleScript",tbl.Script)
	ply.Car.CarOwner = ply:SteamID()
	ply.Car.Locked = true
	ply.Car.Passengers = {}
	ply.Car:Fire("lock","",0)
	ply.Car.ExitPoints = tbl.ExitPoints
	ply.Car.MaxPassengers = tbl.MaxPassengers
	ply.Car:SetNWString("Owner",ply:SteamID())
	ply:GiveObject(ply.Car)
	ply.Car:SetSkin(skin)
	local pos = vehicles.positions

	for i,v in pairs(pos) do
		if !ents.FindInSphere(v[1],100)[2] then
			ply.Car:SetPos(v[1]+Vector(0,0,20))
			ply.Car:SetAngles(v[2] + Angle(0,-90,0))
		end
	end
	
	ply.Car:Spawn()
	if Offsets[tbl.Model] then
		for i=1,#Offsets[tbl.Model] do
			ply.Car:MakePassengerSeat()
		end
	else
		print("Add offsets for model: "..tbl.Model)
	end
end

function ExitPointBlocked(pl,car,pos)
	local trdata = {}
	trdata.start = car:LocalToWorld(car:OBBCenter()+Vector(0,0,50))
	trdata.endpos = car:LocalToWorld(pos + Vector(-17,-17,0))
	trdata.filter = car
	local tr = util.TraceLine(trdata)

	if(DEVMODE)then
		pl:PrintMessage(HUD_PRINTTALK,"DEBUG: ExitPointBlocked Trace 2 dump")
		for k,v in pairs(tr)do
			pl:PrintMessage(HUD_PRINTTALK,tostring(k).." = "..tostring(v))
		end
	end
	if(tr.Hit)then return true end
	
	local trdata = {}
	trdata.start = car:LocalToWorld(car:OBBCenter()+Vector(0,0,50))
	trdata.endpos = car:LocalToWorld(pos + Vector(17,17,0))
	trdata.filter = car
	local tr = util.TraceLine(trdata)

	if(DEVMODE)then
		pl:PrintMessage(HUD_PRINTTALK,"DEBUG: ExitPointBlocked Trace 2 dump")
		for k,v in pairs(tr)do
			pl:PrintMessage(HUD_PRINTTALK,tostring(k).." = "..tostring(v))
		end
	end
	if(tr.Hit)then return true end

	local blockers = ents.FindInBox(car:LocalToWorld(pos + Vector(-17,-17,0)),car:LocalToWorld(pos + Vector(17,17,74)))
	if(DEVMODE)then
		pl:SendNotify("DEBUG: ExitPointBlocked EntsInBox dump","NOTIFY_ERROR",4)
		pl:SendNotify(tostring(#blockers),"NOTIFY_ERROR",4)
		for k,v in pairs(blockers)do
			pl:SendNotify(tostring(v),"NOTIFY_ERROR",4)
		end
	end
	
	for k,v in pairs(blockers)do
		if v != car and v != pl then
			return true
		end
	end
	return false
end

function GM:PlayerUse(ply,ent)
	if ent:GetClass() == "prop_vehicle_jeep" && ent:GetDriver():IsValid() then
		
		if ply.UseDown || (ply.NextCarUse && ply.NextCarUse > CurTime()) then return true end
		for i,v in pairs(ent.Passengers) do
			if !v:IsValid() then table.remove(ent.Passengers,i) end
		end
		local passengers = table.getn(ent.Passengers)+1
		if passengers < ent.MaxPassengers then 
			ply:EnterVehicle(ent.PassengerSeats[passengers])
			table.insert(ent.Passengers,ply)
			ply.InCar = ent.PassengerSeats[passengers]
		end
	end
	return true
end

function GM:KeyDown(ply,key)
	if key == IN_USE then ply.UseDown = true end
end

function GM:KeyRelease(ply,key)
	if key == IN_USE then ply.UseDown = false end
end

function GM:PlayerLeaveVehicle(ply,ent)
	if ent.IsPassSeat then 
		for i,v in pairs(ent:GetParent().Passengers) do
			if v == ply then
				table.remove(ent:GetParent().Passengers,i)
				
				break
			end
		end
	end
	local car = ent
	if(ent.IsPassSeat)then car = ent:GetParent() end
	if(car.ExitPoints)then
		for i=1,#car.ExitPoints do
			if !ExitPointBlocked(ply,car,car.ExitPoints[i]) then
				ply:SetPos(car:LocalToWorld(car.ExitPoints[i]))
				local ang = car:GetForward():Angle()
				ang.z = 0
				ply:SetEyeAngles(ang)
			end
		end
	end
	ply.NextCarUse = CurTime()+0.1
	return true
end

function BuyCar(pl,cmd,args)
	local index = args[1]
	local carTBL = GetRPVehicleList()[index]
	if !carTBL || IsValid(pl.Car) then return end
	if carTBL.Price > pl:GetMoney() then pl:SendNotify("You can not afford that vehicle!","NOTIFY_ERROR",4) return end
	if pl.Cars[index] then pl:SendNotify("You already own that vehicle. Go repaint it","NOTIFY_ERROR",4) return end
	pl.Cars[index] = 0 --they have skin 0
	pl:AddMoney(carTBL.Price * -1)
	Query("UPDATE rp_playerdata SET Vehicle='"..table.ToSave(pl.Cars).."' WHERE SteamID=\'"..pl:SteamID().."\'")
	vehicles.CreatePlayerCar(pl,index)
	umsg.Start("closeCarMenu",pl)
	umsg.End()
end
concommand.Add("buycar",BuyCar)


function painter.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!painter.seller)then 
		painter.seller =  ents.Create("npc_generic")
		painter.seller:EnableChat()
		painter.seller:SetNPCName("Big Al")
		painter.seller:SetModel("models/odessa.mdl")
		painter.seller:Spawn()
	end 
	painter.seller:SetPos(ply:GetPos())
	painter.seller:SetAngles(ply:GetAngles())
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/vehicles/painter/"..game.GetMap()..".txt",str)
end
AddChatCommand("setpaintseller",painter.SetSeller)

function painter.LoadSeller()
	if file.Exists("darklandrp/vehicles/painter/"..game.GetMap()..".txt", "DATA") then
	
		local str = file.Read("darklandrp/vehicles/painter/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		
		painter.seller =  ents.Create("npc_generic")
		painter.seller:SetNPCName("Big Al")
		painter.seller:SetModel("models/odessa.mdl")
		painter.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		painter.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6]))
		painter.seller:Spawn()
		painter.seller:EnableChat()
	end
end
hook.Add("InitPostEntity","LoadPainter",painter.LoadSeller)

function painter.AddSpawn(ply,args)
	if !ply:IsSuperAdmin() then return end
	local pos = ply:GetPos()
	table.insert(painter.positions,pos)
	painter.SaveSpawns()
	ply:SendNotify("You added a spawnpoint for paint spawns","NOTIFY_ERROR",4)
end
AddChatCommand("addpainterspawn",painter.AddSpawn)

function painter.SaveSpawns()
	local str = util.TableToKeyValues(table.Sanitise(painter.positions))
	file.Write("darklandrp/vehicles/spawns/"..game.GetMap().."_paint.txt",str)
end

function painter.LoadSpawns()
	if file.Exists("darklandrp/vehicles/spawns/"..game.GetMap().."_paint.txt", "DATA") then
		local str = file.Read("darklandrp/vehicles/spawns/"..game.GetMap().."_paint.txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		
		for i,v in pairs(table.DeSanitise(tbl)) do
			table.insert(painter.positions,v)
		end
	end
end
hook.Add("InitPostEntity","LoadPaintSpawn",painter.LoadSpawns)

function PaintCar(pl,cmd,args)
	if !IsValid(pl.Car) then return end
	if pl:GetMoney() < 5000 then pl:SendNotify("You can not afford a new paintjob!","NOTIFY_ERROR",4) return end
	
	local skinID = tonumber(args[1])
	local carTBL = GetRPVehicleList()[pl.Car.Type]
	
	if skinID < 0 || skinID > carTBL.SkinCount then return end
	
	local type = pl.Car.Type
	pl.Cars[type] = skinID
	pl.Car:Remove()
	pl.Car = nil
	
	pl:AddMoney(-5000)
	Query("UPDATE rp_playerdata SET Vehicle='"..table.ToSave(pl.Cars).."' WHERE SteamID=\'"..pl:SteamID().."\'")
	vehicles.CreatePlayerCar(pl,type)
	
end
concommand.Add("paintcar",PaintCar)

function GM:DAMPlayerKicked(ply)
	if(ply:InVehicle())then
		ply:ExitVehicle()
	end
end

function GM:DAMPlayerBanned(ply)
	if(ply:InVehicle())then
		ply:ExitVehicle()
	end
end

local refunds = {}
refunds[1] = 35000
refunds[2] = 35000
refunds[3] = 35000
refunds[4] = 105000
refunds[5] = 105000
refunds[6] = 105000
refunds[7] = 105000
refunds[8] = 105000
refunds[9] = 105000
refunds[13] = 105000
refunds[14] = 105000
refunds[15] = 105000
refunds[16] = 35000
refunds[17] = 35000
refunds[18] = 35000
refunds[22] = 35000
refunds[23] = 35000
refunds[24] = 35000
refunds[25] = 55000
refunds[26] = 55000
refunds[27] = 55000
refunds[28] = 55000
refunds[29] = 55000


function OnLoadVehicles(pl,str)
	if tonumber(str) then
		local amt = refunds[tonumber(str)]
		pl:AddMoney(amt)	
		Query("UPDATE rp_playerdata SET Vehicle='' WHERE SteamID='"..pl:SteamID().."'")
	else
		local t = table.ToLoad(str)
		local list = GetRPVehicleList()
		for i,v in pairs(t) do
			if list[i] then
				pl.Cars[i] = tonumber(v)
			end
		end
	end
end
hook.Add("OnLoadVehicles","laodupcars",OnLoadVehicles)