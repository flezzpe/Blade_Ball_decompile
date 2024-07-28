local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Common.BitsUtil)
local v_u_5 = v3.LocalPlayer
local v_u_6 = require(v_u_1.Packages.Replion)
local v_u_7 = require(v_u_1.Controllers.NotificationController)
local v_u_8 = require(v_u_1.Controllers.SettingsController)
local v_u_9 = require(v_u_1.Shared.Inventory).Client
local v_u_10 = require(v_u_1.ServerInfo)
local v_u_11 = require(v_u_1.Shared.Dungeons.DungeonsData)
local v_u_12 = require(v_u_1.Shared.LTM)
local v_u_13 = require(v_u_1.Shared.UseBall2)
local v_u_46 = {
    ["IsAbilitiesBlocked"] = function(_, p14)
        if p14 then
            p14 = p14:GetAttribute("PULSED")
        end
        return p14 ~= nil
    end,
    ["IsBlockedBy"] = function(_, p15, p16)
        if p15 then
            p15 = p15:GetAttribute((("AbilityLock_%*"):format(p16)))
        end
        return p15 == true
    end,
    ["NotifyAbilityBlocked"] = function(_, p17)
        -- upvalues: (copy) v_u_10, (copy) v_u_12, (copy) v_u_7
        if v_u_10.isLTMServer() and v_u_12.getGameMode() == "Flying" then
            return
        elseif v_u_10.isNoAbilityRankedMatchServer() or v_u_10.isDungeonsMatchServer() or v_u_10.isDungeonsLobbyServer() then
            v_u_7.sendNotification("Abilities are disabled in this game mode", p17 or 6)
        else
            v_u_7.sendNotification("Chosen ability is disabled, please choose another", p17 or 6)
        end
    end,
    ["IsAbilityAllowed"] = function(_, p18)
        -- upvalues: (copy) v_u_10, (copy) v_u_12, (copy) v_u_6, (copy) v_u_11
        if v_u_10.isLTMServer() then
            if v_u_12.AllAbilitiesDisabled then
                return false
            else
                return not table.find(v_u_12.getDisabledAbilities(), p18)
            end
        else
            if v_u_10.isDuelMatchServer() then
                local v19 = v_u_6.Client:WaitReplion("DuelMatch")
                local v20
                if v19 then
                    v20 = v19:Get("NoAbilities")
                else
                    v20 = nil
                end
                return v20 == false
            end
            if v_u_10.isNoAbilityRankedMatchServer() then
                return false
            end
            if not v_u_10.isRankedMatchServer() then
                return not (v_u_10.isDungeonsMatchServer() or v_u_10.isDungeonsLobbyServer()) and true or table.find(v_u_11.EnabledAbilities, p18) ~= nil
            end
            local v21 = v_u_6.Client:WaitReplion("AbilityBanVoting"):Get("BannedAbilities") or {}
            return not table.find(v21, p18)
        end
    end,
    ["GetRemainingTrialTime"] = function(_, p22)
        -- upvalues: (copy) v_u_6, (copy) v_u_5
        local v23 = v_u_6.Server:GetReplionFor(v_u_5, "Data")
        if not v23 then
            return 0
        end
        local v24 = v23:Get({ "Trials", "Abilities", p22 })
        if not v24 then
            return 0
        end
        local v25 = v24 - workspace:GetServerTimeNow()
        return math.max(0, v25)
    end,
    ["IsTrialActive"] = function(p26, p27)
        -- upvalues: (copy) v_u_6, (copy) v_u_5
        if v_u_6.Server:GetReplionFor(v_u_5, "Data") then
            return 0 < p26:GetRemainingTrialTime(p27)
        else
            return false
        end
    end,
    ["SetAbility"] = function(p28, p29)
        -- upvalues: (copy) v_u_13, (copy) v_u_10, (copy) v_u_5, (copy) v_u_1
        if p29 and not (v_u_13() or v_u_10.isElementalServer()) then
            local v30 = v_u_5.Character
            if v30 then
                v30 = v_u_5.Character:FindFirstChild("Abilities")
            end
            if v30 then
                local v31 = require(v_u_1.ServerInfo).isTrainingServer()
                if v_u_5.Character and v_u_5.Character:IsDescendantOf(workspace.Alive) and workspace:GetAttribute("CurrentlySelectedMode") ~= "Randomizer" and workspace:GetAttribute("CurrentlySelectedMode") ~= "Rebirth" and not (v31 or p28.AbilitiesRandomizer) then
                    return
                end
                for _, v32 in pairs(v30:GetChildren()) do
                    if v32:IsA("LocalScript") then
                        v32.Enabled = false
                    end
                end
                local v33 = v30:FindFirstChild(p29)
                if v33 then
                    v33.Enabled = true
                    v_u_1.Remotes.kebaind:FireServer()
                    return true
                end
            end
            return false
        end
    end,
    ["IsOwned"] = function(p34, p35)
        -- upvalues: (copy) v_u_6, (copy) v_u_5
        if v_u_6.Server:GetReplionFor(v_u_5, "Data") then
            if p34:IsUnlocked(p35) then
                return not p34:IsTrialActive(p35)
            else
                return false
            end
        else
            return false
        end
    end,
    ["IsUnlocked"] = function(_, p36)
        -- upvalues: (copy) v_u_9
        return 0 < #v_u_9:FindItems("Ability", p36)
    end,
    ["GetEquipped"] = function(_)
        -- upvalues: (copy) v_u_9
        local v37 = v_u_9:GetEquipped("Ability")
        return v37 and v37.Name or "Dash"
    end,
    ["Start"] = function(p_u_38)
        -- upvalues: (copy) v_u_13, (copy) v_u_6, (copy) v_u_4, (copy) v_u_46, (copy) v_u_9, (copy) v_u_5, (copy) v_u_1, (copy) v_u_2, (copy) v_u_8
        if not v_u_13() then
            v_u_6.Client:AwaitReplion("Data", function(p39)
                -- upvalues: (ref) v_u_4, (ref) v_u_46, (copy) p_u_38, (ref) v_u_9
                v_u_4.PlayerMaids.Client.CharacterAdded:Connect(function()
                    -- upvalues: (ref) v_u_4, (ref) v_u_46, (ref) p_u_38
                    v_u_4.PlayerMaids.Client.RespawnAbility = v_u_4.Thread.Every(1, function()
                        -- upvalues: (ref) v_u_46, (ref) p_u_38, (ref) v_u_4
                        if v_u_46:SetAbility(p_u_38:GetEquipped()) then
                            v_u_4.PlayerMaids.Client.RespawnAbility = nil
                        end
                    end)
                end)
                v_u_4.PlayerMaids.Client.AbilitySelected = v_u_9:OnEquip("Ability", function()
                    -- upvalues: (ref) v_u_46, (ref) p_u_38
                    v_u_46:SetAbility(p_u_38:GetEquipped())
                end)
                p_u_38.AbilitiesRandomizer = p39:Get("Settings.Misc.AbilitiesRandomizer.Current")
                v_u_4.PlayerMaids.Client.AbilitiesRandomizer = p39:OnChange("Settings.Misc.AbilitiesRandomizer.Current", function(p40)
                    -- upvalues: (ref) p_u_38
                    p_u_38.AbilitiesRandomizer = p40
                end)
            end)
            local function v_u_43(p41)
                -- upvalues: (ref) v_u_5, (copy) p_u_38
                local v42 = v_u_5.Character
                if v42 then
                    if not (v42:GetAttribute("PULSED") and (v42:GetAttribute("AbilityBlockedByLTM") or v42:GetAttribute("AbilityBlockedByRanked") or v42:GetAttribute("AbilityBlockedByNoAbilityDuel") or v42:GetAttribute("AbilityBlockedByNoAbilityRanked") or v42:GetAttribute("AbilityBlockedByDungeons"))) then
                        return false
                    end
                    p_u_38:NotifyAbilityBlocked(p41)
                    return true
                end
            end
            v_u_1.Remotes.AbilityButtonPress.Event:Connect(v_u_43)
            v_u_1.Remotes.RequestAbilityUse.OnClientEvent:Connect(function()
                -- upvalues: (ref) v_u_1
                v_u_1.Remotes.AbilityButtonPress:Fire()
            end)
            v_u_2.InputBegan:Connect(function(p44, p45)
                -- upvalues: (ref) v_u_8, (copy) v_u_43
                if not p45 then
                    if v_u_8:UseBind(p44, "Ability") then
                        v_u_43()
                    end
                end
            end)
            task.spawn(function()
                -- upvalues: (ref) v_u_5, (copy) v_u_43
                if not v_u_5.Character then
                    v_u_5.CharacterAdded:Wait()
                end
                v_u_43(10)
                for _ = 1, 10 do
                    task.wait(0.1)
                    if v_u_43(10) then
                        break
                    end
                end
            end)
        end
    end
}
return v_u_46

-- // Function Dumper made by King.Kevin
-- // Script Path: ReplicatedStorage.Controllers.AbilityController

