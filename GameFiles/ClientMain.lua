-- Services

local replicatedStorage = game:GetService("ReplicatedStorage")
local status = replicatedStorage:WaitForChild("Status")

local tweenService = game:GetService("TweenService")
local sounds = replicatedStorage:WaitForChild("Sounds")

-- UI elements

local intro = script.Parent:WaitForChild("Intro")
local loading = script.Parent:WaitForChild("Loading")
local intermission = script.Parent:WaitForChild("Intermission")

local tokensLabel = script.Parent:WaitForChild("Tokens") -- textlabel
local tokens = game.Players.LocalPlayer:WaitForChild("Tokens") -- value


loading.Visible = true
sounds.Intro:Play()

local function moveCamera(destination)
	tweenService:Create(workspace.CurrentCamera, TweenInfo.new(1), {CFrame = destination}):Play()
end

loading.disable.MouseButton1Click:Connect(function()
	local Lighting = game:GetService("Lighting")
	Lighting.Blur:Destroy()
	Lighting.ColorCorrection:Destroy()
	Lighting.SunRays:Destroy()
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.FogStart = 0
	Lighting.FogEnd = 9999
	Lighting.Brightness = 1
	
	loading.Visible = false
	intro.Visible = true
	tokensLabel.Visible = true

end)
loading.enable.MouseButton1Click:Connect(function()
	loading.Visible = false
	intro.Visible = true
	tokensLabel.Visible = true

end)



repeat wait()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
until workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
workspace.CurrentCamera.CFrame = workspace:WaitForChild("IntroTunnel").CameraOrigin.CFrame

local topStatus = script.Parent:WaitForChild("TopStatus")
topStatus.Text = status.Value

status:GetPropertyChangedSignal("Value"):Connect(function()
	topStatus.Text = status.Value
end)

tokensLabel.Text = tokens.Value
tokens:GetPropertyChangedSignal("Value"):Connect(function()
	tokensLabel.Text = tokens.Value
end)

intro.Play.MouseButton1Click:Connect(function()
	intro.Visible = false
	tokensLabel.Visible = false
	moveCamera(workspace:WaitForChild("IntroTunnel").Cameraf1.CFrame)
	wait(0.5)
	moveCamera(workspace:WaitForChild("IntroTunnel").Cameraf2.CFrame)
	wait(0.5)
	moveCamera(workspace:WaitForChild("IntroTunnel").Cameraf3.CFrame)
	wait(1)
	
	if game.ReplicatedStorage.MapVoting.Value == true then
		intermission.VotingFrame.MapVoting.Visible = true
	end
	
	if game.ReplicatedStorage.ModeVoting.Value == true then
		intermission.VotingFrame.ModeVoting.Visible = true
	end
	
	intermission.Visible = true
	topStatus.Visible = true
	game.ReplicatedStorage.MenuPlay:FireServer()
end)

intermission.Close.MouseButton1Click:Connect(function()
	intermission.Visible = false
	topStatus.Visible = false
	moveCamera(workspace:WaitForChild("IntroTunnel").Cameraf2.CFrame)
	wait(0.5)
	moveCamera(workspace:WaitForChild("IntroTunnel").Cameraf1.CFrame)
	wait(0.5)
	moveCamera(workspace:WaitForChild("IntroTunnel").CameraOrigin.CFrame)
	wait(0.5)
	
	game.ReplicatedStorage:WaitForChild("BacktoMenu"):FireServer()
	
	wait(1)
	
	tokensLabel.Visible = true
	intro.Visible = true
end)

game.ReplicatedStorage.KillFeed.OnClientEvent:Connect(function(text)
	if not game.Players.LocalPlayer:FindFirstChild("InMenu") then
		script.Parent.KillFeed.Visible = true
		script.Parent.KillFeed.Text = text
		wait(3)
		script.Parent.KillFeed.Visible = false
	end
end)

game.ReplicatedStorage.Announcement.OnClientEvent:Connect(function(text)
	if not game.Players.LocalPlayer:FindFirstChild("InMenu") then
		script.Parent.Announcement.Text = text
		script.Parent.Announcement.Visible = true
		wait(5)
		script.Parent.Announcement.Visible = false
	end
end)

game.ReplicatedStorage:WaitForChild("ToggleMenuCamera").OnClientEvent:Connect(function()
	repeat wait()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	until workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
	workspace.CurrentCamera.CFrame = workspace:WaitForChild("IntroTunnel").CameraOrigin.CFrame
	game.ReplicatedStorage:WaitForChild("BacktoMenu"):FireServer()
	intro.Visible = true
	intermission.Visible = false
	script.Parent:WaitForChild("Shop").Visible = false
	topStatus.Visible = false
	tokensLabel.Visible = true
	sounds.Intro:Play()
	sounds.Game:Stop()
end)

game.ReplicatedStorage:WaitForChild("ToggleGameCamera").OnClientEvent:Connect(function()
	if not game.Players.LocalPlayer:FindFirstChild("InMenu") then
		wait(0.1)
		repeat wait()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		until workspace.CurrentCamera.CameraType == Enum.CameraType.Custom
		wait(0.1)
		workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
		topStatus.Visible = true
		intermission.Visible = false
		tokensLabel.Visible = false
		script.Parent:WaitForChild("Shop").Visible = false
		intro.Visible = false
		sounds.Intro:Stop()
		sounds.Game:Play()
	end
end)

game.ReplicatedStorage:WaitForChild("DisableIntroSettings").OnClientEvent:Connect(function()
	if not game.Players.LocalPlayer:FindFirstChild("InMenu") then
		script.Parent:WaitForChild("Crouch").Visible = false
		intermission.Visible = false
		tokensLabel.Visible = false
		intermission.Visible = false
		tokensLabel.Visible = false
		script.Parent:WaitForChild("Shop").Visible = false
		sounds.Intro:Stop()
	end
end)

game.ReplicatedStorage:WaitForChild("DisableIntermission").OnClientEvent:Connect(function()
	repeat wait()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	until workspace.CurrentCamera.CameraType == Enum.CameraType.Custom
	wait(0.1)
	workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
	intermission.Visible = false
end)

intro.Shop.MouseButton1Click:Connect(function()
	script.Parent:WaitForChild("Shop").Visible = true
	intro.Visible = false
end)

script.Parent:WaitForChild("Shop"):WaitForChild("Close").MouseButton1Click:Connect(function()
	if game.Players.LocalPlayer:FindFirstChild("InMenu") then
		intro.Visible = true
	end
	script.Parent:WaitForChild("Shop").Visible = false
end)
