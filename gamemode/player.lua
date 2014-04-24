local meta = FindMetaTable("Player")

local saveamt
function meta:AddMoney(amt)
	if !self.Money then return end
	self.Money = math.max(self.Money + amt,0)
	saveamt = self.Money - self.InitMoney

	if(saveamt)then
		Query("UPDATE rp_playerdata SET Money=Money +"..saveamt.." WHERE SteamID='"..self:SteamID().."'")
	end
	self.InitMoney = self.Money
	SendMoney(self)
end

function meta:SetMoney(amt)
	self.InitMoney = amt
	self.Money = amt
	SendMoney(self)
end
function meta:SetExperience(s)
	local lvl = self:GetLevel()
	self:SetDTInt(1,s)
	self:TryLevelUp(lvl)
end
function meta:AddExperience(amt)

	local lvl = self:GetLevel()
	
	if self:IsVIP() then
		amt = amt * 2
	end
	
	self:SetExperience(self:GetExperience()+amt)
end
function meta:TryLevelUp(oldLevel)
	local lvl = self:GetLevel()
	if (oldLevel<lvl) then
		self:SendNotify("You have leveled up! You are now level "..self:GetLevel(),"NOTIFY_GENERIC",10)
		self:EmitSound("ambient/energy/whiteflash.wav")
		return
	end
end
function meta:SetGangID(s)
	self:SetDTInt(0,s)
end

function meta:SetNoteriety(s)
	self:SetDTInt(2,s)
end

function meta:AddNoteriety(s)
	self:SetDTInt(2,self:GetDTInt(2)+s)
	self.startDropNoteriety = CurTime()+15
	self:SendNotify("You have gained "..s.." noteriety for your actions","NOTIFY_GENERIC",2)
end
function g_reduceNoteriety()
 
	for i,v in pairs(player.GetAll()) do
		if (!v.startDropNoteriety || v.startDropNoteriety < CurTime()) then
			v:SetNoteriety(math.max(0,v:GetNoteriety()-1))
		end
	end
end
timer.Create("g_reduceNoteriety",5,0,g_reduceNoteriety)
function meta:SetGangLeader(s)
	self:SetDTBool(0,s)
end
function meta:SetHostileTo(plVictim)
	if (plVictim.HostileTo && plVictim.HostileTo[self:SteamID()]) || (self.HostileTo && self.HostileTo[plVictim:SteamID()]) then return end
	self:SendNotify("You are now hostile to "..plVictim:Name().." for the next 5 seconds","NOTIFY_GENERIC",6);
	self.HostileTo = self.HostileTo or {}
	self.HostileTo[plVictim:SteamID()] = CurTime()+5
	umsg.Start("setHostileToMe",plVictim)
		umsg.Entity(self)
	umsg.End()
	timer.Simple(5,function() 
		if (IsValid(self) && self.HostileTo[plVictim:SteamID()] && self.HostileTo[plVictim:SteamID()] < CurTime()) then
			self:SendNotify("You are no longer hostile to "..plVictim:Name(),"NOTIFY_GENERIC",6);
		
			self.HostileTo[plVictim:SteamID()] = nil

			umsg.Start("clearHostileToMe",plVictim)
				umsg.Entity(self)
			umsg.End()
		end

			end)
end
function meta:IsHostileTo(pl)
	return self.HostileTo && self.HostileTo[pl:SteamID()]
end
function meta:ClearHostility()
	self.HostileTo = self.HostileTo or {}
	for i,v in pairs(self.HostileTo) do
		umsg.Start("clearHostileToMe",i)
			umsg.Entity(self)
		umsg.End()
	end
	self.HostileTo = {}
end
function meta:SetGangName(s)
	self:SetDTString(0,s)
end

function meta:GetMoney()
	return self.Money
end

function meta:GetMoneyOffset()
	return self.Money - self.InitMoney
end

function SendModel(pl)
	umsg.Start("sendmodel",pl)
		umsg.String(pl.Model)
	umsg.End()
end

function SendMoney(pl)
	umsg.Start("money",pl)
		umsg.Long(pl.Money)
	umsg.End()
end

function meta:SendNotify(msg,type,len)
	SendNotify(self,msg,type,len)
end 

local NotifyTypes = {}
	NotifyTypes["NOTIFY_GENERIC"]		= 0
	NotifyTypes["NOTIFY_ERROR"]			= 1
	NotifyTypes["NOTIFY_UNDO"]			= 2
	NotifyTypes["NOTIFY_HINT"]			= 3
	NotifyTypes["NOTIFY_CLEANUP"]		= 4
function SendNotify(ply,msg,type,len)
	umsg.Start("SendNotify",ply)		
		umsg.String(msg)
		umsg.Short(NotifyTypes[type])
		umsg.Short(len)
	umsg.End()
end 

function meta:SendMessageBox(str)
	umsg.Start("messageBox",self)
		umsg.String(str)
	umsg.End()
end

--Object stuff
Owned = {}
RemoveFunctions = {}
function AddRemoveFunction(class,func)
	if(!RemoveFunctions[class])then
		RemoveFunctions[class] = func
	end
end

function meta:GiveObject(obj)
	Owned[self:SteamID()] = Owned[self:SteamID()] or {}
	Owned[self:SteamID()][obj] = true
	obj:SetNWString("Owner",self:SteamID())
end

function RemoveObject(obj)
	local steamid = obj:GetNWString("Owner")
	if IsValid(obj:GetOwn()) then obj:SetNWString("Owner","") end
	if !steamid || !Owned[steamid] then return end
	Owned[steamid][obj] = nil
	if table.Count(Owned[steamid]) < 1 then Owned[steamid] = nil end
	if(RemoveFunctions[obj:GetClass()])then
		RemoveFunctions[obj:GetClass()](obj,steamid)
	end
end

AddRemoveFunction("prop_physics",function(ent) ent:Remove() end)
AddRemoveFunction("gmod_cameraprop",function(ent) ent:Remove() end)
AddRemoveFunction("gmod_light",function(ent) ent:Remove() end)
AddRemoveFunction("gmod_lamp",function(ent) ent:Remove() end)
AddRemoveFunction("gmod_button",function(ent) ent:Remove() end)