require(script._Types)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HapticService = game:GetService("HapticService")

local QuestTrackingService, SeasonQuestService
local isHapticsEnabled = false

if RunService:IsClient() then
    require(ReplicatedStorage.Controllers.AnalyticsController)
        :GetRemoteConfigValue("HapticsEnabled", false)
        :andThen(function(enabled)
            isHapticsEnabled = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) and enabled
        end)
else
    QuestTrackingService = require(game.ServerScriptService.Game.Services.Quests.QuestTrackingService)
    SeasonQuestService = require(game.ServerScriptService.Game.Services.SeasonQuestService)
end

local getAbilityCooldownMultiplier = require(ReplicatedStorage.Shared.GetAbilityCooldownMultiplier)
local useBall2 = require(ReplicatedStorage.Shared.UseBall2)()

assert(useBall2, "UseBall2 is not enabled. New abilities module is only available with the new ball enabled.")

local abilities = {}
for _, module in script:GetChildren() do
    if module:IsA("ModuleScript") and not module.Name:match("^_") then
        assert(not abilities[module.Name], ("Duplicate ability module: %s"):format(module.Name))
        abilities[module.Name] = require(module)
    end
end

local activeCharacters = {}
workspace.Alive.ChildRemoved:Connect(function(character)
    activeCharacters[character] = nil
end)

local AbilityHandler = {}

local function createActivationInfo(character, abilityName)
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return nil end
    
    local rootPart = humanoid.RootPart
    if not rootPart then return nil end
    
    local rootAttachment = rootPart:FindFirstChild("RootAttachment")
    if not rootAttachment or not rootAttachment:IsA("Attachment") then return nil end
    
    local torso = character:FindFirstChild("Torso")
    if not torso or not torso:IsA("BasePart") then return nil end
    
    local animator = character:FindFirstChildWhichIsA("Animator", true)
    if not animator then return nil end
    
    local moveDirection = humanoid.MoveDirection.Magnitude == 0 and (humanoid.WalkToPoint.Magnitude ~= 0 and humanoid.WalkToPoint - rootPart.Position or Vector3.zero) or humanoid.MoveDirection
    moveDirection = moveDirection * Vector3.new(1, 0, 1)
    
    return {
        character = character,
        humanoid = humanoid,
        animator = animator,
        rootPart = rootPart,
        torso = torso,
        rootAttachment = rootAttachment,
        upgradeLevel = AbilityHandler.getUpgradeLevel(character, abilityName),
        player = Players:GetPlayerFromCharacter(character),
        moveDirection = moveDirection,
        cleanupSignal = AbilityHandler.getCleanupSignal(character).Event,
        Abilities = AbilityHandler
    }
end

