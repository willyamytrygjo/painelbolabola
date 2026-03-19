--[[
    ksx's Panel  –  UI Library  v1.3.0
    Author: ksx

    BOTÕES TOPBAR:
      🔴 Vermelho → Destrói o painel permanentemente
      🟢 Verde    → Alterna tela cheia / tamanho normal (CORRIGIDO)
      🟡 Amarelo  → Fecha (oculta); pressione toggleKey para reabrir

    CORREÇÕES v1.3:
      - Ícones rbxassetid sem tint de cor (aparecem corretos)
      - Scroll funciona em todas as abas sem corte
      - Botão verde (fullscreen) funciona corretamente
      - Dropdown não corta mais com ClipsDescendants
]]

local KsxPanel = {}
KsxPanel.__index = KsxPanel
KsxPanel.Version = "1.3.0"

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- ─────────────────────────────────────────────
--  Theme
-- ─────────────────────────────────────────────
local Theme = {
    BG            = Color3.fromHex("#0d0d12"),
    BGPanel       = Color3.fromHex("#13131a"),
    BGElement     = Color3.fromHex("#1a1a24"),
    BGHover       = Color3.fromHex("#20202e"),
    Border        = Color3.fromHex("#2a2a3d"),
    Accent        = Color3.fromHex("#7c6ff7"),
    AccentDim     = Color3.fromHex("#4e4899"),
    TextPrimary   = Color3.fromHex("#e8e6ff"),
    TextSecondary = Color3.fromHex("#8884aa"),
    TextMuted     = Color3.fromHex("#55527a"),
    ToggleOn      = Color3.fromHex("#7c6ff7"),
    ToggleOff     = Color3.fromHex("#2a2a3d"),
}

local _bgReg     = {}
local _accentReg = {}

local function regBG(obj, prop, key)
    table.insert(_bgReg, {obj=obj, prop=prop, key=key})
    pcall(function() obj[prop] = Theme[key] end)
end
local function regAcc(obj, prop)
    table.insert(_accentReg, {obj=obj, prop=prop})
    pcall(function() obj[prop] = Theme.Accent end)
end

function KsxPanel:SetTheme(bg, panel, element)
    if bg      then Theme.BG        = bg end
    if panel   then Theme.BGPanel   = panel end
    if element then
        Theme.BGElement = element
        Theme.BGHover   = element:Lerp(Color3.new(1,1,1), 0.07)
    end
    for _, e in ipairs(_bgReg) do
        pcall(function() e.obj[e.prop] = Theme[e.key] end)
    end
end

function KsxPanel:SetAccent(color)
    Theme.Accent    = color
    Theme.AccentDim = color:Lerp(Color3.new(0,0,0), 0.38)
    Theme.ToggleOn  = color
    for _, e in ipairs(_accentReg) do
        pcall(function() e.obj[e.prop] = color end)
    end
end

-- Presets de tema (mapeados das cores originais do ksx Panel)
-- bg=BackgroundColor3  panel=BackgroundColor3_title  elem=BackgroundColor3_button  accent=BackgroundColor3_button
KsxPanel.ThemePresets = {
    { name="Dark",   bg="#232323", panel="#000000", elem="#646464", accent="#646464" },
    { name="Light",  bg="#969696", panel="#ffffff", elem="#e1e1e1", accent="#5a5aaa" },
    { name="Slate",  bg="#465064", panel="#28323c", elem="#64788c", accent="#64788c" },
    { name="Blue",   bg="#3c3caa", panel="#141450", elem="#5050c8", accent="#5050c8" },
    { name="Pink",   bg="#aa3caa", panel="#501450", elem="#c850c8", accent="#c850c8" },
    { name="Violet", bg="#6e28a0", panel="#3c005a", elem="#9650c8", accent="#9650c8" },
    { name="Ruby",   bg="#be1423", panel="#960014", elem="#dc2832", accent="#dc2832" },
    { name="Gold",   bg="#966e0f", panel="#b48c14", elem="#dcb428", accent="#dcb428" },
    { name="Sand",   bg="#b4a064", panel="#c8b478", elem="#e6d296", accent="#c8a01e" },
    { name="Ocean",  bg="#14788c", panel="#00465a", elem="#28a0b4", accent="#28a0b4" },
    { name="Cyber",  bg="#140028", panel="#28003c", elem="#00c8ff", accent="#00c8ff" },
}

