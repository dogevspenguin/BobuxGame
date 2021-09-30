local DataStore = game:GetService("DataStoreService")
local ds = DataStore:GetDataStore("FuYouHecker")

game.Players.PlayerAdded:connect(function(player)
	local leader = Instance.new("Folder",player)
	leader.Name = "leaderstats"
	local Cash = Instance.new("IntValue",leader)
	Cash.Name = "Money"
	Cash.Value = ds:GetAsync(player.UserId) or 0
	ds:SetAsync(player.UserId, Cash.Value)
	Cash.Changed:connect(function()
		ds:SetAsync(player.UserId, Cash.Value)
	end)
end)


game.Players.PlayerRemoving:connect(function(player)
	ds:SetAsync(player.UserId, player.leaderstats.Money.Value)
end)
