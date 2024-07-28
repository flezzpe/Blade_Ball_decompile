require(script._Types)

local v_u_1 = game:GetService("Players")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("ReplicatedStorage")
local v_u_4 = game:GetService("HapticService")
local v_u_5 = nil
local v_u_6 = nil
local v_u_7 = false
if v_u_2:IsClient() then
    require(v_u_3.Controllers.AnalyticsController):GetRemoteConfigValue("HapticsEnabled", false):andThen(function(p8)
        -- upvalues: (ref) v_u_7, (copy) v_u_4
        v_u_7 = v_u_4:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) and p8
    end)
else
    v_u_5 = require(game.ServerScriptService.Game.Services.Quests.QuestTrackingService)
    v_u_6 = require(game.ServerScriptService.Game.Services.SeasonQuestService)
end
local v_u_9 = require(v_u_3.Shared.GetAbilityCooldownMultiplier)
local v10 = require(v_u_3.Shared.UseBall2)()
assert(v10, "UseBall2 is not enabled. New abilities module is only available with the new ball is enabled.")
local v_u_11 = {}
for _, v12 in script:GetChildren() do
    if v12:IsA("ModuleScript") and not v12.Name:match("^_") then
        if v_u_11[v12.Name] then
            error((("Duplicate ability module: %*"):format(v12.Name)))
        end
        v_u_11[v12.Name] = require(v12)
    end
