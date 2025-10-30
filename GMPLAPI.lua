local COOLDOWN_DURATION = 10
local isCoolingDown = false

_G.CanQuickRespawn = true

function _G.ResetCooldown()
	if not isCoolingDown then
		isCoolingDown = true
		_G.CanQuickRespawn = false
		
		task.wait(COOLDOWN_DURATION)

		_G.CanQuickRespawn = true
		isCoolingDown = false
	end
end

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Camera = workspace.Camera
local HomeGUI = PlayerGui:WaitForChild("Home")

local TeamEvent = workspace:WaitForChild("Remote"):WaitForChild("TeamEvent")
local CriminalSpawn = workspace["Criminals Spawn"]:FindFirstChild("SpawnLocation")

local Neutral = Teams.Neutral

local function FixCamera()
	HomeGUI.hud.Visible = true
	HomeGUI.intro.Visible = false
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
	Camera.CameraType = Enum.CameraType.Custom
	if LocalPlayer.Character then
		Camera.CameraSubject = LocalPlayer.Character:WaitForChild("Humanoid")
	end
end

local function SetTeam(Team)
    if Team == Teams.Criminals then error("Can't criminal through remotes.") end
    repeat task.wait()
        TeamEvent:FireServer(Team)
    until LocalPlayer.Team == Team
    FixCamera()
end

local function ChangeTeam(Team)
    local CurrentTeam = LocalPlayer.Team
    if CurrentTeam == Team and Team == Teams.Criminals then
        -- Cannot Quick Respawn Criminals
        return
    end
    if Team == Teams.Criminals then
        ChangeTeam(Teams.Inmates)
        repeat task.wait() until LocalPlayer.Character
        local RootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local OriginalCFrame = RootPart.CFrame * CFrame.new(0, 5, 0)
        RootPart.CFrame = CFrame.new(851, 93, 2609)
        repeat task.wait() until LocalPlayer.Team == Team
        RootPart.CFrame = OriginalCFrame
        return
    end
    SetTeam(Neutral)
    SetTeam(Team)
    task.spawn(_G.ResetCooldown)
end

local API = {}
API.ChangeTeam = ChangeTeam
API.CanQuickRespawn = function()
    return _G.CanQuickRespawn
end
API.Teams = Teams

return API
