local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer

local Config = {
    Aimbot = false,
    Smoothness = 0.12,
    FOV = 150,
    AimPart = "Head",
    WallCheck = true,
    TeamCheck = true,
    Visible = false,
    Accent = Color3.fromRGB(0, 180, 255),
    Prediction = 0.135
}

if plr.PlayerGui:FindFirstChild("BOLABOLA_PAINEL") then 
    plr.PlayerGui.BOLABOLA_PAINEL:Destroy() 
end

local screen = Instance.new("ScreenGui", plr.PlayerGui)
screen.Name = "BOLABOLA_PAINEL"
screen.ResetOnSpawn = false

local Main = Instance.new("Frame", screen)
Main.Size = UDim2.new(0, 620, 0, 400)
Main.Position = UDim2.new(0.5, -310, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Main.Visible = false

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(40, 40, 45)
Stroke.Thickness = 1.5


local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "BOLABOLA_Notification"
NotificationFrame.AnchorPoint = Vector2.new(1, 1)
NotificationFrame.Position = UDim2.new(1, -20, 1, -20)
NotificationFrame.Size = UDim2.new(0, 300, 0, 70)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NotificationFrame.BackgroundTransparency = 0.3
NotificationFrame.BorderSizePixel = 0
Instance.new("UICorner", NotificationFrame).CornerRadius = UDim.new(0, 10)

local NotificationStroke = Instance.new("UIStroke", NotificationFrame)
NotificationStroke.Color = Color3.fromRGB(255, 255, 255)
NotificationStroke.Transparency = 0.7
NotificationStroke.Thickness = 1.2
NotificationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local NotificationText = Instance.new("TextLabel", NotificationFrame)
NotificationText.Size = UDim2.new(1, -20, 1, -10)
NotificationText.Position = UDim2.new(0, 10, 0, 5)
NotificationText.BackgroundTransparency = 1
NotificationText.Text = "BOLABOLA PAINEL loaded successfully!\nPress INSERT to open menu"
NotificationText.Font = Enum.Font.GothamSemibold
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 16
NotificationText.TextWrapped = true
NotificationText.TextXAlignment = Enum.TextXAlignment.Left
NotificationText.TextYAlignment = Enum.TextYAlignment.Center

NotificationFrame.Parent = screen
NotificationFrame.Visible = true

task.delay(4, function()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(NotificationFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(NotificationStroke, tweenInfo, {Transparency = 1}):Play()
    TweenService:Create(NotificationText, tweenInfo, {TextTransparency = 1}):Play()
    
    task.delay(1.5, function()
        NotificationFrame:Destroy()
    end)
end)


local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local MainTitle = Instance.new("TextLabel", TitleBar)
MainTitle.Size = UDim2.new(1, -20, 1, 0)
MainTitle.Position = UDim2.new(0, 15, 0, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "BOLABOLA PAINEL"
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextColor3 = Config.Accent
MainTitle.TextSize = 24
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.TextYAlignment = Enum.TextYAlignment.Center


local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 170, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, 0, 1, -100)
TabHolder.Position = UDim2.new(0, 0, 0, 80)
TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.Padding = UDim.new(0, 5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function AnimateClick(button)
    button.MouseButton1Click:Connect(function()
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(20, 20, 23)}):Play()
    end)
end

local Pages = {}
local function NewTab(name)
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Size = UDim2.new(1, -190, 1, -65)
    Page.Position = UDim2.new(0, 180, 0, 55)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Config.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.85, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)
    AnimateClick(TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

local HomeTab    = NewTab("Dashboard")
local CombatTab  = NewTab("Combat")
local AnimTab    = NewTab("Animations")
local SettingTab = NewTab("Settings")
local MiscTab    = NewTab("Misc")


local ProfileFrame = Instance.new("Frame", HomeTab)
ProfileFrame.Size = UDim2.new(1.8, 0, 0, 100)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", ProfileFrame).CornerRadius = UDim.new(0, 12)

local Avatar = Instance.new("ImageLabel", ProfileFrame)
Avatar.Size = UDim2.new(0, 60, 0, 60); Avatar.Position = UDim2.new(0, 15, 0, 20)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=150&h=150"
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local WelcomeText = Instance.new("TextLabel", ProfileFrame)
WelcomeText.Position = UDim2.new(0, 85, 0, 25); WelcomeText.Size = UDim2.new(1, -100, 0, 20)
WelcomeText.Text = "Welcome back, " .. plr.DisplayName; WelcomeText.Font = Enum.Font.GothamBold; WelcomeText.TextColor3 = Color3.new(1,1,1); WelcomeText.TextSize = 16; WelcomeText.BackgroundTransparency = 1; WelcomeText.TextXAlignment = "Left"

local StatusText = Instance.new("TextLabel", ProfileFrame)
StatusText.Position = UDim2.new(0, 85, 0, 45); StatusText.Size = UDim2.new(1, -100, 0, 20)
StatusText.Text = "Status: Active | Version: 3.0 PRO"; StatusText.Font = Enum.Font.Gotham; StatusText.TextColor3 = Config.Accent; StatusText.TextSize = 12; StatusText.BackgroundTransparency = 1; StatusText.TextXAlignment = "Left"

local function AddToggle(tab, title, callback, default)
    local Tgl = Instance.new("TextButton", tab)
    Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Tgl.Text = "  " .. title
    Tgl.Font = Enum.Font.GothamSemibold; Tgl.TextColor3 = Color3.fromRGB(200, 200, 200); Tgl.TextSize = 12; Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Size = UDim2.new(0, 205, 0, 45)
    Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 10)
    
    local Indicator = Instance.new("Frame", Tgl)
    Indicator.Size = UDim2.new(0, 4, 1, 0); Indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Indicator.BorderSizePixel = 0
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1,0)

    local active = default or false
    if active then Indicator.BackgroundColor3 = Config.Accent; Tgl.TextColor3 = Color3.new(1,1,1) end

    Tgl.MouseButton1Click:Connect(function()
        active = not active
        Indicator.BackgroundColor3 = active and Config.Accent or Color3.fromRGB(40, 40, 45)
        Tgl.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
        callback(active)
    end)
