local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local EmoteEffects = require(script.EmoteEffects)
local Trove = require(ReplicatedStorage.Packages.Trove)
local DynArgs = require(ReplicatedStorage.Shared.DynArgs)
local ServerInfo = require(ReplicatedStorage.ServerInfo)
local WeightRandom = require(ReplicatedStorage.Shared.WeightRandom)

local ReplicatedStorage0 = require(ReplicatedStorage.Shared.FreezeSwordConstraints)
local ReplicatedStorage1 = Players.LocalPlayer
local ReplicatedStorage2 = RunService:IsStudio()
local ReplicatedStorage3 = {
    "Emote38",
    "Emote145",
    "Emote149",
    "Emote153",
    "Emote220",
    "Emote230",
    "Emote234",
    "Emote243",
    "Emote244",
    "Emote248",
    "Emote252",
    "Emote259",
    "Emote260",
    "Emote261",
    "Emote273",
    "Emote233",
    "Emote279",
    "Emote283",
    "Emote281",
    "Emote286",
    "Emote294",
    "Emote295",
    "Emote306",
    "Emote304",
    "Emote305",
    "Emote303",
    "Emote307",
    "Emote308",
    "Emote311",
    "Emote312",
    "Emote313",
    "Emote322",
    "Emote327",
    "Emote332",
    "Emote336",
    "Emote337",
    "Emote338",
    "Emote326",
    "Emote350",
    "Emote354",
    "Emote349",
    "Emote348",
    "Emote351",
    "Emote352",
    "Emote353",
    "Emote355",
    "Emote358",
    "Emote359",
    "Emote360",
    "Emote367",
    "Emote366",
    "Emote369",
    "Emote370",
    "Emote371",
    "Emote385",
    "Emote417",
    "Emote416",
    "Emote405",
    "Emote400",
    "Emote421",
    "Emote422"
}
local ReplicatedStorage4 = {
    "Emote162",
    "Emote225",
    "Emote261",
    "Emote279",
    "Emote286",
    "Emote284",
    "Emote392",
    "Emote393",
    "Emote394"
}
local ReplicatedStorage5 = {
    "Emote108",
    "Emote225",
    "Emote300",
    "Emote301"
}
local ReplicatedStorage6 = {
    "Emote1",
    "Emote2",
    "Emote3",
    "Emote4",
    "Emote5",
    "Emote6",
    "Emote7"
}
local ReplicatedStorage7 = {
    ["Emote284"] = {
        ["Emote284"] = 30,
        ["Emote298"] = 60,
        ["Emote299"] = 10
    },
    ["Emote301"] = {
        ["Emote300"] = 50,
        ["Emote301"] = 50
    }
}
local ReplicatedStorage8 = DynArgs.Or()
local ReplicatedStorage9 = ReplicatedStorage.Remotes.CustomEmote
return {
    ["_getAnimationTrack"] = function(p20, p_u_21)
        -- upvalues: (copy) ReplicatedStorage, (copy) ReplicatedStorage2, (copy) ServerInfo, (copy) ReplicatedStorage5, (copy) ReplicatedStorage3, (copy) ReplicatedStorage9
        if p20._character and p20._character:IsDescendantOf(workspace) and p20._animator then
            if p20._animationTracks[p_u_21] then
                return p20._animationTracks[p_u_21]
            end
            local v22 = ReplicatedStorage.Misc.Emotes:WaitForChild(p_u_21, 5)
            if v22 then
                local RunService3 = p20._characterTrove:Add(p20._animator:LoadAnimation(v22))
                if not table.find(ReplicatedStorage5, p_u_21) then
                    RunService3.Looped = true
                end
                if table.find(ReplicatedStorage3, p_u_21) then
                    p20._characterTrove:Add(RunService3.DidLoop:Connect(function()
                        -- upvalues: (ref) ReplicatedStorage9, (copy) p_u_21
                        ReplicatedStorage9:FireServer(true, p_u_21)
                    end))
                end
                p20._characterTrove:Add(RunService3.Stopped:Connect(function()
                    -- upvalues: (ref) ReplicatedStorage9, (copy) p_u_21
                    ReplicatedStorage9:FireServer(false, p_u_21)
                end))
                local RunService4 = {}
                p20._characterTrove:Add(RunService3:GetMarkerReachedSignal("Pin"):Connect(function(p25)
                    -- upvalues: (copy) RunService4, (copy) RunService3
                    RunService4[p25] = RunService3.TimePosition
                end))
                p20._characterTrove:Add(RunService3:GetMarkerReachedSignal("GOTO"):Connect(function(p26)
                    -- upvalues: (copy) RunService4, (copy) RunService3
                    local v27 = RunService4[p26]
                    if v27 then
                        RunService3.TimePosition = v27
                    end
                end))
                p20._animationTracks[p_u_21] = RunService3
                return RunService3
            end
            if ReplicatedStorage2 or ServerInfo.isTestGame() then
                warn((("Failed to find Animation for %*"):format(p_u_21)))
            end
        end
    end,
    ["_playAnimation"] = function(p28, p29, p30)
        -- upvalues: (copy) ReplicatedStorage7, (copy) WeightRandom
        if p28._character and p28._character:IsDescendantOf(workspace) and p28._humanoid then
            local Players1 = ReplicatedStorage7[p29]
            if Players1 then
                p29 = WeightRandom.getPicker(Players1)()
            end
            p28._humanoid:ChangeState(Enum.HumanoidStateType.Running)
            local Players2 = p28:_getAnimationTrack(p29)
            if Players2 then
                Players2:Play()
            end
            p28._currentTrack = Players2
            if p30 and Players2 then
                local Players3 = 1
                while Players2.Length == 0 and 0 < Players3 do
                    Players3 = Players3 - task.wait()
                end
            end
        end
    end,
    ["Play"] = function(p34, p35)
        -- upvalues: (copy) ReplicatedStorage8, (copy) ReplicatedStorage6, (copy) ReplicatedStorage4, (copy) ReplicatedStorage9
        if p35 and p34._character and p34._character:IsDescendantOf(workspace) and p34._humanoid then
            if 0 < p34._humanoid.MoveDirection.Magnitude then
                return
            else
                if p34._currentEmote then
                    p34:Stop()
                end
                if p34._character:GetAttribute("Ability") == "Platform" then
                    _G.SendNotification("Cannot use emotes while Platform ability is active!", 3)
                    p34:Stop()
                    return
                elseif ReplicatedStorage8.CurrentState then
                    _G.SendNotification("Emotes are disabled!", 3)
                    return
                else
                    local Players6 = os.clock()
                    if Players6 - p34._lastEmote < 0.4 and not table.find(ReplicatedStorage6, p35) then
                        return
                    else
                        p34._lastEmote = Players6
                        p34._currentEmote = p35
                        p34._character:SetAttribute("Emoting", p35)
                        if p34._character:GetAttribute("PassiveRNGEmote") ~= p35 then
                            p34:_playAnimation(p35, table.find(ReplicatedStorage4, p35) ~= nil)
                        end
                        if table.find(ReplicatedStorage6, p35) then
                            ReplicatedStorage9:FireServer(false, p35)
                        else
                            ReplicatedStorage9:FireServer(true, p35, workspace:GetServerTimeNow())
                        end
                    end
                end
            end
        else
            return
        end
    end,
    ["Stop"] = function(p37)
        -- upvalues: (copy) ReplicatedStorage9
        if p37._character then
            p37._character:SetAttribute("Emoting", nil)
        end
        if p37._currentTrack and p37._currentTrack.IsPlaying then
            p37._currentTrack:Stop()
            p37._currentTrack = nil
        end
        if p37._currentEmote then
            ReplicatedStorage9:FireServer(false, p37._currentEmote)
            p37._currentEmote = nil
        end
    end,
    ["Init"] = function(p_u_38)
        -- upvalues: (copy) Trove, (copy) Net, (copy) EmoteEffects, (copy) ReplicatedStorage8, (copy) ReplicatedStorage
        p_u_38._lastEmote = 0
        p_u_38._characterTrove = Trove.new()
        p_u_38._animationTracks = {}
        Net:Connect("PlayEmoteEffects", function(p_u_39, ...)
            -- upvalues: (ref) EmoteEffects
            if EmoteEffects[p_u_39] then
                local v40, v41 = pcall(function(...)
                    -- upvalues: (ref) EmoteEffects, (copy) p_u_39
                    return EmoteEffects[p_u_39](...)
                end, ...)
                if not v40 then
                    warn(("EmoteEffect failed for %*:"):format(p_u_39), v41)
                end
            else
                warn((("Failed to find EmoteEffect for %*"):format(p_u_39)))
            end
        end)
        ReplicatedStorage8.StateChanged:Connect(function(p42)
            -- upvalues: (copy) p_u_38
            if p42 then
                p_u_38:Stop()
            end
        end)
        ReplicatedStorage.Remotes.DisableEmote.OnClientEvent:Connect(function()
            -- upvalues: (copy) p_u_38
            if p_u_38._currentEmote then
                p_u_38:Stop()
            end
        end)
    end,
    ["Start"] = function(p_u_43)
        -- upvalues: (copy) RunService, (copy) ReplicatedStorage8, (copy) ReplicatedStorage0, (copy) ReplicatedStorage1
        local function v51(p_u_44)
            -- upvalues: (copy) p_u_43, (ref) RunService, (ref) ReplicatedStorage8, (ref) ReplicatedStorage0, (ref) ReplicatedStorage1
            p_u_43._characterTrove:Clean()
            table.clear(p_u_43._animationTracks)
            p_u_43._character = p_u_44
            local Net5 = p_u_44:WaitForChild("Humanoid")
            p_u_43._humanoid = Net5
            p_u_43._animator = Net5:WaitForChild("Animator")
            local Net6 = p_u_44:WaitForChild("Head", 5)
            local Net7 = p_u_44:WaitForChild("Torso", 5)
            local Net8 = p_u_44:WaitForChild("HumanoidRootPart", 5)
            p_u_43._characterTrove:Add(RunService.PreSimulation:Connect(function()
                -- upvalues: (copy) Net7, (copy) Net6, (copy) Net8
                if Net7 then
                    Net7.CanCollide = false
                end
                if Net6 then
                    Net6.CanCollide = false
                end
                if Net8 then
                    Net8.CanCollide = true
                end
            end))
            p_u_43._characterTrove:Add(Net5:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                -- upvalues: (copy) Net5, (ref) p_u_43
                if Net5.MoveDirection ~= Vector3.zero and p_u_43._currentEmote then
                    p_u_43:Stop()
                end
            end))
            p_u_43._characterTrove:Add(p_u_44:GetAttributeChangedSignal("InFinisher"):Connect(function()
                -- upvalues: (ref) ReplicatedStorage8, (copy) p_u_44
                ReplicatedStorage8:SetTag("InFinisher", p_u_44:GetAttribute("InFinisher") ~= nil)
            end))
            p_u_43._characterTrove:Add(p_u_44:GetAttributeChangedSignal("AbilityActive"):Connect(function()
                -- upvalues: (copy) p_u_44, (ref) ReplicatedStorage8, (ref) p_u_43
                if p_u_44:GetAttribute("AbilityActive") then
                    local v49 = p_u_44:GetAttribute("Ability")
                    if v49 == "Platform" or v49 == "Bunny Leap" then
                        ReplicatedStorage8:SetTag("AbilityActive", true)
                        if p_u_43._currentEmote then
                            p_u_43:Stop()
                            return
                        end
                    else
                        ReplicatedStorage8:SetTag("AbilityActive", false)
                    end
                else
                    ReplicatedStorage8:SetTag("AbilityActive", false)
                end
            end))
            local EmoteEffects0 = nil
            p_u_43._characterTrove:Add(p_u_44:GetAttributeChangedSignal("Emoting"):Connect(function()
                -- upvalues: (ref) EmoteEffects0, (copy) p_u_44, (ref) ReplicatedStorage0, (ref) ReplicatedStorage1
                if EmoteEffects0 then
                    EmoteEffects0()
                end
                if p_u_44:GetAttribute("Emoting") ~= nil then
                    EmoteEffects0 = ReplicatedStorage0(ReplicatedStorage1)
                end
            end))
            p_u_43._characterTrove:Add(p_u_44.AncestryChanged:Connect(function()
                -- upvalues: (copy) p_u_44, (ref) p_u_43
                if not p_u_44:IsDescendantOf(workspace) then
                    p_u_43:Stop()
                    p_u_43._character = nil
                end
            end))
        end
        ReplicatedStorage1.CharacterAdded:Connect(v51)
        if ReplicatedStorage1.Character then
            task.spawn(v51, ReplicatedStorage1.Character)
        end
    end
}
