local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = { Toggled = true, Accent = Color3.fromRGB(30, 100, 255), _blockDrag = false }

-- Lucide Icons via latte-soft/lucide-roblox (48px sprite-sheet data)
local Icons = {
    home          = { 16898613509, 48, 48, 820, 147 },
    flame         = { 16898613353, 48, 48, 967, 306 },
    settings      = { 16898613777, 48, 48, 771, 257 },
    account       = { 16898613869, 48, 48, 661, 869 },
    eye           = { 16898613353, 48, 48, 771, 563 },
    ["map-pin"]   = { 16898613613, 48, 48, 820, 257 },
    ["bar-chart-2"] = { 16898612629, 48, 48, 967, 710 },
    swords        = { 16898613777, 48, 48, 967, 759 },
    user          = { 16898613869, 48, 48, 661, 869 },
    shield        = { 16898613777, 48, 48, 869,   0 },
    zap           = { 16898613869, 48, 48, 918, 906 },
    target        = { 16898613869, 48, 48, 514, 771 },
    globe         = { 16898613509, 48, 48, 771, 563 },
    layout        = { 16898613509, 48, 48, 967, 612 },
    search        = { 16898613699, 48, 48, 918, 857 },
    save          = { 16898613699, 48, 48, 918, 453 },
    sliders       = { 16898613777, 48, 48, 404, 771 },
    snowflake     = { 16898613869, 48, 48, 869, 563 },
    smile         = { 16898613869, 48, 48, 967, 102 },
    list          = { 16898613509, 48, 48, 869, 514 },
    folder        = { 16898613509, 48, 48, 820, 820 },
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do if i ~= "Parent" then obj[i] = v end end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

function Library:MakeDraggable(gui)
    local drag, dStart, sPos
    gui.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 and not Library._blockDrag then
            drag = true; dStart = i.Position; sPos = gui.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            gui.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

function Library:GetIcon(name)
    return Icons[name] or Icons["home"]
end

function Library:CreateWindow(config)
    local title = type(config) == "table" and config.Title or config or "Snowy Hub"
    local version = type(config) == "table" and config.Footer or "v6"

    local ScreenGui = Create("ScreenGui", {
        Name = "SnowyHub",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })

    if getgenv then
        if getgenv()._SnowyUI then getgenv()._SnowyUI:Destroy() end
        getgenv()._SnowyUI = ScreenGui
    end

    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(8, 10, 20),
        Position = UDim2.new(0.5, -300, 0.5, -225),
        Size = UDim2.new(0, 600, 0, 450),
        ClipsDescendants = true
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    Create("UIStroke", { Color = Color3.fromRGB(20, 30, 60), Thickness = 2, Parent = Main })

    -- Header
    local Header = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60)
    })

    -- Logo Icon
    local LogoContainer = Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Library.Accent,
        Position = UDim2.new(0, 15, 0, 12),
        Size = UDim2.new(0, 36, 0, 36)
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = LogoContainer })

    local snowIcon = Library:GetIcon("snowflake")
    Create("ImageLabel", {
        Parent = LogoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -12, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Image = "rbxassetid://" .. snowIcon[1],
        ImageRectSize = Vector2.new(snowIcon[2], snowIcon[3]),
        ImageRectOffset = Vector2.new(snowIcon[4], snowIcon[5]),
        ImageColor3 = Color3.new(1, 1, 1)
    })

    -- Title
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 0),
        Size = UDim2.new(0, 150, 1, 0),
        Font = "GothamBold",
        Text = title:upper(),
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        TextXAlignment = "Left"
    })

    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60 + title:len() * 10, 0, 5),
        Size = UDim2.new(0, 40, 1, 0),
        Font = "Gotham",
        Text = version:lower(),
        TextColor3 = Color3.fromRGB(150, 150, 160),
        TextSize = 12,
        TextXAlignment = "Left"
    })

    -- Buttons Right
    local BtnContainer = Create("Frame", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -160, 0, 0),
        Size = UDim2.new(0, 150, 1, 0)
    })
    Create("UIListLayout", {
        Parent = BtnContainer,
        FillDirection = "Horizontal",
        HorizontalAlignment = "Right",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 10)
    })

    local FreeBadge = Create("Frame", {
        Parent = BtnContainer,
        BackgroundColor3 = Color3.fromRGB(20, 50, 130),
        Size = UDim2.new(0, 60, 0, 28)
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = FreeBadge })
    Create("TextLabel", {
        Parent = FreeBadge,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = "GothamBold",
        Text = "FREE",
        TextColor3 = Color3.fromRGB(100, 180, 255),
        TextSize = 11
    })

    local function makeHeaderBtn(text)
        local b = Create("TextButton", {
            Parent = BtnContainer,
            BackgroundColor3 = Color3.fromRGB(25, 25, 35),
            Size = UDim2.new(0, 28, 0, 28),
            Font = "GothamBold",
            Text = text,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 14,
            AutoButtonColor = false
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = b })
        Create("UIStroke", { Color = Color3.fromRGB(45, 45, 55), Parent = b })
        return b
    end

    local MinBtn = makeHeaderBtn("_")
    local CloseBtn = makeHeaderBtn("X")

    -- Banner
    local Banner = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(12, 16, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 0, 36)
    })
    local BannerText = Create("TextLabel", {
        Parent = Banner,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = "Gotham",
        Text = "LOADED SUCCESSFULLY -- Use RightShift to toggle",
        TextColor3 = Color3.fromRGB(80, 120, 200),
        TextSize = 12,
        TextXAlignment = "Left"
    })

    -- Navigation
    local Nav = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 105),
        Size = UDim2.new(1, -30, 0, 40)
    })
    local NavList = Create("UIListLayout", {
        Parent = Nav,
        FillDirection = "Horizontal",
        Padding = UDim.new(0, 12),
        VerticalAlignment = "Center"
    })

    -- Line below Nav
    Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(30, 40, 70),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 154),
        Size = UDim2.new(1, 0, 0, 1)
    })

    -- Content Area
    local Folder = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 155),
        Size = UDim2.new(1, 0, 1, -155)
    })

    Library:MakeDraggable(Main)

    local toggled = true
    local function toggleUI()
        toggled = not toggled
        Main.Visible = toggled
    end

    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    MinBtn.MouseButton1Click:Connect(toggleUI)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Window = { Current = nil, Tabs = {} }

    function Window:CreateTab(name, iconName)
        local tabIconData = Library:GetIcon(iconName or "home")

        local TabBtn = Create("TextButton", {
            Name = name .. "Tab",
            Parent = Nav,
            BackgroundColor3 = Color3.fromRGB(15, 20, 35),
            Size = UDim2.new(0, 100, 0, 32),
            AutoButtonColor = false,
            Font = "GothamBold",
            Text = "      " .. name,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 13
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = TabBtn })
        local TabStroke = Create("UIStroke", { Color = Color3.fromRGB(35, 45, 75), Parent = TabBtn })

        local TabIcon = Create("ImageLabel", {
            Name = "Icon",
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = "rbxassetid://" .. tabIconData[1],
            ImageRectSize = Vector2.new(tabIconData[2], tabIconData[3]),
            ImageRectOffset = Vector2.new(tabIconData[4], tabIconData[5]),
            ImageColor3 = Color3.fromRGB(150, 150, 160)
        })

        local TabIndicator = Create("Frame", {
            Name = "TabIndicator",
            Parent = TabBtn,
            BackgroundColor3 = Library.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 1, 2),
            Size = UDim2.new(1, -20, 0, 2),
            Visible = false
        })

        local Page = Create("ScrollingFrame", {
            Parent = Folder,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        local PageList = Create("UIListLayout", { Parent = Page, Padding = UDim.new(0, 12), HorizontalAlignment = "Center" })
        Create("UIPadding", { Parent = Page, PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 30)
        end)

        local Tab = { Page = Page, Btn = TabBtn }

        function Tab:Select()
            if Window.Current then
                Window.Current.Page.Visible = false
                Window.Current.Btn.TextColor3 = Color3.fromRGB(180, 180, 190)
                Window.Current.Btn:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(35, 45, 75)
                Window.Current.Btn.TabIndicator.Visible = false
                Window.Current.Btn.Icon.ImageColor3 = Color3.fromRGB(150, 150, 160)
            end
            Window.Current = Tab
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
            TabBtn:FindFirstChildOfClass("UIStroke").Color = Library.Accent
            TabIndicator.Visible = true
            TabIcon.ImageColor3 = Library.Accent
        end

        TabBtn.MouseButton1Click:Connect(function() Tab:Select() end)

        function Tab:CreateSection(secName)
            local SecContent = Create("Frame", { Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(0.94, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y })
            local SecList = Create("UIListLayout", { Parent = SecContent, Padding = UDim.new(0, 8) })

            local SecTitle = Create("TextLabel", {
                Parent = SecContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = "GothamBold",
                Text = secName:upper(),
                TextColor3 = Color3.fromRGB(100, 120, 180),
                TextSize = 11,
                TextXAlignment = "Left"
            })

            local S = {}

            function S:CreateToggle(n, def, cb)
                local F = Create("Frame", { Parent = SecContent, BackgroundColor3 = Color3.fromRGB(12, 15, 30), Size = UDim2.new(1, 0, 0, 44) })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = F })
                Create("UIStroke", { Color = Color3.fromRGB(25, 30, 50), Parent = F })

                Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -70, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 14, TextXAlignment = "Left" })

                local O = Create("Frame", { Parent = F, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(25, 30, 50), Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 40, 0, 20) })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                local I = Create("Frame", { Parent = O, BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(0, 3, 0.5, -7), Size = UDim2.new(0, 14, 0, 14) })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })

                local t = def or false
                local function u() 
                    Tween(O, 0.2, { BackgroundColor3 = t and Library.Accent or Color3.fromRGB(25, 30, 50) })
                    Tween(I, 0.2, { Position = t and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
                    if cb then cb(t) end 
                end

                local Click = Create("TextButton", { Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
                Click.MouseButton1Click:Connect(function() t = not t; u() end)

                u()
                return { Set = function(_, v) t = v; u() end }
            end

            function S:CreateButton(n, cb)
                local B = Create("TextButton", { Parent = SecContent, BackgroundColor3 = Color3.fromRGB(20, 25, 45), Size = UDim2.new(1, 0, 0, 40), Font = "GothamBold", Text = n, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 14, AutoButtonColor = false })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = B })
                Create("UIStroke", { Color = Color3.fromRGB(40, 50, 80), Parent = B })

                B.MouseEnter:Connect(function() Tween(B, 0.2, { BackgroundColor3 = Color3.fromRGB(30, 40, 70) }) end)
                B.MouseLeave:Connect(function() Tween(B, 0.2, { BackgroundColor3 = Color3.fromRGB(20, 25, 45) }) end)
                B.MouseButton1Click:Connect(function() if cb then cb() end end)
            end

            function S:CreateSlider(n, min, max, def, cb)
                local F = Create("Frame", { Parent = SecContent, BackgroundColor3 = Color3.fromRGB(12, 15, 30), Size = UDim2.new(1, 0, 0, 55) })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = F })
                Create("UIStroke", { Color = Color3.fromRGB(25, 30, 50), Parent = F })

                Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 10), Size = UDim2.new(1, -80, 0, 20), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 13, TextXAlignment = "Left" })
                local Val = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(1, -70, 0, 10), Size = UDim2.new(0, 55, 0, 20), Font = "GothamBold", Text = tostring(def or min), TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })

                local Bar = Create("Frame", { Parent = F, BackgroundColor3 = Color3.fromRGB(25, 30, 50), Position = UDim2.new(0, 15, 0, 38), Size = UDim2.new(1, -30, 0, 6) })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                local Fill = Create("Frame", { Parent = Bar, BackgroundColor3 = Library.Accent, Size = UDim2.new(((def or min) - min) / (max - min), 0, 1, 0) })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

                local dragging = false
                local function move(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Val.Text = tostring(val)
                    if cb then cb(val) end
                end

                Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; move(i) end end)
                UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)

                return { Set = function(_, v) local p = (v - min)/(max - min); Fill.Size = UDim2.new(p, 0, 1, 0); Val.Text = tostring(v); if cb then cb(v) end end }
            end

            function S:CreateDropdown(n, items, def, cb)
                local F = Create("Frame", { Parent = SecContent, BackgroundColor3 = Color3.fromRGB(12, 15, 30), Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = F })
                Create("UIStroke", { Color = Color3.fromRGB(25, 30, 50), Parent = F })

                local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -40, 0, 42), Font = "Gotham", Text = n .. ": " .. (def or "None"), TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 13, TextXAlignment = "Left" })
                local Arrow = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(1, -30, 0, 0), Size = UDim2.new(0, 20, 0, 42), Font = "GothamBold", Text = "v", TextColor3 = Color3.fromRGB(150, 150, 160), TextSize = 12 })

                local ItemList = Create("Frame", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 42), Size = UDim2.new(1, -10, 0, 0) })
                local IL = Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 4) })

                local opened = false
                local function refresh(list)
                    for _, c in next, ItemList:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
                    for _, item in next, list do
                        local Btn = Create("TextButton", { Parent = ItemList, BackgroundColor3 = Color3.fromRGB(20, 25, 45), Size = UDim2.new(1, 0, 0, 30), Font = "Gotham", Text = tostring(item), TextColor3 = Color3.fromRGB(180, 180, 190), TextSize = 13, AutoButtonColor = false })
                        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
                        Btn.MouseButton1Click:Connect(function()
                            Lbl.Text = n .. ": " .. tostring(item)
                            opened = false
                            Arrow.Text = "v"
                            Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, 42) })
                            if cb then cb(item) end
                        end)
                    end
                end
                refresh(items or {})

                local Click = Create("TextButton", { Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), Text = "" })
                Click.MouseButton1Click:Connect(function()
                    opened = not opened
                    Arrow.Text = opened and "^" or "v"
                    local h = opened and (42 + IL.AbsoluteContentSize.Y + 10) or 42
                    Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                end)

                return { Refresh = function(_, list) refresh(list) end }
            end

            function S:CreateTextBox(n, placeholder, cb)
                local F = Create("Frame", { Parent = SecContent, BackgroundColor3 = Color3.fromRGB(12, 15, 30), Size = UDim2.new(1, 0, 0, 44) })
                Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = F })
                Create("UIStroke", { Color = Color3.fromRGB(25, 30, 50), Parent = F })

                Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 13, TextXAlignment = "Left" })
                local Box = Create("TextBox", { Parent = F, BackgroundColor3 = Color3.fromRGB(20, 25, 45), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0.5, -10, 0, 26), Font = "Gotham", Text = "", PlaceholderText = placeholder or "Enter...", TextColor3 = Color3.new(1, 1, 1), PlaceholderColor3 = Color3.fromRGB(100, 100, 110), TextSize = 13, ClearTextOnFocus = false })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Box })

                Box.FocusLost:Connect(function(enter) if enter and cb then cb(Box.Text) end end)
                return { Set = function(_,v) Box.Text = v end }
            end

            function S:CreateLabel(n)
                local Lbl = Create("TextLabel", { Parent = SecContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = "Gotham", Text = " • " .. n, TextColor3 = Color3.fromRGB(160, 160, 170), TextSize = 12, TextXAlignment = "Left" })

                return { Set = function(_, v) Lbl.Text = " • " .. v end }
            end

            function S:AddLabel(n) return S:CreateLabel(n) end
            function S:AddButton(t) return S:CreateButton(t.Text, t.Func) end
            function S:AddToggle(id, t) return S:CreateToggle(t.Text, t.Default, t.Callback) end
            function S:AddDropdown(id, t) return S:CreateDropdown(t.Text, t.Values, t.Default, t.Callback) end
            function S:AddSlider(id, t) return S:CreateSlider(t.Text, t.Min, t.Max, t.Default, t.Callback) end
            function S:AddTextbox(id, t) return S:CreateTextBox(t.Text, t.Placeholder, t.Callback) end

            return S
        end

        function Tab:AddLeftGroupbox(n) return Tab:CreateSection(n) end
        function Tab:AddRightGroupbox(n) return Tab:CreateSection(n) end

        table.insert(Window.Tabs, Tab)
        if not Window.Current then Tab:Select() end
        return Tab
    end

    function Window:AddTab(name, icon) return Window:CreateTab(name, icon) end
    function Window:Notify(text, dur)
        local N = Create("Frame", { Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(10, 12, 25), Position = UDim2.new(1, 20, 1, -100), Size = UDim2.new(0, 240, 0, 60) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = N })
        Create("UIStroke", { Color = Library.Accent, Parent = N })

        Create("TextLabel", { Parent = N, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 20), Font = "GothamBold", Text = "NOTIFICATION", TextColor3 = Library.Accent, TextSize = 12, TextXAlignment = "Left" })
        Create("TextLabel", { Parent = N, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(1, -24, 0, 24), Font = "Gotham", Text = text, TextColor3 = Color3.new(1, 1, 1), TextSize = 13, TextXAlignment = "Left", TextWrapped = true })

        Tween(N, 0.5, { Position = UDim2.new(1, -260, 1, -100) })
        task.delay(dur or 4, function()
            Tween(N, 0.5, { Position = UDim2.new(1, 20, 1, -100) })
            task.wait(0.5); N:Destroy()
        end)
    end

    Library.Notify = function(self, ...) return Window:Notify(...) end

    return Window
end

return Library
