local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- GUI Instance
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KRUN_Durian_Hub_Compact"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
--  ระบบ BYPASS TELEPORT (กันดีด / กันตกแมพ)
-- ==========================================
local function bypassTeleport(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- ล้างแรงเหวี่ยงและความเร็วเดิม เพื่อกันระบบฟิสิกส์ตรวจจับ
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    -- ส่ง Remote แจ้งตำแหน่งให้เซิร์ฟเวอร์ซิงค์เพื่อลดการ Rollback
    if Remotes:FindFirstChild("MovementSync") then
        pcall(function()
            Remotes.MovementSync:FireServer(targetCFrame.Position)
        end)
    end

    -- สลายแรงตรวจจับด้วย NoClip ชั่วคราว และเทเลพอร์ตแบบ CFrame ตรง
    local originalState = hum:GetState()
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    task.wait(0.03)
    root.CFrame = targetCFrame + Vector3.new(0, 2.5, 0)
    task.wait(0.03)
    hum:ChangeState(originalState)
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

-- ==========================================
--  ระบบแปลภาษา (Localization TH / EN)
-- ==========================================
local currentLang = "TH"
local textRegistry = {}

local LangDict = {
    SubTitle = { TH = "สวนทุเรียน By 126!B HUB", EN = "Durian Garden By 126!B HUB!" },
    Tab_Farming = { TH = "ทำฟาร์ม", EN = "Farming" },
    Tab_Harvest = { TH = "เก็บเกี่ยว/ขาย", EN = "Harvest/Sell" },
    Tab_Teleport = { TH = "วาร์ป (Bypass)", EN = "Teleport (Bypass)" },
    Tab_Vehicles = { TH = "ยานพาหนะ", EN = "Vehicles" },
    Tab_FishPet = { TH = "ตกปลา/สัตว์เลี้ยง", EN = "Fish & Pet" },
    Tab_Admin = { TH = "ระบบแอดมิน", EN = "Admin Tools" },
    Tab_Extras = { TH = "ตั้งค่า", EN = "Settings" },

    Sec_Watering = { TH = "ดูแลสวน", EN = "Farm Care" },
    Sec_Seeds = { TH = "ซื้อเมล็ด", EN = "Buy Seeds" },
    Sec_Harvest = { TH = "เก็บผลผลิต", EN = "Harvesting" },
    Sec_SellCargo = { TH = "ขาย & รับของ", EN = "Sell & Loot" },
    Sec_TPLoc = { TH = "จุดวาร์ปสำคัญ (Bypass)", EN = "Waypoints (Bypass)" },
    Sec_TPPlayer = { TH = "วาร์ปหาคนอื่น", EN = "Player Teleport" },
    Sec_SpawnVeh = { TH = "เรียกรถ", EN = "Spawn Vehicle" },
    Sec_Fishing = { TH = "ระบบตกปลา", EN = "Auto Fish" },
    Sec_AdminFunc = { TH = "คำสั่งพิเศษ", EN = "Exploits" },
    Sec_PlayerStat = { TH = "ความเร็วตัวละคร", EN = "Player Speed" },

    WaterGun = { TH = "รดน้ำอัตโนมัติ", EN = "Auto Water" },
    GrowAll = { TH = "เร่งโตทั้งสวน", EN = "Grow All Crops" },
    Spray = { TH = "ฉีดพ่นปุ๋ย", EN = "Auto Spray" },
    BuyMonthong = { TH = "ซื้อหมอนทอง", EN = "Buy Monthong" },
    BuyKanyao = { TH = "ซื้อก้านยาว", EN = "Buy Kanyao" },
    AutoHarvest = { TH = "ดูดผลทุเรียน", EN = "Auto Harvest" },
    SellDurians = { TH = "ขายทุเรียนทันที", EN = "Sell All Durians" },
    ChestClaim = { TH = "รับกล่องรายวัน", EN = "Claim Chest" },
    TPSellZone = { TH = "วาร์ปจุดขายทุเรียน", EN = "TP Sell Area" },
    TPFarmZone = { TH = "วาร์ปแปลงเพาะปลูก", EN = "TP Garden Farm" },
    TPShopZone = { TH = "วาร์ปร้านค้า/โรงรถ", EN = "TP Shop & Garage" },
    SpawnSaleng = { TH = "เรียกรถซาเล้ง", EN = "Spawn Saleng" },
    SpawnPickup = { TH = "เรียกรถกระบะ", EN = "Spawn Pickup" },
    AutoFish = { TH = "ตกปลาออโต้ (Perfect)", EN = "Auto Catch Perfect" },
    UnlockPasses = { TH = "ปลดล็อกเกมพาส", EN = "Unlock Passes" },
    DupeTool = { TH = "ปั๊มไอเทม (Dupe)", EN = "Dupe Items" },
    GiveCash = { TH = "เสกเงินเข้าตัว", EN = "Max Cash" },
    WalkSpeed = { TH = "ความเร็วเดิน", EN = "Speed Walk" }
}

local function registerText(obj, key)
    textRegistry[obj] = key
    obj.Text = LangDict[key][currentLang]
end

local function toggleLanguage()
    currentLang = (currentLang == "TH") and "EN" or "TH"
    for obj, key in pairs(textRegistry) do
        if obj and obj.Parent then
            obj.Text = LangDict[key][currentLang]
        end
    end
end

-- ==========================================
--  สีตัวหนังสือ แดงไล่ดำ (Red to Black)
-- ==========================================
local function applyRedToBlackGradient(textLabel)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 5, 5))
    }
    grad.Rotation = 90
    grad.Parent = textLabel
    return grad
