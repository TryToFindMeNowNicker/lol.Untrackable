local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Camera = workspace.Camera

local PlayerTased = ReplicatedStorage.GunRemotes.PlayerTased
local FakePlayerTased = PlayerTased:Clone()
FakePlayerTased.Parent = PlayerTased.Parent
PlayerTased:Destroy()

local CamCFrame
local function Teleport(TargetCFrame, Character)
    CamCFrame = Camera.CFrame
    if not Character then Character = LocalPlayer.Character end
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        Character.Humanoid.Name = "Valid"
    end
    local RootPart
    local OnRespawn
    OnRespawn = LocalPlayer.CharacterAdded:Connect(function(Character)
        RootPart = Character:WaitForChild("HumanoidRootPart")
        RootPart.CFrame = TargetCFrame
        OnRespawn:Disconnect()
    end)
    LocalPlayer.CharacterAdded:wait()
    repeat task.wait() until RootPart and (RootPart.Position - TargetCFrame.Position).Magnitude < 1
end

LocalPlayer.CharacterRemoving:Connect(function(Character)
    if Character.Humanoid.Name ~= "Valid" then
        Teleport(Character.HumanoidRootPart.CFrame, Character)
        task.wait()
        Camera.CFrame = CamCFrame
        print("God Mode: Respawned at death location")
    end
end)

local Status = LocalPlayer.Status
local isArrested = Status.isArrested

local function AntiArrest()
    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    print("God Mode: Anti-Arrest triggered")
end

RunService.Heartbeat:Connect(function()
    if isArrested.Value == true then
        AntiArrest()
    end
end)

local Teams = game:GetService("Teams")
local function CriminalAntiArrest(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    task.wait(5)
    if LocalPlayer.Team == Teams.Criminals then
        repeat task.wait() until not LocalPlayer.Character:FindFirstChild("ForceField")
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        print("God Mode: Criminal anti-arrest activated")
    end
end

task.spawn(CriminalAntiArrest, LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(CriminalAntiArrest)

print("GOD MODE ACTIVATED")
print("Features:")
print("- Anti-Tase: Cannot be tased")
print("- Anti-Arrest: Auto-escapes arrest")
print("- Death Protection: Respawn at death location")
print("- Criminal Protection: Auto-respawn as criminal")
