-- Cấu hình hệ thống

local ServerUrl = "https://acc-metals-meeting-hose.trycloudflare.com"

local DiscordLink = "https://discord.gg/mnggRFxdeF"



-- Tạo ScreenGui

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "CustomKeySystem"

ScreenGui.Parent = game:GetService("CoreGui") -- Hiện trên cả menu game

ScreenGui.ResetOnSpawn = false



-- Khung chính (Main Frame)

local MainFrame = Instance.new("Frame")

MainFrame.Name = "MainFrame"

MainFrame.Size = UDim2.new(0, 350, 0, 220)

MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)

MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42) -- Màu tối Navy

MainFrame.BorderSizePixel = 0

MainFrame.Active = true

MainFrame.Draggable = true -- Cho phép kéo thả bảng

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



-- Ô nhập Key (TextBox)

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



-- Nút Xác Thực (Verify)

local VerifyBtn = Instance.new("TextButton")

VerifyBtn.Size = UDim2.new(0, 280, 0, 40)

VerifyBtn.Position = UDim2.new(0.5, -140, 0, 110)

VerifyBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) -- Màu xanh lá

VerifyBtn.Text = "XÁC THỰC"

VerifyBtn.Font = Enum.Font.GothamBold

VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

VerifyBtn.TextSize = 14

VerifyBtn.Parent = MainFrame



local BtnCorner = Instance.new("UICorner")

BtnCorner.Parent = VerifyBtn



-- Nút Lấy Key (Get Key)

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



-- Dòng trạng thái (Status)

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



-- 1. Lưu key vào genv khi gõ

KeyInput.FocusLost:Connect(function()

    getgenv().Key = KeyInput.Text

end)



-- 2. Nút lấy key

GetKeyBtn.MouseButton1Click:Connect(function()

    setclipboard(DiscordLink) -- Copy link discord

    StatusLabel.Text = "Đã copy link Discord!"

    StatusLabel.TextColor3 = Color3.fromRGB(56, 189, 248)

end)



-- 3. Nút xác thực

VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    if userKey == "" then 
        StatusLabel.Text = "Vui lòng nhập key!" 
        return 
    end

    StatusLabel.Text = "⏳ Đang kết nối server..."
    
    local success, result = pcall(function()
        -- Thiết lập timeout ngắn để không treo máy nếu link die
        return game:HttpGet(ServerUrl .. "/checkkey?key=" .. userKey)
    end)

    if success then
        if result == "valid" then
            StatusLabel.Text = "✅ THÀNH CÔNG!"
            StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
            getgenv().Verified = true
           pcall(function()
        game:HttpGet(ServerUrl .. "/log_success?user=" .. playerName .. "&key=" .. userKey)
    end)

    StatusLabel.Text = "✨ Xin chào " .. playerName .. "! Đang tải script..."
    task.wait(1)
            task.wait(1)
            ScreenGui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/loigui/Script-blox-kid-/refs/heads/main/scriptmoinhat.lua%20(3)%20(1).lua"))()
        elseif result == "expired" then
            StatusLabel.Text = "❌ Key đã hết hạn sử dụng!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        else
            StatusLabel.Text = "❌ Key sai hoặc chưa giải CAPTCHA!"
            StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
    else
        -- Trường hợp này xảy ra khi link trycloudflare của bạn đã bị đổi/chết
        StatusLabel.Text = "🌐 Lỗi kết nối! Server có thể đang bảo trì."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        warn("Loi ket noi: " .. tostring(result))
    end

end)