end

-- ==========================================
--  1. ลูกลอยเปิด/ปิด สี่เหลี่ยมมน + แสงน้ำเงินอ่อน
-- ==========================================
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Name = "KRUN_FloatButton"
FloatBtn.Size = UDim2.new(0, 44, 0, 44)
FloatBtn.Position = UDim2.new(0.03, 0, 0.4, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 12)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2
FloatStroke.Color = Color3.fromRGB(110, 195, 255)
FloatStroke.Transparency = 0.25
FloatStroke.Parent = FloatBtn

task.spawn(function()
    while FloatStroke.Parent do
        TweenService:Create(FloatStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.65,
            Color = Color3.fromRGB(70, 150, 255)
        }):Play()
        task.wait(1.3)
        TweenService:Create(FloatStroke, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.15,
            Color = Color3.fromRGB(140, 225, 255)
        }):Play()
        task.wait(1.3)
    end
end)

local FloatLogo = Instance.new("TextLabel")
FloatLogo.Size = UDim2.new(1, 0, 1, 0)
FloatLogo.BackgroundTransparency = 1
FloatLogo.Text = "K!"
FloatLogo.Font = Enum.Font.FredokaOne
FloatLogo.TextSize = 22
FloatLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatLogo.Parent = FloatBtn
applyRedToBlackGradient(FloatLogo)

-- แดรกเกอร์ลูกลอย
local draggingFloat, dragInputFloat, dragStartFloat, startPosFloat
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = true
        dragStartFloat = input.Position
        startPosFloat = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFloat = false
            end
        end)
    end
end)
FloatBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputFloat = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputFloat and draggingFloat then
        local delta = input.Position - dragStartFloat
        FloatBtn.Position = UDim2.new(startPosFloat.X.Scale, startPosFloat.X.Offset + delta.X, startPosFloat.Y.Scale, startPosFloat.Y.Offset + delta.Y)
    end
end)

-- ==========================================
--  2. หน้าต่างหลัก (ปรับให้สมส่วน กะทัดรัด)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- ลดขนาดลงจาก 780x480 เป็น 580x360 ให้พอดีหน้าจอ
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.4
MainStroke.Color = Color3.fromRGB(80, 170, 255)
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ลากหน้าต่างหลักได้
local draggingMain, dragInputMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMain = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMain = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMain and draggingMain then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

