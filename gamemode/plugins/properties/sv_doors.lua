 --not sure where to put this.....u find a spot.....args[1] is door's ent index

 function BuyDoor(ply,cmd,args)
	local ent = ents.GetByIndex(tonumber(args[1]))
	if(!IsValid(ent))then return end --who is fucking with the command....or who fucked up coding >.>
	
	if ent.DoorOwner && ent.DoorOwner != "" then ply:SendNotify("This door is already owned","NOTIFY_ERROR",4) return end --already owned by someone
	if ent:GetNWBool("Unownable") then ply:SendNotify("You can not own this door","NOTIFY_ERROR",4) return end --already owned by someone
	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector()*MAX_INTERACT_DIST
	tr.filter = ply
	tr = util.TraceLine(tr)
	if tr.Entity:IsValid() and tr.Entity == ent then
		local cost = ent:GetNWInt("Cost")
		if cost == 0 then cost = DEFAULT_DOOR_PRICE end
		
		if ply:GetMoney() < cost then 
			ply:SendNotify("You can not afford this item","NOTIFY_ERROR",4) 
			return 
		end
	
		ply:AddMoney(cost * -1)
		
		if ent:IsProperty() then GiveProperty(ply,ent) return end
		
		ent.DoorOwner = ply:SteamID()
		ent:SetNWBool("Bought",true)
		
		ply:SendNotify("You bought a door for $"..cost,"NOTIFY_GENERIC",4)
		
		ent:SetNWString("Title","Sold!")
		ply:GiveObject(ent)
		umsg.Start("boughtDoor",ply)
			umsg.Short(tonumber(args[1]))
		umsg.End()
	else
		ply:SendNotify("You are not facing this door","NOTIFY_ERROR",4)
	end
end
concommand.Add("buydoor",BuyDoor)

 --not sure where to put this.....u find a spot.....args[1] is door's ent index
