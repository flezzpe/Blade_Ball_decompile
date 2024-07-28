local DebrisService = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)

require(ReplicatedStorage.Shared.UseBall2)

local EmoteController = require(ReplicatedStorage.Controllers.EmoteController)

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 99)

Replion.Client:WaitReplion("Data")
Humanoid:WaitForChild("Animator", 5)

local WindowFocusedRemoteEvent = Net:RemoteEvent("WindowFocused")
local DoubleJumpAnimation = Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script:WaitForChild("DoubleJump"))

Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script:WaitForChild("BlastersParry"))
Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script:WaitForChild("TwinSlash"))

local TwirlAnimation = Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script:WaitForChild("Twirl"))

local HotbarGui = LocalPlayer.PlayerGui:WaitForChild("Hotbar")
local ZeroGravityArenaMaps = { "MoonMap", "ZeroGravityArena" }
local CurrentCamera = workspace.CurrentCamera

local isFocused = true
local isJumping = false
local lastJumpTime = nil
local jumpCount = 0
local primaryInputType = Enum.UserInputType.MouseButton1
local isJumpLocked = false
local AliveWorkspace = workspace:WaitForChild("Alive")
workspace:WaitForChild("Dead")

script.PlayEmote.Event:Connect(function(emoteName, _)
    warn("PlayEmote event is deprecated, switch to EmoteController:Play() instead")
    EmoteController:Play(emoteName)
end)

UserInputService.WindowFocused:Connect(function()
    isFocused = true
    WindowFocusedRemoteEvent:FireServer(true)
end)

UserInputService.WindowFocusReleased:Connect(function()
    isFocused = false
    WindowFocusedRemoteEvent:FireServer(false)
end)

UserInputService.InputBegan:Connect(function()
    if not isFocused then
        isFocused = true
        
        WindowFocusedRemoteEvent:FireServer(true)
    end
end)

function ReplicatedStorage.Remotes.RequestReflectionData.OnClientInvoke()
    local playersData = {}
    for _, player in ipairs(AliveWorkspace:GetChildren()) do
        if player:FindFirstChild("HumanoidRootPart") then
            playersData[player.Name] = CurrentCamera:WorldToScreenPoint(player.HumanoidRootPart.Position)
        end
    end
    local lastInputType = UserInputService:GetLastInputType()
    local mousePosition
    if lastInputType == Enum.UserInputType.MouseButton1 or lastInputType == Enum.UserInputType.Keyboard or lastInputType == Enum.UserInputType.MouseButton2 then
        mousePosition = { Mouse.X, Mouse.Y }
    else
        mousePosition = { CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2 }
    end
    return {
        refCFrame = workspace.CurrentCamera.CFrame,
        people = playersData,
        mouseposition = mousePosition
    }
end

local UseBall2 = require(ReplicatedStorage.Shared.UseBall2)

UserInputService.JumpRequest:Connect(function()
    local currentTime = os.clock()
    local isDoubleJump = false

    if lastJumpTime then
        isDoubleJump = currentTime - lastJumpTime < 0.1
    end
    lastJumpTime = currentTime

    if not isDoubleJump then
        if Humanoid.FloorMaterial == Enum.Material.Air and not isJumping then
            if isJumpLocked then
                return
            end

            task.spawn(function()
                isJumpLocked = true
                task.wait(0.2)
                isJumpLocked = false
            end)

            jumpCount = jumpCount + 1
            local maxJumps = 1

            if require(game.ReplicatedStorage.Shared.Abilities["Quad Jump"]).iconId == LocalPlayer.PlayerGui.Hotbar.Ability.Vector.Image then
                if not LocalPlayer.PlayerGui.Hotbar.Ability.Red.Visible then
                    local character = LocalPlayer.Character
                    if character then
                        maxJumps = character:IsDescendantOf(AliveWorkspace) and 3 or maxJumps
                    end
                end
            end

            if maxJumps < jumpCount then
                return
            end

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Parent = Character.HumanoidRootPart
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            
            if jumpCount == 1 then
                bodyVelocity.Velocity = Vector3.new(0, 80, 0)
            else
                local velocity = 80 + 10 * LocalPlayer.Upgrades["Quad Jump"].Value
                bodyVelocity.Velocity = Vector3.new(0, velocity, 0)
            end
            DebrisService:AddItem(bodyVelocity, 0.001)

            if LocalPlayer.Character.Torso:FindFirstChild("Whirlwinds") or LocalPlayer.Character.Torso:FindFirstChild("MaxWhirlwinds") then
                ReplicatedStorage.Remotes.CloakJump:FireServer()
            end
            if Character.Parent == AliveWorkspace then
                ReplicatedStorage.Remotes.DoubleJump:FireServer()
            end

            if jumpCount == 1 then
                DoubleJumpAnimation:Play()
            elseif jumpCount == 2 or jumpCount == 3 then
                DoubleJumpAnimation:Stop()
                TwirlAnimation:Stop()
                TwirlAnimation:Play()
                if UseBall2() then
                    ReplicatedStorage.Shared.Abilities["Quad Jump"].Activated:Fire()
                else
                    ReplicatedStorage.Remotes.XtraJumped:FireServer()
                end
            end

            if maxJumps == jumpCount then
                isJumping = true
            end

            local currentJumpCount = jumpCount
            local selectedMap = workspace:GetAttribute("CurrentlySelectedMap")
            if table.find(ZeroGravityArenaMaps, selectedMap) then
                task.wait(3)
            else
                task.wait(1.5)
            end

            if currentJumpCount == jumpCount then
                jumpCount = 0
                isJumping = false
            end
        end
    end
end)

