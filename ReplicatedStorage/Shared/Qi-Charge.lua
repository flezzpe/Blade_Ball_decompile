local script = game:GetService("Players").LocalPlayer.Character.Abilities:FindFirstChild("Qi-Charge")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local settingsController = require(replicatedStorage:WaitForChild("Controllers"):WaitForChild("SettingsController"))
local replion = require(replicatedStorage.Packages.Replion)
local inventoryClient = require(replicatedStorage.Shared.Inventory).Client
local isAdrenalineActive = false
local isCooldownActive = false
local cooldownDuration = 8
local abilityInputType = Enum.UserInputType.MouseButton2
local playerGui = localPlayer:WaitForChild("PlayerGui")
local hotbarAbilityVector = playerGui:WaitForChild("Hotbar"):WaitForChild("Ability"):WaitForChild("Vector")
local qiAbilityMeter = playerGui.QiAbilityMeter
local qiAbilityConfig = require(game.ReplicatedStorage.Shared.Abilities[script.Name])

hotbarAbilityVector.Image = qiAbilityConfig and qiAbilityConfig.iconId or ""
local adrenalineColors = {
    [0] = Color3.new(1, 1, 1),
    [1] = Color3.new(0.490196, 0.882353, 1),
    [2] = Color3.new(1, 0.494118, 0.611765),
    [3] = Color3.new(1, 0.258824, 0.270588)
}
local chargingCoroutine = nil
local isCharging = false

local function handleAdrenalineCharge(isCharging, isForced)
    if isAdrenalineActive or isCooldownActive or localPlayer.Character.Parent ~= workspace.Alive or playerGui.Hotbar.Ability.Red.Visible ~= false then
        if isForced then
            replicatedStorage.Remotes.PlrAdrenalined:FireServer(isCharging)
        end
        return
    else
        replicatedStorage.Remotes.PlrAdrenalined:FireServer(isCharging)
        
        if isCharging or not localPlayer.Character:GetAttribute("ChargingAdrenaline") then
            if isCharging then
                if chargingCoroutine then
                    coroutine.close(chargingCoroutine)
                    chargingCoroutine = nil
                end
                local chargeRate = 1 / (10 - (localPlayer.Upgrades["Qi-Charge"].Value or 0))
                local chargeProgress = character:GetAttribute("AdrenalineChargeProgress") or 0
                chargingCoroutine = task.spawn(function()
                    qiAbilityMeter.Bg.Position = UDim2.fromScale(0.5, 0.78)
                    qiAbilityMeter.Bg:TweenPosition(UDim2.fromScale(0.5, 0.75), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, true)
                    local currentAdrenaline = character:GetAttribute("Adrenaline")
                    while true do
                        local newAdrenaline = character:GetAttribute("Adrenaline")
                        if newAdrenaline ~= currentAdrenaline then
                            chargeProgress = character:GetAttribute("AdrenalineChargeProgress") or 0
                            currentAdrenaline = newAdrenaline
                        end
                        qiAbilityMeter.Bg.TextLabel.Text = ("%*%%"):format(chargeProgress * 1000 // 10)
                        qiAbilityMeter.Bg.Fill.Meter.Offset = Vector2.new(-1 + chargeProgress, 0)
                        qiAbilityMeter.Bg.FillGlow.Meter.Offset = Vector2.new(-1 + chargeProgress, 0)
                        qiAbilityMeter.Bg.FillGlow.ImageTransparency = 1 - 0.75 * (newAdrenaline or 0) / 3
                        qiAbilityMeter.Bg.FillGlow.ImageColor3 = adrenalineColors[newAdrenaline or 0]
                        local shakeIntensity = (chargeProgress - 0.85) / 0.15
                        if shakeIntensity > 0 then
                            qiAbilityMeter.Bg.Position = UDim2.new(0.5, shakeIntensity * (math.random() - 0.5) * 20, 0.75, shakeIntensity * (math.random() - 0.5) * 20)
                        end
                        local newChargeProgress = chargeProgress + task.wait() * chargeRate
                        chargeProgress = math.clamp(newChargeProgress, 0, 1)
                    end
                end)
            end
        else
            if chargingCoroutine then
                coroutine.close(chargingCoroutine)
                chargingCoroutine = nil
            end
            isAdrenalineActive = true
            task.wait(0.05)
            isAdrenalineActive = false
        end
        if not isCooldownActive then
            isCooldownActive = false
        end
    end
end

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if settingsController:UseBind(input, "Ability") then
            handleAdrenalineCharge(true)
        end
    end
end)

userInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if settingsController:UseBind(input, "Ability") then
            handleAdrenalineCharge(false)
        end
    end
end)

local isAbilityButtonPressed = false
replicatedStorage.Remotes.AbilityButtonPress.Event:Connect(function()
    isAbilityButtonPressed = not isAbilityButtonPressed
    handleAdrenalineCharge(isAbilityButtonPressed)
end)

replicatedStorage.Remotes.DashFired.Event:Connect(function()
    task.spawn(function() end)
end)

replicatedStorage.Remotes.EndCD.OnClientEvent:Connect(function()
    task.spawn(function()
        isCooldownActive = true
        isAdrenalineActive = false
        cooldownDuration = 8
        local qiChargeUpgrade = localPlayer:WaitForChild("Upgrades")[script.Name].Value
        cooldownDuration = cooldownDuration - cooldownDuration / 8 * qiChargeUpgrade
        task.wait(cooldownDuration - 1)
        isCooldownActive = false
    end)
end)

replicatedStorage.Remotes.KeybindM2.OnClientEvent:Connect(function(isActive)
    if isActive then
        abilityInputType = nil
    else
        abilityInputType = Enum.UserInputType.MouseButton2
    end
end)

localPlayer.Character:GetAttributeChangedSignal("ChargingAdrenaline"):Connect(function()
    qiAbilityMeter.Bg.Visible = localPlayer.Character:GetAttribute("ChargingAdrenaline") and true or false
end)

qiAbilityMeter.Bg.Visible = localPlayer.Character:GetAttribute("ChargingAdrenaline") and true or false
qiAbilityMeter.Enabled = character.Parent == workspace.Alive
replion.Client:WaitReplion("Data")
local equippedConnection = nil
equippedConnection = inventoryClient:OnEquip("Ability", function(item, _)
    if not item or item.Name ~= "Qi-Charge" then
        equippedConnection:Destroy()
        qiAbilityMeter.Enabled = false
    end
end)

character.AncestryChanged:Connect(function()
    qiAbilityMeter.Enabled = character.Parent == workspace.Alive
    if character.Parent ~= workspace.Alive then
        handleAdrenalineCharge(false)
    end
end)