--[[
Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0xb05b5e0e515a35bf
        1 [boolean] = true
        2 [table]:
        CFrame [table] table: 0xbc835ffff3a6a35f
            1 [function] = PosInObjBlock
            2 [function] = AxisAngleInterpolate
            3 [function] = NormalOfPart
            4 [function] = CreatePart
            5 [function] = GetInvSizeComponents
            6 [function] = PosInObj
            7 [function] = Motor6D
            8 [function] = GetChildrenInRange
            9 [function] = Weld
            10 [function] = RigToPrimaryPart
            11 [function] = InsidePart
        3 [table]:
        Thread [table] table: 0x6ee28d739c78073f
            1 [function] = LoopFor
            2 [function] = RepeatLoopFor
            3 [function] = Every
            4 [function] = Condition
            5 [function] = SpawnConnectionTimer
            6 [function] = IsSuspendend
            7 [function] = SafeResumeDefer
            8 [function] = SpawnConnection
            9 [function] = Coro
            10 [function] = Run
            11 [function] = Wait
            12 [function] = Loop
            13 [function] = SafeResume
            14 [function] = WaitDelay
            15 [function] = RepeatUntil
            16 [RBXScriptSignal] = Signal Heartbeat
            17 [function] = Delay
            18 [function] = SafeCancel
        4 [Instance] = ServerStorage
        5 [table]:
        Settings [table] table: 0x3312a4f1a3a43eef
            1 [number] = 1720283400
            2 [number] = 604800
            3 [Color3] = 1, 1, 0
            4 [number] = 960
            5 [number] = 1688380605
            6 [number] = 345600
            7 [number] = 84600
            8 [Color3] = 0, 1, 0
            9 [Color3] = 1, 0, 0
            10 [number] = 1860
            11 [number] = 60
            12 [number] = 1697248800
        6 [table]:
        BaseObject [table] table: 0x6902ea5940f8bf1f
            1 [function] = Destroy
            2 [function] = new
            3 [table] (Recursive table detected)
            4 [string] = BaseObject
        7 [table]:
        Statable [table] table: 0xf3f46de69b13a3bf
            1 [function] = getAlarmState
            2 [function] = getReplionStatable
        8 [table]:
        Pcall [table] table: 0xccb73a1c68876a1f
            1 [function] = pcallWithDelayedRetries
        9 [RBXScriptSignal] = Signal RenderStepped
        10 [table]:
        SwordUtil [table] table: 0xe491accdb6c4ec4f
            1 [function] = GetCurrentlyEquippedSwordFromCharacter
            2 [function] = GetSwordList
        11 [table]:
        Network [table] table: 0xeec9a1c0c4596f7f
            1 [function] = Invoke
            2 [function] = ListenTo
            3 [table]:
            Events [table] table: 0xa89431f36b6046cf
            4 [function] = Fire
        12 [table]:
        Tags [table] table: 0x3d8c65c1d344dfcf
            1 [function] = GetAllTagged
            2 [function] = GetTagged
            3 [function] = NewDictOfTagged
            4 [function] = AsyncWaitForTaggedDescendant
            5 [function] = Remove
            6 [function] = Bind
            7 [function] = WaitForTaggedDescendant
            8 [function] = AsyncWaitForTagged
            9 [function] = GetTags
            10 [function] = WaitForTagged
            11 [function] = FindFirstTagged
            12 [function] = ForTagged
            13 [function] = ForEach
            14 [function] = NewArrayOfTagged
            15 [function] = Connect
            16 [function] = GetInstanceRemovedSignal
            17 [function] = WaitForTaggedGUI
            18 [function] = Has
            19 [function] = AsyncWaitForTaggedGUI
            20 [function] = GetInstanceAddedSignal
            21 [function] = Add
        13 [table]:
        VectorViewer [table] table: 0x3d827f5eea4329cf
            1 [function] = View
            2 [function] = Perma
        14 [function] = Create
        15 [table]:
        Job [table] table: 0xf722bb779814188f
            1 [function] = setNewCleaner
            2 [function] = cancel
            3 [function] = run
            4 [function] = addTask
            5 [function] = clone
            6 [table]:
            Break [table] table: 0x84b33c078302a01f
            7 [function] = skip
            8 [table] (Recursive table detected)
            9 [function] = new
        16 [table]:
        FFlag [table] table: 0xad99d15621d5c49f
            1 [function] = timeoutFFlag
        17 [table]:
        Events [table] table: 0xe149963cc698859f
            1 [function] = Fire
            2 [function] = Connect
        18 [boolean] = false
        19 [boolean] = false
        20 [Instance] = Debris
        21 [Instance] = UserInputService
        22 [table]:
        PlayerMaids [table] table: 0x313f8f6b3281312f
            1 [table]:
            PlayerAdded [table] table: 0x4d35567afa7768bf
                1 [function] = Connect
            2 [table]:
            __PlayerAdded [table] table: 0x8ca21f09c76e000f
            3 [table]:
            Client [table] table: 0xd845cfb6b125df6f
                1 [table]:
                _tasks [table] table: 0xba6e37a78e0e46ff
                    1 [RBXScriptConnection] = Connection
                    2 [table]:
                    Character [table] table: 0x7ca175e9e216823f
                        1 [table]:
                        _tasks [table] table: 0xe633edd95af2e98f
                    3 [table]:
                    AbilitySelected [table] table: 0x33c47aa2abf37cff
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0x3157f933a2f2ccef
                            1 [table]:
                            _handlerListHead [table] table: 0xdf9d2d1a0911921f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0xaa3674606ab109df
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table]:
                                    _next [table] table: 0xaada1df09ffb154f
                                        1 [function] = Unknown Name
                                        2 [boolean] = true
                                        3 [table] (Recursive table detected)
                                        4 [table]:
                                        _next [table] table: 0x589a53ebe063a8af
                                            1 [function] = Unknown Name
                                            2 [boolean] = true
                                            3 [table] (Recursive table detected)
                                            4 [table]:
                                            _next [table] table: 0x4f87556f424a3fbf
                                                1 [function] = Unknown Name
                                                2 [boolean] = true
                                                3 [table] (Recursive table detected)
                                                4 [table]:
                                                _next [table] table: 0xb3a09bb178e2781f
                                                    1 [function] = Unknown Name
                                                    2 [boolean] = true
                                                    3 [table] (Recursive table detected)
                                                    4 [table]:
                                                    _next [table] table: 0x563ee2635f3475ff
                                                        1 [function] = Unknown Name
                                                        2 [boolean] = true
                                                        3 [table] (Recursive table detected)
                                                        4 [table]:
                                                        _next [table] table: 0xbe595ea35838bf6f
                                                            1 [function] = Unknown Name
                                                            2 [boolean] = true
                                                            3 [table] (Recursive table detected)
                                                            4 [table]:
                                                            _next [table] table: 0xfcd875aa14e25b4f
                                                                1 [function] = Unknown Name
                                                                2 [boolean] = true
                                                                3 [table] (Recursive table detected)
                                                                4 [table]:
                                                                _next [table] table: 0x0b29b98a0b57dc6f
                                                                    1 [function] = Unknown Name
                                                                    2 [boolean] = true
                                                                    3 [table] (Recursive table detected)
                                                                    4 [table]:
                                                                    _next [table] table: 0xd34c9ab69b8fc69f
                                                                        1 [function] = Unknown Name
                                                                        2 [boolean] = true
                                                                        3 [table] (Recursive table detected)
                                                                        4 [table]:
                                                                        _next [table] table: 0xa9319b79f9bef35f
                                                                            1 [function] = Unknown Name
                                                                            2 [boolean] = true
                                                                            3 [table] (Recursive table detected)
                                                                            4 [table] (Recursive table detected)
                        4 [table]:
                        _next [table] table: 0x43b84c4aafa2418f
                            1 [function] = Unknown Name
                            2 [boolean] = true
                            3 [table] (Recursive table detected)
                            4 [table]:
                            _next [table] table: 0x85617e4c9d9ab47f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [boolean] = false
                    4 [table]:
                    AbilitiesRandomizer [table] table: 0x7786a317de52c0ef
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0xc45c32c75d78291f
                            1 [table]:
                            _handlerListHead [table] table: 0x5f7e7ac4e1ec276f
                                1 [function] = reflect
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0x7c926a61c4c78fff
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table] (Recursive table detected)
                        4 [boolean] = false
                    5 [table]:
                    CharacterAdded [table] table: 0x60720ffa55cefcaf
                        1 [function] = Connect
        23 [table]:
        CameraUtils [table] table: 0x71f0c0386c9e1ecf
            1 [function] = getCubeoidDiameter
            2 [function] = isOnScreen
            3 [function] = getBoundingBoxOf
            4 [function] = GetBoundingBox
            5 [function] = fitSphereToCamera
            6 [function] = fitBoundingBoxToCamera
        24 [table]:
        String [table] table: 0x47284ca81f92486f
            1 [function] = EqualsIgnoreCase
            2 [function] = RemoveExcessWhitespace
            3 [function] = AssertAttributeName
            4 [function] = ToCharArray
            5 [function] = AddSpacesToPascalCase
            6 [function] = ToSnakeCase
            7 [function] = ToCamelCase
            8 [function] = Random
            9 [function] = ToByteArray
            10 [function] = EndsWith
            11 [function] = RemoveWhitespace
            12 [function] = TrimEnd
            13 [function] = Escape
            14 [function] = ToKebabCase
            15 [function] = Trim
            16 [function] = ValidateAttributeName
            17 [function] = GetStringLayoutOrder
            18 [function] = StartsWith
            19 [function] = ToPascalCase
            20 [function] = ByteArrayToString
            21 [function] = Contains
            22 [function] = StringBuilder
            23 [function] = TrimStart
        25 [table]:
        Spring [table] table: 0xefa21321e0a6dbbf
            1 [function] = target
            2 [function] = stop
            3 [function] = completed
        26 [table]:
        Streamer [table] table: 0xf18da6e4b47abb3f
            1 [function] = Sync
            2 [function] = SyncPrimaryPart
        27 [Instance] = PhysicsService
        28 [Instance] = ServerScriptService
        29 [table]:
        Vector [table] table: 0xc1b89cc3a1055a5f
            1 [function] = ShowTrack
            2 [function] = Raycast
            3 [function] = Reach
            4 [function] = Slerp
            5 [function] = Lightning
            6 [function] = GetTrackMagnitude
            7 [function] = FromAxisToPolar
            8 [function] = Raycast2
            9 [function] = Random
            10 [function] = CubicBezierArcLength
            11 [function] = GetVectorFromTrack
            12 [function] = KineticDirectionAccelerationMath
            13 [function] = KineticDirectionMath
            14 [function] = TorqueFromForce
            15 [function] = CubicBezier
            16 [function] = SquareBezier
            17 [function] = Lerp
            18 [function] = ClampMagnitude
            19 [function] = AngleBetweenSigned
            20 [function] = AngleBetween
            21 [function] = FromPolarToAxis
        30 [RBXScriptSignal] = Signal Stepped
        31 [table]:
        Sounds [table] table: 0x7726605d6699153f
            1 [function] = PlayAt
            2 [function] = Play
        32 [table]:
        Maid [table] table: 0xa5700b89af96e78f
            1 [function] = Destroy
            2 [function] = DoCleaning
            3 [function] = GiveTasks
            4 [function] = GivePromise
            5 [string] = Maid
            6 [function] = __newindex
            7 [function] = GiveTask
            8 [function] = __index
            9 [function] = new
        33 [Instance] = Run Service
        34 [table]:
        Table [table] table: 0xbe527bcdb019cdcf
            1 [function] = DecodeJSON
            2 [function] = find
            3 [function] = Assign
            4 [function] = GetChildrenNames
            5 [function] = EncodeJSON
            6 [function] = Print
            7 [function] = TablePick
            8 [function] = IsDictionary
            9 [function] = CopyTable
            10 [function] = GetGictionarySize
            11 [function] = CopyTableShallow
            12 [function] = FindDescendantSubstring
            13 [function] = Emtpy
            14 [function] = FastRemove
            15 [function] = FindSubstring
            16 [function] = Emtpy
            17 [function] = Shuffle
            18 [function] = Reverse
            19 [function] = Sync
            20 [function] = CreateDisappearingTable
            21 [function] = IsEmpty
            22 [function] = Map
            23 [function] = FindChildrenSubstring
            24 [function] = FastRemoveFirstValue
            25 [function] = TablePickAndRemove
            26 [function] = CopyDictionary
            27 [function] = Filter
            28 [function] = PickItemFromList
            29 [function] = DictionaryPickAndRemove
            30 [function] = Reduce
            31 [function] = DictionaryPick
        35 [table]:
        EasingUtil [table] table: 0xd1c51e4dba4b95df
            1 [function] = GetEasingStyles
        36 [table]:
        RewardInfo [table] table: 0x303bb853277a8f8f
            1 [function] = getItemOwnershipState
            2 [function] = playerOwnsItem
            3 [function] = playerOwnsItemFromData
        37 [table]:
        Random [table] table: 0x4fd81d7a6225120f
            1 [function] = NextValueFromDictionary
            2 [function] = NextInteger
            3 [function] = NextNumber
            4 [function] = NextRangeNumber
            5 [function] = NextValueFromTable
        38 [table]:
        Players [table] table: 0x775bb55ff6df368f
            1 [function] = getPlayerUsername
            2 [function] = getPlayerUsernameParsed
        39 [table]:
        Pages [table] table: 0xd40021f70caa49cf
            1 [function] = IterPages
            2 [function] = IterPagesAsync
            3 [function] = AdvanceToNextPageAsync
        40 [Instance] = Nafisiuwu
        41 [table]:
        Debug [table] table: 0xf0885a7a03cc073f
            1 [function] = printcontext
            2 [function] = printTable
            3 [function] = Part
            4 [function] = printl
            5 [function] = Line
            6 [function] = info
            7 [function] = warncontext
            8 [function] = pcall
            9 [function] = Get
        42 [table]:
        Physics [table] table: 0x48f8c629b339e6bf
            1 [function] = cloneAndWeld
            2 [function] = fastWeld
            3 [function] = resizePart
            4 [function] = createMotor
            5 [function] = createOldWeld
        43 [table]:
        Promise [table] table: 0x391a7ec75389c47f
            1 [function] = onUnhandledRejection
            2 [function] = _new
            3 [function] = fromEvent
            4 [function] = _all
            5 [function] = _try
            6 [function] = __tostring
            7 [function] = retryWithDelay
            8 [function] = defer
            9 [function] = race
            10 [function] = retry
            11 [function] = delay
            12 [function] = clock
            13 [function] = promisify
            14 [table]:
            __index [table] table: 0x045f37918ff9186f
                1 [function] = cancel
                2 [function] = finally
                3 [function] = _andThen
                4 [function] = andThenReturn
                5 [function] = finallyReturn
                6 [function] = await
                7 [function] = finallyCall
                8 [function] = expect
                9 [function] = timeout
                10 [function] = _finally
                11 [function] = _consumerCancelled
                12 [function] = _reject
                13 [function] = andThen
                14 [function] = andThenCall
                15 [function] = _unwrap
                16 [function] = expect
                17 [function] = catch
                18 [function] = now
                19 [function] = tap
                20 [function] = _resolve
                21 [function] = getStatus
                22 [function] = _finalize
                23 [function] = awaitStatus
            15 [table]:
            _unhandledRejectionCallbacks [table] table: 0x5215ac62aa10d09f
            16 [function] = is
            17 [function] = each
            18 [function] = try
            19 [RBXScriptSignal] = Signal Heartbeat
            20 [table] (Recursive table detected)
            21 [function] = defer
            22 [function] = allSettled
            23 [function] = any
            24 [function] = new
            25 [function] = reject
            26 [function] = fold
            27 [function] = all
            28 [table]:
            Status [table] table: 0xfaa060a11e4a335f
                1 [string] = Cancelled
                2 [string] = Rejected
                3 [string] = Resolved
                4 [string] = Started
            29 [function] = resolve
            30 [table]:
            Error [table] table: 0x4b40a960f96f599f
                1 [function] = __tostring
                2 [function] = getErrorChain
                3 [function] = extend
                4 [function] = isKind
                5 [function] = is
                6 [table]:
                Kind [table] table: 0x98af38407b3408ff
                    1 [string] = ExecutionError
                    2 [string] = TimedOut
                    3 [string] = AlreadyCancelled
                    4 [string] = NotResolvedInTime
                7 [table] (Recursive table detected)
                8 [function] = new
            31 [function] = some
        44 [table]:
        GuiUtils [table] table: 0x094d6d7ce3143dff
            1 [function] = mirrorActivated
            2 [function] = IsGuiObjectVisible
            3 [function] = getActivatedSignal
        45 [table]:
        Icons [table] table: 0x01ee90a8af87665f
            1 [function] = GetEmoteIcon
            2 [function] = GetSwordIcon
            3 [function] = GetIconFromData
            4 [function] = SetSwordIconAsViewport
            5 [function] = GetFinisherIcon
            6 [function] = GetCharacterIcon
            7 [function] = SetSwordIconAsViewportByName
            8 [function] = FitObjectViewportFrame
            9 [function] = GetAbilityIcon
            10 [function] = GetIcon
            11 [function] = GetExplosionIcon
        46 [table]:
        Visual [table] table: 0xe4bffa53935dfccf
            1 [function] = PlayEffectsAt
            2 [function] = TurnOffVisuals
            3 [function] = PlayEffects
        47 [table]:
        State [table] table: 0x1fa83b4bb7cc094f
            1 [function] = Unknown Name
        48 [table]:
        Easing [table] table: 0xd4811892f926d4cf
            1 [function] = SinEnd
            2 [function] = SinBoth
            3 [function] = SinStart
        49 [table]:
        ValueConvertor [table] table: 0xbb2f69c418e6f3cf
            1 [function] = GetColorSequenceFromPercentage
            2 [function] = FormatTimeWithDays
            3 [function] = AddCommas
            4 [function] = GetColorFromPercentage
            5 [function] = PickFromLootbox
            6 [function] = ShrinkNumber
            7 [function] = GetPlayersDisplayNameFromText
            8 [function] = GetLootboxMaxChance
            9 [function] = GetPlayerName
            10 [function] = FormatTimeWithDaysFull
            11 [function] = GetPlayersFromTuple
            12 [function] = FormatDigit
            13 [function] = FormatOrdinal
            14 [function] = FormatShortTime
            15 [function] = AdjustColor
            16 [function] = FormatTimeHHMMSS
            17 [function] = GetPlayersFromText
            18 [function] = FormatShortTimeFull
            19 [function] = GetPercentageTable
            20 [function] = FormatMarkupColor
            21 [function] = FormatTime
            22 [function] = InvertNumberSequence
            23 [function] = PlayerArrayToString
            24 [function] = GetNumberSequenceFromPercentage
            25 [function] = GetPercentageFromNumbers
            26 [function] = NormalizeRarity
            27 [function] = AddNumberPadding
        50 [Instance] = ContextActionService
        51 [table]:
        Signal [table] table: 0xa897443f79f4cf0f
            1 [function] = DisconnectAll
            2 [function] = Is
            3 [function] = Wrap
            4 [function] = On
            5 [function] = Connect
            6 [function] = Destroy
            7 [function] = Wait
            8 [function] = GetConnections
            9 [function] = Fire
            10 [function] = FireDeferred
            11 [function] = Once
            12 [table] (Recursive table detected)
            13 [function] = new
        52 [RBXScriptSignal] = Signal Heartbeat
        53 [table]:
        StateStack [table] table: 0x5e2a65245010197f
            1 [function] = new
            2 [function] = newState
        54 [table]:
        Binder [table] table: 0x463bbe70b43785ff
            1 [function] = GetClassAddedSignal
            2 [function] = Bind
            3 [function] = ObserveInstance
            4 [function] = isBinder
            5 [table] (Recursive table detected)
            6 [function] = new
            7 [function] = GetAll
            8 [function] = Promise
            9 [function] = GetConstructor
            10 [function] = Destroy
            11 [function] = _add
            12 [function] = UnbindClient
            13 [function] = GetTag
            14 [function] = _remove
            15 [function] = Get
            16 [function] = BindClient
            17 [string] = Binder
            18 [function] = Start
            19 [function] = Unbind
            20 [function] = GetClassRemovingSignal
            21 [function] = GetAllSet
    2 [table]:
    2 [table] table: 0x378b284f96857c4f
        1 [function] = IsOwned
        2 [function] = IsAbilitiesBlocked
        3 [function] = IsBlockedBy
        4 [function] = GetRemainingTrialTime
        5 [function] = SetAbility
        6 [function] = NotifyAbilityBlocked
        7 [function] = IsTrialActive
        8 [function] = IsAbilityAllowed
        9 [function] = Start
        10 [function] = GetEquipped
        11 [boolean] = false
        12 [function] = IsUnlocked
    3 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = PlayerMaids
    2 [string] = Client
    3 [string] = Thread
    4 [string] = Every
    5 [string] = RespawnAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0x787d44c35d0d447f
        1 [function] = UpdateObject
        2 [function] = UpdateAllKeybinds
        3 [function] = UpdateHotbar
        4 [function] = LoadSettings
        5 [function] = UseBind
        6 [function] = CanGetStringForKeyCode
        7 [function] = GetBindButton
        8 [function] = SetType
        9 [function] = IsType
        10 [function] = Init
        11 [function] = Start
        12 [function] = UpdateAllSliders
        13 [function] = UpdateAllMisc
        14 [function] = LoadQuality
        15 [function] = GetBindButtons
        16 [function] = BindConnection
        17 [function] = GetDefault
        18 [function] = CustomGetStringForKeyCode
        19 [function] = GetBinds
    2 [function] = notifyBlockedAbility

Function Constants: Unknown Name
    1 [string] = Ability
    2 [string] = UseBind

====================================================================================================

Function Dump: notifyBlockedAbility

Function Upvalues: notifyBlockedAbility
    1 [Instance] = Nafisiuwu
    2 [table] (Recursive table detected)

Function Constants: notifyBlockedAbility
    1 [string] = Character
    2 [string] = PULSED
    3 [string] = GetAttribute
    4 [string] = AbilityBlockedByLTM
    5 [string] = AbilityBlockedByRanked
    6 [string] = AbilityBlockedByNoAbilityDuel
    7 [string] = AbilityBlockedByNoAbilityRanked
    8 [string] = AbilityBlockedByDungeons
    9 [string] = NotifyAbilityBlocked

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = GetEquipped
    2 [string] = SetAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = AbilitiesRandomizer

====================================================================================================

Function Dump: GetEquipped

Function Upvalues: GetEquipped
    1 [table]:
    1 [table] table: 0x5478070339b0d7bf
        1 [function] = OnItemChange
        2 [function] = StringToItem
        3 [function] = FindItems
        4 [function] = GetLegacyInventoryPath
        5 [function] = GetInventory
        6 [function] = OnEquip
        7 [function] = GetEquipped
        8 [function] = GetEquippedList
        9 [function] = OwnsItem
        10 [function] = ItemToString
        11 [function] = GetInventoryVersion
        12 [function] = OnChange
        13 [function] = OnInventoryChange
        14 [function] = SafeGetLegacyInventoryPath
        15 [function] = Get
        16 [function] = GetItem
        17 [userdata] = Freeze.None

Function Constants: GetEquipped
    1 [string] = Ability
    2 [string] = GetEquipped
    3 [string] = Name
    4 [string] = Dash

====================================================================================================

Function Dump: IsUnlocked

Function Upvalues: IsUnlocked
    1 [table] (Recursive table detected)

Function Constants: IsUnlocked
    1 [string] = Ability
    2 [string] = FindItems

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [Instance] = ReplicatedStorage

Function Constants: Unknown Name
    1 [string] = Remotes
    2 [string] = AbilityButtonPress
    3 [string] = Fire

====================================================================================================

Function Dump: NotifyAbilityBlocked

Function Upvalues: NotifyAbilityBlocked
    1 [table]:
    1 [table] table: 0x7d849d32be69a66f
        1 [function] = isRankedMatchServer
        2 [function] = isIntermediatePlayerLobbyServer
        3 [function] = legacy
        4 [function] = isAFKServer
        5 [function] = isLTMServer
        6 [function] = isTrainingServer
        7 [function] = isTournamentDuoServer
        8 [function] = isClanWarServer
        9 [function] = isDungeonsMatchServer
        10 [function] = isTournamentLobbyServer
        11 [function] = isMobileServer
        12 [function] = isTournamentMatchServer
        13 [function] = isDuelLobbyServer
        14 [function] = isTestGame
        15 [function] = isElementalServer
        16 [function] = GetRankType
        17 [function] = isNewPlayerLobbyServer
        18 [function] = isDungeonsLobbyServer
        19 [function] = isProServer
        20 [function] = isDuelMatchServer
        21 [function] = isVoiceServer
        22 [function] = isNewPlayerLobbyMaxSpeedServer
        23 [function] = isTutorialServer
        24 [function] = isPrivateServer
        25 [function] = isNoAbilityRankedLobbyServer
        26 [function] = isNoAbilityRankedMatchServer
        27 [function] = isBossFightServer
        28 [function] = isRBBattlesServer
        29 [function] = isRankedLobbyServer
        30 [function] = isReservedServer
        31 [function] = isTradingPlazaServer
    2 [table]:
    2 [table] table: 0x81fc3fee5b7d484f
        1 [string] = Water Ticket
        2 [boolean] = true
        3 [function] = getDisplayName
        4 [function] = getTimeLeftDHMS
        5 [string] = WaterTickets
        6 [function] = getTimeLeftSeconds
        7 [table]:
        Pack [table] table: 0x51caa79edc47cfdf
            1 [boolean] = true
            2 [string] = FloodSurvival
            3 [number] = 1865615834
            4 [number] = 1865615828
        8 [boolean] = false
        9 [string] = WaterLastLoginStreak
        10 [string] = WaterLoginStreak
        11 [function] = getGameMode
        12 [function] = IsActive
        13 [function] = getDisabledAbilities
        14 [string] = FloodSurvival
        15 [DateTime] = 1721491200000
        16 [string] = WaterClaimedStreaks
        17 [string] = Flood Survival
    3 [table]:
    3 [table] table: 0x7811abc60bd7a2df
        1 [function] = Start
        2 [function] = sendNotification
        3 [function] = SendNotification

Function Constants: NotifyAbilityBlocked
    1 [string] = isLTMServer
    2 [string] = getGameMode
    3 [string] = Flying
    4 [string] = isNoAbilityRankedMatchServer
    5 [string] = isDungeonsMatchServer
    6 [string] = isDungeonsLobbyServer
    7 [string] = sendNotification
    8 [string] = Abilities are disabled in this game mode
    9 [number] = 6
    10 [string] = Chosen ability is disabled, please choose another

====================================================================================================

Function Dump: SetAbility

Function Upvalues: SetAbility
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [Instance] = Nafisiuwu
    4 [Instance] = ReplicatedStorage

Function Constants: SetAbility
    1 [string] = isElementalServer
    2 [string] = Character
    3 [string] = Abilities
    4 [string] = FindFirstChild
    5 [string] = require
    7 [string] = ServerInfo
    8 [string] = isTrainingServer
    9 [string] = workspace
    11 [string] = Alive
    12 [string] = IsDescendantOf
    13 [string] = CurrentlySelectedMode
    14 [string] = GetAttribute
    15 [string] = Randomizer
    16 [string] = Rebirth
    17 [string] = AbilitiesRandomizer
    18 [string] = pairs
    20 [string] = GetChildren
    21 [string] = LocalScript
    22 [string] = IsA
    23 [string] = Enabled
    24 [string] = Remotes
    25 [string] = kebaind
    26 [string] = FireServer

====================================================================================================

Function Dump: IsAbilityAllowed