-- ─────────────────────────────────────────────
--  Helpers
-- ─────────────────────────────────────────────
local function tw(obj, props, t, sty, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or .18, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function new(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do
        pcall(function() o[k] = v end)
    end
    return o
end

local function corner(parent, r)
    local c = new("UICorner", {CornerRadius=UDim.new(0, r or 8)})
    c.Parent = parent
end

local function makeDraggable(frame, handle)
    local drag, di, mp, fp = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true; mp=i.Position; fp=frame.Position
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then di=i end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i == di then
            local d = i.Position - mp
            frame.Position = UDim2.new(fp.X.Scale, fp.X.Offset+d.X, fp.Y.Scale, fp.Y.Offset+d.Y)
        end
    end)
end

local function makeRipple(btn, colorFn)
    btn.ClipsDescendants = true
    btn.MouseButton1Click:Connect(function()
        local col = (colorFn and colorFn()) or Theme.Accent
        local rx = Mouse.X - btn.AbsolutePosition.X
        local ry = Mouse.Y - btn.AbsolutePosition.Y
        local r = new("Frame", {
            AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromOffset(rx,ry),
            Size=UDim2.fromOffset(0,0), BackgroundColor3=col,
            BackgroundTransparency=.75, ZIndex=btn.ZIndex+5, Parent=btn,
        })
        corner(r, 999)
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.4
        tw(r, {Size=UDim2.fromOffset(sz,sz), BackgroundTransparency=1}, .5)
        task.delay(.55, function() r:Destroy() end)
    end)
end

-- ícone na sidebar: imagens SEM tint (aparecem com as cores originais do asset)
local function makeSideIcon(parent, iconStr)
    if not iconStr or iconStr == "" then return nil end
    local isAsset = iconStr:match("^rbxassetid://") or (tonumber(iconStr) ~= nil)
    if isAsset then
        local id = iconStr:match("^rbxassetid://(.+)$") or iconStr
        local img = new("ImageLabel", {
            AnchorPoint=Vector2.new(0,.5), Position=UDim2.fromOffset(8,0),
            Size=UDim2.fromOffset(18,18), BackgroundTransparency=1,
            Image="rbxassetid://"..id,
            -- SEM ImageColor3 override → imagem aparece com suas cores originais
            ZIndex=6, Parent=parent,
        })
        return img
    else
        local lbl = new("TextLabel", {
            AnchorPoint=Vector2.new(0,.5), Position=UDim2.fromOffset(8,0),
            Size=UDim2.fromOffset(20,20), Text=iconStr,
            TextColor3=Theme.TextSecondary, TextSize=15,
            Font=Enum.Font.GothamBold, BackgroundTransparency=1,
            ZIndex=6, Parent=parent,
        })
        return lbl
    end
end

-- ─────────────────────────────────────────────
--  Notify
-- ─────────────────────────────────────────────
local NotifHolder
local function ensureNotif()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = new("ScreenGui", {Name="KsxNotifs", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    NotifHolder = new("Frame", {
        AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-16,1,-16),
        Size=UDim2.fromOffset(320,0), BackgroundTransparency=1, Parent=sg,
    })
    local ul = new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Bottom, Padding=UDim.new(0,8)})
    ul.Parent = NotifHolder
end

