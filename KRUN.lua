-- =========================================================
--  PROJECT: KRUN! HUB - DURIO EDITION
--  GAME: [อัพเดท] สวนทุเรียน 🍈
-- =========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KRUN_Durian_Hub"
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
--  ระบบแปลภาษา (Localization TH / EN)
-- ==========================================
local currentLang = "TH"
local textRegistry = {}

local LangDict = {
    SubTitle = { TH = "สวนทุเรียน By KRUN!", EN = "Durian Garden By KRUN!" },
    -- หมวดหมู่แท็บ
    Tab_Farming = { TH = "ทำฟาร์มทุเรียน", EN = "Durian Farming" },
    Tab_Harvest = { TH = "เก็บเกี่ยว & ขาย", EN = "Harvest & Sell" },
    Tab_Vehicles = { TH = "ยานพาหนะ", EN = "Vehicles & Cargo" },
    Tab_FishPet = { TH = "ตกปลา & สัตว์เลี้ยง", EN = "Fishing & Pets" },
    Tab_Admin = { TH = "ระบบแอดมิน & ดูด", EN = "Admin & Dupe" },
    Tab_Extras = { TH = "ตั้งค่า & อื่นๆ", EN = "Extras & Misc" },
    -- ส่วนหัวกลุ่ม
    Sec_Watering = { TH = "รดน้ำและดูแล", EN = "Watering & Care" },
    Sec_Seeds = { TH = "ระบบซื้อเมล็ด", EN = "Seed System" },
    Sec_Harvest = { TH = "เก็บเกี่ยวผลผลิต", EN = "Harvest Produce" },
    Sec_SellCargo = { TH = "ขาย & ขนส่ง", EN = "Selling & Cargo" },
    Sec_SpawnVeh = { TH = "เรียกรถ", EN = "Spawn Vehicle" },
    Sec_VehControl = { TH = "ควบคุมยานยนต์", EN = "Vehicle Control" },
    Sec_Fishing = { TH = "ระบบตกปลา", EN = "Fishing System" },
    Sec_PetCtrl = { TH = "สัตว์เลี้ยงเสริมพลัง", EN = "Pets & Boost" },
    Sec_AdminFunc = { TH = "ฟังก์ชันผู้พัฒนา", EN = "Developer Remotes" },
    Sec_PassEconomy = { TH = "เศรษฐกิจ & ปลดล็อก", EN = "Pass & Economy" },
    Sec_PlayerStat = { TH = "สถานะผู้เล่น", EN = "Player Stats" },
    Sec_Codes = { TH = "ระบบโค้ด & รีเบิร์ธ", EN = "Codes & Rebirth" },
    -- ชื่อปุ่ม/สวิตช์
    WaterGun = { TH = "ยิงปืนฉีดน้ำรดน้ำอัตโนมัติ", EN = "Auto Water Gun" },
    GrowAll = { TH = "เร่งการโตทั้งหมด (GrowAll)", EN = "Force Grow All Crops" },
    Spray = { TH = "ฉีดพ่นปุ๋ยบำรุงต้นไม้", EN = "Auto Spray Fertilizer" },
    BuyMonthong = { TH = "ซื้อเมล็ดหมอนทอง (Monthong)", EN = "Buy Monthong Seed" },
    BuyKanyao = { TH = "ซื้อเมล็ดก้านยาว (Kanyao)", EN = "Buy Kanyao Seed" },
    BuyChanee = { TH = "ซื้อเมล็ดชะนี (Chanee)", EN = "Buy Chanee Seed" },
    AutoHarvest = { TH = "ดูดเก็บทุเรียนสุกทั้งหมด", EN = "Auto Harvest Durians" },
    SellDurians = { TH = "ขายผลทุเรียนทั้งหมดทันที", EN = "Instant Sell Durians" },
    ChestClaim = { TH = "กดรับหีบสมบัติ/รางวัล", EN = "Claim Daily Chest" },
    SpawnSaleng = { TH = "เรียกรถซาเล้ง (Red Saleng)", EN = "Spawn Red Saleng" },
    SpawnPickup = { TH = "เรียกรถกระบะหรู (Luxe Pickup)", EN = "Spawn Luxe Pickup" },
    AutoFish = { TH = "ตกปลาอัตโนมัติ (สมบูรณ์แบบ)", EN = "Auto Catch Perfect Fish" },
    EquipPet = { TH = "เรียกสัตว์เลี้ยง (Centipede/Cat)", EN = "Equip Pet / Beast" },
    UnlockPasses = { TH = "ปลดล็อกเกมพาสทั้งหมด (UnlockAll)", EN = "Unlock All Gamepasses" },
    DupeTool = { TH = "ปั๊มไอเทมในกระเป๋า (Dupe)", EN = "Duplicate Item (Dupe)" },
    GiveCash = { TH = "เสกเงินเข้าตัว (SetCash/GiveMoney)", EN = "Inject Max Cash" },
    WalkSpeed = { TH = "ความเร็วเดิน (WalkSpeed)", EN = "Walk Speed Multiplier" },
    RebirthBtn = { TH = "จุติรับโบนัส (Rebirth)", EN = "Perform Rebirth" },
    LangToggle = { TH = "ภาษา: ไทย (คลิกเพื่อเปลี่ยน)", EN = "Language: EN (Click to switch)" }
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
--  ฟังก์ชันช่วยสร้างตัวหนังสือ แดงไล่ดำ (Red to Black)
-- ==========================================
local function applyRedToBlackGradient(textLabel)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 0))
    }
    grad.Rotation = 90
    grad.Parent = textLabel
    return grad
