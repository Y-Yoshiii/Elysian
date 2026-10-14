-- ArteriaRaceEquip — Script in ServerScriptService.
-- Equips race accessories (and Dragonkin wings) on R6 characters from ServerStorage.ArteriaAccessories.
-- Reads the player attribute "Race" (Dragonkin | Beastkin | Stonekin | Elf | Human | Tideborn).
-- Set it before the character spawns; changing it later re-equips live.
-- Beastkin: attribute "BeastVariant" = "Fox" (default) | "Wolf".
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local RACE_ATTRIBUTE = "Race"
local VARIANT_ATTRIBUTE = "BeastVariant"

local RACE_PREFIX = {
	Dragonkin = "Dragonkin_",
	Beastkin = "Beastkin_",
	Stonekin = "Stonekin_",
	Elf = "Elf_",
	Human = "Human_",
	Tideborn = "Tideborn_",
}

local TAG = "ArteriaRaceAccessory"

local function excluded(name: string, variant: string): boolean
	if string.find(name, "Beastkin_Fox") and variant ~= "Fox" then return true end
	if string.find(name, "Beastkin_Wolf") and variant ~= "Wolf" then return true end
	return false
end

local function clear(character: Model)
	for _, child in character:GetChildren() do
		if child:IsA("Accessory") and child:GetAttribute(TAG) then child:Destroy() end
	end
end

local function equip(player: Player, character: Model)
	local humanoid = character:WaitForChild("Humanoid", 10) :: Humanoid?
	if not humanoid then return end
	clear(character)

	local race = player:GetAttribute(RACE_ATTRIBUTE)
	local prefix = type(race) == "string" and RACE_PREFIX[race]
	if not prefix then return end
	local variant = player:GetAttribute(VARIANT_ATTRIBUTE)
	if variant ~= "Wolf" then variant = "Fox" end

	local lib = ServerStorage:FindFirstChild("ArteriaAccessories")
	if not lib then warn("ArteriaRaceEquip: ServerStorage.ArteriaAccessories missing (run setup script)") return end

	local function add(template: Instance?)
		if not template then return end
		local acc = template:Clone()
		acc:SetAttribute(TAG, true)
		humanoid:AddAccessory(acc)
	end

	for _, template in lib:GetChildren() do
		if string.sub(template.Name, 1, #prefix) == prefix and not excluded(template.Name, variant) then
			add(template)
		end
	end
	if race == "Dragonkin" then add(ServerStorage:FindFirstChild("Dragonkin_Wings_02")) end
end

local function onPlayer(player: Player)
	player.CharacterAdded:Connect(function(character) equip(player, character) end)
	-- Re-equip live if race/variant changes while the character exists.
	local function refresh()
		if player.Character then task.spawn(equip, player, player.Character) end
	end
	player:GetAttributeChangedSignal(RACE_ATTRIBUTE):Connect(refresh)
	player:GetAttributeChangedSignal(VARIANT_ATTRIBUTE):Connect(refresh)
	if player.Character then task.spawn(equip, player, player.Character) end
end

Players.PlayerAdded:Connect(onPlayer)
for _, p in Players:GetPlayers() do onPlayer(p) end
