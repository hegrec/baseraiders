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

include("perks/sh_perks.lua")
include("perks/cl_perks.lua")
include("vgui/DCategoryCollapse2.lua")
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

surface.CreateFont("TerritoryTitle", {font='Arial', size=38, weight=600});

local function RandomString(len)
	local str = ""
	math.random(100)
	for i=1,len do
		str = str .. string.char(math.random(57)+65)
	end
	return str
end


	hook.Add("RenderScreenspaceEffects","test",--color
		function()
			if LocalPlayer():Health() <= BLOOD_EFFECT then 
				local frac = LocalPlayer():Health()/BLOOD_EFFECT
				local tab = {}
				tab[ "$pp_colour_addr" ] = math.max(0.1-frac*0.2,0)
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0-(0.3-frac)*0.5
				tab[ "$pp_colour_contrast" ] = 1
				tab[ "$pp_colour_colour" ] = 1
				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colour_mulb" ] = 0
				DrawColorModify( tab )
				DrawMotionBlur( math.max(0.1,frac*0.5), 0.5, 0.001) 
			end
		end)

function GM:Initialize()


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

	
	ShowMain()
	//GAMEMODE:SetPlayerSpeed(Me,WALK_SPEED,RUN_SPEED)
	LocalPlayer():SetWalkSpeed(WALK_SPEED);
	LocalPlayer():SetRunSpeed(RUN_SPEED);
	//Get dizzy and stuff near death
	RunConsoleCommand("player_ready")
	
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

	local radius = 100
	local cx,cy = 110,h-110
	surface.SetDrawColor(255,255,255,255)
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
		if !territories[i].OwnerGangName then
			color = Color(200,200,200,255)
		elseif (territories[i].OwnerGangID == LocalPlayer():GetGangID()) then
			color = Color(0,200,0,255)
		elseif (territories[i].ContesterGangID) then
			color = Color(200,200,0,255)
		elseif (territories[i].OwnerGangID != 0) then
			color = Color(200,0,0,255)
		end
		
		
		
		draw.SimpleTextOutlined(str,"ScoreboardSub",px,py,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,3,Color(0,0,0,255))
	end

	draw.SimpleTextOutlined("$"..GetMoney(),"g_Logo",215,ScrH()-5,Color(0,200,0,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,3,Color(0,0,0,255))
	if (LocalPlayer():GetGangName() != "") then
		draw.SimpleTextOutlined("Gang: "..LocalPlayer():GetGangName(),"HUDBars",215,ScrH()-50,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end
	if LocalPlayer():GetNWInt("TerritoryID") != 0 then
		local name = territories[LocalPlayer():GetNWInt("TerritoryID")].Name
		draw.SimpleTextOutlined(name,"HUDBars",215,ScrH()-80,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	else
		draw.SimpleTextOutlined("Public","HUDBars",215,ScrH()-80,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end
	draw.SimpleTextOutlined("Level: "..LocalPlayer():GetLevel(),"HUDBars",215,ScrH()-110,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))

	
	local nearby_ents = ents.FindInSphere(Me:GetShootPos(),300)
	
	for i,v in pairs(nearby_ents) do

		local pos = v:LocalToWorld(v:OBBCenter())
		local tr = {}
		tr.start = LocalPlayer():EyePos()
		tr.endpos = pos
		tr.filter = LocalPlayer()
		tr = util.TraceLine(tr)
		
		
		local tr2 = {}
		tr2.start = LocalPlayer():EyePos()
		tr2.endpos = v:GetPos()
		tr2.filter = LocalPlayer()
		tr2 = util.TraceLine(tr2)

		local tr3 = {}
		tr2.start = LocalPlayer():EyePos()
		tr2.endpos = v:LocalToWorld(v:OBBMaxs())
		tr2.filter = LocalPlayer()
		tr2 = util.TraceLine(tr2)

		local tr4 = {}
		tr2.start = LocalPlayer():EyePos()
		tr2.endpos = v:LocalToWorld(v:OBBMins())
		tr2.filter = LocalPlayer()
		tr2 = util.TraceLine(tr2)
		
		
		if tr.Entity == v or tr2.Entity == v  or tr3.Entity == v  or tr4.Entity == v then
			local text = ""
			local extra

			if (v:GetItemName() != "") then
				text = v:GetItemName()
				if GetItems()[text].ExtraHUD then
					extra = GetItems()[text].ExtraHUD
				end
			elseif v:IsPlayer() then
				text = v:Name()
				pos = v:GetPos()+Vector(0,0,72)
			elseif v:GetClass() == "power_socket" then
				text = v:GetNWInt("WattsAvailable").." Watts Left"
			elseif v:GetClass() == "money" then
				text = "$"..v:GetNWInt("Amount")
			elseif v:GetClass() == "vendingmachine" then
				text = "$5 Water Press USE"
			elseif v:GetClass() == "crafting_table" then
				text = "Crafting Table"
			elseif v:GetClass() == "smelting_furnace" then
				text = "Smelting Furnace"
			elseif v:GetClass() == "npc_generic" then

				text = v:GetNWString("NPCName")
			end
			local maxdist = 500
			pos = pos:ToScreen()
			local cx,cy = ScrW()/2,ScrH()/2
			local dist = math.sqrt((cx-pos.x)*(cx-pos.x)+(cy-pos.y)*(cy-pos.y))
			
			local alpha = math.min(255,(maxdist-dist)/maxdist*255)
			if !extra and extraHUDFuncs[v:GetClass()] then
				extra = extraHUDFuncs[v:GetClass()](v,pos,alpha)
			elseif extra then
				extra(v,pos,alpha)
			end

			draw.SimpleTextOutlined(text,"ScoreboardSub",pos.x,pos.y,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha))
			if v:IsPlayer()then
				local pppp = 65
				if v:GetGangName() != "" then
					local gangtext = "Gang: "..v:GetGangName()
					if v:GetGangLeader() then
						gangtext = gangtext .. " (Ldr)"
					end
					draw.SimpleTextOutlined(gangtext,"HUDBars",pos.x,pos.y-25,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha)) 					
				end			
			elseif v.IsPowered then
				local powered = v:IsPowered()
				if powered then
					draw.SimpleTextOutlined("Powered","HUDBars",pos.x,pos.y-20,Color(20,200,20,alpha),1,1,1,Color(0,0,0,alpha))
				else
					draw.SimpleTextOutlined("Unpowered","HUDBars",pos.x,pos.y-20,Color(200,20,20,alpha),1,1,1,Color(0,0,0,alpha))
				end
				local tbl = GetItems()[v:GetItemName()]
				if tbl and tbl.Watts then
					draw.SimpleTextOutlined(tbl.Watts.." Watts","Default",pos.x,pos.y-35,Color(200,200,20,alpha),1,1,1,Color(0,0,0,alpha))
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
	--Height()
end
queued_experience = queued_experience or {}


hook.Add("PostDrawTranslucentRenderables","queued_experiencereder",function()

	
	local i=1
	while (i<#queued_experience) do
		if (RealTime()-1>queued_experience[i]["StartTime"]) then
			table.remove(queued_experience,i)
		else
			i = i + 1
		end
	end


	for i,v in pairs(queued_experience) do
		local endtime = v["StartTime"]+1
		local frac = 1-math.min(1,math.max(0,(endtime-RealTime())/1))
		local pos = LerpVector(frac,v["StartPos"],v["StartPos"]+Vector(0,0,20))
		
		
		local xp = v["XP"]
		local txt = "+"..xp.."xp"
		local yaw = (v["StartPos"]-LocalPlayer():EyePos()):Angle().yaw-90
		local ang = Angle(0,yaw,90)
		cam.Start3D2D(pos, ang, 0.2)
			draw.SimpleTextOutlined(txt,"TerritoryTitle",0,0,Color(0,255,0,255-frac*255),1,1,1,Color(255,255,255,255-frac*255))
		cam.End3D2D()
	end
	
	local helpVec = Vector(320.968750, 4107.258301, 60.206669)
	local helpAng = Angle(0,-90,90)
	cam.Start3D2D(helpVec, helpAng, 1)
		draw.SimpleTextOutlined("Welcome to Baseraiders!","TerritoryTitle",0,0,Color(255,255,0,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(helpVec, helpAng, 0.5)
		draw.SimpleTextOutlined("Where you can form gangs and conquer new ground!","TerritoryTitle",0,50,Color(255,0,0,255),0,1,1,Color(255,255,255,255))
		draw.SimpleTextOutlined("Be sure to talk to all the NPCs in this building before leaving to explore","TerritoryTitle",0,100,Color(0,255,255,255),0,1,1,Color(255,255,255,255))
		draw.SimpleTextOutlined("Checkout the market downstairs as well","TerritoryTitle",0,150,Color(0,255,0,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Vector(124.595848, 2779.031250, 50.608318), Angle(0,180,90), 0.5)
		draw.SimpleTextOutlined("Press and hold C to access your inventory","TerritoryTitle",0,0,Color(255,255,255,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Vector(120.038223, 3402.968750, -71.685226), Angle(0,0,90), 0.5)
		draw.RoundedBox(0,-14,-10,425,50,Color(120,120,120))
		draw.SimpleTextOutlined("Baseraiders Market","TerritoryTitle",0,10,Color(0,255,255,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Vector(-315.968689, 2836.386230, 50.273762), Angle(0,90,90), 0.7)
		draw.SimpleTextOutlined("Join our community to post suggestions & ban requests","ScoreboardSub",0,0,Color(255,255,255,255),0,1,0,Color(255,255,255,255))
		draw.SimpleTextOutlined("CakeToast.com","TerritoryTitle",0,50,Color(255,255,255,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	
	cam.Start3D2D(Vector(-300.780121, 3409.968750, 45.953957), Angle(0,0,90), 0.4)
		draw.SimpleTextOutlined("You can click and drag items into your inventory","TerritoryTitle",0,0,Color(255,255,255,255),0,1,1,Color(255,255,255,255))
		draw.SimpleTextOutlined("while holding C if USE does not pick it up","TerritoryTitle",0,50,Color(255,255,255,255),0,1,1,Color(255,255,255,255))
		draw.SimpleTextOutlined("CakeToast.com","TerritoryTitle",260,250,Color(255,255,255,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Vector(-310.968750, 3231.679199, -35.755562), Angle(0,90,90), 0.5)
		draw.RoundedBox(0,-4,-1,370,50,Color(120,120,120))
		draw.SimpleTextOutlined("Baseraiders Bank","TerritoryTitle",40,20,Color(0,255,255,255),0,1,1,Color(255,255,255,255))
	cam.End3D2D()
	
end)
function GM:PostDrawTranslucentRenderables(bdepth,bsky)
	for i,v in pairs(territories) do
		if v.Label then
		
			local pos = v.LabelPos
			local ang = v.LabelAngle
			cam.Start3D2D(pos, ang, 0.6)
				v.Label()
			cam.End3D2D()
		end
	
	end

	
	

end
function queueEffect( um )
	local pos = um:ReadVector()
	local xp = um:ReadShort()
	local vip = um:ReadBool()
	if vip then xp = xp * 2 end
	local add = {}
	add["StartPos"] = pos
	add["XP"] = xp
	add["StartTime"] = RealTime()
	table.insert(queued_experience,add)
	
end
usermessage.Hook("experienceUp",queueEffect)


function GetPowerBoost()
	return GetGlobalInt("PowerBoost")
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