local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Loader = require(ReplicatedStorage.Packages.Loader)

require(ReplicatedStorage.Shared.FrameCap)
require(ReplicatedStorage.Packages.Replion)

local Bootstrapper = require(script:WaitForChild("Bootstrapper"))
local PlayerGui = Players.LocalPlayer.PlayerGui

for _, gui in ReplicatedStorage.Assets.ScreenGui:GetChildren() do
    if gui:IsA("LayerCollector") and gui.ResetOnSpawn then
        warn((("ResetOnSpawn is enabled for %* %*!"):format(gui.ClassName, gui.Name)))
    end
    gui.Parent = PlayerGui
end

Bootstrapper:BeforeKnitInit()

local Controllers = Loader.LoadDescendants(ReplicatedStorage.Controllers, Loader.MatchesName("Controller"))
local Client = Loader.LoadDescendants(script.Parent.Client, Loader.MatchesName("Controller$"))

local function ReplicatedStorage4(payload)
    for ReplicatedStorage0, ReplicatedStorage1 in payload do
        if ReplicatedStorage1.Init then
            local ReplicatedStorage2, ReplicatedStorage3 = pcall(ReplicatedStorage1.Init, ReplicatedStorage1)

            if not ReplicatedStorage2 then
                task.spawn(error, (("%*:Init() - %*"):format(ReplicatedStorage0, ReplicatedStorage3)))
            end
        end
    end
end

ReplicatedStorage4(Controllers)
ReplicatedStorage4(Client)

Loader.SpawnAll(Controllers, "Start")
Loader.SpawnAll(Client, "Start")

Bootstrapper:AfterKnitStarted()

Loader.LoadDescendants(ReplicatedStorage.Observers)
require(ReplicatedStorage.Shared.SharedModifiers)
require(ReplicatedStorage.Shared.SpeedModifiers)
require(ReplicatedStorage.Shared.JumpModifiers)