Function Upvalues: IsAbilityAllowed
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)
    3 [table]:
    3 [table] table: 0x834849bb998bd22f
        1 [table]:
        Client [table] table: 0xf730f358e19c6d5f
            1 [function] = OnReplionRemovedWithTag
            2 [function] = AwaitReplion
            3 [function] = GetReplion
            4 [function] = OnReplionAddedWithTag
            5 [function] = WaitReplion
            6 [function] = OnReplionAdded
            7 [function] = OnReplionRemoved
        2 [userdata] = Freeze.None
        3 [table]:
        Server [table] table: 0x7765f94c82919b5f
            1 [function] = GetReplionFor
            2 [function] = GetReplion
            3 [function] = OnReplionAdded
            4 [function] = GetReplionsFor
            5 [function] = AwaitReplionFor
            6 [function] = WaitReplionFor
            7 [function] = OnReplionRemoved
            8 [function] = AwaitReplion
            9 [function] = WaitReplion
            10 [function] = new
    4 [table]:
    4 [table] table: 0x3cb474e75fe2d0cf
        1 [table]:
        Products [table] table: 0xb3e2dbfa067596bf
            1 [number] = 1810437954
        2 [function] = GetMobHealth
        3 [number] = 10
        4 [number] = 50
        5 [table]:
        BaseMobXP [table] table: 0x8f01502053bdfe0f
            1 [number] = 5
            2 [number] = 5
            3 [number] = 5
        6 [number] = 300
        7 [function] = GetNumMobSpawns
        8 [table]:
        BaseMobSpawns [table] table: 0xead7e0d1a8ab36bf
            1 [number] = 5
            2 [number] = 6
            3 [number] = 4
        9 [table]:
        Remotes [table] table: 0xf3c9d39aec2dc85f
            1 [Instance] = RE/Dungeons-TogglePlayAgain
            2 [Instance] = RF/Dungeons-BuyShopItem
            3 [Instance] = RE/Dungeons-DifficultyVote
            4 [Instance] = RF/Dungeons-UseSkillPoints
        10 [number] = 15
        11 [table]:
        DungeonRuneDropMultipliers [table] table: 0x44d28330c957c59f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        12 [number] = 2
        13 [function] = GetTotalSkillPoints
        14 [table]:
        Levels [table] table: 0xaac56f8f4a63251f
            1 [function] = GetLevelFromTotalXP
            2 [function] = GetTotalXP
            3 [function] = GetRequiredXPForLevel
            4 [function] = GetTotalXPForLevel
        15 [table]:
        Tokens [table] table: 0x6c0f0bd9d040a59f
            1 [table]:
            DungeonXP [table] table: 0x8bd8bbbfa3af34ff
                1 [string] = rbxassetid://17302672193
                2 [function] = createDungeonXPReward
            2 [table]:
            DungeonRunes [table] table: 0xcfd5bbaed8bacd6f
                1 [string] = rbxassetid://17294426866
                2 [function] = createDungeonRunesReward
        16 [table]:
        EnabledAbilities [table] table: 0xa7f0ab0a1b6f1e0f
            1 [string] = Dash
            2 [string] = Super Jump
            3 [string] = Quad Jump
            4 [string] = Blink
            5 [string] = Titan Blade
            6 [string] = Platform
            7 [string] = Freeze
            8 [string] = Tact
            9 [string] = Rapture
            10 [string] = Telekinesis
            11 [string] = Forcefield
            12 [string] = Raging Deflection
            13 [string] = Absolute Confidence
            14 [string] = Pull
            15 [string] = Thunder Dash
            16 [string] = Shadow Step
            17 [string] = Reaper
            18 [string] = Wind Cloak
            19 [string] = Phase Bypass
            20 [string] = Phantom
        17 [function] = GetSkillValue
        18 [table]:
        DropChanceMultipliers [table] table: 0x16e43243ee696d6f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        19 [function] = GetUsedSkillPoints
        20 [function] = GetPlayerDamage
        21 [function] = GetRuneDropAmount
        22 [function] = GetPlayerHealth
        23 [table]:
        Difficulties [table] table: 0x9abac2f79af8285f
            1 [string] = Easy
            2 [string] = Normal
            3 [string] = Hard
        24 [function] = GetRuneDropChance
        25 [table]:
        Dungeons [table] table: 0x60f922900b0094ff
            1 [table]:
            Frost Area [table] table: 0x426633969a9f2bff
                1 [string] = Dungeon_FrostArea
                2 [number] = 20
                3 [table]:
                BaseMobDamage [table] table: 0x591a2c4340c47b6f
                    1 [number] = 25
                    2 [number] = 35
                    3 [number] = 15
                4 [table]:
                Drops [table] table: 0x919f80618581834f
                    1 [table]:
                    Chance [table] table: 0xd52a2202abdcd1af
                        1 [table]:
                        1 [table] table: 0x8d3c9353cec4c93f
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x49c15ca22e2a208f
                                1 [string] = Warrior's Beckoning
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298914810
                                4 [string] = Warrior's Beckoning Explosion
                        2 [table]:
                        2 [table] table: 0xe9ae14b27310781f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0x65a56ade08073fef
                                1 [string] = Emote291
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299532193
                                4 [string] = Purposeless Floating Emote
                        3 [table]:
                        3 [table] table: 0xddd8fa0ee16de77f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0x3e0a7afe3a5bcecf
                                1 [string] = Tundra's Tooth
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298967885
                                4 [string] = Tundra's Tooth
                    2 [table]:
                    Items [table] table: 0xcded5a22b6f2ec0f
                        1 [number] = 0.5
                        2 [number] = 0.25
                        3 [number] = 0.75
                    3 [table]:
                    Mobs [table] table: 0x51e5e8ee7fb5565f
                        1 [table]:
                        Default [table] table: 0xe1ff689ebcae9d2f
                            1 [NumberRange] = 5 9 
                        2 [table]:
                        Sentinel [table] table: 0x6d861acd859804bf
                            1 [NumberRange] = 7 11 
                    4 [table]:
                    Guaranteed [table] table: 0x6149337194ea1adf
                        1 [NumberRange] = 100 200 
                        2 [NumberRange] = 100 200 
                        3 [NumberRange] = 200 400 
                5 [string] = Frost Area
                6 [table]:
                BaseMobHealth [table] table: 0x89dba5136bef339f
                    1 [number] = 150
                    2 [number] = 250
                    3 [number] = 125
                7 [table]:
                Mobs [table] table: 0x9da0bd6513290a4f
                    1 [table]:
                    1 [table] table: 0xc1b22255060791df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x104bd107257a58af
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x9b39432b9623560f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x76abb23aa53c6d9f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xe48223cd4c16856f
                        1 [table]:
                        MaxBots [table] table: 0x406483eeedf8b44f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x8e5f339d2ce2fcff
                            1 [number] = 90
                            2 [number] = 10
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x160a53ff02d64bdf
                        1 [table]:
                        MaxBots [table] table: 0xde6493dd30bb9a3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x647be20f67ad22af
                            1 [number] = 80
                            2 [number] = 20
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x3b6ec3adf996118f
                        1 [table]:
                        MaxBots [table] table: 0xeb1dfb4b7b4140ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x47477bbcbe6fa91f
                            1 [number] = 70
                            2 [number] = 30
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x6f2a4a1bb45a387f
                        1 [table]:
                        MaxBots [table] table: 0x87bc5865ca05075f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xd3490b74e52cffcf
                            1 [number] = 60
                            2 [number] = 40
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x53a7d8946f1a6e2f
                        1 [string] = rbxassetid://17301468657
                        2 [string] = Frost Dragon
                        3 [table]:
                        MaxBots [table] table: 0x9a04ca3400c7dd0f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xffd10b4429f055bf
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xfdccc572e833a2ff
                    1 [number] = 45
                    2 [number] = 60
                    3 [number] = 30
                10 [number] = 7
                11 [number] = 15
            2 [table]:
            Grass Area [table] table: 0x3f640a437eaeacbf
                1 [string] = Dungeon_GrassArea
                2 [number] = 0
                3 [table]:
                BaseMobDamage [table] table: 0x9cf4de8ecc157c2f
                    1 [number] = 15
                    2 [number] = 25
                    3 [number] = 10
                4 [table]:
                Drops [table] table: 0x5373a933b350440f
                    1 [table]:
                    Chance [table] table: 0x6b7439d5a16f936f
                        1 [table]:
                        1 [table] table: 0xcf6f49864a140aff
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x8a99adf64f3ba24f
                                1 [string] = Serpent's Demise
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298908498
                                4 [string] = Serpent's Demise Explosion
                        2 [table]:
                        2 [table] table: 0x545c15e7ec2179df
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xe222dc1604d830af
                                1 [string] = Emote287
                                2 [string] = Emote
                                3 [string] = rbxassetid://17298997514
                                4 [string] = Selfie Emote
                        3 [table]:
                        3 [table] table: 0x903195c617f2e83f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xc23fedb25aed0f8f
                                1 [string] = Scaled Longsword
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298959253
                                4 [string] = Scaled Longsword
                    2 [table]:
                    Items [table] table: 0x0b11e1728641edcf
                        1 [number] = 0.25
                        2 [number] = 3
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x14a971a2c184971f
                        1 [table]:
                        Default [table] table: 0x6aaa8153d8be5eef
                            1 [NumberRange] = 1 5 
                        2 [table]:
                        Serpent Knight [table] table: 0xe8dc700293abc67f
                            1 [NumberRange] = 3 7 
                    4 [table]:
                    Guaranteed [table] table: 0xe702b822f8795b9f
                        1 [NumberRange] = 50 100 
                        2 [NumberRange] = 50 100 
                        3 [NumberRange] = 100 200 
                5 [string] = Grass Area
                6 [table]:
                BaseMobHealth [table] table: 0x46ef9661a57e355f
                    1 [number] = 125
                    2 [number] = 150
                    3 [number] = 75
                7 [table]:
                Mobs [table] table: 0xd0ebac2f623ecb0f
                    1 [table]:
                    1 [table] table: 0x86d5b4e10ad0d29f
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x4c1f3ef1f7cb1a6f
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0xeed6b68138fd81ff
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x68ada8d34194294f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xd6bb1823be8df0df
                        1 [table]:
                        MaxBots [table] table: 0x5d2ce64184587f3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x3cba5f30f3a347af
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0xe1176e90654eb68f
                        1 [table]:
                        MaxBots [table] table: 0xc2947c77cf04a5ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x1141c760b2650e1f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x8c68e700202e5d7f
                        1 [table]:
                        MaxBots [table] table: 0xf87787a017c3ac5f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6a7e6e50093954cf
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x9a615fb0daee032f
                        1 [table]:
                        MaxBots [table] table: 0x15848f105c9d720f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0x3c5227c3ddf7babf
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x61a9c7e09baa499f
                        1 [string] = rbxassetid://15522190869
                        2 [string] = Serpent
                        3 [table]:
                        MaxBots [table] table: 0x0d3ca780e95918ff
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xd1363ff186b0e16f
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 600
                9 [table]:
                AttackDamage [table] table: 0x7ef914bf4f0323bf
                    1 [number] = 30
                    2 [number] = 45
                    3 [number] = 15
                10 [number] = 7
                11 [number] = 14
            3 [table]:
            Space Area [table] table: 0x91af20f2151a686f
                1 [string] = Dungeon_SpaceArea
                2 [number] = 40
                3 [table]:
                BaseMobDamage [table] table: 0x8c803dd57bfdff6f
                    1 [number] = 35
                    2 [number] = 50
                    3 [number] = 25
                4 [table]:
                Drops [table] table: 0x6059b0821630afff
                    1 [table]:
                    Chance [table] table: 0x8453162259e69edf
                        1 [table]:
                        1 [table] table: 0x3e619d3250fc55af
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x197fd45d9b8d4d3f
                                1 [string] = Ogre's Martyrdom
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298922489
                                4 [string] = Ogre's Martyrdom Explosion
                        2 [table]:
                        2 [table] table: 0x79450c8e86a7a48f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xd568f57f95b9fc1f
                                1 [string] = Emote292
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299539124
                                4 [string] = Pay Attention! Emote
                        3 [table]:
                        3 [table] table: 0xb145f91ecf656b7f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xe090484dea7c42cf
                                1 [string] = Galactic Halberd
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298973230
                                4 [string] = Galactic Halberd
                    2 [table]:
                    Items [table] table: 0x58258df4f9d6600f
                        1 [number] = 0.125
                        2 [number] = 0.25
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x72a6e9bd3112da5f
                        1 [table]:
                        Default [table] table: 0xdc3d19937829112f
                            1 [NumberRange] = 9 13 
                        2 [table]:
                        Tribesman [table] table: 0xba0bc5c320c088bf
                            1 [NumberRange] = 11 15 
                    4 [table]:
                    Guaranteed [table] table: 0xf61a4ed222c9074f
                        1 [NumberRange] = 200 400 
                        2 [NumberRange] = 200 400 
                        3 [NumberRange] = 400 800 
                5 [string] = Space Area
                6 [table]:
                BaseMobHealth [table] table: 0xeadf25e5be93b79f
                    1 [number] = 300
                    2 [number] = 400
                    3 [number] = 200
                7 [table]:
                Mobs [table] table: 0x30fb31b7f5d18e4f
                    1 [table]:
                    1 [table] table: 0x60f82124aa3b15df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0xfece90144f26dcaf
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x1ce74144280cc43f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0xb6901274117b2b8f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xa8c362640661731f
                        1 [table]:
                        MaxBots [table] table: 0xcc38040c5db1e27f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6e2afd5c63483aef
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x8647ed3ddc9bc9cf
                        1 [table]:
                        MaxBots [table] table: 0x1ea01a9f86f6982f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x308d6aace38c515f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x735358cf91d91fbf
                        1 [table]:
                        MaxBots [table] table: 0x0b6828edcf362e9f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0xc70da8fca8c0970f
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0xaf7d3add2a1d466f
                        1 [table]:
                        MaxBots [table] table: 0x74502cbb0469f54f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xeb82ba8b7503bdff
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0xc25dd42afb5f8cdf
                        1 [string] = rbxassetid://17301462757
                        2 [string] = Galaxy Ogre
                        3 [table]:
                        MaxBots [table] table: 0x2248d2457ea25b3f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xb01683153e4963af
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xc2ed858484e626ff
                    1 [number] = 60
                    2 [number] = 75
                    3 [number] = 45
                10 [number] = 7
                11 [number] = 16
        26 [number] = 0.25
        27 [function] = GetMobXP
        28 [function] = GetRemainingSkillPoints
        29 [function] = GetMobDamage
        30 [table]:
        SkillPoints [table] table: 0xf7a56376a39cd28f
            1 [table]:
            AbilityCooldown [table] table: 0x2b16f3066ad8797f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ability Cooldown
            2 [table]:
            PlayerSpeed [table] table: 0x671e63ca4f37b0cf
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Player Speed
            3 [table]:
            Health [table] table: 0x8bb3f367f8f6ea1f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Health
            4 [table]:
            BallDamage [table] table: 0xcfc04056b1e281ef
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ball Damage
        31 [number] = 3
        32 [number] = 3
        33 [table]:
        Modes [table] table: 0x68ae928081918f2f
            1 [string] = Dungeon
            2 [string] = Boss

Function Constants: IsAbilityAllowed
    1 [string] = isLTMServer
    2 [string] = AllAbilitiesDisabled
    3 [string] = table
    4 [string] = find
    6 [string] = getDisabledAbilities
    7 [string] = isDuelMatchServer
    8 [string] = Client
    9 [string] = DuelMatch
    10 [string] = WaitReplion
    11 [string] = NoAbilities
    12 [string] = Get
    13 [string] = isNoAbilityRankedMatchServer
    14 [string] = isRankedMatchServer
    15 [string] = AbilityBanVoting
    16 [string] = BannedAbilities
    17 [string] = isDungeonsMatchServer
    18 [string] = isDungeonsLobbyServer
    19 [string] = EnabledAbilities

====================================================================================================

Function Dump: IsOwned

Function Upvalues: IsOwned
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsOwned
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = IsUnlocked
    5 [string] = IsTrialActive

====================================================================================================

Function Dump: IsTrialActive

Function Upvalues: IsTrialActive
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsTrialActive
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = GetRemainingTrialTime

====================================================================================================

Function Dump: GetRemainingTrialTime

Function Upvalues: GetRemainingTrialTime
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: GetRemainingTrialTime
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = Trials
    5 [string] = Abilities
    6 [string] = Get
    7 [string] = workspace
    9 [string] = GetServerTimeNow
    10 [string] = math
    11 [string] = max

====================================================================================================

Function Dump: Start

Function Upvalues: Start
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [table] (Recursive table detected)
    4 [table] (Recursive table detected)
    5 [table] (Recursive table detected)
    6 [Instance] = Nafisiuwu
    7 [Instance] = ReplicatedStorage
    8 [Instance] = UserInputService
    9 [table] (Recursive table detected)

Function Constants: Start
    1 [string] = Client
    2 [string] = Data
    3 [string] = AwaitReplion
    4 [string] = Remotes
    5 [string] = AbilityButtonPress
    6 [string] = Event
    7 [string] = Connect
    8 [string] = RequestAbilityUse
    9 [string] = OnClientEvent
    11 [string] = InputBegan
    12 [string] = task
    13 [string] = spawn

====================================================================================================

Function Dump: IsBlockedBy

Function Upvalues: IsBlockedBy

Function Constants: IsBlockedBy
    1 [string] = AbilityLock_%*
    2 [string] = format
    3 [string] = GetAttribute

====================================================================================================

Function Dump: IsAbilitiesBlocked

Function Upvalues: IsAbilitiesBlocked

Function Constants: IsAbilitiesBlocked
    1 [string] = PULSED
    2 [string] = GetAttribute

====================================================================================================
]]

-- // Function Dumper made by King.Kevin
-- // Script Path: ReplicatedStorage.Controllers.AbilityController