end

AddToggle(CombatTab, "Master Aimbot", function(s) Config.Aimbot = s end, false)
AddToggle(CombatTab, "Wall Check", function(s) Config.WallCheck = s end, true)
AddToggle(CombatTab, "Team Check", function(s) Config.TeamCheck = s end, true)
AddToggle(CombatTab, "Silent FOV", function(s) end, false)


task.delay(0.1, function()
    if CombatTab and CombatTab:FindFirstChild("UIListLayout") then
        CombatTab.CanvasSize = UDim2.new(0, 0, 0, CombatTab.UIListLayout.AbsoluteContentSize.Y + 40)
    end
end)

AddToggle(SettingTab, "Fast Run", function(s) 
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = s and 60 or 16 
    end
end, false)

local RespawnButton = Instance.new("TextButton", SettingTab)
RespawnButton.Size = UDim2.new(0.45, 0, 0, 50)
RespawnButton.Position = UDim2.new(0.05, 0, 0, 120)
RespawnButton.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
RespawnButton.Text = "Respawn"
RespawnButton.Font = Enum.Font.GothamBold
RespawnButton.TextColor3 = Color3.fromRGB(220, 255, 220)
RespawnButton.TextSize = 16
Instance.new("UICorner", RespawnButton).CornerRadius = UDim.new(0, 10)

RespawnButton.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.Health = 0
    end
end)

local RejoinButton = Instance.new("TextButton", SettingTab)
RejoinButton.Size = UDim2.new(0.45, 0, 0, 50)
RejoinButton.Position = UDim2.new(0.5, 10, 0, 120)
RejoinButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
RejoinButton.Text = "Rejoin Server"
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextColor3 = Color3.fromRGB(255, 220, 220)
RejoinButton.TextSize = 16
Instance.new("UICorner", RejoinButton).CornerRadius = UDim.new(0, 10)

RejoinButton.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
end)

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = Config.FOV
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Transparency = 0.75
fovCircle.Color = Config.Accent

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Camera.ViewportSize / 2
    fovCircle.Radius = Config.FOV
    fovCircle.Visible = Config.Aimbot and Config.Visible
    fovCircle.Color = Config.Accent
end)

local function isPartVisible(part)
    if not Config.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 999
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {plr.Character or {}}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, rayParams)
    return result and result.Instance and result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestPlayer()
    local closest, minDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player == plr or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then continue end
        if Config.TeamCheck and player.Team == plr.Team then continue end

        local part = player.Character:FindFirstChild(Config.AimPart) or player.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local screen, visible = Camera:WorldToViewportPoint(part.Position)
        if not visible then continue end

        local dist = (Vector2.new(screen.X, screen.Y) - mousePos).Magnitude
        if dist > Config.FOV then continue end
        if Config.WallCheck and not isPartVisible(part) then continue end

        if dist < minDist then
            minDist = dist
            closest = part
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot then return end
    local target = getClosestPlayer()
    if not target then return end

    local predicted = target.Position + target.Velocity * Config.Prediction
    local targetCF = CFrame.new(Camera.CFrame.Position, predicted)
    Camera.CFrame = Camera.CFrame:Lerp(targetCF, Config.Smoothness)
