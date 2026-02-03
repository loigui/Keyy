-- ============================================================
-- 1. CẤU HÌNH TỰ ĐỘNG CẬP NHẬT LINK & THÔNG TIN
-- ============================================================
local LinkFile = "https://raw.githubusercontent.com/loigui/Keyy/main/server_link.txt"
local DiscordLink = "https://discord.gg/mnggRFxdeF"
local MainScript = "https://raw.githubusercontent.com/loigui/Script-blox-kid-/refs/heads/main/scriptmoinhat.lua%20(3)%20(1).lua"

-- Tự động lấy Link Tunnel mới nhất từ GitHub
local LinkSuccess, LinkResult = pcall(function()
    return game:HttpGet(LinkFile)
end)

local ServerUrl = LinkSuccess and LinkResult:gsub("%s+", "") or ""
local Player = game:GetService("Players").LocalPlayer
local playerName = Player.Name

-- ============================================================
-- 2. KHỞI TẠO GUI (VERIFY + AI CHAT)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraSystem_V2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- --- KHUNG XÁC THỰC (MainFrame) ---
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🛡️ VERIFY SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0, 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.Parent = MainFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 280, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, -140, 0, 110)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
VerifyBtn.Text = "XÁC THỰC"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.TextSize = 14
VerifyBtn.Parent = MainFrame
Instance.new("UICorner", VerifyBtn)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 280, 0, 30)
GetKeyBtn.Position = UDim2.new(0.5, -140, 0, 160)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(71, 85, 105)
GetKeyBtn.Text = "LẤY KEY (COPY LINK)"
GetKeyBtn.Font = Enum.Font.Gotham
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.TextSize = 12
GetKeyBtn.Parent = MainFrame
Instance.new("UICorner", GetKeyBtn)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -20)
StatusLabel.Text = ServerUrl == "" and "⚠️ Lỗi link Server!" or "Vui lòng nhập key để tiếp tục"
StatusLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusLabel.TextSize = 12
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- --- KHUNG CHAT AI (AICanvas - Ẩn lúc đầu) ---
-- --- KHUNG CHAT AI (AICanvas - Có thể di chuyển) ---
local AICanvas = Instance.new("Frame")
AICanvas.Name = "AICanvas"
AICanvas.Size = UDim2.new(0, 300, 0, 120)
AICanvas.Position = UDim2.new(1, -310, 1, -130)
AICanvas.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
AICanvas.BorderSizePixel = 0
AICanvas.Visible = false
AICanvas.Active = true       -- CẦN THIẾT: Để nhận diện thao tác chuột
AICanvas.Draggable = true    -- CẦN THIẾT: Cho phép kéo thả
AICanvas.Parent = ScreenGui

local AICorner = Instance.new("UICorner")
AICorner.CornerRadius = UDim.new(0, 10)
AICorner.Parent = AICanvas

local AIInput = Instance.new("TextBox")
AIInput.Size = UDim2.new(1, -20, 0, 35)
AIInput.Position = UDim2.new(0, 10, 0, 35)
AIInput.PlaceholderText = "Hỏi Gemini AI..."
AIInput.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
AIInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AIInput.Parent = AICanvas
Instance.new("UICorner", AIInput)

local AISend = Instance.new("TextButton")
AISend.Size = UDim2.new(1, -20, 0, 30)
AISend.Position = UDim2.new(0, 10, 0, 80)
AISend.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
AISend.Text = "HỎI AI"
AISend.Parent = AICanvas
Instance.new("UICorner", AISend)

-- ============================================================
-- 3. LOGIC XỬ LÝ
-- ============================================================

-- Copy Link Discord
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(DiscordLink)
    StatusLabel.Text = "Đã copy link Discord!"
end)

-- Chat với Gemini
-- Trong phần logic của nút AISend
AISend.MouseButton1Click:Connect(function()
    local q = AIInput.Text
    if q == "" or ServerUrl == "" then return end
    
    AISend.Text = "⏳ Đang nhớ lại..."
    AISend.Active = false
    
    local encoded = game:GetService("HttpService"):UrlEncode(q)
    
    -- THÊM THAM SỐ &user= VÀO URL
    local fullUrl = ServerUrl .. "/ask_gemini?question=" .. encoded .. "&user=" .. playerName
    
    local success, response = pcall(function()
        return game:HttpGet(fullUrl)
    end)
    
    if success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🤖 Gemini AI:",
            Text = response,
            Duration = 10
        })
    end
    
    AISend.Text = "HỎI AI"
    AISend.Active = true
    AIInput.Text = ""
end)

-- Xác thực Key
VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    if userKey == "" or ServerUrl == "" then 
        StatusLabel.Text = "⚠️ Lỗi: Không có link server!" 
        return 
    end

    StatusLabel.Text = "⏳ Đang kết nối..."
    
    local success, result = pcall(function()
        return game:HttpGet(ServerUrl .. "/checkkey?key=" .. userKey)
    end)

    if success then
        if result == "valid" then
            StatusLabel.Text = "✅ THÀNH CÔNG!"
            StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
            
            -- Gửi Log bí mật về Discord
            pcall(function()
                game:HttpGet(ServerUrl .. "/log_success?user=" .. playerName .. "&key=" .. userKey)
            end)

            task.wait(1)
            MainFrame.Visible = false -- Ẩn bảng Verify
            AICanvas.Visible = true  -- Hiện bảng AI Chat
            
            -- Tải Script chính
            loadstring(game:HttpGet(MainScript))()
        elseif result == "expired" then
            StatusLabel.Text = "❌ Key đã hết hạn!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        else
            StatusLabel.Text = "❌ Key sai/Chưa giải Captcha!"
            StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
    else
        StatusLabel.Text = "🌐 Lỗi Server!"
        warn("Loi: " .. tostring(result))
    end
end)


