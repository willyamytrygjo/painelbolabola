BOLABOLA.py
roberto._bolabola
Visual Studio Code
+1

BOLABOLA.py — 09/03/2026 00:34
ja fiz ate por cor
bagulho nao encontra
tmc
ksx [ksxs],  — 09/03/2026 00:34
KKKKKKKKKKKKKKKKKKK
BOLABOLA.py — 09/03/2026 00:47
local RemoteEvent = game:GetService("ReplicatedStorage").Modules.Events.RemoteEvent
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

RemoteEvent.OnClientEvent:Connect(function(arg1,arg2,arg3)

    if arg1 == "FishCaught" then
        print("Evento detectado")

        local Gui = PlayerGui:WaitForChild("CatchOrReleaseIndicator")

        task.wait(3)

        local Botao = Gui.Frame.Frame.Frame:WaitForChild("TextButton")

        if Botao then
            print("Botão filho da puta nao escontrado nessa descragraça")

            if Botao.BackgroundColor3 == Color3.fromRGB(67,200,120) then
                print("Clicando botão")
                doClick(728.29,580.33)
            else
                print("Cor diferente:",Botao.BackgroundColor3)
            end
        end

    end

end)
ksx [ksxs],  — 09/03/2026 02:13
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Event = PlayerGui.CatchOrReleaseIndicator
local GuiService = game:GetService("GuiService")
local Inset = GuiService:GetGuiInset()
local VIM = game:GetService("VirtualInputManager")

local function Click(x, y, d)
    VIM:SendMouseButtonEvent(x or 0, y or 0, 0, true, game, 0)
    if d then task.wait(d) end
    VIM:SendMouseButtonEvent(x or 0, y or 0, 0, false, game, 0)
end

Event.DescendantAdded:Connect(function(btn)
    if not btn:IsA("Frame") then
        local btnCatch = PlayerGui.CatchOrReleaseIndicator:WaitForChild("Frame").Frame.Frame.TextButton
        if btnCatch then
            local p, s = btnCatch.AbsolutePosition, btnCatch.AbsoluteSize
            task.wait(1)
            Click((p.X+(s.X/2))+Inset.X, (p.Y+(s.Y/2))+Inset.Y)
        end
    end
end)
BOLABOLA.py — 09/03/2026 02:18
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

auto pesca.lua
8 KB
ksx [ksxs],  — 10/03/2026 03:43
ta dormindo macaco?
BOLABOLA.py — 10/03/2026 05:17
claros monkey
aguentei nao llkkkkk
ksx [ksxs],  — 10/03/2026 05:18
kkkkkkkkkkkk
to aq mexendo na api
essa merda
mudei de host e nao funfa, tem que adaptar
BOLABOLA.py — 10/03/2026 05:19
kkkkkkkkkkkk
boa
ksx [ksxs],  — 10/03/2026 05:45
Tipo de arquivo em anexo: archive
readable.rar
194.66 KB
ksx [ksxs],  — 10/03/2026 05:52
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local me = Players.LocalPlayer

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local fileName = "savedPosition.txt"

if isfile(fileName) then
    local savedData = readfile(fileName)
    local x, y, z = savedData:match("([^,]+),([^,]+),([^,]+)")

    if x and y and z then
        humanoidRootPart.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
        print("Teleported to saved position: " .. savedData)

        delfile(fileName)
        print("Deleted saved position file")
    else
        print("Error: Could not parse saved position data")
    end
else
    print("No saved position found. File does not exist.")
end

local commands = {
    ["!tprj"] = function()
        local pos = humanoidRootPart.Position
        local posString = tostring(pos.X) .. "," .. tostring(pos.Y) .. "," .. tostring(pos.Z)
        writefile(fileName, posString)
        print("Saved position: " .. posString)

        task.wait(0.5)
        loadstring(game:HttpGet("https://akadmin-bzk.pages.dev/gtarejoin.lua"))()
    end
}

TextChatService.MessageReceived:Connect(function(message)
    if message.TextSource and message.TextSource.UserId == me.UserId then
        local msg = message.Text:lower()
        local cmd = msg:match("^%S+")
        if commands[cmd] then
            commands[cmd]()
        end
    end
end)
BOLABOLA.py — 10/03/2026 06:33
celular:
rbxassetid://82000918069173

pc:
rbxassetid://104665737460595
rbxassetid://85573304704706