end
local v_u_13 = {}
workspace.Alive.ChildRemoved:Connect(function(p14)
    -- upvalues: (copy) v_u_13
    v_u_13[p14] = nil
end)
local v_u_15 = {}
local function createActivationInfo(p16, p17) -- line: 61
    -- upvalues: (copy) v_u_15, (copy) v_u_1
    local v18 = p16:FindFirstChildWhichIsA("Humanoid")
    if v18 then
        local v19 = v18.RootPart
        if v19 then
            local v20 = v19:FindFirstChild("RootAttachment")
            if v20 and v20:IsA("Attachment") then
                local v21 = p16:FindFirstChild("Torso")
                if v21 and v21:IsA("BasePart") then
                    local v22 = p16:FindFirstChildWhichIsA("Animator", true)
                    if v22 then
                        local v23 = Vector3.zero
                        if v18.MoveDirection.Magnitude == 0 then
                            if v18.WalkToPoint.Magnitude ~= 0 then
                                v23 = v18.WalkToPoint - v19.Position
                            end
                        else
                            v23 = v18.MoveDirection
                        end
                        local v24 = v23 * Vector3.new(1, 0, 1)
                        return {
                            ["character"] = p16,
                            ["humanoid"] = v18,
                            ["animator"] = v22,
                            ["rootPart"] = v19,
                            ["torso"] = v21,
                            ["rootAttachment"] = v20,
                            ["upgradeLevel"] = v_u_15.getUpgradeLevel(p16, p17),
                            ["player"] = v_u_1:GetPlayerFromCharacter(p16),
                            ["moveDirection"] = v24,
                            ["cleanupSignal"] = v_u_15.getCleanupSignal(p16).Event,
                            ["Abilities"] = v_u_15
                        }
                    end
                end
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function v_u_15.activateCharacterAbility(p_u_25, p26, p27, p28) -- line: 102
    -- upvalues: (copy) v_u_15, (copy) v_u_2, (copy) createActivationInfo, (copy) v_u_1, (ref) v_u_7, (copy) v_u_4, (copy) v_u_3, (ref) v_u_5, (ref) v_u_6
    local v_u_29 = v_u_15.getCharacterAbility(p_u_25)
    local v30 = v_u_15.getAbilityInfoUnsafe(v_u_29)
    v_u_15.getUpgradeLevel(p_u_25, v_u_29)
    local v31 = v_u_15.createCleaner(p_u_25)
    local v32 = p_u_25:GetAttribute("PULSED")
    if v_u_2:IsClient() and v32 then
        return false
    end
    if v30.isPassive then
        return false
    end
    local v33 = createActivationInfo(p_u_25, v_u_29)
    if not v33 then
        return false
    end
    local v34 = not p26 and v30.overrideCondition
    if v34 then
        v34 = v30.overrideCondition(v33, p27)
    end
    if v33.humanoid.Health <= 0 then
        return false
    end
    local v35 = v_u_15.getCooldown(p_u_25)
    if v35.usesRemaining <= 0 and not v34 then
        return false
    end
    if v32 and not v34 then
        return false
    end
    if v30.canBeUsed and not (v30.canBeUsed(v33) or v34) then
        return false
    end
    if p_u_25.Parent ~= workspace.Alive then
        return false
    end
    if not workspace:GetAttribute("GameActive") then
        return false
    end
    local v_u_36 = v_u_1:GetPlayerFromCharacter(p_u_25)
    local v37
    if v_u_2:IsClient() then
        v37 = v_u_36 == v_u_1.LocalPlayer
    else
        v37 = v_u_36 == nil
    end
    local v38 = nil
    if v37 then
        if v30.localOwnerActivation then
            local v39 = v30.localOwnerActivation
            local v40
            if v_u_2:IsClient() then
                v40 = assert(p28)
            else
                v40 = nil
            end
            v38 = v39(v33, v31, p27, v40)
        end
    else
        v38 = p27
    end
    if v30.validateArguments then
        v30.validateArguments(v38, v33)
    end
    if v_u_2:IsServer() and v30.serverActivationAsync then
        task.spawn(v30.serverActivationAsync, v33, v31, v38)
    end
    if v_u_2:IsClient() and v30.anyClientActivationAsync then
        task.spawn(v30.anyClientActivationAsync, v33, v31, v38)
    end
    if v_u_2:IsServer() then
        p_u_25:SetAttribute("AbilityActive", true)
        v31.addCleaner(function()
            -- upvalues: (copy) p_u_25
            p_u_25:SetAttribute("AbilityActive", nil)
        end)
    end
    if not v34 and (v30.cooldown or v30.getCooldown) then
        local v41 = p_u_25:GetAttribute("CooldownExpiration") or 0
        local v42 = workspace
        p_u_25:SetAttribute("CooldownExpiration", math.max(v41, v42:GetServerTimeNow()) + v35.cooldownDuration)
        local v43 = v_u_15.getCleanupSignal(p_u_25)
        if v43 and v35.cooldownDuration ~= 0 and v35.cooldownDuration ~= nil then
            task.delay(v35.cooldownDuration, v43.Fire, v43, "COOLDOWN_ELAPSED")
        end
    end
    if v_u_2:IsClient() then
        if v_u_7 then
            v_u_4:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 1)
            task.delay(0.15, v_u_4.SetMotor, v_u_4, Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
        end
        if v37 then
            v_u_3.Remotes.ActivateAbility:FireServer(v38)
        end
    elseif v_u_2:IsServer() then
        for _, v44 in v_u_1:GetPlayers() do
            if v44 ~= v_u_36 then
                v_u_3.Remotes.ActivateAbility:FireClient(v44, p_u_25, v38)
            end
        end
    end
    if v_u_2:IsServer() and v_u_36 ~= nil then
        task.spawn(function()
            -- upvalues: (ref) v_u_5, (copy) v_u_36, (copy) v_u_29, (ref) v_u_6
            v_u_5:IncrementQuest(v_u_36, "UseAbility", {
                ["ConsumedAbility"] = v_u_29
            }, 1)
            v_u_6:IncrementCompletionArguments(v_u_36, "Use_Ability", { v_u_29 }, 1)
        end)
    end
    return true
end
local v_u_45 = {}
function v_u_15.getCleanupSignal(p_u_46) -- line: 247
    -- upvalues: (copy) v_u_45, (copy) v_u_15
    if p_u_46 ~= nil then
        if not v_u_45[p_u_46] and typeof(p_u_46) == "Instance" then
            local v_u_47 = Instance.new("BindableEvent")
            v_u_47.Name = ("CleanupFor%*"):format(p_u_46.Name)
            v_u_47.Event:Once(function(p_u_48)
                -- upvalues: (ref) v_u_45, (copy) p_u_46, (copy) v_u_47, (ref) v_u_15
                task.defer(function()
                    -- upvalues: (ref) v_u_45, (ref) p_u_46, (ref) v_u_47, (ref) v_u_15, (copy) p_u_48
                    if v_u_45[p_u_46] == v_u_47 then
                        local v49 = v_u_15.getAbilityInfoUnsafe(v_u_15.getCharacterAbility(p_u_46)).isPassive
                        if p_u_48 ~= "PULSE" or not v49 then
                            v_u_47:Destroy()
                            v_u_45[p_u_46] = nil
                            v_u_15.getCleanupSignal(p_u_46)
                            if v49 then
                                v_u_15.setCharacterAbility(p_u_46, v_u_15.getCharacterAbility(p_u_46))
                            end
                        end
                    else
                        return
                    end
                end)
            end)
            v_u_45[p_u_46] = v_u_47
            p_u_46:GetAttributeChangedSignal("Ability"):Once(function()
                -- upvalues: (copy) v_u_47
                v_u_47:Fire("ABILITY_CHANGED")
            end)
        end
        return v_u_45[p_u_46]
    end
end
function v_u_15.callMassCleanup(p50, p51) -- line: 299
    -- upvalues: (copy) v_u_45
    local v52 = p51 or {}
    for v53, v54 in next, v_u_45 do
        if not v52[v53] then
            v54:Fire(p50)
        end
    end
end
function v_u_15.callMassReactivation() -- line: 307
    -- upvalues: (copy) v_u_15
    local v55 = next
    local v56, v57 = workspace.Alive:GetChildren()
    for _, v58 in v55, v56, v57 do
        local v59 = v_u_15.getCharacterAbility(v58)
        if not v_u_15.getAbilityInfoUnsafe(v59).cooldown then
            v_u_15.setCharacterAbility(v58, v59)
        end
    end
end
function v_u_15.getAbilityInfoUnsafe(p60) -- line: 322
    -- upvalues: (copy) v_u_11
    local v61 = v_u_11[p60]
    local v62 = ("Ability id %* not valid"):format(p60)
    return assert(v61, v62)
end
function v_u_15.getUpgradeLevel(p63, p64) -- line: 326
    -- upvalues: (copy) v_u_1
    local v65 = v_u_1:GetPlayerFromCharacter(p63)
    return not (v65 and v65:FindFirstChild("Upgrades") and v65.Upgrades:FindFirstChild(p64)) and 1 or v65.Upgrades[p64].Value
end
function v_u_15.setCharacterAbility(p66, p67) -- line: 339
    -- upvalues: (copy) createActivationInfo, (copy) v_u_13, (copy) v_u_15
    local v68 = createActivationInfo(p66, p67 or "Dash")
    if v68 then
        if v_u_13[p66] then
            task.spawn(v_u_13[p66])
            v_u_13[p66] = nil
        end
        if p67 then
            p66:SetAttribute("Ability", p67)
            local v69 = v_u_15.getAbilityInfoUnsafe(p67)
            if v69 and v69.equipped then
                v_u_13[p66] = v69.equipped(v68, v_u_15.createCleaner(p66))
            end
        end
    end
end
function v_u_15.getCharacterAbility(p70) -- line: 359
    return p70:GetAttribute("Ability") or "Dash"
end
function v_u_15.getCharacterAbilityChangedSignal(p71) -- line: 363
    return p71:GetAttributeChangedSignal("Ability")
end
function v_u_15.resetCharacterCooldowns(p72) -- line: 371
    p72:SetAttribute("CooldownExpiration", nil)
end
function v_u_15.getCooldown(p73) -- line: 384
    -- upvalues: (copy) v_u_15, (copy) v_u_1, (copy) v_u_9
    local v74 = v_u_15.getCharacterAbility(p73)
    local v75 = v_u_15.getAbilityInfoUnsafe(v74)
    local v76 = v75.cooldown or v75.getCooldown and v75.getCooldown(p73) or nil
    if v76 == nil or v76 <= 0 then
        return {
            ["usesRemaining"] = v75.uses or 1,
            ["cooldownRunning"] = false,
            ["currentCooldownRemaining"] = 0,
            ["totalCooldownRemaining"] = 0,
            ["currentCooldownRemainingAlpha"] = 0,
            ["totalCooldownRemainingAlpha"] = 0,
            ["cooldownDuration"] = 0
        }
    end
    if v75.cooldownReductionPerUpgrade then
        local v77 = v_u_15.getUpgradeLevel(p73, v74)
        v76 = v76 - v75.cooldownReductionPerUpgrade * v77
    end
    local v78 = v_u_1:GetPlayerFromCharacter(p73)
    if v78 then
        v76 = v76 * v_u_9(v78)
    end
    local v79 = (p73:GetAttribute("CooldownExpiration") or 0) - workspace:GetServerTimeNow()
    local v80 = math.max(0, v79)
    local v81 = {}
    local v82 = v75.uses or 1
    local v83 = v80 / v76
    local v84 = v82 - math.ceil(v83)
    v81.usesRemaining = math.max(0, v84)
    v81.cooldownRunning = v80 > 0
    v81.currentCooldownRemaining = v80 % v76
    v81.totalCooldownRemaining = v80
    v81.currentCooldownRemainingAlpha = v80 / v76 % 1
    v81.totalCooldownRemainingAlpha = v80 / v76
    v81.cooldownDuration = v76
    return v81
end
function v_u_15.createCleaner(p_u_85) -- line: 428
    -- upvalues: (copy) v_u_15, (copy) v_u_13
    local v_u_86 = v_u_15.getAbilityInfoUnsafe(v_u_15.getCharacterAbility(p_u_85)).isPassive
    local v87 = v_u_15.getCleanupSignal(p_u_85)
    local v_u_88 = {}
    local v_u_89 = 1
    local v_u_93 = {
        ["addCleaner"] = function(p_u_90)
            -- upvalues: (ref) v_u_89, (ref) v_u_88
            local v91 = typeof(p_u_90) == "Instance" and function()
                -- upvalues: (copy) p_u_90
                p_u_90:Destroy()
            end or typeof(p_u_90) == "thread" and function()
                -- upvalues: (copy) p_u_90
                pcall(task.cancel, p_u_90)
            end or p_u_90
            local v_u_92 = v_u_89
            v_u_89 = v_u_89 + 1
            v_u_88[v_u_92] = v91
            return function()
                -- upvalues: (ref) v_u_88, (copy) v_u_92
                v_u_88[v_u_92] = nil
            end
        end,
        ["clearAllCleaners"] = function()
            -- upvalues: (ref) v_u_88
            v_u_88 = {}
        end
    }
    if v87 then
        v87.Event:Connect(function(p94)
            -- upvalues: (ref) v_u_88, (copy) v_u_93, (copy) v_u_86, (ref) v_u_13, (copy) p_u_85
            for _, v95 in next, v_u_88 do
                task.spawn(xpcall, v95, warn, p94)
            end
            v_u_93.clearAllCleaners()
            if v_u_86 and v_u_13[p_u_85] then
                v_u_13[p_u_85] = nil
            end
        end)
    end
    return v_u_93
end
return v_u_15
