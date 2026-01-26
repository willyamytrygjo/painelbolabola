-- painel bolabola - versão simplificada sem salvar arquivos (para teste)

local version, discordCode, ownerId = "4.5.6", "ksxs", 3961485767
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or game.HttpGet
local S = setmetatable({}, { __index = function(t,k) local s=game:GetService(k); t[k]=s; return s end })
local plr = S.Players.LocalPlayer
local isMobile = S.UserInputService.TouchEnabled and not S.UserInputService.KeyboardEnabled

local function SendNotify(title, message, duration) 
    S.StarterGui:SetCore("SendNotification", {Title = title, Text = message, Duration = duration or 5}) 
end

-- Forçando VIP ativado
local is_vip = true
local vip_fling = "loaded"  -- placeholders para não dar erro
local vip_antifling = "loaded"
local vip_antiforce = "loaded"
local vip_antichatspy = "loaded"
local vip_autosacrifice = "loaded"
local vip_escapehandcuffs = "loaded"

-- Removendo partes de salvar arquivo (que podem falhar em alguns executores)
local savedTheme = "Dark"  -- tema default
local Theme = {  -- só o tema Dark pra simplificar
    BackgroundColor3_title = Color3.fromRGB(0, 0, 0),
    BackgroundColor3_button = Color3.fromRGB(100, 100, 100),
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    TextColor3_credits = Color3.fromRGB(255, 255, 255),
    BorderColor3 = Color3.fromRGB(45, 45, 45),
    ImageColor3 = Color3.fromRGB(25, 25, 25),
    TextColor3 = Color3.fromRGB(150, 150, 150),
    PlaceholderTextColor3 = Color3.fromRGB(140, 140, 140)
}

local function Instantiate(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props or {}) do
        pcall(function() inst[prop] = val end)
    end
    return inst
end

local function UICorner(parent, value)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(value or 0.1, 0)
end

local GUI = Instantiate("ScreenGui", {
    Name = "PainelBolaBola",
    Parent = plr:WaitForChild("PlayerGui"),
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 10
})

local Background = Instantiate("Frame", {
    Name = "Background",
    Parent = GUI,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 500, 0, 350),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.BackgroundColor3,
    BorderSizePixel = 0
})
UICorner(Background, 0.05)

local TitleBarLabel = Instantiate("TextLabel", {
    Name = "TitleBarLabel",
    Parent = Background,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.BackgroundColor3_title,
    Text = "painel bolabola",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    TextScaled = true
})
UICorner(TitleBarLabel, 0.05)

SendNotify("painel bolabola", "Painel carregado! (versão simplificada para teste)", 5)
print("Painel bolabola aberto - teste simples")