end

-- ==========================================
--  1. ลูกลอยเปิด/ปิด สี่เหลี่ยมขอบมน + เรืองแสงสีน้ำเงินอ่อน
-- ==========================================
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Name = "KRUN_FloatButton"
FloatBtn.Size = UDim2.new(0, 56, 0, 56)
FloatBtn.Position = UDim2.new(0.04, 0, 0.45, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 16)
FloatCorner.Parent = FloatBtn

-- แสงเรืองแสงสีน้ำเงินอ่อนๆ
local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2.4
FloatStroke.Color = Color3.fromRGB(100, 190, 255)
FloatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FloatStroke.Transparency = 0.2
FloatStroke.Parent = FloatBtn

-- ทำเอฟเฟกต์เรืองแสง Pulsing
task.spawn(function()
    while FloatStroke.Parent do
        TweenService:Create(FloatStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.65,
            Color = Color3.fromRGB(60, 140, 255)
        }):Play()
        task.wait(1.4)
        TweenService:Create(FloatStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.1,
            Color = Color3.fromRGB(140, 220, 255)
        }):Play()
        task.wait(1.4)
    end
end)

-- โลโก้ในลูกลอย
local FloatLogo = Instance.new("TextLabel")
FloatLogo.Size = UDim2.new(1, 0, 1, 0)
FloatLogo.BackgroundTransparency = 1
FloatLogo.Text = "K!"
FloatLogo.Font = Enum.Font.FredokaOne
FloatLogo.TextSize = 28
FloatLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatLogo.Parent = FloatBtn
applyRedToBlackGradient(FloatLogo)

-- ระบบลากลูกลอย (Draggable)
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
--  2. หน้าต่างหลัก (Main Hub Window)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

-- เส้นขอบเรืองแสงสีน้ำเงินอ่อน
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.6
MainStroke.Color = Color3.fromRGB(80, 170, 255)
MainStroke.Transparency = 0.35
MainStroke.Parent = MainFrame

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
--  แถบด้านซ้าย (Sidebar)
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 220, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Logo Header
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(1, 0, 0, 75)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Parent = Sidebar

