
local CoreGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
endG

getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 1

getgenv().HitboxStatus = false
getgenv().TeamCheck = false

getgenv().Walkspeed = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed
getgenv().Jumppower = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower

getgenv().TPSpeed = 3
getgenv().TPWalk = false


--// UI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/UI"))();
local Window = Library:Create("HEANG CHEAT | 😈ENGINE😈 For PVP")

local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")

ToggleGui.Name = "ToggleGui_HE"
ToggleGui.Parent = game.CoreGui

Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(0, 98, 255)
Toggle.BackgroundTransparency = 1
Toggle.Position = UDim2.new(0, 0, 0.454706937, 0)
Toggle.Size = UDim2.new(0.0650164187, 0, 0.0888099447, 0)
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "Toggle"
Toggle.TextScaled = true
Toggle.TextTransparency = 1
Toggle.TextColor3 = Color3.fromRGB(40, 40, 40)
Toggle.TextSize = 24.000
Toggle.TextXAlignment = Enum.TextXAlignment.Left
Toggle.Active = true
Toggle.Draggable = true
Toggle.MouseButton1Click:connect(function()
    Library:ToggleUI()
end)

local HomeTab = Window:Tab("Home |","rbxassetid://10888331510")
local PlayerTab = Window:Tab("Players |","rbxassetid://12296135476")
local VisualTab = Window:Tab("Visuals |","rbxassetid://12308581351")
local ToolTab = Window:Tab("Tools |","rbxassetid://138278296376047")
local ScriptTab = Window:Tab("Script |","rbxassetid://138025500944534")
local AnimationTab = Window:Tab("Animation |","rbxassetid://138025500944534")
local TrollTab = Window:Tab("Troll |","rbxassetid://138025500944534")
local DTab = Window:Tab("Dahood Aim |","rbxassetid://138025500944534")
local TTab = Window:Tab("Teleport |","rbxassetid://138025500944534")
-- HomeTab:InfoLabel("only works on some games!")
-- test
local aimbotEnabled = false
local wallCheckEnabled = false
local aimAtPart = "Head"
local teamCheckEnabled = false
local headSizeEnabled = false

-- Functions
local function getClosestTarget()
    local Cam = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local localRoot = character:WaitForChild("HumanoidRootPart")
    local nearestTarget = nil
    local shortestDistance = math.huge

    local function checkTarget(target)
        if target and target:IsA("Model") and target:FindFirstChild("Humanoid") and target:FindFirstChild(aimAtPart) then
            local targetRoot = target[aimAtPart]
            local distance = (targetRoot.Position - localRoot.Position).Magnitude

            if distance < shortestDistance then
                if wallCheckEnabled then
                    local rayDirection = (targetRoot.Position - Cam.CFrame.Position).Unit * 1000
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local raycastResult = workspace:Raycast(Cam.CFrame.Position, rayDirection, raycastParams)

                    if raycastResult and raycastResult.Instance:IsDescendantOf(target) then
                        shortestDistance = distance
                        nearestTarget = target
                    end
                else
                    shortestDistance = distance
                    nearestTarget = target
                end
            end
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not teamCheckEnabled or player.Team ~= localPlayer.Team) then
            checkTarget(player.Character)
        end
    end

    if targetNPCs then
        for _, npc in pairs(workspace:GetDescendants()) do
            checkTarget(npc)
        end
    end

    return nearestTarget
end

local function lookAt(targetPosition)
    local Cam = workspace.CurrentCamera
    if targetPosition then
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, targetPosition)
    end
end

local function aimAtTarget()
    local runService = game:GetService("RunService")
    local connection
    connection = runService.RenderStepped:Connect(function()
        if not aimbotEnabled then
            connection:Disconnect()
            return
        end

        local closestTarget = getClosestTarget()
        if closestTarget and closestTarget:FindFirstChild(aimAtPart) then
            local targetRoot = closestTarget[aimAtPart]

            while aimbotEnabled and closestTarget and closestTarget:FindFirstChild(aimAtPart) and closestTarget.Humanoid.Health > 0 do
                lookAt(targetRoot.Position)
                local rayDirection = (targetRoot.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local raycastResult = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, rayDirection, raycastParams)

                if not raycastResult or not raycastResult.Instance:IsDescendantOf(closestTarget) then
                    break
                end

                runService.RenderStepped:Wait()
            end
        end
    end)
end

local function resizeHeads()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    local function resizeHead(model)
        local head = model:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Size = Vector3.new(10, 10, 10)
            head.CanCollide = false
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            resizeHead(player.Character)
        end
    end

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Head") then
            resizeHead(npc)
        end
    end
end

--test
HomeTab:Section("Settings")
-- HomeTab:Section("Main")
HomeTab:Toggle("Enable: ", function(state)
	getgenv().HitboxStatus = state
    game:GetService('RunService').RenderStepped:connect(function()
		if HitboxStatus == true and TeamCheck == false then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		elseif HitboxStatus == true and TeamCheck == true then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if game:GetService('Players').LocalPlayer.Team ~= v.Team then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		else
		    for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
						v.Character.HumanoidRootPart.Transparency = 1
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
						v.Character.HumanoidRootPart.Material = "Plastic"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		end
	end)
end)
HomeTab:Button("Aimbot", function(value)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/aimbot", true))()
end)
HomeTab:Toggle("Aimbot v2 Work", function(Value)
    aimbotEnabled = Value
         if aimbotEnabled then
             aimAtTarget()
         end
 end)
HomeTab:Button("Aimbot v3 Key_Q", function(Value)

game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "Heang",
		Text = "Loading . . .",
	}
)
wait(2)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "Done",
		Text = "Done.....",
	}
)
wait(5)
game.StarterGui:SetCore(
	"SendNotification",
	{
		Title = "Aimbot V3",
		Text = "Control = Q",
	}
)
wait(3)



local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local aimSpeed = 0.1 -- Adjust this value for responsiveness
local isAimAssistEnabled = false
local predictionFactor = 5.4 -- Adjust this value for prediction accuracy
local currentTarget = nil
local smoothingFactor = 0.02 -- Adjust this value for smoother camera movement

local function predictTargetPosition(target, deltaTime)
    local targetPosition = target.UpperTorso.Position
    local targetVelocity = target:FindFirstChild("Humanoid") and target.HumanoidRootPart.Velocity or Vector3.new()

    local predictedPosition = targetPosition + targetVelocity * predictionFactor * deltaTime
    return predictedPosition
end

local function aimAtTarget()
    if currentTarget and currentTarget.Parent then
        local predictedPosition = predictTargetPosition(currentTarget, runService.RenderStepped:Wait())
        local lookVector = (predictedPosition - camera.CFrame.Position).Unit

        -- Smooth the camera movement
        local smoothedLookVector = (1 - smoothingFactor) * lookVector + smoothingFactor * (camera.CFrame.LookVector)

        local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + aimSpeed * smoothedLookVector)
        camera.CFrame = newCFrame
    else
        currentTarget = nil
        isAimAssistEnabled = false
    end
end

local function findClosestPlayerToMouse()
    local mousePos = userInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, object in pairs(game.Players:GetPlayers()) do
        if object ~= player and object.Character and object.Character:FindFirstChild("Humanoid") and object.Character:FindFirstChild("UpperTorso") then
            local targetScreenPos, onScreen = camera:WorldToScreenPoint(object.Character.UpperTorso.Position)

            if onScreen then
                local distance = (Vector2.new(targetScreenPos.X, targetScreenPos.Y) - mousePos).Magnitude

                if distance < shortestDistance then
                    closestPlayer = object.Character
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function onKeyPress(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Q then
            isAimAssistEnabled = not isAimAssistEnabled
            if isAimAssistEnabled then
                currentTarget = findClosestPlayerToMouse()
            else
                currentTarget = nil
            end
            print("Aim Assist Toggled:", isAimAssistEnabled)
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        if currentTarget == character then
            currentTarget = nil
        end
    end)
end

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    onKeyPress(input, gameProcessedEvent)
end)

player.CharacterAdded:Connect(onCharacterAdded)

runService.RenderStepped:Connect(function(deltaTime)
    if isAimAssistEnabled then
        aimAtTarget()
    end
end)
 end)
HomeTab:Toggle("Wall check", function(Value)
    wallCheckEnabled = Value
 end)

HomeTab:TextBox("Hitbox Size", function(value)
    getgenv().HitboxSize = value
end)

HomeTab:TextBox("Hitbox Transparency", function(number)
    getgenv().HitboxTransparency = number
end)
HomeTab:Toggle("Team Check", function(state)
    getgenv().TeamCheck = state
end)

HomeTab:Keybind("Toggle UI", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)
HomeTab:Keybind("Heal", Enum.KeyCode.G, function()
    game.Players.LocalPlayer.Character.Humanoid.Health = (100)
end)
HomeTab:TextBox("Health", function(number)
    game.Players.LocalPlayer.Character.Humanoid.Health = (number)
end)
PlayerTab:TextBox("WalkSpeed", function(value)
    getgenv().Walkspeed = value
    pcall(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

PlayerTab:Toggle("Loop WalkSpeed", function(state)
    getgenv().loopW = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if loopW == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
            end)
        end
    end)
end)

PlayerTab:TextBox("JumpPower", function(value)
    getgenv().Jumppower = value
    pcall(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

PlayerTab:Toggle("Loop JumpPower", function(state)
    getgenv().loopJ = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if loopJ == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Jumppower
            end)
        end
    end)
end)

PlayerTab:Button("double Jump", function(state)
    local UserInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer

local character
local humanoid
local canDoubleJump = false
local hasDoubleJumped = false
local oldPower
local TIME_BETWEEN_JUMPS = 0.1 
-- The time before you can do another jump
local DOUBLE_JUMP_POWER_MULTIPLIER = 2

 -- The amount of times you can jump in the air 

function onJumpRequest()
if not character or not humanoid or not character:IsDescendantOf(workspace) or humanoid:GetState() == Enum.HumanoidStateType.Dead then
return
end

 if canDoubleJump and not hasDoubleJumped then
hasDoubleJumped = true
humanoid.JumpPower = oldPower * DOUBLE_JUMP_POWER_MULTIPLIER
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end

local function characterAdded(newCharacter)
character = newCharacter
humanoid = newCharacter:WaitForChild("Humanoid")
hasDoubleJumped = false
canDoubleJump = false
oldPower = humanoid.JumpPower

humanoid.StateChanged:connect(function(old, new)
if new == Enum.HumanoidStateType.Landed then
canDoubleJump = false
hasDoubleJumped = false
humanoid.JumpPower = oldPower
elseif new == Enum.HumanoidStateType.Freefall then
wait(TIME_BETWEEN_JUMPS)
canDoubleJump = true
end
end)
end

if localPlayer.Character then
characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)
UserInputService.JumpRequest:connect(onJumpRequest)
end)