function KsxPanel:Notify(cfg)
    ensureNotif(); cfg = cfg or {}
    local title  = cfg.Title   or "ksx's Panel"
    local msg    = cfg.Message or cfg.Content or ""
    local dur    = cfg.Duration or 4
    local accent = cfg.Color or Theme.Accent

    local card = new("Frame", {Size=UDim2.new(1,0,0,0), BackgroundColor3=Theme.BGPanel, ClipsDescendants=true, Parent=NotifHolder})
    corner(card, 10)
    local stroke = new("UIStroke", {Color=Theme.Border, Thickness=1}); stroke.Parent = card
    local stripe = new("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=accent, BorderSizePixel=0}); stripe.Parent = card
    local pad = new("Frame", {Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-12,1,0), BackgroundTransparency=1}); pad.Parent = card
    local ul2 = new("UIListLayout", {Padding=UDim.new(0,2)}); ul2.Parent = pad
    local uip = new("UIPadding", {PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)}); uip.Parent = pad
    local tl = new("TextLabel", {Size=UDim2.new(1,-8,0,18), Text=title, TextColor3=Theme.TextPrimary, TextSize=14, Font=Enum.Font.GothamBold, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}); tl.Parent = pad
    if msg ~= "" then
        local ml = new("TextLabel", {Size=UDim2.new(1,-8,0,0), AutomaticSize=Enum.AutomaticSize.Y, Text=msg, TextColor3=Theme.TextSecondary, TextSize=13, Font=Enum.Font.Gotham, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true}); ml.Parent = pad
    end
    local bar = new("Frame", {AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,0,1,0), Size=UDim2.new(1,0,0,2), BackgroundColor3=accent, BorderSizePixel=0}); bar.Parent = card
    tw(card, {Size=UDim2.new(1,0,0,msg~=""and 72 or 50)}, .25)
    task.delay(.05, function() tw(bar, {Size=UDim2.new(0,0,0,2)}, dur-.3, Enum.EasingStyle.Linear) end)
    task.delay(dur, function()
        tw(card, {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1}, .2)
        task.delay(.25, function() card:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  CreateWindow
-- ─────────────────────────────────────────────
function KsxPanel:CreateWindow(cfg)
    cfg = cfg or {}
    local title     = cfg.Title     or "ksx's Panel"
    local subtitle  = cfg.Subtitle  or ""
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.B

    local sg = new("ScreenGui", {Name="KsxPanel_"..title, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Janela principal — SEM ClipsDescendants para dropdown não cortar
    local win = new("Frame", {
        Name="Window", AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5), Size=UDim2.fromOffset(680,460),
        BackgroundColor3=Theme.BG, BorderSizePixel=0,
        ClipsDescendants=false, Parent=sg,
    })
    corner(win, 14)
    local winStroke = new("UIStroke", {Color=Theme.Border, Thickness=1.2}); winStroke.Parent = win
    regBG(win, "BackgroundColor3", "BG")

    -- Glow shadow
    local glow = new("ImageLabel", {
        AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
        Size=UDim2.new(1,60,1,60), BackgroundTransparency=1,
        Image="rbxassetid://5028857084", ImageColor3=Theme.Accent, ImageTransparency=.88,
        ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(24,24,276,276),
        ZIndex=win.ZIndex-1,
    })
    glow.Parent = win
    regAcc(glow, "ImageColor3")

    -- Topbar
    local topbar = new("Frame", {
        Name="Topbar", Size=UDim2.new(1,0,0,46),
        BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, ZIndex=3,
    })
    topbar.Parent = win
    corner(topbar, 14)
    -- quadrar cantos inferiores
    local tpFix = new("Frame", {Position=UDim2.new(0,0,.5,0), Size=UDim2.new(1,0,.5,0), BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, ZIndex=3})
    tpFix.Parent = topbar
    regBG(tpFix, "BackgroundColor3", "BGPanel")
    -- linha inferior
    local tpLine = new("Frame", {AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,0,1,0), Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.Border, BorderSizePixel=0, ZIndex=4})
    tpLine.Parent = topbar
    regBG(topbar, "BackgroundColor3", "BGPanel")

    local titleLblTop = new("TextLabel", {
        Position=UDim2.fromOffset(14,0), Size=UDim2.new(.65,0,1,0),
        Text=title..(subtitle~=""and("  <font transparency='0.45' size='13'>"..subtitle.."</font>")or""),
        RichText=true, TextColor3=Theme.TextPrimary, TextSize=15, Font=Enum.Font.GothamBold,
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5,
    })
    titleLblTop.Parent = topbar

    -- Helper botão topbar
    local function mkTopBtn(col, xOff, iconId, cb)
        local btn = new("TextButton", {
            AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,xOff,.5,0),
            Size=UDim2.fromOffset(16,16), BackgroundColor3=col,
            Text="", BorderSizePixel=0, AutoButtonColor=false, ZIndex=6,
        })
        btn.Parent = topbar
        corner(btn, 999)
        local ico = new("ImageLabel", {
            AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
            Size=UDim2.fromOffset(12,12), BackgroundTransparency=1,
            Image=iconId, ZIndex=7,
            -- SEM ImageColor3 override para preservar a cor original do ícone
        })
        ico.Parent = btn
        btn.MouseEnter:Connect(function() tw(btn,{BackgroundTransparency=.25},.1) end)
        btn.MouseLeave:Connect(function() tw(btn,{BackgroundTransparency=0},.1) end)
        btn.MouseButton1Click:Connect(cb)
        return btn, ico
    end

    -- 🔴 Vermelho — destrói
    mkTopBtn(Color3.fromHex("#ff5f57"), -14, "rbxassetid://104914974782570", function()
        tw(win, {Size=UDim2.fromOffset(0,0), BackgroundTransparency=1}, .22)
        task.delay(.25, function() sg:Destroy() end)
    end)

    -- 🟢 Verde — fullscreen toggle
    -- CORREÇÃO: salva tamanho atual antes de fullscreen, usa ScreenGui size
    local isFullscreen = false
    local savedSize    = UDim2.fromOffset(680, 460)
    local ICON_EXP     = "rbxassetid://100024618512724"
    local ICON_SHR     = "rbxassetid://106458431521571"

    local _, greenIco = mkTopBtn(Color3.fromHex("#28c840"), -34, ICON_EXP, function() end)

    -- conectar depois para ter referência ao greenIco
    local greenBtn = topbar:FindFirstChild("", false) -- não precisa, já temos referência
    -- Reconectar via variável do botão
    local _gBtn, _gIco = mkTopBtn -- não precisamos chamar de novo, já temos greenIco
    -- Vamos fazer direto: recriar conexão correta
    -- O botão verde já foi criado acima, mas o callback foi vazio
    -- Precisamos encontrá-lo e trocar a conexão
    -- Mais simples: criar o botão verde depois com callback completo
    -- Remover o botão vazio que criamos:
    for _, c in ipairs(topbar:GetChildren()) do
        if c:IsA("TextButton") and c.BackgroundColor3 == Color3.fromHex("#28c840") then
            c:Destroy()
            break
        end
    end

    -- Criar verde com callback correto
    local greenBtn2, greenIco2 = mkTopBtn(Color3.fromHex("#28c840"), -34, ICON_EXP, function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            savedSize = win.Size
            greenIco2.Image = ICON_SHR
            -- Anima para preencher a tela (menos 20px de borda)
            tw(win, {
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.fromScale(0.5, 0.5),
            }, .3, Enum.EasingStyle.Quart)
        else
            greenIco2.Image = ICON_EXP
            tw(win, {
                Size = savedSize,
                Position = UDim2.fromScale(0.5, 0.5),
            }, .3, Enum.EasingStyle.Quart)
        end
    end)

    -- 🟡 Amarelo — oculta (reabre com tecla)
    mkTopBtn(Color3.fromHex("#febc2e"), -54, "rbxassetid://133760664135962", function()
        win.Visible = false
    end)

    makeDraggable(win, topbar)

    -- Sidebar
    local sidebar = new("Frame", {
        Name="Sidebar", Position=UDim2.fromOffset(0,46),
        Size=UDim2.new(0,155,1,-46), BackgroundColor3=Theme.BGPanel,
        BorderSizePixel=0, ZIndex=2, ClipsDescendants=true,
    })
    sidebar.Parent = win
    corner(sidebar, 14)
    -- quadrar cantos superiores e direita
    local sbTop = new("Frame", {Position=UDim2.new(0,0,0,0), Size=UDim2.new(1,0,0,14), BackgroundColor3=Theme.BGPanel, BorderSizePixel=0}); sbTop.Parent = sidebar
    regBG(sbTop, "BackgroundColor3", "BGPanel")
    local sbRight = new("Frame", {AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0), Size=UDim2.new(0,14,1,0), BackgroundColor3=Theme.BGPanel, BorderSizePixel=0}); sbRight.Parent = sidebar
    regBG(sbRight, "BackgroundColor3", "BGPanel")
    local sbLine = new("Frame", {AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0), Size=UDim2.new(0,1,1,0), BackgroundColor3=Theme.Border, BorderSizePixel=0, ZIndex=3}); sbLine.Parent = sidebar
    regBG(sidebar, "BackgroundColor3", "BGPanel")

    local tabList = new("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1})
    tabList.Parent = sidebar
    local tabLayout = new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2)}); tabLayout.Parent = tabList
    local tabPad = new("UIPadding", {PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}); tabPad.Parent = tabList

    -- Content area — SEM ClipsDescendants para dropdown não ser cortado
    local contentArea = new("Frame", {
        Name="Content", Position=UDim2.fromOffset(156,46),
        Size=UDim2.new(1,-156,1,-46), BackgroundTransparency=1,
        ClipsDescendants=false,
    })
    contentArea.Parent = win

    -- Window object
    local Window = {}
    Window._tabs = {}; Window._activeTab = nil; Window._sg = sg; Window._win = win

    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == toggleKey then win.Visible = not win.Visible end
    end)

    function Window:SetToggleKey(k) toggleKey = k end
    function Window:SetTheme(bg, panel, element) KsxPanel:SetTheme(bg, panel, element) end
    function Window:SetAccent(color) KsxPanel:SetAccent(color) end
    function Window:Destroy()
        tw(win, {Size=UDim2.fromOffset(0,0)}, .22)
        task.delay(.25, function() sg:Destroy() end)
    end

    -- ─────────────────────────────────────────────
    --  Tab
    -- ─────────────────────────────────────────────
    function Window:Tab(tcfg)
        tcfg = tcfg or {}
        local tabTitle = tcfg.Title or "Tab"
        local tabIcon  = tcfg.Icon  or ""
        local hasIcon  = tabIcon ~= ""

        -- Botão na sidebar
        local btn = new("TextButton", {
            Name="TabBtn_"..tabTitle, Size=UDim2.new(1,0,0,34),
            BackgroundColor3=Theme.BGElement, BackgroundTransparency=1,
            Text="", BorderSizePixel=0, AutoButtonColor=false, ZIndex=5,
        })
        btn.Parent = tabList
        corner(btn, 8)

        local indicator = new("Frame", {
            AnchorPoint=Vector2.new(0,.5), Position=UDim2.new(0,0,.5,0),
            Size=UDim2.fromOffset(3,0), BackgroundColor3=Theme.Accent,
            BorderSizePixel=0, ZIndex=6,
        })
        indicator.Parent = btn
        corner(indicator, 999)
        regAcc(indicator, "BackgroundColor3")

        -- Ícone (sem tint de cor)
        local iconObj = hasIcon and makeSideIcon(btn, tabIcon) or nil

        local lbl = new("TextLabel", {
            Position=UDim2.fromOffset(hasIcon and 31 or 10, 0),
            Size=UDim2.new(1, hasIcon and -35 or -14, 1, 0),
            Text=tabTitle, TextColor3=Theme.TextSecondary, TextSize=13,
            Font=Enum.Font.GothamSemibold, BackgroundTransparency=1,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
        })
        lbl.Parent = btn

        -- ScrollingFrame do conteúdo — ClipsDescendants true aqui para scrollar
        local scroll = new("ScrollingFrame", {
            Name="Content_"..tabTitle, Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, ScrollBarThickness=3,
            ScrollBarImageColor3=Theme.AccentDim, BorderSizePixel=0,
            Visible=false, CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            -- ClipsDescendants=true para scroll funcionar
            ClipsDescendants=true,
        })
        scroll.Parent = contentArea
        regAcc(scroll, "ScrollBarImageColor3")

        local scrollLayout = new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)})
        scrollLayout.Parent = scroll
        local scrollPad = new("UIPadding", {PaddingTop=UDim.new(0,12), PaddingBottom=UDim.new(0,16), PaddingLeft=UDim.new(0,14), PaddingRight=UDim.new(0,14)})
        scrollPad.Parent = scroll

        local Tab = {}; Tab._scroll=scroll; Tab._btn=btn

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._scroll.Visible = false
                tw(t._btn, {BackgroundTransparency=1}, .15)
                local l = t._btn:FindFirstChildWhichIsA("TextLabel")
                if l then tw(l, {TextColor3=Theme.TextSecondary}, .15) end
                local ind = t._btn:FindFirstChildWhichIsA("Frame")
                if ind then tw(ind, {Size=UDim2.fromOffset(3,0)}, .15) end
                -- ícone: não muda cor pois são imagens com cores originais
            end
            scroll.Visible = true
            tw(btn, {BackgroundTransparency=0}, .15)
            tw(lbl, {TextColor3=Theme.TextPrimary}, .15)
            tw(indicator, {Size=UDim2.fromOffset(3,20)}, .15)
            Window._activeTab = Tab
        end

        btn.MouseButton1Click:Connect(activate)
        btn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then tw(btn,{BackgroundTransparency=.6},.1) end
        end)
        btn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then tw(btn,{BackgroundTransparency=1},.1) end
        end)

        table.insert(Window._tabs, Tab)
        if #Window._tabs == 1 then activate() end

        -- ── Helpers de elementos ──────────────────────────────────────────────
        local function mkCard(h)
            local c = new("Frame", {
                Size=UDim2.new(1,0,0,h or 40), BackgroundColor3=Theme.BGElement,
                BorderSizePixel=0,
            })
            c.Parent = scroll
            corner(c, 9)
            regBG(c, "BackgroundColor3", "BGElement")
            return c
        end

        local function mkTitle(parent, text, desc, xOff)
            xOff = xOff or 12
            local tl = new("TextLabel", {
                Position=UDim2.fromOffset(xOff, desc and 8 or 0),
                Size=UDim2.new(1,-xOff-64, 0, desc and 18 or 40),
                Text=text or "", TextColor3=Theme.TextPrimary, TextSize=14,
                Font=Enum.Font.GothamSemibold, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left,
            })
            tl.Parent = parent
            if desc then
                local dl = new("TextLabel", {
                    Position=UDim2.fromOffset(xOff,28), Size=UDim2.new(1,-xOff-64,0,14),
                    Text=desc, TextColor3=Theme.TextMuted, TextSize=12, Font=Enum.Font.Gotham,
                    BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
                })
                dl.Parent = parent
            end
        end

        -- ── ProfileCard ───────────────────────────────────────────────────────
        function Tab:ProfileCard(cfg2)
            cfg2 = cfg2 or {}
            local card = new("Frame", {Size=UDim2.new(1,0,0,88), BackgroundColor3=Theme.BGElement, BorderSizePixel=0})
            card.Parent = scroll
            corner(card, 12)
            local s2 = new("UIStroke", {Color=Theme.Border, Thickness=1}); s2.Parent = card
            regBG(card, "BackgroundColor3", "BGElement")

            local img = new("ImageLabel", {
                AnchorPoint=Vector2.new(0,.5), Position=UDim2.fromOffset(12,44),
                Size=UDim2.fromOffset(64,64), BackgroundColor3=Theme.BGPanel,
                Image=cfg2.Image or "", BorderSizePixel=0, ZIndex=card.ZIndex+1,
            })
            img.Parent = card
            corner(img, 999)
            local imgS = new("UIStroke", {Color=Theme.Accent, Thickness=2.5}); imgS.Parent = img
            regAcc(imgS, "Color")

            local nameLbl = new("TextLabel", {
                Position=UDim2.fromOffset(86,10), Size=UDim2.new(1,-98,0,22),
                Text=cfg2.Name or "", TextColor3=Theme.TextPrimary, TextSize=16,
                Font=Enum.Font.GothamBold, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=card.ZIndex+1,
            })
            nameLbl.Parent = card
            local subLbl = new("TextLabel", {
                Position=UDim2.fromOffset(86,33), Size=UDim2.new(1,-98,0,15),
                Text=cfg2.Sub or "", TextColor3=Theme.Accent, TextSize=13,
                Font=Enum.Font.Gotham, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=card.ZIndex+1,
            })
            subLbl.Parent = card
            regAcc(subLbl, "TextColor3")
            local stLbl = new("TextLabel", {
                Position=UDim2.fromOffset(86,50), Size=UDim2.new(1,-98,0,34),
                Text=cfg2.Stats or "", TextColor3=Theme.TextSecondary, TextSize=12,
                Font=Enum.Font.Gotham, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
                ZIndex=card.ZIndex+1,
            })
            stLbl.Parent = card

            local Obj = {}
            function Obj:SetStats(t) stLbl.Text=t end
            function Obj:SetSub(t)   subLbl.Text=t end
            function Obj:SetImage(i) img.Image=i end
            return Obj
        end

        -- ── Button ────────────────────────────────────────────────────────────
        function Tab:Button(cfg2)
            cfg2 = cfg2 or {}
            local col  = cfg2.Color or Theme.Accent
            local card = mkCard(cfg2.Desc and 52 or 40)
            mkTitle(card, cfg2.Title, cfg2.Desc)

            local dot = new("Frame", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(6,6), BackgroundColor3=col,
                BorderSizePixel=0, ZIndex=card.ZIndex+1,
            })
            dot.Parent = card
            corner(dot, 999)

            local zone = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="", ZIndex=card.ZIndex+1,
            })
            zone.Parent = card
            corner(zone, 9)
            makeRipple(zone, function() return col end)
            zone.MouseEnter:Connect(function() tw(card,{BackgroundColor3=Theme.BGHover},.12) end)
            zone.MouseLeave:Connect(function() tw(card,{BackgroundColor3=Theme.BGElement},.12) end)
            zone.MouseButton1Click:Connect(function() if cfg2.Callback then cfg2.Callback() end end)
            return {}
        end

        -- ── Toggle ────────────────────────────────────────────────────────────
        function Tab:Toggle(cfg2)
            cfg2 = cfg2 or {}
            local state = cfg2.Default or cfg2.Value or false
            local card  = mkCard(cfg2.Desc and 52 or 40)
            mkTitle(card, cfg2.Title, cfg2.Desc)

            local track = new("Frame", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(38,22),
                BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel=0, ZIndex=card.ZIndex+2,
            })
            track.Parent = card
            corner(track, 999)
            local knob = new("Frame", {
                AnchorPoint=Vector2.new(0,.5),
                Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11),
                Size=UDim2.fromOffset(16,16), BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0, ZIndex=track.ZIndex+1,
            })
            knob.Parent = track
            corner(knob, 999)

            local btn2 = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="", ZIndex=track.ZIndex+2,
            })
            btn2.Parent = card
            btn2.MouseButton1Click:Connect(function()
                state = not state
                tw(track, {BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff}, .2)
                tw(knob,  {Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11)}, .2)
                if cfg2.Callback then cfg2.Callback(state) end
            end)

            local Obj = {}
            function Obj:Set(v)
                state = v
                tw(track, {BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff}, .2)
                tw(knob,  {Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11)}, .2)
            end
            function Obj:Get() return state end
            return Obj
        end

        -- ── Slider ────────────────────────────────────────────────────────────
        function Tab:Slider(cfg2)
            cfg2 = cfg2 or {}
            local mn  = cfg2.Min     or 0
            local mx  = cfg2.Max     or 100
            local stp = cfg2.Step    or 1
            local val = cfg2.Default or cfg2.Value or mn
            local card = mkCard(cfg2.Desc and 66 or 54)
            mkTitle(card, cfg2.Title, cfg2.Desc)

            local vLbl = new("TextLabel", {
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,cfg2.Desc and 8 or 11),
                Size=UDim2.fromOffset(50,18), Text=tostring(val),
                TextColor3=Theme.Accent, TextSize=13, Font=Enum.Font.GothamBold,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
            })
            vLbl.Parent = card
            regAcc(vLbl, "TextColor3")

            local tBg = new("Frame", {
                AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,12,1,-10),
                Size=UDim2.new(1,-24,0,4), BackgroundColor3=Theme.Border, BorderSizePixel=0,
            })
            tBg.Parent = card
            corner(tBg, 999)
            local fill = new("Frame", {
                Size=UDim2.new((val-mn)/(mx-mn),0,1,0),
                BackgroundColor3=Theme.Accent, BorderSizePixel=0,
            })
            fill.Parent = tBg
            corner(fill, 999)
            regAcc(fill, "BackgroundColor3")
            local thumb = new("Frame", {
                AnchorPoint=Vector2.new(.5,.5),
                Position=UDim2.fromScale((val-mn)/(mx-mn),.5),
                Size=UDim2.fromOffset(14,14), BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0, ZIndex=tBg.ZIndex+2,
            })
            thumb.Parent = tBg
            corner(thumb, 999)
            local tS = new("UIStroke", {Color=Theme.Accent, Thickness=2}); tS.Parent = thumb
            regAcc(tS, "Color")

            local zone = new("TextButton", {
                Size=UDim2.new(1,0,0,22), AnchorPoint=Vector2.new(0,.5),
                Position=UDim2.fromScale(0,.5), BackgroundTransparency=1,
                Text="", ZIndex=tBg.ZIndex+3,
            })
            zone.Parent = tBg

            local function upd(x)
                local rel = math.clamp((x - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
                val = math.clamp(math.round((mn+(mx-mn)*rel)/stp)*stp, mn, mx)
                vLbl.Text = tostring(val)
                local p = (val-mn)/(mx-mn)
                tw(fill,  {Size=UDim2.fromScale(p,1)}, .05)
                tw(thumb, {Position=UDim2.fromScale(p,.5)}, .05)
                if cfg2.Callback then cfg2.Callback(val) end
            end

            local sliding = false
            zone.MouseButton1Down:Connect(function() sliding=true; upd(Mouse.X) end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding=false end
            end)
            RunService.RenderStepped:Connect(function()
                if sliding then upd(Mouse.X) end
            end)

            local Obj = {}
            function Obj:Set(v)
                val = math.clamp(v, mn, mx); vLbl.Text=tostring(val)
                local p=(val-mn)/(mx-mn)
                fill.Size=UDim2.fromScale(p,1); thumb.Position=UDim2.fromScale(p,.5)
            end
            function Obj:Get() return val end
            return Obj
        end

        -- ── Dropdown ──────────────────────────────────────────────────────────
        -- CORREÇÃO: dropdown abre num Frame flutuante no ScreenGui para não ser cortado
        function Tab:Dropdown(cfg2)
            cfg2 = cfg2 or {}
            local opts  = cfg2.Options or cfg2.Values or {}
            local sel   = cfg2.Default or cfg2.Value or opts[1]
            local multi = cfg2.Multi or false
            local mSel  = {}
            local card  = mkCard(cfg2.Desc and 52 or 40)
            mkTitle(card, cfg2.Title, cfg2.Desc)

            local sLbl = new("TextLabel", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-34,.5,0),
                Size=UDim2.fromOffset(120,20),
                Text=multi and "Select..." or tostring(sel or ""),
                TextColor3=Theme.TextSecondary, TextSize=13, Font=Enum.Font.Gotham,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
                TextTruncate=Enum.TextTruncate.AtEnd,
            })
            sLbl.Parent = card
            local arrow = new("TextLabel", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-10,.5,0),
                Size=UDim2.fromOffset(18,18), Text="▾", TextColor3=Theme.TextMuted,
                TextSize=14, Font=Enum.Font.GothamBold, BackgroundTransparency=1,
            })
            arrow.Parent = card

            local open = false
            local dF   = nil

            local function closeDrop()
                if dF then
                    tw(dF, {Size=UDim2.new(0,dF.Size.X.Offset,0,0)}, .15)
                    task.delay(.18, function() if dF then dF:Destroy(); dF=nil end end)
                    tw(arrow, {Rotation=0}, .18)
                    open = false
                end
            end

            local ob = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="", ZIndex=card.ZIndex+1,
            })
            ob.Parent = card

            ob.MouseButton1Click:Connect(function()
                if open then closeDrop(); return end
                open = true
                tw(arrow, {Rotation=180}, .18)

                -- Calcular posição absoluta do card para posicionar o dropdown
                local absPos  = card.AbsolutePosition
                local absSize = card.AbsoluteSize
                local iH      = 32
                local targetH = math.min(#opts, 6) * iH + 8

                -- Dropdown flutua no ScreenGui acima de tudo
                dF = new("Frame", {
                    Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 4),
                    Size = UDim2.fromOffset(absSize.X, 0),
                    BackgroundColor3 = Theme.BGPanel,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    ZIndex = 100,
                })
                dF.Parent = sg  -- pai = ScreenGui para ficar por cima de tudo
                corner(dF, 9)
                local dStroke = new("UIStroke", {Color=Theme.Border, Thickness=1}); dStroke.Parent = dF
                regBG(dF, "BackgroundColor3", "BGPanel")

                local lst = new("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1}); lst.Parent = dF
                local ll = new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2)}); ll.Parent = lst
                local lp = new("UIPadding", {PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4)}); lp.Parent = lst

                for _, opt in ipairs(opts) do
                    local isSel = multi and table.find(mSel,opt) or (opt==sel)
                    local row = new("TextButton", {
                        Size=UDim2.new(1,0,0,iH-2),
                        BackgroundColor3=isSel and Theme.AccentDim or Color3.new(0,0,0),
                        BackgroundTransparency=isSel and 0 or 1,
                        Text="", BorderSizePixel=0, ZIndex=101,
                    })
                    row.Parent = lst
                    corner(row, 6)
                    local rl = new("TextLabel", {
                        Position=UDim2.fromOffset(10,0), Size=UDim2.new(1,-20,1,0),
                        Text=tostring(opt),
                        TextColor3=isSel and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize=13, Font=Enum.Font.Gotham, BackgroundTransparency=1,
                        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=102,
                    })
                    rl.Parent = row
                    row.MouseEnter:Connect(function()
                        if not(opt==sel and not multi) then tw(row,{BackgroundTransparency=.6},.1) end
                    end)
                    row.MouseLeave:Connect(function()
                        if not(opt==sel and not multi) then tw(row,{BackgroundTransparency=1},.1) end
                    end)
                    row.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(mSel,opt)
                            if idx then table.remove(mSel,idx) else table.insert(mSel,opt) end
                            sLbl.Text = #mSel>0 and table.concat(mSel,", ") or "Select..."
                            if cfg2.Callback then cfg2.Callback(mSel) end
                        else
                            sel = opt; sLbl.Text = tostring(opt)
                            if cfg2.Callback then cfg2.Callback(opt) end
                            closeDrop()
                        end
                    end)
                end

                tw(dF, {Size=UDim2.fromOffset(absSize.X, targetH)}, .18)

                -- Fechar ao clicar fora
                local conn
                conn = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        task.wait()
                        if dF and not dF:IsAncestorOf(game:GetService("Players").LocalPlayer.PlayerGui) then
                            -- verifica se clique foi fora
                            local mp = Vector2.new(Mouse.X, Mouse.Y)
                            local dfPos = dF.AbsolutePosition
                            local dfSize = dF.AbsoluteSize
                            if mp.X < dfPos.X or mp.X > dfPos.X+dfSize.X or mp.Y < dfPos.Y or mp.Y > dfPos.Y+dfSize.Y then
                                closeDrop(); if conn then conn:Disconnect() end
                            end
                        end
                    end
                end)
            end)

            local Obj = {}
            function Obj:Set(v) sel=v; sLbl.Text=tostring(v) end
            function Obj:Get() return multi and mSel or sel end
            function Obj:Refresh(n) opts=n; closeDrop() end
            return Obj
        end

        -- ── Input ─────────────────────────────────────────────────────────────
        function Tab:Input(cfg2)
            cfg2 = cfg2 or {}
            local card = mkCard(cfg2.Desc and 66 or 54)
            mkTitle(card, cfg2.Title, cfg2.Desc)
            local box = new("TextBox", {
                AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,12,1,-8),
                Size=UDim2.new(1,-24,0,26), BackgroundColor3=Theme.BG,
                BorderSizePixel=0, PlaceholderText=cfg2.Placeholder or "Type here...",
                PlaceholderColor3=Theme.TextMuted, Text=cfg2.Default or cfg2.Value or "",
                TextColor3=Theme.TextPrimary, TextSize=13, Font=Enum.Font.Gotham,
                ClearTextOnFocus=false, ZIndex=card.ZIndex+1,
            })
            box.Parent = card
            corner(box, 6)
            local bS = new("UIStroke", {Color=Theme.Border, Thickness=1}); bS.Parent = box
            local bp = new("UIPadding", {PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}); bp.Parent = box
            box.Focused:Connect(function() tw(bS,{Color=Theme.Accent},.15) end)
            box.FocusLost:Connect(function()
                tw(bS,{Color=Theme.Border},.15)
                if cfg2.Callback then cfg2.Callback(box.Text) end
            end)
            local Obj = {}
            function Obj:Set(v) box.Text=v end
            function Obj:Get() return box.Text end
            return Obj
        end

        -- ── Label ─────────────────────────────────────────────────────────────
        function Tab:Label(cfg2)
            cfg2 = cfg2 or {}
            local lf = new("Frame", {
                Size=UDim2.new(1,0,0,cfg2.Height or 28),
                BackgroundTransparency=1,
            })
            lf.Parent = scroll
            local lbl2 = new("TextLabel", {
                Position=UDim2.fromOffset(4,0), Size=UDim2.new(1,-8,1,0),
                Text=cfg2.Title or cfg2.Text or "",
                TextColor3=cfg2.Color or Theme.TextSecondary,
                TextSize=cfg2.TextSize or 13, Font=Enum.Font.Gotham,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true,
            })
            lbl2.Parent = lf
            local Obj = {}
            function Obj:Set(t) lbl2.Text=t end
            Obj.Title = cfg2.Title or ""
            return Obj
        end

        -- ── Separator ─────────────────────────────────────────────────────────
        function Tab:Separator(cfg2)
            cfg2 = cfg2 or {}
            if cfg2.Label then
                local sep = new("Frame", {Size=UDim2.new(1,0,0,22), BackgroundTransparency=1})
                sep.Parent = scroll
                local line = new("Frame", {AnchorPoint=Vector2.new(0,.5), Position=UDim2.fromScale(0,.5), Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.Border, BorderSizePixel=0})
                line.Parent = sep
                local lt = new("TextLabel", {
                    AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
                    Size=UDim2.fromOffset(0,18), AutomaticSize=Enum.AutomaticSize.X,
                    Text="  "..cfg2.Label.."  ", TextColor3=Theme.TextMuted, TextSize=11,
                    Font=Enum.Font.GothamBold, BackgroundColor3=Theme.BG, BorderSizePixel=0,
                    ZIndex=2,
                })
                lt.Parent = sep
                regBG(lt, "BackgroundColor3", "BG")
            else
                local sep = new("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.Border, BorderSizePixel=0})
                sep.Parent = scroll
            end
        end

        -- ── Colorpicker ───────────────────────────────────────────────────────
        function Tab:Colorpicker(cfg2)
            cfg2 = cfg2 or {}
            local col  = cfg2.Default or Color3.fromRGB(124,111,247)
            local card = mkCard(40)
            mkTitle(card, cfg2.Title)

            local sw = new("Frame", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(32,22), BackgroundColor3=col,
                BorderSizePixel=0, ZIndex=card.ZIndex+1,
            })
            sw.Parent = card
            corner(sw, 6)
            local swS = new("UIStroke", {Color=Theme.Border, Thickness=1}); swS.Parent = sw

            local pOpen = false; local pF = nil
            local function cP()
                if pF then
                    tw(pF,{Size=UDim2.new(1,0,0,0)},.18)
                    task.delay(.2,function() if pF then pF:Destroy(); pF=nil end end)
                    pOpen=false
                end
            end

            local sb = new("TextButton", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=sw.ZIndex+1})
            sb.Parent = card
            sb.MouseButton1Click:Connect(function()
                if pOpen then cP(); return end; pOpen=true
                pF = new("Frame", {
                    Position=UDim2.new(0,0,1,4), Size=UDim2.new(1,0,0,0),
                    BackgroundColor3=Theme.BGPanel, BorderSizePixel=0,
                    ClipsDescendants=true, ZIndex=card.ZIndex+10,
                })
                pF.Parent = card
                corner(pF,9)
                local pS = new("UIStroke", {Color=Theme.Border, Thickness=1}); pS.Parent = pF
                local r2,g2,b2=math.round(col.R*255),math.round(col.G*255),math.round(col.B*255)
                local pd = new("Frame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1}); pd.Parent = pF
                local pl = new("UIListLayout", {Padding=UDim.new(0,4)}); pl.Parent = pd
                local pp = new("UIPadding", {PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10)}); pp.Parent = pd
                local function mCh(label,def,cb)
                    local row=new("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1}); row.Parent=pd
                    local rl=new("TextLabel",{Size=UDim2.fromOffset(16,26),Text=label,TextColor3=Theme.TextMuted,TextSize=12,Font=Enum.Font.GothamBold,BackgroundTransparency=1}); rl.Parent=row
                    local tb=new("TextBox",{Position=UDim2.fromOffset(20,3),Size=UDim2.new(1,-20,0,20),BackgroundColor3=Theme.BG,BorderSizePixel=0,Text=tostring(def),TextColor3=Theme.TextPrimary,TextSize=13,Font=Enum.Font.Gotham}); tb.Parent=row
                    corner(tb,5)
                    local tip=new("UIPadding",{PaddingLeft=UDim.new(0,6)}); tip.Parent=tb
                    tb.FocusLost:Connect(function() local n=tonumber(tb.Text); if n then cb(math.clamp(math.round(n),0,255)) end end)
                end
                mCh("R",r2,function(v) r2=v;col=Color3.fromRGB(r2,g2,b2);sw.BackgroundColor3=col;if cfg2.Callback then cfg2.Callback(col) end end)
                mCh("G",g2,function(v) g2=v;col=Color3.fromRGB(r2,g2,b2);sw.BackgroundColor3=col;if cfg2.Callback then cfg2.Callback(col) end end)
                mCh("B",b2,function(v) b2=v;col=Color3.fromRGB(r2,g2,b2);sw.BackgroundColor3=col;if cfg2.Callback then cfg2.Callback(col) end end)
                tw(pF,{Size=UDim2.new(1,0,0,110)},.18)
            end)
            local Obj={}
            function Obj:Set(c) col=c; sw.BackgroundColor3=c end
            function Obj:Get() return col end
            return Obj
        end

        -- ── ThemeSelector (grades de cor pré-definidas) ───────────────────────
        -- Cria uma grade de bolinhas de tema para clicar e aplicar
        function Tab:ThemeSelector()
            local presets = KsxPanel.ThemePresets
            -- altura: 2 linhas de 4 bolinhas
            local rows = math.ceil(#presets / 4)
            local card = mkCard(14 + rows * 38)
            mkTitle(card, "Tema do Painel")

            local grid = new("Frame", {
                AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,12,1,-8),
                Size=UDim2.new(1,-24,0,rows*38-4),
                BackgroundTransparency=1, ZIndex=card.ZIndex+1,
            })
            grid.Parent = card
            local gl = new("UIGridLayout", {
                CellSize=UDim2.fromOffset(28,28), CellPadding=UDim2.fromOffset(8,6),
                SortOrder=Enum.SortOrder.LayoutOrder,
            })
            gl.Parent = grid

            for i, p in ipairs(presets) do
                local swatch = new("TextButton", {
                    Size=UDim2.fromOffset(28,28),
                    BackgroundColor3=Color3.fromHex(p.accent),
                    Text="", BorderSizePixel=0, AutoButtonColor=false,
                    ZIndex=card.ZIndex+2, LayoutOrder=i,
                })
                swatch.Parent = grid
                corner(swatch, 999)
                local ss = new("UIStroke", {Color=Theme.Border, Thickness=1.5}); ss.Parent = swatch

                -- Tooltip com nome
                local tip = new("TextLabel", {
                    AnchorPoint=Vector2.new(.5,1), Position=UDim2.new(.5,0,0,-4),
                    Size=UDim2.fromOffset(0,18), AutomaticSize=Enum.AutomaticSize.X,
                    Text=p.name, TextColor3=Theme.TextPrimary, TextSize=11,
                    Font=Enum.Font.GothamBold, BackgroundColor3=Theme.BGPanel,
                    BorderSizePixel=0, Visible=false, ZIndex=card.ZIndex+10,
                })
                tip.Parent = swatch
                corner(tip, 4)
                local tsp = new("UIPadding", {PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4)}); tsp.Parent = tip

                swatch.MouseEnter:Connect(function()
                    tip.Visible=true
                    tw(ss, {Color=Color3.fromHex(p.accent), Thickness=2.5}, .12)
                end)
                swatch.MouseLeave:Connect(function()
                    tip.Visible=false
                    tw(ss, {Color=Theme.Border, Thickness=1.5}, .12)
                end)
                swatch.MouseButton1Click:Connect(function()
                    -- Aplica o tema completo
                    KsxPanel:SetTheme(
                        Color3.fromHex(p.bg),
                        Color3.fromHex(p.panel),
                        Color3.fromHex(p.elem)
                    )
                    KsxPanel:SetAccent(Color3.fromHex(p.accent))
                    -- Pisca o swatch selecionado
                    tw(swatch, {BackgroundTransparency=.4}, .1)
                    tw(swatch, {BackgroundTransparency=0}, .2)
                end)
            end
        end

        return Tab
    end

    -- Animate in
    win.Size = UDim2.fromOffset(0,0)
    tw(win, {Size=UDim2.fromOffset(680,460)}, .3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return Window
end

return KsxPanel
