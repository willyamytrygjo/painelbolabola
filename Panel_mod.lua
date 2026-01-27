if getgenv().GUI_Loaded then return end; getgenv().GUI_Loaded = true

local version, discordCode, ownerId = "4.5.6", "ksxs", 3961485767
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local S = setmetatable({}, { __index = function(t,k) local s=game:GetService(k); t[k]=s; return s end })
local plr, placeId = S.Players.LocalPlayer, game.PlaceId
local userId, placeName, jobId, Camera, Mouse, isMobile = plr.UserId, S.MarketplaceService:GetProductInfo(placeId).Name, game.JobId, game.Workspace.CurrentCamera, plr:GetMouse(), S.UserInputService.TouchEnabled and not S.UserInputService.KeyboardEnabled

local function SendNotify(title, message, duration) S.StarterGui:SetCore("SendNotification", { Title = title, Text = message, Duration = duration; }) end

local function httpRequest(method, url, headers, body)
        local r = httprequest({Url=url, Method=method or "GET", Headers=headers, Body=body})
        return r and r.Body and select(2, pcall(S.HttpService.JSONDecode, S.HttpService, r.Body))
end

local function goDiscord(code)
        local code = code or discordCode; setclipboard("https://discord.gg/"..code)
        httpRequest(
                'POST', 'http://127.0.0.1:6463/rpc?v=1', { ['Content-Type'] = 'application/json', Origin = 'https://discord.com' },
                S.HttpService:JSONEncode({ cmd = 'INVITE_BROWSER', nonce = S.HttpService:GenerateGUID(false), args = {code = code} })
        )
end

local function RequestAPI(route) return httpRequest("GET", "https://api-ksxspanel-h3xv.onrender.com/"..route) end

local function IsUserBanned()
        local data = RequestAPI("is-banned/"..userId.."?place_name="..S.HttpService:UrlEncode(placeName).."&place_id="..placeId.."&job_id="..jobId)
        if not data then return nil end; if data.is_banned then return true end
        is_vip, is_staff, _broadcast = data.is_vip == true, data.is_staff == true, data.broadcast
        return false
end; is_banned = IsUserBanned()

if is_banned == nil then
        getgenv().GUI_Loaded = false; return
elseif is_banned then
        SendNotify("ksx's Panel", "Voc├¬ est├í banido do ksx's Panel\nContate o suporte: https://discord.gg/"..discordCode, 10); goDiscord(); task.wait(10)
        getgenv().GUI_Loaded = false; return
end

local function GetPing() return math.floor(S.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end

local function GetStats()
    local data = RequestAPI("get-stats")
    if not data then return "" end
        return "\n\nOnline: <font color='rgb(200,200,200)'>"..(data.online_count or 0).."</font>".."\nUsers: <font color='rgb(200,200,200)'>"..(data.total_count or 0).."</font>".."\n\nDate: <font color='rgb(200,200,200)'>"..(data.current_date or "N/A").."</font>"
end

local function GetData()
    local data = RequestAPI("get-data/"..jobId)
    if not data then return {}, {} end
    return data.tags or {}, data.users or {}
end

task.spawn(function() while true do _stats = GetStats(); _tags, _users = GetData(); task.wait(10) end end)

local function GetVip()
        local data = RequestAPI("is-vip/"..userId.."?permission=3f6a0f5d9c7a8d7c2a5d8a7c2c4cbe5c9a7c1e3d9f3f4c9e9f2f8a6d5c6b4a2")
        if not data then return "", "", "", "", "", "" end
        return data["Fling"] or "", data["AntiFling"] or "", data["AntiForce"] or "", data["AntiChatSpy"] or "", data["AutoSacrifice"] or "", data["EscapeHandcuffs"] or ""
end; if is_vip then vip_fling, vip_antifling, vip_antiforce, vip_antichatspy, vip_autosacrifice, vip_escapehandcuffs = GetVip(); if vip_fling == "" then is_vip = false end end; last_vip_state = is_vip

task.spawn(function()
        for _,p in ipairs({ {"AntiCheat", "FlingDetected"}, {"AntiCheat", "GuiThreatDetected"}, {"KickSystem", "KickFeedback"} }) do
                local f=S.ReplicatedStorage:FindFirstChild(p[1]); if f then local x=f:FindFirstChild(p[2]); if x then x:Destroy() end end
        end
end)

if not isfolder("ksx") then makefolder("ksx") end
local __path = "ksx/settings.json"

function WriteFile(section, key, value)
        local data = (isfile(__path) and S.HttpService:JSONDecode(readfile(__path))) or {}
        if key then data[section] = data[section] or {}; data[section][key] = value else data[section] = value end
        writefile(__path, S.HttpService:JSONEncode(data))
end

function LoadFile(section, key, default)
        if isfile(__path) then
                local data = S.HttpService:JSONDecode(readfile(__path))
                if key and data[section] then return data[section][key] or default else return data[section] or default end
        end; return default
end

Themes = {
        Dark = {
                BackgroundColor3_title = Color3.fromRGB(0, 0, 0), BackgroundColor3_button = Color3.fromRGB(100, 100, 100), BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3_credits = Color3.fromRGB(255, 255, 255), BorderColor3 = Color3.fromRGB(45, 45, 45), ImageColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(150, 150, 150), PlaceholderTextColor3 = Color3.fromRGB(140, 140, 140)
        },
        Light = {
                BackgroundColor3_title = Color3.fromRGB(255, 255, 255), BackgroundColor3_button = Color3.fromRGB(225, 225, 225), BackgroundColor3 = Color3.fromRGB(150, 150, 150), TextColor3_credits = Color3.fromRGB(0, 0, 0), BorderColor3 = Color3.fromRGB(255, 255, 255), ImageColor3 = Color3.fromRGB(150, 150, 150), TextColor3 = Color3.fromRGB(0, 0, 0), PlaceholderTextColor3 = Color3.fromRGB(35, 35, 35)
        },
        Slate = {
                BackgroundColor3_title = Color3.fromRGB(40, 50, 60), BackgroundColor3_button = Color3.fromRGB(100, 120, 140), BackgroundColor3 = Color3.fromRGB(70, 80, 100), TextColor3_credits = Color3.fromRGB(230, 235, 240), BorderColor3 = Color3.fromRGB(60, 70, 85), ImageColor3 = Color3.fromRGB(30, 35, 45), TextColor3 = Color3.fromRGB(210, 215, 225), PlaceholderTextColor3 = Color3.fromRGB(180, 185, 195)
        },
        Blue = {
                BackgroundColor3_title = Color3.fromRGB(20, 20, 80), BackgroundColor3_button = Color3.fromRGB(80, 80, 200), BackgroundColor3 = Color3.fromRGB(60, 60, 170), TextColor3_credits = Color3.fromRGB(230, 230, 255), BorderColor3 = Color3.fromRGB(0, 0, 130), ImageColor3 = Color3.fromRGB(0, 0, 60), TextColor3 = Color3.fromRGB(210, 210, 255), PlaceholderTextColor3 = Color3.fromRGB(180, 180, 255)
        },
        Pink = {
                BackgroundColor3_title = Color3.fromRGB(80, 20, 80), BackgroundColor3_button = Color3.fromRGB(200, 80, 200), BackgroundColor3 = Color3.fromRGB(170, 60, 170), TextColor3_credits = Color3.fromRGB(255, 230, 255), BorderColor3 = Color3.fromRGB(130, 0, 130), ImageColor3 = Color3.fromRGB(60, 0, 60), TextColor3 = Color3.fromRGB(255, 210, 255), PlaceholderTextColor3 = Color3.fromRGB(255, 180, 255)
        },
        Violet = {
                BackgroundColor3_title = Color3.fromRGB(60, 0, 90), BackgroundColor3_button = Color3.fromRGB(150, 80, 200), BackgroundColor3 = Color3.fromRGB(110, 40, 160), TextColor3_credits = Color3.fromRGB(240, 220, 255), BorderColor3 = Color3.fromRGB(90, 0, 130), ImageColor3 = Color3.fromRGB(40, 0, 70), TextColor3 = Color3.fromRGB(220, 200, 245), PlaceholderTextColor3 = Color3.fromRGB(200, 170, 230)
        },
        Ruby = {
                BackgroundColor3_title = Color3.fromRGB(150, 0, 20), BackgroundColor3_button = Color3.fromRGB(220, 40, 50), BackgroundColor3 = Color3.fromRGB(190, 20, 35), TextColor3_credits = Color3.fromRGB(255, 230, 235), BorderColor3 = Color3.fromRGB(170, 0, 25), ImageColor3 = Color3.fromRGB(90, 0, 10), TextColor3 = Color3.fromRGB(245, 210, 215), PlaceholderTextColor3 = Color3.fromRGB(230, 180, 185)
        },
        Gold = {
                BackgroundColor3_title = Color3.fromRGB(180, 140, 20), BackgroundColor3_button = Color3.fromRGB(220, 180, 40), BackgroundColor3 = Color3.fromRGB(150, 110, 15), TextColor3_credits = Color3.fromRGB(255, 240, 200), BorderColor3 = Color3.fromRGB(200, 160, 30), ImageColor3 = Color3.fromRGB(120, 90, 10), TextColor3 = Color3.fromRGB(255, 230, 150), PlaceholderTextColor3 = Color3.fromRGB(230, 200, 120)
        },
        Sand = {
                BackgroundColor3_title = Color3.fromRGB(200, 180, 120), BackgroundColor3_button = Color3.fromRGB(230, 210, 150), BackgroundColor3 = Color3.fromRGB(180, 160, 100), TextColor3_credits = Color3.fromRGB(60, 50, 20), BorderColor3 = Color3.fromRGB(210, 190, 130), ImageColor3 = Color3.fromRGB(140, 120, 70), TextColor3 = Color3.fromRGB(80, 70, 30), PlaceholderTextColor3 = Color3.fromRGB(110, 100, 60)
        },
        Ocean = {
                BackgroundColor3_title = Color3.fromRGB(0, 70, 90), BackgroundColor3_button = Color3.fromRGB(40, 160, 180), BackgroundColor3 = Color3.fromRGB(20, 120, 140), TextColor3_credits = Color3.fromRGB(220, 255, 255), BorderColor3 = Color3.fromRGB(0, 100, 120), ImageColor3 = Color3.fromRGB(0, 50, 60), TextColor3 = Color3.fromRGB(200, 240, 250), PlaceholderTextColor3 = Color3.fromRGB(170, 220, 230)
        },
        Cyber = {
                BackgroundColor3_title = Color3.fromRGB(40, 0, 60), BackgroundColor3_button = Color3.fromRGB(0, 200, 255), BackgroundColor3 = Color3.fromRGB(20, 0, 40), TextColor3_credits = Color3.fromRGB(200, 255, 255), BorderColor3 = Color3.fromRGB(0, 150, 200), ImageColor3 = Color3.fromRGB(15, 0, 25), TextColor3 = Color3.fromRGB(180, 255, 255), PlaceholderTextColor3 = Color3.fromRGB(150, 230, 230)
        },
}; savedTheme = LoadFile("Theme", "value", "Dark"); Theme = Themes[savedTheme] or Themes.Dark
if not is_vip and savedTheme ~= "Dark" and savedTheme ~= "Light" then Theme = Themes.Dark; WriteFile("Theme", "value", "Dark") end

local ThemedElements = {}
local function RegisterThemedElement(instance, properties)
        ThemedElements[instance] = properties
        for prop, themeKey in pairs(properties) do if Theme[themeKey] then instance[prop] = Theme[themeKey] end end
end

local function ChangeTheme(theme)
        for instance, properties in pairs(ThemedElements) do
                for prop, themeKey in pairs(properties) do if theme[themeKey] then instance[prop] = theme[themeKey] end end
        end
end

local function ChangeToggleColor(Button)
        local led = Button.Ticket_Asset
        if led.ImageColor3 == Color3.fromRGB(255, 0, 0) then led.ImageColor3 = Color3.fromRGB(0, 255, 0) else led.ImageColor3 = Color3.fromRGB(255, 0, 0) end
end

local function GetPlayer(UserDisplay)
        if UserDisplay ~= "" then
                for i,v in pairs(S.Players:GetPlayers()) do
                        if v.Name:lower():match(UserDisplay) or v.DisplayName:lower():match(UserDisplay) then return v end
                end; return nil
        else return nil end
end

local function GetCharacter(Player) if Player.Character then return Player.Character end end

local function GetRoot(Player) if GetCharacter(Player):FindFirstChild("HumanoidRootPart") then return GetCharacter(Player).HumanoidRootPart end end

local function TeleportTO(posX,posY,posZ,player,method)
        pcall(function()
                local root = GetRoot(plr)
                if not root then return end
                if method ~= "safe" then
                        root.Velocity = Vector3.new(0,0,0)
                        if player == "pos" then root.CFrame = CFrame.new(posX,posY,posZ) else root.CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0) end
                else
                        task.spawn(function()
                                for i = 1,30 do task.wait()
                                        root.Velocity = Vector3.new(0,0,0)
                                        if player == "pos" then root.CFrame = CFrame.new(posX,posY,posZ) else root.CFrame = CFrame.new(GetRoot(player).Position)+Vector3.new(0,2,0) end
                                end
                        end)
                end
        end)
end

local function Touch(x,root)
        pcall(function()
                x = x:FindFirstAncestorWhichIsA("Part")
                if x then if firetouchinterest then task.spawn(function() firetouchinterest(x, root, 1); task.wait(); firetouchinterest(x, root, 0) end) end end
        end)
end

