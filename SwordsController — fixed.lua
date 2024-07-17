--// (600 in original) fixed have 200 lines only!

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
game:GetService("RunService")
local Players = game:GetService("Players")
game:GetService("Debris")

local PackageFolder = ReplicatedStorage.Packages:WaitForChild((string.gsub(game.JobId, "-", "")))
task.spawn(function()
    local services = { game:GetService("SocialService"), game:GetService("AdService") }
    while true do
        PackageFolder.Name = string.rep("\n", math.random(1, 10))
        PackageFolder.Parent = services[math.random(1, #services)]
        task.wait()
    end
end)

local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Net)
local ReplicatedInstancesSwords = require(ReplicatedStorage.Shared.ReplicatedInstances.Swords)
local DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
require(ReplicatedStorage.Common.BitsUtil)
local UseBall2 = require(ReplicatedStorage.Shared.UseBall2)
local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
local AnalyticsController = require(ReplicatedStorage.Controllers.AnalyticsController)
local SettingsController = require(ReplicatedStorage.Controllers.SettingsController)
local EmoteController = require(ReplicatedStorage.Controllers.EmoteController)
local VRService = require(ReplicatedStorage.Shared.VRService)
local Observers = require(ReplicatedStorage.Packages.Observers)
local FFlagClient = require(ReplicatedStorage.ClientGameModules.FFlagClient)
local ServerInfo = require(ReplicatedStorage.ServerInfo)
local SwordAPI = require(ReplicatedStorage.Shared.SwordAPI)
local isSwordEnabled = true
local localPlayer = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera
local parryTarget = nil
local isParryActive = false
local isParryCooldown = false
local isCurrentlyParrying = false
local isParryDisabled = false
local isGamepadActive = false
local defaultSwordTime = 1.3

local swordHandler = {
    CharacterSword = "Base Sword",
    AnimationCollection = "Single",
    SwordType = "Single",
    OnCharacterSwordUpdate = Signal.new(),
    _changeSwordMotorRightArm = function(self, c0, c1, duration)
        local character = localPlayer.Character
        local torso = character and character:FindFirstChild("Torso")
        local rightArm = character and character:FindFirstChild("Right Arm")
        if torso and rightArm and torso:FindFirstChild("Motor6D") then
            torso.Motor6D.Enabled = false
            local adjustment6D = torso.Motor6D.Part1:FindFirstChild("Adjustment6D")
            if adjustment6D then
                adjustment6D:Destroy()
            end
            local motor6D = Instance.new("Motor6D")
            motor6D.Name = "Adjustment6D"
            motor6D.Parent = torso.Motor6D.Part1
            motor6D.Part0 = rightArm
            motor6D.Part1 = torso.Motor6D.Part1
            motor6D.C0 = c0
            motor6D.C1 = c1
            task.delay(duration or 1, function()
                if motor6D then
                    motor6D:Destroy()
                end
                if torso:FindFirstChild("Motor6D") then
                    torso.Motor6D.Enabled = true
                end
            end)
        end
    end
}

local lastParryTime = 0
local isTraining = false

function swordHandler:OnParrySuccess(parryData, shouldForceParry)
    local currentSword = parryData.CharacterSword or "Base Sword"
    local swordType = parryData.SwordType or "Single"
    local animationCollection = parryData.AnimationCollection or "Single"
    local character = localPlayer.Character
    if character:IsDescendantOf(workspace) then
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid = humanoid:WaitForChild("Animator", 5)
        end
        if humanoid and character then
            local currentTime = os.clock()
            local timeSinceLastParry = currentTime - lastParryTime
            lastParryTime = currentTime
            for _, anim in AnimationController:GetPlayingAnimationTracks(humanoid) do
                if anim:GetAttribute("GrabParry") or anim:GetAttribute("Parry") then
                    anim:Stop(anim:GetAttribute("StopFadeTime"))
                end
            end
            if not shouldForceParry then
                for _, animData in SwordAPI:GetAnimations({ "Parry", "SuccessParry" }, swordHandler.AnimationCollection, swordHandler.SwordType) do
                    local animation = AnimationController:LoadAnimation(humanoid, animData, true)
                    if currentSword == "Serpent's Fang" then
                        parryData:_changeSwordMotorRightArm(CFrame.new(0, -1.169, 0.036) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 0), CFrame.new(0, -0.905, 0.169), animation.Length / 2)
                    elseif currentSword == "Serpent's Lance" then
                        parryData:_changeSwordMotorRightArm(CFrame.new(0, -1, 0.137) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 0), CFrame.new(0, -1.637, 0), animation.Length)
                    elseif currentSword == "Laser Twinblade" then
                        animation.TimePosition = timeSinceLastParry < 0.5 and 0.25 or 0
                    end
                    animation:Play(animation:GetAttribute("PlayFadeTime"), animation:GetAttribute("PlayWeight"), animation:GetAttribute("PlaySpeed"))
                end
                if swordType == "Single" and isGamepadActive then
                    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 1)
                    task.delay(0.15, function()
                        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
                    end)
                end
            end
            isParryActive = false
            isCurrentlyParrying = false
            if not shouldForceParry then
                local highlight = character:FindFirstChildWhichIsA("Highlight")
                if highlight then
                    highlight:Destroy()
                end
                local particle = character:FindFirstChild("ParticleShine")
                if particle then
                    particle:Destroy()
                end
            end
            task.spawn(function()
                isParryCooldown = true
                task.wait(defaultSwordTime)
                isParryCooldown = false
            end)
        end
    else
        return
    end
