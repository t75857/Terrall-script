-- Mobile-Friendly Universal Roblox Script (Onion)
-- Tested for mobile devices

-- Load Onion safely
local success, Onion = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Erixxz/Onion/main/Onion.lua"))()
end)

if not success then
    warn("Failed to load Onion library. Make sure your executor supports loadstring and HTTP.")
    return
end

-- Create main GUI window (mobile friendly)
local Window = Onion:Window("Universal Script", Color3.fromRGB(255, 128, 64)) -- No KeyCode

-- ===== Player ESP =====
local ESPSection = Window:Folder("Player ESP")
local espEnabled = false

ESPSection:Toggle("Enable ESP", false, function(state)
    espEnabled = state
end)

-- ===== Movement (WalkSpeed & JumpPower) =====
local MovementSection = Window:Folder("Movement")
local speedValue = 16
local jumpValue = 50

local function applyMovement()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedValue
        char.Humanoid.JumpPower = jumpValue
    end
end

MovementSection:Slider("WalkSpeed", 16, 100, 1, function(val)
    speedValue = val
    applyMovement()
end)

MovementSection:Slider("JumpPower", 50, 200, 1, function(val)
    jumpValue = val
    applyMovement()
end)

-- Automatically apply movement on respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    applyMovement()
end)

-- ===== Anti-AFK =====
local MiscSection = Window:Folder("Misc")
MiscSection:Button("Enable Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- ===== ESP Logic =====
game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not player.Character:FindFirstChild("ESPBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESPBox"
                    box.Adornee = player.Character.HumanoidRootPart
                    box.Size = Vector3.new(2, 5, 1)
                    box.Color3 = Color3.fromRGB(0, 255, 0)
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.Parent = player.Character
                end
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPBox") then
                player.Character.ESPBox:Destroy()
            end
        end
    end
end)

print("Mobile-friendly Onion script loaded successfully!")
