-- World of Arteria — 38 race accessories. Run once in the Studio command bar
-- after importing Arteria_Accessories.glb (3D Importer, Scale Unit = Stud, no rotation).
-- Expects Workspace.Arteria_Accessories containing one Model per accessory. Result: ServerStorage.ArteriaAccessories/<id>
local pack = workspace:WaitForChild("Arteria_Accessories")
local out = game:GetService("ServerStorage"):FindFirstChild("ArteriaAccessories") or Instance.new("Folder")
out.Name = "ArteriaAccessories"
out.Parent = game:GetService("ServerStorage")

-- { id, handle part, attachment name (matches r6.rbxm), AccessoryType, attachment offset from handle }
local DEFS = {
	{ "Dragonkin_Horns_01", "Obsidian", "HatAttachment", "Hat", Vector3.new(0.000, 0.094, -0.212) },
	{ "Dragonkin_Crest_01", "Obsidian", "FaceFrontAttachment", "Face", Vector3.new(0.000, -0.521, -0.445) },
	{ "Dragonkin_Tail_01", "Obsidian", "WaistBackAttachment", "Waist", Vector3.new(-0.316, 0.458, -1.316) },
	{ "Dragonkin_Pauldron_R_01", "Obsidian", "RightShoulderAttachment", "Shoulder", Vector3.new(-0.161, 0.232, -0.000) },
	{ "Dragonkin_Pauldron_L_01", "Obsidian", "LeftShoulderAttachment", "Shoulder", Vector3.new(0.161, 0.232, -0.000) },
	{ "Dragonkin_ArmScales_R_01", "Obsidian", "RightGripAttachment", "Unknown", Vector3.new(0.000, -0.640, -0.004) },
	{ "Dragonkin_ArmScales_L_01", "Obsidian", "LeftGripAttachment", "Unknown", Vector3.new(0.000, -0.640, -0.004) },
	{ "Dragonkin_Claws_R_01", "Bone", "RightGripAttachment", "Unknown", Vector3.new(0.000, 0.102, 0.530) },
	{ "Dragonkin_Claws_L_01", "Bone", "LeftGripAttachment", "Unknown", Vector3.new(0.000, 0.102, 0.530) },
	{ "Beastkin_FoxEars_01", "Fur_Rust", "HatAttachment", "Hat", Vector3.new(0.000, -0.167, -0.020) },
	{ "Beastkin_WolfEars_01", "Fur_Grey", "HatAttachment", "Hat", Vector3.new(0.000, -0.198, -0.021) },
	{ "Beastkin_FoxTail_01", "Fur_Rust", "WaistBackAttachment", "Waist", Vector3.new(-0.088, 0.237, -0.805) },
	{ "Beastkin_WolfTail_01", "Fur_Grey", "WaistBackAttachment", "Waist", Vector3.new(-0.006, 0.330, -0.364) },
	{ "Beastkin_RamHorns_01", "Horn_Tan", "HatAttachment", "Hat", Vector3.new(0.000, 0.374, -0.184) },
	{ "Beastkin_FurRuff_01", "Fur_Cream", "NeckAttachment", "Neck", Vector3.new(0.000, -0.034, 0.000) },
	{ "Beastkin_Muzzle_01", "Fur_Cream", "FaceFrontAttachment", "Face", Vector3.new(0.000, 0.137, -0.000) },
	{ "Beastkin_Claws_R_01", "Claw_Black", "RightGripAttachment", "Unknown", Vector3.new(0.000, 0.102, 0.530) },
	{ "Beastkin_Claws_L_01", "Claw_Black", "LeftGripAttachment", "Unknown", Vector3.new(0.000, 0.102, 0.530) },
	{ "Stonekin_CrystalShoulders_R_01", "Crystal", "RightShoulderAttachment", "Shoulder", Vector3.new(-0.360, -0.241, -0.012) },
	{ "Stonekin_CrystalShoulders_L_01", "Crystal", "LeftShoulderAttachment", "Shoulder", Vector3.new(0.360, -0.241, -0.012) },
	{ "Stonekin_ForearmArmor_R_01", "Stone_Dark", "RightGripAttachment", "Unknown", Vector3.new(-0.056, -0.323, -0.037) },
	{ "Stonekin_ForearmArmor_L_01", "Stone_Dark", "LeftGripAttachment", "Unknown", Vector3.new(0.056, -0.323, -0.037) },
	{ "Stonekin_BackFormation_01", "Crystal", "BodyBackAttachment", "Back", Vector3.new(0.000, -0.530, -0.342) },
	{ "Stonekin_StoneCrown_01", "Stone", "HatAttachment", "Hat", Vector3.new(0.000, 0.080, 0.000) },
	{ "Stonekin_StoneHorns_01", "Stone_Dark", "HatAttachment", "Hat", Vector3.new(0.000, -0.092, 0.250) },
	{ "Elf_PointEars_01", "Skin", "HatAttachment", "Hat", Vector3.new(0.000, 0.434, -0.299) },
	{ "Elf_EarCuffs_01", "Silver", "HatAttachment", "Hat", Vector3.new(0.000, 0.548, -0.222) },
	{ "Elf_Circlet_01", "Silver", "HatAttachment", "Hat", Vector3.new(0.000, 0.235, 0.012) },
	{ "Elf_ForeheadChain_01", "Silver", "FaceFrontAttachment", "Face", Vector3.new(0.000, -0.288, -0.371) },
	{ "Human_Circlet_01", "Bronze", "HatAttachment", "Hat", Vector3.new(0.000, 0.300, 0.007) },
	{ "Human_Laurel_01", "Gold", "HatAttachment", "Hat", Vector3.new(0.000, 0.211, 0.006) },
	{ "Tideborn_EarFins_01", "Fin_Teal", "HatAttachment", "Hat", Vector3.new(0.000, 0.495, -0.301) },
	{ "Tideborn_SeaCrest_01", "Fin_Teal", "HatAttachment", "Hat", Vector3.new(0.000, -0.199, -0.113) },
	{ "Tideborn_CoralHorns_01", "Coral", "HatAttachment", "Hat", Vector3.new(0.000, -0.197, -0.061) },
	{ "Tideborn_CheekScales_01", "Scale_Teal", "FaceFrontAttachment", "Face", Vector3.new(0.000, 0.113, -0.197) },
	{ "Tideborn_Tail_01", "Scale_Teal", "WaistBackAttachment", "Waist", Vector3.new(0.000, 0.376, -0.825) },
	{ "Tideborn_ForearmFins_R_01", "Fin_Teal", "RightGripAttachment", "Unknown", Vector3.new(-0.677, -0.480, -0.146) },
	{ "Tideborn_ForearmFins_L_01", "Fin_Teal", "LeftGripAttachment", "Unknown", Vector3.new(0.677, -0.480, -0.146) },
}