--[[
Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0xb05b5e0e515a35bf
        1 [boolean] = true
        2 [table]:
        CFrame [table] table: 0xbc835ffff3a6a35f
            1 [function] = PosInObjBlock
            2 [function] = AxisAngleInterpolate
            3 [function] = NormalOfPart
            4 [function] = CreatePart
            5 [function] = GetInvSizeComponents
            6 [function] = PosInObj
            7 [function] = Motor6D
            8 [function] = GetChildrenInRange
            9 [function] = Weld
            10 [function] = RigToPrimaryPart
            11 [function] = InsidePart
        3 [table]:
        Thread [table] table: 0x6ee28d739c78073f
            1 [function] = LoopFor
            2 [function] = RepeatLoopFor
            3 [function] = Every
            4 [function] = Condition
            5 [function] = SpawnConnectionTimer
            6 [function] = IsSuspendend
            7 [function] = SafeResumeDefer
            8 [function] = SpawnConnection
            9 [function] = Coro
            10 [function] = Run
            11 [function] = Wait
            12 [function] = Loop
            13 [function] = SafeResume
            14 [function] = WaitDelay
            15 [function] = RepeatUntil
            16 [RBXScriptSignal] = Signal Heartbeat
            17 [function] = Delay
            18 [function] = SafeCancel
        4 [Instance] = ServerStorage
        5 [table]:
        Settings [table] table: 0x3312a4f1a3a43eef
            1 [number] = 1720283400
            2 [number] = 604800
            3 [Color3] = 1, 1, 0
            4 [number] = 960
            5 [number] = 1688380605
            6 [number] = 345600
            7 [number] = 84600
            8 [Color3] = 0, 1, 0
            9 [Color3] = 1, 0, 0
            10 [number] = 1860
            11 [number] = 60
            12 [number] = 1697248800
        6 [table]:
        BaseObject [table] table: 0x6902ea5940f8bf1f
            1 [function] = Destroy
            2 [function] = new
            3 [table] (Recursive table detected)
            4 [string] = BaseObject
        7 [table]:
        Statable [table] table: 0xf3f46de69b13a3bf
            1 [function] = getAlarmState
            2 [function] = getReplionStatable
        8 [table]:
        Pcall [table] table: 0xccb73a1c68876a1f
            1 [function] = pcallWithDelayedRetries
        9 [RBXScriptSignal] = Signal RenderStepped
        10 [table]:
        SwordUtil [table] table: 0xe491accdb6c4ec4f
            1 [function] = GetCurrentlyEquippedSwordFromCharacter
            2 [function] = GetSwordList
        11 [table]:
        Network [table] table: 0xeec9a1c0c4596f7f
            1 [function] = Invoke
            2 [function] = ListenTo
            3 [table]:
            Events [table] table: 0xa89431f36b6046cf
            4 [function] = Fire
        12 [table]:
        Tags [table] table: 0x3d8c65c1d344dfcf
            1 [function] = GetAllTagged
            2 [function] = GetTagged
            3 [function] = NewDictOfTagged
            4 [function] = AsyncWaitForTaggedDescendant
            5 [function] = Remove
            6 [function] = Bind
            7 [function] = WaitForTaggedDescendant
            8 [function] = AsyncWaitForTagged
            9 [function] = GetTags
            10 [function] = WaitForTagged
            11 [function] = FindFirstTagged
            12 [function] = ForTagged
            13 [function] = ForEach
            14 [function] = NewArrayOfTagged
            15 [function] = Connect
            16 [function] = GetInstanceRemovedSignal
            17 [function] = WaitForTaggedGUI
            18 [function] = Has
            19 [function] = AsyncWaitForTaggedGUI
            20 [function] = GetInstanceAddedSignal
            21 [function] = Add
        13 [table]:
        VectorViewer [table] table: 0x3d827f5eea4329cf
            1 [function] = View
            2 [function] = Perma
        14 [function] = Create
        15 [table]:
        Job [table] table: 0xf722bb779814188f
            1 [function] = setNewCleaner
            2 [function] = cancel
            3 [function] = run
            4 [function] = addTask
            5 [function] = clone
            6 [table]:
            Break [table] table: 0x84b33c078302a01f
            7 [function] = skip
            8 [table] (Recursive table detected)
            9 [function] = new
        16 [table]:
        FFlag [table] table: 0xad99d15621d5c49f
            1 [function] = timeoutFFlag
        17 [table]:
        Events [table] table: 0xe149963cc698859f
            1 [function] = Fire
            2 [function] = Connect
        18 [boolean] = false
        19 [boolean] = false
        20 [Instance] = Debris
        21 [Instance] = UserInputService
        22 [table]:
        PlayerMaids [table] table: 0x313f8f6b3281312f
            1 [table]:
            PlayerAdded [table] table: 0x4d35567afa7768bf
                1 [function] = Connect
            2 [table]:
            __PlayerAdded [table] table: 0x8ca21f09c76e000f
            3 [table]:
            Client [table] table: 0xd845cfb6b125df6f
                1 [table]:
                _tasks [table] table: 0xba6e37a78e0e46ff
                    1 [RBXScriptConnection] = Connection
                    2 [table]:
                    Character [table] table: 0x7ca175e9e216823f
                        1 [table]:
                        _tasks [table] table: 0xe633edd95af2e98f
                    3 [table]:
                    AbilitySelected [table] table: 0x33c47aa2abf37cff
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0x3157f933a2f2ccef
                            1 [table]:
                            _handlerListHead [table] table: 0xdf9d2d1a0911921f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0xaa3674606ab109df
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table]:
                                    _next [table] table: 0xaada1df09ffb154f
                                        1 [function] = Unknown Name
                                        2 [boolean] = true
                                        3 [table] (Recursive table detected)
                                        4 [table]:
                                        _next [table] table: 0x589a53ebe063a8af
                                            1 [function] = Unknown Name
                                            2 [boolean] = true
                                            3 [table] (Recursive table detected)
                                            4 [table]:
                                            _next [table] table: 0x4f87556f424a3fbf
                                                1 [function] = Unknown Name
                                                2 [boolean] = true
                                                3 [table] (Recursive table detected)
                                                4 [table]:
                                                _next [table] table: 0xb3a09bb178e2781f
                                                    1 [function] = Unknown Name
                                                    2 [boolean] = true
                                                    3 [table] (Recursive table detected)
                                                    4 [table]:
                                                    _next [table] table: 0x563ee2635f3475ff
                                                        1 [function] = Unknown Name
                                                        2 [boolean] = true
                                                        3 [table] (Recursive table detected)
                                                        4 [table]:
                                                        _next [table] table: 0xbe595ea35838bf6f
                                                            1 [function] = Unknown Name
                                                            2 [boolean] = true
                                                            3 [table] (Recursive table detected)
                                                            4 [table]:
                                                            _next [table] table: 0xfcd875aa14e25b4f
                                                                1 [function] = Unknown Name
                                                                2 [boolean] = true
                                                                3 [table] (Recursive table detected)
                                                                4 [table]:
                                                                _next [table] table: 0x0b29b98a0b57dc6f
                                                                    1 [function] = Unknown Name
                                                                    2 [boolean] = true
                                                                    3 [table] (Recursive table detected)
                                                                    4 [table]:
                                                                    _next [table] table: 0xd34c9ab69b8fc69f
                                                                        1 [function] = Unknown Name
                                                                        2 [boolean] = true
                                                                        3 [table] (Recursive table detected)
                                                                        4 [table]:
                                                                        _next [table] table: 0xa9319b79f9bef35f
                                                                            1 [function] = Unknown Name
                                                                            2 [boolean] = true
                                                                            3 [table] (Recursive table detected)
                                                                            4 [table] (Recursive table detected)
                        4 [table]:
                        _next [table] table: 0x43b84c4aafa2418f
                            1 [function] = Unknown Name
                            2 [boolean] = true
                            3 [table] (Recursive table detected)
                            4 [table]:
                            _next [table] table: 0x85617e4c9d9ab47f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [boolean] = false
                    4 [table]:
                    AbilitiesRandomizer [table] table: 0x7786a317de52c0ef
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0xc45c32c75d78291f
                            1 [table]:
                            _handlerListHead [table] table: 0x5f7e7ac4e1ec276f
                                1 [function] = reflect
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0x7c926a61c4c78fff
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table] (Recursive table detected)
                        4 [boolean] = false
                    5 [table]:
                    CharacterAdded [table] table: 0x60720ffa55cefcaf
                        1 [function] = Connect
        23 [table]:
        CameraUtils [table] table: 0x71f0c0386c9e1ecf
            1 [function] = getCubeoidDiameter
            2 [function] = isOnScreen
            3 [function] = getBoundingBoxOf
            4 [function] = GetBoundingBox
            5 [function] = fitSphereToCamera
            6 [function] = fitBoundingBoxToCamera
        24 [table]:
        String [table] table: 0x47284ca81f92486f
            1 [function] = EqualsIgnoreCase
            2 [function] = RemoveExcessWhitespace
            3 [function] = AssertAttributeName
            4 [function] = ToCharArray
            5 [function] = AddSpacesToPascalCase
            6 [function] = ToSnakeCase
            7 [function] = ToCamelCase
            8 [function] = Random
            9 [function] = ToByteArray
            10 [function] = EndsWith
            11 [function] = RemoveWhitespace
            12 [function] = TrimEnd
            13 [function] = Escape
            14 [function] = ToKebabCase
            15 [function] = Trim
            16 [function] = ValidateAttributeName
            17 [function] = GetStringLayoutOrder
            18 [function] = StartsWith
            19 [function] = ToPascalCase
            20 [function] = ByteArrayToString
            21 [function] = Contains
            22 [function] = StringBuilder
            23 [function] = TrimStart
        25 [table]:
        Spring [table] table: 0xefa21321e0a6dbbf
            1 [function] = target
            2 [function] = stop
            3 [function] = completed
        26 [table]:
        Streamer [table] table: 0xf18da6e4b47abb3f
            1 [function] = Sync
            2 [function] = SyncPrimaryPart
        27 [Instance] = PhysicsService
        28 [Instance] = ServerScriptService
        29 [table]:
        Vector [table] table: 0xc1b89cc3a1055a5f
            1 [function] = ShowTrack
            2 [function] = Raycast
            3 [function] = Reach
            4 [function] = Slerp
            5 [function] = Lightning
            6 [function] = GetTrackMagnitude
            7 [function] = FromAxisToPolar
            8 [function] = Raycast2
            9 [function] = Random
            10 [function] = CubicBezierArcLength
            11 [function] = GetVectorFromTrack
            12 [function] = KineticDirectionAccelerationMath
            13 [function] = KineticDirectionMath
            14 [function] = TorqueFromForce
            15 [function] = CubicBezier
            16 [function] = SquareBezier
            17 [function] = Lerp
            18 [function] = ClampMagnitude
            19 [function] = AngleBetweenSigned
            20 [function] = AngleBetween
            21 [function] = FromPolarToAxis
        30 [RBXScriptSignal] = Signal Stepped
        31 [table]:
        Sounds [table] table: 0x7726605d6699153f
            1 [function] = PlayAt
            2 [function] = Play
        32 [table]:
        Maid [table] table: 0xa5700b89af96e78f
            1 [function] = Destroy
            2 [function] = DoCleaning
            3 [function] = GiveTasks
            4 [function] = GivePromise
            5 [string] = Maid
            6 [function] = __newindex
            7 [function] = GiveTask
            8 [function] = __index
            9 [function] = new
        33 [Instance] = Run Service
        34 [table]:
        Table [table] table: 0xbe527bcdb019cdcf
            1 [function] = DecodeJSON
            2 [function] = find
            3 [function] = Assign
            4 [function] = GetChildrenNames
            5 [function] = EncodeJSON
            6 [function] = Print
            7 [function] = TablePick
            8 [function] = IsDictionary
            9 [function] = CopyTable
            10 [function] = GetGictionarySize
            11 [function] = CopyTableShallow
            12 [function] = FindDescendantSubstring
            13 [function] = Emtpy
            14 [function] = FastRemove
            15 [function] = FindSubstring
            16 [function] = Emtpy
            17 [function] = Shuffle
            18 [function] = Reverse
            19 [function] = Sync
            20 [function] = CreateDisappearingTable
            21 [function] = IsEmpty
            22 [function] = Map
            23 [function] = FindChildrenSubstring
            24 [function] = FastRemoveFirstValue
            25 [function] = TablePickAndRemove
            26 [function] = CopyDictionary
            27 [function] = Filter
            28 [function] = PickItemFromList
            29 [function] = DictionaryPickAndRemove
            30 [function] = Reduce
            31 [function] = DictionaryPick
        35 [table]:
        EasingUtil [table] table: 0xd1c51e4dba4b95df
            1 [function] = GetEasingStyles
        36 [table]:
        RewardInfo [table] table: 0x303bb853277a8f8f
            1 [function] = getItemOwnershipState
            2 [function] = playerOwnsItem
            3 [function] = playerOwnsItemFromData
        37 [table]:
        Random [table] table: 0x4fd81d7a6225120f
            1 [function] = NextValueFromDictionary
            2 [function] = NextInteger
            3 [function] = NextNumber
            4 [function] = NextRangeNumber
            5 [function] = NextValueFromTable
        38 [table]:
        Players [table] table: 0x775bb55ff6df368f
            1 [function] = getPlayerUsername
            2 [function] = getPlayerUsernameParsed
        39 [table]:
        Pages [table] table: 0xd40021f70caa49cf
            1 [function] = IterPages
            2 [function] = IterPagesAsync
            3 [function] = AdvanceToNextPageAsync
        40 [Instance] = Nafisiuwu
        41 [table]:
        Debug [table] table: 0xf0885a7a03cc073f
            1 [function] = printcontext
            2 [function] = printTable
            3 [function] = Part
            4 [function] = printl
            5 [function] = Line
            6 [function] = info
            7 [function] = warncontext
            8 [function] = pcall
            9 [function] = Get
        42 [table]:
        Physics [table] table: 0x48f8c629b339e6bf
            1 [function] = cloneAndWeld
            2 [function] = fastWeld
            3 [function] = resizePart
            4 [function] = createMotor
            5 [function] = createOldWeld
        43 [table]:
        Promise [table] table: 0x391a7ec75389c47f
            1 [function] = onUnhandledRejection
            2 [function] = _new
            3 [function] = fromEvent
            4 [function] = _all
            5 [function] = _try
            6 [function] = __tostring
            7 [function] = retryWithDelay
            8 [function] = defer
            9 [function] = race
            10 [function] = retry
            11 [function] = delay
            12 [function] = clock
            13 [function] = promisify
            14 [table]:
            __index [table] table: 0x045f37918ff9186f
                1 [function] = cancel
                2 [function] = finally
                3 [function] = _andThen
                4 [function] = andThenReturn
                5 [function] = finallyReturn
                6 [function] = await
                7 [function] = finallyCall
                8 [function] = expect
                9 [function] = timeout
                10 [function] = _finally
                11 [function] = _consumerCancelled
                12 [function] = _reject
                13 [function] = andThen
                14 [function] = andThenCall
                15 [function] = _unwrap
                16 [function] = expect
                17 [function] = catch
                18 [function] = now
                19 [function] = tap
                20 [function] = _resolve
                21 [function] = getStatus
                22 [function] = _finalize
                23 [function] = awaitStatus
            15 [table]:
            _unhandledRejectionCallbacks [table] table: 0x5215ac62aa10d09f
            16 [function] = is
            17 [function] = each
            18 [function] = try
            19 [RBXScriptSignal] = Signal Heartbeat
            20 [table] (Recursive table detected)
            21 [function] = defer
            22 [function] = allSettled
            23 [function] = any
            24 [function] = new
            25 [function] = reject
            26 [function] = fold
            27 [function] = all
            28 [table]:
            Status [table] table: 0xfaa060a11e4a335f
                1 [string] = Cancelled
                2 [string] = Rejected
                3 [string] = Resolved
                4 [string] = Started
            29 [function] = resolve
            30 [table]:
            Error [table] table: 0x4b40a960f96f599f
                1 [function] = __tostring
                2 [function] = getErrorChain
                3 [function] = extend
                4 [function] = isKind
                5 [function] = is
                6 [table]:
                Kind [table] table: 0x98af38407b3408ff
                    1 [string] = ExecutionError
                    2 [string] = TimedOut
                    3 [string] = AlreadyCancelled
                    4 [string] = NotResolvedInTime
                7 [table] (Recursive table detected)
                8 [function] = new
            31 [function] = some
        44 [table]:
        GuiUtils [table] table: 0x094d6d7ce3143dff
            1 [function] = mirrorActivated
            2 [function] = IsGuiObjectVisible
            3 [function] = getActivatedSignal
        45 [table]:
        Icons [table] table: 0x01ee90a8af87665f
            1 [function] = GetEmoteIcon
            2 [function] = GetSwordIcon
            3 [function] = GetIconFromData
            4 [function] = SetSwordIconAsViewport
            5 [function] = GetFinisherIcon
            6 [function] = GetCharacterIcon
            7 [function] = SetSwordIconAsViewportByName
            8 [function] = FitObjectViewportFrame
            9 [function] = GetAbilityIcon
            10 [function] = GetIcon
            11 [function] = GetExplosionIcon
        46 [table]:
        Visual [table] table: 0xe4bffa53935dfccf
            1 [function] = PlayEffectsAt
            2 [function] = TurnOffVisuals
            3 [function] = PlayEffects
        47 [table]:
        State [table] table: 0x1fa83b4bb7cc094f
            1 [function] = Unknown Name
        48 [table]:
        Easing [table] table: 0xd4811892f926d4cf
            1 [function] = SinEnd
            2 [function] = SinBoth
            3 [function] = SinStart
        49 [table]:
        ValueConvertor [table] table: 0xbb2f69c418e6f3cf
            1 [function] = GetColorSequenceFromPercentage
            2 [function] = FormatTimeWithDays
            3 [function] = AddCommas
            4 [function] = GetColorFromPercentage
            5 [function] = PickFromLootbox
            6 [function] = ShrinkNumber
            7 [function] = GetPlayersDisplayNameFromText
            8 [function] = GetLootboxMaxChance
            9 [function] = GetPlayerName
            10 [function] = FormatTimeWithDaysFull
            11 [function] = GetPlayersFromTuple
            12 [function] = FormatDigit
            13 [function] = FormatOrdinal
            14 [function] = FormatShortTime
            15 [function] = AdjustColor
            16 [function] = FormatTimeHHMMSS
            17 [function] = GetPlayersFromText
            18 [function] = FormatShortTimeFull
            19 [function] = GetPercentageTable
            20 [function] = FormatMarkupColor
            21 [function] = FormatTime
            22 [function] = InvertNumberSequence
            23 [function] = PlayerArrayToString
            24 [function] = GetNumberSequenceFromPercentage
            25 [function] = GetPercentageFromNumbers
            26 [function] = NormalizeRarity
            27 [function] = AddNumberPadding
        50 [Instance] = ContextActionService
        51 [table]:
        Signal [table] table: 0xa897443f79f4cf0f
            1 [function] = DisconnectAll
            2 [function] = Is
            3 [function] = Wrap
            4 [function] = On
            5 [function] = Connect
            6 [function] = Destroy
            7 [function] = Wait
            8 [function] = GetConnections
            9 [function] = Fire
            10 [function] = FireDeferred
            11 [function] = Once
            12 [table] (Recursive table detected)
            13 [function] = new
        52 [RBXScriptSignal] = Signal Heartbeat
        53 [table]:
        StateStack [table] table: 0x5e2a65245010197f
            1 [function] = new
            2 [function] = newState
        54 [table]:
        Binder [table] table: 0x463bbe70b43785ff
            1 [function] = GetClassAddedSignal
            2 [function] = Bind
            3 [function] = ObserveInstance
            4 [function] = isBinder
            5 [table] (Recursive table detected)
            6 [function] = new
            7 [function] = GetAll
            8 [function] = Promise
            9 [function] = GetConstructor
            10 [function] = Destroy
            11 [function] = _add
            12 [function] = UnbindClient
            13 [function] = GetTag
            14 [function] = _remove
            15 [function] = Get
            16 [function] = BindClient
            17 [string] = Binder
            18 [function] = Start
            19 [function] = Unbind
            20 [function] = GetClassRemovingSignal
            21 [function] = GetAllSet
    2 [table]:
    2 [table] table: 0x378b284f96857c4f
        1 [function] = IsOwned
        2 [function] = IsAbilitiesBlocked
        3 [function] = IsBlockedBy
        4 [function] = GetRemainingTrialTime
        5 [function] = SetAbility
        6 [function] = NotifyAbilityBlocked
        7 [function] = IsTrialActive
        8 [function] = IsAbilityAllowed
        9 [function] = Start
        10 [function] = GetEquipped
        11 [boolean] = false
        12 [function] = IsUnlocked
    3 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = PlayerMaids
    2 [string] = Client
    3 [string] = Thread
    4 [string] = Every
    5 [string] = RespawnAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0x787d44c35d0d447f
        1 [function] = UpdateObject
        2 [function] = UpdateAllKeybinds
        3 [function] = UpdateHotbar
        4 [function] = LoadSettings
        5 [function] = UseBind
        6 [function] = CanGetStringForKeyCode
        7 [function] = GetBindButton
        8 [function] = SetType
        9 [function] = IsType
        10 [function] = Init
        11 [function] = Start
        12 [function] = UpdateAllSliders
        13 [function] = UpdateAllMisc
        14 [function] = LoadQuality
        15 [function] = GetBindButtons
        16 [function] = BindConnection
        17 [function] = GetDefault
        18 [function] = CustomGetStringForKeyCode
        19 [function] = GetBinds
    2 [function] = notifyBlockedAbility