-- ==========================================
--  แถบด้านซ้าย (Compact Sidebar)
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 165, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- โลโก้ KRUN!
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(1, 0, 0, 52)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Parent = Sidebar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "KRUN!"
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Size = UDim2.new(1, -20, 0, 22)
TitleLabel.Position = UDim2.new(0, 14, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = LogoContainer
applyRedToBlackGradient(TitleLabel)

local SubTitle = Instance.new("TextLabel")
SubTitle.Font = Enum.Font.SourceSansBold
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Size = UDim2.new(1, -20, 0, 14)
SubTitle.Position = UDim2.new(0, 14, 0, 31)
SubTitle.BackgroundTransparency = 1
SubTitle.TextColor3 = Color3.fromRGB(120, 120, 140)
SubTitle.Parent = LogoContainer
registerText(SubTitle, "SubTitle")

-- รายการปุ่มแท็บ
local TabBtnScroll = Instance.new("ScrollingFrame")
TabBtnScroll.Size = UDim2.new(1, -12, 1, -108)
TabBtnScroll.Position = UDim2.new(0, 6, 0, 56)
TabBtnScroll.BackgroundTransparency = 1
TabBtnScroll.ScrollBarThickness = 1
TabBtnScroll.CanvasSize = UDim2.new(0, 0, 0, 260)
TabBtnScroll.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabBtnScroll

-- แถบล่างแสดงชื่อผู้เล่น & ปุ่มสลับภาษา
local UserFooter = Instance.new("Frame")
UserFooter.Size = UDim2.new(1, -12, 0, 42)
UserFooter.Position = UDim2.new(0, 6, 1, -48)
UserFooter.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
UserFooter.BorderSizePixel = 0
UserFooter.Parent = Sidebar

local UserCorner = Instance.new("UICorner")
UserCorner.CornerRadius = UDim.new(0, 8)
UserCorner.Parent = UserFooter

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 11
UserName.TextColor3 = Color3.fromRGB(230, 230, 230)
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Size = UDim2.new(0, 95, 0, 14)
UserName.Position = UDim2.new(0, 8, 0, 6)
UserName.BackgroundTransparency = 1
UserName.Parent = UserFooter

local UserTag = Instance.new("TextLabel")
UserTag.Text = "@" .. LocalPlayer.Name
UserTag.Font = Enum.Font.Gotham
UserTag.TextSize = 9
UserTag.TextColor3 = Color3.fromRGB(100, 100, 120)
UserTag.TextXAlignment = Enum.TextXAlignment.Left
UserTag.Size = UDim2.new(0, 95, 0, 12)
UserTag.Position = UDim2.new(0, 8, 0, 22)
UserTag.BackgroundTransparency = 1
UserTag.Parent = UserFooter

local LangSwitchBtn = Instance.new("TextButton")
LangSwitchBtn.Size = UDim2.new(0, 36, 0, 22)
LangSwitchBtn.Position = UDim2.new(1, -42, 0.5, -11)
LangSwitchBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 45)
LangSwitchBtn.Text = "TH/EN"
LangSwitchBtn.Font = Enum.Font.GothamBold
LangSwitchBtn.TextSize = 9
LangSwitchBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
LangSwitchBtn.Parent = UserFooter

local LangBtnCorner = Instance.new("UICorner")
LangBtnCorner.CornerRadius = UDim.new(0, 6)
LangBtnCorner.Parent = LangSwitchBtn

LangSwitchBtn.MouseButton1Click:Connect(function()
    toggleLanguage()
end)

