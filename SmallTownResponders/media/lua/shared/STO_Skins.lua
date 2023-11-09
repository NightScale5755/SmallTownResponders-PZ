local vehicleToSkin = {}
--Enum of zone names, so we can change them easily + intellisense
local ZoneName = {
	Default = "Meade",
	Meade = "Meade",
	KSP = "KSP",
	Muldraugh = "Muldraugh",
	Rosewood = "Rosewood",
	WestPoint = "WestPoint",
	Riverside = "Riverside",
	Louisville = "Louisville",
	LouisvillePD = "LouisvillePD",
	JeffersonPD = "JeffersonPD",
	JeffersonSD = "JeffersonSD",
	Jefferson = "Jefferson",
	RavenCreek = "RavenCreek",
	Tandil = "Tandil",
	Greenport  = "Greenport "
}

---Like DoParam but for vehicles
---@param vehicle string Name of the vehicle script
---@param param string The parameter(s) to apply to this script
---@param module string Optional: the module of the vehicle
---@see Item#DoParam
---@see VehicleScript#Load
local DoVehicleParam = function(vehicle, param, module)
	module = module or "Base"
	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then return false end
	vehicleScript:Load(vehicle, "{" .. param .. "}")
	return true
end

---Utility to add new skins to vehicles
---@param vehicle string Name of the vehicle script
---@param texture string The new skin's texture
---@see DoVehicleParam
local AddVehicleSkin = function(vehicle, zone, texture, module)
	module = module or "Base"

	if not DoVehicleParam(vehicle, "skin { texture = " .. texture .. ",}", module) then return end
	local fullName = module .. "." .. vehicle
	local newSkinNum = ScriptManager.instance:getVehicle(fullName):getSkinCount() - 1

	vehicleToSkin[fullName] = vehicleToSkin[fullName] or {}
	local zoneSkins = vehicleToSkin[fullName][zone]
	if zoneSkins then
		if type(zoneSkins) ~= "table" then -- convert to random picker table if a skin already exists
			zoneSkins = {zoneSkins}
			vehicleToSkin[fullName][zone] = zoneSkins
		end
		table.insert(zoneSkins, newSkinNum)
	else
		vehicleToSkin[fullName][zone] = newSkinNum
	end
end

---Adds a new skin to a vehicle and adds it to the replace table NOTE: this currently stops zone overrides from working on that vehicle
---@param vehicle string Name of the vehicle script
---@param texture string The new skin's texture
---@param replace int The skin number to replace. Only stable if overriding vanilla skins/skins from the mod that adds the vehicle
---@param module string Optional: the module of the vehicle
---@see AddVehicleSkin
---@see DoVehicleParam
local AddVehicleSkinOverride = function(vehicle, replace, texture, module)
	module = module or "Base"

	if not DoVehicleParam(vehicle, "skin { texture = " .. texture .. ",}", module) then return end

	local fullName = module .. "." .. vehicle
	vehicleToSkin[fullName] = vehicleToSkin[fullName] or {}
	vehicleToSkin[fullName].Replace = vehicleToSkin[fullName].Replace or {}
	vehicleToSkin[fullName].Replace[replace] = ScriptManager.instance:getVehicle(fullName):getSkinCount() - 1
end

---Utility to change the siren sound of a vehicle
---@param vehicle string Name of the vehicle script
---@param sound string Name of a sound
---@see DoVehicleParam
local SetSirenSound = function(vehicle, sound)
	DoVehicleParam(vehicle, "lightbar { soundSiren = " .. sound .. ",}")
end

---Utility to change the horn sound of a vehicle
---@param vehicle string Name of the vehicle script
---@param sound string Name of a sound
---@see DoVehicleParam
---@see SetSirenSound
local SetHornSound = function(vehicle, sound)
	DoVehicleParam(vehicle, "sound { horn = " .. sound .. ",}")
end

---Sets a vehicle to use police zones instead of regular zones. Slower but needed for police
local SetPoliceVehicle = function(vehicle, module)
	module = module or "Base"
	local fullName = module .. "." .. vehicle
	vehicleToSkin[fullName] = vehicleToSkin[fullName] or {}
	vehicleToSkin[fullName].Police = true
end