Function Constants: Unknown Name
    1 [string] = Ability
    2 [string] = UseBind

====================================================================================================

Function Dump: notifyBlockedAbility

Function Upvalues: notifyBlockedAbility
    1 [Instance] = Nafisiuwu
    2 [table] (Recursive table detected)

Function Constants: notifyBlockedAbility
    1 [string] = Character
    2 [string] = PULSED
    3 [string] = GetAttribute
    4 [string] = AbilityBlockedByLTM
    5 [string] = AbilityBlockedByRanked
    6 [string] = AbilityBlockedByNoAbilityDuel
    7 [string] = AbilityBlockedByNoAbilityRanked
    8 [string] = AbilityBlockedByDungeons
    9 [string] = NotifyAbilityBlocked

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = GetEquipped
    2 [string] = SetAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = AbilitiesRandomizer

====================================================================================================

Function Dump: GetEquipped

Function Upvalues: GetEquipped
    1 [table]:
    1 [table] table: 0x5478070339b0d7bf
        1 [function] = OnItemChange
        2 [function] = StringToItem
        3 [function] = FindItems
        4 [function] = GetLegacyInventoryPath
        5 [function] = GetInventory
        6 [function] = OnEquip
        7 [function] = GetEquipped
        8 [function] = GetEquippedList
        9 [function] = OwnsItem
        10 [function] = ItemToString
        11 [function] = GetInventoryVersion
        12 [function] = OnChange
        13 [function] = OnInventoryChange
        14 [function] = SafeGetLegacyInventoryPath
        15 [function] = Get
        16 [function] = GetItem
        17 [userdata] = Freeze.None

Function Constants: GetEquipped
    1 [string] = Ability
    2 [string] = GetEquipped
    3 [string] = Name
    4 [string] = Dash

====================================================================================================

Function Dump: IsUnlocked

Function Upvalues: IsUnlocked
    1 [table] (Recursive table detected)

Function Constants: IsUnlocked
    1 [string] = Ability
    2 [string] = FindItems

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [Instance] = ReplicatedStorage

Function Constants: Unknown Name
    1 [string] = Remotes
    2 [string] = AbilityButtonPress
    3 [string] = Fire

====================================================================================================

Function Dump: NotifyAbilityBlocked

Function Upvalues: NotifyAbilityBlocked
    1 [table]:
    1 [table] table: 0x7d849d32be69a66f
        1 [function] = isRankedMatchServer
        2 [function] = isIntermediatePlayerLobbyServer
        3 [function] = legacy
        4 [function] = isAFKServer
        5 [function] = isLTMServer
        6 [function] = isTrainingServer
        7 [function] = isTournamentDuoServer
        8 [function] = isClanWarServer
        9 [function] = isDungeonsMatchServer
        10 [function] = isTournamentLobbyServer
        11 [function] = isMobileServer
        12 [function] = isTournamentMatchServer
        13 [function] = isDuelLobbyServer
        14 [function] = isTestGame
        15 [function] = isElementalServer
        16 [function] = GetRankType
        17 [function] = isNewPlayerLobbyServer
        18 [function] = isDungeonsLobbyServer
        19 [function] = isProServer
        20 [function] = isDuelMatchServer
        21 [function] = isVoiceServer
        22 [function] = isNewPlayerLobbyMaxSpeedServer
        23 [function] = isTutorialServer
        24 [function] = isPrivateServer
        25 [function] = isNoAbilityRankedLobbyServer
        26 [function] = isNoAbilityRankedMatchServer
        27 [function] = isBossFightServer
        28 [function] = isRBBattlesServer
        29 [function] = isRankedLobbyServer
        30 [function] = isReservedServer
        31 [function] = isTradingPlazaServer
    2 [table]:
    2 [table] table: 0x81fc3fee5b7d484f
        1 [string] = Water Ticket
        2 [boolean] = true
        3 [function] = getDisplayName
        4 [function] = getTimeLeftDHMS
        5 [string] = WaterTickets
        6 [function] = getTimeLeftSeconds
        7 [table]:
        Pack [table] table: 0x51caa79edc47cfdf
            1 [boolean] = true
            2 [string] = FloodSurvival
            3 [number] = 1865615834
            4 [number] = 1865615828
        8 [boolean] = false
        9 [string] = WaterLastLoginStreak
        10 [string] = WaterLoginStreak
        11 [function] = getGameMode
        12 [function] = IsActive
        13 [function] = getDisabledAbilities
        14 [string] = FloodSurvival
        15 [DateTime] = 1721491200000
        16 [string] = WaterClaimedStreaks
        17 [string] = Flood Survival
    3 [table]:
    3 [table] table: 0x7811abc60bd7a2df
        1 [function] = Start
        2 [function] = sendNotification
        3 [function] = SendNotification

Function Constants: NotifyAbilityBlocked
    1 [string] = isLTMServer
    2 [string] = getGameMode
    3 [string] = Flying
    4 [string] = isNoAbilityRankedMatchServer
    5 [string] = isDungeonsMatchServer
    6 [string] = isDungeonsLobbyServer
    7 [string] = sendNotification
    8 [string] = Abilities are disabled in this game mode
    9 [number] = 6
    10 [string] = Chosen ability is disabled, please choose another

====================================================================================================

Function Dump: SetAbility

Function Upvalues: SetAbility
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [Instance] = Nafisiuwu
    4 [Instance] = ReplicatedStorage

Function Constants: SetAbility
    1 [string] = isElementalServer
    2 [string] = Character
    3 [string] = Abilities
    4 [string] = FindFirstChild
    5 [string] = require
    7 [string] = ServerInfo
    8 [string] = isTrainingServer
    9 [string] = workspace
    11 [string] = Alive
    12 [string] = IsDescendantOf
    13 [string] = CurrentlySelectedMode
    14 [string] = GetAttribute
    15 [string] = Randomizer
    16 [string] = Rebirth
    17 [string] = AbilitiesRandomizer
    18 [string] = pairs
    20 [string] = GetChildren
    21 [string] = LocalScript
    22 [string] = IsA
    23 [string] = Enabled
    24 [string] = Remotes
    25 [string] = kebaind
    26 [string] = FireServer

====================================================================================================

Function Dump: IsAbilityAllowed

Function Upvalues: IsAbilityAllowed
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)
    3 [table]:
    3 [table] table: 0x834849bb998bd22f
        1 [table]:
        Client [table] table: 0xf730f358e19c6d5f
            1 [function] = OnReplionRemovedWithTag
            2 [function] = AwaitReplion
            3 [function] = GetReplion
            4 [function] = OnReplionAddedWithTag
            5 [function] = WaitReplion
            6 [function] = OnReplionAdded
            7 [function] = OnReplionRemoved
        2 [userdata] = Freeze.None
        3 [table]:
        Server [table] table: 0x7765f94c82919b5f
            1 [function] = GetReplionFor
            2 [function] = GetReplion
            3 [function] = OnReplionAdded
            4 [function] = GetReplionsFor
            5 [function] = AwaitReplionFor
            6 [function] = WaitReplionFor
            7 [function] = OnReplionRemoved
            8 [function] = AwaitReplion
            9 [function] = WaitReplion
            10 [function] = new
    4 [table]:
    4 [table] table: 0x3cb474e75fe2d0cf
        1 [table]:
        Products [table] table: 0xb3e2dbfa067596bf
            1 [number] = 1810437954
        2 [function] = GetMobHealth
        3 [number] = 10
        4 [number] = 50
        5 [table]:
        BaseMobXP [table] table: 0x8f01502053bdfe0f
            1 [number] = 5
            2 [number] = 5
            3 [number] = 5
        6 [number] = 300
        7 [function] = GetNumMobSpawns
        8 [table]:
        BaseMobSpawns [table] table: 0xead7e0d1a8ab36bf
            1 [number] = 5
            2 [number] = 6
            3 [number] = 4
        9 [table]:
        Remotes [table] table: 0xf3c9d39aec2dc85f
            1 [Instance] = RE/Dungeons-TogglePlayAgain
            2 [Instance] = RF/Dungeons-BuyShopItem
            3 [Instance] = RE/Dungeons-DifficultyVote
            4 [Instance] = RF/Dungeons-UseSkillPoints
        10 [number] = 15
        11 [table]:
        DungeonRuneDropMultipliers [table] table: 0x44d28330c957c59f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        12 [number] = 2
        13 [function] = GetTotalSkillPoints
        14 [table]:
        Levels [table] table: 0xaac56f8f4a63251f
            1 [function] = GetLevelFromTotalXP
            2 [function] = GetTotalXP
            3 [function] = GetRequiredXPForLevel
            4 [function] = GetTotalXPForLevel
        15 [table]:
        Tokens [table] table: 0x6c0f0bd9d040a59f
            1 [table]:
            DungeonXP [table] table: 0x8bd8bbbfa3af34ff
                1 [string] = rbxassetid://17302672193
                2 [function] = createDungeonXPReward
            2 [table]:
            DungeonRunes [table] table: 0xcfd5bbaed8bacd6f
                1 [string] = rbxassetid://17294426866
                2 [function] = createDungeonRunesReward
        16 [table]:
        EnabledAbilities [table] table: 0xa7f0ab0a1b6f1e0f
            1 [string] = Dash
            2 [string] = Super Jump
            3 [string] = Quad Jump
            4 [string] = Blink
            5 [string] = Titan Blade
            6 [string] = Platform
            7 [string] = Freeze
            8 [string] = Tact
            9 [string] = Rapture
            10 [string] = Telekinesis
            11 [string] = Forcefield
            12 [string] = Raging Deflection
            13 [string] = Absolute Confidence
            14 [string] = Pull
            15 [string] = Thunder Dash
            16 [string] = Shadow Step
            17 [string] = Reaper
            18 [string] = Wind Cloak
            19 [string] = Phase Bypass
            20 [string] = Phantom
        17 [function] = GetSkillValue
        18 [table]:
        DropChanceMultipliers [table] table: 0x16e43243ee696d6f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        19 [function] = GetUsedSkillPoints
        20 [function] = GetPlayerDamage
        21 [function] = GetRuneDropAmount
        22 [function] = GetPlayerHealth
        23 [table]:
        Difficulties [table] table: 0x9abac2f79af8285f
            1 [string] = Easy
            2 [string] = Normal
            3 [string] = Hard
        24 [function] = GetRuneDropChance
        25 [table]:
        Dungeons [table] table: 0x60f922900b0094ff
            1 [table]:
            Frost Area [table] table: 0x426633969a9f2bff
                1 [string] = Dungeon_FrostArea
                2 [number] = 20
                3 [table]:
                BaseMobDamage [table] table: 0x591a2c4340c47b6f
                    1 [number] = 25
                    2 [number] = 35
                    3 [number] = 15
                4 [table]:
                Drops [table] table: 0x919f80618581834f
                    1 [table]:
                    Chance [table] table: 0xd52a2202abdcd1af
                        1 [table]:
                        1 [table] table: 0x8d3c9353cec4c93f
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x49c15ca22e2a208f
                                1 [string] = Warrior's Beckoning
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298914810
                                4 [string] = Warrior's Beckoning Explosion
                        2 [table]:
                        2 [table] table: 0xe9ae14b27310781f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0x65a56ade08073fef
                                1 [string] = Emote291
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299532193
                                4 [string] = Purposeless Floating Emote
                        3 [table]:
                        3 [table] table: 0xddd8fa0ee16de77f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0x3e0a7afe3a5bcecf
                                1 [string] = Tundra's Tooth
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298967885
                                4 [string] = Tundra's Tooth
                    2 [table]:
                    Items [table] table: 0xcded5a22b6f2ec0f
                        1 [number] = 0.5
                        2 [number] = 0.25
                        3 [number] = 0.75
                    3 [table]:
                    Mobs [table] table: 0x51e5e8ee7fb5565f
                        1 [table]:
                        Default [table] table: 0xe1ff689ebcae9d2f
                            1 [NumberRange] = 5 9 
                        2 [table]:
                        Sentinel [table] table: 0x6d861acd859804bf
                            1 [NumberRange] = 7 11 
                    4 [table]:
                    Guaranteed [table] table: 0x6149337194ea1adf
                        1 [NumberRange] = 100 200 
                        2 [NumberRange] = 100 200 
                        3 [NumberRange] = 200 400 
                5 [string] = Frost Area
                6 [table]:
                BaseMobHealth [table] table: 0x89dba5136bef339f
                    1 [number] = 150
                    2 [number] = 250
                    3 [number] = 125
                7 [table]:
                Mobs [table] table: 0x9da0bd6513290a4f
                    1 [table]:
                    1 [table] table: 0xc1b22255060791df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x104bd107257a58af
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x9b39432b9623560f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x76abb23aa53c6d9f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xe48223cd4c16856f
                        1 [table]:
                        MaxBots [table] table: 0x406483eeedf8b44f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x8e5f339d2ce2fcff
                            1 [number] = 90
                            2 [number] = 10
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x160a53ff02d64bdf
                        1 [table]:
                        MaxBots [table] table: 0xde6493dd30bb9a3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x647be20f67ad22af
                            1 [number] = 80
                            2 [number] = 20
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x3b6ec3adf996118f
                        1 [table]:
                        MaxBots [table] table: 0xeb1dfb4b7b4140ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x47477bbcbe6fa91f
                            1 [number] = 70
                            2 [number] = 30
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x6f2a4a1bb45a387f
                        1 [table]:
                        MaxBots [table] table: 0x87bc5865ca05075f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xd3490b74e52cffcf
                            1 [number] = 60
                            2 [number] = 40
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x53a7d8946f1a6e2f
                        1 [string] = rbxassetid://17301468657
                        2 [string] = Frost Dragon
                        3 [table]:
                        MaxBots [table] table: 0x9a04ca3400c7dd0f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xffd10b4429f055bf
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xfdccc572e833a2ff
                    1 [number] = 45
                    2 [number] = 60
                    3 [number] = 30
                10 [number] = 7
                11 [number] = 15
            2 [table]:
            Grass Area [table] table: 0x3f640a437eaeacbf
                1 [string] = Dungeon_GrassArea
                2 [number] = 0
                3 [table]:
                BaseMobDamage [table] table: 0x9cf4de8ecc157c2f
                    1 [number] = 15
                    2 [number] = 25
                    3 [number] = 10
                4 [table]:
                Drops [table] table: 0x5373a933b350440f
                    1 [table]:
                    Chance [table] table: 0x6b7439d5a16f936f
                        1 [table]:
                        1 [table] table: 0xcf6f49864a140aff
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x8a99adf64f3ba24f
                                1 [string] = Serpent's Demise
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298908498
                                4 [string] = Serpent's Demise Explosion
                        2 [table]:
                        2 [table] table: 0x545c15e7ec2179df
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xe222dc1604d830af
                                1 [string] = Emote287
                                2 [string] = Emote
                                3 [string] = rbxassetid://17298997514
                                4 [string] = Selfie Emote
                        3 [table]:
                        3 [table] table: 0x903195c617f2e83f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xc23fedb25aed0f8f
                                1 [string] = Scaled Longsword
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298959253
                                4 [string] = Scaled Longsword
                    2 [table]:
                    Items [table] table: 0x0b11e1728641edcf
                        1 [number] = 0.25
                        2 [number] = 3
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x14a971a2c184971f
                        1 [table]:
                        Default [table] table: 0x6aaa8153d8be5eef
                            1 [NumberRange] = 1 5 
                        2 [table]:
                        Serpent Knight [table] table: 0xe8dc700293abc67f
                            1 [NumberRange] = 3 7 
                    4 [table]:
                    Guaranteed [table] table: 0xe702b822f8795b9f
                        1 [NumberRange] = 50 100 
                        2 [NumberRange] = 50 100 
                        3 [NumberRange] = 100 200 
                5 [string] = Grass Area
                6 [table]:
                BaseMobHealth [table] table: 0x46ef9661a57e355f
                    1 [number] = 125
                    2 [number] = 150
                    3 [number] = 75
                7 [table]:
                Mobs [table] table: 0xd0ebac2f623ecb0f
                    1 [table]:
                    1 [table] table: 0x86d5b4e10ad0d29f
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x4c1f3ef1f7cb1a6f
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0xeed6b68138fd81ff
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x68ada8d34194294f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xd6bb1823be8df0df
                        1 [table]:
                        MaxBots [table] table: 0x5d2ce64184587f3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x3cba5f30f3a347af
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0xe1176e90654eb68f
                        1 [table]:
                        MaxBots [table] table: 0xc2947c77cf04a5ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x1141c760b2650e1f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x8c68e700202e5d7f
                        1 [table]:
                        MaxBots [table] table: 0xf87787a017c3ac5f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6a7e6e50093954cf
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x9a615fb0daee032f
                        1 [table]:
                        MaxBots [table] table: 0x15848f105c9d720f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0x3c5227c3ddf7babf
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x61a9c7e09baa499f
                        1 [string] = rbxassetid://15522190869
                        2 [string] = Serpent
                        3 [table]:
                        MaxBots [table] table: 0x0d3ca780e95918ff
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xd1363ff186b0e16f
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 600
                9 [table]:
                AttackDamage [table] table: 0x7ef914bf4f0323bf
                    1 [number] = 30
                    2 [number] = 45
                    3 [number] = 15
                10 [number] = 7
                11 [number] = 14
            3 [table]:
            Space Area [table] table: 0x91af20f2151a686f
                1 [string] = Dungeon_SpaceArea
                2 [number] = 40
                3 [table]:
                BaseMobDamage [table] table: 0x8c803dd57bfdff6f
                    1 [number] = 35
                    2 [number] = 50
                    3 [number] = 25
                4 [table]:
                Drops [table] table: 0x6059b0821630afff
                    1 [table]:
                    Chance [table] table: 0x8453162259e69edf
                        1 [table]:
                        1 [table] table: 0x3e619d3250fc55af
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x197fd45d9b8d4d3f
                                1 [string] = Ogre's Martyrdom
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298922489
                                4 [string] = Ogre's Martyrdom Explosion
                        2 [table]:
                        2 [table] table: 0x79450c8e86a7a48f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xd568f57f95b9fc1f
                                1 [string] = Emote292
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299539124
                                4 [string] = Pay Attention! Emote
                        3 [table]:
                        3 [table] table: 0xb145f91ecf656b7f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xe090484dea7c42cf
                                1 [string] = Galactic Halberd
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298973230
                                4 [string] = Galactic Halberd
                    2 [table]:
                    Items [table] table: 0x58258df4f9d6600f
                        1 [number] = 0.125
                        2 [number] = 0.25
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x72a6e9bd3112da5f
                        1 [table]:
                        Default [table] table: 0xdc3d19937829112f
                            1 [NumberRange] = 9 13 
                        2 [table]:
                        Tribesman [table] table: 0xba0bc5c320c088bf
                            1 [NumberRange] = 11 15 
                    4 [table]:
                    Guaranteed [table] table: 0xf61a4ed222c9074f
                        1 [NumberRange] = 200 400 
                        2 [NumberRange] = 200 400 
                        3 [NumberRange] = 400 800 
                5 [string] = Space Area
                6 [table]:
                BaseMobHealth [table] table: 0xeadf25e5be93b79f
                    1 [number] = 300
                    2 [number] = 400
                    3 [number] = 200
                7 [table]:
                Mobs [table] table: 0x30fb31b7f5d18e4f
                    1 [table]:
                    1 [table] table: 0x60f82124aa3b15df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0xfece90144f26dcaf
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x1ce74144280cc43f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0xb6901274117b2b8f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xa8c362640661731f
                        1 [table]:
                        MaxBots [table] table: 0xcc38040c5db1e27f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6e2afd5c63483aef
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x8647ed3ddc9bc9cf
                        1 [table]:
                        MaxBots [table] table: 0x1ea01a9f86f6982f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x308d6aace38c515f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x735358cf91d91fbf
                        1 [table]:
                        MaxBots [table] table: 0x0b6828edcf362e9f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0xc70da8fca8c0970f
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0xaf7d3add2a1d466f
                        1 [table]:
                        MaxBots [table] table: 0x74502cbb0469f54f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xeb82ba8b7503bdff
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0xc25dd42afb5f8cdf
                        1 [string] = rbxassetid://17301462757
                        2 [string] = Galaxy Ogre
                        3 [table]:
                        MaxBots [table] table: 0x2248d2457ea25b3f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xb01683153e4963af
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xc2ed858484e626ff
                    1 [number] = 60
                    2 [number] = 75
                    3 [number] = 45
                10 [number] = 7
                11 [number] = 16
        26 [number] = 0.25
        27 [function] = GetMobXP
        28 [function] = GetRemainingSkillPoints
        29 [function] = GetMobDamage
        30 [table]:
        SkillPoints [table] table: 0xf7a56376a39cd28f
            1 [table]:
            AbilityCooldown [table] table: 0x2b16f3066ad8797f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ability Cooldown
            2 [table]:
            PlayerSpeed [table] table: 0x671e63ca4f37b0cf
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Player Speed
            3 [table]:
            Health [table] table: 0x8bb3f367f8f6ea1f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Health
            4 [table]:
            BallDamage [table] table: 0xcfc04056b1e281ef
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ball Damage
        31 [number] = 3
        32 [number] = 3
        33 [table]:
        Modes [table] table: 0x68ae928081918f2f
            1 [string] = Dungeon
            2 [string] = Boss