function AbilityHandler.activateCharacterAbility(character, param1, param2, param3)
    local abilityName = AbilityHandler.getCharacterAbility(character)
    local abilityInfo = AbilityHandler.getAbilityInfoUnsafe(abilityName)
    
    AbilityHandler.getUpgradeLevel(character, abilityName)
    local cleaner = AbilityHandler.createCleaner(character)
    
    if RunService:IsClient() and character:GetAttribute("PULSED") then
        return false
    end
    
    if abilityInfo.isPassive or (abilityInfo.overrideCondition and not abilityInfo.overrideCondition(createActivationInfo(character, abilityName), param2)) then
        return false
    end
    
    local activationInfo = createActivationInfo(character, abilityName)
    if not activationInfo or activationInfo.humanoid.Health <= 0 then
        return false
    end
    
    local cooldown = AbilityHandler.getCooldown(character)
    if cooldown.usesRemaining <= 0 and not abilityInfo.overrideCondition then
        return false
    end
    
    if character:GetAttribute("PULSED") and not abilityInfo.overrideCondition then
        return false
    end
    
    if abilityInfo.canBeUsed and not (abilityInfo.canBeUsed(activationInfo) or abilityInfo.overrideCondition) then
        return false
    end
    
    if character.Parent ~= workspace.Alive or not workspace:GetAttribute("GameActive") then
        return false
    end
    
    local player = Players:GetPlayerFromCharacter(character)
    local isLocalPlayer = (RunService:IsClient() and player == Players.LocalPlayer) or (RunService:IsServer() and player == nil)
    
    local validationParams = isLocalPlayer and abilityInfo.localOwnerActivation and param3 or param2
    if abilityInfo.validateArguments then
        abilityInfo.validateArguments(validationParams, activationInfo)
    end
    
    if RunService:IsServer() and abilityInfo.serverActivationAsync then
        task.spawn(abilityInfo.serverActivationAsync, activationInfo, cleaner, validationParams)
    end
    
    if RunService:IsClient() and abilityInfo.anyClientActivationAsync then
        task.spawn(abilityInfo.anyClientActivationAsync, activationInfo, cleaner, validationParams)
    end
    
    if RunService:IsServer() then
        character:SetAttribute("AbilityActive", true)
        cleaner.addCleaner(function()
            character:SetAttribute("AbilityActive", nil)
        end)
    end
    
    if not abilityInfo.overrideCondition and (abilityInfo.cooldown or abilityInfo.getCooldown) then
        local cooldownExpiration = character:GetAttribute("CooldownExpiration") or 0
        character:SetAttribute("CooldownExpiration", math.max(cooldownExpiration, workspace:GetServerTimeNow()) + cooldown.cooldownDuration)
        
        local cleanupSignal = AbilityHandler.getCleanupSignal(character)
        if cleanupSignal and cooldown.cooldownDuration ~= 0 then
            task.delay(cooldown.cooldownDuration, cleanupSignal.Fire, cleanupSignal, "COOLDOWN_ELAPSED")
        end
    end
    
    if RunService:IsClient() then
        if isHapticsEnabled then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 1)
            task.delay(0.15, HapticService.SetMotor, HapticService, Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
        end
        if isLocalPlayer then
            ReplicatedStorage.Remotes.ActivateAbility:FireServer(validationParams)
        end
    elseif RunService:IsServer() then
        for _, otherPlayer in Players:GetPlayers() do
            if otherPlayer ~= player then
                ReplicatedStorage.Remotes.ActivateAbility:FireClient(otherPlayer, character, validationParams)
            end
        end
    end
    
    if RunService:IsServer() and player then
        task.spawn(function()
            QuestTrackingService:IncrementQuest(player, "UseAbility", { ConsumedAbility = abilityName }, 1)
            SeasonQuestService:IncrementCompletionArguments(player, "Use_Ability", { abilityName }, 1)
        end)
    end
    
    return true
end

local cleanupSignals = {}

function AbilityHandler.getCleanupSignal(character)
    if character then
        if not cleanupSignals[character] and typeof(character) == "Instance" then
            local signal = Instance.new("BindableEvent")
            signal.Name = ("CleanupFor%s"):format(character.Name)
            
            signal.Event:Once(function(reason)
                task.defer(function()
                    if cleanupSignals[character] == signal then
                        local isPassive = AbilityHandler.getAbilityInfoUnsafe(AbilityHandler.getCharacterAbility(character)).isPassive
                        if reason ~= "PULSE" or not isPassive then
                            signal:Destroy()
                            cleanupSignals[character] = nil
                            AbilityHandler.getCleanupSignal(character)
                            if isPassive then
                                AbilityHandler.setCharacterAbility(character, AbilityHandler.getCharacterAbility(character))
                            end
                        end
                    end
                end)
            end)
            
            cleanupSignals[character] = signal
            character:GetAttributeChangedSignal("Ability"):Once(function()
                signal:Fire("ABILITY_CHANGED")
            end)
        end
        return cleanupSignals[character]
    end
end

function AbilityHandler.callMassCleanup(reason, exclude)
    exclude = exclude or {}
    for character, signal in next, cleanupSignals do
        if not exclude[character] then
            signal:Fire(reason)
        end
    end
end

function AbilityHandler.callMassReactivation()
    for _, character in ipairs(workspace.Alive:GetChildren()) do
        local abilityName = AbilityHandler.getCharacterAbility(character)
        if not AbilityHandler.getAbilityInfoUnsafe(abilityName).cooldown then
            AbilityHandler.setCharacterAbility(character, abilityName)
        end
    end
end

function AbilityHandler.getAbilityInfoUnsafe(abilityName)
    return assert(abilities[abilityName], ("Ability id %s not valid"):format(abilityName))
end

function AbilityHandler.getUpgradeLevel(character, abilityName)
    local player = Players:GetPlayerFromCharacter(character)
    if player and player:FindFirstChild("Upgrades") and player.Upgrades:FindFirstChild(abilityName) then
        return player.Upgrades[abilityName].Value
    end
    return 1
end

function AbilityHandler.setCharacterAbility(character, abilityName)
    local activationInfo = createActivationInfo(character, abilityName or "Dash")
    if activationInfo then
        if activeCharacters[character] then
            task.spawn(activeCharacters[character])
            activeCharacters[character] = nil
        end
        
        if abilityName then
            character:SetAttribute("Ability", abilityName)
            local passive = abilities[abilityName].isPassive and abilities[abilityName].anyClientActivationAsync
            local function cleanupPassive()
                local cleaner = AbilityHandler.createCleaner(character)
                task.spawn(passive, activationInfo, cleaner, activationInfo)
                activeCharacters[character] = cleaner.cleanup
            end
            
            local signal = AbilityHandler.getCleanupSignal(character)
            signal.Event:Once(cleanupPassive)
            cleanupPassive()
        end
    end
end

function AbilityHandler.createCleaner(character)
    local cleaner = {}
    local cleanupTasks = {}
    
    cleaner.addCleaner = function(func)
        table.insert(cleanupTasks, func)
    end
    
    cleaner.cleanup = function()
        for _, task in ipairs(cleanupTasks) do
            task()
        end
        cleanupTasks = {}
    end
    
    character.AncestryChanged:Once(function()
        cleaner.cleanup()
    end)
    
    return cleaner
end

return AbilityHandler
