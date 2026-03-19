--[[
    ██╗  ██╗███████╗██╗  ██╗    ███████╗    ██████╗  █████╗ ███╗   ██╗███████╗██╗     
    ██║ ██╔╝██╔════╝╚██╗██╔╝    ██╔════╝    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
    █████╔╝ ███████╗ ╚███╔╝     ███████╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
    ██╔═██╗ ╚════██║ ██╔██╗     ╚════██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
    ██║  ██╗███████║██╔╝ ██╗    ███████║    ██║     ██║  ██║██║ ╚████║███████╗███████╗
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
    
    ksx's Panel  –  A sleek Roblox Script UI Library
    Version: 1.0.0
    Author: BOLABOLA
    
    Usage:
        local KsxPanel = loadstring(...)()
        local Window = KsxPanel:CreateWindow({ Title = "My Hub", Subtitle = "by ksx" })
        local Tab = Window:Tab({ Title = "Main", Icon = "⚡" })
        Tab:Toggle({ Title = "Fly", Default = false, Callback = function(v) end })
        Tab:Slider({ Title = "Speed", Min = 0, Max = 100, Default = 16, Callback = function(v) end })
        Tab:Button({ Title = "Click Me", Callback = function() end })
        Tab:Dropdown({ Title = "Mode", Options = {"A","B","C"}, Callback = function(v) end })
        Tab:Input({ Title = "Name", Placeholder = "Enter...", Callback = function(v) end })
        Tab:Label({ Title = "Some text info" })
        Tab:Separator()
        KsxPanel:Notify({ Title = "Hello!", Message = "Loaded!", Duration = 3 })
]]

local KsxPanel = {}
KsxPanel.__index = KsxPanel
KsxPanel.Version = "1.0.0"

-- ─────────────────────────────────────────────
--  Services
-- ─────────────────────────────────────────────
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ─────────────────────────────────────────────
--  Theme
-- ─────────────────────────────────────────────
local Theme = {
    -- Background layers
    BG          = Color3.fromHex("#0d0d12"),
    BGPanel     = Color3.fromHex("#13131a"),
    BGElement   = Color3.fromHex("#1a1a24"),
    BGHover     = Color3.fromHex("#20202e"),

    -- Borders
    Border      = Color3.fromHex("#2a2a3d"),
    BorderAccent = Color3.fromHex("#3d3d5c"),

    -- Accent / Brand
    Accent      = Color3.fromHex("#7c6ff7"),   -- violet
    AccentDim   = Color3.fromHex("#4e4899"),
    AccentGlow  = Color3.fromHex("#a99ff8"),

    -- Text
    TextPrimary   = Color3.fromHex("#e8e6ff"),
    TextSecondary = Color3.fromHex("#8884aa"),
    TextMuted     = Color3.fromHex("#55527a"),

    -- States
    Success     = Color3.fromHex("#4ade80"),
    Warning     = Color3.fromHex("#facc15"),
    Danger      = Color3.fromHex("#f87171"),
    Info        = Color3.fromHex("#60a5fa"),

    -- Toggle on/off
    ToggleOn    = Color3.fromHex("#7c6ff7"),
    ToggleOff   = Color3.fromHex("#2a2a3d"),
}

-- ─────────────────────────────────────────────
--  Utility helpers
-- ─────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    t     = t     or 0.18
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t, style, dir), props):Play()
end

local function create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, mousePos, framePos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            mousePos  = input.Position
            framePos  = frame.Position
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