tablet:
rbxassetid://134561146971970
ksx [ksxs],  — 10/03/2026 23:34
me ajuda desgraçado
BOLABOLA.py — 11/03/2026 00:55
voltei
ta on @ksx
ksx [ksxs],  — 11/03/2026 04:54
if getgenv().GUI_Loaded then return end; getgenv().GUI_Loaded = true

local version, discordCode, ownerId = "4.6.1", "ksxs", 3961485767
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local S = setmetatable({}, { __index = function(t,k) local s=game:GetService(k); t[k]=s; return s end })
local plr, placeId = S.Players.LocalPlayer, game.PlaceId... (56 KB restante(s))

Panel.lua
106 KB
https://github.com/bigdanix/roblox-ui-libs/tree/main/millenium
GitHub
roblox-ui-libs/millenium at main · bigdanix/roblox-ui-libs
good looking ui libraries for roblox, i will try to keep it updated and organized. each ui library was not made by me and i am only reposting them. - bigdanix/roblox-ui-libs
good looking ui libraries for roblox, i will try to keep it updated and organized. each ui library was not made by me and i am only reposting them. - bigdanix/roblox-ui-libs
ksx [ksxs],  — 13/03/2026 03:20
ué viado
que q aconteceu ai?
ksx [ksxs],  — 13/03/2026 10:19
https://dashboard.webshare.io/
BOLABOLA.py — 14/03/2026 08:51
entra call
@ksx
ksx [ksxs],  — 14/03/2026 08:52
tô call pv kkkkk
eu nem dormi ainda
vou descansar um pouco
BOLABOLA.py — 14/03/2026 08:52
entra ia no jogo rapidao
ksx [ksxs],  — 14/03/2026 08:58
192
local p,R,w,T=game.Players.LocalPlayer,game:GetService("RunService"),workspace,game:GetService("TweenService")
local function h(x) x=x:gsub("#","") return Color3.fromRGB(tonumber(x:sub(1,2),16),tonumber(x:sub(3,4),16),tonumber(x:sub(5,6),16)) end
local D={h"#003300",h"#00cc44",Color3.new(1,1,1),{"@","#","%","&","!","?","*","$","1","2","7","X","Z"}}
local C={5,60,200,50,60,15,55,14,2,0.05,1.2,5}
local function lerp(a,b,t) return a+(b-a)*t end

tag baiano.txt
4 KB
ksx [ksxs],  — 14/03/2026 21:36
cadê tu pae?
cola ai
ksx [ksxs],  — 14/03/2026 22:56
mano
o ak admin conseguiu arrumar o antiban deles
precisamos arrumar o nosso
ksx [ksxs],  — 15/03/2026 01:17
tenta ver se tem alguma url naqueles arquivos lá do ak
pq se tiver algo que leve a gente tipo pra um repositório atual deles
a gente procura o novo antiban mic deles
vai ser uma boa
BOLABOLA.py — 15/03/2026 05:20
blz
ksx [ksxs],  — 15/03/2026 05:21
eae
BOLABOLA.py — 15/03/2026 05:21
entra call
tava fazendo a lib
ksx [ksxs],  — 15/03/2026 05:21
fx
calma ai
ksx [ksxs],  — 16/03/2026 07:17
https://www.mediafire.com/file/2094dfwnvz6mwnz/YouTube_Audio_Downloader.rar/file
MediaFire
YouTube Audio Downloader
YouTube Audio Downloader
ksx [ksxs],  — 16/03/2026 22:47
https://sms24.me/en
SMS24.me
Receive SMS online | Temporary Phone Numbers | Receive SMS online
No Registration. Receive SMS online for FREE using our disposable / temporary numbers from USA, Canada, UK, Russia, Ukraine, Israel and other countries. Receive anonymous verification code from all the countries and for Instagram, Telegram, Google, Facebook, Linked and more
Imagem
ksx [ksxs],  — 17/03/2026 23:20
viadinho
bora mine dps?
BOLABOLA.py — Ontem às 22:49
freecam 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

message.txt
8 KB
auto pesca 
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