local function StopAnim()
        plr.Character.Animate.Disabled = false
        for _, track in pairs(plr.Character.Humanoid:GetPlayingAnimationTracks()) do track:Stop() end
end

local function PlayAnim(id,time,speed)
        pcall(function()
                StopAnim()
                plr.Character.Animate.Disabled = true
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://"..id
                local loadanim = plr.Character.Humanoid:LoadAnimation(Anim)
                loadanim:Play()
                loadanim.TimePosition = time
                loadanim:AdjustSpeed(speed)
                loadanim.Stopped:Connect(function() StopAnim() end)
        end)
end

local function Instantiate(class, props)
        local inst = Instance.new(class); for prop, val in pairs(props) do if val ~= nil then pcall(function() inst[prop] = val end) end end
        return inst
end

local function UICorner(parent, value) Instantiate("UICorner", { Parent = parent, CornerRadius = UDim.new(value or 0.1, 0) }) end

local function randomString()
        local array = {}; for i = 1, math.random(10, 20) do array[i] = string.char(math.random(32, 126)) end
        return table.concat(array)
end

local GUI = Instantiate("ScreenGui", { Name = tostring(randomString()), Parent = plr:WaitForChild("PlayerGui"),
        ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local NotifyList = Instantiate("Frame", { Name = "NotifyList", Parent = GUI,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -50), Size = UDim2.new(0, 260, 1, -50),
        AnchorPoint = Vector2.new(1, 1),
        ZIndex = 100
})

local NotifyLayout = Instantiate("UIListLayout", { Parent = NotifyList,
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom
})

SendNotify = function(title, message, duration)
        local duration, height = duration or 3, #message > 40 and 85 or 70

        local NotifFrame = Instantiate("Frame", { Parent = NotifyList,
                BackgroundTransparency = 0.05, BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true
        }); UICorner(NotifFrame, 0.1); RegisterThemedElement(NotifFrame, {BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3"})

        local AccentBar = Instantiate("Frame", { Parent = NotifFrame,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 4, 1, 0),
                ZIndex = 102
        }); UICorner(AccentBar, 0); RegisterThemedElement(AccentBar, {BackgroundColor3 = "BackgroundColor3_button"})

        local TitleLbl = Instantiate("TextLabel", { Parent = NotifFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -15, 0, 20),
                Text = title, Font = Enum.Font.Oswald,
                TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left,
                RichText = true, AutoLocalize = false,
                ZIndex = 102
        }); RegisterThemedElement(TitleLbl, {TextColor3 = "TextColor3"})

        local MsgLbl = Instantiate("TextLabel", {
                Parent = NotifFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(1, -15, 1, -26),
                Text = message, Font = Enum.Font.Gotham,
                TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                RichText = true, AutoLocalize = false,
                ZIndex = 102
        }); RegisterThemedElement(MsgLbl, {TextColor3 = "TextColor3"})

        local ProgressBg = Instantiate("Frame", { Parent = NotifFrame,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -3), Size = UDim2.new(1, 0, 0, 3),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                ZIndex = 103
    })

    local ProgressBar = Instantiate("Frame", { Parent = ProgressBg,
                BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 104
    }); RegisterThemedElement(ProgressBar, {BackgroundColor3 = "BackgroundColor3_button"})

        S.TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, height)}):Play()
        S.TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

        task.delay(duration, function()
                if NotifFrame and NotifFrame.Parent then
                        S.TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play(); task.wait(0.3)
                        ThemedElements[NotifFrame], ThemedElements[AccentBar], ThemedElements[TitleLbl], ThemedElements[MsgLbl], ThemedElements[ProgressBar] = nil, nil, nil, nil, nil; NotifFrame:Destroy()
                end
        end)
end

local Background = Instantiate("ImageLabel", { Name = "Background", Parent = GUI, Active = true,
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 500, 0, 350),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://89548031362604", ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Crop, TileSize = UDim2.new(0, 30, 0, 30),
        SliceCenter = Rect.new(0, 256, 0, 256), ZIndex = 9
}); RegisterThemedElement(Background, {BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3", ImageColor3 = "ImageColor3"})

local TitleBarLabel = Instantiate("TextLabel", { Name = "TitleBarLabel", Parent = Background,
        BackgroundTransparency = 0.25, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Text = "ksx's Panel", Font = Enum.Font.Unknown,
        TextSize = 14, TextScaled = true, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center,
        AutoLocalize = false
}); RegisterThemedElement(TitleBarLabel, {BackgroundColor3 = "BackgroundColor3_title", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})

if Background.Draggable then Background.Draggable = false end
local guiObject, dragHandle = Background, TitleBarLabel

local dragging = false
local lastInput, dragStart, startPos
local function dragUpdate()
    if not dragging or not lastInput then return end
    local delta = lastInput.Position - dragStart
    local s, g = Camera.ViewportSize, guiObject.AbsoluteSize
    local clampX = math.clamp((0.5 * s.X) + startPos.X.Offset + delta.X, g.X*0.5-3, s.X-g.X*0.5+3) - (0.5*s.X)
    local clampY = math.clamp((0.5 * s.Y) + startPos.Y.Offset + delta.Y, g.Y*0.5-3, s.Y-g.Y*0.5+3) - (0.5*s.Y)
    guiObject.Position = guiObject.Position:Lerp(UDim2.new(0.5, clampX, 0.5, clampY), 0.12)
end
dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos, lastInput = true, input.Position, guiObject.Position, input
        end
end)
dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                lastInput = input
        end
end)
S.UserInputService.InputChanged:Connect(function(input)
        if dragging and input == lastInput then
                dragUpdate()
        end
end)
S.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
        end
end)

local VersionLabel = Instantiate("TextLabel", { Name = "VersionLabel", Parent = Background,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 4, 0, 2), Size = UDim2.new(0.1, 0, 0, 20),
        Text = "v"..version, Font = Enum.Font.Unknown,
        TextSize = 14, TextScaled = true, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
}); RegisterThemedElement(VersionLabel, {BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})

local SectionList = Instantiate("ScrollingFrame", { Name = "SectionList", Parent = Background,
        BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0, BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(0, 105, 0, 320),
        ScrollBarThickness = 2.5, CanvasSize = UDim2.new(0, 0, is_staff and 1.258 or 1.142, 0)
})

local function CreateSectionButton(name, order)
        local yPos = 5 + (order - 1) * (30 + 10)
        local section_button = Instantiate("TextButton", { Name = name, Parent = SectionList,
                BackgroundTransparency = 0.5, BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, yPos), Size = UDim2.new(0, 105, 0, 30),
                Text = name, Font = Enum.Font.Oswald,
                TextSize = 14, TextScaled = true, TextWrapped = true,
                AutoLocalize = false
        }); RegisterThemedElement(section_button, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})
        return section_button
end

local baseSections = { "Home", "VIP", "Emphasis", "Character", "Target", "Animations", "More", "Misc", "Servers", "About" }
if is_staff then table.insert(baseSections, 2, "STAFF") end
local SectionButtons, currentSection = {}, nil
for i, name in ipairs(baseSections) do SectionButtons[name.."_Section_Button"] = CreateSectionButton(name, i) end

local function CreateSectionFrame(name, visible, scrollsize)
        local section_frame = Instantiate("ScrollingFrame", { Name = name, Parent = Background, Active = true, Visible = visible,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Position = UDim2.new(0, 105, 0, 30), Size = UDim2.new(0, 395, 0, 320),
                ScrollBarThickness = 5, CanvasSize = UDim2.new(0, 0, scrollsize or 0, 0)
        }); RegisterThemedElement(section_frame, {BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3"})
        return section_frame
end

local SectionFrames = {
        Home_Section = CreateSectionFrame("Home_Section", true),
        Staff_Section = CreateSectionFrame("Staff_Section", false),
        Vip_Section = CreateSectionFrame("Vip_Section", false),
        Emphasis_Section = CreateSectionFrame("Emphasis_Section", false),
        Character_Section = CreateSectionFrame("Character_Section", false),
        Target_Section = CreateSectionFrame("Target_Section", false, 1.573),
        Animations_Section = CreateSectionFrame("Animations_Section", false, 2.790),
        More_Section = CreateSectionFrame("More_Section", false),
        Misc_Section = CreateSectionFrame("Misc_Section", false),
        Servers_Section = CreateSectionFrame("Servers_Section", false),
    About_Section = CreateSectionFrame("About_Section", false)
}

local Profile_Image = Instantiate("ImageLabel", { Name = "Profile_Image", Parent = SectionFrames.Home_Section,
        BorderSizePixel = 1,
        Position = UDim2.new(0, 25, 0, 25), Size = UDim2.new(0, 100, 0, 100),
        Image = S.Players:GetUserThumbnailAsync(userId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
}); RegisterThemedElement(Profile_Image, {BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3"})

local function CreateSectionFrameLabel(name, parent, text, position, size, font, textsize)
        local section_frame_label = Instantiate("TextLabel", { Name = name, Parent = parent,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Position = position, Size = size,
                Text = text, Font = font or Enum.Font.SourceSans,
                TextSize = textsize or 24, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                RichText = true, AutoLocalize = false
        }); RegisterThemedElement(section_frame_label, {BackgroundColor3 = "BackgroundColor3", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})
        return section_frame_label
end

CreateSectionFrameLabel("Welcome_Label", SectionFrames.Home_Section, ("Ol├í! "..plr.DisplayName..".\nPressione [B] para abrir/fechar o painel"), UDim2.new(0, 172.5, 0, 36), UDim2.new(0, 200, 0, 100))

local function CreateSectionFrameLink(name, parent, text, position, size, textsize)
        local section_frame_link = CreateSectionFrameLabel(name, parent, text, position, size, nil, textsize)
        section_frame_link.Active = true
        section_frame_link.TextColor3 = Color3.fromRGB(0, 100, 255)
        RegisterThemedElement(section_frame_link, {TextColor3 = section_frame_link.TextColor3})
        return section_frame_link
end

CreateSectionFrameLabel("Partnership_Label", SectionFrames.Home_Section, "<font color='rgb(255,0,0)'>P</font>".."<font color='rgb(255,165,0)'>a</font>".."<font color='rgb(255,255,0)'>r</font>".."<font color='rgb(0,255,0)'>t</font>".."<font color='rgb(0,255,255)'>n</font>".."<font color='rgb(0,0,255)'>e</font>".."<font color='rgb(128,0,128)'>r</font>".."<font color='rgb(255,0,255)'>s</font>".."<font color='rgb(255,105,180)'>h</font>".."<font color='rgb(75,0,130)'>i</font>".."<font color='rgb(148,0,211)'>p</font>".."<font color='rgb(255,255,255)'>:</font>", UDim2.new(0, 259, 0, 149.5), UDim2.new(0, 200, 0, 100))
Partnership_Link = CreateSectionFrameLink("Partnership_Link", SectionFrames.Home_Section, "robux barato", UDim2.new(0, 261, 0, 172.5), UDim2.new(0, 98, 0, 20), 22)

local ViewTag_Button = Instantiate("ImageButton", { Name = "ViewTag_Button", Parent = SectionFrames.Home_Section,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 322, 0, 250), Size = UDim2.new(0, 40, 0, 40),
        Image = "rbxassetid://119030989234087"
})

local function CreateSectionFrameButton(name, parent, order, yOverride, isTextBox, placeholder)
        local xPos, yPos = (order % 2 == 1) and 25 or 210, (25 + math.floor((order - 1) / 2) * 50) + (yOverride or 0)
        local section_frame_button
        if isTextBox then
                section_frame_button = Instance.new("TextBox")
                section_frame_button.Text = ""
                section_frame_button.PlaceholderText = placeholder or ""
                section_frame_button.Font = Enum.Font.Gotham
                section_frame_button.TextSize = 18
                section_frame_button.ClearTextOnFocus = true
                RegisterThemedElement(section_frame_button, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3", PlaceholderColor3 = "PlaceholderTextColor3"})
        else
                section_frame_button = Instance.new("TextButton")
                section_frame_button.Text = name
                section_frame_button.Font = Enum.Font.Oswald
                section_frame_button.TextSize = 14
                section_frame_button.TextScaled = true
                RegisterThemedElement(section_frame_button, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})
        end
        section_frame_button.Name = name
        section_frame_button.Parent = parent
        section_frame_button.BackgroundTransparency = 0.5
        section_frame_button.BorderSizePixel = 0
        section_frame_button.Position = UDim2.new(0, xPos, 0, yPos)
        section_frame_button.Size = UDim2.new(0, 150, 0, 30)
        section_frame_button.TextWrapped = true
        section_frame_button.AutoLocalize = false
        UICorner(section_frame_button)
        return section_frame_button
end

CreateSectionFrameLabel("TpUsers_Label", SectionFrames.Staff_Section, "Teleport User:", UDim2.new(0, 140, 0, 25), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28)

local Vip_Buttons = {
        Fling = CreateSectionFrameButton("Fling", SectionFrames.Vip_Section, 1),
        AntiFling = CreateSectionFrameButton("AntiFling", SectionFrames.Vip_Section, 2),
        AntiForce = CreateSectionFrameButton("AntiForce", SectionFrames.Vip_Section, 3),
        AntiChatSpy = CreateSectionFrameButton("AntiChatSpy", SectionFrames.Vip_Section, 4),
        AutoSacrifice = CreateSectionFrameButton("AutoSacrifice", SectionFrames.Vip_Section, 5),
        EscapeHandcuffs = CreateSectionFrameButton("EscapeHandcuffs", SectionFrames.Vip_Section, 6)
        -- CollectOrbs = CreateSectionFrameButton("CollectOrbs", SectionFrames.Vip_Section, 7)
}

local ChangeVipTheme_Button = Instantiate("ImageButton", { Name = "ChangeVipTheme_Button", Parent = SectionFrames.Vip_Section,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 322, 0, 247.2), Size = UDim2.new(0, 40, 0, 40),
        Image = "rbxassetid://112456487988886"
})

local themeIndex, vipThemes = 0, { "Slate", "Blue", "Pink", "Violet", "Ruby", "Gold", "Sand", "Ocean", "Cyber" }
ChangeVipTheme_Button.MouseButton1Click:Connect(function()
        themeIndex += 1; if themeIndex > #vipThemes then themeIndex = 1 end
        local key = vipThemes[themeIndex]; Theme = Themes[key]; ChangeTheme(Theme); WriteFile("Theme", "value", key)
end)

local vipOverlay = Instantiate("ImageButton", { Name = "VIPOverlay", Parent = SectionFrames.Vip_Section,
        BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        AutoButtonColor = false,
        ZIndex = 50,
        Visible = not is_vip
})

Instantiate("ImageLabel", { Name = "BlurEffect", Parent = vipOverlay,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://8992231225", ImageTransparency = 0.6, ImageColor3 = Color3.fromRGB(100, 100, 255),
        ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 150, 0, 150),
        ZIndex = 51
})

local messageContainer = Instantiate("Frame", { Name = "Message_Container", Parent = vipOverlay,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 300, 0, 100),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 52
})

local function CreateVipLabel(name, text, posY, color, sizeY, font)
        return Instantiate("TextLabel", { Name = name, Parent = messageContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, posY), Size = UDim2.new(1, 0, 0, sizeY),
                Text = text, TextColor3 = color, Font = font,
                TextScaled = true, TextWrapped = true,
                ZIndex = 53
        })
