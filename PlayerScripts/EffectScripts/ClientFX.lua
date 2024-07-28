-- decompiled using medal by alpaca and jujhar

local v_u_1 = game:GetService("Debris")
local v_u_2 = game:GetService("Lighting")
local v_u_3 = game:GetService("Players")
local v_u_4 = game:GetService("ReplicatedStorage")
local v_u_5 = game:GetService("RunService")
local v_u_6 = game:GetService("TweenService")
local v_u_7 = workspace.CurrentCamera
require(v_u_4.ClientGameModules.CameraShaker)
local v_u_8 = require(v_u_4.Misc.LightningBolt)
local v9 = require(v_u_4.Packages.Replion)
require(v_u_4.Packages.Trove)
local v10 = require(v_u_4.Packages.Net)
local v_u_11 = require(v_u_4.Misc.LightningBolt.LightningSparks)
require(v_u_4.Misc.LightningBolt.LightningExplosion)
local v_u_12 = require(v_u_4.Shared.PlaceGhost)
local v_u_13 = require(v_u_4.Common.BitsUtil)
local v14 = require(v_u_4.Controllers.VFXController)
local v_u_15 = require(v_u_4.Packages.Observers)
local v_u_16 = require(v_u_4.Shared.ThreadSafeTargetingHelper)
local v_u_17 = require(v_u_4.Shared.TweenColor)
local v_u_18 = require(v_u_4.Shared.FastUtils)
local v_u_19 = require(v_u_4.Shared.ReplicatedInstances.Swords)
local v_u_20 = require(v_u_4.Shared.ReplicatedInstances.SwordFX)
local v_u_21 = require(v_u_4.Shared.ReplicatedInstances)
workspace:GetAttributeChangedSignal("CurrentlySelectedMode"):Connect(function()
    -- upvalues: (copy) v_u_3, (copy) v_u_19, (copy) v_u_21, (copy) v_u_20
    local v22 = {}
    for _, v23 in v_u_3:GetPlayers() do
        local v24 = v23:GetAttribute("CurrentlyEquippedSword")
        if v24 and not table.find(v22, v24) then
            table.insert(v22, v24)
        end
    end
    local v25 = { "SlashEffect" }
    for _, v26 in v22 do
        local v27 = v_u_19:GetSword(v26)
        if v27 and v27.SlashName and not table.find(v25, v27.SlashName) then
            local v28 = v27.SlashName
            table.insert(v25, v28)
        end
    end
    local v29 = v_u_21:GetOrCreateCollection("SwordFX")
    if v29 then
        for _, v30 in v29.Instances do
            if v30 and not v29.InstancesFetching[v30.Name] and (not v29.InstancesAwaitingThreads[v30.Name] or #v29.InstancesAwaitingThreads[v30.Name] <= 0) and not table.find(v25, v30.Name) then
                v29.Instances[v30.Name] = nil
                v30:Destroy()
            end
        end
    end
    for _, v31 in v25 do
        v_u_20:GetInstance(v31)
    end
end)
v_u_15.observePlayer(function(p32)
    -- upvalues: (copy) v_u_15, (copy) v_u_19, (copy) v_u_20
    return v_u_15.observeAttribute(p32, "CurrentlyEquippedSword", function(p33)
        -- upvalues: (ref) v_u_19, (ref) v_u_20
        local v34
        if typeof(p33) == "string" then
            v34 = v_u_19:GetSword(p33)
        else
            v34 = false
        end
        if v34 and v34.SlashName then
            v_u_20:GetInstance(v34.SlashName)
        end
    end)
end)
local v_u_35 = require(script.Abilities.ChieftainsTotemEffects)
local v_u_36 = require(script.Abilities.QuantumArenaEffects)
local v_u_37 = require(script.Abilities.TimeHoleEffects)
require(script.AutoSwords)
local v_u_38 = 1
v14.OnEmissionMultiplierUpdate:Connect(function(p39)
    -- upvalues: (ref) v_u_38
    v_u_38 = p39
end)
local v_u_40 = nil
v9.Client:AwaitReplion("Data", function(p41)
    -- upvalues: (ref) v_u_40
    v_u_40 = p41
end)
local v_u_42 = true
task.spawn(function()
    -- upvalues: (ref) v_u_42
    task.wait(10)
    v_u_42 = false
end)
local function ShadowFollow(p43, p44, p_u_45, p46, p47) -- line: 106
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) v_u_6
    local v_u_48 = TweenInfo.new(p_u_45 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local v49 = v_u_4.Misc.ShadowFolder
    local v50 = 0
    while v50 < p44 do
        task.wait(p46)
        v50 = v50 + p46
        local v51 = {
            v49.Head:Clone(),
            v49["Left Arm"]:Clone(),
            v49["Left Leg"]:Clone(),
            v49["Right Arm"]:Clone(),
            v49["Right Leg"]:Clone(),
            v49.Torso:Clone()
        }
        if p47 then
            local v52 = Color3.new(0.631373, 0.980392, 1)
            for _, v53 in v51 do
                v53.Color = v52
            end
        end
        for _, v_u_54 in v51 do
            v_u_54.CFrame = p43[v_u_54.Name].CFrame
            v_u_54.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_54, p_u_45)
            task.spawn(function()
                -- upvalues: (copy) p_u_45, (ref) v_u_6, (copy) v_u_54, (copy) v_u_48
                task.wait(p_u_45 / 2)
                v_u_6:Create(v_u_54, v_u_48, {
                    ["Transparency"] = 1,
                    ["Size"] = Vector3.new(0, 0, 0)
                }):Play()
            end)
        end
    end
end
local function phasebypass(p55) -- line: 145
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) v_u_6
    local v56 = v_u_4.Misc.PhaseFolder
    local v57 = 0
    while v57 < 2 do
        task.wait(0.033334)
        v57 = v57 + 0.033334
        local v58 = v56.Head:Clone()
        local v59 = v56.LeftArm:Clone()
        local v60 = v56.LeftLeg:Clone()
        local v61 = v56.RightArm:Clone()
        local v62 = v56.RightLeg:Clone()
        local v63 = v56.Torso:Clone()
        local v64 = v56.zh:Clone()
        local v65 = v56.zla:Clone()
        local v66 = v56.zll:Clone()
        local v67 = v56.zra:Clone()
        local v68 = v56.zrl:Clone()
        local v69 = v56.zt:Clone()
        if math.random(0, 100) < 15 then
            local v70 = Color3.new(0, 1, 0.25098)
            v58.Color = v70
            v59.Color = v70
            v60.Color = v70
            v61.Color = v70
            v62.Color = v70
            v63.Color = v70
        end
        v58.CFrame = p55.Head.CFrame
        v59.CFrame = p55["Left Arm"].CFrame
        v60.CFrame = p55["Left Leg"].CFrame
        v61.CFrame = p55["Right Arm"].CFrame
        v62.CFrame = p55["Right Leg"].CFrame
        v63.CFrame = p55.Torso.CFrame
        v64.CFrame = p55.Head.CFrame
        v65.CFrame = p55["Left Arm"].CFrame
        v66.CFrame = p55["Left Leg"].CFrame
        v67.CFrame = p55["Right Arm"].CFrame
        v68.CFrame = p55["Right Leg"].CFrame
        v69.CFrame = p55.Torso.CFrame
        for _, v_u_71 in ipairs({
            v58,
            v59,
            v60,
            v61,
            v62,
            v63,
            v64,
            v65,
            v66,
            v67,
            v68,
            v69
        }) do
            v_u_71.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_71, 0.4)
            task.spawn(function()
                -- upvalues: (copy) v_u_71, (ref) v_u_6
                local v72 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)
                local v73 = {
                    ["Size"] = Vector3.new(0, 0, 0)
                }
                local v74 = v_u_71.Position
                local v75 = (math.random(0, 40) - 20) * 0.1
                local v76 = (math.random(0, 40) - 20) * 0.1
                local v77 = (math.random(0, 40) - 20) * 0.1
                v73.Position = v74 + Vector3.new(v75, v76, v77)
                v_u_6:Create(v_u_71, v72, v73):Play()
            end)
        end
    end
end
local function shockwave(p78, p79, p80, p81, p82, p83, p84) -- line: 198
    -- upvalues: (copy) v_u_4, (copy) v_u_6, (copy) v_u_1
    local v85 = v_u_4.Misc.Wave:Clone()
    v85.Parent = workspace.Runtime
    if p83 then
        v85.Transparency = 1
        v85.Size = Vector3.new(p79, 0.25, p79)
    else
        v85.Size = Vector3.new(0.01, 0.5, 0.01)
    end
    if p82 then
        v85.CFrame = p78.CFrame
    else
        v85.CFrame = p78.CFrame * CFrame.Angles(1.51, 0, 0)
    end
    if p84 then
        v85.CFrame = v85.CFrame * CFrame.new(0, -2.5, 0)
    end
    if p81 then
        v85.Color = p81
    end
    local v86 = p83 and Vector3.new(0.01, 0.25, 0.01) or Vector3.new(p79, 0.5, p79)
    local v_u_87 = p80 or 0.3
    local v88 = v_u_6:Create(v85, TweenInfo.new(v_u_87, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
        ["Size"] = v86
    })
    local v_u_89 = v_u_6:Create(v85, TweenInfo.new(v_u_87 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
        ["Transparency"] = 1
    })
    if p83 then
        v_u_6:Create(v85, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
            ["Transparency"] = 0
        }):Play()
    end
    v88:Play()
    v_u_1:AddItem(v85, v_u_87)
    task.spawn(function()
        -- upvalues: (ref) v_u_87, (copy) v_u_89
        task.wait(v_u_87 / 2)
        v_u_89:Play()
    end)
