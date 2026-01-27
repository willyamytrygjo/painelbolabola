-- Painel Bonito / Dashboard Moderno (2025 style)
-- Coloque como LocalScript dentro de ScreenGui

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cria o ScreenGui principal (se não existir)
local screenGui = script.Parent
if not screenGui:IsA("ScreenGui") then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernDashboard"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
end

-- =============================================
-- Configurações visuais (mude aqui as cores/temas)
-- =============================================
local THEME = {
    Background = Color3.fromRGB(18, 18, 22),
    Accent    = Color3.fromRGB(85, 120, 255),     -- azul moderno
    AccentDark= Color3.fromRGB(65, 90, 200),
    Text      = Color3.fromRGB(235, 235, 245),
    Gray      = Color3.fromRGB(45, 45, 55),
    Stroke    = Color3.fromRGB(100, 100, 120),
    Hover     = Color3.fromRGB(35, 35, 45),
}

local CORNER_RADIUS = UDim.new(0, 12)
local PADDING       = UDim.new(0, 14)
local TWEEN_INFO    = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- =============================================
-- Cria a estrutura principal
-- =============================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0.45, 0, 0.65, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = THEME.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Gradiente de fundo (opcional - dá profundidade)
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,40)),
    ColorSequenceKeypoint.new(1, THEME.Background)
}
uiGradient.Rotation = 90
uiGradient.Parent = mainFrame

-- Cantos arredondados
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = CORNER_RADIUS
uiCorner.Parent = mainFrame

-- Borda/stroke sutil
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = THEME.Stroke
uiStroke.Transparency = 0.6
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- Sombra suave (usando ImageLabel com transparência)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"  -- sombra popular no Roblox
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.65
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49,49,450,450)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Cabeçalho
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = THEME.Gray
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim.new(0, 20, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Dashboard • Daneli"
title.TextColor3 = THEME.Text
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botão de fechar (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0.5, -17)
closeBtn.AnchorPoint = Vector2.new(1,0.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(210, 40, 40)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,8)
closeCorner.Parent = closeBtn

-- Conteúdo principal (com abas)
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -55)
content.Position = UDim2.new(0,0,0,55)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Exemplo de abas simples (pode expandir)
local tabs = {"Status", "Jogadores", "Config"}

local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
    -- Botão da aba
    local btn = Instance.new("TextButton")
    btn.Name = tabName.."Tab"
    btn.Size = UDim2.new(0, 100, 0, 38)
    btn.Position = UDim2.new(0, (i-1)*110 + 20, 0, 8)
    btn.BackgroundColor3 = THEME.Gray
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = tabName
    btn.TextColor3 = THEME.Text
    btn.TextSize = 16
    btn.Parent = header
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,10)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    -- Frame da aba (conteúdo)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tabName.."Content"
    frame.Size = UDim2.new(1, -30, 1, -30)
    frame.Position = UDim2.new(0,15,0,15)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 4
    frame.Visible = (i == 1)
    frame.Parent = content
    
    tabFrames[tabName] = frame
    
    -- Exemplo de texto dentro da aba (você coloca o que quiser)
    if tabName == "Status" then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0,40)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Bem-vindo, "..player.Name.."!\nSistema online • 2026"
        lbl.TextColor3 = THEME.Accent
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 22
        lbl.TextWrapped = true
        lbl.Parent = frame
    end
end

-- =============================================
-- Animações e interações
-- =============================================

-- Hover nos botões de aba
for _, btn in pairs(tabButtons) do
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TWEEN_INFO, {BackgroundColor3 = THEME.Hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TWEEN_INFO, {BackgroundColor3 = THEME.Gray}):Play()
    end)
end

-- Hover no botão fechar
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(230, 60, 60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(210, 40, 40)}):Play()
end)

-- Lógica de troca de abas
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        tabFrames[name].Visible = true
        
        -- Animação de destaque na aba selecionada
        for _, b in pairs(tabButtons) do
            TweenService:Create(b, TWEEN_INFO, {
                BackgroundColor3 = (b == btn) and THEME.Accent or THEME.Gray,
                TextColor3 = (b == btn) and Color3.new(1,1,1) or THEME.Text
            }):Play()
        end
    end)
end

-- Botão fechar
closeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 1.5, 0),
        Rotation = 8
    })
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Abre com animação (opcional)
mainFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0)
}):Play()

print("Painel bonito carregado! Pressione o X para fechar.")