PlayerTab:TextBox("TP Speed", function(value)
getgenv().TPSpeed = value
end)

PlayerTab:Toggle("TP Walk", function(s)
getgenv().TPWalk = s
local hb = game:GetService("RunService").Heartbeat
local player = game:GetService("Players")
local lplr = player.LocalPlayer
local chr = lplr.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
while getgenv().TPWalk and hb:Wait() and chr and hum and hum.Parent do
  if hum.MoveDirection.Magnitude > 0 then
    if getgenv().TPSpeed and isNumber(getgenv().TPSpeed) then
      chr:TranslateBy(hum.MoveDirection * tonumber(getgenv().TPSpeed))
    else
      chr:TranslateBy(hum.MoveDirection)
    end
  end
end
end)

PlayerTab:Slider("Fov", game.Workspace.CurrentCamera.FieldOfView,120, function(v)
     game.Workspace.CurrentCamera.FieldOfView = v
end)

PlayerTab:Toggle("Infinite Jump", function(s)
getgenv().InfJ = s
    game:GetService("UserInputService").JumpRequest:connect(function()
        if InfJ == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
end)
PlayerTab:Button("NoClip", function(s)
    local Noclip = nil
local Clip = nil

function noclip()
	Clip = false
	local function Nocl()
		if Clip == false and game.Players.LocalPlayer.Character ~= nil then
			for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
					v.CanCollide = false
				end
			end
		end
		wait(0.21) -- basic optimization
	end
	Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end
end)
PlayerTab:Button("Fly Gui", function(s)
    local main = Instance.new("ScreenGui")

    local Frame = Instance.new("Frame")
    
    local up = Instance.new("TextButton")
    
    local down = Instance.new("TextButton")
    
    local onof = Instance.new("TextButton")
    
    local TextLabel = Instance.new("TextLabel")
    
    local plus = Instance.new("TextButton")
    
    local speed = Instance.new("TextLabel")
    
    local mine = Instance.new("TextButton")
    
    local closebutton = Instance.new("TextButton")
    
    local mini = Instance.new("TextButton")
    
    local mini2 = Instance.new("TextButton")
    
     
    
    main.Name = "main"
    
    main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    main.ResetOnSpawn = false
    
     
    
    Frame.Parent = main
    
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    
    Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
    
    Frame.Size = UDim2.new(0, 190, 0, 57)
    
     
    
    up.Name = "up"
    
    up.Parent = Frame
    
    up.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    up.Size = UDim2.new(0, 44, 0, 28)
    
    up.Font = Enum.Font.SourceSans
    
    up.Text = "↑"
    
    up.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    up.TextSize = 14.000
    
     
    
    down.Name = "down"
    
    down.Parent = Frame
    
    down.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    down.Position = UDim2.new(0, 0, 0.491228074, 0)
    
    down.Size = UDim2.new(0, 44, 0, 28)
    
    down.Font = Enum.Font.SourceSans
    
    down.Text = "↓"
    
    down.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    down.TextSize = 14.000
    
     
    
    onof.Name = "onof"
    
    onof.Parent = Frame
    
    onof.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
    
    onof.Size = UDim2.new(0, 56, 0, 28)
    
    onof.Font = Enum.Font.Michroma
    
    onof.Text = "FLY"
    
    onof.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    onof.TextSize = 14.000
    
     
    
    TextLabel.Parent = Frame
    
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
    
    TextLabel.Size = UDim2.new(0, 100, 0, 28)
    
    TextLabel.Font = Enum.Font.Michroma
    
    TextLabel.Text = "Fly gui modded"
    
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    TextLabel.TextScaled = true
    
    TextLabel.TextSize = 14.000
    
    TextLabel.TextWrapped = true
    
     
    
    plus.Name = "plus"
    
    plus.Parent = Frame
    
    plus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    plus.Position = UDim2.new(0.231578946, 0, 0, 0)
    
    plus.Size = UDim2.new(0, 45, 0, 28)
    
    plus.Font = Enum.Font.SourceSans
    
    plus.Text = "+"
    
    plus.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    plus.TextScaled = true
    
    plus.TextSize = 14.000
    
    plus.TextWrapped = true
    
     
    
    speed.Name = "speed"
    
    speed.Parent = Frame
    
    speed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
    
    speed.Size = UDim2.new(0, 44, 0, 28)
    
    speed.Font = Enum.Font.SourceSans
    
    speed.Text = "1"
    
    speed.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    speed.TextScaled = true
    
    speed.TextSize = 14.000
    
    speed.TextWrapped = true
    
    mine.Name = "mine"
    
    mine.Parent = Frame
    
    mine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
    
    mine.Size = UDim2.new(0, 45, 0, 29)
    
    mine.Font = Enum.Font.SourceSans
    
    mine.Text = "-"
    
    mine.TextColor3 = Color3.fromRGB(0, 0, 0)
    
    mine.TextScaled = true
    
    mine.TextSize = 14.000
    
    mine.TextWrapped = true
    
     
    
    closebutton.Name = "Close"
    
    closebutton.Parent = main.Frame
    
    closebutton.BackgroundColor3 = Color3.fromRGB(255, 5, 5)
    
    closebutton.Font = "Michroma"
    
    closebutton.Size = UDim2.new(0, 45, 0, 28)
    
    closebutton.Text = "x"
    
    closebutton.TextSize = 30
    
    closebutton.Position = UDim2.new(0, 0, -1, 27)
    
     
    
    mini.Name = "minimize"
    
    mini.Parent = main.Frame
    
    mini.BackgroundColor3 = Color3.fromRGB(117, 117, 117)
    
    mini.Font = "Michroma"
    
    mini.Size = UDim2.new(0, 45, 0, 28)
    
    mini.Text = "-"
    
    mini.TextSize = 40
    
    mini.Position = UDim2.new(0, 44, -1, 27)
    
     
    
    mini2.Name = "minimize2"
    
    mini2.Parent = main.Frame
    
    mini2.BackgroundColor3 = Color3.fromRGB(117, 117, 117)
    
    mini2.Font = "SourceSans"
    
    mini2.Size = UDim2.new(0, 45, 0, 28)
    
    mini2.Text = "+"
    
    mini2.TextSize = 40
    
    mini2.Position = UDim2.new(0, 44, -1, 57)
    
    mini2.Visible = false
    
     
    
    speeds = 1
    
     
    
    local speaker = game:GetService("Players").LocalPlayer
    
     
    
    local chr = game.Players.LocalPlayer.Character
    
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    
     
    
    nowe = false
    
     
    
    game:GetService("StarterGui"):SetCore("SendNotification", { 
    
     Title = "FLY GUI";
    
     Text = "Fly gui";
    
     Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
    
    Duration = 5;
    
     
    
    Frame.Active = true -- main = gui
    
    Frame.Draggable = true
    
     
    
    onof.MouseButton1Down:connect(function()
    
     
    
     if nowe == true then
    
      nowe = false
    
     
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
    
      speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    
     else 
    
      nowe = true
    
     
    
     
    
     
    
      for i = 1, speeds do
    
       spawn(function()
    
     
    
        local hb = game:GetService("RunService").Heartbeat 
    
     
    
     
    
        tpwalking = true
    
        local chr = game.Players.LocalPlayer.Character
    
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    
        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
    
         if hum.MoveDirection.Magnitude > 0 then
    
          chr:TranslateBy(hum.MoveDirection)
    
         end
    
        end
    
     
    
       end)
    
      end
    
      game.Players.LocalPlayer.Character.Animate.Disabled = true
    
      local Char = game.Players.LocalPlayer.Character
    
      local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    
     
    
      for i,v in next, Hum:GetPlayingAnimationTracks() do
    
       v:AdjustSpeed(0)
    
      end
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
    
      speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
    
      speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    
     end
    
     
    
     
    
     
    
     
    
     if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
    
     
    
     
    
     
    
      local plr = game.Players.LocalPlayer
    
      local torso = plr.Character.Torso
    
      local flying = true
    
      local deb = true
    
      local ctrl = {f = 0, b = 0, l = 0, r = 0}
    
      local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    
      local maxspeed = 50
    
      local speed = 0
    
     
    
     
    
      local bg = Instance.new("BodyGyro", torso)
    
      bg.P = 9e4
    
      bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    
      bg.cframe = torso.CFrame
    
      local bv = Instance.new("BodyVelocity", torso)
    
      bv.velocity = Vector3.new(0,0.1,0)
    
      bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
      if nowe == true then
    
       plr.Character.Humanoid.PlatformStand = true
    
      end
    
      while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
    
       game:GetService("RunService").RenderStepped:Wait()
    
     
    
       if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
    
        speed = speed+.5+(speed/maxspeed)
    
        if speed > maxspeed then
    
         speed = maxspeed
    
        end
    
       elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
    
        speed = speed-1
    
        if speed < 0 then
    
         speed = 0
    
        end
    
       end
    
       if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    
        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    
        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
    
       elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    
        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    
       else
    
        bv.velocity = Vector3.new(0,0,0)
    
       end
    
       -- game.Players.LocalPlayer.Character.Animate.Disabled = true
    
       bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
    
      end
    
      ctrl = {f = 0, b = 0, l = 0, r = 0}
    
      lastctrl = {f = 0, b = 0, l = 0, r = 0}
    
      speed = 0
    
      bg:Destroy()
    
      bv:Destroy()
    
      plr.Character.Humanoid.PlatformStand = false
    
      game.Players.LocalPlayer.Character.Animate.Disabled = false
    
      tpwalking = false
    
     
    
     
    
     
    
     
    
     else
    
      local plr = game.Players.LocalPlayer
    
      local UpperTorso = plr.Character.UpperTorso
    
      local flying = true
    
      local deb = true
    
      local ctrl = {f = 0, b = 0, l = 0, r = 0}
    
      local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    
      local maxspeed = 50
    
      local speed = 0
    
     
    
     
    
      local bg = Instance.new("BodyGyro", UpperTorso)
    
      bg.P = 9e4
    
      bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    
      bg.cframe = UpperTorso.CFrame
    
      local bv = Instance.new("BodyVelocity", UpperTorso)
    
      bv.velocity = Vector3.new(0,0.1,0)
    
      bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
      if nowe == true then
    
       plr.Character.Humanoid.PlatformStand = true
    
      end
    
      while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
    
       wait()
    
     
    
       if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
    
        speed = speed+.5+(speed/maxspeed)
    
        if speed > maxspeed then
    
         speed = maxspeed
    
        end
    
       elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
    
        speed = speed-1
    
        if speed < 0 then
    
         speed = 0
    
        end
    
       end
    
       if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    
        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    
        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
    
       elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    
        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
    
       else
    
        bv.velocity = Vector3.new(0,0,0)
    
       end
    
     
    
       bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
    
      end
    
      ctrl = {f = 0, b = 0, l = 0, r = 0}
    
      lastctrl = {f = 0, b = 0, l = 0, r = 0}
    
      speed = 0
    
      bg:Destroy()
    
      bv:Destroy()
    
      plr.Character.Humanoid.PlatformStand = false
    
      game.Players.LocalPlayer.Character.Animate.Disabled = false
    
      tpwalking = false
    
     
    
     
    
     
    
     end
    
     
    
     
    
     
    
     
    
     
    
    end)
    
     
    
    local tis
    
     
    
    up.MouseButton1Down:connect(function()
    
     tis = up.MouseEnter:connect(function()
    
      while tis do
    
       wait()
    
       game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
    
      end
    
     end)
    
    end)
    
     
    
    up.MouseLeave:connect(function()
    
     if tis then
    
      tis:Disconnect()
    
      tis = nil
    
     end
    
    end)
    
     
    
    local dis
    
     
    
    down.MouseButton1Down:connect(function()
    
     dis = down.MouseEnter:connect(function()
    
      while dis do
    
       wait()
    
       game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
    
      end
    
     end)
    
    end)
    
     
    
    down.MouseLeave:connect(function()
    
     if dis then
    
      dis:Disconnect()
    
      dis = nil
    
     end
    
    end)
    
     
    
     
    
    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    
     wait(0.7)
    
     game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    
     game.Players.LocalPlayer.Character.Animate.Disabled = false
    
     
    
    end)
    
     
    
     
    
    plus.MouseButton1Down:connect(function()
    
     speeds = speeds + 1
    
     speed.Text = speeds
    
     if nowe == true then
    
     
    
     
    
      tpwalking = false
    
      for i = 1, speeds do
    
       spawn(function()
    
     
    
        local hb = game:GetService("RunService").Heartbeat 
    
     
    
     
    
        tpwalking = true
    
        local chr = game.Players.LocalPlayer.Character
    
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    
        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
    
         if hum.MoveDirection.Magnitude > 0 then
    
          chr:TranslateBy(hum.MoveDirection)
    
         end
    
        end
    
     
    
       end)
    
      end
    
     end
    
    end)
    
    mine.MouseButton1Down:connect(function()
    
     if speeds == 1 then
    
      speed.Text = '-1 speed fly bruh'
    
      wait(1)
    
      speed.Text = speeds
    
     else
    
      speeds = speeds - 1
    
      speed.Text = speeds
    
      if nowe == true then
    
       tpwalking = false
    
       for i = 1, speeds do
    
        spawn(function()
    
     
    
         local hb = game:GetService("RunService").Heartbeat 
    
     
    
     
    
         tpwalking = true
    
         local chr = game.Players.LocalPlayer.Character
    
         local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    
         while tpwalking and hb:Wait() and chr and hum and hum.Parent do
    
          if hum.MoveDirection.Magnitude > 0 then
    
           chr:TranslateBy(hum.MoveDirection)
    
          end
    
         end
    
     
    
        end)
    
       end
    
      end
    
     end
    
    end)
    
     
    
    closebutton.MouseButton1Click:Connect(function()
    
     main:Destroy()
    
    end)
    
     
    
    mini.MouseButton1Click:Connect(function()
    
     up.Visible = false
    
     down.Visible = false
    
     onof.Visible = false
    
     plus.Visible = false
    
     speed.Visible = false
    
     mine.Visible = false
    
     mini.Visible = false
    
     mini2.Visible = true
    
     main.Frame.BackgroundTransparency = 1
    
     closebutton.Position = UDim2.new(0, 0, -1, 57)
    
    end)
    
     
    
    mini2.MouseButton1Click:Connect(function()
    
     up.Visible = true
    
     down.Visible = true
    
     onof.Visible = true
    
     plus.Visible = true
    
     speed.Visible = true
    
     mine.Visible = true
    
     mini.Visible = true
    
     mini2.Visible = false
    
     main.Frame.BackgroundTransparency = 0 
    
     closebutton.Position = UDim2.new(0, 0, -1, 27)
    
    end)
    
    
end)
PlayerTab:Button("Resolution", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Resolution",true))()
end)
PlayerTab:Button("Resolution Clear", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Resolution%20Clear",true))()
end)
PlayerTab:Button("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

VisualTab:InfoLabel("Wait 3-10 seconds")

VisualTab:Toggle("Character Highlight", function(state)
getgenv().enabled = state --Toggle on/off
getgenv().filluseteamcolor = true --Toggle fill color using player team color on/off
getgenv().outlineuseteamcolor = true --Toggle outline color using player team color on/off
getgenv().fillcolor = Color3.new(0, 0, 0) --Change fill color, no need to edit if using team color
getgenv().outlinecolor = Color3.new(1, 1, 1) --Change outline color, no need to edit if using team color
getgenv().filltrans = 0.5 --Change fill transparency
getgenv().outlinetrans = 0.5 --Change outline transparency

loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/Highlight-ESP.lua"))()
end)

VisualTab:Button("Fullbright", function(state)
	    local Lighting = game:GetService("Lighting")
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)
VisualTab:Button("Health + Name         - Inject", function(state)
    wait(3)
-- Settings
local Settings = {
    Team_Check = false,
    Team_Color = true,
    Autothickness = true
}

--Locals
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Locals
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local Black = Color3.fromRGB(0, 0, 0)

local function Rainbow(lib, delay)
    for hue = 0, 1, 1/30 do
        local color = Color3.fromHSV(hue, 0.6, 1)
        Colorize(lib, color)
        wait(delay)
    end
    Rainbow(lib)
end
--Main Draw Function
local function Main(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local R15
    if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        R15 = true
    else 
        R15 = false
    end
    coroutine.wrap(Rainbow)(Library, 0.15)
    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)
    --Updater Loop
    local function Updater()
        local c 
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    if Settings.Team_Check then
                        if plr.TeamColor == Player.TeamColor then
                            Colorize(Library, Color3.fromRGB(0, 255, 0))
                        else 
                            Colorize(Library, Color3.fromRGB(255, 0, 0))
                        end
                    end

                    if Settings.Team_Color then
                        Colorize(Library, plr.TeamColor.Color)
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    Vis(Library, true)

                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1/distance*100, 1, 4) --0.1 is min thickness, 6 is max
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else 
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else 
                    Vis(Library, false)
                end
            else 
                Vis(Library, false)
                if game:GetService("Players"):FindFirstChild(plr.Name) == nil then
                    for i, v in pairs(Library) do
                        v:Remove()
                        oripart:Destroy()
                    end
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)

local function ApplyESP(v)
   if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
       v.Character.Humanoid.NameDisplayDistance = 9e9
       v.Character.Humanoid.NameOcclusion = "NoOcclusion"
       v.Character.Humanoid.HealthDisplayDistance = 9e9
       v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
       v.Character.Humanoid.Health = v.Character.Humanoid.Health -- triggers changed
   end
end
for i,v in pairs(game.Players:GetPlayers()) do
   ApplyESP(v)
   v.CharacterAdded:Connect(function()
       task.wait(0.33)
       ApplyESP(v)
   end)
end

game.Players.PlayerAdded:Connect(function(v)
   ApplyESP(v)
   v.CharacterAdded:Connect(function()
       task.wait(0.33)
       ApplyESP(v)
   end)
end)
end)
VisualTab:Button("Tracer                - Inject", function(state)
    local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint

_G.TeamCheck = false -- Use True or False to toggle TeamCheck

for i,v in pairs(game.Players:GetChildren()) do
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(121, 121, 121)
    Tracer.Thickness = 1
    Tracer.Transparency = 1

    function lineesp()
        game:GetService("RunService").RenderStepped:Connect(function()
            if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
                local Vector, OnScreen = camera:worldToViewportPoint(v.Character.RightFoot.Position)

                if OnScreen then
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)

                    if _G.TeamCheck and v.TeamColor == lplr.TeamColor then
                        --//Teammates
                        Tracer.Visible = false
                    else
                        --//Enemies
                        Tracer.Visible = true
                    end
                else
                    Tracer.Visible = false
                end
            else
                Tracer.Visible = false
            end
        end)
    end
    coroutine.wrap(lineesp)()
end

game.Players.PlayerAdded:Connect(function(v)
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(121, 121, 121)
    Tracer.Thickness = 1
    Tracer.Transparency = 1

    function lineesp()
        game:GetService("RunService").RenderStepped:Connect(function()
            if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
                local Vector, OnScreen = camera:worldToViewportPoint(v.Character.RightFoot.Position)

                if OnScreen then
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)

                    if _G.TeamCheck and v.TeamColor == lplr.TeamColor then
                        --//Teammates
                        Tracer.Visible = false
                    else
                        --//Enemies
                        Tracer.Visible = true
                    end
                else
                    Tracer.Visible = false
                end
            else
                Tracer.Visible = false
            end
        end)
    end
    coroutine.wrap(lineesp)()
end)
    end)