local EmoteWheelController = require(ReplicatedStorage.Controllers.EmoteWheelController)
local thumbstickDelta = Vector2.zero
local lastThumbstickPosition = thumbstickDelta

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType.Name:find("Gamepad") then
        EmoteWheelController.thumbstickDelta = Vector2.new(20 * input.Position.X, -20 * input.Position.Y)
        return
    elseif input.UserInputType == Enum.UserInputType.Touch then
        lastThumbstickPosition = Vector2.new(input.Position.X, input.Position.Y)
        EmoteWheelController.thumbstickDelta = (lastThumbstickPosition - thumbstickDelta) * 5
    end
end)

Humanoid.Died:Connect(function()
    ReplicatedStorage.Remotes.OnDeath:FireServer(LocalPlayer)
    if LocalPlayer.Character:FindFirstChildOfClass("Highlight") then
        LocalPlayer.Character:FindFirstChildOfClass("Highlight"):Destroy()
    end
    if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ParticleShine") then
        LocalPlayer.Character.HumanoidRootPart:FindFirstChild("ParticleShine"):Destroy()
    end
end)

ReplicatedStorage.Remotes.KeybindM2.OnClientEvent:Connect(function(isMouseButton2)
    primaryInputType = isMouseButton2 and Enum.UserInputType.MouseButton2 or Enum.UserInputType.MouseButton1
end)

game:GetService("CollectionService"):GetInstanceAddedSignal("Platform"):Connect(function(platform)
    task.defer(function()
        if platform:FindFirstChild("OwnerCharacter") and platform.OwnerCharacter.Value ~= Players.LocalPlayer.Character then
            for _, part in platform:GetChildren() do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            platform.CanCollide = false
        else
            platform.CanCollide = true
        end
    end)
end)

local abilityReady = HotbarGui.Ability.ready
script.Parent:WaitForChild("Abilities"):WaitForChild("Blink"):GetPropertyChangedSignal("Enabled"):Connect(function()
    abilityReady.counts.Visible = script.Parent.Abilities.Blink.Enabled
end)

local initialFieldOfView = workspace.CurrentCamera.FieldOfView
require(ReplicatedStorage.Packages.Observers).observeChildren(script.Parent.Abilities, function(ability)
    ability:GetPropertyChangedSignal("Enabled"):Connect(function()
        if not ability.Enabled then
            workspace.CurrentCamera.FieldOfView = initialFieldOfView
            if ability.Name == "Slash of Duality" then
                local dualityChoice = ability:FindFirstChild("DualityChoice")
                if dualityChoice then
                    require(dualityChoice).toggleOff()
                    return
                end
            elseif ability.Name == "Slashes of Fury" then
                local furyTimer = LocalPlayer.PlayerGui:FindFirstChild("FuryTimer")
                if furyTimer then
                    furyTimer.Enabled = false
                end
                for _, player in workspace.Alive:GetChildren() do
                    local furyHighlight = player:FindFirstChild("FuryHighlight")
                    if furyHighlight then
                        furyHighlight:Destroy()
                    end
                end
                for _, ball in workspace.Balls:GetChildren() do
                    local comboCounter = ball:FindFirstChild("ComboCounter")
                    if comboCounter then
                        comboCounter:Destroy()
                    end
                end
                return
            elseif ability.Name == "Raging Deflection" then
                require(ReplicatedStorage.Shared.SpeedModifiers):RemoveModifierFor(Character, "Initial Raging Deflect Debuff")
                return
            elseif ability.Name == "Death Slash" then
                require(ReplicatedStorage.Shared.SpeedModifiers):RemoveModifierFor(Character, "Initial Death Slash Use")
                require(ReplicatedStorage.Shared.JumpModifiers):RemoveModifierFor(Character, "Initial Death Slash Use")
                return
            elseif ability.Name == "Dash" and LocalPlayer.Character then
                for _, part in LocalPlayer.Character:GetDescendants() do
                    if part:GetAttribute("DashSetMassless") then
                        part:SetAttribute("DashSetMassless", nil)
                        part.Massless = false
                    end
                end
            end
        end
    end)
end)
