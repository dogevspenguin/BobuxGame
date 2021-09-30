

local debounce = false
script.Parent.Touched:Connect(function(hit)
	if hit:FindFirstChild("Hard") and debounce == false then
		debounce = true
		local value = hit:FindFirstChild("Hard")
		if value.Value == 1 then
			value.Value = value.Value - 1
		else
			value.Parent:Destroy()
		end
		wait(1)
		debounce = false
	end
end)