message.txt
9 KB
aimbot 
return function(plr, RunService, UserInputService, SendNotify, CreateTouchButton, key, posX, posY)
    local Camera = workspace.CurrentCamera
    local Mouse = plr:GetMouse()

    local settings = {
        Aimbot = true,

message.txt
5 KB
esp 
return function(plr, RunService, UserInputService, SendNotify, CreateTouchButton, key, posX, posY)
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera

    local PlaceId = game.PlaceId
    local IsMM2, IsArsenal = PlaceId == 142823291, PlaceId == 286090429

message.txt
7 KB
filtro
local Cores = {
    Fundo = Color3.fromRGB(20, 20, 20),
    Texto = Color3.fromRGB(255, 255, 255),
    BotaoItem = Color3.fromRGB(40, 40, 40),
    Selecionado = Color3.fromRGB(70, 70, 70),
    Subtexto = Color3.fromRGB(150, 150, 150),

message.txt
9 KB
ksx [ksxs],  — 00:37
-- KsxLib.lua | UI Library for ksx's Panel
-- Provides: Instantiate, UICorner, theming, notifications, buttons, toggles

local KsxLib = {}

-- ── Services ────────────────────────────────────────────────────────────────

KsxLib.lua
18 KB
-- Panel.lua | ksx's Panel  (usa KsxLib para UI)
if getgenv().GUI_Loaded then return end; getgenv().GUI_Loaded = true

-- ── Carrega a lib ────────────────────────────────────────────────────────────
local L = loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/KsxLib"))()
-- NOTA: ajuste a URL acima para onde você hospedar o KsxLib.lua... (50 KB restante(s))

Panel.lua
100 KB
 
ksx
ksxis
唯一
 
 
 
https://discord.gg/ksxs
-- KsxLib.lua | UI Library for ksx's Panel
-- Provides: Instantiate, UICorner, theming, notifications, buttons, toggles

local KsxLib = {}

-- ── Services ────────────────────────────────────────────────────────────────
local S = setmetatable({}, {
    __index = function(t, k)
        local s = game:GetService(k); t[k] = s; return s
    end
})
KsxLib.S = S

-- ── Helpers ──────────────────────────────────────────────────────────────────
function KsxLib.Instantiate(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do
        if val ~= nil then pcall(function() inst[prop] = val end) end
    end
    return inst
end
local Inst = KsxLib.Instantiate

function KsxLib.UICorner(parent, value)
    Inst("UICorner", { Parent = parent, CornerRadius = UDim.new(value or 0.1, 0) })
end

function KsxLib.randomString()
    local t = {}
    for i = 1, math.random(10, 20) do t[i] = string.char(math.random(32, 126)) end
    return table.concat(t)
end

-- ── Theming ──────────────────────────────────────────────────────────────────
KsxLib.Themes = {
    Dark   = { BG_title = Color3.fromRGB(0,0,0),       BG_btn = Color3.fromRGB(100,100,100), BG = Color3.fromRGB(35,35,35),       Text_credits = Color3.fromRGB(255,255,255), Border = Color3.fromRGB(45,45,45),  Image = Color3.fromRGB(25,25,25),   Text = Color3.fromRGB(150,150,150), Placeholder = Color3.fromRGB(140,140,140) },
    Light  = { BG_title = Color3.fromRGB(255,255,255),  BG_btn = Color3.fromRGB(225,225,225), BG = Color3.fromRGB(150,150,150),    Text_credits = Color3.fromRGB(0,0,0),       Border = Color3.fromRGB(255,255,255),Image = Color3.fromRGB(150,150,150),Text = Color3.fromRGB(0,0,0),       Placeholder = Color3.fromRGB(35,35,35) },
    Slate  = { BG_title = Color3.fromRGB(40,50,60),     BG_btn = Color3.fromRGB(100,120,140), BG = Color3.fromRGB(70,80,100),      Text_credits = Color3.fromRGB(230,235,240), Border = Color3.fromRGB(60,70,85),  Image = Color3.fromRGB(30,35,45),   Text = Color3.fromRGB(210,215,225), Placeholder = Color3.fromRGB(180,185,195) },
    Blue   = { BG_title = Color3.fromRGB(20,20,80),     BG_btn = Color3.fromRGB(80,80,200),   BG = Color3.fromRGB(60,60,170),      Text_credits = Color3.fromRGB(230,230,255), Border = Color3.fromRGB(0,0,130),   Image = Color3.fromRGB(0,0,60),     Text = Color3.fromRGB(210,210,255), Placeholder = Color3.fromRGB(180,180,255) },
    Pink   = { BG_title = Color3.fromRGB(80,20,80),     BG_btn = Color3.fromRGB(200,80,200),  BG = Color3.fromRGB(170,60,170),     Text_credits = Color3.fromRGB(255,230,255), Border = Color3.fromRGB(130,0,130), Image = Color3.fromRGB(60,0,60),    Text = Color3.fromRGB(255,210,255), Placeholder = Color3.fromRGB(255,180,255) },
    Violet = { BG_title = Color3.fromRGB(60,0,90),      BG_btn = Color3.fromRGB(150,80,200),  BG = Color3.fromRGB(110,40,160),     Text_credits = Color3.fromRGB(240,220,255), Border = Color3.fromRGB(90,0,130),  Image = Color3.fromRGB(40,0,70),    Text = Color3.fromRGB(220,200,245), Placeholder = Color3.fromRGB(200,170,230) },
    Ruby   = { BG_title = Color3.fromRGB(150,0,20),     BG_btn = Color3.fromRGB(220,40,50),   BG = Color3.fromRGB(190,20,35),      Text_credits = Color3.fromRGB(255,230,235), Border = Color3.fromRGB(170,0,25),  Image = Color3.fromRGB(90,0,10),    Text = Color3.fromRGB(245,210,215), Placeholder = Color3.fromRGB(230,180,185) },
    Gold   = { BG_title = Color3.fromRGB(180,140,20),   BG_btn = Color3.fromRGB(220,180,40),  BG = Color3.fromRGB(150,110,15),     Text_credits = Color3.fromRGB(255,240,200), Border = Color3.fromRGB(200,160,30),Image = Color3.fromRGB(120,90,10),  Text = Color3.fromRGB(255,230,150), Placeholder = Color3.fromRGB(230,200,120) },
    Sand   = { BG_title = Color3.fromRGB(200,180,120),  BG_btn = Color3.fromRGB(230,210,150), BG = Color3.fromRGB(180,160,100),    Text_credits = Color3.fromRGB(60,50,20),    Border = Color3.fromRGB(210,190,130),Image = Color3.fromRGB(140,120,70), Text = Color3.fromRGB(80,70,30),    Placeholder = Color3.fromRGB(110,100,60) },
    Ocean  = { BG_title = Color3.fromRGB(0,70,90),      BG_btn = Color3.fromRGB(40,160,180),  BG = Color3.fromRGB(20,120,140),     Text_credits = Color3.fromRGB(220,255,255), Border = Color3.fromRGB(0,100,120), Image = Color3.fromRGB(0,50,60),    Text = Color3.fromRGB(200,240,250), Placeholder = Color3.fromRGB(170,220,230) },
    Cyber  = { BG_title = Color3.fromRGB(40,0,60),      BG_btn = Color3.fromRGB(0,200,255),   BG = Color3.fromRGB(20,0,40),        Text_credits = Color3.fromRGB(200,255,255), Border = Color3.fromRGB(0,150,200), Image = Color3.fromRGB(15,0,25),    Text = Color3.fromRGB(180,255,255), Placeholder = Color3.fromRGB(150,230,230) },
}

-- Map old theme keys to new compact keys (for RegisterThemedElement compatibility)
local KEY_MAP = {
    BackgroundColor3_title  = "BG_title",
    BackgroundColor3_button = "BG_btn",
    BackgroundColor3        = "BG",
    TextColor3_credits      = "Text_credits",
    BorderColor3            = "Border",
    ImageColor3             = "Image",
    TextColor3              = "Text",
    PlaceholderColor3       = "Placeholder",
    PlaceholderTextColor3   = "Placeholder",
}

local ThemedElements = {}
KsxLib.ThemedElements = ThemedElements
KsxLib.Theme = KsxLib.Themes.Dark

function KsxLib.RegisterThemedElement(instance, properties)
    ThemedElements[instance] = properties
    local theme = KsxLib.Theme
    for prop, rawKey in pairs(properties) do
        local key = KEY_MAP[rawKey] or rawKey
        local val = theme[key]
        if val then pcall(function() instance[prop] = val end) end
    end
end
local Register = KsxLib.RegisterThemedElement

function KsxLib.ApplyTheme(theme)
    KsxLib.Theme = theme
    for instance, properties in pairs(ThemedElements) do
        if instance and instance.Parent then
            for prop, rawKey in pairs(properties) do
                local key = KEY_MAP[rawKey] or rawKey
                local val = theme[key]
                if val then pcall(function() instance[prop] = val end) end
            end
        end
    end
end

-- ── Notification System ───────────────────────────────────────────────────────
local NotifyList, NotifyLayout

function KsxLib.InitNotifications(gui)
    NotifyList = Inst("Frame", {
        Name = "NotifyList", Parent = gui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -50), Size = UDim2.new(0, 260, 1, -50),
        AnchorPoint = Vector2.new(1, 1), ZIndex = 100
    })
    NotifyLayout = Inst("UIListLayout", {
        Parent = NotifyList,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
end

function KsxLib.Notify(title, message, duration)
    duration = duration or 3
    local height = #message > 40 and 85 or 70

    local frame = Inst("Frame", {
        Parent = NotifyList,
        BackgroundTransparency = 0.05, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true
    })
    KsxLib.UICorner(frame, 0.1)
    Register(frame, { BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3" })

    local accent = Inst("Frame", {
        Parent = frame, BorderSizePixel = 0,
        Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,4,1,0), ZIndex = 102
    })
    KsxLib.UICorner(accent, 0)
    Register(accent, { BackgroundColor3 = "BackgroundColor3_button" })

    local titleLbl = Inst("TextLabel", {
        Parent = frame, BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,6), Size = UDim2.new(1,-15,0,20),
        Text = title, Font = Enum.Font.Oswald,
        TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true, AutoLocalize = false, ZIndex = 102
    })
    Register(titleLbl, { TextColor3 = "TextColor3" })

    local msgLbl = Inst("TextLabel", {
        Parent = frame, BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,28), Size = UDim2.new(1,-15,1,-26),
        Text = message, Font = Enum.Font.Gotham,
        TextSize = 13, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        RichText = true, AutoLocalize = false, ZIndex = 102
    })
    Register(msgLbl, { TextColor3 = "TextColor3" })

    local progressBg = Inst("Frame", {
        Parent = frame, BorderSizePixel = 0,
        Position = UDim2.new(0,0,1,-3), Size = UDim2.new(1,0,0,3),
        BackgroundColor3 = Color3.fromRGB(40,40,40), ZIndex = 103
    })
    local progressBar = Inst("Frame", {
        Parent = progressBg, BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0), ZIndex = 104
    })
    Register(progressBar, { BackgroundColor3 = "BackgroundColor3_button" })

    local TweenService = S.TweenService
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(1, 0, 0, height) }):Play()
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0, 0, 1, 0) }):Play()

    task.delay(duration, function()
        if not (frame and frame.Parent) then return end
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        ThemedElements[frame] = nil; ThemedElements[accent] = nil
        ThemedElements[titleLbl] = nil; ThemedElements[msgLbl] = nil
        ThemedElements[progressBar] = nil
        frame:Destroy()
    end)