---Utility to change the radio of a vehicle
---@param vehicle string Name of the vehicle script
---@param radio string Name of a radio template
---@see DoVehicleParam
---@see SetSirenSound
local SetRadioType = function(vehicle, radio)
	DoVehicleParam(vehicle, "template = " .. radio .. ",")
end

if getActivatedMods():contains("Time_Accurate_Sirens") then

	SetSirenSound("CarLightsPolice","MovieSiren");
	SetSirenSound("PickUpVanLightsPolice","MovieSiren");

end

if getActivatedMods():contains("VVehicleEnhancer") and getActivatedMods():contains("Time_Accurate_Sirens") then

	SetSirenSound("CarLightsSheriff","MovieSiren");
	SetSirenSound("CarLightsStatepolice","MovieSiren");

end

if getActivatedMods():contains("SirenVariety") then

	--SetHornSound("85vicsheriff","BullHorn");
	--SetHornSound("92crownvicPD","BullHorn");
	--SetHornSound("91blazerpd","BullHorn");
	--SetHornSound("87capricePD","BullHorn");
	--SetHornSound("86econolineswat_louisvillepd","BullHorn");
	--SetHornSound("86econolineswat_jeffersonpd","BullHorn");
	--SetHornSound("VanSwat_jeffersonpd","BullHorn");
	--SetHornSound("VanSwat_louisvillepd","BullHorn");
	--SetHornSound("VanSwat_ravencreekpd","BullHorn");
	--SetHornSound("80f350ambulance","BullHorn");
	--SetHornSound("86econolineambulance","BullHorn");
	--SetHornSound("firepumper","AirHorn");
	--SetHornSound("87c10fire","AirHorn");

	--SetSirenSound("80f350ambulance","EmsSiren");
	--SetSirenSound("86econolineambulance","EmsSiren");
	--SetSirenSound("firepumper","FireSiren");
	--SetSirenSound("87c10fire","FireSiren");

end

if getActivatedMods():contains("VVehicleEnhancer") and getActivatedMods():contains("SirenVariety") then

end