Function Constants: IsAbilityAllowed
    1 [string] = isLTMServer
    2 [string] = AllAbilitiesDisabled
    3 [string] = table
    4 [string] = find
    6 [string] = getDisabledAbilities
    7 [string] = isDuelMatchServer
    8 [string] = Client
    9 [string] = DuelMatch
    10 [string] = WaitReplion
    11 [string] = NoAbilities
    12 [string] = Get
    13 [string] = isNoAbilityRankedMatchServer
    14 [string] = isRankedMatchServer
    15 [string] = AbilityBanVoting
    16 [string] = BannedAbilities
    17 [string] = isDungeonsMatchServer
    18 [string] = isDungeonsLobbyServer
    19 [string] = EnabledAbilities

====================================================================================================

Function Dump: IsOwned

Function Upvalues: IsOwned
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsOwned
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = IsUnlocked
    5 [string] = IsTrialActive

====================================================================================================

Function Dump: IsTrialActive

Function Upvalues: IsTrialActive
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsTrialActive
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = GetRemainingTrialTime

====================================================================================================

Function Dump: GetRemainingTrialTime

Function Upvalues: GetRemainingTrialTime
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: GetRemainingTrialTime
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = Trials
    5 [string] = Abilities
    6 [string] = Get
    7 [string] = workspace
    9 [string] = GetServerTimeNow
    10 [string] = math
    11 [string] = max

====================================================================================================

Function Dump: Start

Function Upvalues: Start
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [table] (Recursive table detected)
    4 [table] (Recursive table detected)
    5 [table] (Recursive table detected)
    6 [Instance] = Nafisiuwu
    7 [Instance] = ReplicatedStorage
    8 [Instance] = UserInputService
    9 [table] (Recursive table detected)

Function Constants: Start
    1 [string] = Client
    2 [string] = Data
    3 [string] = AwaitReplion
    4 [string] = Remotes
    5 [string] = AbilityButtonPress
    6 [string] = Event
    7 [string] = Connect
    8 [string] = RequestAbilityUse
    9 [string] = OnClientEvent
    11 [string] = InputBegan
    12 [string] = task
    13 [string] = spawn

====================================================================================================

Function Dump: IsBlockedBy

Function Upvalues: IsBlockedBy

Function Constants: IsBlockedBy
    1 [string] = AbilityLock_%*
    2 [string] = format
    3 [string] = GetAttribute

====================================================================================================

Function Dump: IsAbilitiesBlocked

Function Upvalues: IsAbilitiesBlocked

Function Constants: IsAbilitiesBlocked
    1 [string] = PULSED
    2 [string] = GetAttribute

====================================================================================================
]]

-- // Function Dumper made by King.Kevin
-- // Script Path: ReplicatedStorage.Controllers.AbilityController

--[[
Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0xb05b5e0e515a35bf
        1 [boolean] = true
        2 [table]:
        CFrame [table] table: 0xbc835ffff3a6a35f
            1 [function] = PosInObjBlock
            2 [function] = AxisAngleInterpolate
            3 [function] = NormalOfPart
            4 [function] = CreatePart
            5 [function] = GetInvSizeComponents
            6 [function] = PosInObj
            7 [function] = Motor6D
            8 [function] = GetChildrenInRange
            9 [function] = Weld
            10 [function] = RigToPrimaryPart
            11 [function] = InsidePart
        3 [table]:
        Thread [table] table: 0x6ee28d739c78073f
            1 [function] = LoopFor
            2 [function] = RepeatLoopFor
            3 [function] = Every
            4 [function] = Condition
            5 [function] = SpawnConnectionTimer
            6 [function] = IsSuspendend
            7 [function] = SafeResumeDefer
            8 [function] = SpawnConnection
            9 [function] = Coro
            10 [function] = Run
            11 [function] = Wait
            12 [function] = Loop
            13 [function] = SafeResume
            14 [function] = WaitDelay
            15 [function] = RepeatUntil
            16 [RBXScriptSignal] = Signal Heartbeat
            17 [function] = Delay
            18 [function] = SafeCancel
        4 [Instance] = ServerStorage
        5 [table]:
        Settings [table] table: 0x3312a4f1a3a43eef
            1 [number] = 1720283400
            2 [number] = 604800
            3 [Color3] = 1, 1, 0
            4 [number] = 960
            5 [number] = 1688380605
            6 [number] = 345600
            7 [number] = 84600
            8 [Color3] = 0, 1, 0
            9 [Color3] = 1, 0, 0
            10 [number] = 1860
            11 [number] = 60
            12 [number] = 1697248800
        6 [table]:
        BaseObject [table] table: 0x6902ea5940f8bf1f
            1 [function] = Destroy
            2 [function] = new
            3 [table] (Recursive table detected)
            4 [string] = BaseObject
        7 [table]:
        Statable [table] table: 0xf3f46de69b13a3bf
            1 [function] = getAlarmState
            2 [function] = getReplionStatable
        8 [table]:
        Pcall [table] table: 0xccb73a1c68876a1f
            1 [function] = pcallWithDelayedRetries
        9 [RBXScriptSignal] = Signal RenderStepped
        10 [table]:
        SwordUtil [table] table: 0xe491accdb6c4ec4f
            1 [function] = GetCurrentlyEquippedSwordFromCharacter
            2 [function] = GetSwordList
        11 [table]:
        Network [table] table: 0xeec9a1c0c4596f7f
            1 [function] = Invoke
            2 [function] = ListenTo
            3 [table]:
            Events [table] table: 0xa89431f36b6046cf
            4 [function] = Fire
        12 [table]:
        Tags [table] table: 0x3d8c65c1d344dfcf
            1 [function] = GetAllTagged
            2 [function] = GetTagged
            3 [function] = NewDictOfTagged
            4 [function] = AsyncWaitForTaggedDescendant
            5 [function] = Remove
            6 [function] = Bind
            7 [function] = WaitForTaggedDescendant
            8 [function] = AsyncWaitForTagged
            9 [function] = GetTags
            10 [function] = WaitForTagged
            11 [function] = FindFirstTagged
            12 [function] = ForTagged
            13 [function] = ForEach
            14 [function] = NewArrayOfTagged
            15 [function] = Connect
            16 [function] = GetInstanceRemovedSignal
            17 [function] = WaitForTaggedGUI
            18 [function] = Has
            19 [function] = AsyncWaitForTaggedGUI
            20 [function] = GetInstanceAddedSignal
            21 [function] = Add
        13 [table]:
        VectorViewer [table] table: 0x3d827f5eea4329cf
            1 [function] = View
            2 [function] = Perma
        14 [function] = Create
        15 [table]:
        Job [table] table: 0xf722bb779814188f
            1 [function] = setNewCleaner
            2 [function] = cancel
            3 [function] = run
            4 [function] = addTask
            5 [function] = clone
            6 [table]:
            Break [table] table: 0x84b33c078302a01f
            7 [function] = skip
            8 [table] (Recursive table detected)
            9 [function] = new
        16 [table]:
        FFlag [table] table: 0xad99d15621d5c49f
            1 [function] = timeoutFFlag
        17 [table]:
        Events [table] table: 0xe149963cc698859f
            1 [function] = Fire
            2 [function] = Connect
        18 [boolean] = false
        19 [boolean] = false
        20 [Instance] = Debris
        21 [Instance] = UserInputService
        22 [table]:
        PlayerMaids [table] table: 0x313f8f6b3281312f
            1 [table]:
            PlayerAdded [table] table: 0x4d35567afa7768bf
                1 [function] = Connect
            2 [table]:
            __PlayerAdded [table] table: 0x8ca21f09c76e000f
            3 [table]:
            Client [table] table: 0xd845cfb6b125df6f
                1 [table]:
                _tasks [table] table: 0xba6e37a78e0e46ff
                    1 [RBXScriptConnection] = Connection
                    2 [table]:
                    Character [table] table: 0x7ca175e9e216823f
                        1 [table]:
                        _tasks [table] table: 0xe633edd95af2e98f
                    3 [table]:
                    AbilitySelected [table] table: 0x33c47aa2abf37cff
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0x3157f933a2f2ccef
                            1 [table]:
                            _handlerListHead [table] table: 0xdf9d2d1a0911921f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0xaa3674606ab109df
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table]:
                                    _next [table] table: 0xaada1df09ffb154f
                                        1 [function] = Unknown Name
                                        2 [boolean] = true
                                        3 [table] (Recursive table detected)
                                        4 [table]:
                                        _next [table] table: 0x589a53ebe063a8af
                                            1 [function] = Unknown Name
                                            2 [boolean] = true
                                            3 [table] (Recursive table detected)
                                            4 [table]:
                                            _next [table] table: 0x4f87556f424a3fbf
                                                1 [function] = Unknown Name
                                                2 [boolean] = true
                                                3 [table] (Recursive table detected)
                                                4 [table]:
                                                _next [table] table: 0xb3a09bb178e2781f
                                                    1 [function] = Unknown Name
                                                    2 [boolean] = true
                                                    3 [table] (Recursive table detected)
                                                    4 [table]:
                                                    _next [table] table: 0x563ee2635f3475ff
                                                        1 [function] = Unknown Name
                                                        2 [boolean] = true
                                                        3 [table] (Recursive table detected)
                                                        4 [table]:
                                                        _next [table] table: 0xbe595ea35838bf6f
                                                            1 [function] = Unknown Name
                                                            2 [boolean] = true
                                                            3 [table] (Recursive table detected)
                                                            4 [table]:
                                                            _next [table] table: 0xfcd875aa14e25b4f
                                                                1 [function] = Unknown Name
                                                                2 [boolean] = true
                                                                3 [table] (Recursive table detected)
                                                                4 [table]:
                                                                _next [table] table: 0x0b29b98a0b57dc6f
                                                                    1 [function] = Unknown Name
                                                                    2 [boolean] = true
                                                                    3 [table] (Recursive table detected)
                                                                    4 [table]:
                                                                    _next [table] table: 0xd34c9ab69b8fc69f
                                                                        1 [function] = Unknown Name
                                                                        2 [boolean] = true
                                                                        3 [table] (Recursive table detected)
                                                                        4 [table]:
                                                                        _next [table] table: 0xa9319b79f9bef35f
                                                                            1 [function] = Unknown Name
                                                                            2 [boolean] = true
                                                                            3 [table] (Recursive table detected)
                                                                            4 [table] (Recursive table detected)
                        4 [table]:
                        _next [table] table: 0x43b84c4aafa2418f
                            1 [function] = Unknown Name
                            2 [boolean] = true
                            3 [table] (Recursive table detected)
                            4 [table]:
                            _next [table] table: 0x85617e4c9d9ab47f
                                1 [function] = Unknown Name
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [boolean] = false
                    4 [table]:
                    AbilitiesRandomizer [table] table: 0x7786a317de52c0ef
                        1 [function] = Unknown Name
                        2 [boolean] = true
                        3 [table]:
                        _signal [table] table: 0xc45c32c75d78291f
                            1 [table]:
                            _handlerListHead [table] table: 0x5f7e7ac4e1ec276f
                                1 [function] = reflect
                                2 [boolean] = true
                                3 [table] (Recursive table detected)
                                4 [table]:
                                _next [table] table: 0x7c926a61c4c78fff
                                    1 [function] = Unknown Name
                                    2 [boolean] = true
                                    3 [table] (Recursive table detected)
                                    4 [table] (Recursive table detected)
                        4 [boolean] = false
                    5 [table]:
                    CharacterAdded [table] table: 0x60720ffa55cefcaf
                        1 [function] = Connect
        23 [table]:
        CameraUtils [table] table: 0x71f0c0386c9e1ecf
            1 [function] = getCubeoidDiameter
            2 [function] = isOnScreen
            3 [function] = getBoundingBoxOf
            4 [function] = GetBoundingBox
            5 [function] = fitSphereToCamera
            6 [function] = fitBoundingBoxToCamera
        24 [table]:
        String [table] table: 0x47284ca81f92486f
            1 [function] = EqualsIgnoreCase
            2 [function] = RemoveExcessWhitespace
            3 [function] = AssertAttributeName
            4 [function] = ToCharArray
            5 [function] = AddSpacesToPascalCase
            6 [function] = ToSnakeCase
            7 [function] = ToCamelCase
            8 [function] = Random
            9 [function] = ToByteArray
            10 [function] = EndsWith
            11 [function] = RemoveWhitespace
            12 [function] = TrimEnd
            13 [function] = Escape
            14 [function] = ToKebabCase
            15 [function] = Trim
            16 [function] = ValidateAttributeName
            17 [function] = GetStringLayoutOrder
            18 [function] = StartsWith
            19 [function] = ToPascalCase
            20 [function] = ByteArrayToString
            21 [function] = Contains
            22 [function] = StringBuilder
            23 [function] = TrimStart
        25 [table]:
        Spring [table] table: 0xefa21321e0a6dbbf
            1 [function] = target
            2 [function] = stop
            3 [function] = completed
        26 [table]:
        Streamer [table] table: 0xf18da6e4b47abb3f
            1 [function] = Sync
            2 [function] = SyncPrimaryPart
        27 [Instance] = PhysicsService
        28 [Instance] = ServerScriptService
        29 [table]:
        Vector [table] table: 0xc1b89cc3a1055a5f
            1 [function] = ShowTrack
            2 [function] = Raycast
            3 [function] = Reach
            4 [function] = Slerp
            5 [function] = Lightning
            6 [function] = GetTrackMagnitude
            7 [function] = FromAxisToPolar
            8 [function] = Raycast2
            9 [function] = Random
            10 [function] = CubicBezierArcLength
            11 [function] = GetVectorFromTrack
            12 [function] = KineticDirectionAccelerationMath
            13 [function] = KineticDirectionMath
            14 [function] = TorqueFromForce
            15 [function] = CubicBezier
            16 [function] = SquareBezier
            17 [function] = Lerp
            18 [function] = ClampMagnitude
            19 [function] = AngleBetweenSigned
            20 [function] = AngleBetween
            21 [function] = FromPolarToAxis
        30 [RBXScriptSignal] = Signal Stepped
        31 [table]:
        Sounds [table] table: 0x7726605d6699153f
            1 [function] = PlayAt
            2 [function] = Play
        32 [table]:
        Maid [table] table: 0xa5700b89af96e78f
            1 [function] = Destroy
            2 [function] = DoCleaning
            3 [function] = GiveTasks
            4 [function] = GivePromise
            5 [string] = Maid
            6 [function] = __newindex
            7 [function] = GiveTask
            8 [function] = __index
            9 [function] = new
        33 [Instance] = Run Service
        34 [table]:
        Table [table] table: 0xbe527bcdb019cdcf
            1 [function] = DecodeJSON
            2 [function] = find
            3 [function] = Assign
            4 [function] = GetChildrenNames
            5 [function] = EncodeJSON
            6 [function] = Print
            7 [function] = TablePick
            8 [function] = IsDictionary
            9 [function] = CopyTable
            10 [function] = GetGictionarySize
            11 [function] = CopyTableShallow
            12 [function] = FindDescendantSubstring
            13 [function] = Emtpy
            14 [function] = FastRemove
            15 [function] = FindSubstring
            16 [function] = Emtpy
            17 [function] = Shuffle
            18 [function] = Reverse
            19 [function] = Sync
            20 [function] = CreateDisappearingTable
            21 [function] = IsEmpty
            22 [function] = Map
            23 [function] = FindChildrenSubstring
            24 [function] = FastRemoveFirstValue
            25 [function] = TablePickAndRemove
            26 [function] = CopyDictionary
            27 [function] = Filter
            28 [function] = PickItemFromList
            29 [function] = DictionaryPickAndRemove
            30 [function] = Reduce
            31 [function] = DictionaryPick
        35 [table]:
        EasingUtil [table] table: 0xd1c51e4dba4b95df
            1 [function] = GetEasingStyles
        36 [table]:
        RewardInfo [table] table: 0x303bb853277a8f8f
            1 [function] = getItemOwnershipState
            2 [function] = playerOwnsItem
            3 [function] = playerOwnsItemFromData
        37 [table]:
        Random [table] table: 0x4fd81d7a6225120f
            1 [function] = NextValueFromDictionary
            2 [function] = NextInteger
            3 [function] = NextNumber
            4 [function] = NextRangeNumber
            5 [function] = NextValueFromTable
        38 [table]:
        Players [table] table: 0x775bb55ff6df368f
            1 [function] = getPlayerUsername
            2 [function] = getPlayerUsernameParsed
        39 [table]:
        Pages [table] table: 0xd40021f70caa49cf
            1 [function] = IterPages
            2 [function] = IterPagesAsync
            3 [function] = AdvanceToNextPageAsync
        40 [Instance] = Nafisiuwu
        41 [table]:
        Debug [table] table: 0xf0885a7a03cc073f
            1 [function] = printcontext
            2 [function] = printTable
            3 [function] = Part
            4 [function] = printl
            5 [function] = Line
            6 [function] = info
            7 [function] = warncontext
            8 [function] = pcall
            9 [function] = Get
        42 [table]:
        Physics [table] table: 0x48f8c629b339e6bf
            1 [function] = cloneAndWeld
            2 [function] = fastWeld
            3 [function] = resizePart
            4 [function] = createMotor
            5 [function] = createOldWeld
        43 [table]:
        Promise [table] table: 0x391a7ec75389c47f
            1 [function] = onUnhandledRejection
            2 [function] = _new
            3 [function] = fromEvent
            4 [function] = _all
            5 [function] = _try
            6 [function] = __tostring
            7 [function] = retryWithDelay
            8 [function] = defer
            9 [function] = race
            10 [function] = retry
            11 [function] = delay
            12 [function] = clock
            13 [function] = promisify
            14 [table]:
            __index [table] table: 0x045f37918ff9186f
                1 [function] = cancel
                2 [function] = finally
                3 [function] = _andThen
                4 [function] = andThenReturn
                5 [function] = finallyReturn
                6 [function] = await
                7 [function] = finallyCall
                8 [function] = expect
                9 [function] = timeout
                10 [function] = _finally
                11 [function] = _consumerCancelled
                12 [function] = _reject
                13 [function] = andThen
                14 [function] = andThenCall
                15 [function] = _unwrap
                16 [function] = expect
                17 [function] = catch
                18 [function] = now
                19 [function] = tap
                20 [function] = _resolve
                21 [function] = getStatus
                22 [function] = _finalize
                23 [function] = awaitStatus
            15 [table]:
            _unhandledRejectionCallbacks [table] table: 0x5215ac62aa10d09f
            16 [function] = is
            17 [function] = each
            18 [function] = try
            19 [RBXScriptSignal] = Signal Heartbeat
            20 [table] (Recursive table detected)
            21 [function] = defer
            22 [function] = allSettled
            23 [function] = any
            24 [function] = new
            25 [function] = reject
            26 [function] = fold
            27 [function] = all
            28 [table]:
            Status [table] table: 0xfaa060a11e4a335f
                1 [string] = Cancelled
                2 [string] = Rejected
                3 [string] = Resolved
                4 [string] = Started
            29 [function] = resolve
            30 [table]:
            Error [table] table: 0x4b40a960f96f599f
                1 [function] = __tostring
                2 [function] = getErrorChain
                3 [function] = extend
                4 [function] = isKind
                5 [function] = is
                6 [table]:
                Kind [table] table: 0x98af38407b3408ff
                    1 [string] = ExecutionError
                    2 [string] = TimedOut
                    3 [string] = AlreadyCancelled
                    4 [string] = NotResolvedInTime
                7 [table] (Recursive table detected)
                8 [function] = new
            31 [function] = some
        44 [table]:
        GuiUtils [table] table: 0x094d6d7ce3143dff
            1 [function] = mirrorActivated
            2 [function] = IsGuiObjectVisible
            3 [function] = getActivatedSignal
        45 [table]:
        Icons [table] table: 0x01ee90a8af87665f
            1 [function] = GetEmoteIcon
            2 [function] = GetSwordIcon
            3 [function] = GetIconFromData
            4 [function] = SetSwordIconAsViewport
            5 [function] = GetFinisherIcon
            6 [function] = GetCharacterIcon
            7 [function] = SetSwordIconAsViewportByName
            8 [function] = FitObjectViewportFrame
            9 [function] = GetAbilityIcon
            10 [function] = GetIcon
            11 [function] = GetExplosionIcon
        46 [table]:
        Visual [table] table: 0xe4bffa53935dfccf
            1 [function] = PlayEffectsAt
            2 [function] = TurnOffVisuals
            3 [function] = PlayEffects
        47 [table]:
        State [table] table: 0x1fa83b4bb7cc094f
            1 [function] = Unknown Name
        48 [table]:
        Easing [table] table: 0xd4811892f926d4cf
            1 [function] = SinEnd
            2 [function] = SinBoth
            3 [function] = SinStart
        49 [table]:
        ValueConvertor [table] table: 0xbb2f69c418e6f3cf
            1 [function] = GetColorSequenceFromPercentage
            2 [function] = FormatTimeWithDays
            3 [function] = AddCommas
            4 [function] = GetColorFromPercentage
            5 [function] = PickFromLootbox
            6 [function] = ShrinkNumber
            7 [function] = GetPlayersDisplayNameFromText
            8 [function] = GetLootboxMaxChance
            9 [function] = GetPlayerName
            10 [function] = FormatTimeWithDaysFull
            11 [function] = GetPlayersFromTuple
            12 [function] = FormatDigit
            13 [function] = FormatOrdinal
            14 [function] = FormatShortTime
            15 [function] = AdjustColor
            16 [function] = FormatTimeHHMMSS
            17 [function] = GetPlayersFromText
            18 [function] = FormatShortTimeFull
            19 [function] = GetPercentageTable
            20 [function] = FormatMarkupColor
            21 [function] = FormatTime
            22 [function] = InvertNumberSequence
            23 [function] = PlayerArrayToString
            24 [function] = GetNumberSequenceFromPercentage
            25 [function] = GetPercentageFromNumbers
            26 [function] = NormalizeRarity
            27 [function] = AddNumberPadding
        50 [Instance] = ContextActionService
        51 [table]:
        Signal [table] table: 0xa897443f79f4cf0f
            1 [function] = DisconnectAll
            2 [function] = Is
            3 [function] = Wrap
            4 [function] = On
            5 [function] = Connect
            6 [function] = Destroy
            7 [function] = Wait
            8 [function] = GetConnections
            9 [function] = Fire
            10 [function] = FireDeferred
            11 [function] = Once
            12 [table] (Recursive table detected)
            13 [function] = new
        52 [RBXScriptSignal] = Signal Heartbeat
        53 [table]:
        StateStack [table] table: 0x5e2a65245010197f
            1 [function] = new
            2 [function] = newState
        54 [table]:
        Binder [table] table: 0x463bbe70b43785ff
            1 [function] = GetClassAddedSignal
            2 [function] = Bind
            3 [function] = ObserveInstance
            4 [function] = isBinder
            5 [table] (Recursive table detected)
            6 [function] = new
            7 [function] = GetAll
            8 [function] = Promise
            9 [function] = GetConstructor
            10 [function] = Destroy
            11 [function] = _add
            12 [function] = UnbindClient
            13 [function] = GetTag
            14 [function] = _remove
            15 [function] = Get
            16 [function] = BindClient
            17 [string] = Binder
            18 [function] = Start
            19 [function] = Unbind
            20 [function] = GetClassRemovingSignal
            21 [function] = GetAllSet
    2 [table]:
    2 [table] table: 0x378b284f96857c4f
        1 [function] = IsOwned
        2 [function] = IsAbilitiesBlocked
        3 [function] = IsBlockedBy
        4 [function] = GetRemainingTrialTime
        5 [function] = SetAbility
        6 [function] = NotifyAbilityBlocked
        7 [function] = IsTrialActive
        8 [function] = IsAbilityAllowed
        9 [function] = Start
        10 [function] = GetEquipped
        11 [boolean] = false
        12 [function] = IsUnlocked
    3 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = PlayerMaids
    2 [string] = Client
    3 [string] = Thread
    4 [string] = Every
    5 [string] = RespawnAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table]:
    1 [table] table: 0x787d44c35d0d447f
        1 [function] = UpdateObject
        2 [function] = UpdateAllKeybinds
        3 [function] = UpdateHotbar
        4 [function] = LoadSettings
        5 [function] = UseBind
        6 [function] = CanGetStringForKeyCode
        7 [function] = GetBindButton
        8 [function] = SetType
        9 [function] = IsType
        10 [function] = Init
        11 [function] = Start
        12 [function] = UpdateAllSliders
        13 [function] = UpdateAllMisc
        14 [function] = LoadQuality
        15 [function] = GetBindButtons
        16 [function] = BindConnection
        17 [function] = GetDefault
        18 [function] = CustomGetStringForKeyCode
        19 [function] = GetBinds
    2 [function] = notifyBlockedAbility