end
v_u_4.Remotes.ShadowFollow.OnClientEvent:Connect(function(p_u_90, p_u_91, p_u_92, p_u_93, p_u_94)
    -- upvalues: (copy) ShadowFollow, (copy) shockwave, (copy) v_u_4, (ref) v_u_38, (copy) v_u_1
    task.spawn(function()
        -- upvalues: (ref) ShadowFollow, (copy) p_u_90, (copy) p_u_91, (copy) p_u_92, (copy) p_u_93, (copy) p_u_94
        ShadowFollow(p_u_90, p_u_91, p_u_92, p_u_93, p_u_94)
    end)
    local v_u_95 = Color3.new(0, 0, 0)
    task.spawn(function()
        -- upvalues: (copy) p_u_94, (ref) v_u_95, (ref) shockwave, (copy) p_u_90
        if p_u_94 then
            v_u_95 = Color3.new(0.631373, 0.980392, 1)
        end
        shockwave(p_u_90.HumanoidRootPart, 20, nil, v_u_95)
    end)
    local v96 = v_u_4.Misc.swooshypart:Clone()
    v96.Parent = p_u_90.HumanoidRootPart
    v96.CFrame = p_u_90.HumanoidRootPart.CFrame
    v96.WeldConstraint.Part1 = p_u_90.HumanoidRootPart
    local v_u_97 = v96.partypart.ParticleEmitter
    if p_u_94 then
        v_u_97.Color = ColorSequence.new(v_u_95)
    end
    local v98 = v96.Swoosh
    task.spawn(function()
        -- upvalues: (copy) p_u_94, (copy) v_u_97, (ref) v_u_38
        local v99 = 0
        local v100
        if p_u_94 then
            v100 = 0.9
        else
            v100 = 0.6
        end
        while v99 < v100 do
            task.wait(0.2)
            v99 = v99 + 0.08
            local v101 = v_u_97
            local v102 = v_u_38 * 10
            v101:Emit((math.min(0, v102)))
        end
    end)
    local v103 = math.random(9, 11) * 0.1
    if p_u_94 then
        v98 = v96.Flashstep
    end
    v98.PlaybackSpeed = v103
    v98:Play()
    v_u_1:AddItem(v96, 5)
    task.wait(p_u_91 * 1.33 - 0.2)
    v98.PlaybackSpeed = math.random(9, 11) * 0.1
    v98:Play()
end)
local function parrySuccessAll(p104, p105, p106, p107) -- line: 295
    -- upvalues: (ref) v_u_40, (copy) v_u_19, (copy) v_u_20, (copy) v_u_17, (copy) v_u_1, (ref) v_u_38
    if v_u_40 then
        p104 = v_u_40:Get({
            "Settings",
            "Misc",
            "Remove Swords SFX",
            "Enabled"
        }) and "SlashEffect" or p104
    end
    local v108 = v_u_19:GetSword(p106)
    if not v108 then
        return
    end
    local v109 = v_u_20:GetInstance(p104)
    if not v109 then
        return
    end
    local v110 = v109:Clone()
    local v111
    if typeof(p107) == "Instance" then
        v111 = p107:GetAttribute("SlashColor")
    else
        v111 = false
    end
    if p104 == "SlashEffect" and v111 then
        for _, v112 in v110:GetDescendants() do
            if v112.Name == "RealLa" and v112:IsA("ParticleEmitter") then
                v112.Color = ColorSequence.new(v111)
            end
        end
    end
    if p104 and not v110:GetAttribute("KeepRotation") and (v110:GetAttribute("DualSlash") or v110:GetAttribute("FistSlash")) then
        local v113 = {}
        for _, v114 in v110:GetDescendants() do
            if v114:IsA("Attachment") then
                table.insert(v113, v114)
            end
        end
        if v110:GetAttribute("FistSlash") or #v113 < 2 then
            v113[1].CFrame = CFrame.Angles(0, 3.141592653589793, 2.3896699052455963)
            v113[2].CFrame = CFrame.Angles(0, 0, -0.7853981633974483)
        else
            v113[1].CFrame = CFrame.Angles(0, 3.141592653589793, -2.3896699052455963)
            v113[2].CFrame = CFrame.Angles(0, 0, 0.7853981633974483)
        end
    end
    v_u_17.Update(v110)
    v110.Parent = p105
    local v115 = v110.Parried
    v115.Parent = p105
    v_u_1:AddItem(v115, 2)
    v_u_1:AddItem(v110, 3)
    v110.Position = p105.Position
    if p106 == "Oni Claws" then
        local v116 = p105.Orientation.X
        local v117 = p105.Orientation.Y
        v110.Orientation = Vector3.new(v116, v117, 45)
        local v118 = v110.Attachment.RealLa
        local v119 = v_u_38 * 1
        v118:Emit((math.min(1, v119)))
        local v120 = v110.at2.RealLa
        local v121 = v_u_38 * 1
        v120:Emit((math.min(1, v121)))
        local v122 = v110.at3.Specs1
        local v123 = v_u_38 * 5
        v122:Emit((math.min(1, v123)))
        v115:Play()
        task.wait(0.03)
        if v110 and v110:IsDescendantOf(workspace) and v110:FindFirstChild("at3") then
            local v124 = v110.at3.Spark
            local v125 = v_u_38 * 2
            v124:Emit((math.min(0, v125)))
            local v126 = v110.at3.Spark2
            local v127 = v_u_38 * 2
            v126:Emit((math.min(0, v127)))
            return
        end
    else
        if p106 == "Crescendo" or p106 == "Molten Greatblade" then
            local v128 = p105.Orientation.X
            local v129 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v128, v129, 45)
            local v130 = v110.Attachment.RealLa
            local v131 = v_u_38 * 1
            v130:Emit((math.min(1, v131)))
            local v132 = v110.Attachment.Specs1
            local v133 = v_u_38 * 5
            v132:Emit((math.min(1, v133)))
            local v134 = v110.Attachment.ParticleEmitter
            local v135 = v_u_38 * 8
            v134:Emit((math.min(1, v135)))
            v115:Play()
            return
        end
        if p106 == "Cyber Scythe" then
            local v136 = p105.Orientation.X
            local v137 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v136, v137, 45)
            local v138 = v110.Attachment.RealLa
            local v139 = v_u_38 * 1
            v138:Emit((math.min(1, v139)))
            local v140 = v110.Attachment.Specs1
            local v141 = v_u_38 * 10
            v140:Emit((math.min(1, v141)))
            local v142 = v110.Attachment.Particle2
            local v143 = v_u_38 * 4
            v142:Emit((math.min(1, v143)))
            v110.Attachment.Particle4:Emit(v_u_38 * 3)
            v110.glitch:Play()
            v115:Play()
            return
        end
        if p106 == "Wavelight Greatblade" then
            local v144 = p105.Orientation.X
            local v145 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v144, v145, 45)
            local v146 = v110.Attachment.RealLa
            local v147 = v_u_38 * 1
            v146:Emit((math.min(1, v147)))
            v110.Attachment.Specs1:Emit(v_u_38 * 5)
            v110.Attachment.Specs2:Emit(v_u_38 * 20)
            v110.Attachment.Smoke:Emit(v_u_38 * 8)
            v110.Attachment.Cubes:Emit(v_u_38 * 8)
            v115:Play()
            v110.glitch:Play()
            return
        end
        if p106 == "Essence Cleaver" then
            local v148 = p105.Orientation.X
            local v149 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v148, v149, 45)
            local v150 = v110.Attachment.RealLa
            local v151 = v_u_38 * 1
            v150:Emit((math.min(1, v151)))
            v110.Attachment.Smoke:Emit(v_u_38 * 8)
            v110.Attachment.Cubes:Emit(v_u_38 * 20)
            v115:Play()
            return
        end
        if p106 == "Prince Blade" then
            local v152 = p105.Orientation.X
            local v153 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v152, v153, 45)
            local v154 = v110.Attachment.RealLa
            local v155 = v_u_38 * 1
            v154:Emit((math.min(1, v155)))
            v110.Attachment.Specs1:Emit(v_u_38 * 5)
            v110.Attachment.Specs2:Emit(v_u_38 * 5)
            v110.att2.Specs2:Emit(v_u_38 * 5)
            v110.att2.chb:Emit(v_u_38 * 1)
            v115:Play()
            v110.glitch:Play()
            return
        end
        if p106 == "Shattered Sword" then
            local v156 = p105.Orientation.X
            local v157 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v156, v157, 45)
            local v158 = v110.Attachment.RealLa
            local v159 = v_u_38 * 1
            v158:Emit((math.min(1, v159)))
            v110.Attachment.Smoke:Emit(v_u_38 * 8)
            v110.Attachment.Specs2:Emit(v_u_38 * 10)
            v115:Play()
            v110.glitch:Play()
            return
        end
        if p106 == "Hallow\'s Edge" then
            local v160 = p105.Orientation.X
            local v161 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v160, v161, 45)
            local v162 = v110.Attachment.RealLa
            local v163 = v_u_38 * 1
            v162:Emit((math.min(1, v163)))
            v110.Attachment.Smoke:Emit(v_u_38 * 8)
            v110.Attachment.Cubes:Emit(v_u_38 * 20)
            v110.Attachment.Specs2:Emit(v_u_38 * 10)
            v110.att2.Specs2:Emit(v_u_38 * 5)
            local v164 = v110.att2.chb
            local v165 = v_u_38 * 1
            v164:Emit((math.min(1, v165)))
            v110.att3.Specs2:Emit(v_u_38 * 5)
            local v166 = v110.att3.chb
            local v167 = v_u_38 * 1
            v166:Emit((math.min(1, v167)))
            v110.git:Play()
            v115:Play()
            return
        end
        if p106 == "Dual Nebula Fan" or p106 == "Dual Lunar Fan" or p106 == "Nebula Scythe" or p106 == "Lunar Fan" or p106 == "Dual Singularity Katana" or p106 == "Nebula\'s Lightning" or p106 == "Dual Nebula\'s Lightning" or p106 == "Dual Singularity Scythe" or p106 == "Serpent\'s Fang" or p106 == "Serpent\'s Lance" or p106 == "Hellfire Blade Level 1" or p106 == "Hellfire Blade Level 2" or p106 == "Hellfire Blade Level 3" or p106 == "Play Blade" or p106 == "Haunted Harvester" or p106 == "Morbid Mireblade" or p106 == "Witch\'s Curse" or p106 == "Hallow\'s Wrath" or p106 == "Play Sword" or p106 == "Eternal Piercer" or p106 == "Wind Thorn" or p106 == "Eternum Galepiercer" or p106 == "Ocean Blade" or p106 == "Tsunami Blade" or p106 == "Thunder Blade" or p106 == "Voltage" or p106 == "Elemental Masterblade" or p106 == "Dual Elemental Masterblade" or p106 == "Dual Nebula Scythe" or p106 == "Plasma Gauntlets" or p106 == "Dual Ether Blade" or p106 == "Aurum Etherius" or p106 == "Laser Twinblade" or p106 == "Titan Blade" then
            local v168 = p105.Orientation.Y
            v110.Orientation = Vector3.new(0, v168, 0)
            for _, v169 in pairs(v110.Attachment:GetChildren()) do
                if v169:IsA("ParticleEmitter") then
                    local v170 = v169:GetAttribute("EmitCount")
                    local v171 = 1
                    local v172 = v_u_38
                    if not v170 then
                        local v173 = v169.Name
                        v170 = tonumber(v173) or 1
                    end
                    local v174 = v172 * v170
                    v169:Emit((math.min(v171, v174)))
                end
                if v169:IsA("Attachment") then
                    for _, _ in pairs(v169:GetChildren()) do
                        if v169:IsA("ParticleEmitter") then
                            local v175 = v169:GetAttribute("EmitCount")
                            local v176 = 1
                            local v177 = v_u_38
                            if not v175 then
                                local v178 = v169.Name
                                v175 = tonumber(v178) or 1
                            end
                            local v179 = v177 * v175
                            v169:Emit((math.min(v176, v179)))
                        end
                    end
                end
            end
            v110.glitch:Play()
            v115:Play()
            if p106 == "Dual Nebula Fan" or p106 == "Dual Lunar Fan" or p106 == "Dual Nebula\'s Lightning" or p106 == "Dual Ether Blade" or p106 == "Dual Nebula Scythe" or p106 == "Dual Elemental Masterblade" or p106 == "Dual Singularity Scythe" or p106 == "Dual Singularity Katana" then
                local v180 = p105.Orientation.X
                local v181 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v180, v181, 0)
                for _, v182 in pairs(v110.Attachment2:GetChildren()) do
                    if v182:IsA("ParticleEmitter") then
                        local v183 = v_u_38
                        local v184 = v182.Name
                        local v185 = v183 * (tonumber(v184) or v182:GetAttribute("EmitCount") or 1)
                        v182:Emit((math.min(1, v185)))
                    end
                    if v182:IsA("Attachment") then
                        for _, _ in pairs(v182:GetChildren()) do
                            if v182:IsA("ParticleEmitter") then
                                local v186 = v_u_38
                                local v187 = v182.Name
                                local v188 = v186 * (tonumber(v187) or v182:GetAttribute("EmitCount") or 1)
                                v182:Emit((math.min(1, v188)))
                            end
                        end
                    end
                end
            end
            if p106 == "Eternum Galepiercer" or p106 == "Wind Thorn" then
                local v189 = v110.att2["1"]
                local v190 = v_u_38 * 1
                v189:Emit((math.min(1, v190)))
            end
            if p106 == "Plasma Gauntlets" then
                for _, v191 in pairs(v110.att2:GetChildren()) do
                    if v191:IsA("ParticleEmitter") then
                        local v192 = v_u_38
                        local v193 = v191.Name
                        local v194 = v192 * (tonumber(v193) or v191:GetAttribute("EmitCount") or 1)
                        v191:Emit((math.min(1, v194)))
                    end
                end
            end
            if p106 == "Laser Twinblade" then
                for _, v_u_195 in pairs(p105.Parent:FindFirstChild(p106).DualLaserblade.Neon:getDescendants()) do
                    if v_u_195:IsA("Trail") and v_u_195.Name == "Traileelawlaw" then
                        v_u_195.Enabled = true
                        task.delay(0.2, function()
                            -- upvalues: (copy) v_u_195
                            v_u_195.Enabled = false
                        end)
                    end
                end
                return
            end
        else
            if p106 == "Crimson Katana" or p106 == "Valor\226\128\153s Rage" or p106 == "Prismatic Katana" or p106 == "Prismatic Harvester" or p106 == "Double Sided Prismatic" then
                local v196 = p105.Orientation.X
                local v197 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v196, v197, -10)
                v110.glitch:Play()
                v115:Play()
                for _, v198 in pairs(v110:GetDescendants()) do
                    if v198:IsA("ParticleEmitter") then
                        local v199 = v_u_38
                        local v200 = v198.Name
                        local v201 = v199 * (tonumber(v200) or v198:GetAttribute("EmitCount") or 1)
                        v198:Emit((math.min(1, v201)))
                    end
                end
                return
            end
            if p106 == "Dual Crimson Katana" or p106 == "Dual Prismatic Katana" or p106 == "Crimson Eclipse" then
                local v202 = p105.Orientation.X
                local v203 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v202, v203, 10)
                v110.glitch:Play()
                v115:Play()
                for _, v204 in pairs(v110:GetDescendants()) do
                    if v204:IsA("ParticleEmitter") then
                        local v205 = v_u_38
                        local v206 = v204.Name
                        local v207 = v205 * (tonumber(v206) or v204:GetAttribute("EmitCount") or 1)
                        v204:Emit((math.min(1, v207)))
                    end
                end
                return
            end
            if p106 == "Plasma Blasters" or p106 == "Golden Gauntlets" or p106 == "Plasma Blaster" or p106 == "Firework Blaster" or p106 == "Dual Firework Blasters" then
                local v208 = p105.Orientation.X
                local v209 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v208, v209, 45)
                v110.glitch:Play()
                v115:Play()
                for _, v210 in pairs(v110:GetDescendants()) do
                    if v210:IsA("ParticleEmitter") then
                        local v211 = v_u_38
                        local v212 = v210.Name
                        local v213 = v211 * (tonumber(v212) or v210:GetAttribute("EmitCount") or 1)
                        v210:Emit((math.min(1, v213)))
                    end
                end
                return
            end
            if p106 == "Vanguard Shield" or p106 == "Empyrean Fortress" then
                local v214 = p105.Orientation.X
                local v215 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v214, v215, 45)
                v110.glitch:Play()
                v115:Play()
                for _, v_u_216 in pairs(p105.Parent:FindFirstChild(p106).Model.zpart:getChildren()) do
                    if v_u_216:IsA("Trail") or v_u_216:IsA("Particle") then
                        task.spawn(function()
                            -- upvalues: (copy) v_u_216
                            v_u_216.Enabled = true
                            task.wait(0.2)
                            v_u_216.Enabled = false
                        end)
                    end
                end
                for _, v217 in pairs(v110.Attachment:GetChildren()) do
                    if v217:IsA("ParticleEmitter") then
                        local v218 = v_u_38
                        local v219 = v217.Name
                        local v220 = v218 * tonumber(v219)
                        v217:Emit((math.min(1, v220)))
                    end
                end
                for _, v221 in pairs(v110.Att2:GetChildren()) do
                    if v221:IsA("ParticleEmitter") then
                        local v222 = v_u_38
                        local v223 = v221.Name
                        local v224 = v222 * tonumber(v223)
                        v221:Emit((math.min(1, v224)))
                    end
                end
                return
            end
            if p106 == "Serpent\226\128\153s Sickle" then
                local v225 = p105.Orientation.X
                local v226 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v225, v226, 0)
                v110.glitch:Play()
                v115:Play()
                for _, v227 in pairs(v110.Attachment:GetChildren()) do
                    if v227:IsA("ParticleEmitter") then
                        local v228 = v_u_38 * (v227:GetAttribute("EmitCount") or 1)
                        v227:Emit((math.min(1, v228)))
                    end
                end
                return
            end
            if p106 == "Serpent\226\128\153s Shiv" then
                local v229 = p105.Orientation.X + 180
                local v230 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v229, v230, 0)
                v110.glitch:Play()
                v115:Play()
                for _, v231 in pairs(v110.Attachment:GetChildren()) do
                    if v231:IsA("ParticleEmitter") then
                        local v232 = v_u_38 * (v231:GetAttribute("EmitCount") or 1)
                        v231:Emit((math.min(1, v232)))
                    end
                end
                return
            end
            if p106 == "Gobble Blade" then
                v110.glitch:Play()
                v115:Play()
                for _, v233 in pairs(v110.Attachment:GetChildren()) do
                    if v233:IsA("ParticleEmitter") then
                        local v234 = v_u_38 * (v233:GetAttribute("EmitCount") or 1)
                        v233:Emit((math.min(1, v234)))
                    end
                end
                return
            end
            if p106 == "New Year\'s Axe" then
                local v235 = p105.Orientation.Y
                v110.Orientation = Vector3.new(0, v235, 45)
                v110.glitch:Play()
                v115:Play()
                for _, v236 in pairs(v110.Attachment:GetChildren()) do
                    if v236:IsA("ParticleEmitter") then
                        local v237 = v_u_38 * (v236:GetAttribute("EmitCount") or 1)
                        v236:Emit((math.min(1, v237)))
                    end
                end
                return
            end
            if p106 == "Ultimate Ruby" then
                local v238 = p105.Orientation.X + 180
                local v239 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v238, v239, 0)
                v110.glitch:Play()
                v115:Play()
                for _, v240 in pairs(v110.Attachment:GetChildren()) do
                    if v240:IsA("ParticleEmitter") then
                        local v241 = v_u_38 * (v240:GetAttribute("EmitCount") or 1)
                        v240:Emit((math.min(1, v241)))
                    end
                end
                return
            end
            if p106 == "DOT" or p106 == "Frog" then
                local v242 = typeof(p107) == "Instance" and p107:GetAttribute("LobbyTraining") and p107.Character
                if v242 then
                    v242 = p107.Character.Parent == workspace.Dead
                end
                local v243
                if v242 then
                    v243 = workspace.TrainingBalls
                else
                    v243 = workspace.Balls
                end
                local v_u_244 = nil
                for _, v245 in v243:GetChildren() do
                    if v245:GetAttribute("realBall") then
                        continue
                    end
                    v_u_244 = v245
                    break
                end
                if v_u_244 then
                    local v_u_246 = p105.Parent[p106].Frogge.Handle
                    v_u_246.ribbit:Play()
                    task.spawn(function()
                        -- upvalues: (copy) v_u_246, (ref) v_u_244
                        v_u_246.Tongue.Enabled = true
                        local v247 = math.random(-1, 0) ^ 0
                        local v248 = Vector3.zAxis * math.random(-180, 180)
                        v_u_246.TongueStart.Orientation = v248
                        v_u_246.TongueEnd.Orientation = v248
                        local v249 = (v_u_246:GetAttribute("CCU") or 0) + 1
                        v_u_246:SetAttribute("CCU", v249)
                        local v250 = 0.5
                        while v250 > 0 do
                            if v249 > v_u_246:GetAttribute("CCU") then
                                v_u_246:SetAttribute("CCU", (v_u_246:GetAttribute("CCU") or 0) - 1)
                                return
                            end
                            local v251 = v_u_246.TongueEnd
                            local v252 = v_u_244:GetPivot().Position
                            local v253 = v_u_246.TongueStart.WorldPosition
                            local v254 = v250 - 0.3
                            v251.WorldPosition = v252:Lerp(v253, 1 - math.max(0, v254) / 0.2)
                            local v255 = v_u_246.Tongue
                            local v256 = v250 - 0.4
                            v255.Width0 = (1 - math.max(0, v256) / 0.1) * 0.25
                            v_u_246.Tongue.Width1 = v_u_246.Tongue.Width0
                            local v257
                            if (v_u_246.TongueEnd.Position - v_u_246.TongueStart.Position).Magnitude < 0.1 then
                                v257 = 0
                            else
                                local v258 = os.clock() * 60
                                v257 = math.sin(v258) * 4 * v247
                            end
                            v_u_246.Tongue.CurveSize0 = v257
                            v_u_246.Tongue.CurveSize1 = v257
                            v250 = v250 - task.wait()
                        end
                        v_u_246.Tongue.Enabled = false
                        v_u_246:SetAttribute("CCU", v_u_246:GetAttribute("CCU") - 1)
                    end)
                    local v259 = p105.Orientation.X
                    local v260 = p105.Orientation.Y
                    v110.Orientation = Vector3.new(v259, v260, 45)
                    v110.Attachment.WorldPosition = (v_u_244:GetPivot().Position - v_u_246.Position).Unit * ((v_u_244:GetPivot().Position - v_u_246.Position).Magnitude - 4) + v_u_246.Position
                    v110.Attachment.RealLa:Emit(v_u_38 * 1)
                    v115:Play()
                end
            end
            if p106 == "BAH" then
                p105.parent[p106].sord.bah.SoundId = math.random(0, 1) == 0 and "rbxassetid://15374026679" or "rbxassetid://15386818483"
                p105.parent[p106].sord.bah:Play()
                return
            end
            if p106 == "Siam Ember Axe" or p106 == "Siamese Edgeblade" or p106 == "Arctic Edge" or p106 == "Glacier Shard" or p106 == "Glacial Scythe" or p106 == "Ice Dagger" or p106 == "Frozen Doomblade" or p106 == "Sword of Order" or p106 == "Progression Scythe" or p106 == "Awakened Righteous Blade" or p106 == "Awakened Emperor\'s Axe" or p106 == "Awakened Void Hammer" or p106 == "Awakened Emerald Katana" then
                local v261 = p105.Orientation.X
                local v262 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v261, v262, 0)
                v110.glitch:Play()
                v115:Play()
                
                for _, v263 in pairs(v110.Attachment:GetDescendants()) do
                    if v263:IsA("ParticleEmitter") then
                        local v264 = v_u_38 * (v263:GetAttribute("EmitCount") or 1)
                        v263:Emit((math.max(1, v264)))
                    end
                end

                return
            end
            if p106 and p106:find("Ranked Season 2 Top") then
                local v265 = p105.Orientation.X
                local v266 = p105.Orientation.Y
                v110.Orientation = Vector3.new(v265, v266, 45)
                v110.glitch:Play()
                v115:Play()
                for _, v267 in pairs(v110.Attachment:GetChildren()) do
                    if v267:IsA("ParticleEmitter") then
                        local v268 = v_u_38 * (v267:GetAttribute("EmitCount") or 1)
                        v267:Emit((math.min(1, v268)))
                    end
                end
                return
            end
            if v108.SlashName and p104 ~= "SlashEffect" then
                local v269 = false
                if p106 == "Fire Dragon" or p106 == "Frost Dragon" or p106 == "Shark" then
                    v110.Position = v109.Position
                    v110:PivotTo(p105:GetPivot() * CFrame.Angles(3.141592653589793, 0, 0))
                    v269 = true
                elseif p106 == "Aetherial Lance" then
                    local v270 = p105.Orientation.X + 180
                    local v271 = p105.Orientation.Y + 180
                    v110.Orientation = Vector3.new(v270, v271, 0)
                else
                    local v272 = p105.Orientation.X + 180
                    local v273 = p105.Orientation.Y
                    v110.Orientation = Vector3.new(v272, v273, 0)
                end
                v115:Play()
                local v274 = p106 == "Nightfall Violin" and 1 or v_u_38
                for _, v275 in pairs(v110:GetDescendants()) do
                    if v275:IsA("Sound") then
                        v275:Play()
                    end
                    if v275:IsA("BasePart") and not v269 then
                        v275:PivotTo(p105:GetPivot() * CFrame.new(v275.Position - v109.Position) * v275:GetPivot().Rotation)
                    end
                    if v275:IsA("ParticleEmitter") and (not v275:HasTag("HD Slash") or v_u_38 > 0.5 and not (v_u_40 and v_u_40:Get({
                        "Settings",
                        "Misc",
                        "Low Graphics",
                        "Enabled"
                    }))) and (not v_u_40 or v_u_40:Get({
                        "Settings",
                        "Misc",
                        "Weapon VFX",
                        "Enabled"
                    })) then
                        local v276 = v275:GetAttribute("EmitDelay") or 0
                        if v276 > 0 then
                            task.delay(v276, v275.Emit, v275, v274 * (v275:GetAttribute("EmitCount") or 1))
                        else
                            v275:Emit(v274 * (v275:GetAttribute("EmitCount") or 1))
                        end
                    end
                end
                return
            end
            local v277 = p105.Orientation.X
            local v278 = p105.Orientation.Y
            v110.Orientation = Vector3.new(v277, v278, 45)
            local v279 = v110.Attachment.RealLa
            local v280 = v_u_38 * 1
            v279:Emit((math.min(1, v280)))
            v115:Play()
        end
    end
end
v_u_4.Remotes.ParrySuccessAll.OnClientEvent:Connect(parrySuccessAll)
v_u_4.Remotes.ParrySuccessClient.Event:Connect(parrySuccessAll)
v_u_4.Remotes.RagingSuccessAll.OnClientEvent:Connect(function(p281, p_u_282, p_u_283)
    -- upvalues: (copy) v_u_1, (ref) v_u_38, (copy) shockwave
    local v_u_284 = p_u_282.Parent
    p281.Position = p_u_282.Position
    local v285 = p_u_282.Orientation.X
    local v286 = p_u_282.Orientation.Y
    p281.Orientation = Vector3.new(v285, v286, 45)
    local v287 = p281.swordshinies
    local v288 = nil
    for _, v289 in pairs(p_u_282.Parent:GetChildren()) do
        if v289:FindFirstChild("KatanaMesh") then
            v288 = v289.KatanaMesh
        end
    end
    v287.Parent = v288
    v287.Enabled = true
    v_u_1:AddItem(v287, 2)
    p281.Parried:Play()
    p281.hit:Play()
    if p_u_283 then
        if v_u_284:FindFirstChild("Bobber") then
            p281.At2.ParticleEmitter:Emit(v_u_38 * 4)
            p281.At2.Flash1:Emit(v_u_38 * 2)
            p281.At2.Flash2:Emit(v_u_38 * 1)
        else
            for _, v290 in pairs(p281:GetDescendants()) do
                if v290:IsA("ParticleEmitter") and v290.Name ~= "swordshinies" then
                    local v291 = v_u_38
                    local v292 = v290.Name
                    v290:Emit(v291 * (tonumber(v292) or v290:GetAttribute("EmitCount")))
                end
            end
        end
    else
        for _, v293 in pairs(p281:GetDescendants()) do
            if v293:IsA("ParticleEmitter") and v293.Name ~= "swordshinies" then
                local v294 = v_u_38
                local v295 = v293.Name
                v293:Emit(v294 * tonumber(v295))
            end
        end
    end
    task.spawn(function()
        -- upvalues: (copy) p_u_283, (ref) shockwave, (copy) p_u_282, (copy) v_u_284
        if p_u_283 then
            if v_u_284:FindFirstChild("Bobber") then
                shockwave(p_u_282.Parent.HumanoidRootPart, 40, nil, Color3.new(0.92549, 0.501961, 1), true)
            else
                shockwave(p_u_282.Parent.HumanoidRootPart, 40, nil, Color3.new(0, 0.317647, 1), true)
            end
        else
            shockwave(p_u_282.Parent.HumanoidRootPart, 40, nil, Color3.new(1, 0, 0), true)
            return
        end
    end)
    task.wait(0.2)
    v287.Enabled = false
end)
v_u_4.Remotes.ParryAttempt.OnClientEvent:Connect(function(p296)
    p296.ParryAttempt:Play()
end)
v_u_4.Remotes.ParryAttemptAll.OnClientEvent:Connect(function(p297, p298)
    p297.CFrame = p298.Torso.CFrame
    local v299 = Instance.new("WeldConstraint")
    v299.Parent = p297
    v299.Part0 = p298.Torso
    v299.Part1 = p297
end)
v_u_4.Remotes.PlrDashed.OnClientEvent:Connect(function(p_u_300, p301)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) shockwave
    local v302 = v_u_4.Misc.dash:Clone()
    v302.Parent = workspace.Runtime
    v_u_1:AddItem(v302, 2)
    local v303 = nil
    local v_u_304 = Color3.new(1, 1, 1)
    if p301 then
        v_u_304 = Color3.new(1, 1, 0)
    end
    task.spawn(function()
        -- upvalues: (ref) shockwave, (copy) p_u_300, (ref) v_u_304
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_300, (ref) v_u_304
            shockwave(p_u_300.HumanoidRootPart, 25, nil, v_u_304)
        end)
        task.wait(0.1)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_300, (ref) v_u_304
            shockwave(p_u_300.HumanoidRootPart, 25, nil, v_u_304)
        end)
        task.wait(0.1)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_300, (ref) v_u_304
            shockwave(p_u_300.HumanoidRootPart, 20, nil, v_u_304)
        end)
    end)
    v302.Position = p_u_300.HumanoidRootPart.Position
    v302.WeldConstraint.Part1 = p_u_300.HumanoidRootPart
    if p301 then
        v302.maxswos:Play()
    end
    v302.Swoosh:Play()
    local v305 = Ray.new(v302.Position, (Vector3.new(0, -1, 0)).unit * 10)
    local v306 = game:GetService("Workspace"):FindPartOnRay(v305, p_u_300)
    if v306 then
        v303 = v306.Color
    end
    if v303 then
        v302.Attachment.dust.Color = ColorSequence.new(v303)
        v302.Attachment.dust.Enabled = true
    end
    task.wait(0.2)
    v302.Attachment.dust.Enabled = false
end)
v_u_4.Remotes.PlrSuperJumped.OnClientEvent:Connect(function(p_u_307, p_u_308)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) shockwave
    local v309 = v_u_4.Misc.SuperJump:Clone()
    v309.Parent = workspace.Runtime
    v309.CFrame = p_u_307.HumanoidRootPart.CFrame
    v309.Parent = p_u_307.HumanoidRootPart
    v309.WeldConstraint.Part1 = v309.Parent
    v309.Jump:Play()
    if p_u_308 then
        v309.Wind.PlaybackSpeed = 1
        v309.OniCharge:Play()
    end
    v309.Wind:Play()
    v_u_1:AddItem(v309, 4)
    local v_u_310 = Color3.new(1, 1, 1)
    if p_u_308 then
        v_u_310 = Color3.new(0, 1, 1)
    end
    task.spawn(function()
        -- upvalues: (ref) shockwave, (copy) p_u_307, (ref) v_u_310, (copy) p_u_308
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_307, (ref) v_u_310
            shockwave(p_u_307.HumanoidRootPart, 30, nil, v_u_310, true)
        end)
        task.wait(0.1)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_307, (ref) v_u_310
            shockwave(p_u_307.HumanoidRootPart, 15, nil, v_u_310, true)
        end)
        task.wait(0.1)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_307, (ref) v_u_310
            shockwave(p_u_307.HumanoidRootPart, 15, nil, v_u_310, true)
        end)
        task.wait(0.1)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_307, (ref) v_u_310
            shockwave(p_u_307.HumanoidRootPart, 15, nil, v_u_310, true)
        end)
        if p_u_308 then
            task.wait(0.1)
            task.spawn(function()
                -- upvalues: (ref) shockwave, (ref) p_u_307, (ref) v_u_310
                shockwave(p_u_307.HumanoidRootPart, 15, nil, v_u_310, true)
            end)
        end
    end)