if not getActivatedMods():contains("VVehicleEnhancer") and not getActivatedMods():contains("SCKCO") then

	SetPoliceVehicle("CarLightsPolice")
	SetPoliceVehicle("PickUpVanLightsPolice")

	AddVehicleSkin("CarLightsPolice", ZoneName.KSP, "Vehicles/vehicle_kentuckystate")
	AddVehicleSkin("CarLightsPolice", ZoneName.Meade, "Vehicles/vehicle_meadesheriff")
	AddVehicleSkin("CarLightsPolice", ZoneName.Rosewood, "Vehicles/vehicle_rosewoodpolice")
	AddVehicleSkin("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_westpointpolice1")
	AddVehicleSkin("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_westpointpolice2")
	AddVehicleSkin("CarLightsPolice", ZoneName.Muldraugh, "Vehicles/vehicle_muldraughpolice")
	AddVehicleSkin("CarLightsPolice", ZoneName.Riverside, "Vehicles/vehicle_riversidepolice")
	AddVehicleSkin("CarLightsPolice", ZoneName.LouisvillePD, "Vehicles/vehicle_louisvillepolice")
	AddVehicleSkin("CarLightsPolice", ZoneName.JeffersonPD, "Vehicles/vehicle_jeffersonpolice")
	AddVehicleSkin("CarLightsPolice", ZoneName.JeffersonSD, "Vehicles/vehicle_jeffersonsheriff")

	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.KSP, "Vehicles/vehicle_pickup_ksp");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Meade, "Vehicles/vehicle_pickup_meadesheriff");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Rosewood, "Vehicles/vehicle_pickup_rosewoodsheriff");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_pickup_westpointpolice1");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_pickup_westpointpolice2");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Muldraugh, "Vehicles/vehicle_pickup_muldraughpolice");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Riverside, "Vehicles/vehicle_pickup_riversidepolice");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.LouisvillePD, "Vehicles/vehicle_pickup_louisvillepolice");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.JeffersonPD, "Vehicles/vehicle_pickup_jeffersonpolice");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.JeffersonSD, "Vehicles/vehicle_pickup_jeffersonsheriff");

	AddVehicleSkin("VanAmbulance", ZoneName.Meade, "Vehicles/vehicle_van_meadecountyambulance");
	AddVehicleSkin("VanAmbulance", ZoneName.Louisville, "Vehicles/vehicle_van_louisvilleambulance");
	AddVehicleSkin("VanAmbulance", ZoneName.Jefferson, "Vehicles/vehicle_van_jeffersoncountyambulance");

	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_pickupfireshell_rosewood");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Meade, "Vehicles/vehicle_pickupfireshell_meade");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Louisville, "Vehicles/vehicle_pickupfireshell_louisville");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_pickupfireshell_meade");

	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_pickupfireshell_rosewood");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Meade, "Vehicles/vehicle_pickuptruckfireshell_meade");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Louisville, "Vehicles/vehicle_pickupfireshell_louisville");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_pickuptruckfireshell_meade");

	AddVehicleSkin("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_pickup_stateparkranger");
	AddVehicleSkin("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_pickup_fishandwildlife");
	AddVehicleSkin("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_pickup_nationalparkservice");

	AddVehicleSkin("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_pickup_stateparkranger");
	AddVehicleSkin("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_pickup_fishandwildlife");
	AddVehicleSkin("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_pickup_nationalparkservice");

	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vehicle_carnormal_stateparkranger");
	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vehicle_carnormal_fishandwildlife");
	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vehicle_carnormal_nationalparkservice");

	AddVehicleSkin("StepVanMail", ZoneName.Default, "Vehicles/vehicle_stepvan_uspsmailshell");

	AddVehicleSkinOverride("VanSpecial", 2, "Vehicles/vehicle_van_uspsmailvan");

	if getActivatedMods():contains("RavenCreek") or getActivatedMods():contains("10YL_RC") then

		AddVehicleSkin("CarLightsPolice", ZoneName.RavenCreek, "Vehicles/vehicle_ravencreekpolice");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.RavenCreek, "Vehicles/vehicle_pickup_ravencreekpolice");

		AddVehicleSkin("VanAmbulance", ZoneName.RavenCreek, "Vehicles/vehicle_van_ravencreekambulance");

		AddVehicleSkin("PickUpTruckLightsFire", ZoneName.RavenCreek, "Vehicles/vehicle_pickupfireshell_ravencreek");

		AddVehicleSkin("PickUpVanLightsFire", ZoneName.RavenCreek, "Vehicles/vehicle_pickuptruckfireshell_ravencreek");

	end
	if getActivatedMods():contains("Tandil") then

		AddVehicleSkin("CarLightsPolice", ZoneName.Tandil, "Vehicles/vehicle_tandilpolice");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Tandil, "Vehicles/vehicle_pickup_tandilpolice");

		AddVehicleSkin("VanAmbulance", ZoneName.Tandil, "Vehicles/vehicle_van_tandilambulance");

		AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Tandil, "Vehicles/vehicle_pickupfireshell_tandil");
		AddVehicleSkin("PickUpVanLightsFire", ZoneName.Tandil, "Vehicles/vehicle_pickupfireshell_tandil");

	end
	if getActivatedMods():contains("Greenport") then

		AddVehicleSkin("CarLightsPolice", ZoneName.Greenport, "Vehicles/vehicle_greenportpolice");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Greenport, "Vehicles/vehicle_pickup_greenportpolice");

	end
