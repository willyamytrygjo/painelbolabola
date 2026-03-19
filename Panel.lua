--[[
    ██╗  ██╗███████╗██╗  ██╗    ███████╗    ██████╗  █████╗ ███╗   ██╗███████╗██╗     
    ██║ ██╔╝██╔════╝╚██╗██╔╝    ██╔════╝    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
    █████╔╝ ███████╗ ╚███╔╝     ███████╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
    ██╔═██╗ ╚════██║ ██╔██╗     ╚════██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
    ██║  ██╗███████║██╔╝ ██╗    ███████║    ██║     ██║  ██║██║ ╚████║███████╗███████╗
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

    ksx's Panel  –  UI Library
    Version: 1.2.0
    Author: bolabola
]]

local KsxPanel = {}
KsxPanel.__index = KsxPanel
KsxPanel.Version = "1.2.0"

-- ─────────────────────────────────────────────
--  Services
-- ─────────────────────────────────────────────
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
    BorderAccent  = Color3.fromHex("#3d3d5c"),
    Accent        = Color3.fromHex("#7c6ff7"),
    AccentDim     = Color3.fromHex("#4e4899"),
    AccentGlow    = Color3.fromHex("#a99ff8"),
    TextPrimary   = Color3.fromHex("#e8e6ff"),
    TextSecondary = Color3.fromHex("#8884aa"),
    TextMuted     = Color3.fromHex("#55527a"),
    Success       = Color3.fromHex("#4ade80"),
    Warning       = Color3.fromHex("#facc15"),
    Danger        = Color3.fromHex("#f87171"),
    Info          = Color3.fromHex("#60a5fa"),
    ToggleOn      = Color3.fromHex("#7c6ff7"),
    ToggleOff     = Color3.fromHex("#2a2a3d"),
}

-- Registros para recolorir em runtime
local _bgReg     = {} -- { obj, prop, key }
local _accentReg = {} -- { obj, prop }

local function regBG(obj, prop, key)
    table.insert(_bgReg, { obj=obj, prop=prop, key=key })
    pcall(function() obj[prop] = Theme[key] end)
end
local function regAcc(obj, prop)
    table.insert(_accentReg, { obj=obj, prop=prop })
    pcall(function() obj[prop] = Theme.Accent end)
end

function KsxPanel:SetTheme(bg, panel, element)
    if bg      then Theme.BG        = bg      end
    if panel   then Theme.BGPanel   = panel   end
    if element then
        Theme.BGElement = element
        Theme.BGHover   = element:Lerp(Color3.new(1,1,1), 0.06)
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

