local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Character = game:GetService("Players").LocalPlayer.Character
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UseNewLobby"))
local ServerInfo = require(ReplicatedStorage:WaitForChild("ServerInfo"))
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Time"))
require(ReplicatedStorage.Shared.UniverseIds)
local ServerType = ServerInfo.isDuelLobbyServer() and { "DuelWinsLeaderboard" } or ServerInfo.isLTMServer() and { "KillsLeaderboard", "WinsLeaderboard", "LTMWinsLeaderboard" } or { "KillsLeaderboard", "WinsLeaderboard" }
local Emotes_1 = { "Emote12", "Emote24", "Emote26" }
local Emotes_booleans = {
    ["Emote12"] = true,
    ["Emote24"] = true,
    ["Emote26"] = true
}
local Emotes = ReplicatedStorage:WaitForChild("Misc"):WaitForChild("Emotes")
ReplicatedStorage:WaitForChild("ReplicatedLobbies")
local temp_table1 = {}
local temp_table2 = {}
local function ReplicatedStorage0(payload)
    -- upvalues: (copy) ServerInfo, (ref) ServerType, (copy) temp_table1, (copy) Emotes_1, (copy) Emotes, (copy) Emotes_booleans
    task.spawn(function()
        -- upvalues: (ref) ServerInfo, (copy) payload
        if not ServerInfo.isDuelLobbyServer() then
            local Client = payload:WaitForChild("Runtime"):WaitForChild("Client")
            for _, unknown_script in ipairs(Client:GetChildren()) do
                unknown_script.Enabled = true
            end
        end
    end)
    task.spawn(function()
        -- upvalues: (ref) ServerInfo, (copy) payload, (ref) ServerType, (ref) temp_table1, (ref) Emotes_1, (ref) Emotes, (ref) Emotes_booleans
        if not ServerInfo.isDungeonsLobbyServer() then
            payload:WaitForChild("Leaderboards")
            for _, v13 in ipairs(ServerType) do
                local CollectionService4 = workspace.Leaderboards:WaitForChild(v13):WaitForChild("FirstPlacePlayer"):WaitForChild("Rig"):WaitForChild("Humanoid"):WaitForChild("Animator")
                local temp_table_1 = temp_table1
                local delay_function = task.delay
                local function play_animation()
                    -- upvalues: (ref) Emotes_1, (ref) Emotes, (copy) CollectionService4, (ref) Emotes_booleans
                    while true do
                        local random_emote = Emotes_1[math.random(1, #Emotes_1)]
                        local loaded_animation = CollectionService4:LoadAnimation(Emotes[random_emote])
                        loaded_animation:Play()
                        if Emotes_booleans[random_emote] then
                            task.wait(10)
                            loaded_animation:Stop()
                        else
                            loaded_animation.Ended:Wait()
                            loaded_animation:Stop()
                        end
                        loaded_animation:Destroy()
                    end
                end

                table.insert(temp_table_1, delay_function(1, play_animation))
            end
        end
    end)
end
local function ReplicatedStorage3(Character)
    -- upvalues: (copy) CollectionService
    CollectionService:GetInstanceAddedSignal("SpawnNeon"):Connect(function(part)
        if part:IsA("BasePart") then
            part.Color = Color3.new(1, 0, 0)
        end
    end)
    for _, spawn_parts in ipairs(CollectionService:GetTagged("SpawnNeon")) do
        if spawn_parts:IsA("BasePart") then
            spawn_parts.Color = Color3.new(1, 0, 0)
        end
    end
end
function temp_table2.BeforeKnitInit(Character)
    -- upvalues: (copy) ReplicatedStorage0, (copy) ServerInfo, (copy) ReplicatedStorage3, (copy) ReplicatedStorage
    local v24 = workspace:WaitForChild("Spawn")
    if v24 then
        ReplicatedStorage0(v24)
        if ServerInfo.isProServer() then
            ReplicatedStorage3(v24)
        end
        workspace:SetAttribute("NewLobbyLoaded", true)
    end
    xpcall(function()
        -- upvalues: (ref) ReplicatedStorage
        require(ReplicatedStorage.Common.BitsUtil)
        require(ReplicatedStorage.Shared.ReplicatedInstances):Init()
        require(ReplicatedStorage.Common.MarketplaceService)
    end, warn)
end
function temp_table2.AfterKnitStarted(Character) end
return temp_table2
