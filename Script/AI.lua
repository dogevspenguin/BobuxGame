--Fully made by Rufus14
--animations are made with :lerp() and sine waves
--you can convert the model to use it in script builder
local npc = script.Parent
local torso = npc.Torso
local head = npc.Head
local leftarm = npc["Left Arm"]
local rightarm = npc["Right Arm"]
local leftleg = npc["Left Leg"]
local rightleg = npc["Right Leg"]

local bob = script.Parent:Clone()

local npchumanoid = npc:findFirstChildOfClass("Humanoid")
sine = 0
npc:findFirstChildOfClass("Humanoid").MaxHealth = math.random(100,400)
npc:findFirstChildOfClass("Humanoid").Health = npc:findFirstChildOfClass("Humanoid").MaxHealth
local footstep = Instance.new("Sound", head)
footstep.Name = "footstep"
footstep.SoundId = "rbxassetid://4113577407"
footstep.Looped = true
footstep.Volume = 0
footstep:Play()
--Motor6D's
local neck = torso.Neck
neck.C1 = CFrame.new(0,0,0)
local leftshoulder = torso["Left Shoulder"]
leftshoulder.C1 = CFrame.new(0,0,0)
local rightshoulder = torso["Right Shoulder"]
rightshoulder.C1 = CFrame.new(0,0,0)
local lefthip = torso["Left Hip"]
lefthip.C1 = CFrame.new(0,0,0)
local righthip = torso["Right Hip"]
righthip.C1 = CFrame.new(0,0,0)
step = game:GetService("RunService").Stepped
if npc:findFirstChild("HumanoidRootPart") then
	if npc.HumanoidRootPart:findFirstChild("RootJoint") then
		root = npc.HumanoidRootPart.RootJoint
		root.C1 = CFrame.new(0,0,0)
	elseif npc.HumanoidRootPart:findFirstChild("Root Hip") then
		root = npc.HumanoidRootPart["Root Hip"]
		root.C1 = CFrame.new(0,0,0)
	end
else
	npchumanoid.Health = 0
end
--
local sight = math.huge
local walking = false
local attacking = false
local cansay = true
local ragdolldeath = true
local caninfect = false
local canrandomwalk = true
local saycooldown = 0
function walkanim(walkspeed)
	if walkspeed > 2 then
		walking = true
	else
		walking = false
	end
end
npchumanoid.Running:connect(walkanim)
function walkrandomly()
	while wait(math.random(3,6)) do
		if not walking and canrandomwalk then
			npchumanoid.WalkSpeed = 10
			local function createwalkpart()
				local walkpart = Instance.new("Part", npc)
				walkpart.Size = Vector3.new(1,1,1)
				walkpart.Anchored = true
				walkpart.Material = "Neon"
				walkpart.Transparency = 1
				walkpart.BrickColor = BrickColor.new("Maroon")
				walkpart.CFrame = torso.CFrame * CFrame.new(math.random(-60,60),math.random(-30,30),math.random(-60,60))
				local path = game:GetService("PathfindingService"):FindPathAsync(torso.Position, walkpart.Position)
				local waypoints = path:GetWaypoints()
				if path.Status == Enum.PathStatus.Success then
					for i,v in pairs(waypoints) do
						if canrandomwalk then
							npchumanoid:MoveTo(v.Position)
							local allow = 0
							while (torso.Position - v.Position).magnitude > 4 and allow < 25 do
								allow = allow + 1
								wait()
							end
							if v.Action == Enum.PathWaypointAction.Jump then
								npchumanoid.Jump = true
							end
						end
					end
					for i,v in pairs(npc:GetChildren()) do
						if v.Name == "pospart" then
							v:destroy()
						end
					end
				else
					createwalkpart()
					wait()
				end
			end
			createwalkpart()
		end
	end
end
function chase()
	while true do
		if not walking then
			for i,v in pairs(workspace:GetChildren()) do
				if not v:findFirstChild("Zombie AI") and v:findFirstChildOfClass("Humanoid") and v:findFirstChild("Head") then
					if (v:findFirstChild("Head").Position - npc.Head.Position).magnitude < sight then
						canrandomwalk = false
						local thehumanoid = v:findFirstChildOfClass("Humanoid")
						local pathfinding = false
						local thehead = v:findFirstChild("Head")
						while (thehead.Position - npc.Head.Position).magnitude < sight and thehumanoid.Health > 0 and not v:findFirstChild("Zombie AI") do
							npchumanoid.WalkSpeed = 13
							npchumanoid:MoveTo(thehead.Position, thehead)
							local path = game:GetService("PathfindingService"):FindPathAsync(torso.Position, thehead.Position) --find the path from scp's torso to victims head
							local waypoints = path:GetWaypoints() --get the every point of the path
							if path.Status == Enum.PathStatus.Success then
								for q,w in pairs(waypoints) do --for every point existing..
									if q ~= 1 then
										local allow = 0
										npchumanoid:MoveTo(w.Position, thehead) --...walk to it
										while (torso.Position - w.Position).magnitude > 3.8 and allow < 20 do
											allow = allow + 1
											game:GetService("RunService").Heartbeat:wait()
										end
										if w.Action == Enum.PathWaypointAction.Jump then
											npchumanoid.Jump = true
										end
										if thehumanoid.Health <= 0 then
											break
										end
										if v:findFirstChild("Zombie AI") then
											break
										end
									end
								end
								for q,w in pairs(npc:GetChildren()) do
									if w.Name == "pospart" then
										w:destroy()
									end
								end
							else
								npchumanoid:MoveTo(thehead.Position, thehead)
							end
							wait()
						end
						canrandomwalk = true
					else
						canrandomwalk = true
					end
				end
			end
		end
		wait()
	end
