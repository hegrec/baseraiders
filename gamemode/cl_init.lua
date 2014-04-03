function IncludePlugins(dir)
	MsgN("Starting to include CL Plugins!");
	local fil, Folders = file.Find(dir.."*", "LUA")
	MsgN("Total: ", table.Count(Folders));
	
	for k,v in pairs(Folders)do
		if(v != "." and v != "..")then
			local Files = file.Find(dir..v.."/*.lua", "LUA");
			
			for q,w in pairs(Files) do
				include("plugins/"..v.."/"..w)
			end
		end
	end
end

--Include em'
include("cl_notify.lua")
include("obj_player_extend.lua")
include("obj_entity_extend.lua")
include("shared.lua")
include("cl_menus.lua")
include("cl_hud.lua")
include("cl_inventory.lua")

include("items/sh_itemdefines.lua")


include("npcchat/cl_conversation.lua")

include("skills/sh_skills.lua")
include("skills/cl_skills.lua")

include("vgui/DColorMixerNoAlpha.lua")
include("vgui/DMultiModelPanel.lua")
include("vgui/DHorizontalScroller2.lua")
include("vgui/DPropertySheet2.lua")
include("vgui/DScrollPanel2.lua")

include( 'cl_scoreboard2.lua' )

--Declare em'
util.PrecacheModel("models/darkland/human/male/darkland_male_01.mdl")

debugoverlay = nil

surface.CreateFont("g_Logo", {font="Arial", size=36, weight=1000});
surface.CreateFont("HUDNames", {font='Arial', size=22, weight=1000});
surface.CreateFont("HUDBars", {font='Arial', size=18, weight=600});



local function RandomString(len)
	local str = ""
	math.random(100)
	for i=1,len do
		str = str .. string.char(math.random(57)+65)
	end
	return str
end

local function LoadColor()
	ColorName = RandomString(math.random(5,32))
	hook.Add("RenderScreenspaceEffects",ColorName,--color
		function()
			if LocalPlayer():Health() <= BLOOD_EFFECT then 
				local frac = LocalPlayer():Health()/BLOOD_EFFECT
				local tab = {}
				tab[ "$pp_colour_addr" ] = math.max(0.2-frac*0.2,0)
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0-(1-frac)*0.5
				tab[ "$pp_colour_contrast" ] = 1
				tab[ "$pp_colour_colour" ] = 1
				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colour_mulb" ] = 0
				DrawColorModify( tab )
				DrawMotionBlur( math.max(0.1,frac*0.5), 0.99, 0.006) 
			end
		end
	)
end

local function LoadHeartBeat()
 	HeartBeatName = RandomString(math.random(5,32))
	hook.Add("Think",HeartBeatName, --heartbeat
		function()
			if(LocalPlayer():Health() > BLOOD_EFFECT)then--they aren't hurt enough
				if(NextBeat)then NextBeat = nil end
				return
			end 
			if(LocalPlayer():Health() <= 0)then--they died
				if(NextBeat)then NextBeat = nil end
				return
			end 
			if(NextBeat and SysTime() >= NextBeat)then
				LocalPlayer():EmitSound("darklandrp/heartbeat.wav",100,100) --why the fuck does this loop?!
				NextBeat = nil
			elseif(!NextBeat)then
				NextBeat = (LocalPlayer():Health() * 3 / BLOOD_EFFECT) + 2 + SysTime()--length of heartbeat
			end
		end
	)
end
function GM:Initialize()
	HUDMessages = {}

	BLOOD_EFFECT = 30
	Money = 0
	Model = nil
	NextBeat = nil
	Panels = {};


end
local getinfo = debug.getinfo
--Gamemode done and you have spawned
function GM:InitPostEntity()
	
	Me = LocalPlayer();

	
	Panels["Menu"] = vgui.Create("Menu")
	hook.Call("OnMenusCreated",GAMEMODE) //Allow for menu plugins to be called at the right time
	//GAMEMODE:SetPlayerSpeed(Me,WALK_SPEED,RUN_SPEED)
	LocalPlayer():SetWalkSpeed(WALK_SPEED);
	LocalPlayer():SetRunSpeed(RUN_SPEED);
	//Get dizzy and stuff near death
	
	LoadColor()
	LoadHeartBeat()
	RunConsoleCommand("player_ready")
	
end

local meta = FindMetaTable("Player")
function meta:HasItem(index)
	return Inventory[index] && Inventory[index] > 0
end

function TW(s,f)
	surface.SetFont(f)
	local w = surface.GetTextSize(s)
	return w
end 

local extraHUDFuncs = {}
function AddCustomHUD(class,func)
	extraHUDFuncs[class] = func
