-- Dragonkin_Wings_02 setup — run ONCE in the Studio command bar after importing Arteria_DragonWings.glb
-- (3D Importer: Scale Unit = Stud, no rotation, import into Workspace).
-- Builds an Accessory of rigid MeshParts joined by Motor6Ds. Membranes are created at runtime by
-- ArteriaDragonWings.client.lua, so the imported file contains bones only.
local ServerStorage = game:GetService("ServerStorage")
local ID = "Dragonkin_Wings_02"
local model = workspace:FindFirstChild("Arteria_DragonWings")
assert(model, "Import Arteria_DragonWings.glb into Workspace first")

-- Expected part centers in R6 Torso space (studs). Used to verify the import kept the layout.
local EXPECT = {
	WingMount = Vector3.new(0, 0.5, 0.59),
	Humerus_R = Vector3.new(0.7224, 0.912, 0.7779),
	Forearm_R = Vector3.new(1.715, 1.4365, 0.9151),
	Finger1_R = Vector3.new(3.2935, 1.2265, 1.0426),
	Finger2_R = Vector3.new(2.9635, 0.4869, 1.024),
	Finger3_R = Vector3.new(2.3705, 0.0421, 0.98),
	Humerus_L = Vector3.new(-0.7224, 0.912, 0.7779),
	Forearm_L = Vector3.new(-1.715, 1.4365, 0.9151),
	Finger1_L = Vector3.new(-3.2935, 1.2265, 1.0426),
	Finger2_L = Vector3.new(-2.9635, 0.4869, 1.024),
	Finger3_L = Vector3.new(-2.3705, 0.0421, 0.98),
}
-- { Motor6D name, Part0, Part1, joint pivot in Torso space }
local JOINTS = {
	{ "WingShoulder_R", "WingMount", "Humerus_R", Vector3.new(0.32, 0.55, 0.68) },
	{ "WingElbow_R", "Humerus_R", "Forearm_R", Vector3.new(1.17, 1.2, 0.86) },
	{ "WingFinger1_R", "Forearm_R", "Finger1_R", Vector3.new(2.27, 1.5, 0.98) },
	{ "WingFinger2_R", "Forearm_R", "Finger2_R", Vector3.new(2.27, 1.5, 0.98) },
	{ "WingFinger3_R", "Forearm_R", "Finger3_R", Vector3.new(2.27, 1.5, 0.98) },
	{ "WingShoulder_L", "WingMount", "Humerus_L", Vector3.new(-0.32, 0.55, 0.68) },
	{ "WingElbow_L", "Humerus_L", "Forearm_L", Vector3.new(-1.17, 1.2, 0.86) },
	{ "WingFinger1_L", "Forearm_L", "Finger1_L", Vector3.new(-2.27, 1.5, 0.98) },
	{ "WingFinger2_L", "Forearm_L", "Finger2_L", Vector3.new(-2.27, 1.5, 0.98) },
	{ "WingFinger3_L", "Forearm_L", "Finger3_L", Vector3.new(-2.27, 1.5, 0.98) },
}

local parts = {}
for name in EXPECT do
	local p = model:FindFirstChild(name, true)
	assert(p and p:IsA("BasePart"), "Missing imported part: " .. name)
	parts[name] = p
end
local mount = parts.WingMount
local worst = 0
for name, c in EXPECT do
	worst = math.max(worst, ((parts[name].Position - mount.Position) - (c - EXPECT.WingMount)).Magnitude)
end
assert(worst < 0.05, ("Imported parts are %.2f studs off the expected layout. Re-import with Scale Unit = Stud and no rotation."):format(worst))
local function toWorld(p)
	return mount.Position + (p - EXPECT.WingMount)
end

for _, p in parts do
	p.Anchored = false
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Massless = true
	p.CastShadow = true
	p.Material = Enum.Material.SmoothPlastic
	p.Color = Color3.fromRGB(47, 42, 43)
end

for _, j in JOINTS do
	local name, p0, p1, pivot = j[1], parts[j[2]], parts[j[3]], CFrame.new(toWorld(j[4]))
	local m = Instance.new("Motor6D")
	m.Name = name
	m.Part0 = p0
	m.Part1 = p1
	m.C0 = p0.CFrame:ToObjectSpace(pivot)
	m.C1 = p1.CFrame:ToObjectSpace(pivot)
	m.Parent = p0
end

-- Matches R6 Torso.BodyBackAttachment (0, 0, 0.5).
local att = Instance.new("Attachment")
att.Name = "BodyBackAttachment"
att.CFrame = mount.CFrame:ToObjectSpace(CFrame.new(toWorld(Vector3.new(0, 0, 0.5))))
att.Parent = mount

-- Mount's rest CFrame in Torso space; the animator uses it to place membranes.
local bind = Instance.new("CFrameValue")
bind.Name = "WingBind"
bind.Value = CFrame.new(EXPECT.WingMount) * mount.CFrame.Rotation
bind.Parent = mount

local acc = Instance.new("Accessory")
acc.Name = ID
acc.AccessoryType = Enum.AccessoryType.Back
mount.Name = "Handle"
for _, p in parts do p.Parent = acc end
local old = ServerStorage:FindFirstChild(ID)
if old then old:Destroy() end
acc.Parent = ServerStorage
model:Destroy()
print(ID .. " created in ServerStorage (11 parts, 10 Motor6Ds)")
-- In game (server): character.Humanoid:AddAccessory(game.ServerStorage["Dragonkin_Wings_02"]:Clone())