end

local messageLabel = CreateVipLabel("VIP_Message", "ADQUIRIR VIP", -10, Color3.fromRGB(255, 255, 0), 50, Enum.Font.Oswald)
CreateVipLabel("VIP_SubMessage", "ACESSE: https://discord.gg/"..discordCode, 40, Color3.fromRGB(255, 255, 255), 30, Enum.Font.SourceSans)

local Emphasis_Buttons = {
        Invisible = CreateSectionFrameButton("Invisible", SectionFrames.Emphasis_Section, 1),
        ClickTP = CreateSectionFrameButton("ClickTP", SectionFrames.Emphasis_Section, 2),
        NoClip = CreateSectionFrameButton("NoClip", SectionFrames.Emphasis_Section, 3),
        JerkOff = CreateSectionFrameButton("JerkOff", SectionFrames.Emphasis_Section, 4),
        Impulse = CreateSectionFrameButton("Impulse", SectionFrames.Emphasis_Section, 5),
        FaceBang = CreateSectionFrameButton("FaceBang", SectionFrames.Emphasis_Section, 6),
        Spin = CreateSectionFrameButton("Spin", SectionFrames.Emphasis_Section, 7),
        AnimSpeed = CreateSectionFrameButton("AnimSpeed", SectionFrames.Emphasis_Section, 8),
        feFlip = CreateSectionFrameButton("feFlip", SectionFrames.Emphasis_Section, 9),
        Flashback = CreateSectionFrameButton("Flashback", SectionFrames.Emphasis_Section, 10),
        AntiVoid = CreateSectionFrameButton("AntiVoid", SectionFrames.Emphasis_Section, 11)
}

local Character_Buttons = {
        WalkSpeed = CreateSectionFrameButton("Walk Speed", SectionFrames.Character_Section, 1),
        WalkSpeed_Input = CreateSectionFrameButton("WalkSpeed_Input", SectionFrames.Character_Section, 2, nil, true, "[0 - n]"),
        JumpPower = CreateSectionFrameButton("Jump Power", SectionFrames.Character_Section, 3),
        JumpPower_Input = CreateSectionFrameButton("JumpPower_Input", SectionFrames.Character_Section, 4, nil, true, "[0 - n]"),
        Fly = CreateSectionFrameButton("Fly", SectionFrames.Character_Section, 5),
        FlySpeed_Input = CreateSectionFrameButton("FlySpeed_Input", SectionFrames.Character_Section, 6, nil, true, "[0 - n]"),
        Respawn = CreateSectionFrameButton("Respawn", SectionFrames.Character_Section, 9),
        Checkpoint = CreateSectionFrameButton("Checkpoint", SectionFrames.Character_Section, 10)
}

local TargetImage = Instantiate("ImageLabel", { Name = "TargetImage", Parent = SectionFrames.Target_Section,
        Position = UDim2.new(0, 25, 0, 25), Size = UDim2.new(0, 100, 0, 100),
        Image = "rbxassetid://10818605405"
}); RegisterThemedElement(TargetImage, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3"})

local TargetName_Input = Instantiate("TextBox", { Name = "TargetName_Input", Parent = SectionFrames.Target_Section,
        BackgroundTransparency = 0.3,
        Position = UDim2.new(0, 150, 0, 25.5), Size = UDim2.new(0, 207.5, 0, 30),
        Text = "", PlaceholderText = "@username...", Font = Enum.Font.Gotham,
        TextSize = 16, TextWrapped = true
}); RegisterThemedElement(TargetName_Input, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3", PlaceholderColor3 = "PlaceholderTextColor3"})

local ClickTargetTool_Button = Instantiate("ImageButton", { Name = "ClickTargetTool_Button", Parent = TargetName_Input,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 172, 0, 44), Size = UDim2.new(0, 35, 0, 35),
        Image = "rbxassetid://80854448131955"
})

local UserIDTargetLabel = CreateSectionFrameLabel("UserIDTargetLabel", SectionFrames.Target_Section, "UserID: \nDisplay: \nCreated: ", UDim2.new(0, 150, 0, 64.98), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 21)

local Target_Buttons = {
        View = CreateSectionFrameButton("View", SectionFrames.Target_Section, 5, 25),
        CopyId = CreateSectionFrameButton("Copy ID", SectionFrames.Target_Section, 6, 25),
        Focus = CreateSectionFrameButton("Focus", SectionFrames.Target_Section, 7, 25),
        Follow = CreateSectionFrameButton("Follow", SectionFrames.Target_Section, 8, 25),
        Stand = CreateSectionFrameButton("Stand", SectionFrames.Target_Section, 9, 25),
        Bang = CreateSectionFrameButton("Bang", SectionFrames.Target_Section, 10, 25),
        Drag = CreateSectionFrameButton("Drag", SectionFrames.Target_Section, 11, 25),
        Headsit = CreateSectionFrameButton("Headsit", SectionFrames.Target_Section, 12, 25),
        Doggy = CreateSectionFrameButton("Doggy", SectionFrames.Target_Section, 13, 25),
        Backpack = CreateSectionFrameButton("Backpack", SectionFrames.Target_Section, 14, 25),
        Bring = CreateSectionFrameButton("Bring", SectionFrames.Target_Section, 15, 25),
        Teleport = CreateSectionFrameButton("Teleport", SectionFrames.Target_Section, 16, 25),
        CreateSectionFrameLabel("CopyTargetLabel", SectionFrames.Target_Section, "Copy Target", UDim2.new(0, 150, 0, 450), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28),
        Animation = CreateSectionFrameButton("Animation", SectionFrames.Target_Section, 19, 25)
}

local Animation_Buttons = {
        Vampire = CreateSectionFrameButton("Vampire", SectionFrames.Animations_Section, 1),
        Hero = CreateSectionFrameButton("Hero", SectionFrames.Animations_Section, 2),
        Ghost = CreateSectionFrameButton("Ghost", SectionFrames.Animations_Section, 3),
        Elder = CreateSectionFrameButton("Elder", SectionFrames.Animations_Section, 4),
        Mage = CreateSectionFrameButton("Mage", SectionFrames.Animations_Section, 5),
        Catwalk = CreateSectionFrameButton("Catwalk", SectionFrames.Animations_Section, 6),
        Levitation = CreateSectionFrameButton("Levitation", SectionFrames.Animations_Section, 7),
        Astronaut = CreateSectionFrameButton("Astronaut", SectionFrames.Animations_Section, 8),
        Ninja = CreateSectionFrameButton("Ninja", SectionFrames.Animations_Section, 9),
        Adidas = CreateSectionFrameButton("Adidas", SectionFrames.Animations_Section, 10),
        AdidasClassic = CreateSectionFrameButton("Adidas Classic", SectionFrames.Animations_Section, 11),
        Cartoon = CreateSectionFrameButton("Cartoon", SectionFrames.Animations_Section, 12),
        Pirate = CreateSectionFrameButton("Pirate", SectionFrames.Animations_Section, 13),
        Sneaky = CreateSectionFrameButton("Sneaky", SectionFrames.Animations_Section, 14),
        Toy = CreateSectionFrameButton("Toy", SectionFrames.Animations_Section, 15),
        Knight = CreateSectionFrameButton("Knight", SectionFrames.Animations_Section, 16),
        Confident = CreateSectionFrameButton("Confident", SectionFrames.Animations_Section, 17),
        Popstar = CreateSectionFrameButton("Popstar", SectionFrames.Animations_Section, 18),
        Princess = CreateSectionFrameButton("Princess", SectionFrames.Animations_Section, 19),
        Cowboy = CreateSectionFrameButton("Cowboy", SectionFrames.Animations_Section, 20),
        Patrol = CreateSectionFrameButton("Patrol", SectionFrames.Animations_Section, 21),
        Werewolf = CreateSectionFrameButton("Werewolf", SectionFrames.Animations_Section, 22),
        Robot = CreateSectionFrameButton("Robot", SectionFrames.Animations_Section, 23),
        Zombie = CreateSectionFrameButton("Zombie", SectionFrames.Animations_Section, 24),
        ZombieClassic = CreateSectionFrameButton("Zombie Classic", SectionFrames.Animations_Section, 25)
}

local CustomAnimation_Buttons = {
        CreateSectionFrameLabel("CustomAnim_Label", SectionFrames.Animations_Section, "Custom Animation", UDim2.new(0, 125, 0, 675), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28),
        Idle = CreateSectionFrameButton("Idle", SectionFrames.Animations_Section, 29),
        Idle_Input = CreateSectionFrameButton("Idle_Input", SectionFrames.Animations_Section, 30, nil, true, "Animation ID"),
        Walk = CreateSectionFrameButton("Walk", SectionFrames.Animations_Section, 31),
        Walk_Input = CreateSectionFrameButton("Walk_Input", SectionFrames.Animations_Section, 32, nil, true, "Animation ID"),
        Run = CreateSectionFrameButton("Run", SectionFrames.Animations_Section, 33),
        Run_Input = CreateSectionFrameButton("Run_Input", SectionFrames.Animations_Section, 34, nil, true, "Animation ID"),
        Jump = CreateSectionFrameButton("Jump", SectionFrames.Animations_Section, 35),
        Jump_Input = CreateSectionFrameButton("Jump_Input", SectionFrames.Animations_Section, 36, nil, true, "Animation ID"),
        Fall = CreateSectionFrameButton("Fall", SectionFrames.Animations_Section, 37),
        Fall_Input = CreateSectionFrameButton("Fall_Input", SectionFrames.Animations_Section, 38, nil, true, "Animation ID")
}

local More_Buttons = {
        CreateSectionFrameLabel("Casual_Label", SectionFrames.More_Section, "Casual", UDim2.new(0, 25, 0, 25), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28),
        PianoAuto = CreateSectionFrameButton("PianoAuto", SectionFrames.More_Section, 3),
        CreateSectionFrameLabel("FPS_Label", SectionFrames.More_Section, "FPS", UDim2.new(0, 25, 0, 125), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28),
        ESP = CreateSectionFrameButton("ESP", SectionFrames.More_Section, 7),
        Aimbot = CreateSectionFrameButton("Aimbot", SectionFrames.More_Section, 8)
}

local Misc_Buttons = {
        AntiAFK = CreateSectionFrameButton("Anti AFK", SectionFrames.Misc_Section, 1),
        TpToOwner = CreateSectionFrameButton("TpToOwner", SectionFrames.Misc_Section, 2),
        Shaders = CreateSectionFrameButton("Shaders", SectionFrames.Misc_Section, 3),
        ChangeTime = CreateSectionFrameButton("Day/Night", SectionFrames.Misc_Section, 4),
        ResetLighting = CreateSectionFrameButton("Reset Lighting", SectionFrames.Misc_Section, 5),
        DestroyUI = CreateSectionFrameButton("Destroy GUI", SectionFrames.Misc_Section, 6),
        FreeEmotes = CreateSectionFrameButton("Free Emotes", SectionFrames.Misc_Section, 7),
        ClearChat = CreateSectionFrameButton("Clear Chat", SectionFrames.Misc_Section, 8),
        Rejoin = CreateSectionFrameButton("Rejoin", SectionFrames.Misc_Section, 9),
        InfYieldPremium = CreateSectionFrameButton("Infinite Premium", SectionFrames.Misc_Section, 10)
}

CreateSectionFrameLabel("Servers_Label", SectionFrames.Servers_Section, "Available Servers:", UDim2.new(0, 125, 0, 25), UDim2.new(0, 300, 0, 75), Enum.Font.Oswald, 28)

CreateSectionFrameLabel("Credits_Label", SectionFrames.About_Section, "Developed by <font color='rgb(255,255,255)'>ksx</font>\n\nVersion: <font color='rgb(255,10,10)'>"..version.."</font>", UDim2.new(0, 25, 0, 25), UDim2.new(0, 200, 0, 100))
CreateSectionFrameLabel("Donate_Label", SectionFrames.About_Section, "Donate:", UDim2.new(0, 107.5, 0, 245), UDim2.new(0, 200, 0, 100), nil, 20)
Donate_Link = CreateSectionFrameLink("Donate_Link", SectionFrames.About_Section, "ajudar projeto", UDim2.new(0, 182.5, 0, 245), UDim2.new(0, 90, 0, 18), 18)
CreateSectionFrameLabel("Support_Label", SectionFrames.About_Section, "Support:", UDim2.new(0, 107.5, 0, 270), UDim2.new(0, 200, 0, 100), nil, 20)
Support_Link = CreateSectionFrameLink("Support_Link", SectionFrames.About_Section, "acessar suporte", UDim2.new(0, 182.5, 0, 270), UDim2.new(0, 98, 0, 18), 18)

local ChangeTheme_Button = Instantiate("ImageButton", { Name = "ChangeTheme_Button", Parent = SectionFrames.About_Section,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 322, 0, 247.2), Size = UDim2.new(0, 40, 0, 40),
        Image = savedTheme == "Dark" and "rbxassetid://111141131115404" or "rbxassetid://99955958887420"
})

