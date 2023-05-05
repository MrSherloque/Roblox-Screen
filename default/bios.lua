local bios = {}

local resolution
local localResolution

local pixels

local UserInputService = game:GetService("UserInputService")

local function setPixel(at,c)
	if math.round(at.X) == 0 then
		at += Vector2.new(1,0)
	end

	if math.round(at.X) then
		at += Vector2.new(0,1)
	end
	pixels[math.round(at.X)][math.round(at.Y)].BackgroundColor3 = c
end

local function drawLine(from,to,c)
	local dx = to.X - from.X
	local dy = to.Y - from.Y

	local steps

	if math.abs(dx) > math.abs(dy) then
		steps = math.abs(dx)
	else
		steps = math.abs(dy)
	end

	local x1 = from.X
	local x2 = to.X
	local y1 = from.y

	for x = x1,x2 do
		local y = y1 + dy * (x - x1) / dx
		setPixel(Vector2.new(x,y),c)
	end
end

local function drawBox(from,to,c)

	local ratioX = resolution.X / localResolution.X
	local ratioY = resolution.Y / localResolution.Y

	local scaledFrom = Vector2.new(from.X * ratioX, from.Y * ratioY)
	local scaledTo = Vector2.new(to.X * ratioX, to.Y * ratioY)

	for y = scaledFrom.Y,scaledTo.Y,1 do
		drawLine(Vector2.new(scaledFrom.X,y),Vector2.new(scaledTo.X,y),c)
	end
end

local function drawText(text, pos, scale, co)
	scale = scale or 1
	local x, y = pos.X, pos.Y
	for i = 1, #text do
		local c = text:sub(i,i)
		local bitmap = require(script.Parent.FONTS.Bitmap)[string.upper(c)]
		if bitmap then
			for j = 1, #bitmap do
				for k = 1, #bitmap[j] do
					if bitmap[j][k] == 1 then
						local pixelPos = Vector2.new(x + (k-1)*scale, y + (j-1)*scale)
						for m = 1, scale do
							for n = 1, scale do
								setPixel(Vector2.new(pixelPos.X + m - 1, pixelPos.Y + n - 1),co)
							end
						end
					end
				end
			end
			x = x + (#bitmap[1] + 1) * scale
		end
	end
end

local function setScreen(co)
	for ix,x in pairs(pixels) do
		for iy, y in pairs(x) do
			y.BackgroundColor3 = co
		end
	end
end

local function awaitKey(keyArray)
	print(keyArray)
	local result = false
	
	local conn = UserInputService.InputEnded:Connect(function(input,gp)
		if not gp then 
			print(input.KeyCode)
			local key = keyArray[input.KeyCode]
			if key then
				if input.KeyCode == key then
					result = input.KeyCode
				end
			end
			
		end
		
	end)
	
	repeat wait() until result ~= false
	conn:Disconnect()
	return result
end

local keyMapper = {
	["1"] = Enum.KeyCode.One;
	["2"] = Enum.KeyCode.Two;
	["3"] = Enum.KeyCode.Three;
	["4"] = Enum.KeyCode.Four;
	["5"] = Enum.KeyCode.Five;
	["6"] = Enum.KeyCode.Six;
	["7"] = Enum.KeyCode.Seven;
	["8"] = Enum.KeyCode.Eight;
	["9"] = Enum.KeyCode.Nine;
	["0"] = Enum.KeyCode.Zero;
}

local invertedKeyMapper = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Zero] = 9,
}

bios.load = function(r,lR,p)
	resolution = r
	localResolution = lR
	pixels = p
	
	drawText("BIOS: LOADING!",Vector2.new(10,10),1,Color3.new(1, 1, 1))
	
	local foundOS = script.Parent.OS:GetChildren()
	print(foundOS)
	
	
	wait(2)
	
	setScreen(Color3.new(0,0,0))
	
	if #foundOS == 1 then
		drawText("LOADING OS",Vector2.new(10,10),1,Color3.new(1, 1, 1))

		drawText("1: "..foundOS[1].Name,Vector2.new(10,(1 * 10 + 10)),1,Color3.new(1, 1, 1))

		wait(0.2)

		local OS = require(foundOS[1])
		OS.load(resolution,localResolution,pixels)
	elseif #foundOS == 0 then
		drawText("OS NOT FOUND.",Vector2.new(10,10),1,Color3.new(1, 0, 0))
	else
		drawText("SELECT OS",Vector2.new(10,10),1,Color3.new(1, 1, 1))
		
		local keyArray = {}
		
		for i = 1,#foundOS,1 do
			print(tostring(i))
			keyArray[keyMapper[tostring(i)]] = keyMapper[tostring(i)]
			drawText(i..": "..foundOS[i].Name,Vector2.new(10,(i * 10 + 10)),1,Color3.new(1, 1, 1))
		end
		
		local pressed = awaitKey(keyArray)
		
		setScreen(Color3.new(0,0,0))
		
		drawText("LOADING OS",Vector2.new(10,10),1,Color3.new(1, 1, 1))
		
		drawText(invertedKeyMapper[pressed]..": "..foundOS[invertedKeyMapper[pressed]].Name,Vector2.new(10,(invertedKeyMapper[pressed] * 10 + 10)),1,Color3.new(1, 1, 1))
		
		wait(0.2)
		
		local OS = require(foundOS[invertedKeyMapper[pressed]])
		OS.load(resolution,localResolution,pixels)
	end
	
	
end

return bios
