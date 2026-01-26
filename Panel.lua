if getgenv().GUI_Loaded then return end
getgenv().GUI_Loaded = true

-- CONFIGURAÇÕES
local version, discordCode, ownerId = "4.5.6", "ksxs", 3961485767
local API_URL = "https://api-painel-bolabola.onrender.com" 
local API_TOKEN = "bolabolabolabola"
local NOME_PAINEL = "Painel bolabola"

local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local S = setmetatable({}, { __index = function(t,k) local s=game:GetService(k); t[k]=s; return s end })
local plr = S.Players.LocalPlayer
local userId = plr.UserId

-- Estados
local is_vip = false
local is_staff = false
local is_banned = false

-- Função de criação de instância (unificada)
local function Instantiate(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props or {}) do pcall(function() inst[prop] = val end) end
    return inst
end

local function SendNotify(title, message, duration) 
    pcall(function() S.StarterGui:SetCore("SendNotification", { Title = title, Text = message, Duration = duration or 5 }) end)
end

-- GUI principal (só uma)
local GUI = Instantiate("ScreenGui", { 
    Name = "PainelBola", Parent = plr:WaitForChild("PlayerGui"), ResetOnSpawn = false, IgnoreGuiInset = true 
})

local Background = Instantiate("Frame", { 
    Name = "Background", Parent = GUI, 
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 500, 0, 350),
    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0, Active = true, Draggable = true
})

local TitleBar = Instantiate("TextLabel", { 
    Parent = Background, Size = UDim2.new(1, 0, 0, 30),
    Text = NOME_PAINEL .. " v" .. version, BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Oswald, TextSize = 22
})

-- Verificação VIP/Staff/Ban
task.spawn(function()
    local success, r = pcall(httprequest, {
        Url = API_URL .. "/check/" .. userId,
        Method = "GET",
        Headers = { ["x-token"] = API_TOKEN }
    })
    if success and r and r.Body then
        local ok, data = pcall(S.HttpService.JSONDecode, S.HttpService, r.Body)
        if ok and data then
            if data.is_banned then plr:Kick("Banido: " .. (data.reason or "Sem motivo")) return end
            is_vip = data.is_vip == true
            is_staff = data.tag == "[STAFF]" or data.tag == "[DONO]"
            SendNotify(NOME_PAINEL, "Status: VIP = " .. tostring(is_vip) .. " | Staff = " .. tostring(is_staff), 5)
        end
    end
end)

