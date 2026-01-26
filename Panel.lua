if getgenv().GUI_Loaded then return end
getgenv().GUI_Loaded = true

-- Configurações básicas
local version = "4.5.6"
local discordCode = "ksxs"
local NOME_PAINEL = "Painel bolabola"
local API_URL = "https://api-painel-bolabola.onrender.com"
local API_TOKEN = "bolabolabolabola"

local httprequest = request or http_request or (syn and syn.request) or http.request
local S = setmetatable({}, { __index = function(t,k) return game:GetService(k) end })
local plr = S.Players.LocalPlayer

local is_vip = false
local is_staff = false

-- Função auxiliar de criação (única)
local function Instantiate(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
    return inst
end

local function SendNotify(title, text, dur)
    pcall(function()
        S.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur or 5})
    end)
end

-- Criação da GUI (apenas uma vez)
local GUI = Instantiate("ScreenGui", {
    Name = "PainelBola",
    Parent = plr:WaitForChild("PlayerGui"),
    ResetOnSpawn = false,
    IgnoreGuiInset = true
})

local Background = Instantiate("Frame", {
    Name = "Background",
    Parent = GUI,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 500, 0, 350),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = true  -- começa aberto para testar
})

Instantiate("TextLabel", {
    Parent = Background,
    Size = UDim2.new(1, 0, 0, 30),
    Text = NOME_PAINEL .. " v" .. version,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Oswald,
    TextSize = 24
})

-- Verificação VIP (assíncrona)
task.spawn(function()
    local success, res = pcall(httprequest, {
        Url = API_URL .. "/check/" .. plr.UserId,
        Method = "GET",
        Headers = { ["x-token"] = API_TOKEN }
    })
    if success and res and res.Body then
        local data = S.HttpService:JSONDecode(res.Body)
        if data then
            is_vip = data.is_vip == true
            is_staff = data.tag == "[STAFF]" or data.tag == "[DONO]"
            SendNotify("Painel", "Status carregado: VIP = " .. tostring(is_vip), 5)
        end
    end
end)

-- =============================================
--           MENU LATERAL
-- =============================================

local SectionList = Instantiate("ScrollingFrame", {
    Parent = Background,
    Position = UDim2.new(0, 0, 0, 30),
    Size = UDim2.new(0, 105, 1, -30),
    BackgroundTransparency = 0.5,
    CanvasSize = UDim2.new(0, 0, 0, 0)
})

Instance.new("UIListLayout", SectionList).Padding = UDim.new(0, 6)

local sections = {"Home", "VIP", "Emphasis", "Character", "Target", "Animations", "More", "Misc", "Servers", "About"}
if is_staff then table.insert(sections, 2, "STAFF") end