end

-- ── Button Builders ───────────────────────────────────────────────────────────

-- Indicator assets stored in a folder
local Assets
function KsxLib.InitAssets(parent)
    Assets = Inst("Folder", { Name = "KsxAssets", Parent = parent or game:GetService("CoreGui") })
    return Assets
end

-- Toggle LED (red/green dot on button)
local TicketTemplate
function KsxLib.GetTicketTemplate()
    if TicketTemplate then return TicketTemplate end
    TicketTemplate = Inst("ImageButton", {
        Name = "Ticket_Asset", Parent = Assets,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(1,5,0.5,0), Size = UDim2.new(0,25,0,25),
        AnchorPoint = Vector2.new(0,0.5),
        Image = "rbxassetid://3926305904",
        ImageColor3 = Color3.fromRGB(255,0,0),
        ImageRectSize = Vector2.new(36,36),
        ImageRectOffset = Vector2.new(424,4),
        LayoutOrder = 5, ZIndex = 2
    })
    return TicketTemplate
end

-- Click indicator (grey dot)
local ClickTemplate
function KsxLib.GetClickTemplate()
    if ClickTemplate then return ClickTemplate end
    ClickTemplate = Inst("ImageButton", {
        Name = "Click_Asset", Parent = Assets,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(1,5,0.5,0), Size = UDim2.new(0,25,0,25),
        AnchorPoint = Vector2.new(0,0.5),
        Image = "rbxassetid://3926305904",
        ImageColor3 = Color3.fromRGB(100,100,100),
        ImageRectSize = Vector2.new(36,36),
        ImageRectOffset = Vector2.new(204,964),
        ZIndex = 2
    })
    return ClickTemplate