end
if getActivatedMods():contains("FRUsedCars") then

	SetRadioType("chevystepvanswat","Radio_HAM");
	SetRadioType("85vicsheriff","Radio_HAM");
	SetRadioType("92crownvicPD","Radio_HAM");
	SetRadioType("91blazerpd","Radio_HAM");
	SetRadioType("87capricePD","Radio_HAM");
	SetRadioType("87c10fire","Radio_HAM");
	SetRadioType("firepumper","Radio_HAM");
	SetRadioType("86econolineambulance","Radio_HAM");
	SetRadioType("80f350ambulance","Radio_HAM");

	SetPoliceVehicle("chevystepvanswat")

	SetPoliceVehicle("85vicsheriff")
	AddVehicleSkin("85vicsheriff", ZoneName.KSP, "Vehicles/vehicle_85crownvic_kentuckystatepoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.Meade, "Vehicles/vehicle_85crownvic_meadesheriffshell");
	AddVehicleSkin("85vicsheriff", ZoneName.Rosewood, "Vehicles/vehicle_85crownvic_rosewoodpoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.WestPoint, "Vehicles/vehicle_85crownvic_westpointpoliceshell1");
	AddVehicleSkin("85vicsheriff", ZoneName.WestPoint, "Vehicles/vehicle_85crownvic_westpointpoliceshell2");
	AddVehicleSkin("85vicsheriff", ZoneName.Muldraugh, "Vehicles/vehicle_85crownvic_muldraughpoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.Riverside, "Vehicles/vehicle_85crownvic_riversidepoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.LouisvillePD, "Vehicles/vehicle_85crownvic_lousvillepoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.JeffersonPD, "Vehicles/vehicle_85crownvic_jeffersonpoliceshell");
	AddVehicleSkin("85vicsheriff", ZoneName.JeffersonSD, "Vehicles/vehicle_85crownvic_jeffersonsheriffshell");

	SetPoliceVehicle("92crownvicPD")
	AddVehicleSkin("92crownvicPD", ZoneName.KSP, "Vehicles/vehicle_92crownvic_kentuckystatepoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.Meade, "Vehicles/vehicle_92crownvic_meadesheriffshell");
	AddVehicleSkin("92crownvicPD", ZoneName.Rosewood, "Vehicles/vehicle_92crownvic_rosewoodpoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.WestPoint, "Vehicles/vehicle_92crownvic_westpoliceshell1");
	AddVehicleSkin("92crownvicPD", ZoneName.WestPoint, "Vehicles/vehicle_92crownvic_westpoliceshell2");
	AddVehicleSkin("92crownvicPD", ZoneName.Muldraugh, "Vehicles/vehicle_92crownvic_muldraughpoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.Riverside, "Vehicles/vehicle_92crownvic_riversidepoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.LouisvillePD, "Vehicles/vehicle_92crownvic_louisvillepoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.JeffersonPD, "Vehicles/vehicle_92crownvic_jeffersonpoliceshell");
	AddVehicleSkin("92crownvicPD", ZoneName.JeffersonSD, "Vehicles/vehicle_92crownvic_jeffersoncountysheriffshell");

	SetPoliceVehicle("91blazerpd")
	AddVehicleSkin("91blazerpd", ZoneName.KSP, "Vehicles/vehicle_blazer_kspshell");
	AddVehicleSkin("91blazerpd", ZoneName.Meade, "Vehicles/vehicle_blazer_meadesheriffshell");
	AddVehicleSkin("91blazerpd", ZoneName.Rosewood, "Vehicles/vehicle_blazer_rosewoodpoliceshell");
	AddVehicleSkin("91blazerpd", ZoneName.WestPoint, "Vehicles/vehicle_blazer_westpointpoliceshell1");
	AddVehicleSkin("91blazerpd", ZoneName.WestPoint, "Vehicles/vehicle_blazer_westpointpoliceshell2");
	AddVehicleSkin("91blazerpd", ZoneName.Muldraugh, "Vehicles/vehicle_blazer_muldraughpoliceshell");
	AddVehicleSkin("91blazerpd", ZoneName.Riverside, "Vehicles/vehicle_blazer_riversidepoliceshell");
	AddVehicleSkin("91blazerpd", ZoneName.LouisvillePD, "Vehicles/vehicle_blazer_louisvillepoliceshell");
	AddVehicleSkin("91blazerpd", ZoneName.JeffersonPD, "Vehicles/vehicle_blazer_jeffersoncountypoliceshell");
	AddVehicleSkin("91blazerpd", ZoneName.JeffersonSD, "Vehicles/vehicle_blazer_jeffersoncountysheriffshell");

	SetPoliceVehicle("87capricePD")
	AddVehicleSkin("87capricePD", ZoneName.KSP, "Vehicles/vehicle_87caprice_kspshell");
	AddVehicleSkin("87capricePD", ZoneName.Meade, "Vehicles/vehicle_87caprice_meadesheriffshell");
	AddVehicleSkin("87capricePD", ZoneName.Rosewood, "Vehicles/vehicle_87caprice_rosewoodpoliceshell");
	AddVehicleSkin("87capricePD", ZoneName.WestPoint, "Vehicles/vehicle_87caprice_westpointpoliceshell1");
	AddVehicleSkin("87capricePD", ZoneName.WestPoint, "Vehicles/vehicle_87caprice_westpointpoliceshell2");
	AddVehicleSkin("87capricePD", ZoneName.Muldraugh, "Vehicles/vehicle_87caprice_muldraughpoliceshell");
	AddVehicleSkin("87capricePD", ZoneName.Riverside, "Vehicles/vehicle_87caprice_riversidepoliceshell");
	AddVehicleSkin("87capricePD", ZoneName.LouisvillePD, "Vehicles/vehicle_87caprice_louisvillepoliceshell");
	AddVehicleSkin("87capricePD", ZoneName.JeffersonPD, "Vehicles/vehicle_87caprice_jeffersonpoliceshell");
	AddVehicleSkin("87capricePD", ZoneName.JeffersonSD, "Vehicles/vehicle_87caprice_jeffersonsheriffshell");

	AddVehicleSkin("80f350ambulance", ZoneName.Meade, "Vehicles/vehicle_80f350_meadecountyambulanceshell");
	AddVehicleSkin("80f350ambulance", ZoneName.Louisville, "Vehicles/vehicle_80f350_louisvilleambulanceshell");
	AddVehicleSkin("80f350ambulance", ZoneName.Jefferson, "Vehicles/vehicle_80f350_jeffersoncountyambulanceshell");

	AddVehicleSkin("86econolineambulance", ZoneName.Meade, "Vehicles/vehicle_86econoline_meadecountyambulanceshell");
	AddVehicleSkin("86econolineambulance", ZoneName.Louisville, "Vehicles/vehicle_86econoline_louisvilleambulanceshell");
	AddVehicleSkin("86econolineambulance", ZoneName.Jefferson, "Vehicles/vehicle_86econoline_jeffersoncountyambulanceshell");

	AddVehicleSkin("firepumper", ZoneName.Rosewood, "Vehicles/vehicle_firepumper_rosewood");
	AddVehicleSkin("firepumper", ZoneName.Meade, "Vehicles/vehicle_firepumper_meade");
	AddVehicleSkin("firepumper", ZoneName.Louisville, "Vehicles/vehicle_firepumper_louisville");
	AddVehicleSkin("firepumper", ZoneName.Rosewood, "Vehicles/vehicle_firepumper_meade");

	AddVehicleSkin("87c10fire", ZoneName.Rosewood, "Vehicles/vehicle_c10_utility_rosewood_fireshell");
	AddVehicleSkin("87c10fire", ZoneName.Meade, "Vehicles/vehicle_c10_utility_meade_fireshell");
	AddVehicleSkin("87c10fire", ZoneName.Louisville, "Vehicles/vehicle_c10_utility_louisville_fireshell");
	AddVehicleSkin("87c10fire", ZoneName.Rosewood, "Vehicles/vehicle_c10_utility_meade_fireshell");

	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/vehicle_92wrangler_stateparkrangershell");
	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/vehicle_92wrangler_fishandwidlifeshell");
	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/vehicle_92wrangler_nationalparkserviceshell");

	AddVehicleSkin("85vicranger", ZoneName.Default, "Vehicles/vehicle_85crownvic_nationalparkserviceshell");
	AddVehicleSkin("85vicranger", ZoneName.Default, "Vehicles/vehicle_85crownvic_fishandwildlifeshell");
	AddVehicleSkin("85vicranger", ZoneName.Default, "Vehicles/vehicle_85crownvic_stateparkrangershell");

	AddVehicleSkin("schoolbus", ZoneName.Meade, "Vehicles/vehicle_meadeschoolbusshell");
	AddVehicleSkin("schoolbus", ZoneName.Louisville, "Vehicles/vehicle_jeffersonschoolbusshell");
	AddVehicleSkin("schoolbus", ZoneName.Jefferson, "Vehicles/vehicle_jeffersonschoolbusshell");

	AddVehicleSkin("schoolbusshort", ZoneName.Meade, "Vehicles/vehicle_meadeschoolbusshell");
	AddVehicleSkin("schoolbusshort", ZoneName.Louisville, "Vehicles/vehicle_jeffersonschoolbusshell");
	AddVehicleSkin("schoolbusshort", ZoneName.Jefferson, "Vehicles/vehicle_jeffersonschoolbusshell");

	if getActivatedMods():contains("RavenCreek") or getActivatedMods():contains("10YL_RC") then

		AddVehicleSkin("chevystepvanswat", ZoneName.RavenCreek, "Vehicles/vehicle_stepvanchevyravencreekpoliceshell");
		AddVehicleSkin("85vicsheriff", ZoneName.RavenCreek, "Vehicles/vehicle_85crownvic_ravencreekpoliceshell");
		AddVehicleSkin("92crownvicPD", ZoneName.RavenCreek, "Vehicles/vehicle_92crownvic_ravencreekpoliceshell");
		AddVehicleSkin("91blazerpd", ZoneName.RavenCreek, "Vehicles/vehicle_blazer_ravencreekpoliceshell");
		AddVehicleSkin("87capricePD", ZoneName.RavenCreek, "Vehicles/vehicle_87caprice_ravencreekpoliceshell");
		AddVehicleSkin("87c10fire", ZoneName.RavenCreek, "Vehicles/vehicle_c10_utility_ravencreek_fireshell");
		AddVehicleSkin("firepumper", ZoneName.RavenCreek, "Vehicles/vehicle_firepumper_ravencreek");
		AddVehicleSkin("86econolineambulance", ZoneName.RavenCreek, "Vehicles/vehicle_86econoline_ravencreekambulanceshell");
		AddVehicleSkin("80f350ambulance", ZoneName.RavenCreek, "Vehicles/vehicle_80f350_ravencreekambulanceshell");

		AddVehicleSkin("schoolbus", ZoneName.RavenCreek, "Vehicles/vehicle_ravencreekschoolbusshell");

		AddVehicleSkin("schoolbusshort", ZoneName.RavenCreek, "Vehicles/vehicle_ravencreekschoolbusshell");

	end
	if getActivatedMods():contains("Tandil") then

		--	AddVehicleSkin("chevystepvanswat", ZoneName.Tandil, "Vehicles/vehicle_stepvanchevyravencreekpoliceshell");
		AddVehicleSkin("85vicsheriff", ZoneName.Tandil, "Vehicles/vehicle_85crownvic_tandilpoliceshell");
		AddVehicleSkin("92crownvicPD", ZoneName.Tandil, "Vehicles/vehicle_92crownvic_tandilpoliceshell");
		AddVehicleSkin("91blazerpd", ZoneName.Tandil, "Vehicles/vehicle_blazer_tandilpoliceshell");
		AddVehicleSkin("87capricePD", ZoneName.Tandil, "Vehicles/vehicle_87caprice_tandilpoliceshell");
		AddVehicleSkin("87c10fire", ZoneName.Tandil, "Vehicles/vehicle_c10_utility_tandil_fireshell");
		AddVehicleSkin("firepumper", ZoneName.Tandil, "Vehicles/vehicle_firepumper_tandil");
		AddVehicleSkin("86econolineambulance", ZoneName.Tandil, "Vehicles/vehicle_86econoline_tandilambulanceshell");
		AddVehicleSkin("80f350ambulance", ZoneName.Tandil, "Vehicles/vehicle_80f350_tandilambulanceshell");

		AddVehicleSkin("schoolbus", ZoneName.Tandil, "Vehicles/vehicle_tandilschoolbusshell");

		AddVehicleSkin("schoolbusshort", ZoneName.Tandil, "Vehicles/vehicle_tandilschoolbusshell");

	end
	if getActivatedMods():contains("Greenport") then

		--	AddVehicleSkin("chevystepvanswat", ZoneName.Greenport, "Vehicles/vehicle_stepvanchevyravencreekpoliceshell");
		AddVehicleSkin("85vicsheriff", ZoneName.Greenport, "Vehicles/vehicle_85crownvic_greenportpoliceshell");
		AddVehicleSkin("92crownvicPD", ZoneName.Greenport, "Vehicles/vehicle_92crownvic_greenportpoliceshell");
		AddVehicleSkin("91blazerpd", ZoneName.Greenport, "Vehicles/vehicle_blazer_greenportpoliceshell");
		AddVehicleSkin("87capricePD", ZoneName.Greenport, "Vehicles/vehicle_87caprice_greenportpoliceshell");

	end
	if getActivatedMods():contains("SimonMDLVInternationalAirport") then

		--AddVehicleSkin("firepumper", ZoneName.Tandil, "Vehicles/vehicle_firepumper_louisville_airport");

	end
end
if getActivatedMods():contains("VVehicleEnhancer") and not getActivatedMods():contains("SCKCO") then

	SetPoliceVehicle("CarLightsPolice")
	SetPoliceVehicle("PickUpVanLightsPolice")

	AddVehicleSkin("CarLightsPolice", ZoneName.KSP, "Vehicles/vve/vehicle_kentuckystate_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.Meade, "Vehicles/vve/vehicle_meade_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.Rosewood, "Vehicles/vve/vehicle_rosewood_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint2_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.Muldraugh, "Vehicles/vve/vehicle_muldraugh_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.Riverside, "Vehicles/vve/vehicle_riverside_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.LouisvillePD, "Vehicles/vve/vehicle_louisville_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.JeffersonPD, "Vehicles/vve/vehicle_jeffersonpolice_vve");
	AddVehicleSkin("CarLightsPolice", ZoneName.JeffersonSD, "Vehicles/vve/vehicle_jeffersonsheriff_vve");

	SetPoliceVehicle("CarLightsSheriff")
	AddVehicleSkin("CarLightsSheriff", ZoneName.KSP, "Vehicles/vve/vehicle_kentuckystate_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.Meade, "Vehicles/vve/vehicle_meade_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.Rosewood, "Vehicles/vve/vehicle_rosewood_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint2_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.Muldraugh, "Vehicles/vve/vehicle_muldraugh_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.Riverside, "Vehicles/vve/vehicle_riverside_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.LouisvillePD, "Vehicles/vve/vehicle_louisville_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.JeffersonPD, "Vehicles/vve/vehicle_jeffersonpolice_vve");
	AddVehicleSkin("CarLightsSheriff", ZoneName.JeffersonSD, "Vehicles/vve/vehicle_jeffersonsheriff_vve");

	SetPoliceVehicle("CarLightsStatepolice")
	AddVehicleSkin("CarLightsStatepolice", ZoneName.KSP, "Vehicles/vve/vehicle_kentuckystate_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.Meade, "Vehicles/vve/vehicle_meade_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.Rosewood, "Vehicles/vve/vehicle_rosewood_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_westpoint2_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.Muldraugh, "Vehicles/vve/vehicle_muldraugh_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.Riverside, "Vehicles/vve/vehicle_riverside_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.LouisvillePD, "Vehicles/vve/vehicle_louisville_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.JeffersonPD, "Vehicles/vve/vehicle_jeffersonpolice_vve");
	AddVehicleSkin("CarLightsStatepolice", ZoneName.JeffersonSD, "Vehicles/vve/vehicle_jeffersonsheriff_vve");

	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.KSP, "Vehicles/vve/vehicle_pickup_ksp_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Meade, "Vehicles/vve/vehicle_pickup_meade_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Rosewood, "Vehicles/vve/vehicle_pickup_rosewood_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_pickup_westpoint_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vve/vehicle_pickup_westpoint2_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Muldraugh, "Vehicles/vve/vehicle_pickup_muldraugh_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Riverside, "Vehicles/vve/vehicle_pickup_riverside_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.LouisvillePD, "Vehicles/vve/vehicle_pickup_louisville_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.JeffersonPD, "Vehicles/vve/vehicle_pickup_jeffersonpolice_vve");
	AddVehicleSkin("PickUpVanLightsPolice", ZoneName.JeffersonSD, "Vehicles/vve/vehicle_pickup_jeffersonsheriff_vve");

	AddVehicleSkin("VanAmbulance", ZoneName.Meade, "Vehicles/vve/vehicle_van_meadecountyambulance_vve");
	AddVehicleSkin("VanAmbulance", ZoneName.Louisville, "Vehicles/vve/vehicle_van_louisvilleambulance_vve");
	AddVehicleSkin("VanAmbulance", ZoneName.Jefferson, "Vehicles/vve/vehicle_van_jeffersoncountyambulance_vve");

	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/vve/vehicle_pickupfireshell_rosewood_vve");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Meade, "Vehicles/vve/vehicle_pickupfireshell_meade_vve");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Louisville, "Vehicles/vve/vehicle_pickupfireshell_louisville_vve");
	AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/vve/vehicle_pickupfireshell_meade_vve");

	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/vve/vehicle_pickupfireshell_rosewood_vve");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Meade, "Vehicles/vve/vehicle_pickupfireshell_meade_vve");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Louisville, "Vehicles/vve/vehicle_pickupfireshell_louisville_vve");
	AddVehicleSkin("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/vve/vehicle_pickupfireshell_meade_vve");

	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vve/vehicle_carnormal_stateparkranger_vve");
	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vve/vehicle_carnormal_fishandwildlife_vve");
	AddVehicleSkin("CarLights", ZoneName.Default, "Vehicles/vve/vehicle_carnormal_nationalparkservice_vve");
	AddVehicleSkin("StepVanMail", ZoneName.Default, "Vehicles/vehicle_stepvan_uspsmailshell");

	AddVehicleSkinOverride("VanSpecial", 2, "Vehicles/vve/vehicle_van_uspsmailvan_vve");

	AddVehicleSkinOverride("VanAmbulance_swat_louisville", 0, "Vehicles/vve/vehicle_van_louisvillepolice_vve");

	AddVehicleSkinOverride("Van_meadedoc", 0, "Vehicles/vve/vehicle_van_meadedoc_vve");
	AddVehicleSkinOverride("Van_jeffersondoc", 0, "Vehicles/vve/vehicle_van_jeffersondoc_vve");

	if getActivatedMods():contains("RavenCreek") or getActivatedMods():contains("10YL_RC") then

		AddVehicleSkin("CarLightsPolice", ZoneName.RavenCreek, "Vehicles/vve/vehicle_ravencreek_vve");
		AddVehicleSkin("CarLightsSheriff", ZoneName.RavenCreek, "Vehicles/vve/vehicle_ravencreek_vve");
		AddVehicleSkin("CarLightsStatepolice", ZoneName.RavenCreek, "Vehicles/vve/vehicle_ravencreek_vve");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.RavenCreek, "Vehicles/vve/vehicle_pickup_ravencreek_vve");
		AddVehicleSkin("VanAmbulance", ZoneName.RavenCreek, "Vehicles/vve/vehicle_van_ravencreekambulance_vve");
		AddVehicleSkin("PickUpTruckLightsFire", ZoneName.RavenCreek, "Vehicles/vve/vehicle_pickuptruckfireshell_ravencreek_vve");
		AddVehicleSkin("PickUpVanLightsFire", ZoneName.RavenCreek, "Vehicles/vve/vehicle_pickupfireshell_ravencreek_vve");
		AddVehicleSkinOverride("Van_ravencreekdoc", 0, "Vehicles/vve/vehicle_van_ravencreekdoc_vve");

	end
	if getActivatedMods():contains("Tandil") then

		AddVehicleSkin("CarLightsPolice", ZoneName.Tandil, "Vehicles/vve/vehicle_tandil_vve");
		AddVehicleSkin("CarLightsSheriff", ZoneName.Tandil, "Vehicles/vve/vehicle_tandil_vve");
		AddVehicleSkin("CarLightsStatepolice", ZoneName.Tandil, "Vehicles/vve/vehicle_tandil_vve");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Tandil, "Vehicles/vve/vehicle_pickup_tandil_vve");
		AddVehicleSkin("VanAmbulance", ZoneName.Tandil, "Vehicles/vve/vehicle_van_tandilambulance_vve");
		AddVehicleSkin("PickUpTruckLightsFire", ZoneName.Tandil, "Vehicles/vve/vehicle_pickuptruckfireshell_tandil_vve");
		AddVehicleSkin("PickUpVanLightsFire", ZoneName.Tandil, "Vehicles/vve/vehicle_pickupfireshell_tandil_vve");

	end
	if getActivatedMods():contains("Greenport") then

		AddVehicleSkin("CarLightsPolice", ZoneName.Greenport, "Vehicles/vve/vehicle_greenport_vve");
		AddVehicleSkin("CarLightsSheriff", ZoneName.Greenport, "Vehicles/vve/vehicle_greenport_vve");
		AddVehicleSkin("CarLightsStatepolice", ZoneName.Greenport, "Vehicles/vve/vehicle_greenport_vve");
		AddVehicleSkin("PickUpVanLightsPolice", ZoneName.Greenport, "Vehicles/vve/vehicle_pickup_greenport_vve");

	end
end

return vehicleToSkin