end)
v_u_4.Remotes.PlrRagingDeflectiond.OnClientEvent:Connect(function(p_u_311, p312)
    -- upvalues: (copy) shockwave
    local v_u_313 = Color3.new(0.6, 0, 0)
    if p312 then
        v_u_313 = Color3.new(0.0392157, 0, 0.580392)
        if p_u_311:FindFirstChild("Bobber") then
            v_u_313 = Color3.new(0.482353, 0, 0.580392)
        end
    end
    task.spawn(function()
        -- upvalues: (ref) shockwave, (copy) p_u_311, (ref) v_u_313
        shockwave(p_u_311.HumanoidRootPart, 25, 0.6, v_u_313, true, true, true)
    end)
    task.wait(0.2)
    if p_u_311:FindFirstChild("RagingDeflectHighlight") or p_u_311:FindFirstChild("MaxRagingDeflectHighlight") then
        task.spawn(function()
            -- upvalues: (ref) shockwave, (copy) p_u_311, (ref) v_u_313
            shockwave(p_u_311.HumanoidRootPart, 25, 0.6, v_u_313, true, true, true)
        end)
        task.wait(0.1)
        if p_u_311:FindFirstChild("RagingDeflectHighlight") or p_u_311:FindFirstChild("MaxRagingDeflectHighlight") then
            task.spawn(function()
                -- upvalues: (ref) shockwave, (copy) p_u_311, (ref) v_u_313
                shockwave(p_u_311.HumanoidRootPart, 25, 0.6, v_u_313, true, true, true)
            end)
        end
    else
        return
    end
end)
v_u_4.Remotes.PlrCalmingDeflectiond.OnClientEvent:Connect(function(p_u_314, _)
    -- upvalues: (copy) shockwave, (copy) v_u_3, (copy) v_u_2, (copy) v_u_6
    task.spawn(function()
        -- upvalues: (ref) shockwave, (copy) p_u_314
        for v315 = 5, 30, 25 do
            shockwave(p_u_314.HumanoidRootPart, v315, 0.6, Color3.new(0, 0.333333, 1), true, true, true)
            task.wait(0.05)
        end
        shockwave(p_u_314.HumanoidRootPart, 35, 0.6, Color3.new(0, 0.333333, 1), true, false, true)
    end)
    if v_u_3.LocalPlayer and (v_u_3.LocalPlayer.Character.HumanoidRootPart.Position - p_u_314.HumanoidRootPart.Position).Magnitude <= 20 then
        task.spawn(function()
            -- upvalues: (ref) v_u_2, (ref) v_u_6
            v_u_2.ccCalmingDeflect2.Enabled = true
            task.wait(0.06666666666666667)
            v_u_2.ccCalmingDeflect2.Enabled = false
            v_u_2.ccCalmingDeflect1.Enabled = true
            task.wait(0.06666666666666667)
            v_u_2.ccCalmingDeflect1.Enabled = false
            v_u_2.ExposureCompensation = 5
            v_u_6:Create(v_u_2, TweenInfo.new(0.2), {
                ["ExposureCompensation"] = 0
            }):Play()
        end)
    end
end)
v_u_4.Remotes.PlrFlashCountered.OnClientEvent:Connect(function(p_u_316, p_u_317, p_u_318, p_u_319, p_u_320)
    -- upvalues: (copy) v_u_3, (copy) v_u_7, (copy) v_u_13, (copy) v_u_4, (copy) v_u_1, (copy) v_u_8, (copy) v_u_11, (copy) v_u_2
    local v321 = p_u_316.HumanoidRootPart.CFrame
    local v322 = (CFrame.lookAt(p_u_318.Position, p_u_319.Position).LookVector * Vector3.new(1, 0, 1)).Unit
    local v323 = RaycastParams.new()
    v323.FilterType = Enum.RaycastFilterType.Exclude
    v323.FilterDescendantsInstances = {
        workspace.Runtime,
        workspace.Alive,
        workspace.Dead,
        workspace.Balls,
        workspace.TrainingBalls
    }
    local v324 = workspace:Raycast(v321.Position, v322 * 6, v323)
    local v325 = p_u_319.Position + v322 * (v324 and v324.Distance - 1 or 6)
    local v_u_326 = CFrame.lookAt(v325, p_u_319.Position)
    local v_u_327 = (p_u_318.Position - p_u_319.Position).Magnitude
    task.delay(0.25, function()
        -- upvalues: (copy) p_u_316, (ref) v_u_3, (copy) p_u_318, (ref) v_u_7, (ref) v_u_13, (copy) v_u_327, (copy) v_u_326
        if p_u_316 == v_u_3.LocalPlayer.Character then
            p_u_316.Humanoid.WalkSpeed = p_u_316.Humanoid:GetAttribute("OLD_WS") or p_u_316.Humanoid.WalkSpeed
            local v_u_328 = Instance.new("Part")
            v_u_328.Transparency = 1
            v_u_328.Anchored = true
            v_u_328.CanCollide = false
            v_u_328.CFrame = p_u_318
            v_u_328.Parent = workspace
            v_u_7.CameraSubject = v_u_328
            v_u_328.Destroying:Connect(function()
                -- upvalues: (ref) v_u_7, (ref) p_u_316, (ref) v_u_3, (copy) v_u_328
                v_u_7.CameraSubject = p_u_316:FindFirstChildWhichIsA("Humanoid") or v_u_3.LocalPlayer.CharacterAdded:WaitForChild("Humanoid")
                if v_u_7.CameraSubject == v_u_328 then
                    v_u_7.CameraSubject = (v_u_3.LocalPlayer.Character or v_u_3.LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid")
                end
            end)
            local v329 = v_u_13.Spring.target
            local v330 = 48 - v_u_327
            v329(v_u_328, 0.65, math.clamp(v330, 4, 16), {
                ["CFrame"] = v_u_326 + Vector3.new(0, 4, 0)
            })
            v_u_13.Spring.completed(v_u_328, function()
                -- upvalues: (copy) v_u_328, (ref) p_u_316
                while v_u_328.Parent and (v_u_328.Position - p_u_316:GetPivot().Position).Magnitude > 0.25 do
                    local v331 = task.wait()
                    v_u_328:PivotTo(v_u_328:GetPivot():Lerp(p_u_316:GetPivot(), v331 * 20))
                end
                v_u_328:Destroy()
            end)
            task.delay(0.5, function()
                -- upvalues: (ref) v_u_7, (ref) p_u_316, (copy) v_u_328
                v_u_7.CameraSubject = p_u_316:FindFirstChildWhichIsA("Humanoid")
                v_u_328:Destroy()
                task.wait(1)
                v_u_328:Destroy()
            end)
            p_u_316:FindFirstChildWhichIsA("Humanoid")
            p_u_316:PivotTo(v_u_326 + Vector3.new(0, 4, 0))
        end
    end)
    task.defer(function()
        -- upvalues: (ref) v_u_4, (copy) p_u_316, (ref) v_u_1, (ref) v_u_8, (ref) v_u_11, (ref) v_u_3, (ref) v_u_2, (copy) p_u_319, (copy) p_u_317, (copy) p_u_318, (copy) v_u_327, (copy) v_u_326, (copy) p_u_320
        local v332 = v_u_4.Misc.FlashCounterAura.colorme:Clone()
        v332.Parent = p_u_316.PrimaryPart
        local v333 = v_u_4.Misc.FlashCounterAura.Hand:Clone()
        v333.Parent = p_u_316:FindFirstChild("Right Arm")
        local v334 = v_u_4.Misc.FlashCounterAura.lightning:Clone()
        v334.Parent = p_u_316.PrimaryPart
        v334:Play()
        v_u_1:AddItem(v332, 3)
        v_u_1:AddItem(v333, 3)
        v_u_1:AddItem(v334, 3)
        local v335 = math.random(72, 144)
        while v335 < 360 do
            local v336 = p_u_316:GetPivot()
            local v337 = v336 * CFrame.Angles(0, math.rad(v335), 0) * CFrame.new(0, -3, math.random(-21, -16))
            local v338 = {
                ["WorldPosition"] = v337.Position,
                ["WorldAxis"] = v337.RightVector
            }
            local v339 = {
                ["WorldPosition"] = v336.Position,
                ["WorldAxis"] = v336.RightVector
            }
            local v_u_340 = v_u_8.new(v338, v339, 9)
            v_u_340.AnimationSpeed = 4
            v_u_340.CurveSize0 = 3
            v_u_340.CurveSize1 = 3
            v_u_340.Color = ColorSequence.new(Color3.new(0.12549, 0.027451, 0.258824), Color3.new(0.172549, 0.0745098, 0.309804))
            v_u_340.Thickness = 0.25
            v_u_340.PulseSpeed = 8
            v_u_340.PulseLength = 1
            v_u_340.FadeLength = 0.75
            v_u_340.MaxRadius = 3
            v_u_340.ContractFrom = 0.5
            v_u_340.MinThicknessMultiplier = 0.75
            v_u_340.MaxThicknessMultiplier = 2
            v_u_11.new(v_u_340).MaxSparkCount = 3
            task.delay(0.5, function()
                -- upvalues: (copy) v_u_340
                v_u_340:Destroy()
            end)
            v335 = v335 + math.random(0, 36)
        end
        local v341 = math.random(0, 36)
        while v341 < 360 do
            local v342 = p_u_316:GetPivot()
            local v343 = v342 * CFrame.Angles(0, math.rad(v341), 0) * CFrame.new(0, -3, math.random(-21, -16))
            local v344 = {
                ["WorldPosition"] = v343.Position,
                ["WorldAxis"] = v343.RightVector
            }
            local v345 = {
                ["WorldPosition"] = v342.Position,
                ["WorldAxis"] = v342.RightVector
            }
            local v_u_346 = v_u_8.new(v344, v345, 12)
            v_u_346.AnimationSpeed = 4
            v_u_346.CurveSize0 = 3
            v_u_346.CurveSize1 = 3
            v_u_346.Color = ColorSequence.new(Color3.new(0.705882, 0.556863, 1), Color3.new(0.501961, 0.490196, 0.847059))
            v_u_346.Thickness = 0.35
            v_u_346.PulseSpeed = 6
            v_u_346.PulseLength = 1
            v_u_346.FadeLength = 0.75
            v_u_346.MaxRadius = 3
            v_u_346.ContractFrom = 0.5
            v_u_346.MinThicknessMultiplier = 0.75
            v_u_346.MaxThicknessMultiplier = 2
            v_u_11.new(v_u_346).MaxSparkCount = 3
            task.delay(0.5, function()
                -- upvalues: (copy) v_u_346
                v_u_346:Destroy()
            end)
            v341 = v341 + math.random(0, 36)
        end
        task.wait(0.25)
        if (v_u_3.LocalPlayer.Character.HumanoidRootPart.Position - p_u_316.HumanoidRootPart.Position).Magnitude <= 20 then
            v_u_2.ccFlashCounter.Enabled = true
            task.delay(0.05, function()
                -- upvalues: (ref) v_u_2
                v_u_2.ccFlashCounter.Enabled = false
            end)
        end
        local v_u_347 = v_u_4.Misc.FlashCounterVictim:Clone()
        v_u_347:PivotTo(p_u_319 + Vector3.new(0, 3, 0))
        v_u_347.Parent = workspace
        task.spawn(function()
            -- upvalues: (copy) v_u_347, (ref) p_u_317
            local v348 = 3
            while v348 > 0 do
                v348 = v348 - task.wait()
                v_u_347:PivotTo(p_u_317:GetPivot())
            end
            v_u_347:Destroy()
        end)
        local v349 = p_u_318
        local v350 = v_u_327 // 6.5
        local v351 = v_u_327 % 6.5
        for v352 = (v350 + math.sign(v351)) * 6.5, 0, -6.5 do
            local v353 = v_u_4.Misc.FlashDash:Clone()
            if v352 > 2.5 then
                v353.Pop:Destroy()
            end
            v353.CFrame = CFrame.lookAt(v349.Position, v349.Position - v_u_326.LookVector) * CFrame.Angles(1.5707963267948966, 0, 0)
            v353.Parent = workspace
            v_u_1:AddTag(v353, 3)
            local v354 = next
            local v355, v356 = v353:GetDescendants()
            for _, v357 in v354, v355, v356 do
                if v357:IsA("ParticleEmitter") then
                    v357:Emit(v357:GetAttribute("EmitCount") or 1)
                end
                if v352 <= 2.5 then
                    v353.AbilityBlast:Play()
                end
            end
            v349 = v349 - v_u_326.LookVector * 6.5
        end
        task.wait(p_u_320 == 1 and 1.4 or 1.2)
        v332.Enabled = false
        local v358 = next
        local v359, v360 = v_u_347:GetDescendants()
        for _, v361 in v358, v359, v360 do
            if v361:IsA("ParticleEmitter") or v361:IsA("Beam") then
                v361.Enabled = false
            elseif v361:IsA("Sound") then
                v361:Play()
            end
        end
        local v362 = next
        local v363, v364 = v333:GetDescendants()
        for _, v365 in v362, v363, v364 do
            if v365:IsA("ParticleEmitter") or v365:IsA("Beam") then
                v365.Enabled = false
            end
        end
    end)
end)
v_u_4.Remotes.PlrLuckEffects.OnClientEvent:Connect(function(p366)
    -- upvalues: (copy) v_u_4, (copy) v_u_13, (copy) v_u_1
    local v367 = p366.Character
    if v367 then
        v367 = v367:FindFirstChild("Torso")
    end
    if v367 then
        local v368 = p366:FindFirstChild("Upgrades")
        local v369 = v368 and v368:FindFirstChild("Luck") and v368.Luck.Value or 0
        local v370 = v_u_4.Misc.LuckEmit
        if v369 == 2 then
            v370 = v_u_4.Misc.LuckEmit2
        end
        local v371 = v370:Clone()
        v_u_13.Physics.CreateOldWeld(v371, v367)
        v371.Parent = v367
        v_u_13.Visual:PlayEffects(v371)
        v_u_1:AddItem(v371, 4)
    end
end)
v_u_4.Remotes.PlrFreezeTrapped.OnClientEvent:Connect(function(p372)
    -- upvalues: (copy) v_u_4, (copy) v_u_13
    local v373 = v_u_4.Misc.FreezeTrap.FrostMine:Clone()
    v373:PivotTo(p372)
    local v374 = v373.Bottom.Neon
    v374.Position = v374.Position - Vector3.new(0, 1, 0)
    v373.Parent = workspace
    v373.Bottom.Main.IceTrapPlace:Play()
    local v375 = 0
    while v375 < 0.25 do
        local v376 = task.wait()
        v375 = v375 + v376
        local v377 = v373.Top.Main
        v377.CFrame = v377.CFrame * CFrame.Angles(0, -v376 * 14, 0)
        local v378 = v373.Top.Neon
        v378.CFrame = v378.CFrame * CFrame.Angles(0, -v376 * 14, 0)
    end
    v_u_13.Spring.target(v373.Bottom.Neon, 0.8, 6, {
        ["Position"] = v373.Bottom.Neon.Position + Vector3.yAxis
    })
    v_u_13.Spring.target(v373.Top.Main, 0.8, 6, {
        ["CFrame"] = v373.Top.Main.CFrame * CFrame.Angles(0, 3.141592653589793, 0) - Vector3.new(0, 1, 0)
    })
    v_u_13.Spring.target(v373.Top.Neon, 0.8, 6, {
        ["CFrame"] = v373.Top.Neon.CFrame * CFrame.Angles(0, 3.141592653589793, 0) - Vector3.new(0, 1, 0)
    })
    task.wait(0.25)
    v_u_13.Spring.target(v373.Top.Main, 0.8, 6, {
        ["CFrame"] = v373.Top.Main.CFrame * CFrame.Angles(0, 3.141592653589793, 0) - Vector3.new(0, 1, 0)
    })
    v_u_13.Spring.target(v373.Top.Neon, 0.8, 6, {
        ["CFrame"] = v373.Top.Main.CFrame * CFrame.Angles(0, 3.141592653589793, 0) - Vector3.new(0, 1, 0)
    })
    task.wait(0.25)
    v_u_13.Spring.stop(v373.Bottom.Neon)
    v_u_13.Spring.stop(v373.Top.Main)
    v_u_13.Spring.stop(v373.Top.Neon)
    local v379 = 0
    while v379 < 0.25 do
        v379 = v379 + task.wait()
        local v380 = v379 / 0.25
        v373:PivotTo(p372:Lerp(p372 - Vector3.yAxis * 2, v380))
    end
    v373:Destroy()
end)
v_u_4.Remotes.FreezeTrapExploded.OnClientEvent:Connect(function(p381, p382, p383)
    -- upvalues: (copy) v_u_4, (copy) v_u_1
    local v384 = 5 + p383
    local v385 = v_u_4.Misc.FreezeTrap.FrostMine:Clone()
    v385:PivotTo(p382)
    v_u_1:AddItem(v385, v384)
    v385.Parent = workspace
    v385.Bottom.Main.IceTrapTrigger:Play()
    local v386 = v_u_4.Misc.QuantumIceCube:Clone()
    v386.CFrame = p381
    v386.Parent = workspace
    local v387 = next
    local v388, v389 = v386:GetDescendants()
    for _, v390 in v387, v388, v389 do
        if v390:IsA("ParticleEmitter") then
            if v390.Lifetime.Max == 3 then
                local v391 = v384 + v390.Lifetime.Min - v390.Lifetime.Max
                v390.Lifetime = NumberRange.new(v391, v384)
            end
            if (v390:GetAttribute("EmitDelay") or 0) > 0 then
                task.delay(v384 - 0.5 or 0, v390.Emit, v390, v390:GetAttribute("EmitCount") or 1)
            else
                v390:Emit(v390:GetAttribute("EmitCount") or 1)
            end
        end
    end
    v_u_1:AddItem(v386, v384 + 2)
    local v392 = v_u_4.Misc.FreezeTrap.IceTrapFrozen:Clone()
    v392.Parent = v386
    v392:Play()
    local v393 = v_u_4.Misc.FreezeTrap.FrostMineFX:Clone()
    v393:PivotTo(p382 - Vector3.new(0, 3, 0))
    v_u_1:AddItem(v393, 7)
    v393.Parent = workspace
    local v394 = next
    local v395, v396 = v393.Bottom.Main.emit:GetChildren()
    for _, v397 in v394, v395, v396 do
        v397:Emit(v397:GetAttribute("EmitCount"))
    end
    task.wait(v384)
    local v398 = next
    local v399, v400 = v393:GetDescendants()
    for _, v401 in v398, v399, v400 do
        if v401:IsA("ParticleEmitter") then
            v401.Enabled = false
        end
    end
end)
v_u_4.Remotes.ThunderDash.OnClientEvent:Connect(function(p_u_402, p403, p_u_404, p_u_405)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (ref) v_u_38, (copy) v_u_6, (copy) v_u_8, (copy) v_u_11
    local v_u_406 = v_u_4.Misc.ThunderDash:Clone()
    local v407 = v_u_4.Misc.ThunderDashAddon:Clone()
    v_u_406.Position = p_u_402.HumanoidRootPart.Position
    v407.Position = p403
    v_u_406.Parent = workspace
    v407.Parent = workspace
    v_u_406.sound1:Play()
    if p_u_404 then
        v_u_406.sound2.PlaybackSpeed = 1.5
    end
    v_u_406.sound2:Play()
    v_u_1:AddItem(v_u_406, 3)
    v_u_1:AddItem(v407, 3)
    local v_u_408 = v_u_406.Attachment
    local v409 = v407.Attachment
    if p_u_404 then
        v_u_408.L1.Color = ColorSequence.new(Color3.new(0.701961, 0, 1))
        v409.L1.Color = ColorSequence.new(Color3.new(0.701961, 0, 1))
    end
    v_u_408.L1:Emit(v_u_38 * 10)
    v409.L1:Emit(v_u_38 * 10)
    local v_u_410 = Instance.new("WeldConstraint")
    v_u_410.Parent = p_u_402.HumanoidRootPart
    v_u_410.Part0 = v_u_406
    v_u_410.Part1 = p_u_402.Torso
    task.spawn(function()
        -- upvalues: (ref) v_u_4, (copy) p_u_404, (copy) p_u_405, (ref) v_u_1, (ref) v_u_6, (copy) p_u_402, (copy) v_u_408, (ref) v_u_38, (copy) v_u_410, (copy) v_u_406
        local v411 = v_u_4.Misc.ShadowFolder
        local v412 = v411.Head:Clone()
        local v413 = v411["Left Arm"]:Clone()
        local v414 = v411["Left Leg"]:Clone()
        local v415 = v411["Right Arm"]:Clone()
        local v416 = v411["Right Leg"]:Clone()
        local v417 = v411.Torso:Clone()
        local v418 = Color3.new(1, 0.964706, 0.470588)
        if p_u_404 then
            v418 = Color3.new(0.701961, 0, 1)
        end
        v412.Color = v418
        v413.Color = v418
        v414.Color = v418
        v415.Color = v418
        v416.Color = v418
        v417.Color = v418
        v412.CFrame = p_u_405[1]
        v413.CFrame = p_u_405[2]
        v414.CFrame = p_u_405[5]
        v415.CFrame = p_u_405[3]
        v416.CFrame = p_u_405[4]
        v417.CFrame = p_u_405[6]
        for _, v_u_419 in ipairs({
            v412,
            v413,
            v414,
            v415,
            v416,
            v417
        }) do
            v_u_419.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_419, 2)
            task.spawn(function()
                -- upvalues: (ref) v_u_6, (copy) v_u_419
                task.wait(0.5)
                v_u_6:Create(v_u_419, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
                    ["Transparency"] = 1,
                    ["Size"] = Vector3.new(0, 0, 0)
                }):Play()
            end)
        end
        task.wait(0.1)
        local v420 = v411.Head:Clone()
        local v421 = v411["Left Arm"]:Clone()
        local v422 = v411["Left Leg"]:Clone()
        local v423 = v411["Right Arm"]:Clone()
        local v424 = v411["Right Leg"]:Clone()
        local v425 = v411.Torso:Clone()
        local v426 = Color3.new(1, 0.964706, 0.470588)
        if p_u_404 then
            v426 = Color3.new(0.701961, 0, 1)
        end
        v420.Color = v426
        v421.Color = v426
        v422.Color = v426
        v423.Color = v426
        v424.Color = v426
        v425.Color = v426
        v420.CFrame = p_u_402.Head.CFrame
        v421.CFrame = p_u_402["Left Arm"].CFrame
        v422.CFrame = p_u_402["Left Leg"].CFrame
        v423.CFrame = p_u_402["Right Arm"].CFrame
        v424.CFrame = p_u_402["Right Leg"].CFrame
        v425.CFrame = p_u_402.Torso.CFrame
        for _, v_u_427 in ipairs({
            v420,
            v421,
            v422,
            v423,
            v424,
            v425
        }) do
            v_u_427.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_427, 2)
            task.spawn(function()
                -- upvalues: (ref) v_u_6, (copy) v_u_427
                task.wait(0.5)
                v_u_6:Create(v_u_427, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
                    ["Transparency"] = 1,
                    ["Size"] = Vector3.new(0, 0, 0)
                }):Play()
            end)
        end
        v_u_408.L1:Emit(v_u_38 * 10)
        task.wait(0.15)
        v_u_410:Destroy()
        v_u_406.Anchored = true
    end)
    task.spawn(function()

    end)
    local v_u_428 = v_u_8.new(v409, v_u_408, 7)
    v_u_428.AnimationSpeed = 10
    v_u_428.CurveSize0 = 3
    v_u_428.CurveSize1 = 3
    if p_u_404 then
        v_u_428.Color = Color3.new(0.847059, 0.294118, 1)
    else
        v_u_428.Color = Color3.new(1, 0.854902, 0.321569)
    end
    v_u_428.Thickness = 1
    v_u_428.PulseSpeed = 10
    v_u_428.PulseLength = 3
    v_u_428.FadeLength = 1
    v_u_428.MaxRadius = 6
    v_u_428.ContractFrom = 0.5
    v_u_428.MinThicknessMultiplier = 0.75
    v_u_428.MaxThicknessMultiplier = 1.5
    v_u_11.new(v_u_428).MaxSparkCount = 3
    task.spawn(function()
        -- upvalues: (copy) v_u_428
        task.wait(2)
        v_u_428:Destroy()
    end)
