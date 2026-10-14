-- ArteriaAccessoryAnimator — LocalScript, place in StarterPlayer > StarterPlayerScripts.
-- Client-only cosmetic animation for World of Arteria race accessories (wings, tails, ears, fins).
-- Drives Bone.Transform on the skinned accessories created by Arteria_Accessories_Setup.lua.
-- No RemoteEvents and no server state: every client animates the characters it can see.
-- Generated from the accessory preview page — regenerate rather than hand-editing the SPEC tables.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CONFIG = {
	-- Your flight system should set this attribute on the character model while flying.
	FlyingAttribute = "Flying",
	-- Treat falling/jumping as flying (wings flap on every jump). Off by default.
	FreefallCountsAsFlying = false,
	-- Seconds standing still before the "rest" pose (folded wings, curled tails).
	RestAfterSeconds = 6,
	-- Characters farther than this from the camera are not animated.
	MaxDistance = 150,
}

local function C(b, ax, ay, az, base, amp, f, p, ph, bi)
	return { b = b, ax = Vector3.new(ax, ay, az), base = base, amp = amp, f = f, p = p, ph = ph, bi = bi }
end

local SPEC = {}
local ANIM_1 = {
	blend = 0.7,
	states = {
		idle = { C("Tail#", 0, 1, 0, 0, 0.1, 0.35, 0, -0.7, 0) },
		walk = { C("Tail#", 0, 1, 0, 0, 0.16, 0.9, 0, -0.7, 0) },
		rest = { C("Tail#", 0, 1, 0, 0, 0.05, 0.18, 0, -0.5, 0), C("Tail#", 1, 0, 0, 0.05, 0, 0, 0, 0, 0) },
		fly = { C("Tail0", 1, 0, 0, -0.45, 0, 0, 0, 0, 0), C("Tail#", 1, 0, 0, 0, 0.07, 1.3, 0, -0.8, 0), C("Tail#", 0, 1, 0, 0, 0.04, 0.65, 0, -0.6, 0) },
	},
	events = {
		{ key = "tailFlick", every = { 8, 16 }, dur = 1.2, on = { idle = true, rest = true }, sides = false, shape = "wag", f = 1.6, ch = { C("Tail#", 0, 1, 0, 0, 0.18, 0, 0, -0.6, 0) } },
	},
}
SPEC["Dragonkin_Tail_01"] = ANIM_1

local ANIM_2 = {
	blend = 0.4,
	states = {
		idle = { C("Ear1", 0.9181, -0.2466, 0.3102, 0, 0.03, 0.3, 0, 0, 0) },
		walk = { C("Ear1", 0.9181, -0.2466, 0.3102, 0, 0.05, 1.9, 0, 0, 0), C("Ear2", 0.9181, -0.2466, 0.3102, 0, 0.06, 1.9, -0.8, 0, 0) },
		rest = { C("Ear1", 0.9181, -0.2466, 0.3102, 0.28, 0.02, 0.2, 0, 0, 0), C("Ear2", 0.9181, -0.2466, 0.3102, 0.12, 0, 0, 0, 0, 0) },
		fly = { C("Ear1", 0.9181, -0.2466, 0.3102, 0.6, 0, 0, 0, 0, 0), C("Ear2", 0.9181, -0.2466, 0.3102, 0.25, 0.05, 4, 0, 0, 0) },
	},
	events = {
		{ key = "earTwitch", every = { 2.5, 7 }, dur = 0.4, on = { idle = true, walk = true, rest = true }, sides = true, shape = "twitch", f = 0, ch = { C("Ear1", 0.9181, -0.2466, 0.3102, 0, 0.45, 0, 0, 0, 0), C("Ear2", 0.9181, -0.2466, 0.3102, 0, 0.35, 0, 0, 0, 0), C("Ear1", 0, 1, 0, 0, -0.25, 0, 0, 0, 0) } },
	},
}
SPEC["Beastkin_FoxEars_01"] = ANIM_2

