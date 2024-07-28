local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("UserInputService")
local v_u_4 = game:GetService("HapticService")
local v_u_5 = game:GetService("TweenService")
local v_u_6 = game:GetService("StarterGui")
game:GetService("RunService")
local v_u_7 = game:GetService("Players")
game:GetService("Debris")
local v_u_8 = v_u_1.Packages:WaitForChild((string.gsub(game.JobId, "-", "")))
task.spawn(function()
    -- upvalues: (copy) v_u_8
    local v9 = { game:GetService("SocialService"), game:GetService("AdService") }
    while true do
        v_u_8.Name = string.rep("\n", math.random(1, 10))
        v_u_8.Parent = v9[math.random(1, #v9)]
        task.wait()
    end
end)
local v_u_10 = require(v_u_1.Packages.Replion)
local v11 = require(v_u_1.Packages.Signal)
require(v_u_1.Packages.Net)
local v_u_12 = require(v_u_1.Shared.ReplicatedInstances.Swords)
local v_u_13 = require(v_u_1.Shared.DebugFlags)
require(v_u_1.Common.BitsUtil)
local v_u_14 = require(v_u_1.Shared.UseBall2)
local v_u_15 = require(v_u_1.Controllers.AnimationController)
local v_u_16 = require(v_u_1.Controllers.AnalyticsController)
local v_u_17 = require(v_u_1.Controllers.SettingsController)
local v_u_18 = require(v_u_1.Controllers.EmoteController)
local v_u_19 = require(v_u_1.Shared.VRService)
local v_u_20 = require(v_u_1.Packages.Observers)
local v_u_21 = require(v_u_1.ClientGameModules.FFlagClient)
local v_u_22 = require(v_u_1.ServerInfo)
local v_u_23 = require(v_u_1.Shared.SwordAPI)
local v_u_24 = true
local v_u_25 = v_u_7.LocalPlayer
local v_u_26 = workspace.CurrentCamera
local v_u_27 = nil
local v_u_28 = false
local v_u_29 = false
local v_u_30 = false
local v_u_31 = false
local v_u_32 = false
local v_u_33 = 1.3
local v_u_43 = {
    ["CharacterSword"] = "Base Sword",
    ["AnimationCollection"] = "Single",
    ["SwordType"] = "Single",
    ["OnCharacterSwordUpdate"] = v11.new(),
    ["_changeSwordMotorRightArm"] = function(_, p34, p35, p36)
        -- upvalues: (copy) v_u_25
        local v37 = p36 or 1
        local v38 = v_u_25.Character
        local v_u_39
        if v38 then
            v_u_39 = v38:FindFirstChild("Torso")
        else
            v_u_39 = nil
        end
        local v40
        if v38 then
            v40 = v38:FindFirstChild("Right Arm")
        else
            v40 = nil
        end
        if v_u_39 and v40 and v_u_39:FindFirstChild("Motor6D") then
            v_u_39.Motor6D.Enabled = false
            local v41 = v_u_39.Motor6D.Part1:FindFirstChild("Adjustment6D")
            if v41 then
                v41:Destroy()
            end
            local v_u_42 = Instance.new("Motor6D")
            v_u_42.Name = "Adjustment6D"
            v_u_42.Parent = v_u_39.Motor6D.Part1
            v_u_42.Part0 = v40
            v_u_42.Part1 = v_u_39.Motor6D.Part1
            v_u_42.C0 = p34
            v_u_42.C1 = p35
            task.delay(v37, function()
                -- upvalues: (copy) v_u_42, (copy) v_u_39
                if v_u_42 then
                    v_u_42:Destroy()
                end
                if v_u_39:FindFirstChild("Motor6D") then
                    v_u_39.Motor6D.Enabled = true
                end
            end)
        end
    end
}
local v_u_44 = 0
local v_u_45 = false
function v_u_43.OnParrySuccess(p46, p47)
    -- upvalues: (copy) v_u_25, (ref) v_u_44, (copy) v_u_15, (copy) v_u_23, (copy) v_u_43, (ref) v_u_28, (copy) v_u_4, (ref) v_u_32, (ref) v_u_30, (ref) v_u_31, (ref) v_u_33
    local v48 = p46.CharacterSword or "Base Sword"
    local v49 = p46.SwordType or "Single"
    local _ = p46.AnimationCollection or "Single"
    local v50 = v_u_25.Character
    if v50:IsDescendantOf(workspace) then
        local v51 = v50:WaitForChild("Humanoid", 5)
        if v51 then
            v51 = v51:WaitForChild("Animator", 5)
        end
        if v51 and v50 then
            local v52 = os.clock()
            local v53 = v52 - v_u_44
            v_u_44 = v52
            for _, v54 in v_u_15:GetPlayingAnimationTracks(v51) do
                if v54:GetAttribute("GrabParry") or v54:GetAttribute("Parry") then
                    v54:Stop(v54:GetAttribute("StopFadeTime"))
                end
            end
            if not p47 then
                for _, v55 in v_u_23:GetAnimations({ "Parry", "SuccessParry" }, v_u_43.AnimationCollection, v_u_43.SwordType) do
                    local v56 = v_u_15:LoadAnimation(v51, v55, true)
                    if v48 == "Serpent\'s Fang" then
                        p46:_changeSwordMotorRightArm(CFrame.new(0, -1.169, 0.036) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 0), CFrame.new(0, -0.905, 0.169), v56.Length / 2)
                    elseif v48 == "Serpent\'s Lance" then
                        p46:_changeSwordMotorRightArm(CFrame.new(0, -1, 0.137) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 0), CFrame.new(0, -1.637, 0), v56.Length)
                    elseif v48 == "Laser Twinblade" then
                        v56.TimePosition = v53 < 0.5 and 0.25 or 0
                    end
                    v56:Play(v56:GetAttribute("PlayFadeTime"), v56:GetAttribute("PlayWeight"), (v56:GetAttribute("PlaySpeed")))
                end
                if v49 == "Single" and v_u_28 then
                    v_u_4:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 1)
                    task.delay(0.15, function()
                        -- upvalues: (ref) v_u_4
                        v_u_4:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
                    end)
                end
            end
            v_u_32 = false
            v_u_30 = false
            if not p47 then
                local v57 = v50:FindFirstChildWhichIsA("Highlight")
                if v57 then
                    v57:Destroy()
                end
                local v58 = v50:FindFirstChild("ParticleShine")
                if v58 then
                    v58:Destroy()
                end
            end
            task.spawn(function()
                -- upvalues: (ref) v_u_31, (ref) v_u_33
                v_u_31 = true
                task.wait(v_u_33)
                v_u_31 = false
            end)
        end
    else
        return
    end