-- Temas (completo como no original)
local Themes = {
    Dark = {BackgroundColor3_title = Color3.fromRGB(0, 0, 0), BackgroundColor3_button = Color3.fromRGB(100, 100, 100), BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3_credits = Color3.fromRGB(255, 255, 255), BorderColor3 = Color3.fromRGB(45, 45, 45), ImageColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(150, 150, 150), PlaceholderTextColor3 = Color3.fromRGB(140, 140, 140)},
    Light = {BackgroundColor3_title = Color3.fromRGB(255, 255, 255), BackgroundColor3_button = Color3.fromRGB(225, 225, 225), BackgroundColor3 = Color3.fromRGB(150, 150, 150), TextColor3_credits = Color3.fromRGB(0, 0, 0), BorderColor3 = Color3.fromRGB(255, 255, 255), ImageColor3 = Color3.fromRGB(150, 150, 150), TextColor3 = Color3.fromRGB(0, 0, 0), PlaceholderTextColor3 = Color3.fromRGB(35, 35, 35)},
    Slate = {BackgroundColor3_title = Color3.fromRGB(40, 50, 60), BackgroundColor3_button = Color3.fromRGB(100, 120, 140), BackgroundColor3 = Color3.fromRGB(70, 80, 100), TextColor3_credits = Color3.fromRGB(230, 235, 240), BorderColor3 = Color3.fromRGB(60, 70, 85), ImageColor3 = Color3.fromRGB(30, 35, 45), TextColor3 = Color3.fromRGB(210, 215, 225), PlaceholderTextColor3 = Color3.fromRGB(180, 185, 195)},
    Blue = {BackgroundColor3_title = Color3.fromRGB(20, 20, 80), BackgroundColor3_button = Color3.fromRGB(80, 80, 200), BackgroundColor3 = Color3.fromRGB(60, 60, 170), TextColor3_credits = Color3.fromRGB(230, 230, 255), BorderColor3 = Color3.fromRGB(0, 0, 130), ImageColor3 = Color3.fromRGB(0, 0, 60), TextColor3 = Color3.fromRGB(210, 210, 255), PlaceholderTextColor3 = Color3.fromRGB(180, 180, 255)},
    Pink = {BackgroundColor3_title = Color3.fromRGB(80, 20, 80), BackgroundColor3_button = Color3.fromRGB(200, 80, 200), BackgroundColor3 = Color3.fromRGB(170, 60, 170), TextColor3_credits = Color3.fromRGB(255, 230, 255), BorderColor3 = Color3.fromRGB(130, 0, 130), ImageColor3 = Color3.fromRGB(60, 0, 60), TextColor3 = Color3.fromRGB(255, 210, 255), PlaceholderTextColor3 = Color3.fromRGB(255, 180, 255)},
    Violet = {BackgroundColor3_title = Color3.fromRGB(60, 0, 90), BackgroundColor3_button = Color3.fromRGB(150, 80, 200), BackgroundColor3 = Color3.fromRGB(110, 40, 160), TextColor3_credits = Color3.fromRGB(240, 220, 255), BorderColor3 = Color3.fromRGB(90, 0, 130), ImageColor3 = Color3.fromRGB(40, 0, 70), TextColor3 = Color3.fromRGB(220, 200, 245), PlaceholderTextColor3 = Color3.fromRGB(200, 170, 230)},
    Ruby = {BackgroundColor3_title = Color3.fromRGB(150, 0, 20), BackgroundColor3_button = Color3.fromRGB(220, 40, 50), BackgroundColor3 = Color3.fromRGB(190, 20, 35), TextColor3_credits = Color3.fromRGB(255, 230, 235), BorderColor3 = Color3.fromRGB(170, 0, 25), ImageColor3 = Color3.fromRGB(90, 0, 10), TextColor3 = Color3.fromRGB(245, 210, 215), PlaceholderTextColor3 = Color3.fromRGB(230, 180, 185)},
    Gold = {BackgroundColor3_title = Color3.fromRGB(180, 140, 20), BackgroundColor3_button = Color3.fromRGB(220, 180, 40), BackgroundColor3 = Color3.fromRGB(150, 110, 15), TextColor3_credits = Color3.fromRGB(255, 240, 200), BorderColor3 = Color3.fromRGB(200, 160, 30), ImageColor3 = Color3.fromRGB(120, 90, 10), TextColor3 = Color3.fromRGB(255, 230, 150), PlaceholderTextColor3 = Color3.fromRGB(230, 200, 120)},
    Sand = {BackgroundColor3_title = Color3.fromRGB(200, 180, 120), BackgroundColor3_button = Color3.fromRGB(230, 210, 150), BackgroundColor3 = Color3.fromRGB(180, 160, 100), TextColor3_credits = Color3.fromRGB(60, 50, 20), BorderColor3 = Color3.fromRGB(210, 190, 130), ImageColor3 = Color3.fromRGB(140, 120, 70), TextColor3 = Color3.fromRGB(80, 70, 30), PlaceholderTextColor3 = Color3.fromRGB(110, 100, 60)},
    Ocean = {BackgroundColor3_title = Color3.fromRGB(0, 70, 90), BackgroundColor3_button = Color3.fromRGB(40, 160, 180), BackgroundColor3 = Color3.fromRGB(20, 120, 140), TextColor3_credits = Color3.fromRGB(220, 255, 255), BorderColor3 = Color3.fromRGB(0, 100, 120), ImageColor3 = Color3.fromRGB(0, 50, 60), TextColor3 = Color3.fromRGB(200, 240, 250), PlaceholderTextColor3 = Color3.fromRGB(170, 220, 230)},
    Cyber = {BackgroundColor3_title = Color3.fromRGB(40, 0, 60), BackgroundColor3_button = Color3.fromRGB(0, 200, 255), BackgroundColor3 = Color3.fromRGB(20, 0, 40), TextColor3_credits = Color3.fromRGB(200, 255, 255), BorderColor3 = Color3.fromRGB(0, 150, 200), ImageColor3 = Color3.fromRGB(15, 0, 25), TextColor3 = Color3.fromRGB(180, 255, 255), PlaceholderTextColor3 = Color3.fromRGB(150, 230, 230)}
}