-- ==========================================
--  พื้นที่แสดงผลเนื้อหา (Content Pages)
-- ==========================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -165, 1, 0)
ContentContainer.Position = UDim2.new(0, 165, 0, 0)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function createPage(pageName)
    local Page = Instance.new("Frame")
    Page.Name = pageName
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentContainer

    -- ปรับ 2 คอลัมน์ให้ระยะห่างและขนาดกะทัดรัด
    local LeftCol = Instance.new("ScrollingFrame")
    LeftCol.Size = UDim2.new(0.49, -10, 1, -16)
    LeftCol.Position = UDim2.new(0, 8, 0, 8)
    LeftCol.BackgroundTransparency = 1
    LeftCol.ScrollBarThickness = 2
    LeftCol.CanvasSize = UDim2.new(0, 0, 0, 380)
    LeftCol.Parent = Page

    local LeftList = Instance.new("UIListLayout")
    LeftList.Padding = UDim.new(0, 8)
    LeftList.Parent = LeftCol

    local RightCol = Instance.new("ScrollingFrame")
    RightCol.Size = UDim2.new(0.49, -10, 1, -16)
    RightCol.Position = UDim2.new(0.5, 3, 0, 8)
    RightCol.BackgroundTransparency = 1
    RightCol.ScrollBarThickness = 2
    RightCol.CanvasSize = UDim2.new(0, 0, 0, 380)
    RightCol.Parent = Page

    local RightList = Instance.new("UIListLayout")
    RightList.Padding = UDim.new(0, 8)
    RightList.Parent = RightCol

    Pages[pageName] = { Page = Page, Left = LeftCol, Right = RightCol }
    return Pages[pageName]
end

local function createSection(parentCol, sectionKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
    Card.BorderSizePixel = 0
    Card.Parent = parentCol

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Thickness = 1
    CardStroke.Color = Color3.fromRGB(28, 32, 45)
    CardStroke.Parent = Card

    local CardList = Instance.new("UIListLayout")
    CardList.Padding = UDim.new(0, 7)
    CardList.Parent = Card

    local CardPad = Instance.new("UIPadding")
    CardPad.PaddingTop = UDim.new(0, 8)
    CardPad.PaddingBottom = UDim.new(0, 10)
    CardPad.PaddingLeft = UDim.new(0, 9)
    CardPad.PaddingRight = UDim.new(0, 9)
    CardPad.Parent = Card

    local SecTitle = Instance.new("TextLabel")
    SecTitle.Font = Enum.Font.GothamBold
    SecTitle.TextSize = 11
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.Size = UDim2.new(1, 0, 0, 14)
    SecTitle.BackgroundTransparency = 1
    SecTitle.TextColor3 = Color3.fromRGB(130, 160, 215)
    SecTitle.Parent = Card
    registerText(SecTitle, sectionKey)

    return Card
end

local function addToggle(card, textKey, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.Parent = card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -44, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextColor3 = Color3.fromRGB(215, 215, 225)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    registerText(Label, textKey)

    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 36, 0, 18)
    SwitchBg.Position = UDim2.new(1, -36, 0.5, -9)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(30, 32, 44)
    SwitchBg.Text = ""
    SwitchBg.AutoButtonColor = false
    SwitchBg.Parent = Row

    local SwCorner = Instance.new("UICorner")
    SwCorner.CornerRadius = UDim.new(1, 0)
    SwCorner.Parent = SwitchBg

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SwitchBg

    local KnCorner = Instance.new("UICorner")
    KnCorner.CornerRadius = UDim.new(1, 0)
    KnCorner.Parent = Knob

    local isEnabled = false
    SwitchBg.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            TweenService:Create(SwitchBg, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(255, 40, 40)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.18), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
        else
            TweenService:Create(SwitchBg, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30, 32, 44)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
        end
        callback(isEnabled)
    end)
end

local function addButton(card, textKey, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 26)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 10
    Btn.TextColor3 = Color3.fromRGB(235, 235, 245)
    Btn.AutoButtonColor = false
    Btn.Parent = card
    registerText(Btn, textKey)

    local BtnCor = Instance.new("UICorner")
    BtnCor.CornerRadius = UDim.new(0, 6)
    BtnCor.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(38, 42, 60)
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(200, 35, 35)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 24, 34)}):Play()
        callback()
    end)
end