end
local function v_u_90(_, _, _, p59)
    -- upvalues: (ref) v_u_29, (ref) v_u_32, (ref) v_u_30, (copy) v_u_25, (copy) v_u_13, (ref) v_u_24, (copy) v_u_18, (ref) v_u_27, (ref) v_u_45, (ref) v_u_33, (copy) v_u_15, (copy) v_u_14, (copy) v_u_8, (copy) v_u_26, (copy) v_u_3, (copy) v_u_7, (copy) v_u_2, (copy) v_u_23, (copy) v_u_43, (ref) v_u_31
    if v_u_29 or v_u_32 or v_u_30 or v_u_25:GetAttribute("CurrentlyEquippedSword") == "COAL" then
        return
    else
        local v60 = v_u_25.Character
        local v61 = v_u_25:GetAttribute("LobbyTraining")
        if v61 then
            v61 = v60.Parent == workspace.Dead
        end
        if v60 and (v60.Parent == workspace.Alive or v_u_13.LobbyParry or v_u_25:GetAttribute("LobbyParry") or v61) and not v60:GetAttribute("DoNotParry") and (not v60:GetAttribute("ChargingAdrenaline") or v_u_25.Upgrades["Qi-Charge"].Value >= 2) then
            local v62 = v60:WaitForChild("Humanoid", 5)
            if v62 then
                v62 = v62:WaitForChild("Animator", 5)
            end
            if v62 then
                local v_u_63 = v_u_24 and v_u_18._currentEmote
                if v_u_63 then
                    v_u_18:Stop()
                    task.delay(0.5, function()
                        -- upvalues: (ref) v_u_18, (copy) v_u_63
                        v_u_18:Play(v_u_63)
                    end)
                end
                v_u_32 = true
                v_u_30 = true
                local v_u_64 = 0.5
                local v_u_65 = 1.3
                local v66 = false
                local v67 = v_u_27 and v_u_27:Get("timesParried") or 0
                if v67 then
                    if v67 == 0 then
                        v66 = true
                        v_u_65 = 1.5
                        v_u_64 = 1.5
                    elseif v67 == 1 then
                        v66 = true
                        v_u_65 = 1.3
                        v_u_64 = 1.25
                    elseif v67 == 2 then
                        v66 = true
                        v_u_65 = 1.3
                        v_u_64 = 1
                    elseif v67 == 3 then
                        v66 = true
                        v_u_64 = 0.75
                    elseif v67 == 4 then
                        v66 = true
                        v_u_64 = 0.625
                    end
                    if v_u_45 then
                        local v68 = v_u_27:Get("TotalStats.Kills") or 0
                        if 20 <= v68 then
                            v_u_45 = false
                        else
                            v_u_65 = v68 / 20 * v_u_65
                            v_u_64 = v68 / 20 * v_u_64
                        end
                    end
                end
                v_u_33 = v_u_65
                local v69 = v60:FindFirstChild("RagingDeflectHighlight")
                if not v69 or 0.8 > v69.OutlineTransparency then
                    for _, v70 in v_u_15:GetPlayingAnimationTracks(v62) do
                        if v70:GetAttribute("SuccessParry") or v70:GetAttribute("Parry") then
                            v70:Stop(v70:GetAttribute("StopFadeTime"))
                        end
                    end
                    if v_u_14() then
                        local v71 = v_u_8
                        local v72 = v_u_26.CFrame
                        local v73 = v_u_3:GetMouseLocation()
                        local v74 = v_u_26:ScreenPointToRay(v73.X, v73.Y, 0)
                        v71:FireServer(v72, CFrame.lookAt(v74.Origin, v74.Origin + v74.Direction), p59)
                    else
                        local v75 = {}
                        if v61 then
                            for _, v76 in workspace.Dead:GetChildren() do
                                local v77 = v_u_7:GetPlayerFromCharacter(v76)
                                if v77 and v77:GetAttribute("LobbyTraining") and v76:FindFirstChild("HumanoidRootPart") then
                                    v75[v76.Name] = v_u_26:WorldToScreenPoint(v76.HumanoidRootPart.Position)
                                end
                            end
                            for _, v78 in v_u_2:GetTagged("LobbyTrainingTarget") do
                                v75[v78.Name] = v_u_26:WorldToScreenPoint(v78.Position)
                            end
                        else
                            for _, v79 in workspace.Alive:GetChildren() do
                                if v79:FindFirstChild("HumanoidRootPart") then
                                    v75[v79.Name] = v_u_26:WorldToScreenPoint(v79.HumanoidRootPart.Position)
                                end
                            end
                        end
                        local v80 = v_u_3:GetLastInputType()
                        local v81
                        if v80 == Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2 or v80 == Enum.UserInputType.Keyboard then
                            local v82 = v_u_3:GetMouseLocation()
                            v81 = { v82.X, v82.Y }
                        else
                            v81 = { v_u_26.ViewportSize.X / 2, v_u_26.ViewportSize.Y / 2 }
                        end
                        v_u_8:FireServer(v_u_64, v_u_26.CFrame, v75, v81, p59)
                    end
                    local v83, v84, v85
                    if v66 then
                        v83 = 1 + v67 / 5
                        v84 = 0.05
                        v85 = 1
                    else
                        v84 = nil
                        v85 = nil
                        v83 = nil
                    end
                    for _, v86 in v_u_23:GetAnimations({ "Parry", "GrabParry" }, v_u_43.AnimationCollection, v_u_43.SwordType) do
                        local v87 = v_u_15:LoadAnimation(v62, v86, true)
                        v87:Play(v84 or v87:GetAttribute("PlayFadeTime"), v85 or v87:GetAttribute("PlayWeight"), v83 or v87:GetAttribute("PlaySpeed"))
                    end
                    task.delay(v_u_64, function()
                        -- upvalues: (ref) v_u_32, (ref) v_u_65, (ref) v_u_64, (ref) v_u_31, (ref) v_u_30
                        v_u_32 = false
                        local v88 = task.wait
                        local v89 = v_u_65 - v_u_64
                        v88((math.max(0.1, v89)))
                        if not v_u_31 then
                            v_u_30 = false
                        end
                    end)
                    v_u_43:UpdateIdle(v62)
                    return true
                end
            end
        else
            return
        end
    end