local LogoIcon = Instance.new("ImageLabel")
LogoIcon.Size = UDim2.new(0, 42, 0, 42)
LogoIcon.Position = UDim2.new(0, 16, 0, 16)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Image = "rbxassetid://10849911875" -- Durian/Fruit Vector Icon
LogoIcon.ImageColor3 = Color3.fromRGB(255, 60, 60)
LogoIcon.Parent = LogoContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "KRUN!"
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Size = UDim2.new(0, 140, 0, 24)
TitleLabel.Position = UDim2.new(0, 66, 0, 16)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = LogoContainer
applyRedToBlackGradient(TitleLabel)

local SubTitle = Instance.new("TextLabel")
SubTitle.Font = Enum.Font.SourceSansBold
SubTitle.TextSize = 13
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Size = UDim2.new(0, 140, 0, 16)
SubTitle.Position = UDim2.new(0, 66, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
SubTitle.Parent = LogoContainer
registerText(SubTitle, "SubTitle")

-- รายการปุ่มแท็บ
local TabBtnScroll = Instance.new("ScrollingFrame")
TabBtnScroll.Size = UDim2.new(1, -16, 1, -150)
TabBtnScroll.Position = UDim2.new(0, 8, 0, 80)
TabBtnScroll.BackgroundTransparency = 1
TabBtnScroll.ScrollBarThickness = 2
TabBtnScroll.CanvasSize = UDim2.new(0, 0, 0, 360)
TabBtnScroll.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabBtnScroll

-- แถบโปรไฟล์ผู้ใช้ด้านล่าง (User Bar)
local UserFooter = Instance.new("Frame")
UserFooter.Size = UDim2.new(1, -16, 0, 54)
UserFooter.Position = UDim2.new(0, 8, 1, -62)
UserFooter.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
UserFooter.BorderSizePixel = 0
UserFooter.Parent = Sidebar

local UserCorner = Instance.new("UICorner")
UserCorner.CornerRadius = UDim.new(0, 12)
UserCorner.Parent = UserFooter

local UserAvatar = Instance.new("ImageLabel")
UserAvatar.Size = UDim2.new(0, 38, 0, 38)
UserAvatar.Position = UDim2.new(0, 8, 0.5, -19)
UserAvatar.BackgroundTransparency = 1
UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
UserAvatar.Parent = UserFooter

local UserAvCorner = Instance.new("UICorner")
UserAvCorner.CornerRadius = UDim.new(1, 0)
UserAvCorner.Parent = UserAvatar

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 13
UserName.TextColor3 = Color3.fromRGB(240, 240, 240)
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Size = UDim2.new(0, 100, 0, 16)
UserName.Position = UDim2.new(0, 52, 0, 10)
UserName.BackgroundTransparency = 1
UserName.Parent = UserFooter

local UserTag = Instance.new("TextLabel")
UserTag.Text = "@" .. LocalPlayer.Name
UserTag.Font = Enum.Font.Gotham
UserTag.TextSize = 11
UserTag.TextColor3 = Color3.fromRGB(110, 110, 130)
UserTag.TextXAlignment = Enum.TextXAlignment.Left
UserTag.Size = UDim2.new(0, 100, 0, 14)
UserTag.Position = UDim2.new(0, 52, 0, 28)
UserTag.BackgroundTransparency = 1
UserTag.Parent = UserFooter

-- ปุ่มสลับภาษาบนหัว Footer
local LangSwitchBtn = Instance.new("TextButton")
LangSwitchBtn.Size = UDim2.new(0, 42, 0, 24)
LangSwitchBtn.Position = UDim2.new(1, -48, 0.5, -12)
LangSwitchBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
LangSwitchBtn.Text = "TH/EN"
LangSwitchBtn.Font = Enum.Font.GothamBold
LangSwitchBtn.TextSize = 10
LangSwitchBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
LangSwitchBtn.Parent = UserFooter

local LangBtnCorner = Instance.new("UICorner")
LangBtnCorner.CornerRadius = UDim.new(0, 6)
LangBtnCorner.Parent = LangSwitchBtn

LangSwitchBtn.MouseButton1Click:Connect(function()
    toggleLanguage()
end)

-- ==========================================
--  พื้นที่แสดงเนื้อหา (Content Pages)
-- ==========================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -220, 1, 0)
ContentContainer.Position = UDim2.new(0, 220, 0, 0)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Pages = {}
local TabButtons = {}
local activeTab = nil

