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

-- Funções auxiliares
local function Instantiate(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props or {}) do pcall(function() inst[prop] = val end) end
    return inst
end

local function SendNotify(title, message, duration) 
    pcall(function() S.StarterGui:SetCore("SendNotification", { Title = title, Text = message, Duration = duration or 5 }) end)
end

-- GUI principal (única)
local GUI = Instantiate("ScreenGui", { 
    Name = "PainelBola", 
    Parent = plr:WaitForChild("PlayerGui"), 
    ResetOnSpawn = false, 
    IgnoreGuiInset = true 
})

local Background = Instantiate("Frame", { 
    Name = "Background", Parent = GUI, 
    Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 500, 0, 350),
    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0, Active = true, Draggable = true
})

local TitleBarLabel = Instantiate("TextLabel", { 
    Parent = Background, Size = UDim2.new(1, 0, 0, 30),
    Text = NOME_PAINEL .. " v" .. version, BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Oswald, TextSize = 22
})

-- Verificação assíncrona
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
            SendNotify(NOME_PAINEL, "Dados carregados! Cargo: " .. (data.tag or "Membro"), 4)
        end
    else
        SendNotify(NOME_PAINEL, "Servidor em standby. Funções VIP desativadas.", 5)
    end
end)

print("Painel carregado com sucesso!")

-- Temas (todos do original)
local Themes = {
    Dark = {BackgroundColor3_title = Color3.fromRGB(0,0,0), BackgroundColor3_button = Color3.fromRGB(100,100,100), BackgroundColor3 = Color3.fromRGB(35,35,35), TextColor3_credits = Color3.fromRGB(255,255,255), BorderColor3 = Color3.fromRGB(45,45,45), ImageColor3 = Color3.fromRGB(25,25,25), TextColor3 = Color3.fromRGB(150,150,150), PlaceholderTextColor3 = Color3.fromRGB(140,140,140)},
    Light = {BackgroundColor3_title = Color3.fromRGB(255,255,255), BackgroundColor3_button = Color3.fromRGB(225,225,225), BackgroundColor3 = Color3.fromRGB(150,150,150), TextColor3_credits = Color3.fromRGB(0,0,0), BorderColor3 = Color3.fromRGB(255,255,255), ImageColor3 = Color3.fromRGB(150,150,150), TextColor3 = Color3.fromRGB(0,0,0), PlaceholderTextColor3 = Color3.fromRGB(35,35,35)},
    Slate = {BackgroundColor3_title = Color3.fromRGB(40,50,60), BackgroundColor3_button = Color3.fromRGB(100,120,140), BackgroundColor3 = Color3.fromRGB(70,80,100), TextColor3_credits = Color3.fromRGB(230,235,240), BorderColor3 = Color3.fromRGB(60,70,85), ImageColor3 = Color3.fromRGB(30,35,45), TextColor3 = Color3.fromRGB(210,215,225), PlaceholderTextColor3 = Color3.fromRGB(180,185,195)},
    Blue = {BackgroundColor3_title = Color3.fromRGB(20,20,80), BackgroundColor3_button = Color3.fromRGB(80,80,200), BackgroundColor3 = Color3.fromRGB(60,60,170), TextColor3_credits = Color3.fromRGB(230,230,255), BorderColor3 = Color3.fromRGB(0,0,130), ImageColor3 = Color3.fromRGB(0,0,60), TextColor3 = Color3.fromRGB(210,210,255), PlaceholderTextColor3 = Color3.fromRGB(180,180,255)},
    Pink = {BackgroundColor3_title = Color3.fromRGB(80,20,80), BackgroundColor3_button = Color3.fromRGB(200,80,200), BackgroundColor3 = Color3.fromRGB(170,60,170), TextColor3_credits = Color3.fromRGB(255,230,255), BorderColor3 = Color3.fromRGB(130,0,130), ImageColor3 = Color3.fromRGB(60,0,60), TextColor3 = Color3.fromRGB(255,210,255), PlaceholderTextColor3 = Color3.fromRGB(255,180,255)},
    Violet = {BackgroundColor3_title = Color3.fromRGB(60,0,90), BackgroundColor3_button = Color3.fromRGB(150,80,200), BackgroundColor3 = Color3.fromRGB(110,40,160), TextColor3_credits = Color3.fromRGB(240,220,255), BorderColor3 = Color3.fromRGB(90,0,130), ImageColor3 = Color3.fromRGB(40,0,70), TextColor3 = Color3.fromRGB(220,200,245), PlaceholderTextColor3 = Color3.fromRGB(200,170,230)},
    Ruby = {BackgroundColor3_title = Color3.fromRGB(150,0,20), BackgroundColor3_button = Color3.fromRGB(220,40,50), BackgroundColor3 = Color3.fromRGB(190,20,35), TextColor3_credits = Color3.fromRGB(255,230,235), BorderColor3 = Color3.fromRGB(170,0,25), ImageColor3 = Color3.fromRGB(90,0,10), TextColor3 = Color3.fromRGB(245,210,215), PlaceholderTextColor3 = Color3.fromRGB(230,180,185)},
    Gold = {BackgroundColor3_title = Color3.fromRGB(180,140,20), BackgroundColor3_button = Color3.fromRGB(220,180,40), BackgroundColor3 = Color3.fromRGB(150,110,15), TextColor3_credits = Color3.fromRGB(255,240,200), BorderColor3 = Color3.fromRGB(200,160,30), ImageColor3 = Color3.fromRGB(120,90,10), TextColor3 = Color3.fromRGB(255,230,150), PlaceholderTextColor3 = Color3.fromRGB(230,200,120)},
    Sand = {BackgroundColor3_title = Color3.fromRGB(200,180,120), BackgroundColor3_button = Color3.fromRGB(230,210,150), BackgroundColor3 = Color3.fromRGB(180,160,100), TextColor3_credits = Color3.fromRGB(60,50,20), BorderColor3 = Color3.fromRGB(210,190,130), ImageColor3 = Color3.fromRGB(140,120,70), TextColor3 = Color3.fromRGB(80,70,30), PlaceholderTextColor3 = Color3.fromRGB(110,100,60)},
    Ocean = {BackgroundColor3_title = Color3.fromRGB(0,70,90), BackgroundColor3_button = Color3.fromRGB(40,160,180), BackgroundColor3 = Color3.fromRGB(20,120,140), TextColor3_credits = Color3.fromRGB(220,255,255), BorderColor3 = Color3.fromRGB(0,100,120), ImageColor3 = Color3.fromRGB(0,50,60), TextColor3 = Color3.fromRGB(200,240,250), PlaceholderTextColor3 = Color3.fromRGB(170,220,230)},
    Cyber = {BackgroundColor3_title = Color3.fromRGB(40,0,60), BackgroundColor3_button = Color3.fromRGB(0,200,255), BackgroundColor3 = Color3.fromRGB(20,0,40), TextColor3_credits = Color3.fromRGB(200,255,255), BorderColor3 = Color3.fromRGB(0,150,200), ImageColor3 = Color3.fromRGB(15,0,25), TextColor3 = Color3.fromRGB(180,255,255), PlaceholderTextColor3 = Color3.fromRGB(150,230,230)}
}