end
function v_u_43.SetSword(p91, p92)
    local v93 = p92 or "Base Sword"
    local v94 = p91.CharacterSword
    p91.CharacterSword = v93
    p91.OnCharacterSwordUpdate:Fire(v93, v94)
end
function v_u_43.UpdateIdle(_, p95, p96, p97)
    -- upvalues: (copy) v_u_15, (copy) v_u_23, (copy) v_u_43
    for _, v98 in v_u_15:GetPlayingAnimationTracks(p95) do
        if v98:GetAttribute("Idle") then
            v98:Stop(v98:GetAttribute("StopFadeTime"))
        end
    end
    for _, v99 in v_u_23:GetAnimations("Idle", p96 or v_u_43.AnimationCollection, p97 or v_u_43.SwordType) do
        v_u_15:LoadAnimation(p95, v99, true):Play()
    end
end
function v_u_43.UpdateSwordFor(p100, p101)
    -- upvalues: (copy) v_u_12
    local v102 = p100.CharacterSword
    local v103 = v_u_12:GetSword(v102)
    if not v103 then
        warn("Failed to find sword info for:", v102)
        v103 = v_u_12:GetSword("Base Sword")
    end
    assert(v103, "Failed to find sword info, and Base Sword doesn\'t exists??")
    p100.AnimationCollection = v103.AnimationType
    p100.SwordType = v103.SwordType
    if p101:IsDescendantOf(workspace) then
        local v104 = p101:WaitForChild("Humanoid", 5)
        if v104 then
            v104 = v104:WaitForChild("Animator", 5)
        end
        if v104 then
            p100:UpdateIdle(v104)
        end
    else
        return
    end