end)
v_u_4.Remotes.ForceAbilityActivate.OnClientEvent:Connect(function(p_u_429, p_u_430, p_u_431, p_u_432)
    -- upvalues: (copy) v_u_3, (copy) v_u_4, (copy) shockwave, (copy) v_u_6, (copy) v_u_1, (ref) v_u_38
    print(p_u_429, v_u_3.LocalPlayer)
    local v_u_433 = p_u_429.Character.HumanoidRootPart
    if v_u_3.LocalPlayer ~= p_u_429 then
        local function USEFORCE(p434) -- line: 1452
            -- upvalues: (copy) p_u_430, (ref) v_u_4, (ref) shockwave, (copy) v_u_433, (copy) p_u_429, (copy) p_u_432, (ref) v_u_3, (copy) p_u_431, (ref) v_u_6, (ref) v_u_1, (ref) v_u_38
            local v435
            if p_u_430 == 0 then
                v435 = v_u_4.Misc.forcePart:Clone()
                shockwave(v_u_433, 80, 0.4, Color3.new(0, 0.45098, 1), true)
            elseif p_u_430 == 1 then
                v435 = v_u_4.Misc.forcePart2:Clone()
                shockwave(v_u_433, 90, 0.4, Color3.new(0, 0.45098, 1), true)
            else
                v435 = v_u_4.Misc.forcePart3:Clone()
                shockwave(v_u_433, 100, 0.4, Color3.new(1, 0, 0), true)
            end
            v435.Parent = p_u_429.Character.HumanoidRootPart
            v435.Position = v435.Parent.Position
            local v436 = v435.hit
            v436.PlaybackSpeed = v436.PlaybackSpeed - p434
            v435.hit:Play()
            if p_u_432 then
                local v437 = Instance.new("BodyVelocity")
                v437.MaxForce = Vector3.new(20000, 20000, 20000)
                v437.Parent = v_u_3.LocalPlayer.Character.HumanoidRootPart
                v437.Velocity = p_u_431 * (160 + 30 * p_u_430 - (v_u_433.Position - v_u_3.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 2)
                v_u_6:Create(v437, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {
                    ["Velocity"] = Vector3.new(0, 0, 0)
                }):Play()
                v_u_1:AddItem(v437, 0.5)
            end
            for _, v438 in pairs(v435.At2:GetChildren()) do
                local v439 = v438.Name
                if tonumber(v439) then
                    local v440 = v_u_38
                    local v441 = v438.Name
                    v438:Emit(v440 * tonumber(v441))
                end
            end
            v_u_1:AddItem(v435, 2)
        end
        USEFORCE(0)
        task.wait(0.5)
        USEFORCE(0.5)
        task.wait(0.5)
        USEFORCE(1)
    end
end)
v_u_4.Remotes.RaptureSuccess2.OnClientEvent:Connect(function(p442, p443, p444, _)
    -- upvalues: (copy) v_u_3, (copy) v_u_2, (ref) v_u_38, (copy) v_u_6, (copy) shockwave, (copy) v_u_4, (copy) v_u_1
    if v_u_3.LocalPlayer and (v_u_3.LocalPlayer.Character.HumanoidRootPart.Position - p442.HumanoidRootPart.Position).Magnitude <= 20 then
        local v_u_445 = v_u_2.cc1
        v_u_445.Enabled = true
        task.spawn(function()
            -- upvalues: (copy) v_u_445
            task.wait(0.08)
            v_u_445.Enabled = false
        end)
    end
    p444.Parried:Play()
    p444.ParryAttempt.TimePosition = 0.2
    p444.ParryAttempt:Play()
    p444.Sound2:Play()
    p444.AT.ParticleEmitter:Emit(v_u_38 * 40)
    p444.AT.Specs1:Emit(v_u_38 * 40)
    p444.At2.ParticleEmitter:Emit(v_u_38 * 10)
    p444.At2.RealLa:Emit(v_u_38 * 2)
    local v_u_446 = p444:FindFirstChild("MeshPart")
    if not p443 then
        task.spawn(function()
            -- upvalues: (copy) v_u_446, (ref) v_u_6
            if v_u_446 then
                local v447 = v_u_446
                v447.CFrame = v447.CFrame * CFrame.Angles(1.5707963267948966, 0, 0)
                v_u_446.Transparency = 0
                v_u_6:Create(v_u_446, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
                    ["Color"] = Color3.new(1, 0.568627, 0.368627)
                }):Play()
                task.wait(0.3)
                v_u_6:Create(v_u_446, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                    ["Color"] = Color3.new(0, 0, 0)
                }):Play()
                task.wait(0.5)
                v_u_6:Create(v_u_446, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                    ["Transparency"] = 1
                }):Play()
            end
        end)
    end
    shockwave(p442.Torso.Parent.HumanoidRootPart, 40, nil, Color3.new(1, 0.65098, 0.490196), true)
    local v448 = RaycastParams.new()
    v448.FilterType = Enum.RaycastFilterType.Exclude
    v448.FilterDescendantsInstances = { workspace.Alive, workspace.Dead }
    local v449 = workspace:Raycast(p442.HumanoidRootPart.Position, (Vector3.new(0, -1, 0)).unit * 100, v448)
    if v449 and not p443 then
        local v_u_450 = v449.Instance.Color
        local v_u_451 = v449.Instance.Material
        if v_u_446 then
            v_u_446.dust.Color = ColorSequence.new(v_u_450)
            v_u_446.rocks.Color = ColorSequence.new(v_u_450)
            v_u_446.dots.Color = ColorSequence.new(v_u_450)
            v_u_446.dust:Emit(v_u_38 * 50)
            if v_u_451 == Enum.Material.Slate then
                v_u_446.rocks:Emit(v_u_38 * 25)
            else
                v_u_446.dots:Emit(v_u_38 * 25)
            end
        end
        local v_u_452 = v_u_4.Misc.Rocks:Clone()
        v_u_452.Parent = workspace.Runtime
        v_u_1:AddItem(v_u_452, 8)
        v_u_452:SetPrimaryPartCFrame(p444.CFrame * CFrame.new(0, 1, -6))
        for _, v_u_453 in pairs(v_u_452:GetChildren()) do
            if v_u_453.Name == "Wedge" then
                task.spawn(function()
                    -- upvalues: (copy) v_u_453, (copy) v_u_450, (copy) v_u_451, (copy) v_u_452, (ref) v_u_6
                    v_u_453.Color = v_u_450
                    v_u_453.Material = v_u_451
                    local v454 = v_u_453.Position
                    local v455 = v_u_452:FindFirstChild("wedgeR")
                    local v456 = v_u_453
                    local v457 = v_u_453.Position.X
                    local v458 = v455 and v455.Position.Y or v454.Y
                    local v459 = v_u_453.Position.Z
                    v456.Position = Vector3.new(v457, v458, v459)
                    local v460 = v_u_453.Size
                    v_u_453.Size = Vector3.new(0, 0, 0)
                    v_u_6:Create(v_u_453, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                        ["Size"] = v460 * 1.2,
                        ["Position"] = v454
                    }):Play()
                    task.wait(0.25)
                    v_u_6:Create(v_u_453, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                        ["Size"] = v460
                    }):Play()
                    task.wait(4)
                    local v461 = v_u_6
                    local v462 = v_u_453
                    local v463 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
                    local v464 = {
                        ["Size"] = Vector3.new(0, 0, 0)
                    }
                    local v465 = v_u_453.Position.X
                    local v466 = v455 and v455.Position.Y or v454.Y
                    local v467 = v_u_453.Position.Z
                    v464.Position = Vector3.new(v465, v466, v467)
                    v461:Create(v462, v463, v464):Play()
                end)
            end
        end
    end
end)
v_u_4.Remotes.DeathSlashSuccess.OnClientEvent:Connect(function(p468, p469, _)
    -- upvalues: (copy) v_u_3, (copy) v_u_2, (copy) shockwave
    if v_u_3.LocalPlayer and (v_u_3.LocalPlayer.Character.HumanoidRootPart.Position - p468.HumanoidRootPart.Position).Magnitude <= 20 then
        local v_u_470 = v_u_2.cc3
        v_u_470.Enabled = true
        task.delay(0.08, function()
            -- upvalues: (copy) v_u_470
            v_u_470.Enabled = false
        end)
    end
    p469.Parried:Play()
    for _, v471 in pairs(p469.At2:GetChildren()) do
        local v472 = v471.Name
        v471:Emit((tonumber(v472)))
    end
    for _, v473 in pairs(p469.Attachment:GetChildren()) do
        local v474 = v473.Name
        v473:Emit((tonumber(v474)))
    end
    shockwave(p468.Torso.Parent.HumanoidRootPart, 40, nil, Color3.new(0.333333, 0, 1), true)
end)
local v_u_475 = {}
v_u_4.Remotes.DeathSlashPlayerFX.OnClientEvent:Connect(function(p_u_476, p477)
    -- upvalues: (copy) v_u_13, (copy) v_u_4, (copy) v_u_475
    if p477 then
        local v478 = p_u_476.Character
        local v479 = v_u_13.Maid.new()
        local v480 = v_u_4.Misc.DeathSlashAura:Clone()
        for _, v481 in pairs(v480:GetChildren()) do
            if v481.Name == "Head" then
                v481.Parent = v478.Head
            end
            v479:GiveTask(v481)
        end
        v479:GiveTask(v480.HumanoidRootPart)
        v479:GiveTask(v480.BeamPart2)
        v480.HumanoidRootPart.Parent = v478.HumanoidRootPart
        v480.BeamPart2.Parent = v478.HumanoidRootPart
        v_u_475[p_u_476] = v479
        task.delay(5, function()
            -- upvalues: (ref) v_u_475, (copy) p_u_476
            v_u_475[p_u_476]:DoCleaning()
        end)
    elseif v_u_475[p_u_476] then
        v_u_475[p_u_476]:DoCleaning()
    end
end)
v_u_4.Remotes.WindCloak.OnClientEvent:Connect(function(p482, p483, p484)
    -- upvalues: (copy) shockwave, (copy) v_u_4, (copy) v_u_1, (copy) v_u_6
    local v485 = Color3.new(1, 1, 1)
    if p484 then
        v485 = Color3.new(0.470588, 1, 0.760784)
    end
    shockwave(p482.HumanoidRootPart, 30, nil, v485, true)
    if p484 then
        for _, v486 in pairs(p482:GetChildren()) do
            if v486.Name == "Left Arm" or v486.Name == "Right Arm" or v486.Name == "Head" then
                local v487 = v_u_4.Misc.MaxWhirlwinds:Clone()
                v487.Parent = v486
                v487.CFrame = v487.Parent.CFrame
                v487.Size = v487.Parent.Size
                v487.WeldConstraint.Part1 = v487.Parent
                v_u_1:AddItem(v487, p483 + 1)
                v487.Smoke.Enabled = true
            elseif v486.Name == "Torso" then
                local v488 = v_u_4.Misc.MaxWhirlwinds:Clone()
                v488.Parent = v486
                v488.CFrame = v488.Parent.CFrame
                v488.Size = v488.Parent.Size
                v488.WeldConstraint.Part1 = v488.Parent
                v_u_1:AddItem(v488, p483 + 1)
                v488.Smoke.Enabled = true
                v488.Trail.Enabled = true
                v488.att2.whirl.Enabled = true
                v488.WindSound:Play()
                v488.OniCharge:Play()
            elseif v486.Name == "Left Leg" or v486.Name == "Right Leg" then
                local v489 = v_u_4.Misc.MaxWhirlwinds:Clone()
                v489.Parent = v486
                v489.CFrame = v489.Parent.CFrame
                v489.Size = v489.Parent.Size
                v489.WeldConstraint.Part1 = v489.Parent
                v_u_1:AddItem(v489, p483 + 1)
                v489.Smoke.Enabled = true
                if v489.Parent == "Left Leg" then
                    v489.att1.whirl.RotSpeed = NumberRange.new(500, 1000)
                end
                v489.att1.whirl.Enabled = true
                v489.Specs1.Enabled = true
            end
        end
    else
        for _, v490 in pairs(p482:GetChildren()) do
            if v490.Name == "Left Arm" or v490.Name == "Right Arm" or v490.Name == "Head" then
                local v491 = v_u_4.Misc.Whirlwinds:Clone()
                v491.Parent = v490
                v491.CFrame = v491.Parent.CFrame
                v491.Size = v491.Parent.Size
                v491.WeldConstraint.Part1 = v491.Parent
                v_u_1:AddItem(v491, p483 + 1)
                v491.Smoke.Enabled = true
            elseif v490.Name == "Torso" then
                local v492 = v_u_4.Misc.Whirlwinds:Clone()
                v_u_1:AddItem(v492, p483 + 1)
                v492.Parent = v490
                v492.CFrame = v492.Parent.CFrame
                v492.Size = v492.Parent.Size
                v492.WeldConstraint.Part1 = v492.Parent
                v492.Smoke.Enabled = true
                v492.Trail.Enabled = true
                v492.att2.whirl.Enabled = true
                v492.WindSound:Play()
                v492.OniCharge:Play()
            elseif v490.Name == "Left Leg" or v490.Name == "Right Leg" then
                local v493 = v_u_4.Misc.Whirlwinds:Clone()
                v493.Parent = v490
                v493.CFrame = v493.Parent.CFrame
                v493.Size = v493.Parent.Size
                v493.WeldConstraint.Part1 = v493.Parent
                v_u_1:AddItem(v493, p483 + 1)
                if v490.Name == "Left Leg" then
                    v493.att1.whirl.RotSpeed = NumberRange.new(500, 1000)
                end
                v493.Smoke.Enabled = true
                v493.att1.whirl.Enabled = true
                v493.Specs1.Enabled = true
            end
        end
    end
    task.wait(p483 - 1)
    shockwave(p482.HumanoidRootPart, 15, nil, v485, true)
    for _, v494 in pairs(p482:GetDescendants()) do
        if v494.Name == "Whirlwinds" or v494.Name == "MaxWhirlwinds" then
            for _, v495 in pairs(v494:GetDescendants()) do
                if v495:IsA("ParticleEmitter") or v495:IsA("Trail") then
                    v495.Enabled = false
                elseif v495:IsA("Sound") then
                    if v495.Name == "OniCharge" then
                        v495:Play()
                    end
                    v_u_6:Create(v495, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
                        ["Volume"] = 0
                    }):Play()
                end
            end
        end
    end
end)
v_u_4.Remotes.CloakJump.OnClientEvent:Connect(function(p496, p497)
    -- upvalues: (copy) shockwave
    local v498 = Color3.new(1, 1, 1)
    if p497 then
        v498 = Color3.new(0.470588, 1, 0.760784)
    end
    if p496.Torso:FindFirstChild("Whirlwinds") then
        if p496.Torso:FindFirstChild("Whirlwinds").Smoke.Enabled == false then
            return
        end
        p496.Torso:FindFirstChild("Whirlwinds").Jump:Play()
        shockwave(p496.HumanoidRootPart, 20, nil, v498, true)
    end
    if p496.Torso:FindFirstChild("MaxWhirlwinds") then
        if p496.Torso:FindFirstChild("MaxWhirlwinds").Smoke.Enabled == false then
            return
        end
        p496.Torso:FindFirstChild("MaxWhirlwinds").Jump:Play()
        shockwave(p496.HumanoidRootPart, 20, nil, v498, true)
    end
end)
v_u_4.Remotes.PhaseBypassed.OnClientEvent:Connect(function(p_u_499)
    -- upvalues: (copy) shockwave, (copy) phasebypass, (copy) v_u_4, (copy) v_u_1, (copy) v_u_6
    pcall(function()
        -- upvalues: (ref) shockwave, (copy) p_u_499, (ref) phasebypass, (ref) v_u_4, (ref) v_u_1, (ref) v_u_6
        task.spawn(function()
            -- upvalues: (ref) shockwave, (ref) p_u_499
            shockwave(p_u_499.HumanoidRootPart, 30, nil, Color3.new(0.607843, 0.423529, 1), true)
        end)
        task.spawn(function()
            -- upvalues: (ref) phasebypass, (ref) p_u_499
            phasebypass(p_u_499)
        end)
        task.spawn(function()
            -- upvalues: (ref) v_u_4, (ref) p_u_499, (ref) v_u_1, (ref) v_u_6
            local v500 = v_u_4.Misc.ShadowFolder
            local v501 = Color3.new(0, 1, 0.282353)
            local v_u_502 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            local v503 = {
                v500.Head:Clone(),
                v500["Left Arm"]:Clone(),
                v500["Left Leg"]:Clone(),
                v500["Right Arm"]:Clone(),
                v500["Right Leg"]:Clone(),
                v500.Torso:Clone()
            }
            for _, v504 in v503 do
                v504.CFrame = p_u_499[v504.Name].CFrame
                v504.Color = v501
            end
            local v505 = v_u_4.Misc.PhaseBP:Clone()
            v505.Parent = v503[6]
            v505.Position = v505.Parent.Position
            v505.WeldConstraint.Part1 = v505.Parent
            v505.Attachment.ParticleEmitter.Enabled = true
            v_u_1:AddItem(v505, 5)
            for _, v_u_506 in v503 do
                v_u_506.Parent = workspace.Runtime
                v_u_1:AddItem(v_u_506, 4.5)
                task.spawn(function()
                    -- upvalues: (copy) v_u_506, (ref) v_u_6, (copy) v_u_502
                    task.wait(3)
                    if v_u_506.Name == "Torso" then
                        v_u_506.PhaseBP.Attachment.ParticleEmitter.Enabled = false
                        v_u_506.PhaseBP.ParticleEmitter.Enabled = false
                        v_u_506.PhaseBP.Particle2.Enabled = false
                    end
                    local v507 = v_u_6
                    local v508 = v_u_506
                    local v509 = v_u_502
                    local v510 = {
                        ["Transparency"] = 1
                    }
                    local v511 = v_u_506.Size.X * 3
                    local v512 = v_u_506.Size.Y * 3
                    local v513 = v_u_506.Size.Z * 3
                    v510.Size = Vector3.new(v511, v512, v513)
                    v507:Create(v508, v509, v510):Play()
                end)
            end
        end)
        local v514 = v_u_4.Misc.PhaseBP:Clone()
        v514.Parent = p_u_499.HumanoidRootPart
        v514.CFrame = v514.Parent.CFrame
        v514.WeldConstraint.Part1 = v514.Parent
        v514.CyberStep:Play()
        v514.Step:Play()
        v_u_1:AddItem(v514, 5)
        task.wait(3)
        v514.Step:Play()
        v514.ParticleEmitter.Enabled = false
        v514.Particle2.Enabled = false
        shockwave(p_u_499.HumanoidRootPart, 30, nil, Color3.new(0, 1, 0.164706), true)
    end)
end)
v_u_4.Remotes.Infinity.OnClientEvent:Connect(function(p_u_515, p516)
    -- upvalues: (copy) shockwave, (copy) v_u_4, (copy) v_u_1, (copy) v_u_6
    local v517 = Color3.new(0.27451, 0.372549, 1)
    if p516 then
        v517 = Color3.new(1, 0.898039, 0.486275)
    end
    shockwave(p_u_515.HumanoidRootPart, 30, nil, v517, true)
    local v_u_518
    if p516 then
        v_u_518 = v_u_4.Misc.TrueInfinityFX:Clone()
    else
        v_u_518 = v_u_4.Misc.InfinityFX:Clone()
    end
    v_u_518.Parent = workspace.Runtime
    v_u_1:AddItem(v_u_518, 12)
    p_u_515:GetAttributeChangedSignal("AbilityActive"):Once(function()
        -- upvalues: (copy) p_u_515, (ref) v_u_518
        if not p_u_515:GetAttribute("AbilityActive") then
            v_u_518:Destroy()
        end
    end)
    for _, v_u_519 in pairs(v_u_518:GetChildren()) do
        if v_u_519.Name == "Brum" then
            v_u_519.Parent = p_u_515.Torso
        else
            v_u_519.Parent = p_u_515[v_u_519.Name]
        end
        v_u_1:AddItem(v_u_519, 12)
        if v_u_519:IsA("Sound") then
            v_u_519:Play()
        end
        task.spawn(function()
            -- upvalues: (copy) v_u_519, (ref) v_u_6
            task.wait(10)
            if v_u_519:IsA("ParticleEmitter") then
                v_u_519.Enabled = false
            end
            if v_u_519:IsA("Attachment") then
                for _, v520 in pairs(v_u_519:GetChildren()) do
                    if v520:IsA("ParticleEmitter") then
                        v520.Enabled = false
                    end
                    if v520:IsA("Sound") then
                        v_u_6:Create(v520, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                            ["Volume"] = 0
                        }):Play()
                    end
                    if v520:IsA("Beam") then
                        v520.Enabled = false
                    end
                end
            end
            if v_u_519:IsA("Sound") then
                if v_u_519.Name == "Brum" then
                    v_u_519:Play()
                else
                    v_u_6:Create(v_u_519, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                        ["Volume"] = 0
                    }):Play()
                end
            end
            if v_u_519:IsA("Beam") then
                v_u_519.Enabled = false
            end
        end)
    end
    task.wait(10)
    if p_u_515:FindFirstChild("HumanoidRootPart") then
        shockwave(p_u_515.HumanoidRootPart, 30, nil, v517, true)
    end