local function addSlider(card, textKey, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 38)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -36, 0, 14)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 10
    Label.TextColor3 = Color3.fromRGB(215, 215, 225)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    registerText(Label, textKey)

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0, 30, 0, 14)
    ValLabel.Position = UDim2.new(1, -30, 0, 0)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 10
    ValLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    ValLabel.Text = tostring(defaultVal)
    ValLabel.Parent = SliderFrame

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, 0, 0, 4)
    Bar.Position = UDim2.new(0, 0, 0, 24)
    Bar.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
    Bar.Text = ""
    Bar.AutoButtonColor = false
    Bar.Parent = SliderFrame

    local BarCor = Instance.new("UICorner")
    BarCor.CornerRadius = UDim.new(1, 0)
    BarCor.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 45, 45)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCor = Instance.new("UICorner")
    FillCor.CornerRadius = UDim.new(1, 0)
    FillCor.Parent = Fill

    local isSliding = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + ((maxVal - minVal) * rel))
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        ValLabel.Text = tostring(value)
        callback(value)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function addTab(tabKey, pageName)
    local PageData = createPage(pageName)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = TabBtnScroll

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabBtn

    local TabTitle = Instance.new("TextLabel")
    TabTitle.Size = UDim2.new(1, -16, 1, 0)
    TabTitle.Position = UDim2.new(0, 10, 0, 0)
    TabTitle.BackgroundTransparency = 1
    TabTitle.Font = Enum.Font.GothamMedium
    TabTitle.TextSize = 11
    TabTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Parent = TabBtn
    registerText(TabTitle, tabKey)

    TabButtons[pageName] = { Button = TabBtn, Title = TabTitle }

    TabBtn.MouseButton1Click:Connect(function()
        for p, data in pairs(Pages) do
            data.Page.Visible = (p == pageName)
        end
        for p, btnData in pairs(TabButtons) do
            if p == pageName then
                btnData.Button.BackgroundTransparency = 0
                btnData.Button.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
                btnData.Title.TextColor3 = Color3.fromRGB(255, 60, 60)
            else
                btnData.Button.BackgroundTransparency = 1
                btnData.Title.TextColor3 = Color3.fromRGB(140, 140, 160)
            end
        end
    end)

    return PageData
end

-- ==========================================
--  3. สร้างหมวดหมู่แท็บ & ปลั๊กอินฟังชันก์
-- ==========================================

-- [1] แท็บ: ทำฟาร์ม
local FarmTab = addTab("Tab_Farming", "Farming")
do
    local secWater = createSection(FarmTab.Left, "Sec_Watering")
    addToggle(secWater, "WaterGun", function(state)
        _G.AutoWater = state
        task.spawn(function()
            while _G.AutoWater do
                Remotes.WaterGun:FireServer()[cite: 1]
                Remotes.Water:FireServer()[cite: 1]
                task.wait(0.5)
            end
        end)
    end)
    addButton(secWater, "GrowAll", function()
        Remotes.GrowAll:FireServer()[cite: 1]
    end)
    addToggle(secWater, "Spray", function(state)
        _G.AutoSpray = state
        task.spawn(function()
            while _G.AutoSpray do
                Remotes.Spray:FireServer()[cite: 1]
                task.wait(0.9)
            end
        end)
    end)

    local secSeeds = createSection(FarmTab.Right, "Sec_Seeds")
    addButton(secSeeds, "BuyMonthong", function()
        Remotes.SeedShop:FireServer("Monthong", 1)[cite: 1]
    end)
    addButton(secSeeds, "BuyKanyao", function()
        Remotes.SeedShop:FireServer("Kanyao", 1)[cite: 1]
    end)
end

-- [2] แท็บ: เก็บเกี่ยว / ขาย
local HarvestTab = addTab("Tab_Harvest", "Harvest")
do
    local secHarv = createSection(HarvestTab.Left, "Sec_Harvest")
    addToggle(secHarv, "AutoHarvest", function(state)
        _G.AutoHarvest = state
        task.spawn(function()
            while _G.AutoHarvest do
                Remotes.HarvestFruit:FireServer()[cite: 1]
                Remotes.PutDownLoot:FireServer()[cite: 1]
                task.wait(0.6)
            end
        end)
    end)

    local secSell = createSection(HarvestTab.Right, "Sec_SellCargo")
    addButton(secSell, "SellDurians", function()
        Remotes.SellDurians:FireServer()[cite: 1]
    end)
    addButton(secSell, "ChestClaim", function()
        Remotes.Chest:InvokeServer()[cite: 1]
        Remotes.Rewards:FireServer()[cite: 1]
    end)
