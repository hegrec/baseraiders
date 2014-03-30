local queue = {}
//surface.CreateFont("Comic Sans MS",72,700,true,false,"MarkerSans")
// WHY THE FUCK GOD DAMN FONTS I HATE YOU FUCKING COCK -crazyscouter

surface.CreateFont("MarkerSans", {font='Comic Sans MS', size=72, weight=700});

local function newArea( um )
	local str = um:ReadString()
	queue = {
	text = str,
	start = RealTime(),
	fadein = 2.5,
	fadeout = 5,
	endtime = RealTime()+5
	}
end
usermessage.Hook("newArea",newArea)

function newAreaHUD()
	if queue.start and queue.start < RealTime() and queue.endtime > RealTime() then
		local start = RealTime()-queue.start
		local alpha;
		if queue.fadein >= start then
			alpha = start/queue.fadein*255
		elseif queue.fadeout > start then
			alpha = 255-start/queue.fadein*255
		end
		draw.SimpleTextOutlined(queue.text,"MarkerSans",ScrW()-50,ScrH()-45,Color(200,200,0,alpha),2,1,2,Color(0,0,0,alpha))
	end
end
hook.Add("HUDPaint","drawNewArea",newAreaHUD)