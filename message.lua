-- Cấu hình hệ thống
local ServerUrl = "https://acc-metals-meeting-hose.trycloudflare.com"
local DiscordLink = "https://discord.gg/mnggRFxdeF"
local MainScript = "https://raw.githubusercontent.com/loigui/Script-blox-kid-/refs/heads/main/scriptmoinhat.lua%20(3)%20(1).lua"

-- Lấy thông tin người chơi
local Player = game:GetService("Players").LocalPlayer
local playerName = Player.Name

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomKeySystem"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Khung chính (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🛡️ VERIFY SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Ô nhập Key
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0, 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
KeyInput.Text = getgenv().Key or ""
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = KeyInput

-- Nút Xác Thực
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 280, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, -140, 0, 110)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
VerifyBtn.Text = "XÁC THỰC"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.TextSize = 14
VerifyBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.Parent = VerifyBtn

-- Nút Lấy Key
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 280, 0, 30)
GetKeyBtn.Position = UDim2.new(0.5, -140, 0, 160)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(71, 85, 105)
GetKeyBtn.Text = "LẤY KEY (COPY LINK)"
GetKeyBtn.Font = Enum.Font.Gotham
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 12
GetKeyBtn.Parent = MainFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Parent = GetKeyBtn

-- Dòng trạng thái
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -20)
StatusLabel.Text = "Vui lòng nhập key để tiếp tục"
StatusLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusLabel.TextSize = 12
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-----------------------------------------------------------
-- LOGIC XỬ LÝ
-----------------------------------------------------------

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(DiscordLink)
    StatusLabel.Text = "Đã copy link Discord!"
    StatusLabel.TextColor3 = Color3.fromRGB(56, 189, 248)
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    if userKey == "" then 
        StatusLabel.Text = "Vui lòng nhập key!" 
        return 
    end

    StatusLabel.Text = "⏳ Đang kết nối server..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local success, result = pcall(function()
        return game:HttpGet(ServerUrl .. "/checkkey?key=" .. userKey)
    end)

    if success then
        if result == "valid" then
            StatusLabel.Text = "✅ THÀNH CÔNG!"
            StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
            
            -- Gửi log bí mật về Discord (Không hiện Key trong thông báo bot)
            pcall(function()
                game:HttpGet(ServerUrl .. "/log_success?user=" .. playerName .. "&key=" .. userKey)
            end)

            task.wait(0.5)
            StatusLabel.Text = "✨ Xin chào " .. playerName .. "! Đang tải script..."
            task.wait(1)
            
            ScreenGui:Destroy()
            
            -- TẢI SCRIPT CHÍNH QUA LOADSTRING
            loadstring(game:HttpGet(MainScript))()
            
        elseif result == "expired" then
            StatusLabel.Text = "❌ Key đã hết hạn sử dụng!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        else
            StatusLabel.Text = "❌ Key sai hoặc chưa giải CAPTCHA!"
            StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
    else
        StatusLabel.Text = "🌐 Lỗi kết nối! Kiểm tra link Cloudflare."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        warn("Lỗi xác thực: " .. tostring(result))
    end
end)