function SellDoor(ply,cmd,args)
	local ent = ents.GetByIndex(tonumber(args[1]))
	if(!IsValid(ent))then return end --who is fucking with the command....or who fucked up coding >.>
	
	if(ent.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	local cost = ent:GetNWInt("Cost")
	if cost == 0 then cost = DEFAULT_DOOR_PRICE end
	
	ply:AddMoney(cost/2)
	if ent:IsProperty() then TakeProperty(ply,ent) return end
	
	ent.DoorOwner = ""
	ent.Roommates = {}
	
	ent:SetNWBool("Bought",false) --need to do this to let clients know about it before deleting it (setting to nil will not tell clients)
	timer.Simple(1,function() ent:SetNWBool("Bought",nil) end)
	ent:Fire("unlock","",0)
	ent:SetNWInt("Owner",0)
	ent:SetNWString("Owner","")
	timer.Simple(1,function() ent:SetNWInt("Owner",nil) ent:SetNWString("Owner",nil) end)
	
	RemoveObject(ent)
	ply:SendNotify("You sold a door for $"..(cost / 2),"NOTIFY_GENERIC",4)
	ent:SetLevel(1)
	
	ent:SetNWString("Title","For Rent")
	timer.Simple(1,function() ent:SetNWString("Title",nil) end)
	
	umsg.Start("soldDoor",ply)
		umsg.Short(tonumber(args[1]))
	umsg.End()
end
concommand.Add("selldoor",SellDoor)

 --not sure where to put this.....u find a spot.....args[1] is door's ent index,,,,args[2] is player to add
function AddRoommate(ply,cmd,args)
	local ent = ents.GetByIndex(tonumber(args[1]))
	if(!IsValid(ent))then return end
	

	
	local RM = GetBySteamID(args[2]) --roommate

	if(!RM)then return end

	
	if(ent.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	if ent.DoorOwner && ent.DoorOwner == RM:SteamID() then return end --this RM is actually the owner
	
	ent.Roommates = ent.Roommates or {}
	
	if table.HasValue(ent.Roommates,RM) then return end --this person is a RM
	
	table.insert(ent.Roommates,RM)
	
	umsg.Start("getRoommate",ply)
		umsg.Long(tonumber(args[2]))
	umsg.End()
	
	ply:SendNotify("You added a roommate to this door","NOTIFY_GENERIC",4)
end 
 concommand.Add("addroommate",AddRoommate)
 
  --not sure where to put this.....u find a spot.....args[1] is door's ent index,,,,args[2] is player to add
function RemoveRoommate(ply,cmd,args)
	local ent = ents.GetByIndex(args[1])
	if(!IsValid(ent))then return end
	
	if(ent.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	local RM = GetBySteamID(args[2]) --roommate //Replace GetByUserID with GetBySteamID, a global shared function.
	if(!IsValid(RM))then return end
	
	for k,v in pairs(ent.Roommates)do
		if(v == RM)then 
			table.remove(ent.Roommates,k)
			
			umsg.Start("loseRoommate",ply)
				umsg.Long(tonumber(args[2]))
			umsg.End()
		end
	end	
	ply:SendNotify("You removed a roommate from this door","NOTIFY_GENERIC",4)
end 
concommand.Add("removeroommate",RemoveRoommate)

function RequestRoommates(ply,cmd,args)

	local door = ents.GetByIndex(args[1])
	if !door then return end
	
	if(door.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	door.Roommates = door.Roommates or {}
	
	for i,v in pairs(door.Roommates) do
		if !IsValid(v) then 
			table.remove(door.Roommates,i)
		else
			umsg.Start("getRoommate",ply)
				umsg.Long(v:UserID())
			umsg.End();
		end
	end
end
concommand.Add("reqMates",RequestRoommates)
		
function ChangeDoorName(ply,cmd,args)
	local ent = ents.GetByIndex(tonumber(args[1]))
	if !IsValid(ent) then return end
	
	if args[2] == "" then return end
	if(ent.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	if ent:IsProperty() then return end
	ent:SetNWString("Title",args[2])	
	
	ply:SendNotify("You changed the title of this door","NOTIFY_GENERIC",4)
end 
 concommand.Add("changedoorname",ChangeDoorName)
 
local upgradecosts = {0,1000,1500,2000,2500}
function UpgradeDoor(ply, cmd, args)
	local ent = ents.GetByIndex(tonumber(args[1]))
	if !IsValid(ent) then return end
	
	if(ent.DoorOwner != ply:SteamID())then ply:SendNotify("You do not own this door! p.s. You are a cheater.","NOTIFY_ERROR",4) return end --you are not the owner of this door
	
	local lvl = ent:GetLevel()
	if(lvl >= 5)then
		ply:SendNotify("This door is already fully upgraded","NOTIFY_ERROR",4) 
		return
	end
	
	if ply:GetMoney() < upgradecosts[lvl + 1] then 
			ply:SendNotify("You can not afford to do this","NOTIFY_ERROR",4) 
			return 
	end
	
	ply:AddMoney(upgradecosts[lvl + 1] * -1)
	
	ent:SetLevel(lvl + 1)
	
	ply:SendNotify("You upgraded the locks on this door to level "..lvl + 1,"NOTIFY_GENERIC",4)
end
concommand.Add("upgradedoor",UpgradeDoor)
 
function DoorStripOwner(door)
	if door:IsProperty() then return end
 	door.DoorOwner = ""
	
	door:SetNWBool("Bought",false) --need to do this to let clients know about it before deleting it (setting to nil will not tell clients)
	timer.Simple(1,function() door:SetNWBool("Bought",nil) end)
	door.Roommates = {}
	door:SetNWInt("Owner",0)
	door:SetNWString("Owner","")
	timer.Simple(1,function() door:SetNWInt("Owner",nil) door:SetNWString("Owner",nil) end)
	door:Fire("unlock","",0)
	door:SetLevel(1)
	
	door:SetNWString("Title","For Rent") --need to do this to let clients know about it before deleting it (setting to nil will not tell clients)
	timer.Simple(1,function() door:SetNWString("Title",nil) end)
end
AddRemoveFunction("func_door",DoorStripOwner)
AddRemoveFunction("func_door_rotating",DoorStripOwner)
AddRemoveFunction("prop_door_rotating",DoorStripOwner)

umsg.PoolString("For Rent") --optimization ftw
umsg.PoolString("Sold!")

hook.Add("InitPostEntity","NewDoor",function()
	LoadUnownables() --call here to allow better control of the NWVars
	for k,v in pairs(ents.GetAll())do
		if v:IsValid() then 
			if v:IsDoor() and !v:IsProperty() and !v:IsUnownable() then
				v:Fire("unlock","",0)
			end
		end
	end
end)