local ANIM_3 = {
	blend = 0.4,
	states = {
		idle = { C("Ear1", 0.9642, -0.1366, 0.2271, 0, 0.03, 0.3, 0, 0, 0) },
		walk = { C("Ear1", 0.9642, -0.1366, 0.2271, 0, 0.05, 1.9, 0, 0, 0), C("Ear2", 0.9642, -0.1366, 0.2271, 0, 0.06, 1.9, -0.8, 0, 0) },
		rest = { C("Ear1", 0.9642, -0.1366, 0.2271, 0.28, 0.02, 0.2, 0, 0, 0), C("Ear2", 0.9642, -0.1366, 0.2271, 0.12, 0, 0, 0, 0, 0) },
		fly = { C("Ear1", 0.9642, -0.1366, 0.2271, 0.6, 0, 0, 0, 0, 0), C("Ear2", 0.9642, -0.1366, 0.2271, 0.25, 0.05, 4, 0, 0, 0) },
	},
	events = {
		{ key = "earTwitch", every = { 2.5, 7 }, dur = 0.4, on = { idle = true, walk = true, rest = true }, sides = true, shape = "twitch", f = 0, ch = { C("Ear1", 0.9642, -0.1366, 0.2271, 0, 0.45, 0, 0, 0, 0), C("Ear2", 0.9642, -0.1366, 0.2271, 0, 0.35, 0, 0, 0, 0), C("Ear1", 0, 1, 0, 0, -0.25, 0, 0, 0, 0) } },
	},
}
SPEC["Beastkin_WolfEars_01"] = ANIM_3

local ANIM_4 = {
	blend = 0.6,
	states = {
		idle = { C("Tail#", 0, 1, 0, 0, 0.12, 0.5, 0, -0.6, 0) },
		walk = { C("Tail#", 0, 1, 0, 0, 0.18, 1.1, 0, -0.7, 0), C("Tail#", 1, 0, 0, 0, 0.04, 2.2, 0, -0.5, 0) },
		rest = { C("Tail#", 0, 1, 0, 0.2, 0.03, 0.2, 0, -0.4, 0), C("Tail#", 1, 0, 0, 0.06, 0, 0, 0, 0, 0) },
		fly = { C("Tail0", 1, 0, 0, -0.35, 0, 0, 0, 0, 0), C("Tail#", 0, 1, 0, 0, 0.06, 1.4, 0, -0.8, 0) },
	},
	events = {
		{ key = "tailWag", every = { 5, 12 }, dur = 1.8, on = { idle = true, walk = true }, sides = false, shape = "wag", f = 2.6, ch = { C("Tail#", 0, 1, 0, 0, 0.3, 0, 0, -0.5, 0) } },
	},
}
SPEC["Beastkin_FoxTail_01"] = ANIM_4
SPEC["Beastkin_WolfTail_01"] = ANIM_4

local ANIM_5 = {
	blend = 0.5,
	states = {
		idle = {  },
		walk = { C("ElfEar2", 0, 1, 0, 0, 0.03, 1.9, 0, 0, 0) },
		rest = { C("ElfEar1", -0.9004, 0, 0.435, -0.06, 0, 0, 0, 0, 0) },
		fly = { C("ElfEar1", 0, 1, 0, 0.15, 0, 0, 0, 0, 0), C("ElfEar2", 0, 1, 0, 0, 0.04, 3, 0, 0, 0) },
	},
	events = {
		{ key = "elfEarTwitch", every = { 6, 14 }, dur = 0.35, on = { idle = true, walk = true, rest = true }, sides = true, shape = "twitch", f = 0, ch = { C("ElfEar1", 0, 1, 0, 0, 0.12, 0, 0, 0, 0), C("ElfEar2", 0, 1, 0, 0, 0.16, 0, 0, 0, 0) } },
	},
}
SPEC["Elf_PointEars_01"] = ANIM_5
SPEC["Elf_EarCuffs_01"] = ANIM_5