end)
local v_u_521 = require(v_u_4.Shared.SafeTeleport)
v_u_4.Remotes.Swapped.OnClientEvent:Connect(function(p522, p523, p524)
    -- upvalues: (copy) v_u_3, (copy) v_u_521, (copy) v_u_4, (copy) v_u_1, (copy) shockwave, (ref) v_u_38, (copy) v_u_8, (copy) v_u_11
    local v525 = p522.HumanoidRootPart.Position
    local v526 = p523.HumanoidRootPart.Position
    local v527 = p522.HumanoidRootPart.CFrame
    local v528 = p523.HumanoidRootPart.CFrame
    local v_u_529 = p524 and 0.25 or 0.5
    if p522 == v_u_3.LocalPlayer.Character then
        task.delay(v_u_529, v_u_521, p522, CFrame.lookAt(v526, v526 + v527.LookVector))
        print("TP ME")
    elseif p523 == v_u_3.LocalPlayer.Character then
        task.delay(v_u_529, v_u_521, p523, CFrame.lookAt(v525, v525 + v528.LookVector))
    end
    print(p522, p523, v_u_3.LocalPlayer.Character)
    if p524 then
        local v_u_530 = v_u_4.Misc.maxSwap:Clone()
        local v_u_531 = v_u_4.Misc.maxSwap:Clone()
        v_u_530.Parent = p522
        v_u_531.Parent = p523
        v_u_1:AddItem(v_u_530, 2)
        v_u_1:AddItem(v_u_531, 2)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (copy) v_u_530, (ref) v_u_38, (copy) v_u_529
            shockwave(v_u_530, 15, nil, Color3.new(0, 1, 0.466667), true)
            v_u_530.CFrame = v_u_530.Parent.HumanoidRootPart.CFrame
            v_u_530.WeldConstraint.Part1 = v_u_530.Parent.HumanoidRootPart
            v_u_530.charg:Play()
            v_u_530.Attachment.Osu:Emit(v_u_38 * 1)
            v_u_530.Attachment.zapper:Emit(v_u_38 * 3)
            task.wait(v_u_529)
            shockwave(v_u_530, 25, nil, Color3.new(0, 1, 0.466667), true)
            v_u_530.blas:Play()
            v_u_530.Attachment.Specs2:Emit(v_u_38 * 10)
            v_u_530.Attachment.chb:Emit(v_u_38 * 3)
            v_u_530.Attachment.colorme:Emit(v_u_38 * 5)
        end)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (copy) v_u_531, (ref) v_u_38, (copy) v_u_529
            shockwave(v_u_531, 15, nil, Color3.new(0, 1, 0.466667), true)
            v_u_531.CFrame = v_u_531.Parent.HumanoidRootPart.CFrame
            v_u_531.WeldConstraint.Part1 = v_u_531.Parent.HumanoidRootPart
            v_u_531.charg:Play()
            v_u_531.Attachment.Osu:Emit(v_u_38 * 1)
            v_u_531.Attachment.zapper:Emit(v_u_38 * 3)
            task.wait(v_u_529)
            shockwave(v_u_531, 25, nil, Color3.new(0, 1, 0.466667), true)
            v_u_531.blas:Play()
            v_u_531.Attachment.Specs2:Emit(v_u_38 * 10)
            v_u_531.Attachment.chb:Emit(v_u_38 * 3)
            v_u_531.Attachment.colorme:Emit(v_u_38 * 5)
        end)
        local v_u_532 = v_u_8.new(v_u_530.Attachment, v_u_531.Attachment, 15)
        v_u_532.AnimationSpeed = 6
        v_u_532.CurveSize0 = 3
        v_u_532.CurveSize1 = 3
        if p524 then
            v_u_532.Color = Color3.new(0, 1, 0.466667)
        else
            v_u_532.Color = Color3.new(0, 1, 0.466667)
        end
        v_u_532.Thickness = 0.3
        v_u_532.PulseSpeed = 10
        v_u_532.PulseLength = 5
        v_u_532.FadeLength = 1
        v_u_532.MaxRadius = 5
        v_u_532.ContractFrom = 0.2
        v_u_532.MinThicknessMultiplier = 0.75
        v_u_532.MaxThicknessMultiplier = 1.5
        v_u_11.new(v_u_532).MaxSparkCount = 3
        task.spawn(function()
            -- upvalues: (copy) v_u_529, (copy) v_u_532
            task.wait(v_u_529)
            task.wait(0.13)
            v_u_532:Destroy()
        end)
    else
        local v_u_533 = v_u_4.Misc.swappart:Clone()
        local v_u_534 = v_u_4.Misc.swappart:Clone()
        v_u_533.Parent = p522
        v_u_534.Parent = p523
        v_u_1:AddItem(v_u_533, 2)
        v_u_1:AddItem(v_u_534, 2)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (copy) v_u_533, (ref) v_u_38
            shockwave(v_u_533, 15, nil, Color3.new(0.290196, 0.560784, 1), true)
            v_u_533.CFrame = v_u_533.Parent.HumanoidRootPart.CFrame
            v_u_533.WeldConstraint.Part1 = v_u_533.Parent.HumanoidRootPart
            v_u_533.charg:Play()
            v_u_533.Attachment.Osu:Emit(v_u_38 * 1)
            v_u_533.Attachment.zapper:Emit(v_u_38 * 3)
            task.wait(0.5)
            shockwave(v_u_533, 25, nil, Color3.new(0.290196, 0.560784, 1), true)
            v_u_533.blas:Play()
            v_u_533.Attachment.Specs2:Emit(v_u_38 * 10)
            v_u_533.Attachment.chb:Emit(v_u_38 * 3)
            v_u_533.Attachment.colorme:Emit(v_u_38 * 5)
        end)
        task.spawn(function()
            -- upvalues: (ref) shockwave, (copy) v_u_534, (ref) v_u_38
            shockwave(v_u_534, 15, nil, Color3.new(0.290196, 0.560784, 1), true)
            v_u_534.CFrame = v_u_534.Parent.HumanoidRootPart.CFrame
            v_u_534.WeldConstraint.Part1 = v_u_534.Parent.HumanoidRootPart
            v_u_534.charg:Play()
            v_u_534.Attachment.Osu:Emit(v_u_38 * 1)
            v_u_534.Attachment.zapper:Emit(v_u_38 * 3)
            task.wait(0.5)
            shockwave(v_u_534, 25, nil, Color3.new(0.290196, 0.560784, 1), true)
            v_u_534.blas:Play()
            v_u_534.Attachment.Specs2:Emit(v_u_38 * 10)
            v_u_534.Attachment.chb:Emit(v_u_38 * 3)
            v_u_534.Attachment.colorme:Emit(v_u_38 * 5)
        end)
        local v_u_535 = v_u_8.new(v_u_533.Attachment, v_u_534.Attachment, 15)
        v_u_535.AnimationSpeed = 6
        v_u_535.CurveSize0 = 3
        v_u_535.CurveSize1 = 3
        if p524 then
            v_u_535.Color = Color3.new(0.290196, 0.560784, 1)
        else
            v_u_535.Color = Color3.new(0.290196, 0.596078, 1)
        end
        v_u_535.Thickness = 0.3
        v_u_535.PulseSpeed = 10
        v_u_535.PulseLength = 5
        v_u_535.FadeLength = 1
        v_u_535.MaxRadius = 5
        v_u_535.ContractFrom = 0.2
        v_u_535.MinThicknessMultiplier = 0.75
        v_u_535.MaxThicknessMultiplier = 1.5
        v_u_11.new(v_u_535).MaxSparkCount = 3
        task.spawn(function()
            -- upvalues: (copy) v_u_529, (copy) v_u_535
            task.wait(v_u_529)
            task.wait(0.13)
            v_u_535:Destroy()
        end)
    end
end)
v_u_4.Remotes.ReaperFx.OnClientEvent:Connect(function(p536, p537, p538)
    -- upvalues: (copy) shockwave, (copy) v_u_4, (ref) v_u_38
    local v539 = Color3.new(0.227451, 0, 0)
    local v540 = Color3.new(1, 0, 0)
    if p538 then
        v539 = Color3.new(0.101961, 0, 0.227451)
        v540 = Color3.new(0.415686, 0, 1)
    end
    if p537 < 4 then
        shockwave(p536.HumanoidRootPart, 25, nil, v539, true)
    else
        shockwave(p536.HumanoidRootPart, 25 + p537 * 2, nil, v540, true)
    end
    local v541 = false
    for _, v542 in pairs(p536:GetDescendants()) do
        if v542.Name == "IsReaper" then
            v541 = true
        end
    end
    if v541 then
        local v543 = nil
        for _, v544 in pairs(p536:GetDescendants()) do
            v543 = v544:FindFirstChild("IsReaper") and v544.Name == "A1" and true or v544.Name == "A2" and true or v543
            if v544:FindFirstChild("IsReaper") and v544.Name == "Torso" and v544:IsA("ParticleEmitter") and not v544:FindFirstChild("Configuration") then
                v544.Rate = p537
            end
            if v544:FindFirstChild("IsReaper") and v544.Name == "Torso" and v544:IsA("ParticleEmitter") and v544:FindFirstChild("Configuration") and p537 == 5 then
                v544.Enabled = true
            end
            if v544:FindFirstChild("IsReaper") and v544.Name == "Torso" and v544:IsA("Attachment") and v544:FindFirstChildOfClass("ParticleEmitter") then
                for _, v545 in pairs(v544:GetChildren()) do
                    if v545:IsA("ParticleEmitter") then
                        if v545.Name == "1" or v545.Name == "2" or v545.Name == "3" or v545.Name == "4" or v545.Name == "5" then
                            local v546 = v545.Name
                            if tonumber(v546) == p537 then
                                v545:Emit(v_u_38 * 3)
                            end
                        else
                            local v547 = v_u_38
                            local v548 = v545:FindFirstChildOfClass("Folder").Name
                            v545:Emit(v547 * tonumber(v548))
                        end
                    end
                end
            end
            if v544:FindFirstChild("IsReaper") and v544.Name == "HumanoidRootPart" then
                if v544:IsA("Sound") then
                    if v544:FindFirstChild("Station") then
                        v544.Volume = p537 * 0.1
                        v544.PlaybackSpeed = 1 - p537 * 0.05
                    else
                        v544:Play()
                    end
                elseif p537 >= 2 then
                    v544.Beam.Attachment0 = v544
                    local v549 = nil
                    for _, v550 in pairs(v544.Parent.Parent.Torso:GetChildren()) do
                        if v550:IsA("Attachment") then
                            if v550.Name == "Torso" then
                                if v550:FindFirstChild("Configuration") then
                                    v549 = v550
                                end
                            end
                        end
                    end
                    v544.Beam.Attachment1 = v549
                    v544.Beam.Enabled = true
                end
            end
            if v544:FindFirstChild("IsReaper") then
                if v544.Name == "Head" then
                    for _, v551 in pairs(v544:GetChildren()) do
                        if v551:IsA("ParticleEmitter") then
                            local v552 = v551:FindFirstChildOfClass("Configuration").Name
                            if tonumber(v552) <= p537 then
                                v551.Enabled = true
                            end
                        end
                    end
                end
            end
        end
        if not v543 then
            local v553 = v_u_4.Misc.ReaperFX.A1:Clone()
            local v554 = v_u_4.Misc.ReaperFX.A2:Clone()
            local v555 = p536.Torso
            local v556 = p536.Torso
            v553.Parent = v555
            v554.Parent = v556
            v553.Trail.Enabled = true
            v553.Trail.Attachment0 = v553
            v553.Trail.Attachment1 = v554
        end
    else
        local v557
        if p538 then
            v557 = v_u_4.Misc.MaxReaperFX
        else
            v557 = v_u_4.Misc.ReaperFX
        end
        for _, v558 in pairs(v557:GetChildren()) do
            local v559 = v558:Clone()
            if v559.Name == "A1" or v559.Name == "A2" then
                v559:Destroy()
            else
                v559.Parent = p536[v559.Name]
                if v559.Name ~= "Torso" or not v559:IsA("ParticleEmitter") or v559:FindFirstChild("Configuration") then
                    if v559.Name == "Torso" and v559:IsA("Attachment") and v559:FindFirstChildOfClass("ParticleEmitter") then
                        for _, v560 in pairs(v559:GetChildren()) do
                            if v560:IsA("ParticleEmitter") then
                                if v560.Name == "1" or v560.Name == "2" or v560.Name == "3" or v560.Name == "4" or v560.Name == "5" then
                                    v560.Parent["1"]:Emit(v_u_38 * 3)
                                else
                                    local v561 = v_u_38
                                    local v562 = v560:FindFirstChildOfClass("Folder").Name
                                    v560:Emit(v561 * tonumber(v562))
                                end
                            end
                        end
                    elseif v559.Name == "Torso" and v559:FindFirstChild("Configuration") and p537 == 5 then
                        v559.Enabled = true
                    end
                end
                if v559:IsA("Sound") then
                    v559:Play()
                end
                if v559:IsA("Attachment") and v559.Name ~= "Torso" then
                    for _, v563 in pairs(v559:GetChildren()) do
                        if v563:FindFirstChild("Enabled") then
                            local v564 = v563:FindFirstChildOfClass("Configuration").Name
                            if tonumber(v564) <= p537 then
                                if v563:IsA("ParticleEmitter") then
                                    v563:Emit(v_u_38 * 1)
                                end
                                v563.Enabled = true
                            end
                        end
                    end
                end
            end
        end
    end
end)
v_u_4.Remotes.DisableReaper.OnClientEvent:Connect(function(p565)
    for _, v566 in pairs(p565:GetDescendants()) do
        if v566:FindFirstChild("IsReaper") then
            v566:Destroy()
        end
    end
end)
v_u_4.Remotes.XtraJumped.OnClientEvent:Connect(function(p567, p568)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) shockwave
    local v569 = v_u_4.Misc.quadjumpz:Clone()
    v569.Parent = workspace.Runtime
    v_u_1:AddItem(v569, 1)
    v569.CFrame = p567.HumanoidRootPart.CFrame
    v569.Position = v569.Position - Vector3.new(0, 1, 0)
    v569.Jump:Play()
    local v570 = Color3.new(0.756863, 0.756863, 0.756863)
    if p568 then
        v570 = Color3.new(0.360784, 0.745098, 1)
    end
    shockwave(v569, 10, nil, v570, true)
end)
v_u_4.Remotes.Phantom.OnClientEvent:Connect(function(p571, p572, p573)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (ref) v_u_38, (copy) v_u_6, (copy) v_u_8, (copy) v_u_11, (copy) shockwave
    if p571 and p572 then
        p571:PivotTo(CFrame.lookAt(p572:GetPivot().Position, p572:GetPivot().Position + p571:GetPivot().LookVector))
        local v_u_574, v_u_575, v_u_576
        if p573 then
            v_u_574 = v_u_4.Misc.maxTransmission:Clone()
            v_u_575 = v_u_4.Misc.maxTransmission:Clone()
            v_u_576 = Color3.new(1, 0.635294, 0)
        else
            v_u_574 = v_u_4.Misc.transmissionpart:Clone()
            v_u_575 = v_u_4.Misc.transmissionpart:Clone()
            v_u_576 = Color3.new(0.207843, 0.152941, 1)
        end
        v_u_574.CFrame = p571.HumanoidRootPart.CFrame
        v_u_574.WeldConstraint.Part1 = p571.HumanoidRootPart
        v_u_575.CFrame = p572.HumanoidRootPart.CFrame
        v_u_575.WeldConstraint.Part1 = p572.HumanoidRootPart
        v_u_574.Parent = workspace.Runtime
        v_u_575.Parent = workspace.Runtime
        v_u_1:AddItem(v_u_574, 5)
        v_u_1:AddItem(v_u_575, 7)
        task.spawn(function()
            -- upvalues: (ref) v_u_574
            task.wait(0.1)
            v_u_574.otherpart.Position = v_u_574.Position + Vector3.new(0, 20, 0)
        end)
        local v577 = {
            p571.Head.CFrame,
            p571["Left Arm"].CFrame,
            p571["Left Leg"].CFrame,
            p571["Right Arm"].CFrame,
            p571["Right Leg"].CFrame,
            p571.Torso.CFrame
        }
        if not p573 then
            v_u_574.charg:Play()
        end
        v_u_575.reaperSound:Play()
        local v_u_578 = v_u_574.Attachment
        if not p573 then
            v_u_578.Osu:Emit(v_u_38 * 1)
            v_u_578.zapper:Emit(v_u_38 * 1)
        end
        v_u_574.otherpart.Attachment.ParticleEmitter:Emit(v_u_38 * 20)
        v_u_575.Attachment.Smoke2nd:Emit(v_u_38 * 1)
        local v579 = v_u_4.Misc.ShadowFolder
        local v580 = v579.Head:Clone()
        local v581 = v579["Left Arm"]:Clone()
        local v582 = v579["Left Leg"]:Clone()
        local v583 = v579["Right Arm"]:Clone()
        local v584 = v579["Right Leg"]:Clone()
        local v585 = v579.Torso:Clone()
        local v586 = Color3.new(0, 0, 0)
        v580.Color = v586
        v581.Color = v586
        v582.Color = v586
        v583.Color = v586
        v584.Color = v586
        v585.Color = v586
        v580.CFrame = p572.Head.CFrame
        v581.CFrame = p572["Left Arm"].CFrame
        v582.CFrame = p572["Left Leg"].CFrame
        v583.CFrame = p572["Right Arm"].CFrame
        v584.CFrame = p572["Right Leg"].CFrame
        v585.CFrame = p572.Torso.CFrame
        for _, v_u_587 in ipairs({
            v580,
            v581,
            v582,
            v583,
            v584,
            v585
        }) do
            local v588 = Instance.new("WeldConstraint")
            v588.Parent = v_u_587
            v588.Part0 = v_u_587
            if v_u_587.Name == "Head" then
                v588.Part1 = p572.Head
            elseif v_u_587.Name == "LeftArm" then
                v588.Part1 = p572["Left Arm"]
            elseif v_u_587.Name == "LeftLeg" then
                v588.Part1 = p572["Left Leg"]
            elseif v_u_587.Name == "RightArm" then
                v588.Part1 = p572["Right Arm"]
            elseif v_u_587.Name == "RightLeg" then
                v588.Part1 = p572["Right Leg"]
            elseif v_u_587.Name == "Torso" then
                v588.Part1 = p572.Torso
            end
            local v589 = v_u_587.Size.X * 1.2
            local v590 = v_u_587.Size.Y * 1.2
            local v591 = v_u_587.Size.Z * 1.2
            v_u_587.Size = Vector3.new(v589, v590, v591)
            v_u_587.Anchored = false
            v_u_587.Transparency = 0
            v_u_587.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_587, 2)
            task.spawn(function()
                -- upvalues: (copy) v_u_587, (ref) v_u_6
                task.wait(0.5)
                local v592 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
                local v593 = {
                    ["Transparency"] = 1
                }
                local v594 = v_u_587.Size.X * 1.5
                local v595 = v_u_587.Size.Y * 1.5
                local v596 = v_u_587.Size.Z * 1.5
                v593.Size = Vector3.new(v594, v595, v596)
                v_u_6:Create(v_u_587, v592, v593):Play()
            end)
        end
        if p573 then
            task.spawn(function()
                -- upvalues: (ref) v_u_8, (ref) v_u_574, (copy) v_u_578, (ref) v_u_576, (ref) v_u_11
                task.wait(0.1)
                local v597 = v_u_8.new(v_u_574.otherpart.Attachment, v_u_578, 7)
                v597.AnimationSpeed = 5
                v597.CurveSize0 = 3
                v597.CurveSize1 = 3
                v597.Color = v_u_576
                v597.Thickness = 0.5
                v597.PulseSpeed = 10
                v597.PulseLength = 4
                v597.FadeLength = 1
                v597.MaxRadius = 5
                v597.ContractFrom = 0.2
                v597.MinThicknessMultiplier = 0.75
                v597.MaxThicknessMultiplier = 1.5
                local v598 = v_u_11.new(v597)
                v598.Color = Color3.new(1, 0.905882, 0.360784)
                v598.MaxSparkCount = 3
            end)
        else
            local v599 = v_u_8.new(v_u_574.otherpart.Attachment, v_u_578, 7)
            v599.AnimationSpeed = 5
            v599.CurveSize0 = 3
            v599.CurveSize1 = 3
            v599.Color = v_u_576
            v599.Thickness = 0.4
            v599.PulseSpeed = 10
            v599.PulseLength = 4
            v599.FadeLength = 1
            v599.MaxRadius = 5
            v599.ContractFrom = 0.2
            v599.MinThicknessMultiplier = 0.75
            v599.MaxThicknessMultiplier = 1.5
            local v600 = v_u_11.new(v599)
            v600.Color = Color3.new(0, 0, 0)
            v600.MaxSparkCount = 3
        end
        shockwave(v_u_574, 15, nil, v_u_576, true)
        shockwave(v_u_575, 15, nil, v_u_576, true)
        if not p573 then
            task.wait(0.3)
        end
        v_u_578.Smoke:Emit(v_u_38 * 1)
        if not p573 then
            task.wait(0.167)
        end
        v_u_575.atttoo.p22:Emit(v_u_38 * 1)
        local v601 = v_u_4.Misc.ShadowFolder
        local v602 = v601.Head:Clone()
        local v603 = v601["Left Arm"]:Clone()
        local v604 = v601["Left Leg"]:Clone()
        local v605 = v601["Right Arm"]:Clone()
        local v606 = v601["Right Leg"]:Clone()
        local v607 = v601.Torso:Clone()
        local v608 = Color3.new(0, 0, 0)
        if p573 then
            v608 = Color3.new(1, 0.815686, 0.145098)
        end
        v602.Color = v608
        v603.Color = v608
        v604.Color = v608
        v605.Color = v608
        v606.Color = v608
        v607.Color = v608
        v602.CFrame = v577[1]
        v603.CFrame = v577[2]
        v604.CFrame = v577[5]
        v605.CFrame = v577[3]
        v606.CFrame = v577[4]
        v607.CFrame = v577[6]
        local v609 = v_u_574.atttoo
        v609.Parent = v607
        v609.p22:Emit(v_u_38 * 1)
        for _, v_u_610 in ipairs({
            v602,
            v603,
            v604,
            v605,
            v606,
            v607
        }) do
            v_u_610.Parent = workspace.Runtime
            v_u_1:AddItem(v_u_610, 2)
            task.spawn(function()
                -- upvalues: (ref) v_u_6, (copy) v_u_610
                task.wait(0.5)
                v_u_6:Create(v_u_610, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
                    ["Transparency"] = 1,
                    ["Size"] = Vector3.new(0, 0, 0)
                }):Play()
            end)
        end
        if not p573 then
            task.wait(0.033)
        end
        task.spawn(function()
            -- upvalues: (ref) v_u_575
            v_u_575.new.Enabled = true
            task.wait(5)
            v_u_575.new.Enabled = false
        end)
        v_u_578.Specs2:Emit(v_u_38 * 10)
        v_u_578.darkspecs:Emit(v_u_38 * 10)
        v_u_578.chb:Emit(v_u_38 * 1)
        v_u_578.colorme:Emit(v_u_38 * 5)
        v_u_574.blas:Play()
        v_u_574.blas2:Play()
        v_u_575.Attachment.darkspecs:Emit(v_u_38 * 10)
        shockwave(v_u_574, 25, nil, v_u_576, true)
    end
