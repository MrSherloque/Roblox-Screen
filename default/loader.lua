local resolution = {X = 600, Y = 400}
local localResolution = {X = 600, Y = 400}
local size = {X = 5, Y = 5}
resolution.X /= size.X
resolution.Y /= size.Y

local pixels = {}
local BIOS = script:WaitForChild("BIOS")
local OS = script:WaitForChild("OS")
local FONTS = script:WaitForChild("FONTS")

wait(5)

local spawned = 0
local run = true

script.Parent.exit.TextButton.MouseButton1Click:Connect(function()
	run = false
	
	script.Parent.ScreenGui:Destroy()
end)

for x = 1,resolution.X,1 do
	pixels[x] = {}
	if run == false then break end
	for y = 1,resolution.Y,1 do
		if run == false then break end
		spawned += 1
		local newFrame = Instance.new("Frame")
		newFrame.Name = "pixel"
		newFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		newFrame.Size = UDim2.new(0,size.X,0,size.Y)
		newFrame.Position = UDim2.new(0,size.X*x - size.X,0,size.Y*y - size.Y)--newFrame.Position = UDim2.new(0,size.X*x - size.X,0,size.Y*y - size.Y)
		newFrame.BorderSizePixel = 0
		
		pixels[x][y] = newFrame
		newFrame.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui
		if spawned >=1000 then
			spawned = 0
			wait()
		end
		
	end
	
	
end

local b = require(BIOS)
b.load(resolution,localResolution,pixels)


print("DONE")