Function Constants: Unknown Name
    1 [string] = Ability
    2 [string] = UseBind

====================================================================================================

Function Dump: notifyBlockedAbility

Function Upvalues: notifyBlockedAbility
    1 [Instance] = Nafisiuwu
    2 [table] (Recursive table detected)

Function Constants: notifyBlockedAbility
    1 [string] = Character
    2 [string] = PULSED
    3 [string] = GetAttribute
    4 [string] = AbilityBlockedByLTM
    5 [string] = AbilityBlockedByRanked
    6 [string] = AbilityBlockedByNoAbilityDuel
    7 [string] = AbilityBlockedByNoAbilityRanked
    8 [string] = AbilityBlockedByDungeons
    9 [string] = NotifyAbilityBlocked

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = GetEquipped
    2 [string] = SetAbility

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [table] (Recursive table detected)

Function Constants: Unknown Name
    1 [string] = AbilitiesRandomizer

====================================================================================================

Function Dump: GetEquipped

Function Upvalues: GetEquipped
    1 [table]:
    1 [table] table: 0x5478070339b0d7bf
        1 [function] = OnItemChange
        2 [function] = StringToItem
        3 [function] = FindItems
        4 [function] = GetLegacyInventoryPath
        5 [function] = GetInventory
        6 [function] = OnEquip
        7 [function] = GetEquipped
        8 [function] = GetEquippedList
        9 [function] = OwnsItem
        10 [function] = ItemToString
        11 [function] = GetInventoryVersion
        12 [function] = OnChange
        13 [function] = OnInventoryChange
        14 [function] = SafeGetLegacyInventoryPath
        15 [function] = Get
        16 [function] = GetItem
        17 [userdata] = Freeze.None

Function Constants: GetEquipped
    1 [string] = Ability
    2 [string] = GetEquipped
    3 [string] = Name
    4 [string] = Dash

====================================================================================================

Function Dump: IsUnlocked

Function Upvalues: IsUnlocked
    1 [table] (Recursive table detected)

Function Constants: IsUnlocked
    1 [string] = Ability
    2 [string] = FindItems

====================================================================================================

Function Dump: Unknown Name

Function Upvalues: Unknown Name
    1 [Instance] = ReplicatedStorage

Function Constants: Unknown Name
    1 [string] = Remotes
    2 [string] = AbilityButtonPress
    3 [string] = Fire

====================================================================================================

Function Dump: NotifyAbilityBlocked

Function Upvalues: NotifyAbilityBlocked
    1 [table]:
    1 [table] table: 0x7d849d32be69a66f
        1 [function] = isRankedMatchServer
        2 [function] = isIntermediatePlayerLobbyServer
        3 [function] = legacy
        4 [function] = isAFKServer
        5 [function] = isLTMServer
        6 [function] = isTrainingServer
        7 [function] = isTournamentDuoServer
        8 [function] = isClanWarServer
        9 [function] = isDungeonsMatchServer
        10 [function] = isTournamentLobbyServer
        11 [function] = isMobileServer
        12 [function] = isTournamentMatchServer
        13 [function] = isDuelLobbyServer
        14 [function] = isTestGame
        15 [function] = isElementalServer
        16 [function] = GetRankType
        17 [function] = isNewPlayerLobbyServer
        18 [function] = isDungeonsLobbyServer
        19 [function] = isProServer
        20 [function] = isDuelMatchServer
        21 [function] = isVoiceServer
        22 [function] = isNewPlayerLobbyMaxSpeedServer
        23 [function] = isTutorialServer
        24 [function] = isPrivateServer
        25 [function] = isNoAbilityRankedLobbyServer
        26 [function] = isNoAbilityRankedMatchServer
        27 [function] = isBossFightServer
        28 [function] = isRBBattlesServer
        29 [function] = isRankedLobbyServer
        30 [function] = isReservedServer
        31 [function] = isTradingPlazaServer
    2 [table]:
    2 [table] table: 0x81fc3fee5b7d484f
        1 [string] = Water Ticket
        2 [boolean] = true
        3 [function] = getDisplayName
        4 [function] = getTimeLeftDHMS
        5 [string] = WaterTickets
        6 [function] = getTimeLeftSeconds
        7 [table]:
        Pack [table] table: 0x51caa79edc47cfdf
            1 [boolean] = true
            2 [string] = FloodSurvival
            3 [number] = 1865615834
            4 [number] = 1865615828
        8 [boolean] = false
        9 [string] = WaterLastLoginStreak
        10 [string] = WaterLoginStreak
        11 [function] = getGameMode
        12 [function] = IsActive
        13 [function] = getDisabledAbilities
        14 [string] = FloodSurvival
        15 [DateTime] = 1721491200000
        16 [string] = WaterClaimedStreaks
        17 [string] = Flood Survival
    3 [table]:
    3 [table] table: 0x7811abc60bd7a2df
        1 [function] = Start
        2 [function] = sendNotification
        3 [function] = SendNotification

Function Constants: NotifyAbilityBlocked
    1 [string] = isLTMServer
    2 [string] = getGameMode
    3 [string] = Flying
    4 [string] = isNoAbilityRankedMatchServer
    5 [string] = isDungeonsMatchServer
    6 [string] = isDungeonsLobbyServer
    7 [string] = sendNotification
    8 [string] = Abilities are disabled in this game mode
    9 [number] = 6
    10 [string] = Chosen ability is disabled, please choose another

====================================================================================================

Function Dump: SetAbility

Function Upvalues: SetAbility
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [Instance] = Nafisiuwu
    4 [Instance] = ReplicatedStorage

Function Constants: SetAbility
    1 [string] = isElementalServer
    2 [string] = Character
    3 [string] = Abilities
    4 [string] = FindFirstChild
    5 [string] = require
    7 [string] = ServerInfo
    8 [string] = isTrainingServer
    9 [string] = workspace
    11 [string] = Alive
    12 [string] = IsDescendantOf
    13 [string] = CurrentlySelectedMode
    14 [string] = GetAttribute
    15 [string] = Randomizer
    16 [string] = Rebirth
    17 [string] = AbilitiesRandomizer
    18 [string] = pairs
    20 [string] = GetChildren
    21 [string] = LocalScript
    22 [string] = IsA
    23 [string] = Enabled
    24 [string] = Remotes
    25 [string] = kebaind
    26 [string] = FireServer

====================================================================================================

Function Dump: IsAbilityAllowed