end
candmg = true
function damage(part)
	if part.Parent:findFirstChildOfClass("Humanoid") and part.Name ~= "pospart" and not part.Parent:findFirstChild("Zombie AI") and candmg then
		if part.Parent:findFirstChildOfClass("Humanoid").Health <= 4 and part.Parent:findFirstChildOfClass("Humanoid").Health > 0 then
			part.Parent.Head.CFrame = CFrame.new(part.Parent.Head.Position, head.Position)
			part.Parent:findFirstChildOfClass("Humanoid").WalkSpeed = 0
			part.Parent:findFirstChildOfClass("Humanoid").JumpPower = 0
			local deathrandom = math.random(1,5)
			local deathsound = Instance.new("Sound", part.Parent.Head)
			deathsound.Volume = 0.5
			if deathrandom == 1 then
				deathsound.SoundId = "rbxassetid://566988981"
			end
			if deathrandom == 2 then
				deathsound.SoundId = "rbxassetid://884349060"
			end
			if deathrandom == 3 then
				deathsound.SoundId = "rbxassetid://170399891"
			end
			if deathrandom == 4 then
				deathsound.SoundId = "rbxassetid://402192395"
			end
			if deathrandom == 5 then
				deathsound.SoundId = "rbxassetid://1835338424"
			end
			deathsound:Play()
			if not caninfect then
				part.Parent:findFirstChildOfClass("Humanoid").Health = 0
				local plr = game.Players:GetPlayerFromCharacter(part.Parent)
				local id = game.Players:GetUserIdFromNameAsync(plr.Name)
				local mainCframe = part.Parent.PrimaryPart.CFrame
				local outfit = game.Players:GetHumanoidDescriptionFromUserId(id)

				part.Parent:Destroy()
				local clne = script.Parent:Clone()
				clne:SetPrimaryPartCFrame(mainCframe)
				clne.Parent = workspace
				clne.Humanoid:ApplyDescription(outfit)

			end
			if part.Parent ~= nil then
				if part.Parent:findFirstChild("UpperTorso") then
					part.Parent:findFirstChildOfClass("Humanoid").Health = 0
				end
			end
			if part.Parent:findFirstChild("Torso") and part.Parent:findFirstChild("HumanoidRootPart") and caninfect then
				local victim = part.Parent
				local ok = Instance.new("BoolValue", part.Parent)
				ok.Name = "Zombie AI"
				if part.Parent:findFirstChild("Right Arm") then
					rightarmw = Instance.new("Weld", part.Parent.Torso)
					rightarmw.Part0 = part.Parent.Torso
					rightarmw.Part1 = part.Parent["Right Arm"]
					rightarmw.C0 = CFrame.new(1.5,0,0)
					rightarmw.Name = "RightArmWeld"
				end
				if part.Parent:findFirstChild("Right Leg") then
					rightlegw = Instance.new("Weld", part.Parent.Torso)
					rightlegw.Part0 = part.Parent.Torso
					rightlegw.Part1 = part.Parent["Right Leg"]
					rightlegw.C0 = CFrame.new(0.5,-2,0)
					rightlegw.Name = "RightLegWeld"
				end
				if part.Parent:findFirstChild("Left Arm") then
					leftarmw = Instance.new("Weld", part.Parent.Torso)
					leftarmw.Part0 = part.Parent.Torso
					leftarmw.Part1 = part.Parent["Left Arm"]
					leftarmw.C0 = CFrame.new(-1.5,0,0)
					leftarmw.Name = "LeftArmWeld"
				end
				if part.Parent:findFirstChild("Left Leg") then
					leftlegw = Instance.new("Weld", part.Parent.Torso)
					leftlegw.Part0 = part.Parent.Torso
					leftlegw.Part1 = part.Parent["Left Leg"]
					leftlegw.C0 = CFrame.new(-0.5,-2,0)
					leftlegw.Name = "LeftLegWeld"
				end
				local humanoidrootpartw = Instance.new("Weld", part.Parent.HumanoidRootPart)
				humanoidrootpartw.Part0 = part.Parent.HumanoidRootPart
				humanoidrootpartw.Part1 = part.Parent.Torso
				humanoidrootpartw.Name = "HumanoidRootPartWeld"
				for i,v in pairs(part.Parent:GetChildren()) do
					if v.ClassName == "Script" and v.Name ~= "Zombie AI" and v.Name ~= "Health" then
						v:destroy()
					end
				end
				for i = 0,1 , 0.02 do
					rightarmw.C0 = rightarmw.C0:lerp(CFrame.new(1.64086914, 0.201171875, 0, 0.939692497, -0.342020094, 0, 0.342020124, 0.939692557, 0, 0, 0, 1),i)
					leftarmw.C0 = leftarmw.C0:lerp(CFrame.new(-1.98254395, 0.588928223, 0, 0.342020214, 0.939692438, -1.77635663e-15, -0.939692497, 0.342020243, -3.55271368e-15, 0, 3.55271368e-15, 1),i)
					leftlegw.C0 = leftlegw.C0:lerp(CFrame.new(-0.681274414, -2.07165527, 0, 0.984807611, 0.173648268, 0, -0.173648283, 0.98480767, 0, 0, 0, 1),i)
					rightlegw.C0 = rightlegw.C0:lerp(CFrame.new(1.0670166, -2.11602783, 0, 0.866025329, -0.499999851, 0, 0.499999881, 0.866025388, 0, 0, 0, 1),i)
					humanoidrootpartw.C0 = humanoidrootpartw.C0:lerp(CFrame.new(0, -2.60009766, 1.20001221, 0.99999994, 0, 0, 0, -4.37113883e-08, -1, 0, 1, -4.37113883e-08),i)
					game:GetService("RunService").Heartbeat:wait()
				end
				wait(1)
				part.Parent.Archivable = true
				for i,v in pairs(part.Parent.Torso:GetChildren()) do
					if v.ClassName == "Weld" then
						v:destroy()
					end
				end
				for i,v in pairs(part.Parent.HumanoidRootPart:GetChildren()) do
					if v.ClassName == "Weld" then
						v:destroy()
					end
				end
				local clone = victim:Clone()
				part.Parent:findFirstChildOfClass("Humanoid").Health = 0
				wait()
				for i,v in pairs(part.Parent:GetChildren()) do
					if v.ClassName == "Part" or v.ClassName == "Accessory" then
						v:destroy()
					end
				end
				local scriptclone = script:Clone()
				clone.Name = clone.Name.." (Zombie)"
				clone.Parent = workspace
				for i,v in pairs(clone:GetChildren()) do
					if v.ClassName == "Script" and v.Name ~= "Zombie AI" and v.Name ~= "money kill" and v.Name ~= "Respawn" then
						v.Disabled = true
					end
				end
				scriptclone.Parent = clone
				victim.Parent = nil
				wait(0.2)
				local green = math.random(1,3)
				if green == 1 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Sea green")
						end
					end
				end
				if green == 2 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Bright green")
						end
					end
				end
				if green == 3 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Forest green")
						end
					end
				end
			else
				local victim = part.Parent
				victim:findFirstChildOfClass("Humanoid").PlatformStand = true
				for i,v in pairs(part.Parent:GetChildren()) do
					if v.ClassName == "Script" and v.Name ~= "Zombie AI" and v.Name ~= "Health" then
						v:destroy()
					end
				end
				wait(1)
				part.Parent.Archivable = true
				if victim:findFirstChild("Torso") then
					for i,v in pairs(part.Parent.Torso:GetChildren()) do
						if v.ClassName == "Weld" then
							v:destroy()
						end
					end
				end
				for i,v in pairs(part.Parent:GetChildren()) do
					if v.ClassName == "Script" then
						v:destroy()
					end
				end
				local clone = victim:Clone()
				part.Parent:findFirstChildOfClass("Humanoid").Health = 0
				for i,v in pairs(part.Parent:GetChildren()) do
					if v.ClassName == "Part" or v.ClassName == "Accessory" then
						v:destroy()
					end
				end
				local scriptclone = script:Clone()
				clone.Name = clone.Name.." (Zombie)"
				clone.Parent = workspace
				scriptclone.Parent = clone
				victim.Parent = nil
				local green = math.random(1,3)
				if green == 1 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Sea green")
						end
					end
				end
				if green == 2 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Bright green")
						end
					end
				end
				if green == 3 then
					for i,v in pairs(clone:GetChildren()) do
						if v.ClassName == "MeshPart" or v.ClassName == "Part" then
							v.BrickColor = BrickColor.new("Forest green")
						end
					end
				end
			end
		else
			part.Parent:findFirstChildOfClass("Humanoid"):TakeDamage(4)
		end
	end