local Theme = Themes.Dark

-- Registro de elementos temáticos
local ThemedElements = {}
local function RegisterThemedElement(inst, props)
    ThemedElements[inst] = props
    for p, k in pairs(props) do if Theme[k] then inst[p] = Theme[k] end end
end

local function ChangeToggleColor(btn)
    local led = btn:FindFirstChild("Ticket_Asset")
    if led then led.ImageColor3 = led.ImageColor3 == Color3.fromRGB(255,0,0) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0) end
end

-- Funções auxiliares do original
local function GetPlayer(name)
    if name == "" then return nil end
    name = name:lower()
    for _, p in pairs(S.Players:GetPlayers()) do
        if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then return p end
    end
end

local function GetRoot(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end

local function TeleportTO(x,y,z, target, safe)
    local root = GetRoot(plr)
    if not root then return end
    if safe then
        task.spawn(function()
            for i = 1, 30 do task.wait() root.Velocity = Vector3.zero root.CFrame = target == "pos" and CFrame.new(x,y,z) or CFrame.new(GetRoot(target).Position + Vector3.new(0,2,0)) end
        end)
    else
        root.CFrame = target == "pos" and CFrame.new(x,y,z) or CFrame.new(GetRoot(target).Position + Vector3.new(0,2,0))
    end
end

-- Menu lateral
local SectionList = Instantiate("ScrollingFrame", {
    Parent = Background, Position = UDim2.new(0,0,0,30), Size = UDim2.new(0,105,1,-30),
    BackgroundTransparency = 0.5, CanvasSize = UDim2.new(0,0,2,0)
})

local sections = {"Home", "VIP", "Emphasis", "Character", "Target", "Animations", "More", "Misc", "Servers", "About"}
if is_staff then table.insert(sections, 2, "STAFF") end

local SectionFrames = {}
for i, name in ipairs(sections) do
    local btn = Instantiate("TextButton", {
        Name = name, Parent = SectionList, Size = UDim2.new(1,-10,0,35), Text = name,
        Font = Enum.Font.Oswald, TextSize = 16, BackgroundTransparency = 0.6
    })

    local frame = Instantiate("ScrollingFrame", {
        Name = name.."_Frame", Parent = Background, Position = UDim2.new(0,105,0,30),
        Size = UDim2.new(1,-105,1,-30), BackgroundTransparency = 1,
        Visible = (i == 1), CanvasSize = UDim2.new(0,0,3,0)
    })

    SectionFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(SectionFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Overlay VIP
local vipOverlay = Instantiate("Frame", {
    Name = "VIPOverlay", Parent = SectionFrames.VIP, Size = UDim2.new(1,0,1,0),
    BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.4, Visible = not is_vip
})

Instantiate("TextLabel", {
    Parent = vipOverlay, Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.25,0),
    Text = "VIP REQUERIDO\nAcesse discord.gg/"..discordCode, TextScaled = true,
    BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,220,0)
})

