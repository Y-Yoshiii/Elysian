WORLD OF ARTERIA — ACCESSORY PACK
=================================

1_RaceAccessories/   38 race accessories (horns, ears, tails, crests, fins…)
2_DragonWings/       Dragonkin_Wings_02 — articulated dragon wings (Motor6D rig)

All files use studs and the R6 rig from r6.rbxm. Import every GLB with the
3D Importer: Scale Unit = Stud, no rotation, into Workspace.

STEP 1 — Race accessories
  a. Import 1_RaceAccessories/Arteria_Accessories.glb
  b. Paste Arteria_Accessories_Setup.lua into the command bar and run it
     -> ServerStorage.ArteriaAccessories/<id>
  c. Put ArteriaAccessoryAnimator.client.lua in StarterPlayer > StarterPlayerScripts
     as a LocalScript (tails, ears, fins). Needs the GLB's skin/bones to survive import;
     it warns "has no Bones" if they didn't.

STEP 2 — Dragon wings
  a. Import 2_DragonWings/Arteria_DragonWings.glb
  b. Paste Arteria_DragonWings_Setup.lua into the command bar and run it
     -> ServerStorage.Dragonkin_Wings_02  (stops with an error if the import moved parts)
  c. Put ArteriaDragonWings.client.lua in StarterPlayer > StarterPlayerScripts
     as a LocalScript.
  d. From your flight script: character:SetAttribute("Flying", true)
     Optional: SetAttribute("WingState", "Folded"|"Idle"|"Glide"|"Flight"),
               SetAttribute("WingFlapRate", 1.3)

Equip (server): humanoid:AddAccessory(<accessory>:Clone())
Dragonkin_Wings_01 is intentionally not included — use Dragonkin_Wings_02.
None of this has been tested in Studio yet; report the Explorer tree if an import differs.
