-- HOLLOW.lua
-- Roblox Studio LocalScript for your own experience.
-- Install: StarterPlayer > StarterPlayerScripts
-- Test NPCs must be Models inside Workspace > TestNPCs, with Humanoid and Head.
-- This is not an injector and will not run in the normal Roblox Player by itself.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local config = {
    ESP = true,
    AimAssist = false,
    FOV = 150,
    Smoothness = 0.15,
}

local gui = Instance.new("ScreenGui")
gui.Name = "HOLLOW"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Main"
panel.Size = UDim2.fromOffset(290, 280)
panel.Position = UDim2.new(0.5, -145, 0.5, -140)
panel.BackgroundColor3 = Color3.fromRGB(19, 21, 29)
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 10)
panelCorner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 210, 170)
stroke.Thickness = 1
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 42)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "HOLLOW  |  TEST MENU"
title.TextColor3 = Color3.fromRGB(0, 220, 180)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 28)
close.Position = UDim2.new(1, -38, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(55, 35, 43)
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = panel
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

local function makeButton(label, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 36)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = Color3.fromRGB(39, 44, 57)
    button.TextColor3 = Color3.fromRGB(235, 239, 245)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.Text = label
    button.AutoButtonColor = true
    button.Parent = panel
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    return button
end

local espButton = makeButton("", 55)
local aimButton = makeButton("", 99)

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -24, 0, 22)
fovLabel.Position = UDim2.fromOffset(12, 145)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 12
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = panel

local fovInput = Instance.new("TextBox")
fovInput.Size = UDim2.new(1, -24, 0, 32)
fovInput.Position = UDim2.fromOffset(12, 169)
fovInput.BackgroundColor3 = Color3.fromRGB(39, 44, 57)
fovInput.TextColor3 = Color3.new(1, 1, 1)
fovInput.PlaceholderText = "FOV (30–500)"
fovInput.Text = tostring(config.FOV)
fovInput.ClearTextOnFocus = false
fovInput.Font = Enum.Font.Gotham
fovInput.TextSize = 13
fovInput.Parent = panel
Instance.new("UICorner", fovInput).CornerRadius = UDim.new(0, 6)

local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(1, -24, 0, 22)
smoothLabel.Position = UDim2.fromOffset(12, 207)
smoothLabel.BackgroundTransparency = 1
smoothLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.TextSize = 12
smoothLabel.TextXAlignment = Enum.TextXAlignment.Left
smoothLabel.Parent = panel

local smoothInput = Instance.new("TextBox")
smoothInput.Size = UDim2.new(1, -24, 0, 30)
smoothInput.Position = UDim2.fromOffset(12, 231)
smoothInput.BackgroundColor3 = Color3.fromRGB(39, 44, 57)
smoothInput.TextColor3 = Color3.new(1, 1, 1)
smoothInput.PlaceholderText = "Smoothness (0.01–1)"
smoothInput.Text = tostring(config.Smoothness)
smoothInput.ClearTextOnFocus = false
smoothInput.Font = Enum.Font.Gotham
smoothInput.TextSize = 13
smoothInput.Parent = panel
Instance.new("UICorner", smoothInput).CornerRadius = UDim.new(0, 6)

local function refreshLabels()
    espButton.Text = "NPC ESP: " .. (config.ESP and "ON" or "OFF")
    aimButton.Text = "NPC Aim Assist: " .. (config.AimAssist and "ON" or "OFF")
    fovLabel.Text = "Aim FOV: " .. tostring(config.FOV)
    smoothLabel.Text = "Aim smoothing: " .. string.format("%.2f", config.Smoothness)
end

espButton.MouseButton1Click:Connect(function()
    config.ESP = not config.ESP
    refreshLabels()
end)

aimButton.MouseButton1Click:Connect(function()
    config.AimAssist = not config.AimAssist
    refreshLabels()
end)

fovInput.FocusLost:Connect(function()
    local value = tonumber(fovInput.Text)
    if value then
        config.FOV = math.clamp(math.floor(value), 30, 500)
    end
    fovInput.Text = tostring(config.FOV)
    refreshLabels()
end)

smoothInput.FocusLost:Connect(function()
    local value = tonumber(smoothInput.Text)
    if value then
        config.Smoothness = math.clamp(value, 0.01, 1)
    end
    smoothInput.Text = tostring(config.Smoothness)
    refreshLabels()
end)

close.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        panel.Visible = not panel.Visible
    end
end)

local highlights = {}

local function updateESP()
    local folder = workspace:FindFirstChild("TestNPCs")
    if not folder then
        for npc, highlight in pairs(highlights) do
            highlight:Destroy()
            highlights[npc] = nil
        end
        return
    end

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") then
            local highlight = highlights[npc]
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "HOLLOW_TestNPC_Highlight"
                highlight.Adornee = npc
                highlight.FillColor = Color3.fromRGB(0, 210, 170)
                highlight.OutlineColor = Color3.fromRGB(235, 255, 250)
                highlight.FillTransparency = 0.72
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = gui
                highlights[npc] = highlight
            end
            highlight.Enabled = config.ESP
        end
    end

    for npc, highlight in pairs(highlights) do
        if not npc.Parent or npc.Parent ~= folder then
            highlight:Destroy()
            highlights[npc] = nil
        end
    end
end

local function getClosestTestNPC()
    local folder = workspace:FindFirstChild("TestNPCs")
    if not folder then return nil end

    local viewportCenter = camera.ViewportSize / 2
    local closestPart = nil
    local shortestDistance = config.FOV

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local head = npc:FindFirstChild("Head")
            if humanoid and humanoid.Health > 0 and head and head:IsA("BasePart") then
                local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPoint.Z > 0 then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - viewportCenter).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPart = head
                    end
                end
            end
        end
    end

    return closestPart
end

refreshLabels()

RunService.RenderStepped:Connect(function()
    camera = workspace.CurrentCamera
    updateESP()

    if config.AimAssist then
        local target = getClosestTestNPC()
        if target then
            local desired = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, config.Smoothness)
        end
    end
end)

print("[HOLLOW] Test menu loaded. Press INSERT to show/hide.")
