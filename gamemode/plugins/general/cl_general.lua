function breachHud(ent,pos,alpha)
	local timeLEft = math.max(0,ent:GetExplodeTime()- CurTime())
	
	draw.SimpleTextOutlined(math.floor(timeLEft),"TerritoryTitle",pos.x,pos.y-40,Color(255,0,0,alpha),1,1,1,Color(255,255,255,255))

end
AddCustomHUD("breach_charge",breachHud)