end)
v_u_4.Remotes.Blinked.OnClientEvent:Connect(function(_, _, p611, p612)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (ref) v_u_38, (copy) v_u_6
    local v613
    if p611 then
        v613 = v_u_4.Misc.MaxBlink:Clone()
    else
        v613 = v_u_4.Misc.Blink:Clone()
    end
    v613.Parent = workspace.Runtime
    v_u_1:AddItem(v613, 4)
    v613.CFrame = p612[6]
    v613.sound2:Play()
    v613.sound1:Play()
    v613.Attachment.Specs2:Emit(v_u_38 * 10)
    v613.Attachment.ball:Emit(v_u_38 * 1)
    local v614 = v_u_4.Misc.ShadowFolder
    local v615 = v614.Head:Clone()
    local v616 = v614["Left Arm"]:Clone()
    local v617 = v614["Left Leg"]:Clone()
    local v618 = v614["Right Arm"]:Clone()
    local v619 = v614["Right Leg"]:Clone()
    local v620 = v614.Torso:Clone()
    local v621 = Color3.new(0.321569, 0.478431, 1)
    if p611 then
        v621 = Color3.new(1, 1, 0.556863)
    end
    v615.Color = v621
    v616.Color = v621
    v617.Color = v621
    v618.Color = v621
    v619.Color = v621
    v620.Color = v621
    v615.CFrame = p612[1]
    v616.CFrame = p612[2]
    v617.CFrame = p612[5]
    v618.CFrame = p612[3]
    v619.CFrame = p612[4]
    v620.CFrame = p612[6]
    for _, v_u_622 in ipairs({
        v615,
        v616,
        v617,
        v618,
        v619,
        v620
    }) do
        v_u_622.Parent = workspace.Runtime
        v_u_1:AddItem(v_u_622, 2)
        task.spawn(function()
            -- upvalues: (copy) v_u_622, (ref) v_u_6
            task.wait(0.5)
            local v623 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            local v624 = {}
            local v625 = v_u_622.Position.X
            local v626 = v_u_622.Position.Y + 5
            local v627 = v_u_622.Position.Z
            v624.Position = Vector3.new(v625, v626, v627)
            v624.Size = Vector3.new(0, 0, 0)
            v_u_6:Create(v_u_622, v623, v624):Play()
        end)
    end
end)
v_u_4.Remotes.PulseFX.OnClientEvent:Connect(function(p_u_628, p629, p_u_630, p_u_631, p_u_632)
    -- upvalues: (copy) v_u_4, (copy) shockwave, (ref) v_u_38, (copy) v_u_8, (copy) v_u_11, (copy) v_u_6, (copy) v_u_1
    local v_u_633 = p_u_628.CFrame
    local v_u_634 = p_u_628.Parent
    local v_u_635, v_u_636
    if p629 then
        v_u_635 = v_u_4.Misc.maxpulse_part
        v_u_636 = Color3.new(0, 0.14902, 1)
    else
        v_u_635 = v_u_4.Misc.pulse_part
        v_u_636 = Color3.new(1, 0, 0)
    end
    task.spawn(shockwave, p_u_628, p_u_630 * 2, 0.4, v_u_636, true)
    task.delay(0.5, function()
        -- upvalues: (copy) p_u_631, (copy) v_u_633, (copy) p_u_630, (ref) v_u_635, (copy) v_u_634, (ref) v_u_38, (ref) v_u_8, (copy) p_u_628, (ref) v_u_636, (ref) v_u_11, (copy) p_u_632, (ref) v_u_6, (ref) v_u_1
        for _, v637 in pairs(p_u_631) do
            local v_u_638 = v637[1]
            local _ = v637[2]
            if v_u_638 then
                local v_u_639 = v_u_638.PrimaryPart
                if v_u_639 and p_u_630 >= (v_u_639.Position - v_u_633.Position).Magnitude then
                    task.spawn(function()
                        -- upvalues: (ref) v_u_635, (copy) v_u_638, (copy) v_u_639, (ref) v_u_634, (ref) v_u_38, (ref) v_u_8, (ref) p_u_628, (ref) v_u_636, (ref) v_u_11, (ref) p_u_632, (ref) v_u_6, (ref) v_u_1
                        local v_u_640 = v_u_635:Clone()
                        v_u_640.Parent = v_u_638
                        v_u_640.CFrame = v_u_639.CFrame
                        v_u_640.WeldConstraint.Part1 = v_u_639
                        if v_u_638 == v_u_634 then
                            v_u_640.blas:Play()
                            v_u_640.blas2:Play()
                            for _, v641 in pairs(v_u_640.Attachment:GetChildren()) do
                                if v641.Name ~= "aurazap" then
                                    local v642 = v_u_38
                                    local v643 = v641.Name
                                    v641:Emit(v642 * tonumber(v643))
                                end
                            end
                        else
                            v_u_640.zip:Play()
                            v_u_640.Attachment.aurazap.Enabled = true
                            local v644, v645 = pcall(function()
                                -- upvalues: (ref) v_u_8, (ref) p_u_628, (copy) v_u_640
                                return v_u_8.new(p_u_628.RootAttachment, v_u_640.Attachment, 9)
                            end)
                            if v644 then
                                v645.AnimationSpeed = 6
                                v645.CurveSize0 = 3
                                v645.CurveSize1 = 3
                                v645.Color = v_u_636
                                v645.Thickness = 0.4
                                v645.PulseSpeed = 10
                                v645.PulseLength = 3
                                v645.FadeLength = 0.5
                                v645.MaxRadius = 5
                                v645.ContractFrom = 0.2
                                v645.MinThicknessMultiplier = 0.75
                                v645.MaxThicknessMultiplier = 1.5
                                local v646 = v_u_11.new(v645)
                                v646.MaxSparkCount = 3
                                task.wait(p_u_632)
                                v645:Destroy()
                                v646:Destroy()
                                v_u_640.Attachment.aurazap.Enabled = false
                                v_u_6:Create(v_u_640.zip, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                                    ["Volume"] = 0
                                }):Play()
                            end
                        end
                        v_u_1:AddItem(v_u_640, p_u_632 + 2)
                    end)
                end
            end
        end
    end)
end)
v_u_4.Remotes.QuantumArena.OnClientEvent:Connect(function(p647)
    -- upvalues: (copy) v_u_3, (copy) v_u_36
    local v648 = v_u_3.LocalPlayer.Character
    if v648 and not v648:IsDescendantOf(workspace.Dead) then
        v_u_36(p647)
    end
end)
v_u_4.Remotes.QuantumArenaDash.OnClientEvent:Connect(function(p649, p650, p651)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) v_u_12, (copy) v_u_8, (copy) v_u_11
    local v652 = p649.Character
    if v652 then
        local v653 = v_u_4.Misc.ThunderDash:Clone()
        local v654 = v_u_4.Misc.ThunderDashAddon:Clone()
        v653.Position = p650.Position
        v654.Position = p651.Position
        v653.Parent = workspace.Runtime
        v654.Parent = workspace.Runtime
        v653.sound1:Play()
        v653.sound2:Play()
        v_u_1:AddItem(v653, 3)
        v_u_1:AddItem(v654, 3)
        v653.Attachment.L1.Color = ColorSequence.new(Color3.fromRGB(25, 100, 255))
        v654.Attachment.L1.Color = ColorSequence.new(Color3.fromRGB(25, 100, 255))
        v653.Attachment.L1:Emit(10)
        v654.Attachment.L1:Emit(10)
        v_u_12(v652, {
            ["color"] = Color3.fromRGB(25, 100, 255),
            ["lifetime"] = 1,
            ["animationDelay"] = 0.5
        })
        local v_u_655 = v_u_8.new(v653.Attachment, v654.Attachment, 7)
        v_u_655.AnimationSpeed = 10
        v_u_655.CurveSize0 = 3
        v_u_655.CurveSize1 = 3
        v_u_655.Color = Color3.fromRGB(25, 100, 255)
        v_u_655.Thickness = 1
        v_u_655.PulseSpeed = 10
        v_u_655.PulseLength = 3
        v_u_655.FadeLength = 1
        v_u_655.MaxRadius = 6
        v_u_655.ContractFrom = 0.5
        v_u_655.MinThicknessMultiplier = 0.75
        v_u_655.MaxThicknessMultiplier = 1.5
        local v_u_656 = v_u_11.new(v_u_655)
        v_u_656.MaxSparkCount = 3
        task.delay(2, function()
            -- upvalues: (copy) v_u_656, (copy) v_u_655
            v_u_656:Destroy()
            v_u_655:Destroy()
        end)
        v653.Attachment.L1:Emit(10)
        task.wait(0.15)
        v653.WeldConstraint:Destroy()
        v653.Anchored = true
    end
end)
v_u_4.Remotes.PlrConfidenceTaunted.OnClientEvent:Connect(function(p657)
    -- upvalues: (copy) v_u_4, (copy) v_u_1
    local v_u_658 = p657.Character
    if v_u_658 then
        local v659 = p657.Upgrades["Absolute Confidence"].Value >= 2
        local v660 = v659 and 12 or 7
        local v_u_661 = v_u_4.Misc.ConfidenceEffects[v659 and "ConfidentAuraMax" or "ConfidentAura"]:Clone()
        local v_u_662 = {}
        local v663 = next
        local v664, v665 = v_u_661:GetChildren()
        for _, v666 in v663, v664, v665 do
            if v666:IsA("Sound") then
                v666.Parent = v_u_658.HumanoidRootPart
                v666:Play()
            else
                local v667 = v_u_658:FindFirstChild(v666.Name)
                if v667 then
                    local v668 = next
                    local v669, v670 = v_u_661:GetDescendants()
                    for _, v671 in v668, v669, v670 do
                        if v671.Parent == v666 then
                            v671.Parent = v667
                        end
                        v_u_662[#v_u_662 + 1] = v671
                    end
                else
                    print("No aura part", v666.Name, "found in character")
                end
            end
        end
        local v_u_672 = nil
        local function v_u_674() -- line: 2638
            -- upvalues: (ref) v_u_672, (ref) v_u_674, (ref) v_u_1, (copy) v_u_661, (copy) v_u_662
            if v_u_672 then
                v_u_672:Disconnect()
            end
            v_u_674 = function()

            end
            v_u_1:AddItem(v_u_661, 2)
            for _, v673 in next, v_u_662 do
                v_u_1:AddItem(v673, 2)
                if v673:IsA("ParticleEmitter") or v673:IsA("Light") then
                    v673.Enabled = false
                end
            end
        end
        v_u_672 = v_u_658:GetAttributeChangedSignal("IS_CONFIDENT"):Connect(function()
            -- upvalues: (copy) v_u_658, (ref) v_u_674
            if not v_u_658:GetAttribute("IS_CONFIDENT") then
                v_u_674()
            end
        end)
        task.wait(v660)
        v_u_674()
    end
end)
local v_u_675 = {}
v_u_4.Remotes.PlrHellHooked.OnClientEvent:Connect(function(p_u_676, p_u_677, p678)
    -- upvalues: (copy) v_u_4, (copy) v_u_1, (copy) v_u_6, (copy) v_u_675, (copy) v_u_3
    local v679 = p_u_676.Character
    local v680 = v_u_4.Misc.HellHook[p678 == 2 and "MaxHook" or "Hook"]:Clone()
    v680:PivotTo(v679.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, 1.5707963267948966))
    local v_u_681 = Instance.new("Part")
    v_u_681.Size = Vector3.zero
    v_u_681.CanCollide = false
    v_u_681.Anchored = true
    v_u_681.Transparency = 1
    v_u_681:PivotTo(v680:GetPivot())
    local v682 = v680:FindFirstChildWhichIsA("BasePart")
    v682.Hook:Play()
    local v683 = require(v680.Segment)(v682)
    v683(v_u_681, v679.HumanoidRootPart, nil, CFrame.new(0, 0, 8) * CFrame.Angles(0, 0, 1.5707963267948966))
    local v684 = v682.Size
    v682.Size = v682.Size / 25
    v_u_681.Parent = workspace.Runtime
    v680.Parent = workspace.Runtime
    v_u_1:AddItem(v680, 1.5)
    v_u_6:Create(v682, TweenInfo.new(0.1), {
        ["Size"] = v684
    }):Play()
    local v_u_685 = v_u_681.CFrame
    local v_u_686 = 0.35
    task.spawn(function()
        -- upvalues: (ref) v_u_686, (copy) p_u_677, (copy) v_u_681, (copy) v_u_685
        while v_u_686 > 0 and p_u_677.Parent == workspace.Alive and not p_u_677:GetAttribute("Dead") and workspace:GetAttribute("GameActive") do
            v_u_681.CFrame = p_u_677:GetPivot():Lerp(v_u_685, (v_u_686 / 0.35) ^ 3)
            v_u_686 = v_u_686 - task.wait()
        end
    end)
    local v_u_687 = coroutine.running()
    v_u_675[p_u_676] = v_u_687
    task.delay(3, function()
        -- upvalues: (copy) v_u_687, (ref) v_u_675, (copy) p_u_676
        coroutine.resume(v_u_687)
        v_u_675[p_u_676] = nil
    end)
    if coroutine.yield() then
        if p_u_676 == v_u_3.LocalPlayer then
            local v688 = p_u_676.Character.Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script.Animations.HookSlam)
            v688:Play()
            task.delay(2, v688.Destroy, v688)
        end
        v683(p_u_677.HumanoidRootPart)
        v_u_6:Create(v682, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0.15), {
            ["Size"] = v684 / 25
        }):Play()
        if p_u_677 == v_u_3.LocalPlayer.Character then
            p_u_677.HumanoidRootPart.Anchored = true
            local v689 = p_u_677.HumanoidRootPart.CFrame
            local v690 = 0.15
            while v690 > 0 and p_u_677.Parent == workspace.Alive and not p_u_677:GetAttribute("Dead") do
                local v691 = v679.HumanoidRootPart.CFrame
                local v692 = RaycastParams.new()
                v692.FilterType = Enum.RaycastFilterType.Exclude
                v692.FilterDescendantsInstances = {
                    workspace.Runtime,
                    workspace.Alive,
                    workspace.Dead,
                    workspace.Balls,
                    workspace.TrainingBalls
                }
                local v693 = workspace:Spherecast(v691.Position, 1.5, v691.LookVector * 5, v692) or workspace:Raycast(v691.Position, v691.LookVector * 5, v692)
                local v694 = v691 * CFrame.new(0, 0, -(v693 and v693.Distance - 1 or 5))
                p_u_677.HumanoidRootPart.CFrame = v694:Lerp(v689, v690 / 0.15)
                v690 = v690 - task.wait()
            end
            p_u_677.HumanoidRootPart.Anchored = false
        else
            task.wait(0.15)
        end
        v680:Destroy()
        task.wait(0.6)
        local v695 = v_u_4.Misc.HellHook[p678 == 2 and "MaxSlam" or "Slam"]:Clone()
        v695.CFrame = p_u_677.HumanoidRootPart.CFrame - Vector3.new(0, 4.5, 0)
        v695.Parent = workspace.Runtime
        local v696 = next
        local v697, v698 = v695:GetDescendants()
        for _, v699 in v696, v697, v698 do
            if v699:IsA("Sound") then
                v699:Play()
            elseif v699:IsA("ParticleEmitter") then
                v699:Emit(v699:GetAttribute("EmitCount"))
            end
        end
        v_u_1:AddItem(v695, 4)
    else
        v_u_6:Create(v682, TweenInfo.new(0.1)):Play()
        v_u_1:AddItem(v680, 0.1)
    end