local Assets = Instantiate("Folder", { Name = "Assets" })

local Ticket_Asset = Instantiate("ImageButton", { Name = "Ticket_Asset", Parent = Assets,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(1, 5, 0.5, 0), Size = UDim2.new(0, 25, 0, 25),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxassetid://3926305904", ImageColor3 = Color3.fromRGB(255, 0, 0), ImageRectSize = Vector2.new(36, 36), ImageRectOffset = Vector2.new(424, 4),
        LayoutOrder = 5, ZIndex = 2
})

local function CreateToggle(Button) local NewToggle = Ticket_Asset:Clone(); NewToggle.Parent = Button end

local Click_Asset = Instantiate("ImageButton", { Name = "Click_Asset", Parent = Assets,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(1, 5, 0.5, 0), Size = UDim2.new(0, 25, 0, 25),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxassetid://3926305904", ImageColor3 = Color3.fromRGB(100, 100, 100), ImageRectSize = Vector2.new(36, 36), ImageRectOffset = Vector2.new(204, 964),
        ZIndex = 2
})

local function CreateClicker(Button) local NewClicker = Click_Asset:Clone(); NewClicker.Parent = Button end

local Velocity_Asset = Instantiate("BodyAngularVelocity", { Name = "BreakVelocity", Parent = Assets,
        P = 1250, AngularVelocity = Vector3.new(0,0,0), MaxTorque = Vector3.new(50000,50000,50000)
})

local OpenClose = Instantiate("ImageButton", { Name = "OpenClose", Parent = GUI,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0, 30, 0, 30),
        Image = "rbxassetid://107842413848271",
        AutoButtonColor = false
}); UICorner(OpenClose, 1); RegisterThemedElement(OpenClose, {BackgroundColor3 = "BackgroundColor3"})

CreateClicker(Vip_Buttons.Fling); CreateToggle(Vip_Buttons.AntiFling)
CreateClicker(Vip_Buttons.AntiForce); CreateToggle(Vip_Buttons.AntiChatSpy)
CreateClicker(Vip_Buttons.AutoSacrifice); CreateClicker(Vip_Buttons.EscapeHandcuffs)
-- CreateClicker(Vip_Buttons.CollectOrbs)

CreateClicker(Emphasis_Buttons.Invisible); CreateClicker(Emphasis_Buttons.ClickTP)
CreateClicker(Emphasis_Buttons.NoClip); CreateClicker(Emphasis_Buttons.JerkOff)
CreateClicker(Emphasis_Buttons.Impulse); CreateClicker(Emphasis_Buttons.FaceBang)
CreateClicker(Emphasis_Buttons.Spin); CreateClicker(Emphasis_Buttons.AnimSpeed)
CreateClicker(Emphasis_Buttons.feFlip); CreateClicker(Emphasis_Buttons.Flashback)
CreateClicker(Emphasis_Buttons.AntiVoid)

CreateToggle(Character_Buttons.WalkSpeed); CreateToggle(Character_Buttons.JumpPower); CreateToggle(Character_Buttons.Fly)
CreateClicker(Character_Buttons.Respawn); CreateToggle(Character_Buttons.Checkpoint)

CreateToggle(Target_Buttons.View); CreateClicker(Target_Buttons.CopyId)
CreateToggle(Target_Buttons.Focus); CreateToggle(Target_Buttons.Follow)
CreateToggle(Target_Buttons.Stand); CreateToggle(Target_Buttons.Bang)
CreateToggle(Target_Buttons.Drag); CreateToggle(Target_Buttons.Headsit)
CreateToggle(Target_Buttons.Doggy); CreateToggle(Target_Buttons.Backpack)
CreateClicker(Target_Buttons.Bring); CreateClicker(Target_Buttons.Teleport)
CreateToggle(Target_Buttons.Animation)

CreateClicker(Animation_Buttons.Vampire); CreateClicker(Animation_Buttons.Hero)
CreateClicker(Animation_Buttons.Ghost); CreateClicker(Animation_Buttons.Elder)
CreateClicker(Animation_Buttons.Mage); CreateClicker(Animation_Buttons.Catwalk)
CreateClicker(Animation_Buttons.Levitation); CreateClicker(Animation_Buttons.Astronaut)
CreateClicker(Animation_Buttons.Ninja); CreateClicker(Animation_Buttons.Adidas)
CreateClicker(Animation_Buttons.AdidasClassic); CreateClicker(Animation_Buttons.Cartoon)
CreateClicker(Animation_Buttons.Pirate); CreateClicker(Animation_Buttons.Sneaky)
CreateClicker(Animation_Buttons.Toy); CreateClicker(Animation_Buttons.Knight)
CreateClicker(Animation_Buttons.Confident); CreateClicker(Animation_Buttons.Popstar)
CreateClicker(Animation_Buttons.Princess); CreateClicker(Animation_Buttons.Cowboy)
CreateClicker(Animation_Buttons.Patrol); CreateClicker(Animation_Buttons.Werewolf)
CreateClicker(Animation_Buttons.Robot); CreateClicker(Animation_Buttons.Zombie)
CreateClicker(Animation_Buttons.ZombieClassic)
CreateClicker(CustomAnimation_Buttons.Idle)
CreateClicker(CustomAnimation_Buttons.Walk); CreateClicker(CustomAnimation_Buttons.Run)
CreateClicker(CustomAnimation_Buttons.Jump); CreateClicker(CustomAnimation_Buttons.Fall)

CreateClicker(More_Buttons.PianoAuto)
CreateClicker(More_Buttons.ESP); CreateClicker(More_Buttons.Aimbot)

CreateToggle(Misc_Buttons.AntiAFK); CreateClicker(Misc_Buttons.TpToOwner)
CreateToggle(Misc_Buttons.Shaders); CreateToggle(Misc_Buttons.ChangeTime)
CreateClicker(Misc_Buttons.ResetLighting); CreateClicker(Misc_Buttons.DestroyUI)
CreateClicker(Misc_Buttons.FreeEmotes); CreateClicker(Misc_Buttons.ClearChat)
CreateClicker(Misc_Buttons.Rejoin); CreateClicker(Misc_Buttons.InfYieldPremium)

local function ChangeSection(SectionClicked)
        local sectionName = SectionClicked.Name:gsub("_Section_Button", ""):upper(); currentSection = sectionName
        for _, v in ipairs(SectionList:GetChildren()) do
                if v:IsA("TextButton") then
                        local isActive = v == SectionClicked
                        S.TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                BackgroundTransparency = isActive and 0.3 or 0.5, TextTransparency = isActive and 0 or 0.2
                        }):Play()
                end
        end
        for _, frame in ipairs(Background:GetChildren()) do
                if frame:IsA("ScrollingFrame") and frame.Name ~= "SectionList" then
                        frame.Visible = frame.Name:gsub("_Section", ""):upper() == sectionName
                end
        end
end
for _, name in ipairs(baseSections) do
        local button = SectionButtons[name.."_Section_Button"]; button.MouseButton1Click:Connect(function() ChangeSection(button) end)
end

local function GetFormattedPingStats()
    local p = GetPing(); local c = (p <= 79 and "rgb(80,255,80)") or (p <= 149 and "rgb(255,200,50)") or "rgb(255,80,80)"
    return "Ping: <font color='"..c.."'>"..p.."ms</font>"
end

local Stats_Label, stats_lastUpdate = nil, 0
S.RunService.Heartbeat:Connect(function(dt)
    if not _stats then return end
    Stats_Label = Stats_Label or CreateSectionFrameLabel("Stats_Label", SectionFrames.Home_Section, GetFormattedPingStats().._stats, UDim2.new(0, 25, 0, 150), UDim2.new(0, 200, 0, 200))
    stats_lastUpdate = stats_lastUpdate + dt
    if stats_lastUpdate >= 1 then Stats_Label.Text = GetFormattedPingStats().._stats; stats_lastUpdate = 0 end
end)

Partnership_Link.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                goDiscord('UTDNQWABx5'); SendNotify("Link Copiado!", "Cole no navegador para acessar a loja.", 10)
        end
end)
Partnership_Link.MouseEnter:Connect(function() Partnership_Link.TextColor3 = Color3.fromRGB(255, 100, 100) end)
Partnership_Link.MouseLeave:Connect(function() Partnership_Link.TextColor3 = Color3.fromRGB(0, 100, 255) end)

local isTagActive, deviceIcons = true, { mobile = "106664533595965", tablet = "72895940611699", desktop = "71666975026687" }
local _userDevices, _usersSet, _playerTags, _rainbowLabels, _rainbowGradients, _updating, _characterConnections = {}, {}, {}, {}, {}, {}, {}

local function RemoveTag(player)
    if not player or not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if head then
        local old = head:FindFirstChild("NameTagGui")
        if old then old:Destroy() end
    end
    if not _usersSet[player.UserId] and _characterConnections[player.UserId] then
        _characterConnections[player.UserId]:Disconnect(); _characterConnections[player.UserId] = nil
    end
end

local function removeAllTags()
        for _, u in ipairs(_users) do
                local player = S.Players:GetPlayerByUserId(u.user_id); if player then RemoveTag(player); _playerTags[player.UserId] = nil end
        end
end

local function CreateTag(player, tagsLookup)
    if not isTagActive or not player.Character or _updating[player.UserId] or not _usersSet[player.UserId] then return end
    _updating[player.UserId] = true
    local head = player.Character:FindFirstChild("Head")
    if not head then _updating[player.UserId] = nil return end
    local tagData, currentData = tagsLookup and tagsLookup[player.UserId], _playerTags[player.UserId] or {name = "User", color = Color3.fromRGB(255, 255, 255), rainbow = false}
    local newTagName, newTagColor, isRainbow, rainbowType = currentData.name, currentData.color, currentData.rainbow, nil
    if tagData then
        newTagName = tagData.name
        if tagData.color == "Rainbow" or tagData.color == "Rainbow2" then isRainbow = true; rainbowType = tagData.rainbowType or tagData.color
                else isRainbow = false; newTagColor = Color3.fromRGB(tagData.color[1], tagData.color[2], tagData.color[3]) end
    else
        newTagName = "User"; newTagColor = Color3.fromRGB(255, 255, 255); isRainbow = false; rainbowType = nil
    end
    if currentData.name ~= newTagName or currentData.rainbow ~= isRainbow or currentData.rainbowType ~= rainbowType or (not isRainbow and currentData.color ~= newTagColor) or not head:FindFirstChild("NameTagGui") then
        RemoveTag(player)
        local billboard = Instantiate("BillboardGui", { Name = "NameTagGui", Parent = head,
                        Adornee = head,
                        Size = UDim2.new(0, 200, 0, 50),
                        StudsOffset = Vector3.new(0, 2, 0),
                        MaxDistance = 50
                })
        local textLabel = Instantiate("TextLabel", { Parent = billboard,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 50, 0, 0), Size = UDim2.new(0.5, 0, 0.5, 0),
                        Text = newTagName, Font = Enum.Font.FredokaOne,
                        TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
                        TextScaled = true,
                        AutoLocalize = false
                })
                if newTagName == "User" or newTagName == "VIP" then
                        local iconId = deviceIcons[_userDevices[player.UserId]]
                        if iconId then
                                Instantiate("ImageLabel", { Name = "DeviceIcon", Parent = billboard,
                                        BackgroundTransparency = 1,
                                        Position = UDim2.new(0, 130, 0, 2.9), Size = UDim2.new(0, 20, 0, 20),
                                        Image = "rbxassetid://"..iconId
                                })
                        end
                end
                if isRainbow then
                        _rainbowLabels[textLabel] = true
                        if rainbowType == "Rainbow2" then
                                _rainbowGradients[textLabel] = Instantiate("UIGradient", { Name = "Gradient", Parent = textLabel,
                                        Color = ColorSequence.new({
                                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 100)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 128, 0)),
                                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 150)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 128, 255)),
                                                ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
                                        }), Rotation = 0
                                })
                        else
                                textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                                _rainbowGradients[textLabel] = nil
                        end
                else
                        textLabel.TextColor3 = newTagColor
                        _rainbowLabels[textLabel] = nil; _rainbowGradients[textLabel] = nil
                end
        _playerTags[player.UserId] = {name = newTagName, color = newTagColor, rainbow = isRainbow, rainbowType = rainbowType}
    end
    _updating[player.UserId] = nil
end

