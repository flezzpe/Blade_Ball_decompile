--// reaper module, but named as a bounty

require(script.Parent._Types)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local ShockwaveEffect = require(ReplicatedStorage.Shared.ShockwaveEffect)
local SpeedModifiers = require(ReplicatedStorage.Shared.SpeedModifiers)
require(ReplicatedStorage.Shared.ThreadSafeTargetingHelper)

local function applyReaperEffect(character, isKill)
    if not character or not character:GetAttribute("IsReaper") or character:GetAttribute("PULSED") or not character:FindFirstChildWhichIsA("Humanoid", true) then
        return
    end

    if isKill then
        local kills = character:GetAttribute("ReaperKills") + 1
        character:SetAttribute("ReaperKills", math.clamp(kills, 1, 5))
    end

    local reaperKills = character:GetAttribute("ReaperKills")
    local reaperUpgrade = character:GetAttribute("ReaperUpgrade")
    local speedBoost

    if reaperUpgrade == 1 then
        speedBoost = reaperKills == 1 and 45 or 30 + reaperKills * 10
    elseif reaperUpgrade == 2 then
        speedBoost = 40 + reaperKills * 10
    else
        speedBoost = 50 + reaperKills * 10
    end

    SpeedModifiers:SetModifierFor(character, "Reaper", function(speed)
        return speed + (not speedBoost and 0 or speedBoost - 36)
    end, SpeedModifiers.Priority.ADD)

    local color = reaperUpgrade >= 2 and Color3.fromRGB(26, 0, 58) or Color3.fromRGB(58, 0, 0)
    local highlightColor = reaperUpgrade >= 2 and Color3.fromRGB(106, 0, 255) or Color3.fromRGB(255, 0, 0)

    ShockwaveEffect({
        cframe = character:GetPivot(),
        diameter = 25 + (reaperKills >= 4 and reaperKills * 2 or 0),
        color = reaperKills >= 4 and highlightColor or color,
        orientation = "Vertical"
    })

    if character:GetAttribute("HasReaperBodyEffects") then
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:FindFirstChild("IsReaper") then
                -- Handle Torso ParticleEmitters
                if descendant.Name == "Torso" then
                    if descendant:IsA("ParticleEmitter") then
                        if descendant:FindFirstChild("Configuration") then
                            if reaperKills >= 5 then
                                descendant.Enabled = true
                            end
                        else
                            descendant.Rate = reaperKills
                        end
                    elseif descendant:IsA("Attachment") and descendant:FindFirstChildWhichIsA("ParticleEmitter") then
                        for _, emitter in ipairs(descendant:GetChildren()) do
                            if emitter:IsA("ParticleEmitter") then
                                local folder = emitter:FindFirstChildWhichIsA("Folder")
                                local folderName = folder and folder.Name or emitter.Name
                                if tonumber(folderName) == reaperKills then
                                    emitter:Emit(3)
                                elseif folder then
                                    emitter:Emit(tonumber(folderName))
                                end
                            end
                        end
                    end
                elseif descendant.Name == "HumanoidRootPart" and descendant:IsA("Sound") then
                    if descendant:FindFirstChild("Station") then
                        descendant.Volume = reaperKills * 0.1
                        descendant.PlaybackSpeed = 1 - reaperKills * 0.05
                    else
                        descendant:Play()
                    end
                elseif descendant.Name == "Head" then
                    for _, particle in ipairs(descendant:GetChildren()) do
                        if particle:IsA("ParticleEmitter") and particle:FindFirstChildWhichIsA("Configuration") then
                            if reaperKills >= tonumber(particle:FindFirstChildWhichIsA("Configuration").Name) then
                                particle.Enabled = true
                            end
                        end
                    end
                elseif descendant:IsA("Beam") then
                    local attachment0 = descendant:FindFirstChild("Attachment0")
                    local attachment1 = descendant:FindFirstChild("Attachment1")
                    if attachment0 and attachment1 then
                        descendant.Enabled = reaperKills >= 2
                    end
                end
            end
        end
    else
        character:SetAttribute("HasReaperBodyEffects", true)
        local reaperFX = reaperUpgrade >= 2 and ReplicatedStorage.Misc.MaxReaperFX:Clone() or ReplicatedStorage.Misc.ReaperFX:Clone()
        for _, child in ipairs(reaperFX:GetChildren()) do
            local parentPart = character:FindFirstChild(child.Name)
            if parentPart then
                child.Parent = parentPart
                if child:IsA("ParticleEmitter") then
                    child:Emit(tonumber(child:FindFirstChildWhichIsA("Folder").Name))
                elseif child:IsA("Sound") then
                    child:Play()
                end
            end
        end
    end
end

if RunService:IsServer() then
    task.defer(function()
        require(ServerScriptService.Game.CoreGameModules.MapManager).CharacterKilled:Connect(function(_, character)
            applyReaperEffect(character, true)
        end)
    end)
end

return {
    iconId = "rbxassetid://17676181458",
    isPassive = true,
    equipped = function(user, config)
        user.character:SetAttribute("IsReaper", true)
        user.character:SetAttribute("ReaperKills", user.character:GetAttribute("LAST_REAPER_KILLS") or 0)
        user.character:SetAttribute("ReaperUpgrade", user.upgradeLevel)
        user.character:SetAttribute("LAST_REAPER_KILLS", nil)

        local parryEffect = Instance.new("BindableFunction")
        parryEffect.Name = "CustomParryEffect"
        parryEffect.OnInvoke = function()
            local clash = ServerStorage.clash:Clone()
            clash:PivotTo(user.character:GetPivot())
            clash.Parent = workspace.Runtime
            clash.ReaperAtt.shockwave:Emit(10)
            clash.ReaperAtt.zapper:Emit(1)
            clash.reaperSound:Play()
            Debris:AddItem(clash, 3)
        end

        config.addCleaner(function(cleanupType)
            if cleanupType == "PULSE" then
                SpeedModifiers:RemoveModifierFor(user.character, "Reaper")
                local connection
                connection = user.character:GetAttributeChangedSignal("PULSED"):Connect(function()
                    if not user.character:GetAttribute("PULSED") then
                        applyReaperEffect(user.character, false)
                        connection:Disconnect()
                    end
                end)
            else
                for _, desc in ipairs(user.character:GetDescendants()) do
                    if desc:FindFirstChild("IsReaper") then
                        desc:Destroy()
                    end
                end
                user.character:SetAttribute("HasReaperBodyEffects", false)
                user.character:SetAttribute("IsReaper", nil)
                user.character:SetAttribute("ReaperKills", nil)
                user.character:SetAttribute("LAST_REAPER_KILLS", user.character:GetAttribute("ReaperKills"))
                user.character:SetAttribute("ReaperUpgrade", nil)
                parryEffect:Destroy()
            end
        end)
    end
}