local made, missing = 0, {}
for _, d in DEFS do
	local id, handleName, attName, accType, offset = d[1], d[2], d[3], d[4], d[5]
	local model = pack:FindFirstChild(id, true)
	local handle = model and model:FindFirstChild(handleName, true)
	if not handle then table.insert(missing, id) continue end
	local old = out:FindFirstChild(id)
	if old then old:Destroy() end

	local acc = Instance.new("Accessory")
	acc.Name = id
	acc.AccessoryType = Enum.AccessoryType[accType]
	for _, p in model:GetDescendants() do
		if p:IsA("BasePart") then
			p.Anchored = false
			p.CanCollide = false
			p.CanQuery = false
			p.CanTouch = false
			p.Massless = true
			if p ~= handle then
				local w = Instance.new("WeldConstraint")
				w.Part0 = handle
				w.Part1 = p
				w.Parent = p
			end
		end
	end
	local a = Instance.new("Attachment")
	a.Name = attName
	a.Position = offset
	a.Parent = handle
	handle.Name = "Handle"
	for _, p in model:GetDescendants() do
		if p:IsA("BasePart") then p.Parent = acc end
	end
	acc.Parent = out
	made += 1
end
pack:Destroy()
print(("Arteria: %d accessories created in ServerStorage.ArteriaAccessories"):format(made))
if #missing > 0 then warn("Missing in import: " .. table.concat(missing, ", ")) end

-- In game (server): humanoid:AddAccessory(game.ServerStorage.ArteriaAccessories["Dragonkin_Horns_01"]:Clone())