end)
v_u_4.Remotes.PlrHellHookCompleted.OnClientEvent:Connect(function(p700, p701)
    -- upvalues: (copy) v_u_675
    local v702 = v_u_675[p700]
    if v702 then
        coroutine.resume(v702, p701)
        v_u_675[p700] = nil
    end
end)
v_u_4.Remotes.PlrQuasared.OnClientEvent:Connect(function(p703, p_u_704)
    -- upvalues: (copy) v_u_4, (copy) v_u_8, (copy) v_u_11, (copy) v_u_6, (copy) v_u_3, (copy) v_u_1, (copy) v_u_2
    local v705 = p703.Character
    if v705 then
        local v706 = p703.Upgrades.Quasar.Value
        local v_u_707 = v_u_4.Misc.Quasar.Summon:Clone()
        v_u_707:PivotTo(CFrame.lookAt(v705.HumanoidRootPart.Position, p_u_704.HumanoidRootPart.Position) * CFrame.new(0, 0, -5))
        v_u_707.Parent = workspace.Runtime
        v_u_707.Humanoid:LoadAnimation(v_u_707.Charge):Play(0)
        local v_u_708 = 1.5
        (function()
            -- upvalues: (copy) v_u_707, (ref) v_u_8, (ref) v_u_708, (ref) v_u_11
            local v709 = math.random(72, 144)
            while v709 < 360 do
                local v710 = v_u_707:GetPivot()
                local v711 = v710 * CFrame.Angles(6.283185307179586 * math.random(), math.rad(v709), 6.283185307179586 * math.random()) * CFrame.new(0, -3, math.random(-16, -9))
                local v712 = {
                    ["WorldPosition"] = v711.Position,
                    ["WorldAxis"] = v711.RightVector
                }
                local v713 = {
                    ["WorldPosition"] = v710.Position,
                    ["WorldAxis"] = v710.RightVector
                }
                local v_u_714 = v_u_8.new(v712, v713, 9)
                v_u_714.AnimationSpeed = 4
                v_u_714.CurveSize0 = 3
                v_u_714.CurveSize1 = 3
                v_u_714.Color = ColorSequence.new(Color3.new())
                v_u_714.Thickness = 0.25
                v_u_714.PulseSpeed = 8
                v_u_714.PulseLength = v_u_708
                v_u_714.FadeLength = 0.75
                v_u_714.MaxRadius = 3
                v_u_714.ContractFrom = 0.5
                v_u_714.MinThicknessMultiplier = 0.75
                v_u_714.MaxThicknessMultiplier = 2
                local v_u_715 = v_u_11.new(v_u_714)
                v_u_715.MaxSparkCount = 3
                task.delay(3, function()
                    -- upvalues: (copy) v_u_714, (copy) v_u_715
                    v_u_714:Destroy()
                    task.wait(3)
                    v_u_715:Destroy()
                end)
                v709 = v709 + math.random(36, 72)
            end
            local v716 = math.random(0, 36)
            while v716 < 360 do
                local v717 = v_u_707:GetPivot()
                local v718 = v717 * CFrame.Angles(6.283185307179586 * math.random(), math.rad(v716), 6.283185307179586 * math.random()) * CFrame.new(0, -3, math.random(-16, -9))
                local v719 = {
                    ["WorldPosition"] = v718.Position,
                    ["WorldAxis"] = v718.RightVector
                }
                local v720 = {
                    ["WorldPosition"] = v717.Position,
                    ["WorldAxis"] = v717.RightVector
                }
                local v_u_721 = v_u_8.new(v719, v720, 12)
                v_u_721.AnimationSpeed = 4
                v_u_721.CurveSize0 = 3
                v_u_721.CurveSize1 = 3
                v_u_721.Color = ColorSequence.new(Color3.new(0.0509804, 0.603922, 0.839216))
                v_u_721.Thickness = 0.5
                v_u_721.PulseSpeed = 6
                v_u_721.PulseLength = v_u_708
                v_u_721.FadeLength = 0.75
                v_u_721.MaxRadius = 3
                v_u_721.ContractFrom = 0.5
                v_u_721.MinThicknessMultiplier = 0.75
                v_u_721.MaxThicknessMultiplier = 2
                local v_u_722 = v_u_11.new(v_u_721)
                v_u_722.MaxSparkCount = 3
                task.delay(3, function()
                    -- upvalues: (copy) v_u_721, (copy) v_u_722
                    v_u_721:Destroy()
                    task.wait(3)
                    v_u_722:Destroy()
                end)
                v716 = v716 + math.random(36, 72)
            end
        end)()
        task.wait(0.4)
        v_u_708 = 1.5
        (function()
            -- upvalues: (copy) p_u_704, (copy) v_u_707, (ref) v_u_8, (ref) v_u_708, (ref) v_u_11
            for _ = 1, 8 do
                local v723 = CFrame.new
                local v724 = math.random(2, 5)
                local v725 = math.random() - 0.5
                local v726 = v724 * math.sign(v725)
                local v727 = math.random(2, 5)
                local v728 = math.random() - 0.5
                local v729 = v723(v726, v727 * math.sign(v728), 0)
                local v730 = p_u_704.HumanoidRootPart.CFrame * v729
                local v731 = v_u_707:GetPivot() * v729
                local v732 = {
                    ["WorldPosition"] = v731.Position,
                    ["WorldAxis"] = v731.RightVector
                }
                local v733 = {
                    ["WorldPosition"] = v730.Position,
                    ["WorldAxis"] = v730.RightVector
                }
                local v_u_734 = v_u_8.new(v732, v733, 16)
                v_u_734.AnimationSpeed = 4
                v_u_734.CurveSize0 = 3
                v_u_734.CurveSize1 = 3
                v_u_734.Color = ColorSequence.new(Color3.new())
                v_u_734.Thickness = 0.35
                v_u_734.PulseSpeed = 8
                v_u_734.PulseLength = v_u_708
                v_u_734.FadeLength = 0.125
                v_u_734.MaxRadius = 6
                v_u_734.ContractFrom = 0.5
                v_u_734.MinThicknessMultiplier = 0.75
                v_u_734.MaxThicknessMultiplier = 2
                local v_u_735 = v_u_11.new(v_u_734)
                v_u_735.MaxSparkCount = 3
                task.delay(3, function()
                    -- upvalues: (copy) v_u_734, (copy) v_u_735
                    v_u_734:Destroy()
                    task.wait(3)
                    v_u_735:Destroy()
                end)
            end
            for _ = 1, 4 do
                local v736 = CFrame.new
                local v737 = math.random(1, 3)
                local v738 = math.random() - 0.5
                local v739 = v737 * math.sign(v738)
                local v740 = math.random(1, 3)
                local v741 = math.random() - 0.5
                local v742 = v736(v739, v740 * math.sign(v741), 0)
                local v743 = p_u_704.HumanoidRootPart.CFrame * v742
                local v744 = v_u_707:GetPivot() * v742
                local v745 = {
                    ["WorldPosition"] = v744.Position,
                    ["WorldAxis"] = v744.RightVector
                }
                local v746 = {
                    ["WorldPosition"] = v743.Position,
                    ["WorldAxis"] = v743.RightVector
                }
                local v_u_747 = v_u_8.new(v745, v746, 16)
                v_u_747.AnimationSpeed = 4
                v_u_747.CurveSize0 = 3
                v_u_747.CurveSize1 = 3
                v_u_747.Color = ColorSequence.new(Color3.new(0.0509804, 0.603922, 0.839216))
                v_u_747.Thickness = 0.35
                v_u_747.PulseSpeed = 8
                v_u_747.PulseLength = v_u_708
                v_u_747.FadeLength = 0.75
                v_u_747.MaxRadius = 6
                v_u_747.ContractFrom = 0.5
                v_u_747.MinThicknessMultiplier = 0.75
                v_u_747.MaxThicknessMultiplier = 2
                local v_u_748 = v_u_11.new(v_u_747)
                v_u_748.MaxSparkCount = 3
                task.delay(3, function()
                    -- upvalues: (copy) v_u_747, (copy) v_u_748
                    v_u_747:Destroy()
                    task.wait(3)
                    v_u_748:Destroy()
                end)
            end
        end)()
        local v749 = (v_u_707:GetPivot().Position - p_u_704.HumanoidRootPart.Position).Unit
        v_u_6:Create(v_u_707.HumanoidRootPart, TweenInfo.new(0.05), {
            ["CFrame"] = CFrame.lookAt(p_u_704.HumanoidRootPart.Position, p_u_704.HumanoidRootPart.Position + v749)
        }):Play()
        task.wait(0.1)
        v_u_707:Destroy()
        if p_u_704 == v_u_3.LocalPlayer.Character then
            local v750 = Instance.new("Highlight")
            v750.FillColor = Color3.new(0, 0, 1)
            v750.FillTransparency = 0.5
            v750.OutlineColor = Color3.new(0, 0, 1)
            v750.OutlineTransparency = 0
            v750.Parent = p_u_704
            v_u_1:AddItem(v750, 4 + v706)
            local v751 = workspace.CurrentCamera
            local v752 = v751.CFrame
            local v753 = CFrame.Angles
            local v754 = 1.5707963267948966 * math.random(1, 3)
            local v755 = math.random()
            v751.CFrame = v752 * v753(0, v754 * math.sign(v755), 0)
            local v756
            if v_u_2:FindFirstChildWhichIsA("Sky") then
                v756 = nil
            else
                v756 = Instance.new("Sky")
                v756.Parent = v_u_2
            end
            v_u_2.Blindness.Enabled = true
            local v757 = v_u_2:FindFirstChild("Atmosphere") or {
                ["Haze"] = 0,
                ["Color"] = Color3.new(),
                ["Decay"] = 0,
                ["Density"] = 0,
                ["Offset"] = 0
            }
            v757.Parent = nil
            local v758 = v_u_4.Misc.Quasar.Blindness:Clone()
            v758.Parent = v_u_2
            task.wait(4 + v706)
            v_u_2.Blindness.Enabled = false
            v_u_6:Create(v758, TweenInfo.new(0.5), {
                ["Haze"] = v757.Haze,
                ["Color"] = v757.Color,
                ["Decay"] = v757.Color,
                ["Density"] = v757.Density,
                ["Offset"] = v757.Offset
            }):Play()
            task.wait(0.5)
            v758:Destroy()
            if v756 then
                v756:Destroy()
            end
            if not game.Lighting:FindFirstChild("Atmosphere") then
                v757.Parent = game.Lighting
            end
        end
    else
        return
    end
end)
local function bunnyImpact(p759, p760) -- line: 3002
    -- upvalues: (copy) v_u_4, (copy) v_u_1
    if workspace:GetAttribute("OriginalGrav") then
        workspace.Gravity = workspace:GetAttribute("OriginalGrav")
        workspace:SetAttribute("OriginalGrav", nil)
    end
    local v761 = p759:FindFirstChild("HumanoidRootPart")
    local v762 = v_u_4.Misc.BunnyLeap.Smash:Clone()
    v762.Parent = v761
    v762:Play()
    v_u_1:AddItem(v762, 1)
    if not p760 then
        local v763 = RaycastParams.new()
        v763.FilterType = Enum.RaycastFilterType.Exclude
        v763.RespectCanCollide = true
        v763.FilterDescendantsInstances = { workspace.Alive, workspace.Map:FindFirstChild("BallFloor", true) }
        p760 = workspace:Raycast(v761.Position, Vector3.new(0, -25, 0), v763)
        if not p760 then
            local v764 = RaycastParams.new()
            v764.FilterDescendantsInstances = { workspace.Map }
            v764.FilterType = Enum.RaycastFilterType.Include
            p760 = workspace:Raycast(v761.Position, Vector3.new(0, -25, 0), v764)
        end
    end
    if p760 then
        local v765 = v_u_4.Misc.BunnyLeap.Slam:Clone()
        v765.CFrame = CFrame.new(p760.Position + Vector3.new(0, 0.1, 0))
        v765.Parent = workspace.Runtime
        local v766 = next
        local v767, v768 = v765:GetDescendants()
        for _, v769 in v766, v767, v768 do
            if v769:IsA("ParticleEmitter") then
                v769:Emit(v769:GetAttribute("EmitCount"))
            end
        end
        v_u_1:AddItem(v765, 3)
        local v770 = p759:GetPivot()
        local v771 = 0
        while v771 < 360 do
            local v772 = Instance.new("Part")
            v772.CanCollide = false
            v772.Material = p760.Material
            v772.Color = p760.Instance.Color
            local v773 = 1 + math.random() * 4
            v772.Size = Vector3.new(v773, v773, v773)
            v_u_4.Misc.BunnyLeap.Trail.BunnyLeapTrail:Clone().Parent = v772
            local v774 = v770 * CFrame.Angles(0, math.rad(v771), 0) * CFrame.new(0, 0, -1)
            local v775 = math.random() + 1.5
            local v776 = v774 + Vector3.new(0, v775, 0)
            v772.CFrame = CFrame.lookAt(v776.Position, v770.Position)
            local v777 = Instance.new("BodyVelocity")
            v777.MaxForce = Vector3.new(40000, 40000, 40000)
            v777.Velocity = v772.CFrame.LookVector * math.random(-30, -16) * math.random(1, 3)
            v777.Parent = v772
            v_u_1:AddItem(v777, 0.05)
            v772.Parent = workspace
            v_u_1:AddItem(v772, 3)
            v771 = v771 + math.random(30, 50)
        end
    end
end
local v_u_778 = {}
v_u_4.Remotes.PlrBunnyHopped.OnClientEvent:Connect(function(p_u_779)
    -- upvalues: (copy) v_u_3, (copy) v_u_4, (copy) v_u_1, (copy) v_u_778, (copy) v_u_6
    if not workspace:GetAttribute("OriginalGrav") then
        workspace:SetAttribute("OriginalGrav", workspace.Gravity)
        workspace.Gravity = 196.2
    end
    local v_u_780 = p_u_779:FindFirstChild("HumanoidRootPart")
    local v_u_781 = v_u_3.LocalPlayer.Character
    local v_u_782
    if p_u_779 == v_u_781 then
        v_u_781:SetAttribute("CAN_BUNNY_SLAM", true)
        v_u_782 = p_u_779.Humanoid:LoadAnimation(v_u_4.Misc.BunnyLeap.BunnyHop)
        v_u_1:AddItem(v_u_782, 1.5)
    else
        v_u_782 = nil
    end
    local v783 = v_u_780:FindFirstChild("BunnyLeapAura")
    if not v783 then
        v783 = v_u_4.Misc.BunnyLeap.Trail.BunnyLeapAura:Clone()
        v783.Parent = v_u_780
    end
    local v784 = v_u_780:FindFirstChild("BunnyLeapTrail")
    if not v784 then
        v784 = v_u_4.Misc.BunnyLeap.Trail.BunnyLeapTrail:Clone()
        v784.Parent = v_u_780
    end
    v_u_1:AddItem(v783, 2.5)
    v_u_1:AddItem(v784, 2.5)
    v_u_778[p_u_779] = task.spawn(function()
        -- upvalues: (copy) p_u_779, (copy) v_u_781, (ref) v_u_4, (ref) v_u_782, (copy) v_u_780, (ref) v_u_1, (ref) v_u_6, (ref) v_u_778
        for v785 = 1, 4 do
            if p_u_779 == v_u_781 then
                if v785 == 4 then
                    v_u_4.Remotes.PlrBunnyCancelled:FireServer()
                else
                    v_u_782:Stop()
                    v_u_782:Play()
                    local v786 = Instance.new("BodyVelocity")
                    v786.MaxForce = Vector3.new(0, 30000, 0)
                    v786.Velocity = Vector3.new(0, 35, 0)
                    v786.Name = "LITTLE_BUNNY_HOP"
                    v786.Parent = v_u_780
                    v_u_1:AddItem(v786, 0.1)
                end
            end
            if v785 < 4 and v785 > 1 then
                local v787 = v_u_4.Misc.BunnyLeap[("Jump%*"):format(v785 - 1)]:Clone()
                v787.Parent = v_u_780
                v787:Play()
                v_u_1:AddItem(v787, 0.5)
            end
            task.wait(0.35)
            local v788 = v_u_4.Misc.BunnyLeap[("Egg%*"):format((math.random(1, 3)))]:Clone()
            v788.CFrame = p_u_779:GetPivot() - Vector3.new(0, 4.5, 0)
            v788.Parent = workspace.Runtime
            v_u_1:AddItem(v788, 1)
            v_u_6:Create(v788, TweenInfo.new(1), {
                ["CFrame"] = v788.CFrame * CFrame.Angles(5.497787143782138, math.random() * 2 * 3.141592653589793, 1.5707963267948966) - Vector3.new(0, 25, 0),
                ["Transparency"] = 1
            }):Play()
        end
        v_u_778[p_u_779] = nil
    end)
end)
v_u_4.Remotes.PlrBunnyLeaped.OnClientEvent:Connect(function(p789)
    -- upvalues: (copy) v_u_778, (copy) v_u_3, (copy) v_u_4, (copy) v_u_1, (copy) bunnyImpact
    if v_u_778[p789] and coroutine.status(v_u_778[p789]) ~= "dead" then
        coroutine.close(v_u_778[p789])
        v_u_778[p789] = nil
    end
    local v790 = v_u_3.LocalPlayer.Character
    local v791 = p789:FindFirstChild("HumanoidRootPart")
    local v_u_792 = v791:FindFirstChild("BunnyLeapAura")
    if not v_u_792 then
        v_u_792 = v_u_4.Misc.BunnyLeap.Trail.BunnyLeapAura:Clone()
        v_u_792.Parent = v791
    end
    local v_u_793 = v791:FindFirstChild("BunnyLeapTrail")
    if not v_u_793 then
        v_u_793 = v_u_4.Misc.BunnyLeap.Trail.BunnyLeapTrail:Clone()
        v_u_793.Parent = v791
    end
    v_u_1:AddItem(v_u_792, 1.5)
    v_u_1:AddItem(v_u_793, 1.5)
    local v794 = v_u_4.Misc.BunnyLeap.Jump3:Clone()
    v794.Parent = v791
    v794:Play()
    v_u_1:AddItem(v794, 0.5)
    if p789 == v790 then
        local v795 = p789.Humanoid:LoadAnimation(v_u_4.Misc.BunnyLeap.BunnyHop)
        local v796 = p789.Humanoid:LoadAnimation(v_u_4.Misc.BunnyLeap.BunnyFall)
        v795:Play()
        if v791:FindFirstChild("LITTLE_BUNNY_HOP") then
            v791.LITTLE_BUNNY_HOP:Destroy()
        end
        local v797 = Instance.new("BodyVelocity")
        v797.MaxForce = Vector3.new(0, 500000, 0)
        v797.Velocity = Vector3.new(0, 120, 0)
        v797.Parent = v791
        local v798 = 0
        while v798 < 0.5 do
            local v799 = 120 - 240 * v798
            local v800 = math.max(0, v799)
            v797.Velocity = Vector3.new(0, v800, 0)
            v798 = v798 + task.wait()
        end
        v795:Stop()
        v795:Destroy()
        v796:Play()
        v797.Velocity = Vector3.new(0, -500, 0)
        local v801 = RaycastParams.new()
        v801.FilterType = Enum.RaycastFilterType.Exclude
        v801.RespectCanCollide = true
        v801.FilterDescendantsInstances = { workspace.Alive, workspace.Map:FindFirstChild("BallFloor", true) }
        repeat
            task.wait()
            local v802 = workspace:Raycast(v791.Position, Vector3.new(0, -9, 0), v801)
        until v802
        local v803 = workspace.CurrentCamera
        local v804 = v_u_3.LocalPlayer:GetMouse()
        local v805 = v790:GetAttribute("TeamColor")
        local v806 = next
        local v807, v808 = workspace.Alive:GetChildren()
        local v809 = (1 / 0)
        local v810 = nil
        for _, v811 in v806, v807, v808 do
            if v811 ~= v790 then
                if not v805 or v805 ~= v811:GetAttribute("TeamColor") then
                    if not v811:GetAttribute("Dead") then
                        if not v811:GetAttribute("Invisible") then
                            if not v811:GetAttribute("DoNotTarget") then
                                local v812 = v803:WorldToScreenPoint(v811.HumanoidRootPart.Position)
                                local v813 = Vector2.new(v812.X - v804.X, v812.Y - v804.Y).Magnitude
                                if v813 < v809 then
                                    v810 = v811
                                    v809 = v813
                                end
                            end
                        end
                    end
                end
            end
        end
        v796:Stop()
        v796:Destroy()
        v791.AssemblyLinearVelocity = Vector3.zero
        v797:Destroy()
        v_u_4.Remotes.PlrBunnySlammed:FireServer(p789:GetPivot().Position.Y, v810)
        v_u_1:AddItem(v_u_792, 1)
        v_u_1:AddItem(v_u_793, 1)
        task.delay(0.1, function()
            -- upvalues: (ref) v_u_792, (ref) v_u_793
            local v814 = next
            local v815, v816 = v_u_792:GetDescendants()
            for _, v817 in v814, v815, v816 do
                if v817:IsA("ParticleEmitter") or v817:IsA("Trail") then
                    v817.Enabled = false
                end
            end
            local v818 = next
            local v819, v820 = v_u_793:GetDescendants()
            for _, v821 in v818, v819, v820 do
                if v821:IsA("ParticleEmitter") or v821:IsA("Trail") then
                    v821.Enabled = false
                end
            end
        end)
        bunnyImpact(p789, v802)
    end
end)
v_u_4.Remotes.PlrBunnySlammed.OnClientEvent:Connect(function(p822)
    -- upvalues: (copy) v_u_3, (copy) bunnyImpact
    if p822 ~= v_u_3.LocalPlayer.Character then
        bunnyImpact(p822)
        local v823 = p822:FindFirstChild("HumanoidRootPart")
        local v824 = v823:FindFirstChild("BunnyLeapAura")
        local v825 = v823:FindFirstChild("BunnyLeapTrail")
        if v824 then
            v824:Destroy()
        end
        if v825 then
            v825:Destroy()
        end
    end
end)
workspace.Runtime.ChildAdded:Connect(function(p826)
    -- upvalues: (copy) v_u_6
    if p826.Name == "FLING_EGG" then
        local v827 = p826.Size
        p826.Size = p826.Size * 0.1
        v_u_6:Create(p826, TweenInfo.new(0.25), {
            ["Size"] = v827
        }):Play()
        local v828 = p826:WaitForChild("EGGWELD")
        local v829 = v828.Part1
        v828:Destroy()
        while p826:GetAttribute("EGGSISTENT") do
            local v830 = v829.CFrame
            local v831 = CFrame.Angles
            local v832 = os.clock() * 30
            local v833 = 7 * math.sin(v832)
            p826.CFrame = v830 * v831(0, 0, (math.rad(v833)))
            task.wait()
        end
        v_u_6:Create(p826, TweenInfo.new(0.25), {
            ["Size"] = v827 * 1.25,
            ["Transparency"] = 1
        }):Play()
    end
end)
local v_u_834 = require(v_u_4.Shared.SpeedModifiers)
local v_u_835 = require(v_u_4.Shared.JumpModifiers)
v_u_4.Remotes.PlrUsedScopophobia.OnClientEvent:Connect(function(p836)
    -- upvalues: (copy) v_u_3, (copy) v_u_16, (copy) v_u_4, (copy) v_u_5, (copy) v_u_7, (copy) v_u_834, (copy) v_u_835, (copy) v_u_1
    local v837 = p836.Upgrades.Scopophobia.Value
    local v_u_838 = 38 + v837 * 24
    local v_u_839 = 15 + 15 * v837
    local v840 = 6 + v837 * 3
    local v_u_841 = 2.5 - v837 * 1
    local v_u_842 = 0.6 - 0.1 * v837
    local v_u_843 = p836.Character
    local v_u_844 = v_u_3.LocalPlayer.Character
    local v845 = not v_u_16.AreCharactersEnemies(v_u_843, v_u_844)
    local v_u_846 = v_u_4.Misc.Scopophobia[v837 > 0 and "Upgrade" or "Base"]:Clone()
    local v847 = next
    local v848, v849 = v_u_846:GetDescendants()
    for _, v850 in v847, v848, v849 do
        if v850:IsA("ParticleEmitter") then
            v850.Enabled = false
        end
    end
    v_u_846.Parent = workspace.Runtime
    local v_u_851 = nil
    v_u_851 = v_u_5.Heartbeat:Connect(function()
        -- upvalues: (copy) v_u_843, (copy) v_u_846, (ref) v_u_851, (ref) v_u_7
        if v_u_843.Parent ~= workspace.Alive then
            v_u_846:Destroy()
            v_u_851:Disconnect()
        end
        local v852 = v_u_843:GetPivot() * CFrame.new(0, 1.5, 0)
        local _ = v_u_7.CFrame
        v_u_846.CFrame = v852
    end)
    if v_u_843 == v_u_844 or v845 then
        task.wait(v840)
    else
        local v_u_853 = os.clock()
        local v_u_854 = 0
        v_u_834:SetModifierFor(v_u_844, ("Scopophobia_%*"):format(p836.Name), function(p855)
            -- upvalues: (copy) v_u_843, (copy) v_u_844, (copy) v_u_838, (copy) v_u_839, (ref) v_u_853, (ref) v_u_854, (copy) v_u_841, (copy) v_u_842
            local v856 = v_u_843:GetPivot()
            local v857 = v_u_844:GetPivot()
            local v858 = v_u_838
            local v859 = 1 - v_u_839 / 360
            local v860 = v857.Position - v856.Position
            local v861
            if v860.Magnitude <= v858 then
                v861 = v859 < v856.LookVector:Dot(v860.Unit)
            else
                v861 = false
            end
            local v862 = v856.LookVector:Dot(v_u_844.Humanoid.MoveDirection) < 0.000125
            local v863 = os.clock()
            if v861 then
                v863 = v_u_853 or v863
            end
            v_u_853 = v863
            if v861 then
                v_u_854 = v_u_854 + (v856.Position - v857.Position).Magnitude / 40 / v_u_841
            end
            if v861 then
                if v862 or v_u_844.Humanoid.MoveDirection == Vector3.zero then
                    p855 = 0
                else
                    local v864 = v_u_854
                    local v865 = math.min(v864, 1)
                    p855 = p855 * (1 + (v_u_842 - 1) * v865)
                end
            end
            return p855
        end, v_u_834.Priority.DEBUFF)
        v_u_835:SetModifierFor(v_u_844, ("Scopophobia_%*"):format(p836.Name), function(p866)
            -- upvalues: (copy) v_u_843, (copy) v_u_844, (copy) v_u_838, (copy) v_u_839
            local v867 = v_u_843:GetPivot()
            local v868 = v_u_844:GetPivot()
            local v869 = v_u_838
            local v870 = 1 - v_u_839 / 360
            local v871 = v868.Position - v867.Position
            local v872
            if v871.Magnitude <= v869 then
                v872 = v870 < v867.LookVector:Dot(v871.Unit)
            else
                v872 = false
            end
            return v872 and 0 or p866
        end, v_u_835.Priority.DEBUFF)
        while v840 > 0 and v_u_843.Parent == workspace.Alive do
            v_u_834:Update(v_u_844)
            v_u_835:Update(v_u_844)
            v840 = v840 - task.wait()
        end
        v_u_834:RemoveModifierFor(v_u_844, (("Scopophobia_%*"):format(p836.Name)))
        v_u_835:RemoveModifierFor(v_u_844, (("Scopophobia_%*"):format(p836.Name)))
    end
    local v873 = next
    local v874, v875 = v_u_846:GetDescendants()
    for _, v_u_876 in v873, v874, v875 do
        if v_u_876:IsA("ParticleEmitter") then
            v_u_876.Enabled = false
        elseif v_u_876:IsA("Beam") then
            task.spawn(function()
                -- upvalues: (copy) v_u_876
                local v877 = v_u_876.Transparency
                local v878 = 0
                while v878 < 1 do
                    local v879 = {}
                    for v880, v881 in next, v877.Keypoints do
                        local v882 = NumberSequenceKeypoint.new
                        local v883 = v881.Time
                        local v884 = v881.Value
                        v879[v880] = v882(v883, v884 + (1 - v884) * v878)
                    end
                    v_u_876.Transparency = NumberSequence.new(v879)
                    v878 = v878 + task.wait() * 10
                end
                v_u_876:Destroy()
            end)
        end
    end
    v_u_1:AddItem(v_u_846, 2)
    task.delay(2, v_u_851.Disconnect, v_u_851)
end)
local v_u_885 = {}
v10:Connect("TimeHoleActivate", function(p_u_886, p887)
    -- upvalues: (copy) v_u_37, (copy) v_u_885
    local v888 = v_u_37(p_u_886, p887)
    v_u_885[p_u_886] = v888
    v888:Add(function()
        -- upvalues: (ref) v_u_885, (copy) p_u_886
        v_u_885[p_u_886] = nil
    end)
end)
v10:Connect("TimeHoleDeactivate", function(p889)
    -- upvalues: (copy) v_u_885
    local v890 = v_u_885[p889]
    if v890 then
        v890:Destroy()
    end
end)
local v_u_891 = {}
v10:Connect("ChieftainsTotemActivate", function(p_u_892, p893)
    -- upvalues: (copy) v_u_35, (copy) v_u_891
    local v894 = v_u_35(p_u_892, p893)
    v_u_891[p_u_892] = {
        ["Trove"] = v894,
        ["Properties"] = p893
    }
    v894:Add(function()
        -- upvalues: (ref) v_u_891, (copy) p_u_892
        v_u_891[p_u_892] = nil
    end)
end)
v10:Connect("ChieftainsTotemDeactivate", function(p895)
    -- upvalues: (copy) v_u_891
    local v896 = v_u_891[p895]
    if v896 and v896.Trove then
        v896.Trove:Destroy()
    end
end)
local v_u_897 = v_u_4.Assets.Abilities["Chieftain\'s Totem"]
v_u_13.Thread.Every(0.25, function()
    -- upvalues: (copy) v_u_3, (copy) v_u_891, (copy) v_u_897
    for _, v898 in workspace.Alive:GetChildren() do
        if v_u_3:GetPlayerFromCharacter(v898) then
            local v899 = v898:GetPivot().Position
            local v900 = {}
            for v901, v902 in v_u_891 do
                local v903 = v902.Properties
                if v903 and v901.Parent == workspace.Alive and v903.totem and (v901 == v898 or (v899 - v901:GetPivot().Position).Magnitude <= v903.range * 0.5 and not workspace.ShowdownActive.Value) then
                    v900[v901] = v903
                end
            end
            local v904 = v898:FindFirstChild("Chieftain\'s Totems")
            if next(v900) then
                if not v904 then
                    v904 = Instance.new("Folder")
                    v904.Name = "Chieftain\'s Totems"
                    v904.Parent = v898
                end
                for v905, v906 in v900 do
                    local v907 = v904:FindFirstChild(v905.Name)
                    if not v907 then
                        v907 = Instance.new("Folder")
                        v907.Name = v905.Name
                        local v908 = Instance.new("ObjectValue")
                        v908.Name = "Owner"
                        v908.Value = v905
                        v908.Parent = v907
                        v907.Parent = v904
                    end
                    if not v907:FindFirstChild("Beam") then
                        local v909
                        if v906.upgrade == 2 then
                            v909 = v_u_897.Upgraded
                        else
                            v909 = v_u_897.Normal
                        end
                        local v910 = v909.Beam:Clone()
                        v910.Attachment0 = v906.totem:FindFirstChild("RootAttachment", true)
                        v910.Attachment1 = v898:FindFirstChild("RootAttachment", true)
                        v910.Parent = v907
                    end
                    if not v907:FindFirstChild("Torso") then
                        local v911
                        if v906.upgrade == 2 then
                            v911 = v_u_897.Upgraded
                        else
                            v911 = v_u_897.Normal
                        end
                        local v912 = v911.Torso:Clone()
                        v912.Weld.Part1 = v898:FindFirstChild("Torso")
                        v912.Parent = v907
                    end
                end
                for _, v913 in v904:GetChildren() do
                    local v914 = v913:FindFirstChild("Owner")
                    if v914 then
                        v914 = v914.Value
                    end
                    if not v914 or v914.Parent ~= workspace.Alive or not v900[v914] then
                        v913:Destroy()
                    end
                end
            elseif v904 then
                v904:Destroy()
            end
        end
    end
end)
workspace.Dead.ChildAdded:Connect(function(p915)
    local v916 = p915:FindFirstChild("Chieftain\'s Totems")
    if v916 then
        v916:Destroy()
    end
end)
v_u_15.observeTag("EncryptedClone", function(p917)
    -- upvalues: (copy) v_u_3, (copy) v_u_4, (copy) v_u_5
    local v_u_918 = p917:GetAttribute("EncryptedCloneEndTime")
    if p917:GetAttribute("EncryptedCloneOwner") ~= v_u_3.LocalPlayer.Name or not v_u_918 then
        return nil
    end
    local v_u_919 = v_u_4.Assets.TimerBillboard:Clone()
    v_u_919.Adornee = p917:FindFirstChild("Head")
    local v_u_922 = v_u_5.PostSimulation:Connect(function()
        -- upvalues: (copy) v_u_918, (copy) v_u_919
        local v920 = v_u_918 - workspace:GetServerTimeNow()
        local v921 = math.max(v920, 0)
        v_u_919.TextLabel.Text = string.format("%0.1fs", v921)
    end)
    v_u_919.Parent = p917
    return function()
        -- upvalues: (copy) v_u_922, (copy) v_u_919
        v_u_922:Disconnect()
        v_u_919:Destroy()
    end
end)
v_u_15.observeTag("AerodynamicSlashTornado", function(object)
    -- upvalues: (copy) v_u_13, (copy) v_u_5
    
    local ballName = object:GetAttribute("Ball")
    if not workspace.Balls:WaitForChild(ballName, 5) then
        return
    end

    local targetBall
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if ball.Name == ballName and not ball:GetAttribute("realBall") then
            targetBall = ball
            break
        end
    end

    if not targetBall then
        return
    end

    local tornadoTime = (object:GetAttribute("TornadoTime") or 1) + 0.4
    local isFinished = false
    task.delay(tornadoTime, function()
        isFinished = true
    end)

    v_u_13.Visual:PlayEffects(object)

    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true
            task.delay(tornadoTime, function()
                descendant.Enabled = false
            end)
        end
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.RespectCanCollide = true
    raycastParams.FilterDescendantsInstances = { workspace.Alive, workspace.Dead, workspace.Map:FindFirstChild("BallFloor", true) }

    local initialRaycastResult = workspace:Raycast(targetBall.Position, Vector3.new(0, -200, 0), raycastParams)
    local initialPosition = initialRaycastResult and initialRaycastResult.Position or targetBall.Position
    object:PivotTo(CFrame.new(initialPosition) + Vector3.new(0, 0.1, 0))

    local simulationConnection = v_u_5.PostSimulation:Connect(function(deltaTime)
        if not isFinished then
            local currentPivot = object:GetPivot()
            local raycastResult = workspace:Raycast(targetBall.Position, Vector3.new(0, -200, 0), raycastParams)
            local newPosition = raycastResult and raycastResult.Position or targetBall.Position

            object:PivotTo(currentPivot:Lerp(CFrame.new(newPosition) + Vector3.new(0, 0.1, 0), 0.175 * deltaTime * 60))
        end
    end)

    return function()
        simulationConnection:Disconnect()
    end
end, { workspace })

