local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local ClientLoader = script
local PlayerGui = LocalPlayer.PlayerGui

local Loader = require(ReplicatedStorage.Packages.Loader)
local Bootstrapper = require(ClientLoader:WaitForChild("Bootstrapper"))

require(ReplicatedStorage.Shared.FrameCap)
require(ReplicatedStorage.Packages.Replion)

for _, gui in ipairs(ReplicatedStorage.Assets.ScreenGui:GetChildren()) do
    if gui:IsA("LayerCollector") and gui.ResetOnSpawn then
        warn(string.format("ResetOnSpawn is enabled for %s %s!", gui.ClassName, gui.Name))
    end

    gui.Parent = PlayerGui
end

Bootstrapper:BeforeKnitInit()

local controllersFromReplicatedStorage = Loader.LoadDescendants(ReplicatedStorage.Controllers, Loader.MatchesName("Controller"))
local controllersFromClient = Loader.LoadDescendants(ClientLoader.Parent.Client, Loader.MatchesName("Controller$"))

local function initializeControllers(controllers)
    for name, controller in pairs(controllers) do
        if controller.Init then
            local success, err = pcall(controller.Init, controller)

            if not success then
                task.spawn(error, string.format("%s:Init() - %s", name, err))
            end
        end
    end
end

initializeControllers(controllersFromReplicatedStorage)
initializeControllers(controllersFromClient)
Loader.SpawnAll(controllersFromReplicatedStorage, "Start")
Loader.SpawnAll(controllersFromClient, "Start")

Bootstrapper:AfterKnitStarted()

Loader.LoadDescendants(ReplicatedStorage.Observers)
require(ReplicatedStorage.Shared.SharedModifiers)
require(ReplicatedStorage.Shared.SpeedModifiers)
require(ReplicatedStorage.Shared.JumpModifiers)