end

function KsxLib.CreateToggle(btn)
    local t = KsxLib.GetTicketTemplate():Clone(); t.Parent = btn
end
function KsxLib.CreateClicker(btn)
    local c = KsxLib.GetClickTemplate():Clone(); c.Parent = btn
end

function KsxLib.ChangeToggleColor(btn)
    local led = btn:FindFirstChild("Ticket_Asset")
    if not led then return end
    if led.ImageColor3 == Color3.fromRGB(255,0,0) then
        led.ImageColor3 = Color3.fromRGB(0,255,0)
    else
        led.ImageColor3 = Color3.fromRGB(255,0,0)
    end
end

-- Modern rounded button with hover/press tween
function KsxLib.MakeButton(name, parent, position, size, isTextBox, placeholder)
    local btn
    if isTextBox then
        btn = Inst("TextBox", {
            Name = name, Parent = parent,
            BackgroundTransparency = 0.3, BorderSizePixel = 0,
            Position = position, Size = size or UDim2.new(0,150,0,30),
            Text = "", PlaceholderText = placeholder or "",
            Font = Enum.Font.Gotham, TextSize = 16,
            TextWrapped = true, ClearTextOnFocus = true,
            AutoLocalize = false
        })
        Register(btn, { BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3", PlaceholderColor3 = "PlaceholderTextColor3" })
    else
        btn = Inst("TextButton", {
            Name = name, Parent = parent,
            BackgroundTransparency = 0.25, BorderSizePixel = 0,
            Position = position, Size = size or UDim2.new(0,150,0,30),
            Text = name, Font = Enum.Font.GothamBold,
            TextSize = 13, TextScaled = true, TextWrapped = true,
            AutoLocalize = false, AutoButtonColor = false
        })
        Register(btn, { BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3" })

        -- Hover / press micro-animations
        local base = 0.25
        btn.MouseEnter:Connect(function()
            S.TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.1 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            S.TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { BackgroundTransparency = base }):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            S.TweenService:Create(btn, TweenInfo.new(0.06, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.45 }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            S.TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.1 }):Play()
        end)
    end
    KsxLib.UICorner(btn, 0.25)
    return btn
end

-- Grid-position helper (same layout as original CreateSectionFrameButton)
function KsxLib.MakeGridButton(name, parent, order, xOverride, yOverride, isTextBox, placeholder, size)
    local xPos = xOverride or ((order % 2 == 1) and 25 or 210)
    local yPos = (25 + math.floor((order - 1) / 2) * 50) + (yOverride or 0)
    return KsxLib.MakeButton(name, parent, UDim2.new(0, xPos, 0, yPos), size or UDim2.new(0,150,0,30), isTextBox, placeholder)
end

-- Section nav button (sidebar)
function KsxLib.MakeSectionButton(name, parent, order)
    local yPos = 5 + (order - 1) * 40
    local btn = Inst("TextButton", {
        Name = name, Parent = parent,
        BackgroundTransparency = 0.4, BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, yPos), Size = UDim2.new(1, -10, 0, 32),
        Text = name, Font = Enum.Font.GothamBold,
        TextSize = 13, TextScaled = true, TextWrapped = true,
        AutoLocalize = false, AutoButtonColor = false
    })
    KsxLib.UICorner(btn, 0.3)
    Register(btn, { BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3" })

    btn.MouseEnter:Connect(function()
        S.TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.15 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        S.TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
    end)
    return btn
end

-- Label helper
function KsxLib.MakeLabel(name, parent, text, position, size, font, textsize)
    local lbl = Inst("TextLabel", {
        Name = name, Parent = parent,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = position, Size = size,
        Text = text, Font = font or Enum.Font.SourceSans,
        TextSize = textsize or 24, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        RichText = true, AutoLocalize = false
    })
    Register(lbl, { BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3" })
    return lbl
end

-- Link label
function KsxLib.MakeLink(name, parent, text, position, size, textsize)
    local lbl = KsxLib.MakeLabel(name, parent, text, position, size, nil, textsize)
    lbl.Active = true
    lbl.TextColor3 = Color3.fromRGB(0, 100, 255)
    Register(lbl, { TextColor3 = lbl.TextColor3 })
    return lbl
end

-- Section frame (scrolling)
function KsxLib.MakeSectionFrame(name, parent, visible, scrollsize)
    local frame = Inst("ScrollingFrame", {
        Name = name, Parent = parent, Active = true, Visible = visible,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 110, 0, 34), Size = UDim2.new(0, 390, 0, 316),
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, scrollsize or 0, 0),
        ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
    })
    Register(frame, { BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3" })
    return frame
end

return KsxLib
KsxLib.lua
18 KB