VisualTab:Button("show Keyboard", function(state)
    getgenv().enabled = toggle --Toggle on/off
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Keyboard"))()
    end)


if game.PlaceId == 3082002798 then
    local GamesTab = Window:Tab("Games","rbxassetid://15426471035")
	GamesTab:InfoLabel("Game: "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
	GamesTab:Button("No Cooldown", function()
	    for i, v in pairs(game:GetService('ReplicatedStorage')['Shared_Modules'].Tools:GetDescendants()) do
		    if v:IsA('ModuleScript') then
			    local Module = require(v)
				Module.DEBOUNCE = 0
			end
		end
	end)
end
ToolTab:Button("TP TOOL", function()
    mouse = game.Players.LocalPlayer:GetMouse()
    tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "TP"
    tool.Activated:connect(function()
    local pos = mouse.Hit+Vector3.new(0,2.5,0)
    pos = CFrame.new(pos.X,pos.Y,pos.Z)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end)
    tool.Parent = game.Players.LocalPlayer.Backpack
end)

ScriptTab:Button("infiniteyield", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
end)
ScriptTab:Button("Esp menu", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/ESP%20menu%20work.lua'),true))()
end)
ScriptTab:Button("FPS Boost", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/FPS'),true))()
end)
ScriptTab:Button("RTX ON", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/RTX%20ON"))()
end)
ScriptTab:Button("Free cam", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/CameraSpy/main/Script", true))()
end)
ScriptTab:Button("Freecam V2 Key = F5", function()
    function sandbox(var,func)
        local env = getfenv(func)
        local newenv = setmetatable({},{
        __index = function(self,k)
        if k=="script" then
        return var
        else
        return env[k]
        end
        end,
        })
        setfenv(func,newenv)
        return func
        end
        cors = {}
        mas = Instance.new("Model",game:GetService("Lighting"))
        LocalScript0 = Instance.new("LocalScript")
        LocalScript0.Name = "FreeCamera"
        LocalScript0.Parent = mas
        table.insert(cors,sandbox(LocalScript0,function()
        -----------------------------------------------------------------------
        -- Freecam
        -- Cinematic free camera for spectating and video production.
        ------------------------------------------------------------------------
         
        local pi    = math.pi
        local abs   = math.abs
        local clamp = math.clamp
        local exp   = math.exp
        local rad   = math.rad
        local sign  = math.sign
        local sqrt  = math.sqrt
        local tan   = math.tan
         
        local ContextActionService = game:GetService("ContextActionService")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local StarterGui = game:GetService("StarterGui")
        local UserInputService = game:GetService("UserInputService")
         
        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer = Players.LocalPlayer
        end
         
        local Camera = workspace.CurrentCamera
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local newCamera = workspace.CurrentCamera
        if newCamera then
        Camera = newCamera
        end
        end)
         
        ------------------------------------------------------------------------
         
        local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
        local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
        local FREECAM_MACRO_KB = {Enum.KeyCode.F5}
         
        local NAV_GAIN = Vector3.new(1, 1, 1)*64
        local PAN_GAIN = Vector2.new(0.75, 1)*8
        local FOV_GAIN = 300
         
        local PITCH_LIMIT = rad(90)
         
        local VEL_STIFFNESS = 1.5
        local PAN_STIFFNESS = 1.0
        local FOV_STIFFNESS = 4.0
         
        ------------------------------------------------------------------------
         
        local Spring = {} do
        Spring.__index = Spring
         
        function Spring.new(freq, pos)
        local self = setmetatable({}, Spring)
        self.f = freq
        self.p = pos
        self.v = pos*0
        return self
        end
         
        function Spring:Update(dt, goal)
        local f = self.f*2*pi
        local p0 = self.p
        local v0 = self.v
         
        local offset = goal - p0
        local decay = exp(-f*dt)
         
        local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
        local v1 = (f*dt*(offset*f - v0) + v0)*decay
         
        self.p = p1
        self.v = v1
         
        return p1
        end
         
        function Spring:Reset(pos)
        self.p = pos
        self.v = pos*0
        end
        end
         
        ------------------------------------------------------------------------
         
        local cameraPos = Vector3.new()
        local cameraRot = Vector2.new()
        local cameraFov = 0
         
        local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
        local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
        local fovSpring = Spring.new(FOV_STIFFNESS, 0)
         
        ------------------------------------------------------------------------
         
        local Input = {} do
        local thumbstickCurve do
        local K_CURVATURE = 2.0
        local K_DEADZONE = 0.15
         
        local function fCurve(x)
        return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
        end
         
        local function fDeadzone(x)
        return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
        end
         
        function thumbstickCurve(x)
        return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
        end
        end
         
        local gamepad = {
        ButtonX = 0,
        ButtonY = 0,
        DPadDown = 0,
        DPadUp = 0,
        ButtonL2 = 0,
        ButtonR2 = 0,
        Thumbstick1 = Vector2.new(),
        Thumbstick2 = Vector2.new(),
        }
         
        local keyboard = {
        W = 0,
        A = 0,
        S = 0,
        D = 0,
        E = 0,
        Q = 0,
        U = 0,
        H = 0,
        J = 0,
        K = 0,
        I = 0,
        Y = 0,
        Up = 0,
        Down = 0,
        LeftShift = 0,
        RightShift = 0,
        }
         
        local mouse = {
        Delta = Vector2.new(),
        MouseWheel = 0,
        }
         
        local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
        local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
        local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
        local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
        local FOV_WHEEL_SPEED    = 1.0
        local FOV_GAMEPAD_SPEED  = 0.25
        local NAV_ADJ_SPEED      = 0.75
        local NAV_SHIFT_MUL      = 0.25
         
        local navSpeed = 1
         
        function Input.Vel(dt)
        navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)
         
        local kGamepad = Vector3.new(
        thumbstickCurve(gamepad.Thumbstick1.x),
        thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
        thumbstickCurve(-gamepad.Thumbstick1.y)
        )*NAV_GAMEPAD_SPEED
         
        local kKeyboard = Vector3.new(
        keyboard.D - keyboard.A + keyboard.K - keyboard.H,
        keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
        keyboard.S - keyboard.W + keyboard.J - keyboard.U
        )*NAV_KEYBOARD_SPEED
         
        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
         
        return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
        end
         
        function Input.Pan(dt)
        local kGamepad = Vector2.new(
        thumbstickCurve(gamepad.Thumbstick2.y),
        thumbstickCurve(-gamepad.Thumbstick2.x)
        )*PAN_GAMEPAD_SPEED
        local kMouse = mouse.Delta*PAN_MOUSE_SPEED
        mouse.Delta = Vector2.new()
        return kGamepad + kMouse
        end
         
        function Input.Fov(dt)
        local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
        local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
        mouse.MouseWheel = 0
        return kGamepad + kMouse
        end
         
        do
        local function Keypress(action, state, input)
        keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
        return Enum.ContextActionResult.Sink
        end
         
        local function GpButton(action, state, input)
        gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
        return Enum.ContextActionResult.Sink
        end
         
        local function MousePan(action, state, input)
        local delta = input.Delta
        mouse.Delta = Vector2.new(-delta.y, -delta.x)
        return Enum.ContextActionResult.Sink
        end
         
        local function Thumb(action, state, input)
        gamepad[input.KeyCode.Name] = input.Position
        return Enum.ContextActionResult.Sink
        end
         
        local function Trigger(action, state, input)
        gamepad[input.KeyCode.Name] = input.Position.z
        return Enum.ContextActionResult.Sink
        end
         
        local function MouseWheel(action, state, input)
        mouse[input.UserInputType.Name] = -input.Position.z
        return Enum.ContextActionResult.Sink
        end
         
        local function Zero(t)
        for k, v in pairs(t) do
        t[k] = v*0
        end
        end
         
        function Input.StartCapture()
        ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
        Enum.KeyCode.W, Enum.KeyCode.U,
        Enum.KeyCode.A, Enum.KeyCode.H,
        Enum.KeyCode.S, Enum.KeyCode.J,
        Enum.KeyCode.D, Enum.KeyCode.K,
        Enum.KeyCode.E, Enum.KeyCode.I,
        Enum.KeyCode.Q, Enum.KeyCode.Y,
        Enum.KeyCode.Up, Enum.KeyCode.Down
        )
        ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
        ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
        ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
        ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
        ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
        end
         
        function Input.StopCapture()
        navSpeed = 1
        Zero(gamepad)
        Zero(keyboard)
        Zero(mouse)
        ContextActionService:UnbindAction("FreecamKeyboard")
        ContextActionService:UnbindAction("FreecamMousePan")
        ContextActionService:UnbindAction("FreecamMouseWheel")
        ContextActionService:UnbindAction("FreecamGamepadButton")
        ContextActionService:UnbindAction("FreecamGamepadTrigger")
        ContextActionService:UnbindAction("FreecamGamepadThumbstick")
        end
        end
        end
         
        local function GetFocusDistance(cameraFrame)
        local znear = 0.1
        local viewport = Camera.ViewportSize
        local projy = 2*tan(cameraFov/2)
        local projx = viewport.x/viewport.y*projy
        local fx = cameraFrame.rightVector
        local fy = cameraFrame.upVector
        local fz = cameraFrame.lookVector
         
        local minVect = Vector3.new()
        local minDist = 512
         
        for x = 0, 1, 0.5 do
        for y = 0, 1, 0.5 do
        local cx = (x - 0.5)*projx
        local cy = (y - 0.5)*projy
        local offset = fx*cx - fy*cy + fz
        local origin = cameraFrame.p + offset*znear
        local part, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
        local dist = (hit - origin).magnitude
        if minDist > dist then
        minDist = dist
        minVect = offset.unit
        end
        end
        end
         
        return fz:Dot(minVect)*minDist
        end
         
        ------------------------------------------------------------------------
         
        local function StepFreecam(dt)
        local vel = velSpring:Update(dt, Input.Vel(dt))
        local pan = panSpring:Update(dt, Input.Pan(dt))
        local fov = fovSpring:Update(dt, Input.Fov(dt))
         
        local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
         
        cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
        cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
        cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))
         
        local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
        cameraPos = cameraCFrame.p
         
        Camera.CFrame = cameraCFrame
        Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
        Camera.FieldOfView = cameraFov
        end
         
        ------------------------------------------------------------------------
         
        local PlayerState = {} do
        local mouseIconEnabled
        local cameraSubject
        local cameraType
        local cameraFocus
        local cameraCFrame
        local cameraFieldOfView
        local screenGuis = {}
        local coreGuis = {
        Backpack = true,
        Chat = true,
        Health = true,
        PlayerList = true,
        }
        local setCores = {
        BadgesNotificationsActive = true,
        PointsNotificationsActive = true,
        }
         
        -- Save state and set up for freecam
        function PlayerState.Push()
        for name in pairs(coreGuis) do
        coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
        end
        for name in pairs(setCores) do
        setCores[name] = StarterGui:GetCore(name)
        StarterGui:SetCore(name, false)
        end
        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playergui then
        for _, gui in pairs(playergui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
        screenGuis[#screenGuis + 1] = gui
        gui.Enabled = false
        end
        end
        end
         
        cameraFieldOfView = Camera.FieldOfView
        Camera.FieldOfView = 70
         
        cameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Custom
         
        cameraSubject = Camera.CameraSubject
        Camera.CameraSubject = nil
         
        cameraCFrame = Camera.CFrame
        cameraFocus = Camera.Focus
         
        mouseIconEnabled = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = false
         
        mouseBehavior = UserInputService.MouseBehavior
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
         
        -- Restore state
        function PlayerState.Pop()
        for name, isEnabled in pairs(coreGuis) do
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
        end
        for name, isEnabled in pairs(setCores) do
        StarterGui:SetCore(name, isEnabled)
        end
        for _, gui in pairs(screenGuis) do
        if gui.Parent then
        gui.Enabled = true
        end
        end
         
        Camera.FieldOfView = cameraFieldOfView
        cameraFieldOfView = nil
         
        Camera.CameraType = cameraType
        cameraType = nil
         
        Camera.CameraSubject = cameraSubject
        cameraSubject = nil
         
        Camera.CFrame = cameraCFrame
        cameraCFrame = nil
         
        Camera.Focus = cameraFocus
        cameraFocus = nil
         
        UserInputService.MouseIconEnabled = mouseIconEnabled
        mouseIconEnabled = nil
         
        UserInputService.MouseBehavior = mouseBehavior
        mouseBehavior = nil
        end
        end
         
        local function StartFreecam()
        local cameraCFrame = Camera.CFrame
        cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
        cameraPos = cameraCFrame.p
        cameraFov = Camera.FieldOfView
         
        velSpring:Reset(Vector3.new())
        panSpring:Reset(Vector2.new())
        fovSpring:Reset(0)
         
        PlayerState.Push()
        RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
        Input.StartCapture()
        end
         
        local function StopFreecam()
        Input.StopCapture()
        RunService:UnbindFromRenderStep("Freecam")
        PlayerState.Pop()
        end
         
        ------------------------------------------------------------------------
         
        do
        local enabled = false
         
        local function ToggleFreecam()
        if enabled then
        StopFreecam()
        else
        StartFreecam()
        end
        enabled = not enabled
        end
         
        local function CheckMacro(macro)
        for i = 1, #macro - 1 do
        if not UserInputService:IsKeyDown(macro[i]) then
        return
        end
        end
        ToggleFreecam()
        end
         
        local function HandleActivationInput(action, state, input)
        if state == Enum.UserInputState.Begin then
        if input.KeyCode == FREECAM_MACRO_KB[#FREECAM_MACRO_KB] then
        CheckMacro(FREECAM_MACRO_KB)
        end
        end
        return Enum.ContextActionResult.Pass
        end
         
        ContextActionService:BindActionAtPriority("FreecamToggle", HandleActivationInput, false, TOGGLE_INPUT_PRIORITY, FREECAM_MACRO_KB[#FREECAM_MACRO_KB])
        end
        end))
        for i,v in pairs(mas:GetChildren()) do
        v.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        pcall(function() v:MakeJoints() end)
        end
        mas:Destroy()
        for i,v in pairs(cors) do
        spawn(function()
        pcall(v)
        end)
        end
end)
ScriptTab:Button("invisible", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/invisible"))()
end)
ScriptTab:Button("CCTV", function()
    local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "",
    Text = "CCTV",
    Icon = "rbxassetid://29819383",
    Duration = 2.5,
})

local FEHATS = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local gsdfgsd = Instance.new("TextLabel")
local biggerhat = Instance.new("TextButton")
local drophats = Instance.new("TextButton")
local admin = Instance.new("TextButton")


FEHATS.Parent = game.CoreGui

main.Name = "main"
main.Parent = FEHATS
main.BackgroundColor3 = Color3.new(0,0,0)
main.BorderSizePixel = 6
main.BorderColor3 = Color3.new(0,0,0)
main.Position = UDim2.new(0.2, 0, 0.1)
main.Size = UDim2.new(0, 141, 0, 194)
main.Active = true
main.Draggable = true

gsdfgsd.Name = ""
gsdfgsd.Parent = main
gsdfgsd.BackgroundColor3 = Color3.fromRGB(450,350,250)
gsdfgsd.BackgroundTransparency = 1.000
gsdfgsd.Position = UDim2.new(0, 0, -0.0309278369, 0)
gsdfgsd.Size = UDim2.new(0, 140, 0, 32)
gsdfgsd.Font = Enum.Font.SourceSansBold
gsdfgsd.Text = "CCTV Camera"
gsdfgsd.TextColor3 = Color3.new(1,1,1)
gsdfgsd.TextSize = 20.000
gsdfgsd.TextWrapped = true

biggerhat.Name = ""
biggerhat.Parent = main
biggerhat.BackgroundColor3 = Color3.fromRGB(1,1,1)
biggerhat.BorderSizePixel = 1
biggerhat.Position = UDim2.new(0, 0, 0.170103088, 0)
biggerhat.Size = UDim2.new(0, 140, 0, 28)
biggerhat.Font = Enum.Font.SourceSansBold
biggerhat.Text = "Set CCTV Camera"
biggerhat.TextColor3 = Color3.fromRGB(450,350,250)
biggerhat.BorderColor3 = Color3.new(1,1,1)
biggerhat.TextSize = 17.000
biggerhat.TextWrapped = true

biggerhat.MouseButton1Click:connect(function()
getgenv().Handle = false
wait(0.1)
workspace:FindFirstChild("CCTV").CFrame = game.Workspace.CurrentCamera.CFrame
workspace:FindFirstChild("CCTV").Camera.CFrame = game.Workspace.CurrentCamera.CFrame
end)

drophats.Name = ""
drophats.Parent = main
drophats.BackgroundColor3 = Color3.fromRGB(1,1,1)
drophats.BorderSizePixel = 1
drophats.Position = UDim2.new(0, 0, 0.427835047, 0)
drophats.Size = UDim2.new(0, 140, 0, 28)
drophats.Font = Enum.Font.SourceSansBold
drophats.Text = "View CCTV Camera"
drophats.TextColor3 = Color3.fromRGB(450,350,250)
drophats.BorderColor3 = Color3.new(1,1,1)
drophats.TextScaled = true
drophats.TextSize = 20.000
drophats.TextWrapped = true

drophats.MouseButton1Click:connect(function()
game.Players.LocalPlayer.Character.Humanoid.Died:connect(function()
local player = game.Players.LocalPlayer
player.CameraMaxZoomDistance = 1000
player.CameraMinZoomDistance = -1
wait()
ScreenGui0:Destroy()
game:GetService("Workspace").CCTV.Transparency = 0
game:GetService("Workspace").CCTV.Camera.Transparency = 0
end)

local player = game.Players.LocalPlayer
player.CameraMaxZoomDistance = 1
player.CameraMinZoomDistance = 100
wait()
game.Workspace.CurrentCamera.CameraSubject = workspace:FindFirstChild("CCTV")
game:GetService("Workspace").CCTV.Transparency = 1
game:GetService("Workspace").CCTV.Camera.Transparency = 1
wait()
local ScreenGui0 = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame1 = Instance.new("Frame")
local Frame2 = Instance.new("Frame")
local Frame3 = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextButton0 = Instance.new("TextLabel")
local TextButton1 = Instance.new("TextLabel")
local TextButton2 = Instance.new("TextLabel")
local TextButton3 = Instance.new("TextLabel")
local TextButton4 = Instance.new("TextLabel")
local TextButton5 = Instance.new("TextLabel")
local TextButton6 = Instance.new("TextButton")
local TextButton7 = Instance.new("TextButton")
local TextButton8 = Instance.new("TextButton")
local TextButton9 = Instance.new("TextButton")
local TextButton10 = Instance.new("TextButton")

ScreenGui0.Parent = game.CoreGui

Frame.Parent = ScreenGui0
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(1,1,1)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0,0,-0.18)
Frame.Size = UDim2.new(1.2,0.2,0.2)
Frame.Active = true
Frame.Draggable = false

Frame1.Parent = ScreenGui0
Frame1.BackgroundColor3 = Color3.new(0,0,0)
Frame1.BorderColor3 = Color3.new(1,1,1)
Frame1.BorderSizePixel = 0
Frame1.Position = UDim2.new(0,0,0.82)
Frame1.Size = UDim2.new(1.2,0.2,0.2)
Frame1.Active = true
Frame1.Draggable = false

Frame2.Parent = ScreenGui0
Frame2.BackgroundColor3 = Color3.new(0,0,0)
Frame2.BorderColor3 = Color3.new(1,1,1)
Frame2.BorderSizePixel = 0
Frame2.Position = UDim2.new(0,0,-0.18)
Frame2.Size = UDim2.new(0.1,0,1)
Frame2.Active = true
Frame2.Draggable = false

Frame3.Parent = ScreenGui0
Frame3.BackgroundColor3 = Color3.new(0,0,0)
Frame3.BorderColor3 = Color3.new(1,1,1)
Frame3.BorderSizePixel = 0
Frame3.Position = UDim2.new(0.83,0,-0.18)
Frame3.Size = UDim2.new(0.2,0,1)
Frame3.Active = true
Frame3.Draggable = false

TextButton.Parent = Frame1
TextButton.BackgroundColor3 = Color3.new(8,0,0)
TextButton.BackgroundTransparency = 0
TextButton.Position = UDim2.new(0.1,0,0.1)
TextButton.TextColor3 = Color3.new(0,0,0)
TextButton.Size = UDim2.new(0.05,0,0.4)
TextButton.Font = Enum.Font.SourceSansLight
TextButton.FontSize = Enum.FontSize.Size14
TextButton.Text = "Exit"
TextButton.TextScaled = true
TextButton.TextSize = 8
TextButton.TextWrapped = true

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
game:GetService("Workspace").CCTV.Transparency = 0
game:GetService("Workspace").CCTV.Camera.Transparency = 0
ScreenGui0:Destroy()
workspace.CurrentCamera.FieldOfView = 70
end)