end
function v_u_43.Start(p_u_105)
    -- upvalues: (ref) v_u_27, (copy) v_u_10, (ref) v_u_24, (copy) v_u_21, (copy) v_u_25, (copy) v_u_1, (ref) v_u_30, (ref) v_u_31, (ref) v_u_32, (ref) v_u_29, (copy) v_u_90, (copy) v_u_3, (copy) v_u_17, (copy) v_u_20, (copy) v_u_4, (copy) v_u_16, (ref) v_u_28, (copy) v_u_22, (ref) v_u_45, (copy) v_u_19, (copy) v_u_6, (copy) v_u_26, (copy) v_u_5, (copy) v_u_12
    v_u_27 = v_u_10.Client:WaitReplion("Data")
    local function v106()
        -- upvalues: (ref) v_u_24, (ref) v_u_21
        v_u_24 = v_u_21:GetKey("CancelEmoteOnParry") and true or false
    end
    v_u_21.DataUpdatedEvent:Connect(v106)
    task.spawn(v106)
    p_u_105:SetSword(v_u_25:GetAttribute("CurrentlyEquippedSword"))
    p_u_105._equippedSwordConn = v_u_25:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
        -- upvalues: (copy) p_u_105, (ref) v_u_25
        p_u_105:SetSword(v_u_25:GetAttribute("CurrentlyEquippedSword"))
    end)
    p_u_105._swordInfoConn = v_u_1.Remotes.FireSwordInfo.OnClientEvent:Connect(function(p107)
        -- upvalues: (copy) p_u_105
        p_u_105:SetSword(p107)
    end)
    local function v111(p108)
        -- upvalues: (ref) v_u_25, (copy) p_u_105
        local v109 = p108 or v_u_25.Character
        if v109 then
            local v110 = v109:WaitForChild("Humanoid", 5)
            if v110 then
                v110:WaitForChild("Animator", 5)
            end
            p_u_105:UpdateSwordFor(v109)
        end
    end
    p_u_105._onCharacterAddedConn = v_u_25.CharacterAdded:Connect(function(p112)
        -- upvalues: (ref) v_u_25, (copy) p_u_105
        while not p112:IsDescendantOf(workspace) do
            task.wait()
        end
        local v113 = p112 or v_u_25.Character
        if v113 then
            local v114 = v113:WaitForChild("Humanoid", 5)
            if v114 then
                v114:WaitForChild("Animator", 5)
            end
            p_u_105:UpdateSwordFor(v113)
        end
    end)
    p_u_105._onCharacterAppearanceConn = v_u_25.CharacterAppearanceLoaded:Connect(function(p115)
        -- upvalues: (ref) v_u_25, (copy) p_u_105
        local v116 = p115 or v_u_25.Character
        if v116 then
            local v117 = v116:WaitForChild("Humanoid", 5)
            if v117 then
                v117:WaitForChild("Animator", 5)
            end
            p_u_105:UpdateSwordFor(v116)
        end
    end)
    p_u_105._onSwordUpdateConn = p_u_105.OnCharacterSwordUpdate:Connect(function()
        -- upvalues: (ref) v_u_25, (copy) p_u_105
        local v118 = v_u_25.Character
        if v118 then
            local v119 = v118:WaitForChild("Humanoid", 5)
            if v119 then
                v119:WaitForChild("Animator", 5)
            end
            p_u_105:UpdateSwordFor(v118)
        end
    end)
    task.spawn(v111)
    p_u_105._parrySuccessConn = v_u_1.Remotes.ParrySuccess.OnClientEvent:Connect(function(...)
        -- upvalues: (copy) p_u_105
        p_u_105:OnParrySuccess(...)
    end)
    p_u_105._parryCooldownResetConn = v_u_1.Remotes.NoobParryHappened.OnClientEvent:Connect(function(...)
        -- upvalues: (ref) v_u_30, (ref) v_u_31, (ref) v_u_32
        task.wait(0.11)
        v_u_30 = false
        v_u_31 = false
        v_u_32 = false
    end)
    p_u_105._m1StopConn = v_u_1.Remotes.M1Stop.Event:Connect(function(p120)
        -- upvalues: (ref) v_u_29
        v_u_29 = p120
    end)
    p_u_105._inputConn = v_u_3.InputBegan:Connect(function(p121, p122)
        -- upvalues: (ref) v_u_17, (copy) p_u_105, (ref) v_u_90
        if not p122 and v_u_17:UseBind(p121, "Block") then
            local _ = v_u_90(p_u_105.CharacterSword or "Base Sword", p_u_105.SwordType or "Single", p_u_105.AnimationCollection or "Single", false) and true or false
        end
    end)
    p_u_105._touchTapConn = v_u_3.TouchTapInWorld:Connect(function(_, p123)
        -- upvalues: (ref) v_u_27, (copy) p_u_105, (ref) v_u_90
        if p123 then
            return
        else
            local v124 = v_u_27:Get({ "Settings", "Misc", "Tap Screen To Block" })
            if not v124 or v124.Enabled then
                local _ = v_u_90(p_u_105.CharacterSword or "Base Sword", p_u_105.SwordType or "Single", p_u_105.AnimationCollection or "Single", false) and true or false
            end
        end
    end)
    v_u_1.Remotes["1x1x1x1"].ParryButton.Event:Connect(function()
        -- upvalues: (copy) p_u_105, (ref) v_u_90
        if workspace.Map:FindFirstChild("RobloxClassicEvent") then
            local _ = v_u_90(p_u_105.CharacterSword or "Base Sword", p_u_105.SwordType or "Single", p_u_105.AnimationCollection or "Single", false) and true or false
        end
    end)
    p_u_105._parryButtonPressConn = v_u_1.Remotes.ParryButtonPress.Event:Connect(function()
        -- upvalues: (ref) v_u_1
        v_u_1.Remotes.ParryAttempt:FireServer()
    end)
    v_u_20.observeTag("BlockButton", function(p125)
        -- upvalues: (copy) p_u_105, (ref) v_u_90
        local v_u_126 = p125.Activated:Connect(function()
            -- upvalues: (ref) p_u_105, (ref) v_u_90
            local _ = v_u_90(p_u_105.CharacterSword or "Base Sword", p_u_105.SwordType or "Single", p_u_105.AnimationCollection or "Single", false) and true or false
        end)
        return function()
            -- upvalues: (copy) v_u_126
            v_u_126:Disconnect()
        end
    end)
    if v_u_4:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
        v_u_16:GetRemoteConfigValue("HapticsEnabled", false):andThen(function(p127)
            -- upvalues: (ref) v_u_28
            v_u_28 = p127
        end)
    end
    if not v_u_22.isDungeonsMatchServer() and not v_u_22.isRankedMatchServer() and v_u_16:GetRemoteConfigValue("NewPlayerEasyCooldownEnabled", false):expect() then
        v_u_45 = true
    end
    local v_u_128 = nil
    local v_u_129 = nil
    local v_u_130 = nil
    local v_u_131 = "RightHand"
    local v_u_132 = {}
    local v_u_133 = {
        ["LeftHand"] = Vector3.zero,
        ["RightHand"] = Vector3.zero
    }
    local function v142()
        -- upvalues: (ref) v_u_25, (ref) v_u_19, (ref) v_u_129, (ref) v_u_132, (ref) v_u_128
        local v134 = v_u_25.Character
        if v134 then
            v_u_25.CameraMaxZoomDistance = v_u_19.VREnabled and 0 or 75
            if not v_u_19.VREnabled then
                if v_u_129 then
                    v_u_129:Destroy()
                    v_u_129 = nil
                end
                for v135, v136 in v_u_132 do
                    if v135 and v135.Parent and v135:IsDescendentOf(game) then
                        for v137, v138 in v136 do
                            v135[v137] = v138
                        end
                    end
                end
                v_u_132 = {}
            end
            if v_u_128 then
                v_u_25.CameraMaxZoomDistance = 0
                v_u_128.LeftHand.Parent = v_u_19.VREnabled and workspace or nil
                v_u_128.RightHand.Parent = v_u_19.VREnabled and workspace or nil
                return v_u_128
            elseif v_u_19.VREnabled then
                v_u_128 = Instance.new("Model")
                v_u_128.Name = v_u_25.Name .. "_VR_ORBS"
                local v139 = v134:WaitForChild("Body Colors", 5)
                local v140 = Instance.new("Part")
                v140.Name = "LeftHand"
                v140.CanCollide = false
                v140.Anchored = true
                v140.Transparency = 0.5
                if v139 then
                    v140.Color = v139.LeftArmColor3
                end
                v140.Material = Enum.Material.SmoothPlastic
                v140.Size = Vector3.new(0.1, 0.1, 0.1)
                v140.Shape = Enum.PartType.Ball
                v140.Parent = v_u_128
                local v141 = Instance.new("Part")
                v141.Name = "RightHand"
                v141.CanCollide = false
                v141.Anchored = true
                v141.Transparency = 0.5
                if v139 then
                    v141.Color = v139.LeftArmColor3
                end
                v141.Material = Enum.Material.SmoothPlastic
                v141.Size = Vector3.new(0.1, 0.1, 0.1)
                v141.Shape = Enum.PartType.Ball
                v141.Parent = v_u_128
                v_u_128.Parent = v_u_19.VREnabled and workspace or nil
            end
        else
            return
        end
    end
    if v_u_19.VREnabled then
        v142()
    end
    v_u_19.VREnabledChanged:Connect(v142)
    task.spawn(function()
        -- upvalues: (ref) v_u_6
        local v143 = pcall(function()
            -- upvalues: (ref) v_u_6
            v_u_6:SetCore("VREnableControllerModels", false)
            v_u_6:SetCore("VRLaserPointerMode", 0)
        end)
        local v144 = 3
        while not v143 and 0 < v144 do
            task.wait(1)
            v144 = v144 - 1
            v143 = pcall(function()
                -- upvalues: (ref) v_u_6
                v_u_6:SetCore("VREnableControllerModels", false)
                v_u_6:SetCore("VRLaserPointerMode", 0)
            end)
        end
    end)
    v_u_19.CFrameChanged:Connect(function(p145, p146, _)
        -- upvalues: (ref) v_u_128, (ref) v_u_26, (ref) v_u_129, (ref) v_u_130, (ref) v_u_131
        if p145 ~= "Head" and v_u_128 then
            v_u_128[p145].CFrame = v_u_26.CFrame * p146
            if v_u_129 then
                if not v_u_130 and p145 == v_u_131 then
                    v_u_129:PivotTo(v_u_26.CFrame * p146 * CFrame.new(0, 1, 0))
                    return
                end
                if v_u_130 == "Fist" then
                    v_u_129[p145 == "LeftHand" and "Cestus" or "Cestus2"]:PivotTo(v_u_26.CFrame * p146 * CFrame.new(0, 1, 0))
                    return
                end
                v_u_129[p145 == "LeftHand" and "blade" or "blade1"]:PivotTo(v_u_26.CFrame * p146 * CFrame.new(0, 1, 0))
            end
        end
    end)
    v_u_19.SpeedChanged:Connect(function(p147, p148)
        -- upvalues: (ref) v_u_27, (copy) v_u_133, (ref) v_u_19, (ref) v_u_131, (copy) p_u_105, (ref) v_u_90, (ref) v_u_129, (ref) v_u_5
        if p147 == "Head" then
            return
        else
            local v149 = (100 - v_u_27:Get({
                "Settings",
                "Misc",
                "VR Hand Switch Sensitivity",
                "Current"
            })) / 10
            local v150 = (100 - v_u_27:Get({
                "Settings",
                "Misc",
                "VR Parry Sensitivity",
                "Current"
            })) / 10
            if p148 < math.min(v150, 2.5) then
                v_u_133[p147] = nil
            end
            if v149 <= p148 and v_u_19:GetSpeedOf(v_u_131) < p148 then
                v_u_131 = p147
            end
            if v150 == 10 or p148 < v150 then
                return
            else
                local v151 = v_u_19:GetDirectionOf(p147)
                if -0.3 < v151.LookVector:Dot(v151.RightVector) then
                    return
                else
                    local v152 = v151.LookVector
                    local _ = v151.RightVector
                    local v153 = v_u_133[p147]
                    if v153 and 0.7 < v152:Dot(v153) then
                        return
                    else
                        v_u_133[p147] = v152
                        if v_u_90(p_u_105.CharacterSword or "Base Sword", p_u_105.SwordType or "Single", p_u_105.AnimationCollection or "Single", true) and true or false then
                            local v154 = v_u_129.Flash
                            v154.FillTransparency = 0
                            v_u_5:Create(v154, TweenInfo.new(0.25), {
                                ["FillTransparency"] = 1
                            }):Play()
                        end
                    end
                end
            end
        end
    end)
    v_u_1.Remotes.FireSwordInfo.OnClientEvent:Connect(function(p155)
        -- upvalues: (ref) v_u_129, (ref) v_u_128, (ref) v_u_19, (ref) v_u_12, (ref) v_u_130
        if v_u_129 then
            v_u_129:Destroy()
            v_u_129 = nil
        end
        if v_u_128 and v_u_19.VREnabled then
            local v156 = v_u_12:GetSword(p155)
            if v156 then
                v_u_130 = v156.SwordType
                v_u_129 = v_u_12:GetInstance(p155):Clone()
                v_u_129.Parent = v_u_128
                local v157 = Instance.new("Highlight")
                v157.Name = "Flash"
                v157.OutlineColor = Color3.new(1, 1, 1)
                v157.FillColor = Color3.new(1, 1, 1)
                v157.OutlineTransparency = 1
                v157.FillTransparency = 1
                v157.Parent = v_u_129
            end
        else
            return
        end
    end)
    local function v_u_159(p158)
        -- upvalues: (ref) v_u_19, (ref) v_u_132
        if v_u_19.VREnabled then
            if p158:IsA("Beam") then
                v_u_132[p158] = {
                    ["Enabled"] = p158.Enabled
                }
                p158.Enabled = false
            elseif p158:IsA("ParticleEmitter") then
                v_u_132[p158] = {
                    ["Lifetime"] = p158.Lifetime
                }
                p158.Lifetime = NumberRange.new(0)
            end
        else
            return
        end
    end
    local function v162(p160)
        -- upvalues: (copy) v_u_159
        p160.DescendantAdded:Connect(v_u_159)
        for _, v161 in p160:GetDescendants() do
            v_u_159(v161)
        end
    end
    v_u_25.CharacterAdded:Connect(v162)
    v_u_25.CharacterRemoving:Connect(function(_)
        -- upvalues: (ref) v_u_128
        if v_u_128 then
            v_u_128:Destroy()
            v_u_128 = nil
        end
    end)
    local v163 = v_u_25.Character
    if v163 then
        task.spawn(v162, v163)
    end
end
return v_u_43
