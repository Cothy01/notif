local NotificationUI = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TweenService = game:GetService("TweenService")

-- Setup ScreenGui
NotificationUI.Name = "NotificationUI"
NotificationUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
NotificationUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Setup Container
Container.Name = "Container"
Container.Parent = NotificationUI
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(1, -300, 0, 50) -- Positioned in top-right
Container.Size = UDim2.new(0, 280, 0, 600)
Container.ClipsDescendants = true

-- Setup UIListLayout
UIListLayout.Parent = Container
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Notification module
local NotificationSystem = {}

-- Function to create a new notification
function NotificationSystem.notify(message, duration)
	duration = duration or 3 -- Default duration of 3 seconds

	-- Create Notification Frame
	local Notification = Instance.new("Frame")
	Notification.Name = "Notification"
	Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	Notification.Size = UDim2.new(0, 260, 0, 50)
	Notification.BackgroundTransparency = 1
	Notification.Parent = Container

	-- UICorner
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = Notification

	-- TextLabel
	local Information = Instance.new("TextLabel")
	Information.Name = "Information"
	Information.BackgroundTransparency = 1
	Information.Size = UDim2.new(1, -20, 1, 0)
	Information.Position = UDim2.new(0, 10, 0, 0)
	Information.Font = Enum.Font.GothamBold
	Information.Text = message
	Information.TextColor3 = Color3.fromRGB(255, 255, 255)
	Information.TextSize = 14
	Information.TextTransparency = 1
	Information.TextWrapped = true
	Information.Parent = Notification

	-- Animations
	local slideIn = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0
	})
	local textFadeIn = TweenService:Create(Information, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
		TextTransparency = 0
	})
	local slideOut = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(0.2, 0, 0, 0),
		BackgroundTransparency = 1
	})
	local textFadeOut = TweenService:Create(Information, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
		TextTransparency = 1
	})

	-- Initial position for slide-in
	Notification.Position = UDim2.new(0.2, 0, 0, 0)

	-- Play slide-in and fade-in animations
	slideIn:Play()
	textFadeIn:Play()

	-- Auto-remove after duration
	delay(duration, function()
		slideOut:Play()
		textFadeOut:Play()
		slideOut.Completed:Connect(function()
			Notification:Destroy()
		end)
	end)
end

-- Function to clear all notifications
function NotificationSystem.clear()
	for _, notification in ipairs(Container:GetChildren()) do
		if notification:IsA("Frame") then
			local slideOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(0.2, 0, 0, 0),
				BackgroundTransparency = 1
			})
			local textFadeOut = TweenService:Create(notification.Information, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
				TextTransparency = 1
			})
			slideOut:Play()
			textFadeOut:Play()
			slideOut.Completed:Connect(function()
				notification:Destroy()
			end)
		end
	end
end

-- Example usage
-- NotificationSystem.notify("Welcome to the game!", 5)
-- NotificationSystem.notify("You earned 100 points!", 3)

return NotificationSystem