TextButton.MouseButton1Click:connect(function()
ScreenGui0:Destroy()
local player = game.Players.LocalPlayer
player.CameraMaxZoomDistance = 1000
player.CameraMinZoomDistance = 12
wait()
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
game:GetService("Workspace").CCTV.Transparency = 0
game:GetService("Workspace").CCTV.Camera.Transparency = 0
wait()
local player = game.Players.LocalPlayer
player.CameraMaxZoomDistance = 1000
player.CameraMinZoomDistance = -1
workspace.CurrentCamera.FieldOfView = 70
end)

TextButton0.Parent = Frame3
TextButton0.BackgroundColor3 = Color3.new(0,0,0)
TextButton0.BackgroundTransparency = 1
TextButton0.Position = UDim2.new(0.1,0,0.32)
TextButton0.TextColor3 = Color3.new(1,1,1)
TextButton0.Size = UDim2.new(0.42,0,0.08)
TextButton0.Font = Enum.Font.SourceSansLight
TextButton0.FontSize = Enum.FontSize.Size14
TextButton0.Text = "Fov"
TextButton0.TextScaled = true
TextButton0.TextSize = 8
TextButton0.TextWrapped = true

TextButton1.Parent = Frame3
TextButton1.BackgroundColor3 = Color3.new(0,0,0)
TextButton1.BackgroundTransparency = 1
TextButton1.Position = UDim2.new(0.1,0,0.4)
TextButton1.TextColor3 = Color3.new(1,1,1)
TextButton1.Size = UDim2.new(0.1,0,0.09)
TextButton1.Font = Enum.Font.SourceSansLight
TextButton1.FontSize = Enum.FontSize.Size14
TextButton1.Text = "1"
TextButton1.TextScaled = true
TextButton1.TextSize = 8
TextButton1.TextWrapped = true