end

-- [3] แท็บ: BYPASS TELEPORT
local TpTab = addTab("Tab_Teleport", "Teleport")
do
    local secTP1 = createSection(TpTab.Left, "Sec_TPLoc")
    addButton(secTP1, "TPSellZone", function()
        -- จุดส่งทุเรียน/ขายทุเรียน
        local sellZone = workspace:FindFirstChild("SellArea") or workspace:FindFirstChild("MarketSat")
        if sellZone then
            bypassTeleport(sellZone:GetPivot())
        else
            bypassTeleport(CFrame.new(35, 12, -150))
        end
    end)
    addButton(secTP1, "TPFarmZone", function()
        -- จุดแปลงปลูกทุเรียน
        local farmZone = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("FarmLand")
        if farmZone then
            bypassTeleport(farmZone:GetPivot())
        else
            bypassTeleport(CFrame.new(0, 10, 0))
        end
    end)
    addButton(secTP1, "TPShopZone", function()
        -- จุดร้านค้าเมล็ด & โรงรถ
        bypassTeleport(CFrame.new(-120, 10, 80))
    end)

    local secTP2 = createSection(TpTab.Right, "Sec_TPPlayer")
    -- สแกนผู้เล่นในเซิร์ฟเพื่อทำปุ่มวาร์ปหา
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 24)
            pBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextSize = 10
            pBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
            pBtn.Text = "TP: " .. plr.DisplayName
            pBtn.Parent = secTP2

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 6)
            pCorner.Parent = pBtn

            pBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    bypassTeleport(plr.Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end

-- [4] แท็บ: ยานพาหนะ
local VehTab = addTab("Tab_Vehicles", "Vehicles")
do
    local secSpawn = createSection(VehTab.Left, "Sec_SpawnVeh")
    addButton(secSpawn, "SpawnSaleng", function()
        Remotes.Garage:FireServer("RedSaleng")[cite: 1]
    end)
    addButton(secSpawn, "SpawnPickup", function()
        Remotes.Garage:FireServer("LuxePickup")[cite: 1]
    end)
end

-- [5] แท็บ: ตกปลา & สัตว์เลี้ยง
local FishTab = addTab("Tab_FishPet", "FishPet")
do
    local secFish = createSection(FishTab.Left, "Sec_Fishing")
    addToggle(secFish, "AutoFish", function(state)
        _G.AutoFish = state
        task.spawn(function()
            while _G.AutoFish do
                Remotes.CatchReady:FireServer()[cite: 1]
                task.wait(0.35)
                Remotes.Fishing:FireServer("Perfect")[cite: 1]
                task.wait(1.1)
            end
        end)
    end)
end

-- [6] แท็บ: แอดมิน & ปั๊มของ
local AdminTab = addTab("Tab_Admin", "Admin")
do
    local secDev = createSection(AdminTab.Left, "Sec_AdminFunc")
    addButton(secDev, "UnlockPasses", function()
        Remotes.UnlockAllPasses:FireServer()[cite: 1]
    end)
    addButton(secDev, "DupeTool", function()
        Remotes.DupeItem:FireServer()[cite: 1]
    end)
    addButton(secDev, "GiveCash", function()
        Remotes.GiveMoney:FireServer(99999999)[cite: 1]
        Remotes.SetCash:FireServer(99999999)[cite: 1]
    end)
end

-- [7] แท็บ: ตั้งค่า
local ExtraTab = addTab("Tab_Extras", "Extras")
do
    local secStat = createSection(ExtraTab.Left, "Sec_PlayerStat")
    addSlider(secStat, "WalkSpeed", 16, 200, 16, function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)
end

-- เปิดแท็บแรกอัตโนมัติ
Pages["Farming"].Page.Visible = true
TabButtons["Farming"].Button.BackgroundTransparency = 0
TabButtons["Farming"].Button.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
TabButtons["Farming"].Title.TextColor3 = Color3.fromRGB(255, 60, 60)