-- ─────────────────────────────────────────────
--  Helpers internos
-- ─────────────────────────────────────────────
local function tw(obj, props, t, sty, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or .18, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function new(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end

local function corner(parent, r)
    new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
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

local function ripple(btn, colorFn)
    btn.ClipsDescendants = true
    btn.MouseButton1Click:Connect(function()
        local col = (colorFn and colorFn()) or Theme.Accent
        local rx = Mouse.X - btn.AbsolutePosition.X
        local ry = Mouse.Y - btn.AbsolutePosition.Y
        local r = new("Frame", {
            AnchorPoint = Vector2.new(.5,.5),
            Position = UDim2.fromOffset(rx, ry),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = col,
            BackgroundTransparency = .7,
            ZIndex = btn.ZIndex + 5,
            Parent = btn,
        })
        corner(r, 999)
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
        tw(r, { Size=UDim2.fromOffset(sz,sz), BackgroundTransparency=1 }, .45)
        task.delay(.5, function() r:Destroy() end)
    end)
end

-- Ícone: aceita rbxassetid://ID, número puro ou emoji/texto
local function makeIcon(parent, iconStr, size, xOff)
    size = size or 18; xOff = xOff or 8
    local isAsset = iconStr and (iconStr:match("^rbxassetid://") or iconStr:match("^%d+$"))
    if isAsset then
        local id = iconStr:match("^rbxassetid://(.+)$") or iconStr
        return new("ImageLabel", {
            AnchorPoint = Vector2.new(0,.5),
            Position = UDim2.fromOffset(xOff, 0),
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
            Image = "rbxassetid://"..id,
            ImageColor3 = Theme.TextSecondary,
            ZIndex = 6, Parent = parent,
        }), true
    elseif iconStr and iconStr ~= "" then
        return new("TextLabel", {
            AnchorPoint = Vector2.new(0,.5),
            Position = UDim2.fromOffset(xOff, 0),
            Size = UDim2.fromOffset(20, 20),
            Text = iconStr, TextColor3 = Theme.TextSecondary,
            TextSize = 15, Font = Enum.Font.GothamBold,
            BackgroundTransparency = 1, ZIndex = 6, Parent = parent,
        }), false
    end
    return nil, false
end

-- ─────────────────────────────────────────────
--  Notify
-- ─────────────────────────────────────────────
local NotifHolder

local function ensureNotif()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = new("ScreenGui", {
        Name="KsxPanelNotifs", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    NotifHolder = new("Frame", {
        AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-16,1,-16),
        Size=UDim2.fromOffset(320,0), BackgroundTransparency=1, Parent=sg,
    })
    new("UIListLayout", {
        SortOrder=Enum.SortOrder.LayoutOrder,
        VerticalAlignment=Enum.VerticalAlignment.Bottom,
        Padding=UDim.new(0,8), Parent=NotifHolder,
    })
end

function KsxPanel:Notify(cfg)
    ensureNotif(); cfg = cfg or {}
    local title  = cfg.Title   or "ksx's Panel"
    local msg    = cfg.Message or cfg.Content or ""
    local dur    = cfg.Duration or 4
    local accent = cfg.Color or Theme.Accent

    local card = new("Frame", {
        Size=UDim2.new(1,0,0,0), BackgroundColor3=Theme.BGPanel,
        ClipsDescendants=true, Parent=NotifHolder,
    })
    corner(card, 10)
    new("UIStroke", { Color=Theme.Border, Thickness=1, Parent=card })
    new("Frame", { Size=UDim2.new(0,3,1,0), BackgroundColor3=accent, BorderSizePixel=0, Parent=card })

    local pad = new("Frame", {
        Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-12,1,0),
        BackgroundTransparency=1, Parent=card,
    })
    new("UIListLayout", { Padding=UDim.new(0,2), Parent=pad })
    new("UIPadding", { PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10), Parent=pad })
    new("TextLabel", {
        Size=UDim2.new(1,-8,0,18), Text=title,
        TextColor3=Theme.TextPrimary, TextSize=14, Font=Enum.Font.GothamBold,
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, Parent=pad,
    })
    if msg ~= "" then
        new("TextLabel", {
            Size=UDim2.new(1,-8,0,0), AutomaticSize=Enum.AutomaticSize.Y,
            Text=msg, TextColor3=Theme.TextSecondary, TextSize=13, Font=Enum.Font.Gotham,
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true, Parent=pad,
        })
    end
    local bar = new("Frame", {
        AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,0,1,0),
        Size=UDim2.new(1,0,0,2), BackgroundColor3=accent, BorderSizePixel=0, Parent=card,
    })
    tw(card, { Size=UDim2.new(1,0,0,msg~=""and 72 or 50) }, .25)
    task.delay(.05, function()
        tw(bar, { Size=UDim2.new(0,0,0,2) }, dur-.3, Enum.EasingStyle.Linear)
    end)
    task.delay(dur, function()
        tw(card, { Size=UDim2.new(1,0,0,0), BackgroundTransparency=1 }, .2)
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
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift

    local sg = new("ScreenGui", {
        Name="KsxPanel_"..title, ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ── Janela principal ──
    local win = new("Frame", {
        Name="Window", AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5), Size=UDim2.fromOffset(680,460),
        BackgroundColor3=Theme.BG, BorderSizePixel=0,
        ClipsDescendants=false, Parent=sg,
    })
    corner(win, 14)
    new("UIStroke", { Color=Theme.Border, Thickness=1.2, Parent=win })
    regBG(win, "BackgroundColor3", "BG")

    -- Glow
    new("ImageLabel", {
        AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
        Size=UDim2.new(1,60,1,60), BackgroundTransparency=1,
        Image="rbxassetid://5028857084", ImageColor3=Theme.Accent, ImageTransparency=.88,
        ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(24,24,276,276),
        ZIndex=win.ZIndex-1, Parent=win,
    })

    -- ── Topbar ──
    local topbar = new("Frame", {
        Name="Topbar", Size=UDim2.new(1,0,0,46),
        BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, ZIndex=3, Parent=win,
    })
    corner(topbar, 14)
    -- quadrar cantos inferiores
    new("Frame", {
        Position=UDim2.new(0,0,.5,0), Size=UDim2.new(1,0,.5,0),
        BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, ZIndex=3, Parent=topbar,
    })
    -- linha separadora
    new("Frame", {
        AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,0,1,0),
        Size=UDim2.new(1,0,0,1), BackgroundColor3=Theme.Border,
        BorderSizePixel=0, ZIndex=4, Parent=topbar,
    })
    regBG(topbar, "BackgroundColor3", "BGPanel")

    new("TextLabel", {
        Position=UDim2.fromOffset(14,0), Size=UDim2.new(.65,0,1,0),
        Text=title..(subtitle~=""and("  <font transparency='0.45' size='13'>"..subtitle.."</font>")or""),
        RichText=true, TextColor3=Theme.TextPrimary, TextSize=15, Font=Enum.Font.GothamBold,
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5, Parent=topbar,
    })

    -- Helper dos botões do topbar
    local function mkTopBtn(col, xOff, iconId, cb)
        local btn = new("TextButton", {
            AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,xOff,.5,0),
            Size=UDim2.fromOffset(16,16), BackgroundColor3=col,
            Text="", BorderSizePixel=0, AutoButtonColor=false, ZIndex=6, Parent=topbar,
        })
        corner(btn, 999)
        local ico = new("ImageLabel", {
            AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
            Size=UDim2.fromOffset(12,12), BackgroundTransparency=1,
            Image=iconId, ImageColor3=Color3.new(1,1,1), ZIndex=7, Parent=btn,
        })
        btn.MouseEnter:Connect(function() tw(btn,{BackgroundTransparency=.2},.1) end)
        btn.MouseLeave:Connect(function() tw(btn,{BackgroundTransparency=0},.1) end)
        btn.MouseButton1Click:Connect(cb)
        return btn, ico
    end

    -- ────────────────────────────────────────────
    --  🔴 VERMELHO — destrói o painel para sempre
    -- ────────────────────────────────────────────
    mkTopBtn(Color3.fromHex("#ff5f57"), -14, "rbxassetid://104914974782570", function()
        tw(win, { Size=UDim2.fromOffset(0,0), BackgroundTransparency=1 }, .22)
        task.delay(.25, function() sg:Destroy() end)
    end)

    -- ────────────────────────────────────────────
    --  🟢 VERDE — alterna tela cheia / tamanho normal
    -- ────────────────────────────────────────────
    local fullscreen   = false
    local normalSize   = UDim2.fromOffset(680, 460)
    local fullSize     = UDim2.new(1, -20, 1, -20)
    local ICON_EXPAND  = "rbxassetid://100024618512724"
    local ICON_SHRINK  = "rbxassetid://106458431521571"

    local _, greenIcon = mkTopBtn(Color3.fromHex("#28c840"), -34, ICON_EXPAND, function()
        fullscreen = not fullscreen
        if fullscreen then
            greenIcon.Image = ICON_SHRINK
            tw(win, { Size=fullSize }, .25, Enum.EasingStyle.Quart)
        else
            greenIcon.Image = ICON_EXPAND
            tw(win, { Size=normalSize }, .25, Enum.EasingStyle.Quart)
        end
    end)

    -- ────────────────────────────────────────────
    --  🟡 AMARELO — fecha (oculta) o painel
    --   O painel reabre ao pressionar toggleKey (padrão: B)
    -- ────────────────────────────────────────────
    mkTopBtn(Color3.fromHex("#febc2e"), -54, "rbxassetid://133760664135962", function()
        win.Visible = false
    end)

    makeDraggable(win, topbar)

    -- ── Sidebar ──
    local sidebar = new("Frame", {
        Name="Sidebar", Position=UDim2.fromOffset(0,46),
        Size=UDim2.new(0,155,1,-46), BackgroundColor3=Theme.BGPanel,
        BorderSizePixel=0, ZIndex=2, ClipsDescendants=true, Parent=win,
    })
    corner(sidebar, 14)
    new("Frame", { Position=UDim2.new(0,0,0,0), Size=UDim2.new(1,0,0,14), BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, Parent=sidebar })
    new("Frame", { AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0), Size=UDim2.new(0,14,1,0), BackgroundColor3=Theme.BGPanel, BorderSizePixel=0, Parent=sidebar })
    new("Frame", { AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0), Size=UDim2.new(0,1,1,0), BackgroundColor3=Theme.Border, BorderSizePixel=0, ZIndex=3, Parent=sidebar })
    regBG(sidebar, "BackgroundColor3", "BGPanel")

    local tabList = new("Frame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Parent=sidebar })
    new("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2), Parent=tabList })
    new("UIPadding", { PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Parent=tabList })

    -- ── Content area ──
    local contentArea = new("Frame", {
        Name="Content", Position=UDim2.fromOffset(156,46),
        Size=UDim2.new(1,-156,1,-46), BackgroundTransparency=1,
        ClipsDescendants=true, Parent=win,
    })

    -- ─────────────────────────────────────────────
    --  Window object
    -- ─────────────────────────────────────────────
    local Window = {}
    Window._tabs      = {}
    Window._activeTab = nil
    Window._sg        = sg
    Window._win       = win

    -- Toggle key: abre/fecha o painel (amarelo fecha, tecla reabre)
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == toggleKey then
            win.Visible = not win.Visible
        end
    end)

    function Window:SetToggleKey(k) toggleKey = k end

    function Window:SetTheme(bg, panel, element)
        KsxPanel:SetTheme(bg, panel, element)
    end

    function Window:SetAccent(color)
        KsxPanel:SetAccent(color)
    end

    function Window:Destroy()
        tw(win, { Size=UDim2.fromOffset(0,0) }, .22)
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

        local btn = new("TextButton", {
            Name="TabBtn_"..tabTitle, Size=UDim2.new(1,0,0,34),
            BackgroundColor3=Theme.BGElement, BackgroundTransparency=1,
            Text="", BorderSizePixel=0, AutoButtonColor=false, ZIndex=5, Parent=tabList,
        })
        corner(btn, 8)

        local indicator = new("Frame", {
            AnchorPoint=Vector2.new(0,.5), Position=UDim2.new(0,0,.5,0),
            Size=UDim2.fromOffset(3,0), BackgroundColor3=Theme.Accent,
            BorderSizePixel=0, ZIndex=6, Parent=btn,
        })
        corner(indicator, 999)
        regAcc(indicator, "BackgroundColor3")

        local iconObj = nil
        if hasIcon then
            iconObj, _ = makeIcon(btn, tabIcon, 18, 8)
        end

        local lbl = new("TextLabel", {
            Position=UDim2.fromOffset(hasIcon and 31 or 10, 0),
            Size=UDim2.new(1, hasIcon and -35 or -14, 1, 0),
            Text=tabTitle, TextColor3=Theme.TextSecondary, TextSize=13,
            Font=Enum.Font.GothamSemibold, BackgroundTransparency=1,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6, Parent=btn,
        })

        local scroll = new("ScrollingFrame", {
            Name="Content_"..tabTitle, Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, ScrollBarThickness=3,
            ScrollBarImageColor3=Theme.AccentDim, BorderSizePixel=0,
            Visible=false, CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=contentArea,
        })
        new("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), Parent=scroll })
        new("UIPadding", { PaddingTop=UDim.new(0,12), PaddingBottom=UDim.new(0,12), PaddingLeft=UDim.new(0,14), PaddingRight=UDim.new(0,14), Parent=scroll })

        local Tab = {}; Tab._scroll=scroll; Tab._btn=btn

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._scroll.Visible = false
                tw(t._btn, { BackgroundTransparency=1 }, .15)
                local l = t._btn:FindFirstChildWhichIsA("TextLabel")
                if l then tw(l, { TextColor3=Theme.TextSecondary }, .15) end
                local ind = t._btn:FindFirstChildWhichIsA("Frame")
                if ind then tw(ind, { Size=UDim2.fromOffset(3,0) }, .15) end
                local ic = t._btn:FindFirstChildWhichIsA("ImageLabel")
                if ic then tw(ic, { ImageColor3=Theme.TextSecondary }, .15) end
            end
            scroll.Visible = true
            tw(btn, { BackgroundTransparency=0 }, .15)
            tw(lbl, { TextColor3=Theme.TextPrimary }, .15)
            tw(indicator, { Size=UDim2.fromOffset(3,20) }, .15)
            if iconObj then tw(iconObj, { ImageColor3=Theme.Accent }, .15) end
            Window._activeTab = Tab
        end

        btn.MouseButton1Click:Connect(activate)
        btn.MouseEnter:Connect(function() if Window._activeTab ~= Tab then tw(btn,{BackgroundTransparency=.6},.1) end end)
        btn.MouseLeave:Connect(function() if Window._activeTab ~= Tab then tw(btn,{BackgroundTransparency=1},.1) end end)
        table.insert(Window._tabs, Tab)
        if #Window._tabs == 1 then activate() end

        -- ── Helpers de card ──
        local function mkCard(h)
            local c = new("Frame", {
                Size=UDim2.new(1,0,0,h or 40), BackgroundColor3=Theme.BGElement,
                BorderSizePixel=0, Parent=scroll,
            })
            corner(c, 9)
            regBG(c, "BackgroundColor3", "BGElement")
            return c
        end

        local function titleLbl(parent, text, desc, xOff)
            xOff = xOff or 12
            new("TextLabel", {
                Position=UDim2.fromOffset(xOff, desc and 8 or 0),
                Size=UDim2.new(1,-xOff-60, 0, desc and 18 or 40),
                Text=text or "", TextColor3=Theme.TextPrimary, TextSize=14,
                Font=Enum.Font.GothamSemibold, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=parent,
            })
            if desc then
                new("TextLabel", {
                    Position=UDim2.fromOffset(xOff,28), Size=UDim2.new(1,-xOff-60,0,14),
                    Text=desc, TextColor3=Theme.TextMuted, TextSize=12, Font=Enum.Font.Gotham,
                    BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, Parent=parent,
                })
            end
        end

        -- ── ProfileCard ──────────────────────────────────────────────────────
        function Tab:ProfileCard(cfg2)
            cfg2 = cfg2 or {}
            local card = new("Frame", {
                Size=UDim2.new(1,0,0,88), BackgroundColor3=Theme.BGElement,
                BorderSizePixel=0, Parent=scroll,
            })
            corner(card, 12)
            new("UIStroke", { Color=Theme.Border, Thickness=1, Parent=card })
            regBG(card, "BackgroundColor3", "BGElement")

            local imgLbl = new("ImageLabel", {
                AnchorPoint=Vector2.new(0,.5), Position=UDim2.fromOffset(12,44),
                Size=UDim2.fromOffset(64,64), BackgroundColor3=Theme.BGPanel,
                Image=cfg2.Image or "", BorderSizePixel=0, ZIndex=card.ZIndex+1, Parent=card,
            })
            corner(imgLbl, 999)
            local imgStroke = new("UIStroke", { Color=Theme.Accent, Thickness=2.5, Parent=imgLbl })
            regAcc(imgStroke, "Color")

            new("TextLabel", {
                Position=UDim2.fromOffset(86,10), Size=UDim2.new(1,-98,0,22),
                Text=cfg2.Name or "", TextColor3=Theme.TextPrimary, TextSize=16,
                Font=Enum.Font.GothamBold, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=card.ZIndex+1, Parent=card,
            })
            local subLbl = new("TextLabel", {
                Position=UDim2.fromOffset(86,33), Size=UDim2.new(1,-98,0,15),
                Text=cfg2.Sub or "", TextColor3=Theme.Accent, TextSize=13,
                Font=Enum.Font.Gotham, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=card.ZIndex+1, Parent=card,
            })
            regAcc(subLbl, "TextColor3")
            local statsLbl = new("TextLabel", {
                Position=UDim2.fromOffset(86,50), Size=UDim2.new(1,-98,0,34),
                Text=cfg2.Stats or "", TextColor3=Theme.TextSecondary, TextSize=12,
                Font=Enum.Font.Gotham, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
                ZIndex=card.ZIndex+1, Parent=card,
            })

            local Obj = {}
            function Obj:SetStats(t) statsLbl.Text = t end
            function Obj:SetSub(t)   subLbl.Text   = t end
            function Obj:SetImage(i) imgLbl.Image   = i end
            return Obj
        end

        -- ── Button ───────────────────────────────────────────────────────────
        function Tab:Button(cfg2)
            cfg2 = cfg2 or {}
            local col  = cfg2.Color or Theme.Accent
            local card = mkCard(cfg2.Desc and 52 or 40)
            titleLbl(card, cfg2.Title, cfg2.Desc)

            local dot = new("Frame", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(6,6), BackgroundColor3=col,
                BorderSizePixel=0, ZIndex=card.ZIndex+1, Parent=card,
            })
            corner(dot, 999)

            local zone = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="",
                ZIndex=card.ZIndex+1, Parent=card,
            })
            corner(zone, 9)
            ripple(zone, function() return col end)
            zone.MouseEnter:Connect(function() tw(card,{BackgroundColor3=Theme.BGHover},.12) end)
            zone.MouseLeave:Connect(function() tw(card,{BackgroundColor3=Theme.BGElement},.12) end)
            zone.MouseButton1Click:Connect(function() if cfg2.Callback then cfg2.Callback() end end)
            return {}
        end

        -- ── Toggle ───────────────────────────────────────────────────────────
        function Tab:Toggle(cfg2)
            cfg2 = cfg2 or {}
            local state = cfg2.Default or cfg2.Value or false
            local card  = mkCard(cfg2.Desc and 52 or 40)
            titleLbl(card, cfg2.Title, cfg2.Desc)

            local track = new("Frame", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(38,22),
                BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel=0, ZIndex=card.ZIndex+2, Parent=card,
            })
            corner(track, 999)
            local knob = new("Frame", {
                AnchorPoint=Vector2.new(0,.5),
                Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11),
                Size=UDim2.fromOffset(16,16), BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0, ZIndex=track.ZIndex+1, Parent=track,
            })
            corner(knob, 999)

            local btn2 = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="",
                ZIndex=track.ZIndex+2, Parent=card,
            })
            btn2.MouseButton1Click:Connect(function()
                state = not state
                tw(track, { BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff }, .2)
                tw(knob,  { Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11) }, .2)
                if cfg2.Callback then cfg2.Callback(state) end
            end)

            local Obj = {}
            function Obj:Set(v)
                state = v
                tw(track, { BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff }, .2)
                tw(knob,  { Position=state and UDim2.fromOffset(18,11) or UDim2.fromOffset(3,11) }, .2)
            end
            function Obj:Get() return state end
            return Obj
        end

        -- ── Slider ───────────────────────────────────────────────────────────
        function Tab:Slider(cfg2)
            cfg2 = cfg2 or {}
            local mn  = cfg2.Min     or 0
            local mx  = cfg2.Max     or 100
            local stp = cfg2.Step    or 1
            local val = cfg2.Default or cfg2.Value or mn
            local card = mkCard(cfg2.Desc and 66 or 54)
            titleLbl(card, cfg2.Title, cfg2.Desc)

            local vLbl = new("TextLabel", {
                AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,cfg2.Desc and 8 or 11),
                Size=UDim2.fromOffset(50,18), Text=tostring(val),
                TextColor3=Theme.Accent, TextSize=13, Font=Enum.Font.GothamBold,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right, Parent=card,
            })
            regAcc(vLbl, "TextColor3")

            local tBg = new("Frame", {
                AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,12,1,-10),
                Size=UDim2.new(1,-24,0,4), BackgroundColor3=Theme.Border,
                BorderSizePixel=0, Parent=card,
            })
            corner(tBg, 999)
            local fill = new("Frame", {
                Size=UDim2.new((val-mn)/(mx-mn),0,1,0),
                BackgroundColor3=Theme.Accent, BorderSizePixel=0, Parent=tBg,
            })
            corner(fill, 999)
            regAcc(fill, "BackgroundColor3")
            local thumb = new("Frame", {
                AnchorPoint=Vector2.new(.5,.5),
                Position=UDim2.fromScale((val-mn)/(mx-mn),.5),
                Size=UDim2.fromOffset(14,14), BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0, ZIndex=tBg.ZIndex+2, Parent=tBg,
            })
            corner(thumb, 999)
            local tStroke = new("UIStroke", { Color=Theme.Accent, Thickness=2, Parent=thumb })
            regAcc(tStroke, "Color")

            local zone = new("TextButton", {
                Size=UDim2.new(1,0,0,22), AnchorPoint=Vector2.new(0,.5),
                Position=UDim2.fromScale(0,.5), BackgroundTransparency=1,
                Text="", ZIndex=tBg.ZIndex+3, Parent=tBg,
            })

            local function upd(x)
                local rel = math.clamp((x - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
                val = math.clamp(math.round((mn+(mx-mn)*rel)/stp)*stp, mn, mx)
                vLbl.Text = tostring(val)
                local p = (val-mn)/(mx-mn)
                tw(fill,  { Size=UDim2.fromScale(p,1) }, .05)
                tw(thumb, { Position=UDim2.fromScale(p,.5) }, .05)
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
                local p = (val-mn)/(mx-mn)
                fill.Size=UDim2.fromScale(p,1); thumb.Position=UDim2.fromScale(p,.5)
            end
            function Obj:Get() return val end
            return Obj
        end

        -- ── Dropdown ─────────────────────────────────────────────────────────
        function Tab:Dropdown(cfg2)
            cfg2 = cfg2 or {}
            local opts   = cfg2.Options or cfg2.Values or {}
            local sel    = cfg2.Default or cfg2.Value or opts[1]
            local multi  = cfg2.Multi or false
            local mSel   = {}
            local card   = mkCard(cfg2.Desc and 52 or 40)
            titleLbl(card, cfg2.Title, cfg2.Desc)

            local sLbl = new("TextLabel", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-34,.5,0),
                Size=UDim2.fromOffset(110,20),
                Text=multi and "Select..." or tostring(sel or ""),
                TextColor3=Theme.TextSecondary, TextSize=13, Font=Enum.Font.Gotham,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
                TextTruncate=Enum.TextTruncate.AtEnd, Parent=card,
            })
            local arrow = new("TextLabel", {
                AnchorPoint=Vector2.new(1,.5), Position=UDim2.new(1,-10,.5,0),
                Size=UDim2.fromOffset(18,18), Text="▾", TextColor3=Theme.TextMuted,
                TextSize=14, Font=Enum.Font.GothamBold, BackgroundTransparency=1, Parent=card,
            })

            local open=false; local dF=nil
            local function closeDrop()
                if dF then
                    tw(dF,{Size=UDim2.new(1,0,0,0)},.18)
                    task.delay(.2,function() if dF then dF:Destroy(); dF=nil end end)
                    tw(arrow,{Rotation=0},.18); open=false
                end
            end

            local ob = new("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="",
                ZIndex=card.ZIndex+1, Parent=card,
            })
            ob.MouseButton1Click:Connect(function()
                if open then closeDrop(); return end
                open=true; tw(arrow,{Rotation=180},.18)
                local iH=32; local h=math.min(#opts,6)*iH+8
                dF = new("Frame", {
                    Position=UDim2.new(0,0,1,4), Size=UDim2.new(1,0,0,0),
                    BackgroundColor3=Theme.BGPanel, BorderSizePixel=0,
                    ClipsDescendants=true, ZIndex=card.ZIndex+10, Parent=card,
                })
                corner(dF,9); new("UIStroke",{Color=Theme.Border,Thickness=1,Parent=dF})
                regBG(dF,"BackgroundColor3","BGPanel")
                local lst = new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=dF})
                new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=lst})
                new("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),Parent=lst})
                for _,opt in ipairs(opts) do
                    local isSel=multi and table.find(mSel,opt) or (opt==sel)
                    local row=new("TextButton",{
                        Size=UDim2.new(1,0,0,iH-2),
                        BackgroundColor3=isSel and Theme.AccentDim or Color3.new(0,0,0),
                        BackgroundTransparency=isSel and 0 or 1,
                        Text="",BorderSizePixel=0,ZIndex=dF.ZIndex+1,Parent=lst,
                    })
                    corner(row,6)
                    new("TextLabel",{
                        Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-20,1,0),
                        Text=tostring(opt),
                        TextColor3=isSel and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize=13,Font=Enum.Font.Gotham,BackgroundTransparency=1,
                        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=row.ZIndex+1,Parent=row,
                    })
                    row.MouseEnter:Connect(function() if not(opt==sel and not multi) then tw(row,{BackgroundTransparency=.6},.1) end end)
                    row.MouseLeave:Connect(function() if not(opt==sel and not multi) then tw(row,{BackgroundTransparency=1},.1) end end)
                    row.MouseButton1Click:Connect(function()
                        if multi then
                            local idx=table.find(mSel,opt)
                            if idx then table.remove(mSel,idx) else table.insert(mSel,opt) end
                            sLbl.Text=#mSel>0 and table.concat(mSel,", ") or "Select..."
                            if cfg2.Callback then cfg2.Callback(mSel) end
                        else
                            sel=opt; sLbl.Text=tostring(opt)
                            if cfg2.Callback then cfg2.Callback(opt) end
                            closeDrop()
                        end
                    end)
                end
                tw(dF,{Size=UDim2.new(1,0,0,h)},.18)
            end)

            local Obj={}
            function Obj:Set(v) sel=v; sLbl.Text=tostring(v) end
            function Obj:Get() return multi and mSel or sel end
            function Obj:Refresh(n) opts=n; closeDrop() end
            return Obj
        end

        -- ── Input ─────────────────────────────────────────────────────────────
        function Tab:Input(cfg2)
            cfg2 = cfg2 or {}
            local card = mkCard(cfg2.Desc and 66 or 54)
            titleLbl(card, cfg2.Title, cfg2.Desc)
            local box = new("TextBox", {
                AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,12,1,-8),
                Size=UDim2.new(1,-24,0,26), BackgroundColor3=Theme.BG,
                BorderSizePixel=0, PlaceholderText=cfg2.Placeholder or "Type here...",
                PlaceholderColor3=Theme.TextMuted, Text=cfg2.Default or cfg2.Value or "",
                TextColor3=Theme.TextPrimary, TextSize=13, Font=Enum.Font.Gotham,
                ClearTextOnFocus=false, ZIndex=card.ZIndex+1, Parent=card,
            })
            corner(box, 6)
            local bStroke = new("UIStroke",{Color=Theme.Border,Thickness=1,Parent=box})
            new("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),Parent=box})
            box.Focused:Connect(function() tw(bStroke,{Color=Theme.Accent},.15) end)
            box.FocusLost:Connect(function()
                tw(bStroke,{Color=Theme.Border},.15)
                if cfg2.Callback then cfg2.Callback(box.Text) end
            end)
            local Obj={}
            function Obj:Set(v) box.Text=v end
            function Obj:Get() return box.Text end
            return Obj
        end

        -- ── Label ─────────────────────────────────────────────────────────────
        function Tab:Label(cfg2)
            cfg2 = cfg2 or {}
            local lf = new("Frame",{
                Size=UDim2.new(1,0,0,cfg2.Height or 28),
                BackgroundTransparency=1, Parent=scroll,
            })
            local lbl2 = new("TextLabel",{
                Position=UDim2.fromOffset(4,0), Size=UDim2.new(1,-8,1,0),
                Text=cfg2.Title or cfg2.Text or "",
                TextColor3=cfg2.Color or Theme.TextSecondary,
                TextSize=cfg2.TextSize or 13, Font=Enum.Font.Gotham,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true, Parent=lf,
            })
            local Obj={}
            function Obj:Set(t) lbl2.Text=t end
            Obj.Title=cfg2.Title or ""
            return Obj
        end

        -- ── Separator ─────────────────────────────────────────────────────────
        function Tab:Separator(cfg2)
            cfg2 = cfg2 or {}
            if cfg2.Label then
                local sep=new("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Parent=scroll})
                new("Frame",{AnchorPoint=Vector2.new(0,.5),Position=UDim2.fromScale(0,.5),Size=UDim2.new(1,0,0,1),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=sep})
                new("TextLabel",{
                    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
                    Size=UDim2.fromOffset(0,18),AutomaticSize=Enum.AutomaticSize.X,
                    Text="  "..cfg2.Label.."  ",TextColor3=Theme.TextMuted,TextSize=11,
                    Font=Enum.Font.GothamBold,BackgroundColor3=Theme.BG,BorderSizePixel=0,
                    ZIndex=2,Parent=sep,
                })
            else
                new("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=scroll})
            end
        end

        -- ── Colorpicker ───────────────────────────────────────────────────────
        function Tab:Colorpicker(cfg2)
            cfg2 = cfg2 or {}
            local col  = cfg2.Default or Color3.fromRGB(124,111,247)
            local card = mkCard(40)
            titleLbl(card, cfg2.Title)
            local sw = new("Frame",{
                AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-12,.5,0),
                Size=UDim2.fromOffset(32,22),BackgroundColor3=col,
                BorderSizePixel=0,ZIndex=card.ZIndex+1,Parent=card,
            })
            corner(sw,6); new("UIStroke",{Color=Theme.Border,Thickness=1,Parent=sw})

            local pOpen=false; local pF=nil
            local function cP()
                if pF then tw(pF,{Size=UDim2.new(1,0,0,0)},.18); task.delay(.2,function() if pF then pF:Destroy(); pF=nil end end); pOpen=false end
            end
            local sb=new("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=sw.ZIndex+1,Parent=card})
            sb.MouseButton1Click:Connect(function()
                if pOpen then cP(); return end; pOpen=true
                pF=new("Frame",{Position=UDim2.new(0,0,1,4),Size=UDim2.new(1,0,0,0),BackgroundColor3=Theme.BGPanel,BorderSizePixel=0,ClipsDescendants=true,ZIndex=card.ZIndex+10,Parent=card})
                corner(pF,9); new("UIStroke",{Color=Theme.Border,Thickness=1,Parent=pF})
                local r2,g2,b2=math.round(col.R*255),math.round(col.G*255),math.round(col.B*255)
                local pd=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=pF})
                new("UIListLayout",{Padding=UDim.new(0,4),Parent=pd})
                new("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),Parent=pd})
                local function mCh(label,def,cb)
                    local row=new("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,Parent=pd})
                    new("TextLabel",{Size=UDim2.fromOffset(16,26),Text=label,TextColor3=Theme.TextMuted,TextSize=12,Font=Enum.Font.GothamBold,BackgroundTransparency=1,Parent=row})
                    local tb=new("TextBox",{Position=UDim2.fromOffset(20,3),Size=UDim2.new(1,-20,0,20),BackgroundColor3=Theme.BG,BorderSizePixel=0,Text=tostring(def),TextColor3=Theme.TextPrimary,TextSize=13,Font=Enum.Font.Gotham,Parent=row})
                    corner(tb,5); new("UIPadding",{PaddingLeft=UDim.new(0,6),Parent=tb})
                    tb.FocusLost:Connect(function() local n=tonumber(tb.Text); if n then cb(math.clamp(math.round(n),0,255)) end end)
                end
                mCh("R",r2,function(v) r2=v; col=Color3.fromRGB(r2,g2,b2); sw.BackgroundColor3=col; if cfg2.Callback then cfg2.Callback(col) end end)
                mCh("G",g2,function(v) g2=v; col=Color3.fromRGB(r2,g2,b2); sw.BackgroundColor3=col; if cfg2.Callback then cfg2.Callback(col) end end)
                mCh("B",b2,function(v) b2=v; col=Color3.fromRGB(r2,g2,b2); sw.BackgroundColor3=col; if cfg2.Callback then cfg2.Callback(col) end end)
                tw(pF,{Size=UDim2.new(1,0,0,110)},.18)
            end)
            local Obj={}; function Obj:Set(c) col=c; sw.BackgroundColor3=c end; function Obj:Get() return col end; return Obj
        end

        return Tab
    end

    -- Animate in
    win.Size = UDim2.fromOffset(0,0)
    tw(win, { Size=UDim2.fromOffset(680,460) }, .3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return Window
end

return KsxPanel