TextButton2.Parent = Frame3
TextButton2.BackgroundColor3 = Color3.new(0,0,0)
TextButton2.BackgroundTransparency = 1
TextButton2.Position = UDim2.new(0.1,0,0.5)
TextButton2.TextColor3 = Color3.new(1,1,1)
TextButton2.Size = UDim2.new(0.1,0,0.09)
TextButton2.Font = Enum.Font.SourceSansLight
TextButton2.FontSize = Enum.FontSize.Size14
TextButton2.Text = "2"
TextButton2.TextScaled = true
TextButton2.TextSize = 8
TextButton2.TextWrapped = true

TextButton3.Parent = Frame3
TextButton3.BackgroundColor3 = Color3.new(0,0,0)
TextButton3.BackgroundTransparency = 1
TextButton3.Position = UDim2.new(0.1,0,0.6)
TextButton3.TextColor3 = Color3.new(1,1,1)
TextButton3.Size = UDim2.new(0.1,0,0.09)
TextButton3.Font = Enum.Font.SourceSansLight
TextButton3.FontSize = Enum.FontSize.Size14
TextButton3.Text = "3"
TextButton3.TextScaled = true
TextButton3.TextSize = 8
TextButton3.TextWrapped = true

TextButton4.Parent = Frame3
TextButton4.BackgroundColor3 = Color3.new(0,0,0)
TextButton4.BackgroundTransparency = 1
TextButton4.Position = UDim2.new(0.1,0,0.7)
TextButton4.TextColor3 = Color3.new(1,1,1)
TextButton4.Size = UDim2.new(0.1,0,0.09)
TextButton4.Font = Enum.Font.SourceSansLight
TextButton4.FontSize = Enum.FontSize.Size14
TextButton4.Text = "4"
TextButton4.TextScaled = true
TextButton4.TextSize = 8
TextButton4.TextWrapped = true

