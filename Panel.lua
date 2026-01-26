-- painel bolabola - versão 100% mínima (sem nada que dê erro)

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "PainelBolaBola"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 350)
frame.Position = UDim2.new(0.5, -250, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "painel bolabola"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 50
title.TextScaled = true
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 40)
subtitle.Position = UDim2.new(0, 0, 0, 60)
subtitle.BackgroundTransparency = 1
subtitle.Text = "VIP ATIVADO - Edição Daneli - Paranatinga MT"
subtitle.TextColor3 = Color3.fromRGB(0, 255, 100)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 28
subtitle.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 50, 0, 50)
close.Position = UDim2.new(1, -55, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.white
close.Font = Enum.Font.GothamBold
close.TextSize = 40
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("painel bolabola mínimo aberto com sucesso!")