end)


local AnimListLayout = Instance.new("UIListLayout", AnimTab)
AnimListLayout.SortOrder = Enum.SortOrder.LayoutOrder
AnimListLayout.Padding = UDim.new(0, 10)

local AnimPadding = Instance.new("UIPadding", AnimTab)
AnimPadding.PaddingTop = UDim.new(0, 15)
AnimPadding.PaddingBottom = UDim.new(0, 15)
AnimPadding.PaddingLeft = UDim.new(0, 12)
AnimPadding.PaddingRight = UDim.new(0, 12)

local ResetBtn = Instance.new("TextButton", AnimTab)
ResetBtn.Size = UDim2.new(0.45, 0, 0, 45)
ResetBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
ResetBtn.Text = "Reset Animation"
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
ResetBtn.TextSize = 15
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 10)
ResetBtn.LayoutOrder = 1

ResetBtn.MouseEnter:Connect(function() TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 30, 30)}):Play() end)
ResetBtn.MouseLeave:Connect(function() TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}):Play() end)

ResetBtn.MouseButton1Click:Connect(function()
    local char = plr.Character
    if not char then return end
    local Animate = char:FindFirstChild("Animate")
    if not Animate then return end
    Animate.Disabled = true
    for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    
    Animate.idle.Animation1.AnimationId     = "rbxassetid://507766666"
    Animate.idle.Animation2.AnimationId     = "rbxassetid://507766951"
    Animate.walk.WalkAnim.AnimationId       = "rbxassetid://507777826"
    Animate.run.RunAnim.AnimationId         = "rbxassetid://507767714"
    Animate.jump.JumpAnim.AnimationId       = "rbxassetid://507765000"
    Animate.fall.FallAnim.AnimationId       = "rbxassetid://507767968"
    Animate.climb.ClimbAnim.AnimationId     = "rbxassetid://507765644"
    
    Animate.Disabled = false
    char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end)

local Spacer = Instance.new("Frame", AnimTab)
Spacer.Size = UDim2.new(1,0,0,10)
Spacer.BackgroundTransparency = 1
Spacer.LayoutOrder = 2

local function SetAnimation(ids)
    local char = plr.Character
    if not char then return end
    task.wait(0.1)
    local Animate = char:FindFirstChild("Animate")
    if not Animate then return end
    Animate.Disabled = true
    for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    
    local anims = {
        Animate.idle.Animation1,
        Animate.idle.Animation2,
        Animate.walk.WalkAnim,
        Animate.run.RunAnim,
        Animate.jump.JumpAnim,
        Animate.fall.FallAnim,
        Animate.climb.ClimbAnim
    }
    
    for i, id in ipairs(ids) do
        if anims[i] and id and id > 0 then
            anims[i].AnimationId = "rbxassetid://" .. tostring(id)
        end
    end
    
    Animate.Disabled = false
    char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