TextButton5.Parent = Frame3
TextButton5.BackgroundColor3 = Color3.new(0,0,0)
TextButton5.BackgroundTransparency = 1
TextButton5.Position = UDim2.new(0.1,0,0.8)
TextButton5.TextColor3 = Color3.new(1,1,1)
TextButton5.Size = UDim2.new(0.1,0,0.09)
TextButton5.Font = Enum.Font.SourceSansLight
TextButton5.FontSize = Enum.FontSize.Size14
TextButton5.Text = "5"
TextButton5.TextScaled = true
TextButton5.TextSize = 8
TextButton5.TextWrapped = true

TextButton6.Parent = Frame3
TextButton6.BackgroundColor3 = Color3.new(0,0,0)
TextButton6.BackgroundTransparency = 0
TextButton6.BorderSizePixel = 1
TextButton6.BorderColor3 = Color3.new(1,1,1)
TextButton6.Position = UDim2.new(0.22,0,0.4)
TextButton6.TextColor3 = Color3.new(1,1,1)
TextButton6.Size = UDim2.new(0.2,0,0.09)
TextButton6.Font = Enum.Font.SourceSansLight
TextButton6.FontSize = Enum.FontSize.Size14
TextButton6.Text = ""
TextButton6.TextScaled = true
TextButton6.TextSize = 8
TextButton6.TextWrapped = true

TextButton6.MouseButton1Click:connect(function()
workspace.CurrentCamera.FieldOfView = 70
end)

TextButton7.Parent = Frame3
TextButton7.BackgroundColor3 = Color3.new(0,0,0)
TextButton7.BackgroundTransparency = 0
TextButton7.BorderSizePixel = 1
TextButton7.BorderColor3 = Color3.new(1,1,1)
TextButton7.Position = UDim2.new(0.22,0,0.5)
TextButton7.TextColor3 = Color3.new(1,1,1)
TextButton7.Size = UDim2.new(0.2,0,0.09)
TextButton7.Font = Enum.Font.SourceSansLight
TextButton7.FontSize = Enum.FontSize.Size14
TextButton7.Text = ""
TextButton7.TextScaled = true
TextButton7.TextSize = 8
TextButton7.TextWrapped = true

TextButton7.MouseButton1Click:connect(function()
workspace.CurrentCamera.FieldOfView = 60
end)

TextButton8.Parent = Frame3
TextButton8.BackgroundColor3 = Color3.new(0,0,0)
TextButton8.BackgroundTransparency = 0
TextButton8.BorderSizePixel = 1
TextButton8.BorderColor3 = Color3.new(1,1,1)
TextButton8.Position = UDim2.new(0.22,0,0.6)
TextButton8.TextColor3 = Color3.new(1,1,1)
TextButton8.Size = UDim2.new(0.2,0,0.09)
TextButton8.Font = Enum.Font.SourceSansLight
TextButton8.FontSize = Enum.FontSize.Size14
TextButton8.Text = ""
TextButton8.TextScaled = true
TextButton8.TextSize = 8
TextButton8.TextWrapped = true

TextButton8.MouseButton1Click:connect(function()
workspace.CurrentCamera.FieldOfView = 45
end)

TextButton9.Parent = Frame3
TextButton9.BackgroundColor3 = Color3.new(0,0,0)
TextButton9.BackgroundTransparency = 0
TextButton9.BorderSizePixel = 1
TextButton9.BorderColor3 = Color3.new(1,1,1)
TextButton9.Position = UDim2.new(0.22,0,0.7)
TextButton9.TextColor3 = Color3.new(1,1,1)
TextButton9.Size = UDim2.new(0.2,0,0.09)
TextButton9.Font = Enum.Font.SourceSansLight
TextButton9.FontSize = Enum.FontSize.Size14
TextButton9.Text = ""
TextButton9.TextScaled = true
TextButton9.TextSize = 8
TextButton9.TextWrapped = true

TextButton9.MouseButton1Click:connect(function()
workspace.CurrentCamera.FieldOfView = 30
end)

TextButton10.Parent = Frame3
TextButton10.BackgroundColor3 = Color3.new(0,0,0)
TextButton10.BackgroundTransparency = 0
TextButton10.BorderSizePixel = 1
TextButton10.BorderColor3 = Color3.new(1,1,1)
TextButton10.Position = UDim2.new(0.22,0,0.8)
TextButton10.TextColor3 = Color3.new(1,1,1)
TextButton10.Size = UDim2.new(0.2,0,0.09)
TextButton10.Font = Enum.Font.SourceSansLight
TextButton10.FontSize = Enum.FontSize.Size14
TextButton10.Text = ""
TextButton10.TextScaled = true
TextButton10.TextSize = 8
TextButton10.TextWrapped = true

TextButton10.MouseButton1Click:connect(function()
workspace.CurrentCamera.FieldOfView = 5
end)
end)

admin.Name = ""
admin.Parent = main
admin.BackgroundColor3 = Color3.fromRGB(1,1,1)
admin.BorderSizePixel = 1
admin.Position = UDim2.new(0, 0, 0.690721631, 0)
admin.Size = UDim2.new(0, 140, 0, 28)
admin.Font = Enum.Font.SourceSansBold
admin.Text = "Goto CCTV Camera"
admin.TextColor3 = Color3.fromRGB(450,350,250)
admin.BorderColor3 = Color3.new(1,1,1)
admin.TextSize = 17.000
admin.TextWrapped = true

admin.MouseButton1Click:connect(function()
for _,v in next, Workspace:GetDescendants() do 
    if v.Name == "CCTV" then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
       wait(0.1)
       end
end
end)

local CCTV = Instance.new("Part")
local Camera = Instance.new("Part")

local position = Vector3.new(0,100000,0)
CCTV.Name = "CCTV"
CCTV.Color = Color3.new(0,0,0)
CCTV.Material = Enum.Material.Neon
CCTV.Transparency = 0
CCTV.Position = position
CCTV.Size = Vector3.new(1.5,1.5,2)
CCTV.CastShadow = true
CCTV.Anchored = true
CCTV.CanCollide = false
CCTV.Parent = workspace