v_u_15.observeTag("BladeTrap", function(p_u_936)
    -- upvalues: (copy) v_u_4, (copy) v_u_18, (copy) v_u_15, (copy) v_u_5
    local v_u_937 = v_u_4.Assets.Abilities["Blade Trap"].Model:Clone()
    v_u_937:PivotTo(p_u_936:GetPivot())
    v_u_937.Parent = p_u_936
    local v_u_938 = v_u_937.Base.Main
    local v939 = v_u_937.Blade
    local v940 = p_u_936:GetAttribute("Range") * 0.5 * 0.5
    local v_u_941 = {
        CFrame.identity,
        CFrame.new(-v940, 3, 0),
        CFrame.new(v940, 3, 0),
        CFrame.new(0, 3, -v940),
        CFrame.new(0, 3, v940),
        CFrame.new(0, 6, 0)
    }
    local v_u_942 = table.create(6)
    for v943 = 1, 6 do
        v_u_942[v943] = v943 == 1 and v939 and v939 or v939:Clone()
        v_u_942[v943].Name = v943
    end
    local v_u_944 = 2
    local v_u_945 = false
    local function updateActive() -- line: 3697
        -- upvalues: (ref) v_u_944, (ref) v_u_945, (ref) v_u_18, (copy) v_u_938, (copy) p_u_936, (copy) v_u_937, (copy) v_u_942
        v_u_944 = v_u_945 and 3 or 2
        local v946 = {
            ["Brightness"] = v_u_945 and 0.1 or 0.05,
            ["Width1"] = v_u_945 and 30 or 7
        }
        v_u_18.fastTween(v_u_938.Beam, TweenInfo.new(0.5), v946)
        local v947 = v_u_18.fastTween
        local v948 = v_u_938.TopLight
        local v949 = TweenInfo.new(0.5)
        local v950 = {}
        local v951
        if v_u_945 then
            v951 = Vector3.yAxis * 6 * 2
        else
            v951 = Vector3.yAxis * 4
        end
        v950.Position = v951
        v947(v948, v949, v950)
        local v_u_952 = p_u_936:GetAttribute("Range")
        local v_u_953 = v_u_952 / 45
        v_u_937.Floor:ScaleTo(v_u_953)
        v_u_18.fastTween(v_u_937.Floor.FloorVFX.Main.Attachment0.Beam, TweenInfo.new(0.5), {
            ["Width0"] = 0.5,
            ["Width1"] = 0.5
        })
        v_u_18.fastTween(v_u_937.Floor.FloorVFX.Main.Attachment0.Beam2, TweenInfo.new(0.5), {
            ["Width0"] = 0.5,
            ["Width1"] = 0.5
        })
        task.defer(function()
            -- upvalues: (copy) v_u_952, (ref) v_u_937, (copy) v_u_953
            local v954 = v_u_952 / 2
            local v955 = v_u_937.Floor.FloorVFX.Main.Attachment0
            local v956 = v954 - 1 * v_u_953 / 2
            v955.Position = Vector3.new(v956, 0, 0)
            local v957 = v_u_937.Floor.FloorVFX.Main.Attachment1
            local v958 = -v954 + 1 * v_u_953 / 2
            v957.Position = Vector3.new(v958, 0, 0)
        end)
        for v959, v960 in v_u_942 do
            if v_u_945 and v959 ~= 1 then
                v960.Main.Weld.C0 = v_u_942[1].Main.Weld.C0
            end
            local v961
            if v_u_945 or v959 == 1 then
                v961 = v_u_937
            else
                v961 = nil
            end
            v960.Parent = v961
        end
    end
    local function setActive(p962) -- line: 3739
        -- upvalues: (ref) v_u_945, (copy) updateActive
        v_u_945 = p962
        updateActive()
    end
    task.spawn(setActive, false)
    local v_u_975 = v_u_15.observeAttribute(p_u_936, "Ready", function(p963)
        -- upvalues: (ref) v_u_18, (copy) v_u_938, (copy) v_u_942, (copy) v_u_937
        local v964
        if p963 then
            v964 = Color3.fromRGB(234, 82, 82)
        else
            v964 = Color3.fromRGB(0, 0, 0)
        end
        v_u_18.fastTween(v_u_938.Parent.Detail, TweenInfo.new(0.5), {
            ["Color"] = v964
        })
        for _, v965 in v_u_942 do
            v_u_18.fastTween(v965.Neon, TweenInfo.new(0.5), {
                ["Color"] = v964
            })
        end
        local v966 = {}
        local v967 = {
            ["Beams"] = { v_u_937.Floor.FloorVFX.Main.Attachment0.Beam, v_u_937.Floor.FloorVFX.Main.Attachment0.Beam2 },
            ["TargetColor"] = v964
        }
        local v968 = {
            ["Beams"] = { v_u_938.Beam }
        }
        local v969
        if p963 then
            v969 = Color3.fromRGB(172, 0, 0)
        else
            v969 = Color3.fromRGB(0, 0, 0)
        end
        v968.TargetColor = v969
        __set_list(v966, 1, {v967, v968})
        for _, v_u_970 in v966 do
            local v_u_971 = Instance.new("Color3Value")
            v_u_971.Value = v_u_970.Beams[1].Color.Keypoints[1].Value
            v_u_971.Changed:Connect(function(p972)
                -- upvalues: (copy) v_u_970
                local v973 = ColorSequence.new(p972)
                for _, v974 in v_u_970.Beams do
                    v974.Color = v973
                end
            end)
            v_u_18.fastTween(v_u_971, TweenInfo.new(0.5), {
                ["Value"] = v_u_970.TargetColor
            }).Destroying:Once(function()
                -- upvalues: (copy) v_u_971
                v_u_971:Destroy()
            end)
        end
        return nil
    end)
    local v_u_977 = v_u_15.observeAttribute(p_u_936, "Active", function(p976)
        -- upvalues: (ref) v_u_945, (copy) updateActive
        v_u_945 = p976 and true or false
        updateActive()
        return nil
    end)
    local v_u_989 = v_u_5.PostSimulation:Connect(function(p978)
        -- upvalues: (copy) v_u_942, (ref) v_u_944, (ref) v_u_945, (copy) v_u_941
        local v979 = 0.1 * p978 * 60
        local v980 = workspace:GetServerTimeNow()
        local v981 = CFrame.new
        local v982 = v980 * 2
        local v983 = v981(0, 2.8 + math.sin(v982) * 0.5, 0)
        for v984, v985 in v_u_942 do
            if v985.Parent then
                local v986 = v980 + v984
                local v987 = v986 % 6.283185307179586 * v_u_944
                local v988 = v983 * CFrame.Angles(0, v_u_945 and v980 % 6.283185307179586 * 2 or 0, 0) * (v_u_945 and v_u_941[v984] or CFrame.identity) * CFrame.Angles(math.cos(v986), v987, -v987 + math.sin(v986))
                v985.Main.Weld.C0 = v985.Main.Weld.C0:Lerp(v988, v979)
            end
        end
    end)
    return function()
        -- upvalues: (copy) v_u_989, (copy) v_u_975, (copy) v_u_977, (copy) v_u_937, (ref) v_u_18, (copy) v_u_938
        v_u_989:Disconnect()
        v_u_975()
        v_u_977()
        for _, v990 in v_u_937:GetDescendants() do
            if v990:IsA("BasePart") then
                v_u_18.fastTween(v990, TweenInfo.new(0.5), {
                    ["Transparency"] = 1
                })
            end
        end
        v_u_18.fastTween(v_u_938.Beam, TweenInfo.new(0.5), {
            ["Width0"] = 0,
            ["Width1"] = 0
        })
        v_u_18.fastTween(v_u_937.Floor.FloorVFX.Main.Attachment0.Beam, TweenInfo.new(0.5), {
            ["Width0"] = 0,
            ["Width1"] = 0
        })
        v_u_18.fastTween(v_u_937.Floor.FloorVFX.Main.Attachment0.Beam2, TweenInfo.new(0.5), {
            ["Width0"] = 0,
            ["Width1"] = 0
        })
        task.delay(0.5, function()
            -- upvalues: (ref) v_u_937
            v_u_937:Destroy()
        end)
    end
end)
v_u_4.Remotes.PlrBountied.OnClientEvent:Connect(function(p991, p992, p993)
    -- upvalues: (copy) v_u_6
    for _, v_u_994 in p992:GetChildren() do
        if v_u_994.Name == "BOUNTY" and v_u_994.Claimer.Text == p991.Name then
            if p993 then
                v_u_994.Icon.Scale.Scale = 3
                v_u_6:Create(v_u_994.Icon.Scale, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                    ["Scale"] = 1
                }):Play()
                task.delay(1, function()
                    -- upvalues: (copy) v_u_994, (ref) v_u_6
                    if v_u_994:IsDescendantOf(workspace) then
                        v_u_994.Icon.ImageColor3 = Color3.new(1, 0, 0)
                        v_u_6:Create(v_u_994.Icon, TweenInfo.new(0.5), {
                            ["ImageColor3"] = Color3.new(1, 1, 1)
                        }):Play()
                    end
                end)
            else
                v_u_994.Icon.ImageColor3 = Color3.new(1, 0, 0)
                v_u_994.Icon.Scale.Scale = 2
                v_u_6:Create(v_u_994.Icon, TweenInfo.new(0.5), {
                    ["ImageColor3"] = Color3.new(1, 1, 1)
                }):Play()
                v_u_6:Create(v_u_994.Icon.Scale, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                    ["Scale"] = 1
                }):Play()
            end
        end
    end
end)
v10:Connect("SlashesOfFuryCatch", function(p995, p_u_996, _)
    -- upvalues: (copy) v_u_8, (copy) v_u_11, (copy) v_u_4, (copy) v_u_13, (copy) v_u_1
    local v_u_997 = p995:FindFirstChild("HumanoidRootPart")
    if v_u_997 then
        local v998 = Color3.fromRGB(255, 0, 0)
        local v999, v1000 = pcall(function()
            -- upvalues: (ref) v_u_8, (copy) v_u_997, (copy) p_u_996
            return v_u_8.new(v_u_997.RootAttachment, p_u_996:FindFirstChildWhichIsA("Attachment"), 9)
        end)
        if v999 then
            v1000.AnimationSpeed = 6
            v1000.CurveSize0 = 3
            v1000.CurveSize1 = 3
            v1000.Color = v998
            v1000.Thickness = 0.4
            v1000.PulseSpeed = 10
            v1000.PulseLength = 3
            v1000.FadeLength = 0.5
            v1000.MaxRadius = 5
            v1000.ContractFrom = 0.2
            v1000.MinThicknessMultiplier = 0.75
            v1000.MaxThicknessMultiplier = 1.5
            local v1001 = v_u_11.new(v1000)
            v1001.MaxSparkCount = 3
            task.wait(0.5)
            local v1002 = v_u_4.Assets.Abilities["Slashes of Fury"].BallEmit:Clone()
            v1002.CFrame = p_u_996.CFrame
            v1002.Parent = workspace.Runtime
            v_u_13.Visual:PlayEffects(v1002)
            v_u_1:AddItem(v1002, 4)
            task.wait(1)
            v1000:Destroy()
            v1001:Destroy()
        end
    end
end)