local function UpdateTags()
    if not _users then return end
        local tagsLookup = {}
    if _tags then
        for _, tagData in pairs(_tags) do
            if tagData.ids then
                for _, id in ipairs(tagData.ids) do
                    tagsLookup[id] = {name = tagData.name, color = tagData.color, rainbowType = tagData.rainbowType}
                end
            end
        end
    end
    local newSet = {}; _userDevices = {}
    for _, u in ipairs(_users) do
                if u.is_vip and not tagsLookup[u.user_id] then
            tagsLookup[u.user_id] = {name = "VIP", color = {255, 215, 0}, rainbow = false}
        end
        newSet[u.user_id] = true; _userDevices[u.user_id] = u.device
        local player = S.Players:GetPlayerByUserId(u.user_id)
        if player then
            task.spawn(function() CreateTag(player, tagsLookup) end)
            if not _characterConnections[player.UserId] then
                _characterConnections[player.UserId] = player.CharacterAdded:Connect(function() CreateTag(player, tagsLookup) end)
            end
        end
    end
    _usersSet = newSet
    for userId, _ in pairs(_playerTags) do
        if not _usersSet[userId] then
            local player = S.Players:GetPlayerByUserId(userId); if player then RemoveTag(player) end; _playerTags[userId] = nil
        end
    end
end

local hue = 0
S.RunService.Heartbeat:Connect(function(dt)
    UpdateTags()
    hue = (hue + dt * 0.25) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
    for label in pairs(_rainbowLabels) do
        if label and label.Parent then
            label.TextColor3 = rainbowColor
            local grad = _rainbowGradients[label]; if grad then grad.Rotation = (grad.Rotation + 1) % 360 end
        else
            _rainbowLabels[label] = nil; _rainbowGradients[label] = nil
        end
    end
end)

ViewTag_Button.MouseButton1Click:Connect(function()
    isTagActive = not isTagActive
    if isTagActive then
        ViewTag_Button.Image = "rbxassetid://119030989234087"
    else
        ViewTag_Button.Image = "rbxassetid://113916582668001"; removeAllTags()
    end
    UpdateTags()
end)

local function UpdateTeleportUserButtons()
        if not (_users and #_users >= 1) then return end
        local count, users = 0, #_users
        for _, v in ipairs(SectionFrames.Staff_Section:GetChildren()) do
                if v:IsA("TextButton") and v.Name:find("Users_") then v:Destroy() end
        end
        for i = 1, users do
                local u = _users[i]
                local id = u and u.user_id
                if id and id ~= userId then
                        local user = S.Players:GetPlayerByUserId(id)
                        if user then
                                count += 1
                                local tag = _playerTags[user.UserId] or {color = Color3.fromRGB(255,255,255), rainbow = false}
                                local btn = CreateSectionFrameButton(user.DisplayName, SectionFrames.Staff_Section, count + 2)
                                btn.Name = "Users_"..id; btn.RichText = false; CreateClicker(btn)
                                if tag.rainbow then _rainbowLabels[btn] = true else btn.TextColor3 = tag.color end
                                btn.MouseButton1Click:Connect(function()
                                        local hrp = user.Character and user.Character:FindFirstChild("HumanoidRootPart")
                                        if hrp then plr.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)) end
                                end)
                        end
                end
        end
        SectionFrames.Staff_Section.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(count / 2) * 50 + 75))
end

vipOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                goDiscord(); SendNotify("VIP", "Link copiado!\nAcesse para adquirir seu VIP.", 10)
        end
end)

local function UpdateServerButtons()
        local data = httpRequest("GET", "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100")
        local _servers = data and data.data
        if not _servers then return end
        local count, servers = 0, #_servers
        table.sort(_servers, function(a, b)
                return (a.playing == b.playing and a.ping < b.ping) or (a.playing > b.playing)
        end)
        for _, v in ipairs(SectionFrames.Servers_Section:GetChildren()) do
                if v:IsA("TextButton") and v.Name:find("Server_") then v:Destroy() end
        end
        for i = 1, servers do
                local s = _servers[i]
                local id, p, max, ping = s.id, s.playing, s.maxPlayers, s.ping
                if id ~= game.JobId and p < max then
                        count += 1
                        local color = (ping <= 79 and "rgb(80,255,80)") or (ping <= 149 and "rgb(255,200,50)") or "rgb(255,80,80)"
                        local btn = CreateSectionFrameButton(p.."/"..max.." ÔÇó <font color='"..color.."'>"..ping.."ms</font>", SectionFrames.Servers_Section, count + 2)
                        btn.Name = "Server_"..id; btn.RichText = true; CreateClicker(btn)
                        btn.MouseButton1Click:Connect(function() S.TeleportService:TeleportToPlaceInstance(placeId, id, plr) end)
                end
        end
        SectionFrames.Servers_Section.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(count / 2) * 50 + 75))
end

local staff_lastUpdate, servers_lastUpdate = 5, 15
S.RunService.Heartbeat:Connect(function(dt)
        if currentSection == "STAFF" then
                staff_lastUpdate += dt; if staff_lastUpdate >= 5 then staff_lastUpdate = 0; UpdateTeleportUserButtons() end
        elseif currentSection == "VIP" then
                messageLabel.TextColor3 = Color3.fromRGB(255, 255, 0):Lerp(Color3.fromRGB(255, 175, 0),(math.sin(tick() * 3) + 1) / 2)
        elseif currentSection == "SERVERS" then
                servers_lastUpdate += dt; if servers_lastUpdate >= 15 then servers_lastUpdate = 0; UpdateServerButtons() end
        else
                staff_lastUpdate, servers_lastUpdate = 5, 15
        end
end)

local ScreenButtonGui = Instantiate("ScreenGui", { Name = "Touch_Button", Parent = plr:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        DisplayOrder = 0
})
local function CreateTouchButton(action, key, posX, posY)
    if isMobile then
                local buttonSize = UDim2.new(0, 30, 0, 30)
                local ScreenButton = Instantiate("TextButton", { Parent = ScreenButtonGui,
                        BackgroundTransparency = 0.300, BorderSizePixel = 0,
                        Position = UDim2.new(
                                0, 40 + (posY - 1) * (buttonSize.X.Offset + 20),
                                0, 15 + (posX - 1) * (buttonSize.Y.Offset + 15)
                        ), Size = buttonSize,
                        Text = key, Font = Enum.Font.Oswald,
                        TextSize = 14, TextScaled = true, TextWrapped = true
                }); UICorner(ScreenButton); RegisterThemedElement(ScreenButton, {BackgroundColor3 = "BackgroundColor3_button", BorderColor3 = "BorderColor3", TextColor3 = "TextColor3"})
        if action then ScreenButton.MouseButton1Click:Connect(action) end
        return ScreenButton
    end; return nil
end

_FlingLoaded = false
Vip_Buttons.Fling.MouseButton1Click:Connect(function()
        pcall(function()
                if _FlingLoaded then return end
                _FlingLoaded = true
                loadstring(vip_fling)()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "H", 2, 14)
        end)
end)

_G.AntiFlingToggled = false
Vip_Buttons.AntiFling.MouseButton1Click:Connect(function()
        ChangeToggleColor(Vip_Buttons.AntiFling)
        if Vip_Buttons.AntiFling.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                _G.AntiFlingToggled = true
                loadstring(vip_antifling)()
        else
                _G.AntiFlingToggled = false
        end
end)

_AntiForceLoaded = false
Vip_Buttons.AntiForce.MouseButton1Click:Connect(function()
        pcall(function()
                if _AntiForceLoaded then return end
                _AntiForceLoaded = true
                loadstring(vip_antiforce)()(plr, S.UserInputService, SendNotify, CreateTouchButton, "K", 2, 15)
        end)
end)

_G.AntiChatSpyToggled = false
Vip_Buttons.AntiChatSpy.MouseButton1Click:Connect(function()
        ChangeToggleColor(Vip_Buttons.AntiChatSpy)
        if Vip_Buttons.AntiChatSpy.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                _G.AntiChatSpyToggled = true
                loadstring(vip_antichatspy)()
        else
                _G.AntiChatSpyToggled = false
        end
end)

_AutoSacrificeLoaded = false
Vip_Buttons.AutoSacrifice.MouseButton1Click:Connect(function()
        pcall(function()
                if _AutoSacrificeLoaded then return end
                _AutoSacrificeLoaded = true
                loadstring(vip_autosacrifice)()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "L", 3, 16)
        end)
end)

_EscapeHandcuffsLoaded = false
Vip_Buttons.EscapeHandcuffs.MouseButton1Click:Connect(function()
        pcall(function()
                if _EscapeHandcuffsLoaded then return end
                _EscapeHandcuffsLoaded = true
                loadstring(vip_escapehandcuffs)()(plr, S.UserInputService, SendNotify, CreateTouchButton, "J", 2, 16)
        end)
end)

-- _CollectOrbsLoaded = false
-- Vip_Buttons.CollectOrbs.MouseButton1Click:Connect(function()
--      pcall(function()
--              if _CollectOrbsLoaded then return end
--              _CollectOrbsLoaded = true
--              loadstring(vip_collectorbs)()(plr, S.UserInputService, SendNotify, CreateTouchButton, "P", 4, 16)
--      end)
-- end)

_InvisibleLoaded = false
Emphasis_Buttons.Invisible.MouseButton1Click:Connect(function()
        pcall(function()
                if _InvisibleLoaded then return end
                _InvisibleLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/Invisible"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "Y", 2, 1)
        end)
end)

_ClickTPLoaded = false
Emphasis_Buttons.ClickTP.MouseButton1Click:Connect(function()
        pcall(function()
                if (not isMobile and _ClickTPLoaded) or (isMobile and (plr.Backpack:FindFirstChild("TPTool") or (plr.Character and plr.Character:FindFirstChild("TPTool")))) then return end
                _ClickTPLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/ClickTP"))()(plr, S.UserInputService, SendNotify)
        end)
end)

_NoClipLoaded = false
Emphasis_Buttons.NoClip.MouseButton1Click:Connect(function()
        pcall(function()
                if _NoClipLoaded then return end
                _NoClipLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/NoClip"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "N", 3, 1)
        end)
end)

_JerkOffLoaded = false
Emphasis_Buttons.JerkOff.MouseButton1Click:Connect(function()
        pcall(function()
                if _JerkOffLoaded then return end
                _JerkOffLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/JerkOff"))()(plr, S.UserInputService, SendNotify, CreateTouchButton, "R", 3, 2)
        end)
end)

_ImpulseLoaded = false
Emphasis_Buttons.Impulse.MouseButton1Click:Connect(function()
        pcall(function()
                if _ImpulseLoaded then return end
                _ImpulseLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/Impulse"))()(plr, S.UserInputService, SendNotify, CreateTouchButton, "M", 2, 2)
        end)
end)

_FaceBangLoaded = false
Emphasis_Buttons.FaceBang.MouseButton1Click:Connect(function()
        pcall(function()
                if _FaceBangLoaded then return end
                _FaceBangLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/FaceBang"))(); SendNotify("FaceBang", "Z.FaceBang", 5)
        end)
end)

_SpinLoaded = false
Emphasis_Buttons.Spin.MouseButton1Click:Connect(function()
        pcall(function()
                if _SpinLoaded then return end
                _SpinLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/Spin"))()(plr, S.UserInputService, SendNotify, CreateTouchButton, "T", 4, 1)
        end)
end)

_AnimSpeedLoaded = false
Emphasis_Buttons.AnimSpeed.MouseButton1Click:Connect(function()
        pcall(function()
                if _AnimSpeedLoaded then return end
                _AnimSpeedLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/AnimSpeed"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "E", "Q", 1, 2) -- key1 = posY, key2 = posY-1
        end)
end)

_feFlipLoaded = false
Emphasis_Buttons.feFlip.MouseButton1Click:Connect(function()
        pcall(function()
                if _feFlipLoaded then return end
                _feFlipLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/feFlip"))()(plr, SendNotify, CreateTouchButton, "X", "C", 1, 13) -- key1 = posY, key2 = posY+1
        end)
end)

_FlashbackLoaded = false
Emphasis_Buttons.Flashback.MouseButton1Click:Connect(function()
        pcall(function()
                if _FlashbackLoaded then return end
                _FlashbackLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/Flashback"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "V", 1, 15)
        end)
end)

_AntiVoidLoaded = false
Emphasis_Buttons.AntiVoid.MouseButton1Click:Connect(function()
        pcall(function()
                if _AntiVoidLoaded then return end
                _AntiVoidLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/Emphasis/AntiVoid"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "G", 1, 16)
        end)
end)

WalkSpeed, recentSpeed = nil, nil
Character_Buttons.WalkSpeed_Input.FocusLost:Connect(function()
        local Speed = Character_Buttons.WalkSpeed_Input.Text:match("%d+")
        if not Speed then return end
        WalkSpeed = tonumber(Speed)
        if Character_Buttons.WalkSpeed.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                plr.Character.Humanoid.WalkSpeed = WalkSpeed
        end
        SendNotify("ksx's Panel", "Velocidade atualizada para "..WalkSpeed..".", 5)
        recentSpeed = WalkSpeed
end)

Character_Buttons.WalkSpeed.MouseButton1Click:Connect(function()
        ChangeToggleColor(Character_Buttons.WalkSpeed)
        if Character_Buttons.WalkSpeed.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                WalkSpeed = 50
                if recentSpeed then WalkSpeed = recentSpeed end
        else
                WalkSpeed = 16
        end
        plr.Character.Humanoid.WalkSpeed = WalkSpeed
end)