local Theme = Themes.Dark

-- Registro de elementos temáticos
local ThemedElements = {}
local function RegisterThemedElement(inst, props)
    ThemedElements[inst] = props
    for p, k in pairs(props) do if Theme[k] then inst[p] = Theme[k] end end
end

-- Funções auxiliares (todas as principais do original)
local function ChangeToggleColor(Button)
    local led = Button:FindFirstChild("Ticket_Asset") or Button:FindFirstChildWhichIsA("ImageLabel")
    if led and led.ImageColor3 == Color3.fromRGB(255, 0, 0) then 
        led.ImageColor3 = Color3.fromRGB(0, 255, 0) 
    else 
        led.ImageColor3 = Color3.fromRGB(255, 0, 0) 
    end
end

local function GetPlayer(name)
    name = name:lower()
    for _, p in pairs(S.Players:GetPlayers()) do
        if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then return p end
    end
end

local function GetRoot(player) 
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function TeleportTo(pos, player)
    local root = GetRoot(plr)
    if root then root.CFrame = CFrame.new(pos or GetRoot(player).Position + Vector3.new(0,3,0)) end
end

-- Criação das seções e botões (estrutura completa)
local SectionList = Instantiate("ScrollingFrame", {
    Name = "SectionList", Parent = Background, Position = UDim2.new(0,0,0,30), Size = UDim2.new(0,105,1,-30),
    BackgroundTransparency = 0.5, CanvasSize = UDim2.new(0,0,2,0)
})

local sections = {"Home", "VIP", "Emphasis", "Character", "Target", "Animations", "More", "Misc", "Servers", "About"}
if is_staff then table.insert(sections, 2, "STAFF") end

local SectionFrames = {}
for i, name in ipairs(sections) do
    local btn = Instantiate("TextButton", {
        Name = name, Parent = SectionList, Size = UDim2.new(1,0,0,40), Position = UDim2.new(0,0,0,(i-1)*45),
        Text = name, BackgroundTransparency = 0.5
    })
    RegisterThemedElement(btn, {BackgroundColor3 = "BackgroundColor3_button", TextColor3 = "TextColor3"})

    local frame = Instantiate("ScrollingFrame", {
        Name = name.."_Frame", Parent = Background, Position = UDim2.new(0,105,0,30), Size = UDim2.new(1,-105,1,-30),
        BackgroundTransparency = 1, Visible = (i == 1), CanvasSize = UDim2.new(0,0,3,0)
    })
    SectionFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(SectionFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Overlay VIP (só aparece se não VIP)
local vipOverlay = Instantiate("Frame", {
    Name = "VIPOverlay", Parent = SectionFrames.VIP, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.4, Visible = not is_vip
})

Instantiate("TextLabel", {
    Parent = vipOverlay, Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.25,0),
    Text = "VIP Requerido\nAcesse: discord.gg/"..discordCode, TextColor3 = Color3.fromRGB(255,220,0),
    BackgroundTransparency = 1, TextScaled = true, Font = Enum.Font.Oswald
})

-- Home - exemplo de conteúdo
local home = SectionFrames.Home
Instantiate("TextLabel", {Parent = home, Size = UDim2.new(1,0,0,50), Position = UDim2.new(0,0,0,10), Text = "Bem-vindo ao Painel Bolabola!", TextScaled = true, BackgroundTransparency = 1})

-- Botão de abrir/fechar (tecla B + botão flutuante)
local toggleBtn = Instantiate("TextButton", {
    Parent = GUI, Size = UDim2.new(0,40,0,40), Position = UDim2.new(0,10,0.5,-20), Text = "B", BackgroundTransparency = 0.3
})
toggleBtn.MouseButton1Click:Connect(function() Background.Visible = not Background.Visible end)

S.UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.B then Background.Visible = not Background.Visible end
end)

print("Painel carregado - pressione B para abrir/fechar")