local function createPage(pageName)
    local Page = Instance.new("Frame")
    Page.Name = pageName
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentContainer

    -- โครงสร้างแบบ 2 คอลัมน์ (ซ้าย - ขวา ตาม UI Reference)
    local LeftCol = Instance.new("ScrollingFrame")
    LeftCol.Size = UDim2.new(0.485, -12, 1, -24)
    LeftCol.Position = UDim2.new(0, 12, 0, 12)
    LeftCol.BackgroundTransparency = 1
    LeftCol.ScrollBarThickness = 3
    LeftCol.CanvasSize = UDim2.new(0,0,0, 540)
    LeftCol.Parent = Page

    local LeftList = Instance.new("UIListLayout")
    LeftList.Padding = UDim.new(0, 12)
    LeftList.Parent = LeftCol

    local RightCol = Instance.new("ScrollingFrame")
    RightCol.Size = UDim2.new(0.485, -12, 1, -24)
    RightCol.Position = UDim2.new(0.5, 4, 0, 12)
    RightCol.BackgroundTransparency = 1
    RightCol.ScrollBarThickness = 3
    RightCol.CanvasSize = UDim2.new(0,0,0, 540)
    RightCol.Parent = Page

    local RightList = Instance.new("UIListLayout")
    RightList.Padding = UDim.new(0, 12)
    RightList.Parent = RightCol

    Pages[pageName] = { Page = Page, Left = LeftCol, Right = RightCol }
    return Pages[pageName]
end

-- สร้าง Card แยกส่วน
local function createSection(parentCol, sectionKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 0) -- Auto Size
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Card.BorderSizePixel = 0
    Card.Parent = parentCol

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 12)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Thickness = 1
    CardStroke.Color = Color3.fromRGB(28, 32, 45)
    CardStroke.Parent = Card

    local CardList = Instance.new("UIListLayout")
    CardList.Padding = UDim.new(0, 10)
    CardList.Parent = Card

    local CardPad = Instance.new("UIPadding")
    CardPad.PaddingTop = UDim.new(0, 12)
    CardPad.PaddingBottom = UDim.new(0, 14)
    CardPad.PaddingLeft = UDim.new(0, 12)
    CardPad.PaddingRight = UDim.new(0, 12)
    CardPad.Parent = Card

    local SecTitle = Instance.new("TextLabel")
    SecTitle.Font = Enum.Font.GothamBold
    SecTitle.TextSize = 13
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.Size = UDim2.new(1, 0, 0, 18)
    SecTitle.BackgroundTransparency = 1
    SecTitle.TextColor3 = Color3.fromRGB(150, 170, 220)
    SecTitle.Parent = Card
    registerText(SecTitle, sectionKey)

    return Card
end

-- สวิตช์เปิด/ปิด Toggle Component
local function addToggle(card, textKey, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 32)
    Row.BackgroundTransparency = 1
    Row.Parent = card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    registerText(Label, textKey)

    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 44, 0, 24)
    SwitchBg.Position = UDim2.new(1, -44, 0.5, -12)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(30, 32, 44)
    SwitchBg.Text = ""
    SwitchBg.AutoButtonColor = false
    SwitchBg.Parent = Row

    local SwCorner = Instance.new("UICorner")
    SwCorner.CornerRadius = UDim.new(1, 0)
    SwCorner.Parent = SwitchBg

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
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
            TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 40, 40)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 32, 44)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        callback(isEnabled)
    end)
end

-- ปุ่มกด Action Component
local function addButton(card, textKey, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(240, 240, 255)
    Btn.AutoButtonColor = false
    Btn.Parent = card
    registerText(Btn, textKey)

    local BtnCor = Instance.new("UICorner")
    BtnCor.CornerRadius = UDim.new(0, 8)
    BtnCor.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(45, 50, 70)
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play()
        task.wait(0.12)
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 24, 34)}):Play()
        callback()
    end)