JumpPower, recentPower = nil, nil
Character_Buttons.JumpPower_Input.FocusLost:Connect(function()
        local Power = Character_Buttons.JumpPower_Input.Text:match("%d+")
        if not Power then return end
        JumpPower = tonumber(Power)
        if Character_Buttons.JumpPower.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                plr.Character.Humanoid.JumpHeight = JumpPower
        end
        SendNotify("ksx's Panel", "Altura do pulo atualizada para "..JumpPower..".", 5)
        recentPower = JumpPower
end)

Character_Buttons.JumpPower.MouseButton1Click:Connect(function()
        ChangeToggleColor(Character_Buttons.JumpPower)
        if Character_Buttons.JumpPower.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                JumpPower = 50
                if recentPower then JumpPower = recentPower end
        else
                JumpPower = 7.199999809265137
        end
        plr.Character.Humanoid.JumpHeight = JumpPower
end)

FlySpeed, recentFlySpeed = 75, 75
Character_Buttons.FlySpeed_Input.FocusLost:Connect(function()
        local Speed = Character_Buttons.FlySpeed_Input.Text:match("%d+")
        if not Speed then return end
        FlySpeed = tonumber(Speed)
        recentFlySpeed = FlySpeed
        SendNotify("ksx's Panel", "Velocidade de voo atualizada para "..FlySpeed..".", 5)
end)

local animationTracks = {}
local BodyVelocity, BodyGyro = nil, nil
local wasShiftLock, ControlPressed = nil, false
local Flying, FlyControl, FlyNotified = false, false, false
local function Fly()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum, hrp = char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
        local function loadFlyAnim(animId)
                local anim = Instance.new("Animation"); anim.AnimationId = animId
                return hum:LoadAnimation(anim)
        end
        for key, animId in pairs({ forward = "rbxassetid://10714177846", left = "rbxassetid://10147823318", backward = "rbxassetid://10147823318", right = "rbxassetid://10147823318", idleFly = "rbxassetid://10714347256" }) do
                animationTracks[key] = loadFlyAnim(animId)
        end
        local function stopFlyAnim()
                for _, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop() end
        end
        local function playFlyAnim(animKey, time, speed)
                local track = animationTracks[animKey]
                if not track then return end
                stopFlyAnim()
                track:Play(); track.TimePosition = time; track:AdjustSpeed(speed)
        end
        local function setShiftLock(active)
                if active then plr.DevEnableMouseLock = wasShiftLock else wasShiftLock = plr.DevEnableMouseLock; plr.DevEnableMouseLock = false end
        end
        local function stopFly()
                if not Flying then return end
                Flying = false
                stopFlyAnim()
                if BodyVelocity then BodyVelocity:Destroy(); BodyVelocity = nil end
                if BodyGyro then BodyGyro:Destroy(); BodyGyro = nil end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                setShiftLock(true)
                if Character_Buttons.Fly.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then ChangeToggleColor(Character_Buttons.Fly) end
        end
        local function startFly()
                if Flying then return end
                Flying = true
                setShiftLock(false)
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                hrp.Velocity = Vector3.new(0, 50, 0)
                BodyVelocity = Instance.new("BodyVelocity", hrp)
                BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                BodyVelocity.Velocity = Vector3.zero
                BodyGyro = Instance.new("BodyGyro", hrp)
                BodyGyro.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
                BodyGyro.CFrame = hrp.CFrame
                hum.Died:Once(stopFly)
        end
        local function updateFlySpeed(isMoving)
                if not Flying then return end
                if S.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and isMoving then
                        if not ControlPressed then
                                ControlPressed, FlySpeed = true, recentFlySpeed * (4 / 3)
                                S.TweenService:Create(Camera, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FieldOfView = 90}):Play()
                        end
                elseif ControlPressed then
                        ControlPressed, FlySpeed = false, recentFlySpeed
                        S.TweenService:Create(Camera, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = 70}):Play()
                end
        end
        local function updateFlyDirection()
                if not Flying then return end
                local isMoving, moveDir, yAngle, xAngle = false, Vector3.zero, 0, 0
                local lv, rv = Camera.CFrame.LookVector, Camera.CFrame.RightVector
                local direction = (plr.Character or plr.CharacterAdded:Wait()):WaitForChild("Humanoid").MoveDirection
                if direction.Magnitude > 0 then
                        isMoving, moveDir = true, Vector3.new(direction.X, (math.abs(Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(lv.X,0,lv.Z))) >= math.abs(Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(rv.X,0,rv.Z))) and lv.Y * (Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(lv.X,0,lv.Z)) >= 0 and 1 or -1) or 0), direction.Z) * FlySpeed
                        if math.abs(Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(rv.X,0,rv.Z))) > math.abs(Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(lv.X,0,lv.Z))) then
                                if Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(rv.X,0,rv.Z)) > 0 then
                                        playFlyAnim("right", 4.81, 0)
                                else
                                        playFlyAnim("left", 3.55, 0)
                                end
                        else
                                if Vector3.new(direction.X,0,direction.Z):Dot(Vector3.new(lv.X,0,lv.Z)) > 0 then
                                        playFlyAnim("forward", 4.65, 0); yAngle, xAngle = -85, -0.3
                                else
                                        playFlyAnim("backward", 4.11, 0)
                                end
                        end
                end
                if not isMobile then
                        if S.UserInputService:IsKeyDown(Enum.KeyCode.Space) then isMoving = true; moveDir += Vector3.new(0,0.25,0) * FlySpeed end
                        if S.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then isMoving = true; moveDir -= Vector3.new(0,0.25,0) * FlySpeed end
                end
                if not isMoving then
                        playFlyAnim("idleFly", 4, 0)
                        if BodyVelocity then BodyVelocity.Velocity = Vector3.zero end
                        if BodyGyro then BodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + lv) end
                else
                        if BodyVelocity then BodyVelocity.Velocity = moveDir end
                        if BodyGyro then BodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + lv) * CFrame.Angles(math.rad(yAngle), xAngle, 0) end
                end; return isMoving
        end
        S.RunService.RenderStepped:Connect(function()
                local isMoving = updateFlyDirection(); updateFlySpeed(isMoving)
        end)
        local function toggleFly()
                ChangeToggleColor(Character_Buttons.Fly)
                FlyControl = true
                if not FlyNotified then SendNotify("Fly", "F.Fly", 5); FlyNotified = true end
                if Character_Buttons.Fly.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        startFly()
                else
                        stopFly()
                end
        end; toggleFly()
end
S.UserInputService.InputBegan:Connect(function(input, gamep)
        if FlyControl and not gamep and input.KeyCode == Enum.KeyCode.F then Fly() end
end)
Character_Buttons.Fly.MouseButton1Click:Connect(Fly)

Character_Buttons.Respawn.MouseButton1Click:Connect(function()
        local RsP = GetRoot(plr).Position
        plr.Character.Humanoid.Health = 0
        plr.CharacterAdded:wait()
        TeleportTO(RsP.X,RsP.Y,RsP.Z,"pos","safe")
end)

SavedCheckpoint = nil
Character_Buttons.Checkpoint.MouseButton1Click:Connect(function()
        ChangeToggleColor(Character_Buttons.Checkpoint)
        if Character_Buttons.Checkpoint.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                SavedCheckpoint = GetRoot(plr).Position; SendNotify("ksx's Panel", "Checkpoint salvo.", 5)
        else
                SavedCheckpoint = nil; SendNotify("ksx's Panel", "Checkpoint limpo.", 5)
        end
end)

TargetedPlayer = nil
local function UpdateTarget(player)
        if (player ~= nil) then
                TargetedPlayer = player.Name
                TargetName_Input.Text = player.Name
                UserIDTargetLabel.Text = ("UserID: "..player.UserId.."\nDisplay: "..player.DisplayName.."\nCreated: "..os.date("%d-%m-%Y", os.time()-player.AccountAge * 24 * 3600))
                TargetImage.Image = S.Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
        else
                TargetName_Input.Text = "@username..."
                UserIDTargetLabel.Text = "UserID: \nDisplay: \nCreated: "
                TargetImage.Image = "rbxassetid://10818605405"
                TargetedPlayer = nil
                Target_Buttons.View.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Focus.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Follow.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Stand.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Bang.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Drag.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Headsit.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Doggy.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Backpack.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
                Target_Buttons.Animation.Ticket_Asset.ImageColor3 = Color3.fromRGB(255,0,0)
        end
end

TargetName_Input.FocusLost:Connect(function() local LabelTarget = GetPlayer(TargetName_Input.Text); UpdateTarget(LabelTarget) end)

local TargetTool
ClickTargetTool_Button.MouseButton1Click:Connect(function()
        if not (plr.Backpack:FindFirstChild("ClickTarget") or (plr.Character and plr.Character:FindFirstChild("ClickTarget"))) then
                TargetTool = Instance.new("Tool")
                TargetTool.Name = "ClickTarget"
                TargetTool.RequiresHandle = false
                TargetTool.TextureId = "rbxassetid://80854448131955"
                TargetTool.ToolTip = "Select Target"
        end
        local function ActivateTool()
                local hit, person = Mouse.Target, nil
                if hit and hit.Parent then
                        if hit.Parent:IsA("Model") then person = S.Players:GetPlayerFromCharacter(hit.Parent)
                        elseif hit.Parent:IsA("Accessory") then person = S.Players:GetPlayerFromCharacter(hit.Parent.Parent) end
                        if person then UpdateTarget(person) end
                end
        end
        TargetTool.Activated:Connect(function() ActivateTool() end)
        TargetTool.Parent = plr.Backpack
end)

Target_Buttons.View.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.View)
                if Target_Buttons.View.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        repeat
                                pcall(function() Camera.CameraSubject = S.Players[TargetedPlayer].Character.Humanoid end); task.wait(0.1)
                        until Target_Buttons.View.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        Camera.CameraSubject = plr.Character.Humanoid
                end
        end
end)

Target_Buttons.CopyId.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then setclipboard(S.Players[TargetedPlayer].UserId) end
end)

Target_Buttons.Focus.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Focus)
                if Target_Buttons.Focus.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        repeat
                                pcall(function() local target = S.Players[TargetedPlayer]; TeleportTO(0,0,0,target) end); task.wait(0.2)
                        until Target_Buttons.Focus.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                end
        end
end)

Target_Buttons.Follow.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Follow)
                if Target_Buttons.Follow.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        local isMoving, lastPos = false, Vector3.new()
                        repeat
                                pcall(function()
                                        local myRoot = GetRoot(plr)
                                        if myRoot and not myRoot:FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = myRoot end)
                                        end
                                        local targetRoot = GetRoot(S.Players[TargetedPlayer])
                                        if myRoot and targetRoot then
                                                local targetPos = targetRoot.Position - targetRoot.CFrame.LookVector * 2
                                                local targetCFrame = CFrame.new(targetPos, targetRoot.Position)
                                                myRoot.CFrame = myRoot.CFrame:Lerp(targetCFrame, 0.25)
                                                myRoot.Velocity = Vector3.new(0,0,0)
                                                if (targetRoot.Position - lastPos).Magnitude > 0.05 then if not isMoving then isMoving = true; PlayAnim(10921269718,4,1) end
                                                elseif isMoving then isMoving = false; StopAnim() end
                                                lastPos = targetRoot.Position
                                        end
                                end); task.wait()
                        until Target_Buttons.Follow.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        StopAnim(); if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Stand.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Stand)
                if Target_Buttons.Stand.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        PlayAnim(13823324057,4,0)
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local root = GetRoot(S.Players[TargetedPlayer])
                                        GetRoot(plr).CFrame = root.CFrame * CFrame.new(-3,1,0); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end); task.wait()
                        until Target_Buttons.Stand.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        StopAnim(); if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Bang.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Bang)
                if Target_Buttons.Bang.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        PlayAnim(5918726674,0,1)
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local otherRoot = GetRoot(S.Players[TargetedPlayer])
                                        GetRoot(plr).CFrame = otherRoot.CFrame * CFrame.new(0,0,1.1); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end); task.wait()
                        until Target_Buttons.Bang.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        StopAnim(); if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Drag.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Drag)
                if Target_Buttons.Drag.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        PlayAnim(10714360343,0.5,0)
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local root = S.Players[TargetedPlayer].Character.RightHand
                                        GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,-2.5,1) * CFrame.Angles(-2, -3, 0); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end)
                                task.wait()
                        until Target_Buttons.Drag.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        StopAnim(); if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Headsit.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Headsit)
                if Target_Buttons.Headsit.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local targethead = S.Players[TargetedPlayer].Character.Head
                                        plr.Character.Humanoid.Sit = true
                                        GetRoot(plr).CFrame = targethead.CFrame * CFrame.new(0,2,0); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end); task.wait()
                        until Target_Buttons.Headsit.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Doggy.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Doggy)
                if Target_Buttons.Doggy.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        PlayAnim(13694096724,3.4,0)
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local root = S.Players[TargetedPlayer].Character.LowerTorso
                                        GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,0.23,0); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end); task.wait()
                        until Target_Buttons.Doggy.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        StopAnim(); if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Backpack.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                ChangeToggleColor(Target_Buttons.Backpack)
                if Target_Buttons.Backpack.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        repeat
                                pcall(function()
                                        if not GetRoot(plr):FindFirstChild("BreakVelocity") then
                                                pcall(function() local TempV = Velocity_Asset:Clone(); TempV.Parent = GetRoot(plr) end)
                                        end
                                        local root = GetRoot(S.Players[TargetedPlayer])
                                        plr.Character.Humanoid.Sit = true
                                        GetRoot(plr).CFrame = root.CFrame * CFrame.new(0,0,1.2) * CFrame.Angles(0,-3,0); GetRoot(plr).Velocity = Vector3.new(0,0,0)
                                end); task.wait()
                        until Target_Buttons.Backpack.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0)
                        if GetRoot(plr):FindFirstChild("BreakVelocity") then GetRoot(plr).BreakVelocity:Destroy() end
                end
        end