Function Upvalues: IsAbilityAllowed
    1 [table] (Recursive table detected)
    2 [table] (Recursive table detected)
    3 [table]:
    3 [table] table: 0x834849bb998bd22f
        1 [table]:
        Client [table] table: 0xf730f358e19c6d5f
            1 [function] = OnReplionRemovedWithTag
            2 [function] = AwaitReplion
            3 [function] = GetReplion
            4 [function] = OnReplionAddedWithTag
            5 [function] = WaitReplion
            6 [function] = OnReplionAdded
            7 [function] = OnReplionRemoved
        2 [userdata] = Freeze.None
        3 [table]:
        Server [table] table: 0x7765f94c82919b5f
            1 [function] = GetReplionFor
            2 [function] = GetReplion
            3 [function] = OnReplionAdded
            4 [function] = GetReplionsFor
            5 [function] = AwaitReplionFor
            6 [function] = WaitReplionFor
            7 [function] = OnReplionRemoved
            8 [function] = AwaitReplion
            9 [function] = WaitReplion
            10 [function] = new
    4 [table]:
    4 [table] table: 0x3cb474e75fe2d0cf
        1 [table]:
        Products [table] table: 0xb3e2dbfa067596bf
            1 [number] = 1810437954
        2 [function] = GetMobHealth
        3 [number] = 10
        4 [number] = 50
        5 [table]:
        BaseMobXP [table] table: 0x8f01502053bdfe0f
            1 [number] = 5
            2 [number] = 5
            3 [number] = 5
        6 [number] = 300
        7 [function] = GetNumMobSpawns
        8 [table]:
        BaseMobSpawns [table] table: 0xead7e0d1a8ab36bf
            1 [number] = 5
            2 [number] = 6
            3 [number] = 4
        9 [table]:
        Remotes [table] table: 0xf3c9d39aec2dc85f
            1 [Instance] = RE/Dungeons-TogglePlayAgain
            2 [Instance] = RF/Dungeons-BuyShopItem
            3 [Instance] = RE/Dungeons-DifficultyVote
            4 [Instance] = RF/Dungeons-UseSkillPoints
        10 [number] = 15
        11 [table]:
        DungeonRuneDropMultipliers [table] table: 0x44d28330c957c59f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        12 [number] = 2
        13 [function] = GetTotalSkillPoints
        14 [table]:
        Levels [table] table: 0xaac56f8f4a63251f
            1 [function] = GetLevelFromTotalXP
            2 [function] = GetTotalXP
            3 [function] = GetRequiredXPForLevel
            4 [function] = GetTotalXPForLevel
        15 [table]:
        Tokens [table] table: 0x6c0f0bd9d040a59f
            1 [table]:
            DungeonXP [table] table: 0x8bd8bbbfa3af34ff
                1 [string] = rbxassetid://17302672193
                2 [function] = createDungeonXPReward
            2 [table]:
            DungeonRunes [table] table: 0xcfd5bbaed8bacd6f
                1 [string] = rbxassetid://17294426866
                2 [function] = createDungeonRunesReward
        16 [table]:
        EnabledAbilities [table] table: 0xa7f0ab0a1b6f1e0f
            1 [string] = Dash
            2 [string] = Super Jump
            3 [string] = Quad Jump
            4 [string] = Blink
            5 [string] = Titan Blade
            6 [string] = Platform
            7 [string] = Freeze
            8 [string] = Tact
            9 [string] = Rapture
            10 [string] = Telekinesis
            11 [string] = Forcefield
            12 [string] = Raging Deflection
            13 [string] = Absolute Confidence
            14 [string] = Pull
            15 [string] = Thunder Dash
            16 [string] = Shadow Step
            17 [string] = Reaper
            18 [string] = Wind Cloak
            19 [string] = Phase Bypass
            20 [string] = Phantom
        17 [function] = GetSkillValue
        18 [table]:
        DropChanceMultipliers [table] table: 0x16e43243ee696d6f
            1 [number] = 1.5
            2 [number] = 2
            3 [number] = 1
        19 [function] = GetUsedSkillPoints
        20 [function] = GetPlayerDamage
        21 [function] = GetRuneDropAmount
        22 [function] = GetPlayerHealth
        23 [table]:
        Difficulties [table] table: 0x9abac2f79af8285f
            1 [string] = Easy
            2 [string] = Normal
            3 [string] = Hard
        24 [function] = GetRuneDropChance
        25 [table]:
        Dungeons [table] table: 0x60f922900b0094ff
            1 [table]:
            Frost Area [table] table: 0x426633969a9f2bff
                1 [string] = Dungeon_FrostArea
                2 [number] = 20
                3 [table]:
                BaseMobDamage [table] table: 0x591a2c4340c47b6f
                    1 [number] = 25
                    2 [number] = 35
                    3 [number] = 15
                4 [table]:
                Drops [table] table: 0x919f80618581834f
                    1 [table]:
                    Chance [table] table: 0xd52a2202abdcd1af
                        1 [table]:
                        1 [table] table: 0x8d3c9353cec4c93f
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x49c15ca22e2a208f
                                1 [string] = Warrior's Beckoning
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298914810
                                4 [string] = Warrior's Beckoning Explosion
                        2 [table]:
                        2 [table] table: 0xe9ae14b27310781f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0x65a56ade08073fef
                                1 [string] = Emote291
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299532193
                                4 [string] = Purposeless Floating Emote
                        3 [table]:
                        3 [table] table: 0xddd8fa0ee16de77f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0x3e0a7afe3a5bcecf
                                1 [string] = Tundra's Tooth
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298967885
                                4 [string] = Tundra's Tooth
                    2 [table]:
                    Items [table] table: 0xcded5a22b6f2ec0f
                        1 [number] = 0.5
                        2 [number] = 0.25
                        3 [number] = 0.75
                    3 [table]:
                    Mobs [table] table: 0x51e5e8ee7fb5565f
                        1 [table]:
                        Default [table] table: 0xe1ff689ebcae9d2f
                            1 [NumberRange] = 5 9 
                        2 [table]:
                        Sentinel [table] table: 0x6d861acd859804bf
                            1 [NumberRange] = 7 11 
                    4 [table]:
                    Guaranteed [table] table: 0x6149337194ea1adf
                        1 [NumberRange] = 100 200 
                        2 [NumberRange] = 100 200 
                        3 [NumberRange] = 200 400 
                5 [string] = Frost Area
                6 [table]:
                BaseMobHealth [table] table: 0x89dba5136bef339f
                    1 [number] = 150
                    2 [number] = 250
                    3 [number] = 125
                7 [table]:
                Mobs [table] table: 0x9da0bd6513290a4f
                    1 [table]:
                    1 [table] table: 0xc1b22255060791df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x104bd107257a58af
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x9b39432b9623560f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x76abb23aa53c6d9f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xe48223cd4c16856f
                        1 [table]:
                        MaxBots [table] table: 0x406483eeedf8b44f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x8e5f339d2ce2fcff
                            1 [number] = 90
                            2 [number] = 10
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x160a53ff02d64bdf
                        1 [table]:
                        MaxBots [table] table: 0xde6493dd30bb9a3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x647be20f67ad22af
                            1 [number] = 80
                            2 [number] = 20
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x3b6ec3adf996118f
                        1 [table]:
                        MaxBots [table] table: 0xeb1dfb4b7b4140ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x47477bbcbe6fa91f
                            1 [number] = 70
                            2 [number] = 30
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x6f2a4a1bb45a387f
                        1 [table]:
                        MaxBots [table] table: 0x87bc5865ca05075f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xd3490b74e52cffcf
                            1 [number] = 60
                            2 [number] = 40
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x53a7d8946f1a6e2f
                        1 [string] = rbxassetid://17301468657
                        2 [string] = Frost Dragon
                        3 [table]:
                        MaxBots [table] table: 0x9a04ca3400c7dd0f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xffd10b4429f055bf
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xfdccc572e833a2ff
                    1 [number] = 45
                    2 [number] = 60
                    3 [number] = 30
                10 [number] = 7
                11 [number] = 15
            2 [table]:
            Grass Area [table] table: 0x3f640a437eaeacbf
                1 [string] = Dungeon_GrassArea
                2 [number] = 0
                3 [table]:
                BaseMobDamage [table] table: 0x9cf4de8ecc157c2f
                    1 [number] = 15
                    2 [number] = 25
                    3 [number] = 10
                4 [table]:
                Drops [table] table: 0x5373a933b350440f
                    1 [table]:
                    Chance [table] table: 0x6b7439d5a16f936f
                        1 [table]:
                        1 [table] table: 0xcf6f49864a140aff
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x8a99adf64f3ba24f
                                1 [string] = Serpent's Demise
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298908498
                                4 [string] = Serpent's Demise Explosion
                        2 [table]:
                        2 [table] table: 0x545c15e7ec2179df
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xe222dc1604d830af
                                1 [string] = Emote287
                                2 [string] = Emote
                                3 [string] = rbxassetid://17298997514
                                4 [string] = Selfie Emote
                        3 [table]:
                        3 [table] table: 0x903195c617f2e83f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xc23fedb25aed0f8f
                                1 [string] = Scaled Longsword
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298959253
                                4 [string] = Scaled Longsword
                    2 [table]:
                    Items [table] table: 0x0b11e1728641edcf
                        1 [number] = 0.25
                        2 [number] = 3
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x14a971a2c184971f
                        1 [table]:
                        Default [table] table: 0x6aaa8153d8be5eef
                            1 [NumberRange] = 1 5 
                        2 [table]:
                        Serpent Knight [table] table: 0xe8dc700293abc67f
                            1 [NumberRange] = 3 7 
                    4 [table]:
                    Guaranteed [table] table: 0xe702b822f8795b9f
                        1 [NumberRange] = 50 100 
                        2 [NumberRange] = 50 100 
                        3 [NumberRange] = 100 200 
                5 [string] = Grass Area
                6 [table]:
                BaseMobHealth [table] table: 0x46ef9661a57e355f
                    1 [number] = 125
                    2 [number] = 150
                    3 [number] = 75
                7 [table]:
                Mobs [table] table: 0xd0ebac2f623ecb0f
                    1 [table]:
                    1 [table] table: 0x86d5b4e10ad0d29f
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0x4c1f3ef1f7cb1a6f
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0xeed6b68138fd81ff
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0x68ada8d34194294f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xd6bb1823be8df0df
                        1 [table]:
                        MaxBots [table] table: 0x5d2ce64184587f3f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x3cba5f30f3a347af
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0xe1176e90654eb68f
                        1 [table]:
                        MaxBots [table] table: 0xc2947c77cf04a5ef
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x1141c760b2650e1f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x8c68e700202e5d7f
                        1 [table]:
                        MaxBots [table] table: 0xf87787a017c3ac5f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6a7e6e50093954cf
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0x9a615fb0daee032f
                        1 [table]:
                        MaxBots [table] table: 0x15848f105c9d720f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0x3c5227c3ddf7babf
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0x61a9c7e09baa499f
                        1 [string] = rbxassetid://15522190869
                        2 [string] = Serpent
                        3 [table]:
                        MaxBots [table] table: 0x0d3ca780e95918ff
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xd1363ff186b0e16f
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 600
                9 [table]:
                AttackDamage [table] table: 0x7ef914bf4f0323bf
                    1 [number] = 30
                    2 [number] = 45
                    3 [number] = 15
                10 [number] = 7
                11 [number] = 14
            3 [table]:
            Space Area [table] table: 0x91af20f2151a686f
                1 [string] = Dungeon_SpaceArea
                2 [number] = 40
                3 [table]:
                BaseMobDamage [table] table: 0x8c803dd57bfdff6f
                    1 [number] = 35
                    2 [number] = 50
                    3 [number] = 25
                4 [table]:
                Drops [table] table: 0x6059b0821630afff
                    1 [table]:
                    Chance [table] table: 0x8453162259e69edf
                        1 [table]:
                        1 [table] table: 0x3e619d3250fc55af
                            1 [number] = 2
                            2 [table]:
                            Reward [table] table: 0x197fd45d9b8d4d3f
                                1 [string] = Ogre's Martyrdom
                                2 [string] = Explosion
                                3 [string] = rbxassetid://17298922489
                                4 [string] = Ogre's Martyrdom Explosion
                        2 [table]:
                        2 [table] table: 0x79450c8e86a7a48f
                            1 [number] = 1
                            2 [table]:
                            Reward [table] table: 0xd568f57f95b9fc1f
                                1 [string] = Emote292
                                2 [string] = Emote
                                3 [string] = rbxassetid://17299539124
                                4 [string] = Pay Attention! Emote
                        3 [table]:
                        3 [table] table: 0xb145f91ecf656b7f
                            1 [number] = 0.25
                            2 [table]:
                            Reward [table] table: 0xe090484dea7c42cf
                                1 [string] = Galactic Halberd
                                2 [string] = Sword
                                3 [string] = rbxassetid://17298973230
                                4 [string] = Galactic Halberd
                    2 [table]:
                    Items [table] table: 0x58258df4f9d6600f
                        1 [number] = 0.125
                        2 [number] = 0.25
                        3 [number] = 0.5
                    3 [table]:
                    Mobs [table] table: 0x72a6e9bd3112da5f
                        1 [table]:
                        Default [table] table: 0xdc3d19937829112f
                            1 [NumberRange] = 9 13 
                        2 [table]:
                        Tribesman [table] table: 0xba0bc5c320c088bf
                            1 [NumberRange] = 11 15 
                    4 [table]:
                    Guaranteed [table] table: 0xf61a4ed222c9074f
                        1 [NumberRange] = 200 400 
                        2 [NumberRange] = 200 400 
                        3 [NumberRange] = 400 800 
                5 [string] = Space Area
                6 [table]:
                BaseMobHealth [table] table: 0xeadf25e5be93b79f
                    1 [number] = 300
                    2 [number] = 400
                    3 [number] = 200
                7 [table]:
                Mobs [table] table: 0x30fb31b7f5d18e4f
                    1 [table]:
                    1 [table] table: 0x60f82124aa3b15df
                        1 [number] = 1
                        2 [number] = 1
                        3 [number] = 1
                        4 [table]:
                        List [table] table: 0xfece90144f26dcaf
                            1 [number] = 100
                    2 [table]:
                    2 [table] table: 0x1ce74144280cc43f
                        1 [number] = 1.1
                        2 [number] = 1.1
                        3 [number] = 1.1
                        4 [table]:
                        List [table] table: 0xb6901274117b2b8f
                            1 [number] = 100
                    3 [table]:
                    3 [table] table: 0xa8c362640661731f
                        1 [table]:
                        MaxBots [table] table: 0xcc38040c5db1e27f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x6e2afd5c63483aef
                            1 [number] = 10
                            2 [number] = 90
                        3 [number] = 1.2
                        4 [number] = 1.2
                        5 [number] = 1.2
                    4 [table]:
                    4 [table] table: 0x8647ed3ddc9bc9cf
                        1 [table]:
                        MaxBots [table] table: 0x1ea01a9f86f6982f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0x308d6aace38c515f
                            1 [number] = 20
                            2 [number] = 80
                        3 [number] = 1.3
                        4 [number] = 1.3
                        5 [number] = 1.3
                    5 [table]:
                    5 [table] table: 0x735358cf91d91fbf
                        1 [table]:
                        MaxBots [table] table: 0x0b6828edcf362e9f
                            1 [number] = 1
                        2 [table]:
                        List [table] table: 0xc70da8fca8c0970f
                            1 [number] = 30
                            2 [number] = 70
                        3 [number] = 1.4
                        4 [number] = 1.4
                        5 [number] = 1.4
                    6 [table]:
                    6 [table] table: 0xaf7d3add2a1d466f
                        1 [table]:
                        MaxBots [table] table: 0x74502cbb0469f54f
                            1 [number] = 2
                        2 [table]:
                        List [table] table: 0xeb82ba8b7503bdff
                            1 [number] = 40
                            2 [number] = 60
                        3 [number] = 1.5
                        4 [number] = 1.5
                        5 [number] = 1.5
                    7 [table]:
                    7 [table] table: 0xc25dd42afb5f8cdf
                        1 [string] = rbxassetid://17301462757
                        2 [string] = Galaxy Ogre
                        3 [table]:
                        MaxBots [table] table: 0x2248d2457ea25b3f
                            1 [number] = 4
                        4 [table]:
                        List [table] table: 0xb01683153e4963af
                            1 [number] = 100
                        5 [number] = 1.6
                        6 [boolean] = true
                        7 [number] = 1.6
                        8 [number] = 1.6
                8 [number] = 720
                9 [table]:
                AttackDamage [table] table: 0xc2ed858484e626ff
                    1 [number] = 60
                    2 [number] = 75
                    3 [number] = 45
                10 [number] = 7
                11 [number] = 16
        26 [number] = 0.25
        27 [function] = GetMobXP
        28 [function] = GetRemainingSkillPoints
        29 [function] = GetMobDamage
        30 [table]:
        SkillPoints [table] table: 0xf7a56376a39cd28f
            1 [table]:
            AbilityCooldown [table] table: 0x2b16f3066ad8797f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ability Cooldown
            2 [table]:
            PlayerSpeed [table] table: 0x671e63ca4f37b0cf
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Player Speed
            3 [table]:
            Health [table] table: 0x8bb3f367f8f6ea1f
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Health
            4 [table]:
            BallDamage [table] table: 0xcfc04056b1e281ef
                1 [function] = GetValue
                2 [number] = 40
                3 [string] = Ball Damage
        31 [number] = 3
        32 [number] = 3
        33 [table]:
        Modes [table] table: 0x68ae928081918f2f
            1 [string] = Dungeon
            2 [string] = Boss

Function Constants: IsAbilityAllowed
    1 [string] = isLTMServer
    2 [string] = AllAbilitiesDisabled
    3 [string] = table
    4 [string] = find
    6 [string] = getDisabledAbilities
    7 [string] = isDuelMatchServer
    8 [string] = Client
    9 [string] = DuelMatch
    10 [string] = WaitReplion
    11 [string] = NoAbilities
    12 [string] = Get
    13 [string] = isNoAbilityRankedMatchServer
    14 [string] = isRankedMatchServer
    15 [string] = AbilityBanVoting
    16 [string] = BannedAbilities
    17 [string] = isDungeonsMatchServer
    18 [string] = isDungeonsLobbyServer
    19 [string] = EnabledAbilities

====================================================================================================

Function Dump: IsOwned

Function Upvalues: IsOwned
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsOwned
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = IsUnlocked
    5 [string] = IsTrialActive

====================================================================================================

Function Dump: IsTrialActive

Function Upvalues: IsTrialActive
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: IsTrialActive
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = GetRemainingTrialTime

====================================================================================================

Function Dump: GetRemainingTrialTime

Function Upvalues: GetRemainingTrialTime
    1 [table] (Recursive table detected)
    2 [Instance] = Nafisiuwu

Function Constants: GetRemainingTrialTime
    1 [string] = Server
    2 [string] = Data
    3 [string] = GetReplionFor
    4 [string] = Trials
    5 [string] = Abilities
    6 [string] = Get
    7 [string] = workspace
    9 [string] = GetServerTimeNow
    10 [string] = math
    11 [string] = max

====================================================================================================

Function Dump: Start

Function Upvalues: Start
    1 [function] = Unknown Name
    2 [table] (Recursive table detected)
    3 [table] (Recursive table detected)
    4 [table] (Recursive table detected)
    5 [table] (Recursive table detected)
    6 [Instance] = Nafisiuwu
    7 [Instance] = ReplicatedStorage
    8 [Instance] = UserInputService
    9 [table] (Recursive table detected)

Function Constants: Start
    1 [string] = Client
    2 [string] = Data
    3 [string] = AwaitReplion
    4 [string] = Remotes
    5 [string] = AbilityButtonPress
    6 [string] = Event
    7 [string] = Connect
    8 [string] = RequestAbilityUse
    9 [string] = OnClientEvent
    11 [string] = InputBegan
    12 [string] = task
    13 [string] = spawn

====================================================================================================

Function Dump: IsBlockedBy

Function Upvalues: IsBlockedBy

Function Constants: IsBlockedBy
    1 [string] = AbilityLock_%*
    2 [string] = format
    3 [string] = GetAttribute

====================================================================================================

Function Dump: IsAbilitiesBlocked

Function Upvalues: IsAbilitiesBlocked

Function Constants: IsAbilitiesBlocked
    1 [string] = PULSED
    2 [string] = GetAttribute

====================================================================================================
]]