local ANIM_6 = {
	blend = 0.5,
	states = {
		idle = { C("Fin1", 0, 1, 0, 0, 0.06, 0.45, 0, 0, 0), C("Fin2", 0, 1, 0, 0, 0.1, 0.9, -0.8, 0, 0) },
		walk = { C("Fin1", 0, 1, 0, 0, 0.06, 0.9, 0, 0, 0), C("Fin2", 0, 1, 0, 0, 0.12, 1.8, -0.8, 0, 0) },
		rest = { C("Fin1", 0, 1, 0, -0.12, 0, 0, 0, 0, 0), C("Fin2", 0, 1, 0, 0, 0.04, 0.3, 0, 0, 0) },
		fly = { C("Fin1", 0, 1, 0, -0.2, 0, 0, 0, 0, 0), C("Fin2", 0, 1, 0, 0, 0.1, 2.2, 0, 0, 0) },
	},
	events = {
		{ key = "finFlare", every = { 4, 10 }, dur = 0.6, on = { idle = true, walk = true, rest = true }, sides = true, shape = "twitch", f = 0, ch = { C("Fin1", 0, 1, 0, 0, 0.35, 0, 0, 0, 0), C("Fin2", 0, 1, 0, 0, 0.15, 0, 0, 0, 0) } },
	},
}
SPEC["Tideborn_EarFins_01"] = ANIM_6

local ANIM_7 = {
	blend = 0.5,
	states = {
		idle = { C("Crest#", 0, 0, 1, 0, 0.08, 0.7, 0, 0.6, 0) },
		walk = { C("Crest#", 0, 0, 1, 0, 0.1, 1.2, 0, 0.6, 0) },
		rest = { C("Crest#", 0, 0, 1, 0, 0.03, 0.25, 0, 0.5, 0) },
		fly = { C("Crest#", 1, 0, 0, 0.15, 0, 0, 0, 0, 0), C("Crest#", 0, 0, 1, 0, 0.12, 1.8, 0, 0.6, 0) },
	},
	events = {

	},
}
SPEC["Tideborn_SeaCrest_01"] = ANIM_7

local ANIM_8 = {
	blend = 0.6,
	states = {
		idle = { C("Tail#", 1, 0, 0, 0, 0.1, 0.55, 0, -0.9, 0) },
		walk = { C("Tail#", 1, 0, 0, 0, 0.14, 1, 0, -0.9, 0), C("Tail#", 0, 1, 0, 0, 0.04, 1, 0, -0.7, 0) },
		rest = { C("Tail#", 1, 0, 0, 0, 0.04, 0.2, 0, -0.7, 0), C("Tail#", 0, 1, 0, 0.06, 0, 0, 0, 0, 0) },
		fly = { C("Tail0", 1, 0, 0, -0.3, 0, 0, 0, 0, 0), C("Tail#", 1, 0, 0, 0, 0.18, 1.6, 0, -1, 0) },
	},
	events = {
		{ key = "tailFlick", every = { 7, 14 }, dur = 1, on = { idle = true, rest = true }, sides = false, shape = "wag", f = 2, ch = { C("Tail#", 1, 0, 0, 0, 0.15, 0, 0, -0.9, 0) } },
	},
}
SPEC["Tideborn_Tail_01"] = ANIM_8

local ANIM_9 = {
	blend = 0.5,
	states = {
		idle = { C("ArmFin1", 0, -1, 0, 0, 0.08, 0.5, 0, 0, 0), C("ArmFin2", 0, -1, 0, 0, 0.12, 0.9, -0.8, 0, 0) },
		walk = { C("ArmFin1", 0, -1, 0, 0, 0.12, 1.4, 0, 0, 0), C("ArmFin2", 0, -1, 0, 0, 0.15, 1.4, -0.8, 0, 0) },
		rest = { C("ArmFin1", 0, -1, 0, -0.35, 0, 0, 0, 0, 0), C("ArmFin2", 0, -1, 0, 0, 0.03, 0.3, 0, 0, 0) },
		fly = { C("ArmFin1", 0, -1, 0, 0.2, 0, 0, 0, 0, 0), C("ArmFin2", 0, -1, 0, 0, 0.12, 2.2, 0, 0, 0) },
	},
	events = {

	},
}
SPEC["Tideborn_ForearmFins_R_01"] = ANIM_9
SPEC["Tideborn_ForearmFins_L_01"] = ANIM_9