end)

Target_Buttons.Bring.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then
                local char, hrp, hum, tool = plr.Character, GetRoot(plr), plr.Character.Humanoid, plr.Backpack:FindFirstChild("Algemas") or plr.Character:FindFirstChild("Algemas")
                if not tool then return SendNotify("Bring", "Voc├¬ precisa ter as algemas.", 3) end
                local target = S.Players[TargetedPlayer]; if not target or not target.Character then return end
        if target.Character:GetAttribute("IsCarried") or target.Character:GetAttribute("IsCarrying") then return SendNotify("Bring", "Jogador n├úo dispon├¡vel.", 3) end
                if tool then hum:EquipTool(tool) end
                local startPos = hrp.CFrame
                repeat
                        pcall(function()
                                if not target.Character:GetAttribute("IsCarried") and not target.Character:GetAttribute("IsCarrying") then
                                        local tHrp = GetRoot(target); if not tHrp then return end
                                        hrp.CFrame = tHrp.CFrame * CFrame.new(0,0,1)
                                        spawn(function() task.wait(0.1); if char:FindFirstChild("Algemas") then char.Algemas.Events.CarryEvent:FireServer(target.Character) end end)
                                end
                        end); task.wait()
                until target.Character:GetAttribute("IsCarried") or not target.Character.Parent or (tool.Parent ~= hum and tool.Parent ~= char)
                if hrp:FindFirstChild("BreakVelocity") then hrp.BreakVelocity:Destroy() end
                hrp.CFrame = startPos; task.wait(0.5); if tool then hum:UnequipTools() end
        end
end)

Target_Buttons.Teleport.MouseButton1Click:Connect(function()
        if TargetedPlayer ~= nil then TeleportTO(0,0,0,S.Players[TargetedPlayer],"safe") end
end)

isCopyingAnimations = false
Target_Buttons.Animation.MouseButton1Click:Connect(function()
    if TargetedPlayer ~= nil then
        ChangeToggleColor(Target_Buttons.Animation)
        if Target_Buttons.Animation.Ticket_Asset.ImageColor3 == Color3.fromRGB(0, 255, 0) then
            local thePlayer = S.Players[TargetedPlayer]
            if not thePlayer then return end
            local TheirCharacter = thePlayer.Character or thePlayer.CharacterAdded:Wait()
            if not TheirCharacter then return end
            local character = plr.Character or plr.CharacterAdded:Wait()
            local Humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid", 0.5)
            local TheirHumanoid = TheirCharacter:FindFirstChildWhichIsA("Humanoid") or TheirCharacter:WaitForChild("Humanoid", 0.5)
            if not Humanoid or not TheirHumanoid then return end
            if not isCopyingAnimations then
                isCopyingAnimations = true
                task.spawn(function()
                    while isCopyingAnimations do
                        for _, v1 in pairs(TheirHumanoid:GetPlayingAnimationTracks()) do
                            if not string.find(v1.Animation.AnimationId, "507768375") then
                                local NewAnimation = Instance.new("Animation")
                                NewAnimation.AnimationId = v1.Animation.AnimationId
                                local NewAnimTrack = Humanoid:LoadAnimation(NewAnimation)
                                NewAnimTrack.Priority = v1.Priority
                                NewAnimTrack.Looped = v1.Looped
                                NewAnimTrack:Play(0.1, 1, v1.Speed)
                                NewAnimTrack.TimePosition = v1.TimePosition
                                task.spawn(function() v1.Stopped:Wait(); NewAnimTrack:Stop(); NewAnimTrack:Destroy() end)
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end
        else
            local character = plr.Character or plr.CharacterAdded:Wait()
            local Humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then StopAnim() end
            isCopyingAnimations = false
        end
    end
end)

local function GetA(f, c)
    local a=plr.Character:WaitForChild("Animate",5); local o=a and a:WaitForChild(f,3); if o then return o:FindFirstChild(c) or o:FindFirstChildWhichIsA("Animation") end
end

local function SetAnimation(idle, idle2, walk, run, jump, climb, fall)
    local Animate = plr.Character:WaitForChild("Animate",5); if not Animate then return end
    Animate.Disabled = true
    StopAnim()
        for _, v in pairs({
                {"idle","Animation1", idle}, {"idle","Animation2", idle2},
                {"walk","WalkAnim", walk}, {"run","RunAnim", run}, {"jump","JumpAnim", jump}, {"climb","ClimbAnim", climb}, {"fall","FallAnim", fall}
        }) do
                local obj = GetA(v[1], v[2]); if obj then obj.AnimationId = "rbxassetid://"..v[3] end
        end
    plr.Character.Humanoid:ChangeState(3)
    Animate.Disabled = false
end
for name, ids in pairs({
        Vampire = {1083445855, 1083450166, 1083473930, 1083462077, 1083455352, 1083439238, 1083443587},
        Hero = {616111295, 616113536, 616122287, 616117076, 616115533, 616104706, 616108001},
        Ghost = {616006778, 616008087, 616010382, 616013216, 616008936, 616003713, 616005863},
        Elder = {845397899, 845400520, 845403856, 845386501, 845398858, 845392038, 845396048},
        Mage = {707742142, 707855907, 707897309, 707861613, 707853694, 707826056, 707829716},
        Catwalk = {133806214992291, 94970088341563, 109168724482748, 81024476153754, 116936326516985, 119377220967554, 92294537340807},
        Levitation = {616006778, 616008087, 616010382, 616013216, 616008936, 616003713, 616005863},
        Astronaut = {891621366, 891633237, 891667138, 891636393, 891627522, 891609353, 891617961},
        Ninja = {656117400, 656118341, 656121766, 656118852, 656117878, 656114359, 656115606},
        Adidas = {122257458498464, 102357151005774, 122150855457006, 82598234841035, 75290611992385, 88763136693023, 98600215928904},
        AdidasClassic = {18537376492, 18537371272, 18537392113, 18537384940, 18537380791, 18537363391, 18537367238},
        Cartoon = {742637544, 742638445, 742640026, 742638842, 742637942, 742636889, 742637151},
        Pirate = {750781874, 750782770, 750785693, 750783738, 750782230, 750779899, 750780242},
        Sneaky = {1132473842, 1132477671, 1132510133, 1132494274, 1132489853, 1132461372, 1132469004},
        Toy = {782841498, 782845736, 782843345, 782842708, 782847020, 782843869, 782846423},
        Knight = {657595757, 657568135, 657552124, 657564596, 658409194, 658360781, 657600338},
        Confident = {1069977950, 1069987858, 1070017263, 1070001516, 1069984524, 1069946257, 1069973677},
        Popstar = {1212900985, 1212900985, 1212980338, 1212980348, 1212954642, 1213044953, 1212900995},
        Princess = {941003647, 941013098, 941028902, 941015281, 941008832, 940996062, 941000007},
        Cowboy = {1014390418, 1014398616, 1014421541, 1014401683, 1014394726, 1014380606, 1014384571},
        Patrol = {1149612882, 1150842221, 1151231493, 1150967949, 1150944216, 1148811837, 1148863382},
        Werewolf = {1083195517, 1083214717, 1083178339, 1083216690, 1083218792, 1083182000, 1083189019},
        Robot = {10921248039, 10921248831, 10921255446, 10921250460, 10921252123, 10921247141, 10921251156},
        Zombie = {3489171152, 3489171152, 3489174223, 3489173414, 616161997, 616156119, 616157476},
        ZombieClassic = {616158929, 616160636, 616168032, 616163682, 616161997, 616156119, 616157476}
}) do
        Animation_Buttons[name].MouseButton1Click:Connect(function()
                SetAnimation(ids[1], ids[2], ids[3], ids[4], ids[5], ids[6], ids[7])
        end)
end

local function SetCustomAnimation(input, anims)
    local Animate = plr.Character:WaitForChild("Animate",5); if not Animate then return end
    Animate.Disabled = true
    StopAnim()
    local AnimId = tonumber(input.Text:match("%d+"))
    for _, v in ipairs(anims) do if v[1] then v[1].AnimationId = "rbxassetid://"..(AnimId or v[2]) end end
    plr.Character.Humanoid:ChangeState(3)
    Animate.Disabled = false
end
for name, v in pairs({
    Idle = {CustomAnimation_Buttons.Idle_Input, {{GetA("idle","Animation1"), 122257458498464}, {GetA("idle","Animation2"), 102357151005774}}},
    Walk = {CustomAnimation_Buttons.Walk_Input, {{GetA("walk","WalkAnim"), 18537392113}}},
    Run = {CustomAnimation_Buttons.Run_Input, {{GetA("run","RunAnim"), 18537384940}}},
    Jump = {CustomAnimation_Buttons.Jump_Input, {{GetA("jump","JumpAnim"), 18537380791}}},
    Fall = {CustomAnimation_Buttons.Fall_Input, {{GetA("fall","FallAnim"), 18537367238}}}
}) do
        CustomAnimation_Buttons[name].MouseButton1Click:Connect(function()
                SetCustomAnimation(v[1], v[2])
        end)
end

More_Buttons.PianoAuto.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/More/PianoAuto"))() end)
end)

_ESPLoaded = false
More_Buttons.ESP.MouseButton1Click:Connect(function()
        pcall(function()
                if _ESPLoaded then return end
                _ESPLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/More/ESP"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "E", 1, 4)
        end)
end)

_AimbotLoaded = false
More_Buttons.Aimbot.MouseButton1Click:Connect(function()
        pcall(function()
                if _AimbotLoaded then return end
                _AimbotLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ksx1s/ksx-s/refs/heads/main/modules/More/Aimbot"))()(plr, S.RunService, S.UserInputService, SendNotify, CreateTouchButton, "F", 1, 3)
        end)
end)

AntiAFKFunction = nil
Misc_Buttons.AntiAFK.MouseButton1Click:Connect(function()
        ChangeToggleColor(Misc_Buttons.AntiAFK)
        if Misc_Buttons.AntiAFK.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                AntiAFKFunction = plr.Idled:Connect(function()
                        local VirtualUser = S.VirtualUser
                        VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())
                end)
        else
                AntiAFKFunction:Disconnect()
        end
end)

Misc_Buttons.TpToOwner.MouseButton1Click:Connect(function()
        if userId == ownerId then return end
    local owner = S.Players:GetPlayerByUserId(ownerId)
    if owner and owner.Character and owner.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character:SetPrimaryPartCFrame(owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) * CFrame.Angles(0,math.rad(180),0))
                SendNotify("TpToOwner", "Voc├¬ foi teletransportado para o Owner.", 3)
    else
                SendNotify("TpToOwner", "O Owner n├úo foi encontrado na experi├¬ncia.", 3)
    end
end)

Misc_Buttons.Shaders.MouseButton1Click:Connect(function()
        ChangeToggleColor(Misc_Buttons.Shaders)
        if Misc_Buttons.Shaders.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                S.Lighting.Brightness = 1.5; S.Lighting.ClockTime = 17.30
                local Sky = Instance.new("Sky")
                Sky.SkyboxBk = "http://www.roblox.com/asset/?id=144933338"
                Sky.SkyboxDn = "http://www.roblox.com/asset/?id=144931530"
                Sky.SkyboxFt = "http://www.roblox.com/asset/?id=144933262"
                Sky.SkyboxLf = "http://www.roblox.com/asset/?id=144933244"
                Sky.SkyboxRt = "http://www.roblox.com/asset/?id=144933299"
                Sky.SkyboxUp = "http://www.roblox.com/asset/?id=144931564"
                Sky.StarCount = 5000
                Sky.SunAngularSize = 5
                Sky.Parent = S.Lighting
                local Bloom = Instance.new("BloomEffect")
                Bloom.Intensity = 0.3
                Bloom.Size = 10
                Bloom.Threshold = 0.8
                Bloom.Parent = S.Lighting
                local Blur = Instance.new("BlurEffect")
                Blur.Size = 5
                Blur.Parent = S.Lighting
                local ColorC = Instance.new("ColorCorrectionEffect")
                ColorC.Brightness = 0
                ColorC.Contrast = 0.1
                ColorC.Saturation = 0.25
                ColorC.TintColor = Color3.fromRGB(255, 255, 255)
                ColorC.Parent = S.Lighting
                local SunRays = Instance.new("SunRaysEffect")
                SunRays.Intensity = 0.1
                SunRays.Spread = 0.8
                SunRays.Parent = S.Lighting
        else
                for i,v in pairs(S.Lighting:GetChildren()) do v:Destroy() end
                S.Lighting.Brightness = 2; S.Lighting.ClockTime = 14.5
        end
end)

Misc_Buttons.ChangeTime.MouseButton1Click:Connect(function()
        if Misc_Buttons.Shaders.Ticket_Asset.ImageColor3 == Color3.fromRGB(255,0,0) then
                local Sky = Instance.new("Sky")
                Sky.Parent = S.Lighting
                ChangeToggleColor(Misc_Buttons.ChangeTime)
                if Misc_Buttons.ChangeTime.Ticket_Asset.ImageColor3 == Color3.fromRGB(0,255,0) then
                        S.Lighting.ClockTime = 19.5; Sky.StarCount = 5000
                else
                        S.Lighting.ClockTime = 14.5; Sky.StarCount = 0
                end
        else
                SendNotify("ksx's Panel", "Por favor, desligue os shaders.", 5)
        end
end)