end
function GM:HUDPaint()
	if !Me then return end
	GAMEMODE:PaintNotes()
	local w = ScrW()
	local h = ScrH()
	
	local radius = 140
	local cx,cy = w-150,h-150
	surface.SetTexture(surface.GetTextureID("baseraiders/minimap"))
	surface.DrawTexturedRect(cx-radius,cy-radius,radius*2,radius*2)
	for i,v in pairs(territories) do
		
		local pos = (v.Min+v.Max)/2
		local yaw = LocalPlayer():GetAngles().yaw
		local vDir = pos-LocalPlayer():GetPos()
		local dist = vDir:Length()
		vDir:Normalize()
		vDir:Rotate(Angle(0,180-yaw,0))
		local theta = math.atan2(vDir.y,vDir.x)
		
		local str = ""
		local words = string.Explode(" ",v.Name)
		for ii,vv in pairs(words) do
			str = str .. string.sub(vv,1,1)
		end

		

		local multiplier = math.min(radius-20,dist/2)
		px = cx+(math.sin(theta) * multiplier)
		py = cy+(math.cos(theta) * multiplier)

		
		local color = Color(200,200,200,255)
		if GetGlobalInt("t_owner_id_"..i) == 0 then
			color = Color(200,200,200,255)
		elseif (GetGlobalInt("t_owner_id_"..i) == LocalPlayer():GetNWInt("GangID")) then
			color = Color(0,200,0,255)
		elseif (GetGlobalInt("t_contester_id_"..i) != 0) then
			color = Color(200,200,0,255)
		elseif (GetGlobalInt("t_owner_id_"..i) != 0) then
			color = Color(200,0,0,255)
		end
		
		
		
		draw.SimpleTextOutlined(str,"g_Logo",px,py,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,3,Color(0,0,0,255))
	end
	draw.SimpleTextOutlined("$"..GetMoney(),"g_Logo",ScrW()-305,ScrH()-5,Color(0,200,0,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,3,Color(0,0,0,255))
	
	
	local nearby_ents = ents.FindInSphere(Me:GetShootPos(),500)
	
	for i,v in pairs(nearby_ents) do
		local tr = {}
		tr.start = LocalPlayer():EyePos()
		tr.endpos = v:GetPos()
		tr.filter = LocalPlayer()
		tr = util.TraceLine(tr)
		if tr.Entity == v then
			local text = ""
			local extra = function() end
			if (v:GetNWString("ItemName") != "") then
				text = v:GetNWString("ItemName")
				if GetItems()[text].ExtraHUD then
					extra = GetItems()[text].ExtraHUD
				end
			elseif extraHUDFuncs[v:GetClass()] then
				extra = extraHUDFuncs[v:GetClass()]
			elseif v:IsPlayer() then
				text = v:Name()
			elseif v:GetClass() == "power_socket" then
				text = v:GetNWInt("WattsAvailable").." Watts Left"
			elseif v:GetClass() == "money" then
				text = "$"..v:GetNWInt("Amount")
			end
			local maxdist = 500
			local pos = (v:GetPos()+Vector(0,0,v:OBBMaxs().z)):ToScreen()
			local cx,cy = ScrW()/2,ScrH()/2
			local dist = math.sqrt((cx-pos.x)*(cx-pos.x)+(cy-pos.y)*(cy-pos.y))
			
			local alpha = math.min(255,(maxdist-dist)/maxdist*255)
			extra(v,pos,alpha)
			if v != Me then
				draw.SimpleTextOutlined(text,"ScoreboardSub",pos.x,pos.y,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha))
				if (v:IsPlayer() and v:GetNWString("GangName") != "") then
					draw.SimpleTextOutlined("Gang: "..v:GetNWString("GangName"),"ScoreboardSub",pos.x,pos.y-20,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha))
				elseif v:GetClass() == "darkland_light" then
					local powered = v:IsPowered()
					if powered then
						draw.SimpleTextOutlined("Powered","HUDBars",pos.x,pos.y-20,Color(20,200,20,alpha),1,1,1,Color(0,0,0,alpha))
					else
						draw.SimpleTextOutlined("Unpowered","HUDBars",pos.x,pos.y-20,Color(200,20,20,alpha),1,1,1,Color(0,0,0,alpha))
					end
				elseif v:GetClass() == "weed_plant" then
					local amt = v:GetLightAmount()
					if amt == 0 then
						draw.SimpleTextOutlined("No light","HUDBars",pos.x,pos.y-20,Color(200,20,20,alpha),1,1,1,Color(0,0,0,alpha))
					else
						if amt == 1 then
							draw.SimpleTextOutlined("Dim light","HUDBars",pos.x,pos.y-20,Color(200,200,20,alpha),1,1,1,Color(0,0,0,alpha))
						elseif amt == 2 then
							draw.SimpleTextOutlined("Good light","HUDBars",pos.x,pos.y-20,Color(20,200,200,alpha),1,1,1,Color(0,0,0,alpha))
						elseif amt == 3 then
							draw.SimpleTextOutlined("Perfect light","HUDBars",pos.x,pos.y-20,Color(20,200,20,alpha),1,1,1,Color(0,0,0,alpha))
						end
						local charge_per = math.min(1,v:GetGrowthPercentage()/100)
					
						draw.RoundedBox(0,pos.x-100,pos.y-60,200,8,Color(0,0,0,alpha))
						draw.RoundedBox(0,pos.x-98,pos.y-58,charge_per*(200-4),8-4,Color(50,200,50,alpha))
					end
				end
			end
		end
	end
	local tr = LocalPlayer():EyeTrace(MAX_INTERACT_DIST*3)
	
	if tr.Entity:IsValid() then
		if(tr.Entity:GetClass() == "prop_physics")then
			local str = "Owner: Unknown"
			local pl = GetBySteamID(tr.Entity:GetNWString("Owner"))
			if pl then str = "Owner: "..pl:Name() end
			draw.RoundedBox(6,ScrW()*0.5-100,ScrH()-20,200,20,Color(0,0,0,200))
			draw.SimpleText(str,"ScoreboardSub",ScrW()*0.5,ScrH()-10,Color(255,255,255,255),1,1)
		end
	end

	if(tr.Entity:IsValid() and HUDMessage(tr.Entity:GetClass()) != "")then
		local dpos = tr.Entity:LocalToWorld(tr.Entity:OBBCenter()):ToScreen()
		local col = Color(20,255,20,255)
		draw.SimpleTextOutlined(HUDMessage(tr.Entity:GetClass()),"ScoreboardSub",dpos.x,dpos.y+20,Color(20,0,20,255),1,1,1,col)
	end	
	--Height()