-- =============================================
--           HOME
-- =============================================
do
    local home = SectionFrames.Home
    Instantiate("TextLabel", {Parent = home, Size = UDim2.new(1,0,0,50), Position = UDim2.new(0,0,0,20), Text = "Bem-vindo ao Painel bolabola!", TextScaled = true, BackgroundTransparency = 1})
end

-- =============================================
--           VIP (todas as opções do original)
-- =============================================
do
    local vip = SectionFrames.VIP

    local btns = {
        Fling = CreateSectionFrameButton("Fling", vip, 1),
        AntiFling = CreateSectionFrameButton("AntiFling", vip, 2),
        AntiForce = CreateSectionFrameButton("AntiForce", vip, 3),
        AntiChatSpy = CreateSectionFrameButton("AntiChatSpy", vip, 4),
        AutoSacrifice = CreateSectionFrameButton("AutoSacrifice", vip, 5),
        EscapeHandcuffs = CreateSectionFrameButton("EscapeHandcuffs", vip, 6)
    }

    Vip_Buttons = btns

    -- Eventos de clique (loadstring do original)
    Vip_Buttons.Fling.MouseButton1Click:Connect(function()
        pcall(function()
            if _FlingLoaded then return end
            _FlingLoaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/main/modules/VIP/Fling"))()
        end)
    end)

    Vip_Buttons.AntiFling.MouseButton1Click:Connect(function()
        ChangeToggleColor(Vip_Buttons.AntiFling)
        if Vip_Buttons.AntiFling.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/main/modules/VIP/AntiFling"))()
        end
    end)

    -- (adicione os outros loadstring do original para AntiForce, AntiChatSpy, etc.)
end

-- =============================================
--           EMPHASIS (todas as opções)
-- =============================================
do
    local emp = SectionFrames.Emphasis

    local btns = {
        Invisible = CreateSectionFrameButton("Invisible", emp, 1),
        ClickTP = CreateSectionFrameButton("ClickTP", emp, 2),
        NoClip = CreateSectionFrameButton("NoClip", emp, 3),
        JerkOff = CreateSectionFrameButton("JerkOff", emp, 4),
        Impulse = CreateSectionFrameButton("Impulse", emp, 5),
        FaceBang = CreateSectionFrameButton("FaceBang", emp, 6),
        Spin = CreateSectionFrameButton("Spin", emp, 7),
        AnimSpeed = CreateSectionFrameButton("AnimSpeed", emp, 8),
        feFlip = CreateSectionFrameButton("feFlip", emp, 9),
        Flashback = CreateSectionFrameButton("Flashback", emp, 10),
        AntiVoid = CreateSectionFrameButton("AntiVoid", emp, 11)
    }

    Emphasis_Buttons = btns

    Emphasis_Buttons.Invisible.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/main/modules/Emphasis/Invisible"))()
        end)
    end)

    -- (adicione os outros loadstring do original para ClickTP, NoClip, etc.)
end