local STATE_ORDER = { "idle", "walk", "rest", "fly" }
local TAU = math.pi * 2
local IDENTITY = CFrame.identity
local rng = Random.new()

local tracked = {} -- [Accessory] = record
local characters = {} -- [Model] = { idleSince, state, visible, events }

-- Pattern "Tail#" matches Tail0, Tail1… (index = digits); otherwise exact base name.
-- Bones ending in _L are mirrored across X, so their rotation axis is mirrored too.
local function resolve(bones, pattern, axis)
	local out = {}
	local prefix = pattern:match("^(.-)#$")
	for _, bone in bones do
		local base, side = bone.Name:match("^(.-)_([RL])$")
		base = base or bone.Name
		local idx
		if prefix then
			local digits = base:sub(#prefix + 1)
			if base:sub(1, #prefix) == prefix and digits:match("^%d+$") then
				idx = tonumber(digits)
			end
		elseif base == pattern then
			idx = 0
		end
		if idx then
			local ax = side == "L" and Vector3.new(axis.X, -axis.Y, -axis.Z) or axis
			table.insert(out, { bone = bone, idx = idx, side = side, ax = ax })
		end
	end
	return out
end

local function envelope(ev, u, t, idx, ph)
	if ev.shape == "wag" then
		return math.sin(math.pi * u) * math.sin(TAU * ev.f * t + ph * idx)
	end
	if u < 0.25 then
		return math.sin((u / 0.25) * math.pi / 2)
	end
	return math.cos(((u - 0.25) / 0.75) * math.pi / 2)
end

local function untrack(accessory)
	local rec = tracked[accessory]
	if not rec then return end
	for _, bone in rec.bones do
		if bone.Parent then bone.Transform = IDENTITY end
	end
	tracked[accessory] = nil
end

local function track(accessory, character)
	local spec = SPEC[accessory.Name]
	if not spec or tracked[accessory] or accessory.Parent ~= character then return end
	local bones = {}
	for _, d in accessory:GetDescendants() do
		if d:IsA("Bone") then table.insert(bones, d) end
	end
	if #bones == 0 then
		warn(("[ArteriaAccessoryAnimator] %s on %s has no Bones; re-import the GLB so skinning is kept"):format(accessory.Name, character.Name))
		return
	end
	local rec = { character = character, bones = bones, pose = {}, weights = { idle = 1, walk = 0, rest = 0, fly = 0 }, states = {}, events = {} }
	for _, name in STATE_ORDER do
		local list = {}
		for _, ch in spec.states[name] or {} do
			table.insert(list, { ch = ch, targets = resolve(bones, ch.b, ch.ax) })
		end
		rec.states[name] = list
	end
	for _, ev in spec.events or {} do
		local chans = {}
		for _, ch in ev.ch do
			table.insert(chans, { ch = ch, targets = resolve(bones, ch.b, ch.ax) })
		end
		table.insert(rec.events, { ev = ev, chans = chans })
	end
	tracked[accessory] = rec
	if not characters[character] then
		characters[character] = { idleSince = os.clock(), state = "idle", visible = true, events = {} }
	end
end

local function watchCharacter(character)
	for _, child in character:GetChildren() do
		if child:IsA("Accessory") then track(child, character) end
	end
	-- Deferred so welds/bones parented in the same frame as the accessory exist when we scan.
	character.ChildAdded:Connect(function(child)
		if child:IsA("Accessory") then task.defer(track, child, character) end
	end)
	character.ChildRemoved:Connect(function(child)
		untrack(child)
	end)
end

local function watchPlayer(player)
	if player.Character then watchCharacter(player.Character) end
	player.CharacterAdded:Connect(watchCharacter)
end
for _, player in Players:GetPlayers() do watchPlayer(player) end
Players.PlayerAdded:Connect(watchPlayer)

local function updateCharacter(character, cs, now, cameraPosition)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character.PrimaryPart
	if not humanoid or not root then
		cs.visible = false
		return
	end
	local humanoidState = humanoid:GetState()
	local flying = character:GetAttribute(CONFIG.FlyingAttribute) == true
		or humanoidState == Enum.HumanoidStateType.Flying
		or (CONFIG.FreefallCountsAsFlying and humanoidState == Enum.HumanoidStateType.Freefall)
	local moving = humanoid.MoveDirection.Magnitude > 0.1 and humanoid.FloorMaterial ~= Enum.Material.Air
	if flying or moving then cs.idleSince = now end
	if flying then
		cs.state = "fly"
	elseif moving then
		cs.state = "walk"
	elseif now - cs.idleSince > CONFIG.RestAfterSeconds then
		cs.state = "rest"
	else
		cs.state = "idle"
	end
	cs.visible = (root.Position - cameraPosition).Magnitude < CONFIG.MaxDistance
end

local function updateAccessory(rec, cs, now, dt)
	local state = cs.state
	local pose = rec.pose
	for _, bone in rec.bones do pose[bone] = IDENTITY end

	local rate = dt / rec.blend
	for _, name in STATE_ORDER do
		local target = name == state and 1 or 0
		local wgt = rec.weights[name]
		rec.weights[name] = wgt + math.clamp(target - wgt, -rate, rate)
	end

	for _, name in STATE_ORDER do
		local wgt = rec.weights[name]
		if wgt > 0.001 then
			for _, entry in rec.states[name] do
				local ch = entry.ch
				for _, t in entry.targets do
					local angle = wgt * (ch.base + ch.bi * t.idx + ch.amp * math.sin(TAU * ch.f * now + ch.p + ch.ph * t.idx))
					pose[t.bone] = pose[t.bone] * CFrame.fromAxisAngle(t.ax, angle)
				end
			end
		end
	end

	-- Events (ear twitches, tail wags) share one schedule per character via ev.key,
	-- so paired accessories (e.g. elf ears + ear cuffs) twitch together.
	for _, entry in rec.events do
		local ev = entry.ev
		local s = cs.events[ev.key]
		if not s then
			s = { next = now + rng:NextNumber(ev.every[1], ev.every[2]), start = -1e9, side = "B" }
			cs.events[ev.key] = s
		end
		if now >= s.next and now - s.start > ev.dur then
			if ev.on[state] then
				s.start = now
				s.side = ev.sides and ({ "R", "L", "B" })[rng:NextInteger(1, 3)] or "B"
			end
			s.next = now + ev.dur + rng:NextNumber(ev.every[1], ev.every[2])
		end
		local u = (now - s.start) / ev.dur
		if u >= 0 and u <= 1 then
			for _, chan in entry.chans do
				for _, t in chan.targets do
					if not t.side or s.side == "B" or s.side == t.side then
						local angle = chan.ch.amp * envelope(ev, u, now - s.start, t.idx, chan.ch.ph)
						pose[t.bone] = pose[t.bone] * CFrame.fromAxisAngle(t.ax, angle)
					end
				end
			end
		end
	end

	for bone, cf in pose do bone.Transform = cf end
end

RunService.RenderStepped:Connect(function(dt)
	local now = os.clock()
	local camera = Workspace.CurrentCamera
	if not camera then return end
	local cameraPosition = camera.CFrame.Position
	for character, cs in characters do
		if character.Parent then
			updateCharacter(character, cs, now, cameraPosition)
		else
			characters[character] = nil
		end
	end
	for accessory, rec in tracked do
		local cs = characters[rec.character]
		if not accessory.Parent or not cs then
			tracked[accessory] = nil
		elseif cs.visible then
			if not rec.blend then rec.blend = SPEC[accessory.Name].blend end
			updateAccessory(rec, cs, now, math.min(dt, 0.1))
		end
	end
end)
