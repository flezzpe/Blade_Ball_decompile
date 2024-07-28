
local script = game:GetService("Players").LocalPlayer.Character.Abilities.Swap
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local CurrentCamera = workspace.CurrentCamera
local InitialFOV = CurrentCamera.FieldOfView
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Character:WaitForChild("Humanoid")
local SettingsController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("SettingsController"))
local isSwapping = false
local isCooldown = false
local MouseButton = Enum.UserInputType.MouseButton2
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HotbarAbility = PlayerGui:WaitForChild("Hotbar"):WaitForChild("Ability")
local AbilityIcon = HotbarAbility:WaitForChild("Vector")
local AbilityName = script.Name
local AbilityData = require(ReplicatedStorage.Shared.Abilities:WaitForChild(AbilityName))
AbilityIcon.Image = AbilityData and AbilityData.iconId or ""


local function performSwap(inputType)
    if isSwapping then
        return
    elseif LocalPlayer.Character.Parent == workspace.Alive and not HotbarAbility.Red.Visible then
        isSwapping = true
        TweenService:Create(CurrentCamera, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0), {
            FieldOfView = InitialFOV * 1.08
        }):Play()
        
        local mousePosition
        if inputType and (inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Keyboard or inputType == Enum.UserInputType.MouseButton2) then
            local mouseLocation = UserInputService:GetMouseLocation()
            mousePosition = { mouseLocation.X, mouseLocation.Y }
        else
            mousePosition = { CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2 }
        end
        
        local potentialTargets = {}
        for _, character in ipairs(workspace.Alive:GetChildren()) do
            if not (character:GetAttribute("Dead") or character:GetAttribute("Invisible") or character:GetAttribute("DoNotTarget") or character:GetAttribute("IsEncryptedClone") or character:GetAttribute("1x1x1x1")) and character ~= LocalPlayer.Character and character:FindFirstChild("HumanoidRootPart") then
                potentialTargets[{ Character = character }] = CurrentCamera:WorldToScreenPoint(character.HumanoidRootPart.Position)
            end
        end
        
        local closestTarget = { Distance = nil, Player = nil }
        local targetPosition = Vector2.new(mousePosition[1], mousePosition[2])
        for target, screenPosition in pairs(potentialTargets) do
            local character = target.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (targetPosition - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                if not closestTarget.Player or (closestTarget.Distance and distance < closestTarget.Distance) then
                    closestTarget.Distance = distance
                    closestTarget.Player = target
                end
            end
        end
        
        if closestTarget.Player then
            local cooldown = 25 - 5 * LocalPlayer.Upgrades[script.Name].Value
            ReplicatedStorage.Remotes.Swapped:FireServer(closestTarget.Player.Character.Name)
            ReplicatedStorage.Remotes.VisualBindableCD:Fire(false, true, cooldown)
            task.wait(cooldown)
            if not isCooldown then
                isSwapping = false
            end
        else
            task.wait(1)
            isSwapping = false
            return
        end
    else
        return
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and SettingsController:UseBind(input, "Ability") then
        performSwap(input.UserInputType)
    end
end)

ReplicatedStorage.Remotes.AbilityButtonPress.Event:Connect(function()
    performSwap()
end)

ReplicatedStorage.Remotes.EndCD.OnClientEvent:Connect(function()
    task.spawn(function()
        isCooldown = true
        isSwapping = false
        local cooldown = 25 - 5 * LocalPlayer:WaitForChild("Upgrades")[script.Name].Value
        task.wait(cooldown - 1)
        isCooldown = false
    end)
end)
ReplicatedStorage.Remotes.KeybindM2.OnClientEvent:Connect(function(isDisabled)
    MouseButton = isDisabled and nil or Enum.UserInputType.MouseButton2
end)