Misc_Buttons.ResetLighting.MouseButton1Click:Connect(function()
        S.Lighting.Brightness = 2; S.Lighting.ClockTime = 14.5
        if not S.Lighting:FindFirstChildOfClass("Atmosphere") then
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Name = "Atmosphere"
                Atmosphere.Parent = S.Lighting
                Atmosphere.Density = 0.3
                Atmosphere.Offset = 0.25
                Atmosphere.Color = Color3.fromRGB(199, 199, 199)
                Atmosphere.Decay = Color3.fromRGB(106, 112, 125)
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
        else
                S.Lighting.Atmosphere.Density = 0.3
                S.Lighting.Atmosphere.Offset = 0.25
                S.Lighting.Atmosphere.Color = Color3.fromRGB(199, 199, 199)
                S.Lighting.Atmosphere.Decay = Color3.fromRGB(106, 112, 125)
                S.Lighting.Atmosphere.Glare = 0
                S.Lighting.Atmosphere.Haze = 0
        end
        if not S.Lighting:FindFirstChildOfClass("Sky") then
                local Sky = Instance.new("Sky")
                Sky.Name = "Sky"
                Sky.Parent = S.Lighting
                Sky.MoonAngularSize = 11
                Sky.StarCount = 3000
                Sky.SunAngularSize = 11
        else
                S.Lighting.Sky.MoonAngularSize = 11
                S.Lighting.Sky.StarCount = 3000
                S.Lighting.Sky.SunAngularSize = 11
        end
        if not S.Lighting:FindFirstChildOfClass("BloomEffect") then
                local Bloom = Instance.new("BloomEffect")
                Bloom.Name = "Bloom"
                Bloom.Parent = S.Lighting
                Bloom.Intensity = 1
                Bloom.Enabled = true
                Bloom.Size = 24
                Bloom.Threshold = 2
        else
                S.Lighting.Bloom.Intensity = 1
                S.Lighting.Bloom.Enabled = true
                S.Lighting.Bloom.Size = 24
                S.Lighting.Bloom.Threshold = 2
        end
        if not S.Lighting:FindFirstChildOfClass("DepthOfFieldEffect") then
                local DepthOfField = Instance.new("DepthOfFieldEffect")
                DepthOfField.Name = "DepthOfField"
                DepthOfField.Parent = S.Lighting
                DepthOfField.Enabled = false
                DepthOfField.FarIntensity = 0.1
                DepthOfField.FocusDistance = 0.05
                DepthOfField.InFocusRadius = 30
                DepthOfField.NearIntensity = 0.75
        else
                S.Lighting.DepthOfField.Enabled = false
                S.Lighting.DepthOfField.FarIntensity = 0.1
                S.Lighting.DepthOfField.FocusDistance = 0.05
                S.Lighting.DepthOfField.InFocusRadius = 30
                S.Lighting.DepthOfField.NearIntensity = 0.75
        end
        if not S.Lighting:FindFirstChildOfClass("SunRaysEffect") then
                local SunRays = Instance.new("SunRaysEffect")
                SunRays.Name = "SunRays"
                SunRays.Parent = S.Lighting
                SunRays.Enabled = true
                SunRays.Intensity = 0.01
                SunRays.Spread = 0.1
        else
                S.Lighting.SunRays.Enabled = true
                S.Lighting.SunRays.Intensity = 0.01
                S.Lighting.SunRays.Spread = 0.1
        end
end)

Misc_Buttons.DestroyUI.MouseButton1Click:Connect(function()
        GUI:Destroy(); ScreenButtonGui:Destroy(); if TargetTool then TargetTool:Destroy() end
        isTagActive = false; removeAllTags(); getgenv().GUI_Loaded = false
end)

Misc_Buttons.FreeEmotes.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))() end)
end)

Misc_Buttons.ClearChat.MouseButton1Click:Connect(function()
        local chat = S.TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
        local function sendchat(msg) chat:SendAsync(msg) end
        for i = 1, 6 do sendchat("") end
        wait(0.5); sendchat("/cls")
end)

Misc_Buttons.Rejoin.MouseButton1Click:Connect(function() S.TeleportService:TeleportToPlaceInstance(placeId, jobId, plr) end)

Misc_Buttons.InfYieldPremium.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/crazyDawg/main/InfYieldOther.lua"))() end)
end)

Donate_Link.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                setclipboard("https://1pix.gg/ksxspanel"); SendNotify("Link Copiado!", "Cole no navegador para ir pra p├ígina de doa├º├úo.", 10)
        end
end)
Donate_Link.MouseEnter:Connect(function() Donate_Link.TextColor3 = Color3.fromRGB(255, 100, 100) end)
Donate_Link.MouseLeave:Connect(function() Donate_Link.TextColor3 = Color3.fromRGB(0, 100, 255) end)

Support_Link.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                goDiscord(); SendNotify("Link Copiado!", "Cole no navegador para acessar o servidor de suporte.", 10)
        end
end)
Support_Link.MouseEnter:Connect(function() Support_Link.TextColor3 = Color3.fromRGB(255, 100, 100) end)
Support_Link.MouseLeave:Connect(function() Support_Link.TextColor3 = Color3.fromRGB(0, 100, 255) end)

isThemeActive = savedTheme ~= "Dark"
ChangeTheme_Button.MouseButton1Click:Connect(function()
        isThemeActive = not isThemeActive
        if isThemeActive then
                Theme = Themes.Light; ChangeTheme_Button.Image = "rbxassetid://99955958887420"; ChangeTheme(Theme); WriteFile("Theme", "value", "Light")
        else
                Theme = Themes.Dark; ChangeTheme_Button.Image = "rbxassetid://111141131115404"; ChangeTheme(Theme); WriteFile("Theme", "value", "Dark")
        end
end)

S.Players.PlayerRemoving:Connect(function(player)
        pcall(function() if player.Name == TargetedPlayer then UpdateTarget(nil); SendNotify("ksx's Panel", "O jogador alvo saiu.", 5) end end)
end)

plr.CharacterAdded:Connect(function(x)
        x:WaitForChild("Humanoid"); if SavedCheckpoint ~= nil then TeleportTO(SavedCheckpoint.X,SavedCheckpoint.Y,SavedCheckpoint.Z,"pos","safe") end
end)

OpenClose.MouseButton1Click:Connect(function() Background.Visible = not Background.Visible end)

S.UserInputService.InputBegan:Connect(function(input, gamep)
        if not gamep and input.KeyCode == Enum.KeyCode.B then Background.Visible = not Background.Visible end
end)

local canRequest = true
local function TpToPlace(command, username)
        if command == "?tp" and username and username ~= "" and canRequest then
                canRequest = false
                local data = RequestAPI("get-pos/"..username.."?user_id="..userId.."&permission=3f6a0f5d9c7a8d7c2a5d8a7c2c4cbe5c9a7c1e3d9f3f4c9e9f2f8a6d5c6b4a2")
                if data and data.place_id and data.job_id then
                        SendNotify("ksx's Panel", "Teleportando para o usu├írio "..username.."...", 3)
                        task.wait(3); S.TeleportService:TeleportToPlaceInstance(data.place_id, data.job_id, plr)
                else
                        local errorMsg = data and data.error or "Erro desconhecido"
                        SendNotify("ksx's Panel", errorMsg, 5)
                end; task.delay(10, function() canRequest = true end)
        end
end
local function BanUser(command, username)
        if command == "?ban" and username and username ~= "" and canRequest then
                canRequest = false
                local data = RequestAPI("ban-user/"..username.."?user_id="..userId.."&permission=3f6a0f5d9c7a8d7c2a5d8a7c2c4cbe5c9a7c1e3d9f3f4c9e9f2f8a6d5c6b4a2")
                if data and data.success then
                        SendNotify("ksx's Panel", data.success, 5)
                else
                        local errorMsg = data and data.error or "Erro desconhecido"
                        SendNotify("ksx's Panel", errorMsg, 5)
                end; task.delay(10, function() canRequest = true end)
        end
end
local function UnBanUser(command, username)
        if command == "?unban" and username and username ~= "" and canRequest then
                canRequest = false
                local data = RequestAPI("unban-user/"..username.."?user_id="..userId.."&permission=3f6a0f5d9c7a8d7c2a5d8a7c2c4cbe5c9a7c1e3d9f3f4c9e9f2f8a6d5c6b4a2")
                if data and data.success then
                        SendNotify("ksx's Panel", data.success, 5)
                else
                        local errorMsg = data and data.error or "Erro desconhecido"
                        SendNotify("ksx's Panel", errorMsg, 5)
                end; task.delay(10, function() canRequest = true end)
        end
end
S.TextChatService.SendingMessage:Connect(function(msg)
        task.spawn(function()
                local messageText = msg.Text
                local args = string.split(messageText, " ")
                local command, username = args[1]:lower(), table.concat(args, " ", 2)
                TpToPlace(command, username); BanUser(command, username); UnBanUser(command, username)
        end)
end)

local last_broadcast = 0
task.spawn(function()
        while task.wait(10) do
                if IsUserBanned() then
                        SendNotify("ksx's Panel", "Voc├¬ foi banido do ksx's Panel\nContate o suporte: https://discord.gg/"..discordCode, 3); goDiscord()
                        ScreenButtonGui:Destroy(); if TargetTool then TargetTool:Destroy() end; isTagActive = false; removeAllTags(); task.wait(3); GUI:Destroy(); plr:Kick()
                end
                if is_vip ~= last_vip_state then
                        if is_vip then
                                vip_fling, vip_antifling, vip_antiforce, vip_antichatspy, vip_autosacrifice, vip_escapehandcuffs = GetVip()
                                vipOverlay.Visible = not is_vip; SendNotify("ksx's Panel", "Seu VIP foi ativado com sucesso!", 5)
                        else
                                isThemeActive = false; Theme = Themes.Dark; ChangeTheme_Button.Image = "rbxassetid://111141131115404"; ChangeTheme(Theme); WriteFile("Theme", "value", "Dark")
                                vipOverlay.Visible = not is_vip; SendNotify("ksx's Panel", "Seu VIP expirou.\nPara renovar sua assinatura acesse: https://discord.gg/"..discordCode, 5); goDiscord()
                        end; last_vip_state = is_vip
                end
                local b = _broadcast; if b and b.message and b.id > last_broadcast then last_broadcast = b.id; SendNotify("AVISO DO SISTEMA", b.message, b.duration) end
        end
end)

task.spawn(function()
        while task.wait(30) do
                pcall(function()
                        local now, age = os.time(), plr.AccountAge
                        local date_1, date_2, date_3 = os.date("%Y-%m-%d", now-age * 24 * 3600), os.date("%Y-%m-%d", now-(age+1) * 24 * 3600), os.date("%Y-%m-%d", now-(age-1) * 24 * 3600)
                        local decode = httpRequest("GET", "https://users.roblox.com/v1/users/"..userId)
                        local original_name, original_display, original_date = decode.name, decode.displayName, decode.created:sub(1,10)
                        local function reconnect()
                                GUI:Destroy(); SendNotify("ksx's Panel", "Ocorreu um erro inesperado, reconectando...", 3)
                                task.wait(3); S.TeleportService:TeleportToPlaceInstance(placeId, jobId, plr)
                        end
                        if (plr.Name ~= original_name) or (plr.DisplayName ~= original_display) then reconnect(); return end
                        if (date_1 ~= original_date) and (date_2 ~= original_date) and (date_3 ~= original_date) then reconnect() end
                end)
        end
end)


--// VISUAL ENHANCER (auto-injected)
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local plr = Players.LocalPlayer

    local gui = plr:WaitForChild("PlayerGui"):WaitForChildWhichIsA("ScreenGui")
    local bg = gui:WaitForChild("Background", true)

    -- Blur
    if not Lighting:FindFirstChild("PanelBlur") then
        local blur = Instance.new("BlurEffect")
        blur.Name = "PanelBlur"
        blur.Size = 16
        blur.Parent = Lighting
    end

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = bg
    shadow.AnchorPoint = Vector2.new(0.5,0.5)
    shadow.Position = UDim2.new(0.5,0,0.5,8)
    shadow.Size = UDim2.new(1,40,1,40)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 0

    -- Rounded panel
    if not bg:FindFirstChildOfClass("UICorner") then
        local c = Instance.new("UICorner",bg)
        c.CornerRadius = UDim.new(0.15,0)
    end

    -- Title gradient
    local title = bg:FindFirstChild("TitleBarLabel")
    if title and not title:FindFirstChild("UIGradient") then
        local g = Instance.new("UIGradient",title)
        g.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120,120,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180,80,255))
        }
    end

    -- Buttons hover + stroke
    for _,v in ipairs(bg:GetDescendants()) do
        if v:IsA("TextButton") or v:IsA("TextBox") then
            if not v:FindFirstChildOfClass("UICorner") then
                Instance.new("UICorner",v).CornerRadius = UDim.new(0.25,0)
            end
            if not v:FindFirstChildOfClass("UIStroke") then
                local s = Instance.new("UIStroke",v)
                s.Transparency = 0.6
                s.Thickness = 1
            end
            if v:IsA("TextButton") then
                v.MouseEnter:Connect(function()
                    TweenService:Create(v,TweenInfo.new(.15),{BackgroundTransparency=0.25}):Play()
                end)
                v.MouseLeave:Connect(function()
                    TweenService:Create(v,TweenInfo.new(.15),{BackgroundTransparency=0.5}):Play()
                end)
            end
        end
    end
end)

--// END VISUAL ENHANCER
