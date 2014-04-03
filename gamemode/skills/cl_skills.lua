include("sh_skills.lua")

surface.CreateFont("ScoreboardSub", {font='coolvetica', size=32, weight=500})

local Me = LocalPlayer();

Skills = {}
Levels = {}
for i,v in pairs(GetSkillList()) do
	Skills[i] = 0
	Levels[i] = 1
end



for i,v in pairs(GetSkillList()) do
	hook.Add(v.hookUsed,i.."Increase",
		function(pl)
			if pl != Me then return end
			Skills[i] = math.Clamp(Skills[i] + 1,0,GetSkillList()[i].getNeeded(Me))
		end
	)
end
	
usermessage.Hook("skillLeveled",function ( um )
	local skill = um:ReadString()
	Skills[skill] = 0
	Levels[skill] = Levels[skill]+1
	GAMEMODE:AddNotify("You have leveled your ("..skill..") skill! (Level "..Levels[skill]..")",NOTIFY_GENERIC,8)
	print("You have leveled your ("..skill..") skill! (Level "..Levels[skill]..")")
	surface.PlaySound("buttons/button9.wav")
end)

--Sent upon joining the server
usermessage.Hook("skillSet",function( um ) Skills[um:ReadString()] = um:ReadLong() end)
usermessage.Hook("levelSet",function( um ) Levels[um:ReadString()] = um:ReadChar() end)

function CreateSkillsTab()
	local list = vgui.Create("DPanelList")
	list:SetSpacing(1)
	list:SetPadding(7)
	for i,v in pairs(GetSkillList()) do
		local p = vgui.Create("DPanel")
		p:SetTall(64)
		p.Paint = 
		function() 
			draw.RoundedBox(6,0,0,p:GetWide(),p:GetTall(),Color(80,80,80,255))
			draw.SimpleText(i,"ScoreboardSub",p:GetWide()-5,15,Color(220,20,20,255),2,1)
			draw.SimpleText("Level "..Levels[i],"ScoreboardSub",5,15,Color(220,20,20,255),0,1)
			local xpneeded = v.getNeeded(LocalPlayer())
			draw.SimpleText(Skills[i].."/"..xpneeded,"Default",p:GetWide()-5,30,Color(0,0,0,255),2,1)
			
			
			draw.RoundedBox(2,5,p:GetTall()-20,p:GetWide()-10,15,Color(10,10,10,255))
			if Skills[i] > 0 then
				draw.RoundedBox(2,7,p:GetTall()-18,Skills[i]/xpneeded*p:GetWide()-14,11,Color(255,255,10,255))
			end
		end
		list:AddItem(p)
	end
	
	Panels["Menu"].Sheet:AddSheet("Skills",list,"gui/silkicons/pill",nil,nil,nil,3) 
end
hook.Add("OnMenusCreated","CreateSkillsTab",CreateSkillsTab)