end
--TODO: USE THIS SYSTEM FOR MODULES TO RELIEVE THE HUDPAINT ABOVE
function HUDMessage(entclass)
	if(HUDMessages[entclass])then return HUDMessages[entclass] end
	return ""
end

function GM:PostDrawOpaqueRenderables(bdepth,bsky)


	local pos = territories[1].PowerLabel
	
	local ang = Angle(0,-90,90)
	cam.Start3D2D(pos, ang, 0.6)
	draw.SimpleText("Power Plant","Billboard",0,0,Color(255,255,255,255),1)
	draw.RoundedBox(0,0,30,500,30,Color(0,0,0,255))
	local powerboost = GetPowerBoost()
	local maxboost = MAX_WOOD_BOOST*WOOD_BOOST
	local maxpower = BASE_POWER+maxboost
	
	local maxsize = 500-4
	
	local power = BASE_POWER+powerboost
	local percentage = power/maxpower
	
	
	
	draw.RoundedBox(0,2,32,maxsize*percentage,26,Color(200,0,0,255))
	draw.SimpleText(power.."/"..maxpower.." KW","Billboard",10,32,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
	cam.End3D2D()
	
	
end
function GetPowerBoost()
	return GetGlobalInt("PowerBoost")
end
function AddHUDMessage(entclass,msg)
	HUDMessages[entclass] = msg
end

function GM:HUDShouldDraw(name)
	if (name == "CHudHealth" or name == "CHudBattery") then
		return false
	else
		return true
	end
end

--Don't turn it off if other stuff is going on.
function gui.SafeTurnOff()
	if Panels["Property"] then return end
	gui.EnableScreenClicker(false)
end

function draw.BlackOut(x,y,width,height)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect(x,y,width ,height)
	surface.DrawOutlinedRect(x-1,y-1,width + 2,height + 2)
	surface.DrawOutlinedRect(x+1,y+1,width - 2,height - 2)
end

function surface.GetTextWidth(text,font)
	surface.SetFont(font)
	local w = surface.GetTextSize(text)
	return w
end

TW = surface.GetTextWidth
GTW = TW
function surface.GetTextHeight(text,font)
	surface.SetFont(font)
	local w,h = surface.GetTextSize(text)
	
	return h
end
TH = surface.GetTextHeight


function HasLineOfSight(v)
	local tr = LocalPlayer():GetEyeTrace();
	
	if tr.Entity == v then return true end
	return false
end

local HintList = {
InventoryHelp = "You can open your character's inventory with F2",
NeedACar = "Looking for a faster way to travel? Explore the map and you may find someone who can help"
}

function messageBox( um )
	gui.EnableScreenClicker(true)
	Derma_Message( um:ReadString(), "Alert!", "OK" )
end
usermessage.Hook("messageBox",messageBox)

function RecvMoney( um )
	Money = um:ReadLong()
end
usermessage.Hook("money",RecvMoney)

function GetMoney()
	return Money
end

function RecvModel( um )
	Model = um:ReadString()
end
usermessage.Hook("sendmodel",RecvModel)

function GetModel()
	return Model
end

IncludePlugins("wod/gamemode/plugins/") -- load last