local SectionFrames = {}
for i, name in ipairs(sections) do
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = SectionList
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.Font = Enum.Font.Oswald
    btn.TextSize = 16
    btn.BackgroundTransparency = 0.6
    btn.TextColor3 = Color3.fromRGB(220,220,220)

    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "_Frame"
    frame.Parent = Background
    frame.Position = UDim2.new(0, 105, 0, 30)
    frame.Size = UDim2.new(1, -105, 1, -30)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.CanvasSize = UDim2.new(0, 0, 3, 0)

    SectionFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(SectionFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Overlay VIP (só se não for VIP)
local vipOverlay = Instance.new("Frame")
vipOverlay.Name = "VIPOverlay"
vipOverlay.Parent = SectionFrames.VIP
vipOverlay.Size = UDim2.new(1,0,1,0)
vipOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
vipOverlay.BackgroundTransparency = 0.4
vipOverlay.Visible = not is_vip

Instance.new("TextLabel", vipOverlay).Text = "VIP BLOQUEADO\nAcesse discord.gg/"..discordCode
Instance.new("TextLabel", vipOverlay).Size = UDim2.new(1,0,0.5,0)
Instance.new("TextLabel", vipOverlay).Position = UDim2.new(0,0,0.25,0)
Instance.new("TextLabel", vipOverlay).BackgroundTransparency = 1
Instance.new("TextLabel", vipOverlay).TextScaled = true
Instance.new("TextLabel", vipOverlay).TextColor3 = Color3.fromRGB(255,220,0)

-- =============================================
--           HOME
-- =============================================
do
    local home = SectionFrames.Home
    Instance.new("TextLabel", home).Text = "Bem-vindo!"
    Instance.new("TextLabel", home).Size = UDim2.new(1,0,0,50)
    Instance.new("TextLabel", home).Position = UDim2.new(0,0,0,20)
    Instance.new("TextLabel", home).BackgroundTransparency = 1
    Instance.new("TextLabel", home).TextScaled = true
end

-- =============================================
--           VIP (todas as opções do original)
-- =============================================
do
    local vip = SectionFrames.VIP

    local btns = {
        "Fling", "AntiFling", "AntiForce", "AntiChatSpy", "AutoSacrifice", "EscapeHandcuffs"
    }

    for i, name in ipairs(btns) do
        local btn = Instance.new("TextButton")
        btn.Parent = vip
        btn.Size = UDim2.new(0.45,0,0,45)
        btn.Position = UDim2.new(0.05 + ((i-1)%2)*0.5, 0, 0.05 + math.floor((i-1)/2)*0.13, 0)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

        btn.MouseButton1Click:Connect(function()
            SendNotify("VIP", name .. " ativado", 4)
            -- Aqui você pode colocar loadstring real se tiver link
        end)
    end
end

-- =============================================
--           CHARACTER (Fly, WalkSpeed, JumpPower, etc.)
-- =============================================
do
    local char = SectionFrames.Character

    local wsBtn = Instance.new("TextButton", char)
    wsBtn.Size = UDim2.new(0.45,0,0,45)
    wsBtn.Position = UDim2.new(0.05,0,0.05,0)
    wsBtn.Text = "WalkSpeed 50"
    wsBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

    wsBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 50
            SendNotify("Character", "WalkSpeed = 50", 4)
        end
    end)

    local jpBtn = Instance.new("TextButton", char)
    jpBtn.Size = UDim2.new(0.45,0,0,45)
    jpBtn.Position = UDim2.new(0.5,0,0.05,0)
    jpBtn.Text = "JumpPower 100"
    jpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

    jpBtn.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = 100
            SendNotify("Character", "JumpPower = 100", 4)
        end
    end)

    local flyBtn = Instance.new("TextButton", char)
    flyBtn.Size = UDim2.new(0.45,0,0,45)
    flyBtn.Position = UDim2.new(0.05,0,0.2,0)
    flyBtn.Text = "Fly ON/OFF"
    flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

    local flying = false
    flyBtn.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            SendNotify("Fly", "Fly ativado - WASD + Space/Ctrl", 5)
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hum = char:WaitForChild("Humanoid")
            local root = char:WaitForChild("HumanoidRootPart")

            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            bv.Velocity = Vector3.new()

            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
            bg.CFrame = root.CFrame

            hum.PlatformStand = true

            local speed = 60
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not flying then conn:Disconnect() return end
                local cam = workspace.CurrentCamera
                local move = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
                bv.Velocity = move.Unit * speed
                bg.CFrame = cam.CFrame
            end)
        else
            SendNotify("Fly", "Fly desativado", 4)
            if plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(root:GetChildren()) do
                        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
                    end
                    plr.Character.Humanoid.PlatformStand = false
                end
            end
        end
    end)
end

-- =============================================
--           EMPHASIS (Invisible, NoClip, Spin, etc.)
-- =============================================
do
    local emp = SectionFrames.Emphasis

    local btns = {
        {"Invisible", "Invisibilidade ativada"},
        {"ClickTP", "Click para teleportar"},
        {"NoClip", "NoClip ativado"},
        {"Spin", "Girando..."}
    }

    for i, t in ipairs(btns) do
        local btn = Instance.new("TextButton", emp)
        btn.Size = UDim2.new(0.45,0,0,45)
        btn.Position = UDim2.new(0.05 + ((i-1)%2)*0.5, 0, 0.05 + math.floor((i-1)/2)*0.13, 0)
        btn.Text = t[1]
        btn.BackgroundColor3 = Color3.fromRGB(180, 60, 180)

        btn.MouseButton1Click:Connect(function()
            SendNotify("Emphasis", t[2], 4)
        end)
    end
end

-- =============================================
--           TARGET (View, Follow, Bang, etc.)
-- =============================================
do
    local tgt = SectionFrames.Target

    local input = Instance.new("TextBox", tgt)
    input.Size = UDim2.new(0.8,0,0,35)
    input.Position = UDim2.new(0.1,0,0.05,0)
    input.PlaceholderText = "Nome do alvo..."

    local btns = {"View", "Teleport", "Bring", "Bang", "Follow"}

    for i, name in ipairs(btns) do
        local btn = Instance.new("TextButton", tgt)
        btn.Size = UDim2.new(0.45,0,0,45)
        btn.Position = UDim2.new(0.05 + ((i-1)%2)*0.5, 0, 0.2 + math.floor((i-1)/2)*0.13, 0)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)

        btn.MouseButton1Click:Connect(function()
            SendNotify("Target", name .. " usado", 4)
        end)
    end
end

-- Tecla B para abrir/fechar
S.UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then
        Background.Visible = not Background.Visible
    end
end)

-- Botão flutuante para mobile
local toggleBtn = Instance.new("TextButton", GUI)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.Text = "B"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
toggleBtn.Font = Enum.Font.Oswald
toggleBtn.TextSize = 24

toggleBtn.MouseButton1Click:Connect(function()
    Background.Visible = not Background.Visible
end)

print("Painel bolabola corrigido e aberto - Pressione B")