end

-- แถบเลื่อน Slider Component
local function addSlider(card, textKey, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 46)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    registerText(Label, textKey)

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0, 40, 0, 18)
    ValLabel.Position = UDim2.new(1, -40, 0, 0)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    ValLabel.Text = tostring(defaultVal)
    ValLabel.Parent = SliderFrame

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0, 28)
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

-- ฟังก์ชันสร้างแท็บฝั่งซ้าย
local function addTab(tabKey, pageName, iconId)
    local PageData = createPage(pageName)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 42)
    TabBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = TabBtnScroll

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 10)
    TabBtnCorner.Parent = TabBtn

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 20, 0, 20)
    TabIcon.Position = UDim2.new(0, 12, 0.5, -10)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = iconId or "rbxassetid://10849911875"
    TabIcon.ImageColor3 = Color3.fromRGB(140, 140, 160)
    TabIcon.Parent = TabBtn

    local TabTitle = Instance.new("TextLabel")
    TabTitle.Size = UDim2.new(1, -44, 1, 0)
    TabTitle.Position = UDim2.new(0, 42, 0, 0)
    TabTitle.BackgroundTransparency = 1
    TabTitle.Font = Enum.Font.GothamMedium
    TabTitle.TextSize = 13
    TabTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Parent = TabBtn
    registerText(TabTitle, tabKey)

    TabButtons[pageName] = { Button = TabBtn, Icon = TabIcon, Title = TabTitle }

    TabBtn.MouseButton1Click:Connect(function()
        for p, data in pairs(Pages) do
            data.Page.Visible = (p == pageName)
        end
        for p, btnData in pairs(TabButtons) do
            if p == pageName then
                btnData.Button.BackgroundTransparency = 0
                btnData.Button.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
                btnData.Title.TextColor3 = Color3.fromRGB(255, 60, 60)
                btnData.Icon.ImageColor3 = Color3.fromRGB(255, 60, 60)
            else
                btnData.Button.BackgroundTransparency = 1
                btnData.Title.TextColor3 = Color3.fromRGB(150, 150, 170)
                btnData.Icon.ImageColor3 = Color3.fromRGB(140, 140, 160)
            end
        end
    end)

    return PageData
end

-- ==========================================
--  3. สร้างแท็บและเชื่อมต่อ Remote ทั้งหมดตาม Dump
-- ==========================================

-- [1] แท็บ: ทำฟาร์มทุเรียน
local FarmTab = addTab("Tab_Farming", "Farming", "rbxassetid://10849911875")
do
    local secWater = createSection(FarmTab.Left, "Sec_Watering")
    addToggle(secWater, "WaterGun", function(state)
        _G.AutoWater = state
        task.spawn(function()
            while _G.AutoWater do
                Remotes.WaterGun:FireServer()
                Remotes.Water:FireServer()
                task.wait(0.5)
            end
        end)
    end)

    addButton(secWater, "GrowAll", function()
        Remotes.GrowAll:FireServer()
    end)

    addToggle(secWater, "Spray", function(state)
        _G.AutoSpray = state
        task.spawn(function()
            while _G.AutoSpray do
                Remotes.Spray:FireServer()
                task.wait(1)
            end
        end)
    end)

    local secSeeds = createSection(FarmTab.Right, "Sec_Seeds")
    addButton(secSeeds, "BuyMonthong", function()
        Remotes.SeedShop:FireServer("Monthong", 1)
    end)
    addButton(secSeeds, "BuyKanyao", function()
        Remotes.SeedShop:FireServer("Kanyao", 1)
    end)
    addButton(secSeeds, "BuyChanee", function()
        Remotes.SeedShop:FireServer("Chanee", 1)
    end)
end

