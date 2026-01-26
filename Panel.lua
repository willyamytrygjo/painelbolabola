-- painel bolabola - versão mínima sem API/arquivos

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "PainelBolaBola"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 350)
frame.Position = UDim2.new(0.5, -250, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "painel bolabola"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 40
title.TextScaled = true

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "VIP ATIVADO - Daneli Edition"
subtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 24

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.white
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("painel bolabola aberto - versão mínima")