local position = Vector3.new(0,100000,0)
Camera.Name = "Camera"
Camera.Color = Color3.new(1,1,1)
Camera.Material = Enum.Material.Neon
Camera.Transparency = 0
Camera.Position = position
Camera.Size = Vector3.new(1,0.5,2.1)
Camera.CastShadow = true
Camera.Anchored = true
Camera.CanCollide = false
Camera.Parent = CCTV
wait(0.1)
getgenv().Handle = true
while getgenv().Handle == true do
spawn(function()
workspace:FindFirstChild("CCTV").CFrame = game.Players.LocalPlayer.Character.LeftHand.CFrame
workspace:FindFirstChild("CCTV").Camera.CFrame = game.Players.LocalPlayer.Character.LeftHand.CFrame
end)
wait(.0000000000001)
end
end)
TrollTab:Button("fing all", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Custom%20By%20HEang.lua))()
end)
TrollTab:Button("📌🔪 - Painel Fling// Op", function()
    loadstring(game:HttpGet("https://paste.ee/r/NTtmf",true))()
end)
TrollTab:Button("Auto Fling", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Auto%20Fling%20Player",true))()
end)
TrollTab:Button("Ghost Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub"))()
end)
TrollTab:Button("Control Player", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Control%20Player"))();
end)
AnimationTab:Button("Zombie Animation", function()
    loadstring(game:HttpGet("https://pastefy.app/n42Ougzx/raw",true))()
end)
AnimationTab:Button("Steal Animation Gui", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Animation%20Stealer"))();
end)
ToolTab:Button("Fake HeadLess", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Fake%20Headless",true))()
end)
DTab:Button("Dahood Aim", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/Aimbot%20%2B%20slientaim%20%2B%20esp.lua",true))()
end)
DTab:Button("Slient Aim", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KIKO102133/Kiko.gethub.io/refs/heads/main/sli",true))()
end)
DTab:Button("Slient aim V2", function()
    getgenv().SilentAim = {
        Settings = {
            Enabled = true,
            AimPart = "Head",
            Prediction = 0.1365,
            WallCheck = true
        },
        FOV = {
            Enabled = true,
            Size = 100,
            Filled = false,
            Thickness = 1,
            Transparency = 1,
            Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        }
    }
    local lp = game:GetService("Players").LocalPlayer
    local cc = game:GetService("Workspace").CurrentCamera
    local mouse = lp:GetMouse()
    getgenv().PredictionBackUp = getgenv().SilentAim.Settings.Prediction
    local cc = game:GetService("Workspace").CurrentCamera
    local mouse = lp:GetMouse()
    
    local Utility = {
        Invite = "camlock",
        BackupInvite = "VfKf5dvSYX",
        Version = "1.0.0a",
        Method = "UpdateMousePos",
        AllowedPlaceIDs = {
            2788229376, -- Da Hood
            7213786345, -- Da Hood VC
            9825515356, -- Hood Customs
            5602055394, -- Hood Modded
            7951883376, -- Hood Modded VC
            12927359803, -- Dah Aim Trainer
            12867571492, -- KatanaHood
            7242996350, -- Da Hood Aim Trainer
            12884917481, -- Da Hood Aim Trainer VC
            11867820563, -- Dae Hood
            12618586930, -- Dat Hood
        }
    }
    
    if game.PlaceId == 2788229376 or game.PlaceId == 7213786345 then -- // Da Hood
        Utility.Method = "UpdateMousePos"
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then -- // Hood Modded
        Utility.Method = "MousePos"
            MainRemote = game:GetService("ReplicatedStorage").Bullets 
    elseif game.PlaceId == 12927359803 then -- // Dah Aim Trainer
        Utility.Method = "UpdateMousePos"
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    elseif game.PlaceId == 7242996350 or game.PlaceId == 12884917481 then -- // Da Hood Aim Trainer
        Utility.Method = "UpdateMousePos" 
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    elseif game.PlaceId == 12867571492 then -- // Katana Hood
        Utility.Method = "UpdateMousePos"
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    elseif game.PlaceId == 11867820563 then -- // Dae Hood
        Utility.Method = "UpdateMousePos"
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    elseif game.PlaceId == 12618586930 then -- // Dat Hood
        Utility.Method = "UpdateMousePos"
            MainRemote = game:GetService("ReplicatedStorage").MainEvent
    end
    
    WTS = (function(Object)
        local ObjectVector = cc:WorldToScreenPoint(Object.Position)
        return Vector2.new(ObjectVector.X, ObjectVector.Y)
    end)
    
    Filter = (function(obj)
        if (obj:IsA('BasePart')) then
            return true
        end
    end)
    
    mousePosVector2 = (function()
        return Vector2.new(mouse.X, mouse.Y) 
    end)
    
    getClosestBodyPart = (function()
        local shortestDistance = math.huge
        local bodyPart = nil
        for _, v in next, game.Players:GetPlayers() do
            if (v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid")) then
                for k, x in next, v.Character:GetChildren() do
                    if (Filter(x)) then
                        local Distance = (WTS(x) - mousePosVector2()).magnitude
                        if (Distance < shortestDistance) then
                            shortestDistance = Distance
                            bodyPart = x
                        end
                    end
                end
            end
        end
        return bodyPart
    end)
    
    local FOVCircle = Drawing.new("Circle")
    
    
    function updateFOV()
        FOVCircle.Radius = SilentAim.FOV.Size * 3
        FOVCircle.Visible = SilentAim.FOV.Enabled
        FOVCircle.Transparency = SilentAim.FOV.Transparency
        FOVCircle.Filled = SilentAim.FOV.Filled
        FOVCircle.Color = SilentAim.FOV.Color
        FOVCircle.Thickness = SilentAim.FOV.Thickness
        FOVCircle.Position = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
        return FOVCircle
    end
    
    local plrService = game:GetService("Players")
    local localPlr = plrService.LocalPlayer
    local mouseLocal = localPlr:GetMouse()
    local Players, Client, Mouse, Camera =
        game:GetService("Players"),
        game:GetService("Players").LocalPlayer,
        game:GetService("Players").LocalPlayer:GetMouse(),
        game:GetService("Workspace").CurrentCamera
    
    
    function wallCheck(destination, ignore)
        if (getgenv().SilentAim.Settings.WallCheck) then
            local Origin = Camera.CFrame.p
            local CheckRay = Ray.new(Origin, destination - Origin)
            local Hit = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(CheckRay, ignore)
            return Hit == nil
        else
            return true
        end
    end
    
    function getClosestPlayerToCursor()
        closestDist = SilentAim.FOV.Size * 3.47
        closestPlr = nil;
        for i, v in next, plrService:GetPlayers() do
            pcall(function()
                local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true;
                local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil
                if v ~= localPlr and v.Character and v.Character.Humanoid.Health > 0 and notKO and notGrabbed then
                    local screenPos, cameraVisible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if cameraVisible then
                        local distToMouse = (Vector2.new(mouseLocal.X, mouseLocal.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if distToMouse < closestDist and wallCheck(v.Character.Head.Position, {
                            game:GetService("Players").LocalPlayer,
                            v.Character
                        }) then
                            closestPlr = v
                            closestDist = distToMouse
                        end
                    end
                end
            end)
        end
        return closestPlr, closestDist
    end
    
    spawn(function()
        while wait() do
            Plr = getClosestPlayerToCursor()
        end
    end)
    
    spawn(function()
        while wait() do
            if Plr ~= nil and Plr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                local Ping = math.floor(game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                getgenv().SilentAim.Settings.Prediction = Ping / 1000 + 0.07
            end
        end
    end)
    
    game:GetService("RunService").Heartbeat:connect(function()
        updateFOV()
    end)
    
    local plr = game.Players.LocalPlayer
    local Char = plr.Character or plr.CharacterAdded:Wait()
    
    local function CharAdded()
    Char.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then -- add a better check for if the tool is a weapon 
            tool.Activated:Connect(function() -- fuck a :Disconnect lol
                if Plr ~= nil then
                    game:GetService("ReplicatedStorage").MainEvent:FireServer(Utility.Method, Plr.Character[SilentAim.Settings.AimPart].Position + (Plr.Character[SilentAim.Settings.AimPart].Velocity * SilentAim.Settings.Prediction))
                end
            end)
        end
    end)
    end
    
    plr.CharacterAdded:Connect(function(newchar)
    Char = newchar
    CharAdded()
    end)
    
    CharAdded()
end)
ScriptTab:Button("giver Tool", function()
    --Script Made By GhostPlayer
--Date May 18 2022
--Time PM 4:38

local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "GhostPlayer",
    Icon = "rbxassetid://29819383",
    Duration = 10,
})
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "X-Ray"
tool.Activated:connect(function()
local xrayHotkey = Enum.KeyCode.E                                                                 

local uis = game:GetService("UserInputService")


local xrayOn = false


uis.InputBegan:Connect(function(inp, processed)
	
	
	if processed then return end
	
	
	if inp.KeyCode == xrayHotkey then
		
		
		xrayOn = not xrayOn
		
		
		for i, descendant in pairs(workspace:GetDescendants()) do
				
			if descendant:IsA("BasePart") then
				
				if xrayOn then
					
					if not descendant:FindFirstChild("OriginalTransparency") then
						
						local originalTransparency = Instance.new("NumberValue")
						originalTransparency.Name = "OriginalTransparency"
						originalTransparency.Value = descendant.Transparency
						originalTransparency.Parent = descendant
					end
					
					descendant.Transparency = 0.5
					
				else
					descendant.Transparency = descendant.OriginalTransparency.Value
				end
			end
		end
	end
end)
wait()
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
wait()
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "J", false, game)
end)
tool.Parent = game.Players.LocalPlayer.Backpack
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Clone      Not Fe"
tool.Activated:connect(function()
    loadstring(game:GetObjects('rbxassetid://7339698872')[1].Source)()
end)
tool.Parent = game.Players.LocalPlayer.Backpack
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = ("Penetrating")
tool.Activated:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
do wait()
for i, v in next, workspace:GetDescendants() do
    if v:IsA("Part") or v:IsA("BasePart") and not v.Color == Color3.fromRGB(73, 84, 98) then
        v.CanCollide = false 
    end
end
wait(0.3)
for i, v in next, workspace:GetDescendants() do
    if v:IsA("Part") or v:IsA("BasePart") and not v.Color == Color3.fromRGB(73, 84, 98) then
        v.CanCollide = true
    end
end
end
end)		
tool.Parent = game.Players.LocalPlayer.Backpack

mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = ("Dash")
tool.Activated:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
do wait()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 500
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "W", false, game)
wait(0.2)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 17
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "S", false, game)
end
end)		
tool.Parent = game.Players.LocalPlayer.Backpack

mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = ("Super Jump")
tool.Activated:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
do wait()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 130
wait()
game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
wait(0.1)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end
end)		
tool.Parent = game.Players.LocalPlayer.Backpack
end)

ScriptTab:Button("player Remove", function ()
    local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "GhostPlayer",
    Icon = "rbxassetid://29819383",
    Duration = 2.5,
})

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Text = Instance.new("TextButton")


ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(0,0,0)
Frame.Position = UDim2.new(0.00001,0.0009,0)
Frame.Size = UDim2.new(2,0.2,0.08)
Frame.Active = true
Frame.Draggable = false

Text.Parent = Frame
Text.BackgroundColor3 = Color3.new(0,0,0)
Text.BackgroundTransparency = 100
Text.Position = UDim2.new(0,0,0.1)
Text.Size = UDim2.new(0.5,0.9,0.6)
Text.TextColor3 = Color3.new(1,1,1)
Text.Text = "3"
Text.TextScaled = true
Text.TextSize = 8
Text.TextWrapped = true
wait(1)
Text.Text = "2"
wait(1)
Text.Text = "1"
wait(1)
ScreenGui:Destroy()
local message = Instance.new("Message",workspace)
message.Text = "Players Removing."
wait(1)
message.Text = "Players Removing.."
wait(1)
message.Text = "Players Removing..."
wait(1)
message.Text = "Players Removing"
wait(1)
message.Text = "Players Removing."
wait(1)
message.Text = "Players Removing.."
wait(1)
message.Text = "Players Removing..."
wait(1)
message.Text = "Players Removing"
wait(1)
message.Text = "Players Removing."
wait(1)
message.Text = "Players Removing.."
wait(1.8)
message:Destroy()
local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Players Removing",
    Text = "Successful!",
    Icon = "rbxassetid://29819383",
    Duration = 2.5,
})
local L_1_ = true;
local L_2_ = game.Players.LocalPlayer.Character.HumanoidRootPart;
local L_3_ = L_2_.Position - Vector3.new(0, 1000, 0)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(L_4_arg1)
	if L_4_arg1 == 'f' then
		L_1_ = not L_1_
	end;
	if L_4_arg1 == 'r' then
		L_2_ = game.Players.LocalPlayer.Character.HumanoidRootPart;
		L_3_ = L_2_.Position - Vector3.new(5, 0, 0)
	end
