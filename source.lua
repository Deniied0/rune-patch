-- // rune exploit patch by annatar
-- // make this a localscript in game.ReplicatedFirst with a random name

task.wait() -- this is here incase you make a serverscript parent it, scripts cant be reparented while it just got reparented without yielding
script.Parent=nil -- they wont be able to get this script unless their exploit has getnilinstances

local repf = game:GetService'ReplicatedFirst'
local scon = game:GetService'ScriptContext'
local tpsr = game:GetService'TeleportService'
local plrs = game:GetService'Players'
local runs = game:GetService'RunService'
-- below is from https://gist.github.com/haggen/2fd643ea9a261fea2094?permalink_comment_id=3871389#gistcomment-3871389
math.randomseed(os.time())
local character_set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_++{}|\\:;'\"<>?,./"

local string_sub = string.sub
local math_random = math.random
local table_concat = table.concat
local character_set_amount = #character_set
local number_one = 1
local default_length = 10

local function generate_key(length)
	local random_string = {}

	for int = number_one, length or default_length do
		local random_number = math_random(number_one, character_set_amount)
		local character = string_sub(character_set, random_number, random_number)

		random_string[#random_string + number_one] = character
	end

	return table_concat(random_string)
end
-- from this line the rest is my code

local function detected()
	game:GetService'Players'.LocalPlayer:Destroy()
end

tpsr.LocalPlayerArrivedFromTeleport:Connect(function(gui)
	pcall(function() -- just in case it's still parented to coregui
		if not gui then return end
		for i,v in next,gui:GetDescendants() do
			if v:IsA'LuaSourceContainer' then
				detected()
			end
		end
	end)
end)

local bait = Instance.new'LocalScript'
bait.Name = 'Inject' -- we create a script with no parent caled "Inject" in nil to confuse scanners

runs.Heartbeat:Connect(function()
	repf.Name = generate_key(math.random(1,30))
	scon.Name = generate_key(math.random(1,30)) -- some exploit devs are too stupid to get around this lol
	plrs.Name = generate_key(math.random(1,30))
			
	for i in next,_G do
		if i == 'IY' or i == 'Dex' then
			detected()
		end
	end
		
	if game:FindFirstChild'saveinstance' then
		detected()
	end
end)

script.Name = "RbxCharacterSounds"

local function addDetections(inst)
	inst.Changed:Connect(detected)
	inst.DescendantAdded:Connect(detected)
	inst.AncestryChanged:Connect(detected)
end

addDetections(script)
addDetections(bait)

local teleportData = tpsr:GetLocalPlayerTeleportData()

if teleportData and type(teleportData) == type{} then
	for i,v in next,teleportData do
		if typeof(v) == typeof(game) and v:IsA'LuaSourceContainer' then
			detected()
		end
		if typeof(v) == typeof(game) then
			for i,v in next,v:GetDescendants() do
				if v:IsA'LuaSourceContainer' then
					detected()
				end
			end
		end
	end
end

-- this is all i could think of for now, feel free to make a pull req