local function addRipple(button, color)
    button.ClipsDescendants = true
    button.MouseButton1Click:Connect(function()
        local ripple = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(Mouse.X - button.AbsolutePosition.X, Mouse.Y - button.AbsolutePosition.Y),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = color or Color3.new(1,1,1),
            BackgroundTransparency = 0.7,
            ZIndex = button.ZIndex + 5,
            Parent = button,
        })
        create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ripple })

        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.2
        tween(ripple, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 }, 0.45)
        task.delay(0.5, function() ripple:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  Notification system
-- ─────────────────────────────────────────────
local NotifHolder

local function ensureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = create("ScreenGui", {
        Name = "KsxPanelNotifs",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    NotifHolder = create("Frame", {
        Name = "Holder",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.fromOffset(320, 0),
        BackgroundTransparency = 1,
        Parent = sg,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        Parent = NotifHolder,
    })
end

function KsxPanel:Notify(cfg)
    ensureNotifHolder()
    cfg = cfg or {}
    local title   = cfg.Title   or "ksx's Panel"
    local msg     = cfg.Message or cfg.Content or ""
    local dur     = cfg.Duration or 4
    local accent  = cfg.Color or Theme.Accent

    local card = create("Frame", {
        Name = "Notif",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.BGPanel,
        BackgroundTransparency = 0,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    create("UICorner",  { CornerRadius = UDim.new(0, 10), Parent = card })
    create("UIStroke",  { Color = Theme.Border, Thickness = 1, Parent = card })

    -- Accent stripe
    create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = card,
    })

    local pad = create("Frame", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -12, 1, 0),
        BackgroundTransparency = 1,
        Parent = card,
    })
    create("UIListLayout", { Padding = UDim.new(0, 2), Parent = pad })
    create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = pad })

    create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 18),
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pad,
    })

    if msg ~= "" then
        create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = msg,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = pad,
        })
    end

    -- Progress bar
    local bar = create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = card,
    })

    -- Animate in
    tween(card, { Size = UDim2.new(1, 0, 0, msg ~= "" and 70 or 48) }, 0.25)
    task.delay(0.05, function()
        tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, dur - 0.3, Enum.EasingStyle.Linear)
    end)

    task.delay(dur, function()
        tween(card, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.2)
        task.delay(0.25, function() card:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  Window
-- ─────────────────────────────────────────────
function KsxPanel:CreateWindow(cfg)
    cfg = cfg or {}
    local title    = cfg.Title    or "ksx's Panel"
    local subtitle = cfg.Subtitle or ""
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift

    -- ScreenGui
    local sg = create("ScreenGui", {
        Name = "KsxPanel_" .. title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ── Main Window Frame ──────────────────────────────────────────────────
    local win = create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(680, 460),
        BackgroundColor3 = Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = sg,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = win })
    create("UIStroke", { Color = Theme.Border, Thickness = 1.2, Parent = win })

    -- Subtle glow shadow
    local glow = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 60, 1, 60),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.88,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = win.ZIndex - 1,
        Parent = win,
    })

    -- ── Topbar ────────────────────────────────────────────────────────────
    local topbar = create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.BGPanel,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = win,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = topbar })
    -- Bottom-square corners hack
    create("Frame", {
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = Theme.BGPanel,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = topbar,
    })

    -- Accent line under topbar
    create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = topbar,
    })

    -- Title
    create("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Text = title .. (subtitle ~= "" and ("  <font transparency='0.45' size='13'>" .. subtitle .. "</font>") or ""),
        RichText = true,
        TextColor3 = Theme.TextPrimary,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = topbar,
    })

    -- Topbar image buttons (close, minimize, fullscreen)
    -- Estrutura: TextButton (fundo colorido + clique) + ImageLabel filho (ícone visível por cima)
    local function makeTopBtn(color, xOff, iconId, callback)
        -- Botão base (fundo colorido, captura cliques)
        local btn = create("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, xOff, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            BackgroundColor3 = color,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 6,
            Parent = topbar,
        })
        create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })

        -- Imagem por cima do fundo
        local icon = create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(12, 12),
            BackgroundTransparency = 1,
            Image = iconId,
            ImageColor3 = Color3.new(1, 1, 1),
            ZIndex = 7,
            Parent = btn,
        })

        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundTransparency = 0.2 }, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundTransparency = 0 }, 0.1)
        end)
        btn.MouseButton1Click:Connect(callback)

        -- retorna btn e icon para poder trocar a imagem depois
        return btn, icon
    end

    -- 🔴 Vermelho – Destruir painel
    makeTopBtn(
        Color3.fromHex("#ff5f57"), -14,
        "rbxassetid://104914974782570",
        function()
            tween(win, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, 0.22)
            task.delay(0.25, function() sg:Destroy() end)
        end
    )

    -- 🟢 Verde – Minimizar / restaurar
    local minimized = false
    makeTopBtn(
        Color3.fromHex("#28c840"), -34,
        "rbxassetid://133760664135962",
        function()
            if not minimized then
                tween(win, { Size = UDim2.fromOffset(680, 46) }, 0.22)
            else
                tween(win, { Size = UDim2.fromOffset(680, 460) }, 0.22)
            end
            minimized = not minimized
        end
    )

    -- 🟡 Amarelo – Tela cheia toggle (troca ícone ao clicar)
    local fullscreen = false
    local ICON_EXPAND = "rbxassetid://100024618512724"
    local ICON_SHRINK = "rbxassetid://106458431521571"
    local normalSize  = UDim2.fromOffset(680, 460)
    local fullSize    = UDim2.new(1, -20, 1, -20)

    local _, yellowIcon = makeTopBtn(
        Color3.fromHex("#febc2e"), -54,
        ICON_EXPAND,
        function()
            fullscreen = not fullscreen
            if fullscreen then
                yellowIcon.Image = ICON_SHRINK
                tween(win, { Size = fullSize }, 0.25, Enum.EasingStyle.Quart)
            else
                yellowIcon.Image = ICON_EXPAND
                tween(win, { Size = normalSize }, 0.25, Enum.EasingStyle.Quart)
            end
        end
    )

    -- Draggable
    makeDraggable(win, topbar)

    -- ── Sidebar ───────────────────────────────────────────────────────────
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 46),
        Size = UDim2.new(0, 150, 1, -46),
        BackgroundColor3 = Theme.BGPanel,
        BorderSizePixel = 0,
        ZIndex = 2,
        ClipsDescendants = true,
        Parent = win,
    })
    -- Left bottom corner round
    create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = sidebar })
    create("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = Theme.BGPanel,
        BorderSizePixel = 0,
        Parent = sidebar,
    })
    create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 14, 1, 0),
        BackgroundColor3 = Theme.BGPanel,
        BorderSizePixel = 0,
        Parent = sidebar,
    })

    -- Separator line
    create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = sidebar,
    })

    local tabList = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = tabList })
    create("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = tabList })

    -- ── Content area ──────────────────────────────────────────────────────
    local contentArea = create("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(151, 46),
        Size = UDim2.new(1, -151, 1, -46),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = win,
    })

    -- ─────────────────────────────────────────────
    --  Window object
    -- ─────────────────────────────────────────────
    local Window = {}
    Window._tabs      = {}
    Window._activeTab = nil
    Window._sg        = sg

    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            win.Visible = not win.Visible
        end
    end)

    -- ── Tab constructor ────────────────────────────────────────────────────
    function Window:Tab(tcfg)
        tcfg = tcfg or {}
        local tabTitle = tcfg.Title or "Tab"
        local tabIcon  = tcfg.Icon  or ""

        -- Sidebar button
        local btn = create("TextButton", {
            Name = "TabBtn_" .. tabTitle,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.BGElement,
            BackgroundTransparency = 1,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 5,
            Parent = tabList,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

        -- Active indicator bar
        local indicator = create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(3, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 6,
            Parent = btn,
        })
        create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })

        local lbl = create("TextLabel", {
            Position = UDim2.fromOffset(tabIcon ~= "" and 30 or 12, 0),
            Size = UDim2.new(1, tabIcon ~= "" and -34 or -16, 1, 0),
            Text = tabTitle,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = btn,
        })

        if tabIcon ~= "" then
            create("TextLabel", {
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.fromOffset(20, 34),
                Text = tabIcon,
                TextColor3 = Theme.TextSecondary,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = btn,
            })
        end

        -- Scroll frame for tab content
        local scroll = create("ScrollingFrame", {
            Name = "Content_" .. tabTitle,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.AccentDim,
            BorderSizePixel = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = contentArea,
        })
        create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = scroll })
        create("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = scroll })

        local Tab = {}
        Tab._scroll = scroll
        Tab._btn    = btn

        local function activate()
            -- Deactivate all
            for _, t in ipairs(Window._tabs) do
                t._scroll.Visible = false
                tween(t._btn, { BackgroundTransparency = 1 }, 0.15)
                tween(t._btn:FindFirstChild("UIStroke") and t._btn or t._btn, {}, 0)
                -- label colour
                local l = t._btn:FindFirstChildWhichIsA("TextLabel")
                if l then tween(l, { TextColor3 = Theme.TextSecondary }, 0.15) end
                -- indicator
                local ind = t._btn:FindFirstChild(tostring(t._btn) .. "ind") or t._btn:FindFirstChildWhichIsA("Frame")
                if ind then tween(ind, { Size = UDim2.fromOffset(3, 0) }, 0.15) end
            end

            -- Activate this
            scroll.Visible = true
            tween(btn, { BackgroundTransparency = 0 }, 0.15)
            tween(lbl, { TextColor3 = Theme.TextPrimary }, 0.15)
            tween(indicator, { Size = UDim2.fromOffset(3, 20) }, 0.15)
            Window._activeTab = Tab
        end

        btn.MouseButton1Click:Connect(activate)
        btn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then
                tween(btn, { BackgroundTransparency = 0.6 }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then
                tween(btn, { BackgroundTransparency = 1 }, 0.1)
            end
        end)

        table.insert(Window._tabs, Tab)
        if #Window._tabs == 1 then activate() end

        -- ── Element helpers ────────────────────────────────────────────────
        local function makeCard(h)
            local card = create("Frame", {
                Size = UDim2.new(1, 0, 0, h or 40),
                BackgroundColor3 = Theme.BGElement,
                BorderSizePixel = 0,
                Parent = scroll,
            })
            create("UICorner", { CornerRadius = UDim.new(0, 9), Parent = card })
            return card
        end

        local function titleLabel(parent, text, desc, xOff)
            xOff = xOff or 12
            create("TextLabel", {
                Position = UDim2.fromOffset(xOff, desc and 7 or 0),
                Size = UDim2.new(1, -xOff - 60, 0, desc and 18 or 40),
                Text = text or "",
                TextColor3 = Theme.TextPrimary,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = parent,
            })
            if desc then
                create("TextLabel", {
                    Position = UDim2.fromOffset(xOff, 26),
                    Size = UDim2.new(1, -xOff - 60, 0, 14),
                    Text = desc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = parent,
                })
            end
        end

        -- ── Button ─────────────────────────────────────────────────────────
        function Tab:Button(cfg)
            cfg = cfg or {}
            local card = makeCard(cfg.Desc and 52 or 40)
            local color = cfg.Color or Theme.Accent

            titleLabel(card, cfg.Title, cfg.Desc)

            local clickZone = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = card.ZIndex + 1,
                Parent = card,
            })
            create("UICorner", { CornerRadius = UDim.new(0, 9), Parent = clickZone })
            addRipple(clickZone, color)

            clickZone.MouseEnter:Connect(function() tween(card, { BackgroundColor3 = Theme.BGHover }, 0.12) end)
            clickZone.MouseLeave:Connect(function() tween(card, { BackgroundColor3 = Theme.BGElement }, 0.12) end)
            clickZone.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)

            -- Accent right dot
            create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(6, 6),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                ZIndex = card.ZIndex + 1,
                Parent = card,
            }):SetAttribute("corner", true)
            for _, v in ipairs(card:GetChildren()) do
                if v:IsA("Frame") and v:GetAttribute("corner") then
                    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = v })
                end
            end

            local Obj = {}
            function Obj:SetTitle(t) end
            return Obj
        end

        -- ── Toggle ─────────────────────────────────────────────────────────
        function Tab:Toggle(cfg)
            cfg = cfg or {}
            local state = cfg.Default or cfg.Value or false
            local card = makeCard(cfg.Desc and 52 or 40)
            titleLabel(card, cfg.Title, cfg.Desc)

            -- Track
            local track = create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(38, 22),
                BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel = 0,
                ZIndex = card.ZIndex + 2,
                Parent = card,
            })
            create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

            -- Knob
            local knob = create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = state and UDim2.fromOffset(18, 11) or UDim2.fromOffset(3, 11),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = track.ZIndex + 1,
                Parent = track,
            })
            create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = track.ZIndex + 2,
                Parent = card,
            })

            btn.MouseButton1Click:Connect(function()
                state = not state
                tween(track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                tween(knob, { Position = state and UDim2.fromOffset(18, 11) or UDim2.fromOffset(3, 11) }, 0.2)
                if cfg.Callback then cfg.Callback(state) end
            end)

            local Obj = {}
            function Obj:Set(v)
                state = v
                tween(track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                tween(knob, { Position = state and UDim2.fromOffset(18, 11) or UDim2.fromOffset(3, 11) }, 0.2)
            end
            function Obj:Get() return state end
            return Obj
        end

        -- ── Slider ─────────────────────────────────────────────────────────
        function Tab:Slider(cfg)
            cfg = cfg or {}
            local min  = cfg.Min     or 0
            local max  = cfg.Max     or 100
            local step = cfg.Step    or 1
            local val  = cfg.Default or cfg.Value or min
            local card = makeCard(cfg.Desc and 66 or 54)

            titleLabel(card, cfg.Title, cfg.Desc)

            -- Value label
            local valLbl = create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, cfg.Desc and 7 or 10),
                Size = UDim2.fromOffset(50, 18),
                Text = tostring(val),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = card,
            })

            -- Track BG
            local trackBg = create("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 12, 1, -10),
                Size = UDim2.new(1, -24, 0, 4),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Parent = card,
            })
            create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBg })

            -- Fill
            local fill = create("Frame", {
                Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = trackBg,
            })
            create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

            -- Thumb
            local thumb = create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale((val - min) / (max - min), 0.5),
                Size = UDim2.fromOffset(14, 14),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = trackBg.ZIndex + 2,
                Parent = trackBg,
            })
            create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
            create("UIStroke", { Color = Theme.Accent, Thickness = 2, Parent = thumb })

            -- Input zone
            local zone = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 22),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0, 0.5),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = trackBg.ZIndex + 3,
                Parent = trackBg,
            })

            local function updateSlider(x)
                local abs = trackBg.AbsoluteSize.X
                local rel = math.clamp((x - trackBg.AbsolutePosition.X) / abs, 0, 1)
                local raw = min + (max - min) * rel
                local snapped = math.round(raw / step) * step
                snapped = math.clamp(snapped, min, max)
                val = snapped
                valLbl.Text = tostring(val)
                local pct = (val - min) / (max - min)
                tween(fill, { Size = UDim2.fromScale(pct, 1) }, 0.05)
                tween(thumb, { Position = UDim2.fromScale(pct, 0.5) }, 0.05)
                if cfg.Callback then cfg.Callback(val) end
            end

            local sliding = false
            zone.MouseButton1Down:Connect(function()
                sliding = true
                updateSlider(Mouse.X)
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            RunService.RenderStepped:Connect(function()
                if sliding then updateSlider(Mouse.X) end
            end)

            local Obj = {}
            function Obj:Set(v)
                val = math.clamp(v, min, max)
                valLbl.Text = tostring(val)
                local pct = (val - min) / (max - min)
                fill.Size = UDim2.fromScale(pct, 1)
                thumb.Position = UDim2.fromScale(pct, 0.5)
            end
            function Obj:Get() return val end
            return Obj
        end

        -- ── Dropdown ───────────────────────────────────────────────────────
        function Tab:Dropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or cfg.Values or {}
            local selected = cfg.Default or cfg.Value or (options[1])
            local multi = cfg.Multi or false
            local multiSelected = {}

            local card = makeCard(cfg.Desc and 52 or 40)
            titleLabel(card, cfg.Title, cfg.Desc)

            local selLbl = create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -36, 0.5, 0),
                Size = UDim2.fromOffset(110, 20),
                Text = multi and "Select..." or tostring(selected),
                TextColor3 = Theme.TextSecondary,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            -- Arrow
            local arrow = create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(18, 18),
                Text = "▾",
                TextColor3 = Theme.TextMuted,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                BackgroundTransparency = 1,
                Parent = card,
            })

            local open = false
            local dropFrame

            local function closeDropdown()
                if dropFrame then
                    tween(dropFrame, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.18)
                    task.delay(0.2, function()
                        if dropFrame then dropFrame:Destroy(); dropFrame = nil end
                    end)
                    tween(arrow, { Rotation = 0 }, 0.18)
                    open = false
                end
            end

            local openBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = card.ZIndex + 1,
                Parent = card,
            })

            openBtn.MouseButton1Click:Connect(function()
                if open then closeDropdown(); return end
                open = true
                tween(arrow, { Rotation = 180 }, 0.18)

                local itemH = 32
                local h = math.min(#options, 6) * itemH + 8
                dropFrame = create("Frame", {
                    Position = UDim2.new(0, 0, 1, 4),
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Theme.BGPanel,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    ZIndex = card.ZIndex + 10,
                    Parent = card,
                })
                create("UICorner", { CornerRadius = UDim.new(0, 9), Parent = dropFrame })
                create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = dropFrame })

                local list = create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = dropFrame,
                })
                create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = list })
                create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = list })

                for _, opt in ipairs(options) do
                    local isSelected = multi and table.find(multiSelected, opt) or (opt == selected)
                    local row = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, itemH - 2),
                        BackgroundColor3 = isSelected and Theme.AccentDim or Color3.fromHex("#00000000"),
                        BackgroundTransparency = isSelected and 0 or 1,
                        Text = "",
                        BorderSizePixel = 0,
                        ZIndex = dropFrame.ZIndex + 1,
                        Parent = list,
                    })
                    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })
                    create("TextLabel", {
                        Position = UDim2.fromOffset(10, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Text = tostring(opt),
                        TextColor3 = isSelected and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = row.ZIndex + 1,
                        Parent = row,
                    })

                    row.MouseEnter:Connect(function()
                        if not (opt == selected and not multi) then
                            tween(row, { BackgroundTransparency = 0.6 }, 0.1)
                        end
                    end)
                    row.MouseLeave:Connect(function()
                        if not (opt == selected and not multi) then
                            tween(row, { BackgroundTransparency = 1 }, 0.1)
                        end
                    end)
                    row.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(multiSelected, opt)
                            if idx then table.remove(multiSelected, idx)
                            else table.insert(multiSelected, opt) end
                            selLbl.Text = #multiSelected > 0 and table.concat(multiSelected, ", ") or "Select..."
                            if cfg.Callback then cfg.Callback(multiSelected) end
                        else
                            selected = opt
                            selLbl.Text = tostring(opt)
                            if cfg.Callback then cfg.Callback(opt) end
                            closeDropdown()
                        end
                    end)
                end

                tween(dropFrame, { Size = UDim2.new(1, 0, 0, h) }, 0.18)
            end)

            local Obj = {}
            function Obj:Set(v) selected = v; selLbl.Text = tostring(v) end
            function Obj:Get() return multi and multiSelected or selected end
            function Obj:Refresh(newOpts)
                options = newOpts
                closeDropdown()
            end
            return Obj
        end

        -- ── Input ──────────────────────────────────────────────────────────
        function Tab:Input(cfg)
            cfg = cfg or {}
            local card = makeCard(cfg.Desc and 66 or 54)
            titleLabel(card, cfg.Title, cfg.Desc)

            local box = create("TextBox", {
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 12, 1, -8),
                Size = UDim2.new(1, -24, 0, 26),
                BackgroundColor3 = Theme.BG,
                BorderSizePixel = 0,
                PlaceholderText = cfg.Placeholder or "Type here...",
                PlaceholderColor3 = Theme.TextMuted,
                Text = cfg.Default or cfg.Value or "",
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                ZIndex = card.ZIndex + 1,
                Parent = card,
            })
            create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = box })
            create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = box })
            create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = box })

            box.Focused:Connect(function()
                tween(box:FindFirstChildWhichIsA("UIStroke"), { Color = Theme.Accent }, 0.15)
            end)
            box.FocusLost:Connect(function(enter)
                tween(box:FindFirstChildWhichIsA("UIStroke"), { Color = Theme.Border }, 0.15)
                if cfg.Callback then cfg.Callback(box.Text) end
            end)

            local Obj = {}
            function Obj:Set(v) box.Text = v end
            function Obj:Get() return box.Text end
            return Obj
        end

        -- ── Label ──────────────────────────────────────────────────────────
        function Tab:Label(cfg)
            cfg = cfg or {}
            local lf = create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = scroll,
            })
            create("TextLabel", {
                Position = UDim2.fromOffset(4, 0),
                Size = UDim2.new(1, -8, 1, 0),
                Text = cfg.Title or cfg.Text or "",
                TextColor3 = cfg.Color or Theme.TextSecondary,
                TextSize = cfg.TextSize or 13,
                Font = Enum.Font.Gotham,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = lf,
            })
        end

        -- ── Separator ──────────────────────────────────────────────────────
        function Tab:Separator(cfg)
            cfg = cfg or {}
            local sep = create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Parent = scroll,
            })
            if cfg.Label then
                sep.Size = UDim2.new(1, 0, 0, 22)
                sep.BackgroundTransparency = 1
                local line = create("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0,
                    Parent = sep,
                })
                create("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 18),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Text = "  " .. cfg.Label .. "  ",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    BackgroundColor3 = Theme.BG,
                    BorderSizePixel = 0,
                    ZIndex = line.ZIndex + 1,
                    Parent = sep,
                })
            end
        end

        -- ── Colorpicker ────────────────────────────────────────────────────
        function Tab:Colorpicker(cfg)
            cfg = cfg or {}
            local color = cfg.Default or Color3.fromRGB(255, 100, 100)
            local card = makeCard(40)
            titleLabel(card, cfg.Title)

            local swatch = create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(28, 20),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                ZIndex = card.ZIndex + 1,
                Parent = card,
            })
            create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = swatch })
            create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = swatch })

            -- Simple RGB input popup (lightweight)
            local pickerOpen = false
            local pickerFrame

            local function closePicker()
                if pickerFrame then
                    tween(pickerFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
                    task.delay(0.2, function() if pickerFrame then pickerFrame:Destroy(); pickerFrame = nil end end)
                    pickerOpen = false
                end
            end

            local swatchBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = swatch.ZIndex + 1,
                Parent = card,
            })

            swatchBtn.MouseButton1Click:Connect(function()
                if pickerOpen then closePicker(); return end
                pickerOpen = true

                pickerFrame = create("Frame", {
                    Position = UDim2.new(0, 0, 1, 4),
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Theme.BGPanel,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    ZIndex = card.ZIndex + 10,
                    Parent = card,
                })
                create("UICorner", { CornerRadius = UDim.new(0, 9), Parent = pickerFrame })
                create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = pickerFrame })

                local r, g, b = math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255)

                local pad = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = pickerFrame })
                create("UIListLayout", { Padding = UDim.new(0, 4), Parent = pad })
                create("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = pad })

                local function makeChannel(label, defVal, callback)
                    local row = create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = pad })
                    create("TextLabel", { Size = UDim2.fromOffset(16, 26), Text = label, TextColor3 = Theme.TextMuted, TextSize = 12, Font = Enum.Font.GothamBold, BackgroundTransparency = 1, Parent = row })
                    local tb = create("TextBox", {
                        Position = UDim2.fromOffset(20, 3),
                        Size = UDim2.new(1, -20, 0, 20),
                        BackgroundColor3 = Theme.BG,
                        BorderSizePixel = 0,
                        Text = tostring(defVal),
                        TextColor3 = Theme.TextPrimary,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        Parent = row,
                    })
                    create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tb })
                    create("UIPadding", { PaddingLeft = UDim.new(0, 6), Parent = tb })
                    tb.FocusLost:Connect(function()
                        local n = tonumber(tb.Text)
                        if n then callback(math.clamp(math.round(n), 0, 255)) end
                    end)
                end

                makeChannel("R", r, function(v) r = v; color = Color3.fromRGB(r, g, b); swatch.BackgroundColor3 = color; if cfg.Callback then cfg.Callback(color) end end)
                makeChannel("G", g, function(v) g = v; color = Color3.fromRGB(r, g, b); swatch.BackgroundColor3 = color; if cfg.Callback then cfg.Callback(color) end end)
                makeChannel("B", b, function(v) b = v; color = Color3.fromRGB(r, g, b); swatch.BackgroundColor3 = color; if cfg.Callback then cfg.Callback(color) end end)

                tween(pickerFrame, { Size = UDim2.new(1, 0, 0, 110) }, 0.18)
            end)

            local Obj = {}
            function Obj:Set(c) color = c; swatch.BackgroundColor3 = c end
            function Obj:Get() return color end
            return Obj
        end

        return Tab
    end

    -- ── SetToggleKey ────────────────────────────────────────────────────────
    function Window:SetToggleKey(key)
        toggleKey = key
    end

    -- ── Destroy ─────────────────────────────────────────────────────────────
    function Window:Destroy()
        tween(win, { Size = UDim2.fromOffset(0, 0) }, 0.22)
        task.delay(0.25, function() sg:Destroy() end)
    end

    -- Animate in
    win.Size = UDim2.fromOffset(0, 0)
    tween(win, { Size = UDim2.fromOffset(680, 460) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return Window
end

return KsxPanel