local animationPacks = {
    {"Vampire",        {1083445855, 1083450166, 1083473930, 1083462077, 1083455352, 1083439238, 1083443587}},
    {"Hero",           {616111295, 616113536, 616122287, 616117076, 616115533, 616104706, 616108001}},
    {"Ghost",          {616006778, 616008087, 616010382, 616013216, 616008936, 616003713, 616005863}},
    {"Elder",          {845397899, 845400520, 845403856, 845386501, 845398858, 845392038, 845396048}},
    {"Mage",           {707742142, 707855907, 707897309, 707861613, 707853694, 707826056, 707829716}},
    {"Catwalk",        {133806214992291, 94970088341563, 109168724482748, 81024476153754, 116936326516985, 119377220967554, 92294537340807}},
    {"Levitation",     {616006778, 616008087, 616010382, 616013216, 616008936, 616003713, 616005863}},
    {"Astronaut",      {891621366, 891633237, 891667138, 891636393, 891627522, 891609353, 891617961}},
    {"Ninja",          {656117400, 656118341, 656121766, 656118852, 656117878, 656114359, 656115606}},
    {"Adidas",         {122257458498464, 102357151005774, 122150855457006, 82598234841035, 75290611992385, 88763136693023, 98600215928904}},
    {"Adidas Classic", {18537376492, 18537371272, 18537392113, 18537384940, 18537380791, 18537363391, 18537367238}},
    {"Cartoon",        {742637544, 742638445, 742640026, 742638842, 742637942, 742636889, 742637151}},
    {"Pirate",         {750781874, 750782770, 750785693, 750783738, 750782230, 750779899, 750780242}},
    {"Sneaky",         {1132473842, 1132477671, 1132510133, 1132494274, 1132489853, 1132461372, 1132469004}},
    {"Toy",            {782841498, 782845736, 782843345, 782842708, 782847020, 782843869, 782846423}},
    {"Knight",         {657595757, 657568135, 657552124, 657564596, 658409194, 658360781, 657600338}},
    {"Confident",      {1069977950, 1069987858, 1070017263, 1070001516, 1069984524, 1069946257, 1069973677}},
    {"Popstar",        {1212900985, 1212900985, 1212980338, 1212980348, 1212954642, 1213044953, 1212900995}},
    {"Princess",       {941003647, 941013098, 941028902, 941015281, 941008832, 940996062, 941000007}},
    {"Cowboy",         {1014390418, 1014398616, 1014421541, 1014401683, 1014394726, 1014380606, 1014384571}},
    {"Patrol",         {1149612882, 1150842221, 1151231493, 1150967949, 1150944216, 1148811837, 1148863382}},
    {"Werewolf",       {1083195517, 1083214717, 1083178339, 1083216690, 1083218792, 1083182000, 1083189019}},
    {"Robot",          {10921248039, 10921248831, 10921255446, 10921250460, 10921252123, 10921247141, 10921251156}},
    {"Zombie",         {3489171152, 3489171152, 3489174223, 3489173414, 616161997, 616156119, 616157476}},
    {"Zombie Classic", {616158929, 616160636, 616168032, 616163682, 616161997, 616156119, 616157476}},
}

for i, pack in ipairs(animationPacks) do
    local name, ids = pack[1], pack[2]
    local btn = Instance.new("TextButton", AnimTab)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.LayoutOrder = 10 + i
    AnimateClick(btn)
    
    btn.MouseButton1Click:Connect(function()
        SetAnimation(ids)
        print("Applied pack: " .. name)
    end)
end

AnimTab:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
    AnimTab.CanvasSize = UDim2.new(0, 0, 0, AnimListLayout.AbsoluteContentSize.Y + 60)
end)


local MiscBackground = Instance.new("Frame", MiscTab)
MiscBackground.Size = UDim2.new(1, 0, 1, 0)
MiscBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MiscBackground.BackgroundTransparency = 0.4
local gradient = Instance.new("UIGradient", MiscBackground)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 40))
}
MiscBackground.Parent = MiscTab

local LoadEmotesBtn = Instance.new("TextButton", MiscTab)
LoadEmotesBtn.Size = UDim2.new(0.75, 0, 0, 90)
LoadEmotesBtn.Position = UDim2.new(0.125, 0, 0.35, 0)
LoadEmotesBtn.BackgroundColor3 = Color3.fromRGB(35, 70, 140)
LoadEmotesBtn.Text = "Load Free Emotes"
LoadEmotesBtn.Font = Enum.Font.GothamBlack
LoadEmotesBtn.TextColor3 = Color3.fromRGB(230, 240, 255)
LoadEmotesBtn.TextSize = 28
Instance.new("UICorner", LoadEmotesBtn).CornerRadius = UDim.new(0, 16)
local uiStroke = Instance.new("UIStroke", LoadEmotesBtn)
uiStroke.Color = Config.Accent
uiStroke.Thickness = 2.5
uiStroke.Transparency = 0.4

AnimateClick(LoadEmotesBtn)

LoadEmotesBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    end)
    if success then
        print("Free Emotes loaded successfully!")
    else
        warn("Error loading emotes: " .. tostring(err))
    end
end)


local function ToggleUI()
    Config.Visible = not Config.Visible
    local target = Config.Visible and UDim2.new(0.5, -310, 0.5, -200) or UDim2.new(0.5, -310, -2, 0)
    
    local duration = Config.Visible and 0.35 or 0.7
    local easing = Config.Visible and Enum.EasingStyle.Quad or Enum.EasingStyle.Quint
    
    TweenService:Create(Main, TweenInfo.new(duration, easing, Enum.EasingDirection.Out), {Position = target}):Play()
    
    if Config.Visible then
        Main.Visible = true
    else
        task.delay(duration, function()
            if not Config.Visible then
                Main.Visible = false
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightControl then
        ToggleUI()
    end
end)

print("BOLABOLA ULTRA executed successfully! Press INSERT to open")

HomeTab.Visible = true