end)

for L_5_forvar1, L_6_forvar2 in pairs(game.Players:GetPlayers()) do
	if L_6_forvar2 == game.Players.LocalPlayer then
	else
		local L_7_ = coroutine.create(function()
			game:GetService('RunService').RenderStepped:Connect(function()
				local L_8_, L_9_ = pcall(function()
					local L_10_ = L_6_forvar2.Character;
					if L_10_ then
						if L_10_:FindFirstChild("HumanoidRootPart") then
							if L_1_ then
								L_6_forvar2.Backpack:ClearAllChildren()
								for L_11_forvar1, L_12_forvar2 in pairs(L_10_:GetChildren()) do
									if L_12_forvar2:IsA("Tool") then
										L_12_forvar2:Destroy()
									end
								end;
								L_10_.HumanoidRootPart.CFrame = CFrame.new(L_3_)
							end
						end
					end
				end)
				if L_8_ then
				else
					warn("Unnormal error: "..L_9_)
				end
			end)
		end)
		coroutine.resume(L_7_)
	end
end;

game.Players.PlayerAdded:Connect(function(L_13_arg1)   
	if L_13_arg1 == game.Players.LocalPlayer then
	else
		local L_14_ = coroutine.create(function()
			game:GetService('RunService').RenderStepped:Connect(function()
				local L_15_, L_16_ = pcall(function()
					local L_17_ = L_13_arg1.Character;
					if L_17_ then
						if L_17_:FindFirstChild("HumanoidRootPart") then
							if L_1_ then
								L_13_arg1.Backpack:ClearAllChildren()
								for L_18_forvar1, L_19_forvar2 in pairs(L_17_:GetChildren()) do
									if L_19_forvar2:IsA("Tool") then
										L_19_forvar2:Destroy()
									end
								end;
								L_17_.HumanoidRootPart.CFrame = CFrame.new(L_3_)
							end
						end
					end
				end)
				if L_15_ then
				else
					warn("Unnormal error: "..L_16_)
				end
			end)
		end)
		coroutine.resume(L_14_)
	end           
end)
end)

ScriptTab:Button("Dump", function()
    local a=game:GetObjects("rbxassetid://3567096419")[1] a.Parent=game.CoreGui local function _(a,_)local function _(b,_)local a={} local c={script=_} local _={} _.__index=function(_,_)if c[_]==nil then return getfenv()[_]else return c[_]end end _.__newindex=function(_,a,_)if c[a]==nil then getfenv()[a]=_ else c[a]=_ end end setmetatable(a,_) setfenv(b,a) return b end local function b(a)if a.ClassName=="Script"or a.ClassName=="LocalScript"then task.spawn(function()_(loadstring(a.Source,"="..a:GetFullName()),a)()end)end for _,_ in pairs(a:GetChildren())do b(_)end end b(a)end _(a)
end)
TrollTab:Button("Grab Player", function()
    local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "",
    Text = "Grab",
    Icon = "rbxassetid://29819383",
    Duration = 2,
})

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextBox")
local TextButton1 = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(8,0,0)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0.293040276, 0, 0.491666675, 0)
Frame.Size = UDim2.new(0.16,0.2,0.4)
Frame.Active = true
Frame.Draggable = true

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.new(1,1,1)
TextButton.BackgroundTransparency = 0
TextButton.Position = UDim2.new(0.103524067, 0, 0.200333327, 0)
TextButton.Size = UDim2.new(0.8,0.9,0.2)
TextButton.Font = Enum.Font.SourceSansLight
TextButton.FontSize = Enum.FontSize.Size14
TextButton.Text = "Player Name"
TextButton.TextScaled = true
TextButton.TextSize = 8
TextButton.TextWrapped = true

TextButton1.Parent = Frame
TextButton1.BackgroundColor3 = Color3.new(5,5,5)
TextButton1.BackgroundTransparency = 0
TextButton1.Position = UDim2.new(0.2,0,0.6)
TextButton1.Size = UDim2.new(0.6,0.9,0.13)
TextButton1.Font = Enum.Font.SourceSansLight
TextButton1.FontSize = Enum.FontSize.Size14
TextButton1.Text = "Grab"
TextButton1.TextScaled = true
TextButton1.TextScaled = 8
TextButton1.TextWrapped = true


TextButton1.MouseButton1Click:connect(function()
if InProgress == false then
   InProgress = true

--On Second Click
TextButton1.Text = "Grab"
getgenv().Grabbing = false

else
InProgress = false

--On First Click
TextButton1.Text = "UnGrab"
local target = TextButton.Text

getgenv().Grabbing = true
while getgenv().Grabbing == true do
game:GetService("Workspace").Grab.CFrame = workspace[target].LeftHand.CFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Grab.CFrame * CFrame.Angles(math.rad(260),math.rad(0),math.rad(0))
print()
game:GetService("RunService").Heartbeat:wait();
end;
end
end)


local part = Instance.new("Part")

local position = Vector3.new(0,100000,0)
part.Name = "Grab"
part.Color = Color3.new(0,0,0)
part.Material = Enum.Material.Plastic
part.Transparency = 1
part.Position = position
part.Size = Vector3.new(1,0.5,1)
part.CastShadow = true
part.Anchored = true
part.CanCollide = false
part.Parent = workspace
end)

function teleport1()
    local daddy = game.Players.LocalPlayer.Character.HumanoidRootPart
    local griddy = CFrame.new(Vector3.new(-70, 35, 362))
    daddy.CFrame = griddy
end
 
TTab:Button("Safe zone 1", function()
  teleport1()
end)
ToolTab:Button("Pos gui", function ()
    local CoreGui = game:GetService("StarterGui")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local copy = Instance.new("TextButton")
local pos = Instance.new("TextBox")
local find = Instance.new("TextButton")
local tp = Instance.new("TextButton")
--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.32,0,0.08)
Frame.Size = UDim2.new(0, 280, 0.3, 100)
Frame.Active = true

title.Name = "title"
title.Parent = Frame
title.BackgroundColor3 = Color3.fromRGB(255,0,0)
title.BorderSizePixel = 0
title.Size = UDim2.new(0, 280, 0, 50)
title.Font = Enum.Font.GothamBold
title.Text = "Position Reader"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 30.000
title.TextWrapped = true

copy.Name = "copy"
copy.Parent = Frame
copy.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
copy.BorderSizePixel = 0
copy.Position = UDim2.new(0.66,0,0.635)
copy.Size = UDim2.new(0,70,0,47)
copy.Font = Enum.Font.GothamSemibold
copy.Text = "Copy"
copy.TextColor3 = Color3.fromRGB(255, 255, 255)
copy.TextSize = 20.000

pos.Name = "pos"
pos.Parent = Frame
pos.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
pos.BorderSizePixel = 0
pos.Position = UDim2.new(0.0904392749, 0, 0.305825233, 0)
pos.Size = UDim2.new(0, 230, 0, 50)
pos.Font = Enum.Font.GothamSemibold
pos.Text = ""
pos.TextColor3 = Color3.fromRGB(255, 255, 255)
pos.TextSize = 14.000
pos.TextWrapped = true

tp.Name = "copy"
tp.Parent = Frame
tp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tp.BorderSizePixel = 0
tp.Position = UDim2.new(0.37,0,0.635)
tp.Size = UDim2.new(0,70,0,47)
tp.Font = Enum.Font.GothamSemibold
tp.Text = "Notify"
tp.TextColor3 = Color3.fromRGB(255, 255, 255)
tp.TextSize = 20.000

tp.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.new(pos.text)
end)

find.Name = "find"
find.Parent = Frame
find.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
find.BorderSizePixel = 0
find.Position = UDim2.new(0.0904392898, 0, 0.635922313, 0)
find.Size = UDim2.new(0, 70, 0, 47)
find.Font = Enum.Font.GothamSemibold
find.Text = "Read"
find.TextColor3 = Color3.fromRGB(255, 255, 255)
find.TextSize = 20.000

-- Scripts:

local function UMTQ_fake_script() -- copy.LocalScript 
	local script = Instance.new('LocalScript', copy)

	script.Parent.MouseButton1Click:Connect(function()
		setclipboard(script.Parent.Parent.pos.Text)
	end)
end
coroutine.wrap(UMTQ_fake_script)()
local function KJAYG_fake_script() -- Frame.Dragify 
	local script = Instance.new('LocalScript', Frame)

	local UIS = game:GetService("UserInputService")
	function dragify(Frame)
	    dragToggle = nil
	    local dragSpeed = 0
	    dragInput = nil
	    dragStart = nil
	    local dragPos = nil
	    function updateInput(input)
	        local Delta = input.Position - dragStart
	        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
	        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
	    end
	    Frame.InputBegan:Connect(function(input)
	        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
	            dragToggle = true
	            dragStart = input.Position
	            startPos = Frame.Position
	            input.Changed:Connect(function()
	                if input.UserInputState == Enum.UserInputState.End then
	                    dragToggle = false
	                end
	            end)
	        end
	    end)
	    Frame.InputChanged:Connect(function(input)
	        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
	            dragInput = input
	        end
	    end)
	    game:GetService("UserInputService").InputChanged:Connect(function(input)
	        if input == dragInput and dragToggle then
	            updateInput(input)
	        end
	    end)
	end
	
	dragify(script.Parent)
end
coroutine.wrap(KJAYG_fake_script)()

local function EKBNYI_fake_script() -- find.LocalScript 
	local script = Instance.new('LocalScript', find)

	script.Parent.MouseButton1Down:Connect(function()
		script.Parent.Parent.pos.Text = tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
		end)
end
coroutine.wrap(EKBNYI_fake_script)()

tp.MouseButton1Click:Connect(function()
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Text = Instance.new("TextButton")


ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(0,0,0)
Frame.Position = UDim2.new(0.00001,0.0009,0)
Frame.Size = UDim2.new(2,0.2,0.08)
Frame.Active = true
Frame.Draggable = false

Text.Parent = Frame
Text.BackgroundColor3 = Color3.new(0,0,0)
Text.BackgroundTransparency = 100
Text.Position = UDim2.new(0,0,0.1)
Text.Size = UDim2.new(0.5,0.9,0.6)
Text.TextColor3 = Color3.new(1,1,1)
Text.Text = tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
Text.TextScaled = true
Text.TextSize = 8
Text.TextWrapped = true
wait(5)
ScreenGui:Destroy()
end)

end)

TrollTab:Button("Spin Hat", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BingusWR/Fe-Spinning-Hat-Script/refs/heads/main/Fe%20Spinning%20Hats%20Script"))()
end)