-- [2] แท็บ: เก็บเกี่ยว & ค้าขาย
local HarvestTab = addTab("Tab_Harvest", "Harvest", "rbxassetid://10849911875")
do
    local secHarvest = createSection(HarvestTab.Left, "Sec_Harvest")
    addToggle(secHarvest, "AutoHarvest", function(state)
        _G.AutoHarvest = state
        task.spawn(function()
            while _G.AutoHarvest do
                Remotes.HarvestFruit:FireServer()
                Remotes.PutDownLoot:FireServer()
                task.wait(0.6)
            end
        end)
    end)

    local secSell = createSection(HarvestTab.Right, "Sec_SellCargo")
    addButton(secSell, "SellDurians", function()
        Remotes.SellDurians:FireServer()
    end)
    addButton(secSell, "ChestClaim", function()
        Remotes.Chest:InvokeServer()
        Remotes.Rewards:FireServer()
    end)
end

-- [3] แท็บ: ยานพาหนะ (Vehicles)
local VehTab = addTab("Tab_Vehicles", "Vehicles", "rbxassetid://10849911875")
do
    local secSpawn = createSection(VehTab.Left, "Sec_SpawnVeh")
    addButton(secSpawn, "SpawnSaleng", function()
        Remotes.Garage:FireServer("RedSaleng")
    end)
    addButton(secSpawn, "SpawnPickup", function()
        Remotes.Garage:FireServer("LuxePickup")
    end)

    local secCtrl = createSection(VehTab.Right, "Sec_VehControl")
    addButton(secCtrl, "SpawnPickup", function()
        Remotes.VehicleAction:FireServer("Refuel")
    end)
end

-- [4] แท็บ: ตกปลา & สัตว์เลี้ยง
local FishTab = addTab("Tab_FishPet", "FishPet", "rbxassetid://10849911875")
do
    local secFish = createSection(FishTab.Left, "Sec_Fishing")
    addToggle(secFish, "AutoFish", function(state)
        _G.AutoFish = state
        task.spawn(function()
            while _G.AutoFish do
                Remotes.CatchReady:FireServer()
                task.wait(0.4)
                Remotes.Fishing:FireServer("Perfect")
                task.wait(1.2)
            end
        end)
    end)

    local secPet = createSection(FishTab.Right, "Sec_PetCtrl")
    addButton(secPet, "EquipPet", function()
        Remotes.Pet:FireServer("Equip", "Cat")
    end)
end

-- [5] แท็บ: ระบบแอดมิน & ดูดไอเทม (Admin & Dupe)
local AdminTab = addTab("Tab_Admin", "Admin", "rbxassetid://10849911875")
do
    local secDev = createSection(AdminTab.Left, "Sec_AdminFunc")
    addButton(secDev, "UnlockPasses", function()
        Remotes.UnlockAllPasses:FireServer()
    end)
    addButton(secDev, "DupeTool", function()
        Remotes.DupeItem:FireServer()
    end)

    local secCash = createSection(AdminTab.Right, "Sec_PassEconomy")
    addButton(secCash, "GiveCash", function()
        Remotes.GiveMoney:FireServer(99999999)
        Remotes.SetCash:FireServer(99999999)
    end)
end

-- [6] แท็บ: ตั้งค่า & สถานะผู้เล่น (Extras)
local ExtraTab = addTab("Tab_Extras", "Extras", "rbxassetid://10849911875")
do
    local secStat = createSection(ExtraTab.Left, "Sec_PlayerStat")
    addSlider(secStat, "WalkSpeed", 16, 250, 16, function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)

    local secMisc = createSection(ExtraTab.Right, "Sec_Codes")
    addButton(secMisc, "RebirthBtn", function()
        Remotes.Rebirth:InvokeServer()
    end)
end

-- เปิดหน้าแรกเป็นค่าเริ่มต้น
Pages["Farming"].Page.Visible = true
TabButtons["Farming"].Button.BackgroundTransparency = 0
TabButtons["Farming"].Button.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TabButtons["Farming"].Title.TextColor3 = Color3.fromRGB(255, 60, 60)
TabButtons["Farming"].Icon.ImageColor3 = Color3.fromRGB(255, 60, 60)