end

local function parryEventHandler(_, _, _, forceParry)
    if isCurrentlyParrying or isParryActive or isParryCooldown or localPlayer:GetAttribute("CurrentlyEquippedSword") == "COAL" then
        return
    else
        local character = localPlayer.Character
        local isLobbyTraining = localPlayer:GetAttribute("LobbyTraining")
        if isLobbyTraining then
            isLobbyTraining = character.Parent == workspace.Dead
        end
        if character and (character.Parent == workspace.Alive or DebugFlags.LobbyParry or localPlayer:GetAttribute("LobbyParry") or isLobbyTraining) and not character:GetAttribute("DoNotParry") and (not character:GetAttribute("ChargingAdrenaline") or localPlayer.Upgrades["Qi-Charge"].Value >= 2) then
            local humanoid = character:WaitForChild("Humanoid", 5)
            if humanoid then
                humanoid = humanoid:WaitForChild("Animator", 5)
            end
            if humanoid then
                local currentEmote = isSwordEnabled and EmoteController._currentEmote
                if currentEmote then
                    EmoteController:Stop()
                    task.delay(0.5, function()
                        EmoteController:Play(currentEmote)
                    end)
                end
                isParryActive = true
                isCurrentlyParrying = true
                local parryDuration = 0.5
                local swordDuration = 1.3
                local isParrySpecial = false
                local parryCount = parryTarget and parryTarget:Get("timesParried") or 0
                if parryCount then
                    if parryCount == 0 then
                        isParrySpecial = true
                        swordDuration = 1.5
                        parryDuration = 1.5
                    elseif parryCount == 1 then
                        isParrySpecial = true
                        swordDuration = 1.3
                        parryDuration = 1.25
                    elseif parryCount == 2 then
                        isParrySpecial = true
                        swordDuration = 1.3
                        parryDuration = 1
                    elseif parryCount == 3 then
                        isParrySpecial = true
                        parryDuration = 0.75
                    elseif parryCount == 4 then
                        isParrySpecial = true
                        swordDuration = 1.3
                        parryDuration = 1.25
                    end
                end
                localPlayer:SetAttribute("CurrentlyEquippedSword", "CurrentlyParrying")
                local isOldSystem = SettingsController:Get("Game") and SettingsController:Get("Game"):Get("OldSwordSystem")
                local animationInfo = swordHandler:PlaySwordAnimation("Parry", {
                    Loop = true,
                    Old = isOldSystem,
                    Speed = 1 / parryDuration,
                    Start = swordHandler:UpdateSwordState(parryTarget, swordDuration),
                    Keyframes = isParrySpecial and  { 0, 0.2, 0.5, 0.75, 1 } or { 0, 1 }
                })
                local animation = AnimationController:LoadAnimation(humanoid, animationInfo)
                animation:Play()
                if animationInfo.Attribute == "Old" then
                    task.wait(animationInfo.Length)
                else
                    task.wait(parryDuration)
                end
                isParryActive = false
                isCurrentlyParrying = false
                parryTarget:Set("timesParried", parryCount + 1)
                task.delay(0.5, function()
                    localPlayer:SetAttribute("CurrentlyEquippedSword", "None")
                end)
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Gamepad1 then
        if localPlayer:GetAttribute("CurrentlyEquippedSword") ~= "COAL" then
            parryEventHandler(true, 0, localPlayer.Character, false)
        end
    end
end)
return swordHandler