end
torso.Touched:connect(damage)
function death()
	
	if script.Parent:findFirstChild("Head") then
		local deathrandom = math.random(1,7)
		local deathsound = Instance.new("Sound", script.Parent.Head)
		deathsound.Volume = 3
		if deathrandom == 1 then
			deathsound.SoundId = "rbxassetid://131138845"
		end
		if deathrandom == 2 then
			deathsound.SoundId = "rbxassetid://131138839"
		end
		if deathrandom == 3 then
			deathsound.SoundId = "rbxassetid://131138850"
		end
		if deathrandom == 4 then
			deathsound.SoundId = "rbxassetid://131138860"
		end
		if deathrandom == 5 then
			deathsound.SoundId = "rbxassetid://131138854"
		end
		if deathrandom == 6 then
			deathsound.SoundId = "rbxassetid://131138848"
		end
		if deathrandom == 7 then
			deathsound.SoundId = "rbxassetid://461063380"
		end
		deathsound:Play()
	end
	wait(5)
	local bill = bob:Clone()
	bill:MakeJoints()
	bill.Parent = workspace
	script.Parent:Destroy()
end
npchumanoid.Died:connect(death)
spawn(walkrandomly)
spawn(chase)
while step:wait() do --check animations and other things
	sine = sine + 1
	if not walking then
		footstep.Volume = 0
		neck.C0 = neck.C0:lerp(CFrame.new(0,1.2,0) * CFrame.Angles(math.sin(sine/30)/10,0,0) * CFrame.new(0,0.25,0),0.1)
		righthip.C0 = righthip.C0:lerp(CFrame.new(0.5,-1-math.cos(sine/30)/15,0) * CFrame.Angles(math.rad(10+(2*math.sin(-sine/30))),0,-math.sin(sine/60)/10) * CFrame.new(0,-1,0),0.1)
		lefthip.C0 = lefthip.C0:lerp(CFrame.new(-0.5,-1-math.cos(sine/30)/15,0) * CFrame.Angles(math.rad(10+(2*math.sin(-sine/30))),0,-math.sin(sine/60)/10) * CFrame.new(0,-1,0),0.1)
		root.C0 = root.C0:lerp(CFrame.new(0,math.cos(sine/30)/15,0) * CFrame.Angles(math.rad(-10+(2*math.sin(sine/30))),0,math.sin(sine/60)/15),0.1)
		rightshoulder.C0 = rightshoulder.C0:lerp(CFrame.new(1.5,0.5,0) * CFrame.Angles(math.rad(20)+math.rad(5*math.sin(sine/30)),0,math.rad(5*math.cos(sine/30)/2)) * CFrame.new(0,-0.5,0),0.1)
		leftshoulder.C0 = leftshoulder.C0:lerp(CFrame.new(-1.5,0.5,0) * CFrame.Angles(math.rad(20)-math.rad(5*math.sin(sine/30)),0,-math.rad(5*math.cos(sine/30)/2)) * CFrame.new(0,-0.5,0),0.1)
	end
	if walking then --this is the walking animation
		footstep.Volume = 0.5
		leftshoulder.C0 = leftshoulder.C0:lerp(CFrame.new(-1.5,0.5,0) * CFrame.Angles(math.rad(100-math.cos(sine/5)*10),0,math.rad(math.sin(sine/10)*10)) * CFrame.new(0,-0.5,0),0.1)
		rightshoulder.C0 = rightshoulder.C0:lerp(CFrame.new(1.5,0.5,0) * CFrame.Angles(math.rad(100-math.cos(sine/5)*10),0,math.rad(math.sin(sine/10)*10)) * CFrame.new(0,-0.5,0),0.1)
		neck.C0 = neck.C0:lerp(CFrame.new(0,1.2,0) * CFrame.Angles(math.rad(10+math.cos(sine/5)*6),0,0) * CFrame.new(0,0.25,0),0.1)
		root.C0 = root.C0:lerp(CFrame.new(0,math.sin(sine/5)/9,0) * CFrame.Angles(math.rad(-15),0,math.cos(sine/10)/6),0.1)
		righthip.C0 = righthip.C0:lerp(CFrame.new(0.5,-1+math.cos(sine/10)/3,-math.cos(sine/10)/3) * CFrame.Angles(math.sin(sine/10),0,0) * CFrame.new(0,-1,0),0.1)
		lefthip.C0 = lefthip.C0:lerp(CFrame.new(-0.5,-1-math.cos(sine/10)/3,math.cos(sine/10)/3) * CFrame.Angles(-math.sin(sine/10),0,0) * CFrame.new(0,-1,0),0.1)
	end
end