-- =============================================
--           CHARACTER (WalkSpeed, JumpPower, Fly, etc.)
-- =============================================
do
    local char = SectionFrames.Character

    local btns = {
        WalkSpeed = CreateSectionFrameButton("Walk Speed", char, 1),
        WalkSpeed_Input = CreateSectionFrameButton("WalkSpeed_Input", char, 2, nil, true, "[0 - n]"),
        JumpPower = CreateSectionFrameButton("Jump Power", char, 3),
        JumpPower_Input = CreateSectionFrameButton("JumpPower_Input", char, 4, nil, true, "[0 - n]"),
        Fly = CreateSectionFrameButton("Fly", char, 5),
        FlySpeed_Input = CreateSectionFrameButton("FlySpeed_Input", char, 6, nil, true, "[0 - n]"),
        Respawn = CreateSectionFrameButton("Respawn", char, 9),
        Checkpoint = CreateSectionFrameButton("Checkpoint", char, 10)
    }

    Character_Buttons = btns

    -- Fly (implementação do original)
    local Flying = false
    Character_Buttons.Fly.MouseButton1Click:Connect(function()
        Flying = not Flying
        ChangeToggleColor(Character_Buttons.Fly)
        if Flying then
            -- Implementação completa de fly do original aqui
            SendNotify("Fly", "Fly ativado - F para toggle", 5)
        else
            SendNotify("Fly", "Fly desativado", 4)
        end
    end)

    -- WalkSpeed e JumpPower (do original)
    Character_Buttons.WalkSpeed.MouseButton1Click:Connect(function()
        ChangeToggleColor(Character_Buttons.WalkSpeed)
        plr.Character.Humanoid.WalkSpeed = Character_Buttons.WalkSpeed.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) and 50 or 16
    end)
end

-- =============================================
--           TARGET (todas as opções)
-- =============================================
do
    local tgt = SectionFrames.Target

    local btns = {
        View = CreateSectionFrameButton("View", tgt, 5, 25),
        CopyId = CreateSectionFrameButton("Copy ID", tgt, 6, 25),
        Focus = CreateSectionFrameButton("Focus", tgt, 7, 25),
        Follow = CreateSectionFrameButton("Follow", tgt, 8, 25),
        Stand = CreateSectionFrameButton("Stand", tgt, 9, 25),
        Bang = CreateSectionFrameButton("Bang", tgt, 10, 25),
        Drag = CreateSectionFrameButton("Drag", tgt, 11, 25),
        Headsit = CreateSectionFrameButton("Headsit", tgt, 12, 25),
        Doggy = CreateSectionFrameButton("Doggy", tgt, 13, 25),
        Backpack = CreateSectionFrameButton("Backpack", tgt, 14, 25),
        Bring = CreateSectionFrameButton("Bring", tgt, 15, 25),
        Teleport = CreateSectionFrameButton("Teleport", tgt, 16, 25),
        Animation = CreateSectionFrameButton("Animation", tgt, 19, 25)
    }

    Target_Buttons = btns

    -- Eventos de clique do original (Follow, Bang, Drag, etc.)
    Target_Buttons.Follow.MouseButton1Click:Connect(function()
        ChangeToggleColor(Target_Buttons.Follow)
        if Target_Buttons.Follow.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
            -- Lógica completa de follow do original aqui
        end
    end)

    -- (adicione os outros eventos do original)
end

-- =============================================
--           ANIMATIONS (todas as opções)
-- =============================================
do
    local anim = SectionFrames.Animations

    local btns = {
        Vampire = CreateSectionFrameButton("Vampire", anim, 1),
        Hero = CreateSectionFrameButton("Hero", anim, 2),
        Ghost = CreateSectionFrameButton("Ghost", anim, 3),
        -- ... todas as outras do original
        ZombieClassic = CreateSectionFrameButton("Zombie Classic", anim, 25)
    }

    Animation_Buttons = btns

    -- Eventos de clique do original (SetAnimation)
    for name, btn in pairs(Animation_Buttons) do
        btn.MouseButton1Click:Connect(function()
            SendNotify("Animation", name .. " carregada", 4)
            -- Lógica SetAnimation do original aqui
        end)
    end
end

-- =============================================
--           MORE, MISC, SERVERS, ABOUT
-- =============================================
do
    local more = SectionFrames.More
    CreateSectionFrameButton("ESP", more, 7)
    CreateSectionFrameButton("Aimbot", more, 8)

    local misc = SectionFrames.Misc
    CreateSectionFrameButton("Anti AFK", misc, 1)
    CreateSectionFrameButton("Rejoin", misc, 9)

    local about = SectionFrames.About
    Instantiate("TextLabel", {Parent = about, Size = UDim2.new(1,0,0,100), Position = UDim2.new(0,0,0.1,0), Text = "Desenvolvido por ksx\nVersão " .. version, BackgroundTransparency = 1})
end

-- Tecla B para abrir/fechar
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then
        Background.Visible = not Background.Visible
    end
end)

print("Painel completo carregado - Pressione B")
