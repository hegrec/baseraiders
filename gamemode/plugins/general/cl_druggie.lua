local Effects = {}

function Effects.Weed()
	local start = RealTime()
	local endtime = WEED_HIGH
	local peak = 0.3*WEED_HIGH
	hook.Add("RenderScreenspaceEffects","DarklandRPDrug",
		function()
			local frac = 0
			local progress = (RealTime()-start)/endtime
			if progress*WEED_HIGH<peak then
				frac = math.EaseInOut(progress,0.1,0.9)
			else
				progress = 1-progress
				frac = math.EaseInOut(progress,0.01,0.9)
			end
			
			DrawMotionBlur(0.2/frac, 0.99, 0)
		end
	)
	timer.Simple(WEED_HIGH,function() hook.GetTable()["RenderScreenspaceEffects"]["DarklandRPDrug"] = nil end)

end

function Effects.Shrooms()
	local start = RealTime()
	local endtime = SHROOM_HIGH
	local peak = 0.3*SHROOM_HIGH
	hook.Add("RenderScreenspaceEffects","DarklandRPDrug",
		function()
			local frac = 0
			local progress = (RealTime()-start)/endtime
			if progress*SHROOM_HIGH<peak then
				frac = math.EaseInOut(progress,0.1,0.9)
			else
				progress = 1-progress
				frac = math.EaseInOut(progress,0.01,0.9)
			end
			DrawBloom( 0, 0.75*frac, 1, 1, 1, 1, 1, 1, 1 )
		end
	)
	timer.Simple(SHROOM_HIGH,function() hook.GetTable()["RenderScreenspaceEffects"]["DarklandRPDrug"] = nil end)

end


local function useDrug(um)
	local drug = um:ReadString()
	Effects[drug]()
end
usermessage.Hook("usedDrug",useDrug)