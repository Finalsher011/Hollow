end)

local esp_by_model = {}

local function remove_esp(model)
    local item = esp_by_model[model]
    if item then
        if item.highlight then item.highlight:Destroy() end
        if item.billboard then item.billboard:Destroy() end
        esp_by_model[model] = nil
    end
end

local function add_esp(model)
    if esp_by_model[model] or not model:IsA("Model") then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local adornee = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
    if not humanoid or not adornee then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(0, 210, 180)
    highlight.OutlineColor = Color3.fromRGB(220, 255, 250)
    highlight.FillTransparency = 0.78
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = gui

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = adornee
    billboard.Size = UDim2.fromOffset(190, 42)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 255, 250)
    label.TextStrokeTransparency = 0.25
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = billboard

    esp_by_model[model] = {
        highlight = highlight,
        billboard = billboard,
        label = label,
    }
end

local function get_targets()
    local result = {}
    for _, model in ipairs(CollectionService:GetTagged("TrainingTarget")) do
        if model:IsA("Model") and model:IsDescendantOf(workspace) then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local part = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and part then
                table.insert(result, {model = model, humanoid = humanoid, part = part})
            end
        end
    end
    return result
end

local function closest_target()
    local center = camera.ViewportSize / 2
    local best, best_distance = nil, config.fov
    for _, target in ipairs(get_targets()) do
        local screen, visible = camera:WorldToViewportPoint(target.part.Position)
        if visible and screen.Z > 0 then
            local distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude
            if distance < best_distance then
                best, best_distance = target.part, distance
            end
        end
    end
    return best
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == config.aim_key then
        aiming = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == config.aim_key then
        aiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    update_circle()

    local targets = get_targets()
    local active = {}
    for _, target in ipairs(targets) do
        active[target.model] = true
        if config.esp then
            add_esp(target.model)
            local item = esp_by_model[target.model]
            if item then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local target_root = target.model:FindFirstChild("HumanoidRootPart") or target.part
                local distance = root and (root.Position - target_root.Position).Magnitude or 0
                item.label.Text = string.format("%s  |  %dm  |  HP %d",
                    target.model.Name, math.floor(distance), math.floor(target.humanoid.Health))
            end
        else
            remove_esp(target.model)
        end
    end

    for model in pairs(esp_by_model) do
        if not active[model] then remove_esp(model) end
    end

    if config.aim_assist and aiming then
        local target = closest_target()
        if target then
            local desired = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, config.smoothing)
        end
    end
end)

refresh_ui()end)

local esp_by_model = {}

local function remove_esp(model)
    local item = esp_by_model[model]
    if item then
        if item.highlight then item.highlight:Destroy() end
        if item.billboard then item.billboard:Destroy() end
        esp_by_model[model] = nil
    end
end

local function add_esp(model)
    if esp_by_model[model] or not model:IsA("Model") then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local adornee = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
    if not humanoid or not adornee then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(0, 210, 180)
    highlight.OutlineColor = Color3.fromRGB(220, 255, 250)
    highlight.FillTransparency = 0.78
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = gui

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = adornee
    billboard.Size = UDim2.fromOffset(190, 42)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 255, 250)
    label.TextStrokeTransparency = 0.25
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = billboard

    esp_by_model[model] = {
        highlight = highlight,
        billboard = billboard,
        label = label,
    }
end

local function get_targets()
    local result = {}
    for _, model in ipairs(CollectionService:GetTagged("TrainingTarget")) do
        if model:IsA("Model") and model:IsDescendantOf(workspace) then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local part = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and part then
                table.insert(result, {model = model, humanoid = humanoid, part = part})
            end
        end
    end
    return result
end

local function closest_target()
    local center = camera.ViewportSize / 2
    local best, best_distance = nil, config.fov
    for _, target in ipairs(get_targets()) do
        local screen, visible = camera:WorldToViewportPoint(target.part.Position)
        if visible and screen.Z > 0 then
            local distance = (Vector2.new(screen.X, screen.Y) - center).Magnitude
            if distance < best_distance then
                best, best_distance = target.part, distance
            end
        end
    end
    return best
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == config.aim_key then
        aiming = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == config.aim_key then
        aiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    update_circle()

    local targets = get_targets()
    local active = {}
    for _, target in ipairs(targets) do
        active[target.model] = true
        if config.esp then
            add_esp(target.model)
            local item = esp_by_model[target.model]
            if item then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local target_root = target.model:FindFirstChild("HumanoidRootPart") or target.part
                local distance = root and (root.Position - target_root.Position).Magnitude or 0
                item.label.Text = string.format("%s  |  %dm  |  HP %d",
                    target.model.Name, math.floor(distance), math.floor(target.humanoid.Health))
            end
        else
            remove_esp(target.model)
        end
    end

    for model in pairs(esp_by_model) do
        if not active[model] then remove_esp(model) end
    end

    if config.aim_assist and aiming then
        local target = closest_target()
        if target then
            local desired = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, config.smoothing)
        end
    end
end)

refresh_ui()
