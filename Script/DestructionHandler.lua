for _, v in pairs(script.Parent:GetChildren()) do
	if v.ClassName ~= script then
		local var = Instance.new("NumberValue")
		var.Name = "Hard"
		var.Value = 10
		var.Parent = v
	end
end
