baseraiders.util = baseraiders.util or {}

function baseraiders.util.Serialize(data)
	local success, value = pcall(von.serialize, data)

	if not success then
		print(value)
		return ""
	end

	return value
end

function baseraiders.util.Deserialize(data)
	local success, value = pcall(von.deserialize, data)

	if not success then
		print(value)
		return {}
	end

	return value
end