--if isClient() then return end
local vehicleToSkin = {}
local ZoneName = require 'STFR_Vehicle_Skin_Zones'

---@param message string
---@param level integer
local debugError = function(message, level)
	if isDebugEnabled() then
		error(message, level+1)
	end
end

---Like DoParam but for vehicles
---@param vehicle string Name of the vehicle script
---@param param string The parameter(s) to apply to this script
---@param module? string the module of the vehicle
---@see Item.DoParam
---@see VehicleScript.Load
local DoVehicleParam = function(vehicle, param, module)
	module = module or "Base"
	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then return false end
	vehicleScript:Load(vehicle, "{" .. param .. "}")
	return true
end

---@param t any[]
local getListString = function(t)
	local pattern = "%s" .. string.rep(";%s", #t - 1)
	return string.format(pattern, unpack(t))
end

---@param vehicle string
---@param part string
---@param name string
---@param t table Keys must be primitives. Values can be primitives or list-like tables of primitives
---@param module? string
local addTableToPart = function(vehicle, part, name, t, module)
	module = module or "Base"

	local tableStr = ""
	for k,v in pairs(t) do
		if type(v) == "table" then
			v = getListString(v)
		end
		tableStr = string.format("%s%s=%s,", tableStr, k, v)
	end

	ScriptManager.instance:getVehicle(module .. "." .. vehicle):Load(vehicle,
		string.format("{ part %s { table %s { %s } } }", part, name, tableStr))
end

---@enum LightbarColor
LightbarColour = {
	Default = {1, 0, 0, 0, 0, 1},
	Red = {1, 0, 0, 1, 0, 0},
	Blue = {0, 0, 1, 0, 0, 1},
	Yellow = {1, 1, 0, 1, 1, 0}
}

---@class LightbarColourScript
---@field default LightbarColor
---@field [integer] LightbarColor

---@class LightbarSirenScript
---@field default string Semicolon separated sounds (e.g. YelpSound;WailSound;SirenSound)
---@field [integer] string Semicolon separated sounds (e.g. YelpSound;WailSound;SirenSound)

---@class HornScript
---@field default string
---@field [integer] string

---@type table<string, LightbarColourScript>
local lightbarMap = {}

---Overrides the colours 
---@param vehicle string Short type of the vehicle
---@param colours LightbarColourScript Vehicle lightbar colour map
---@param module? string Module of the vehicle. Defaults to Base
local setVehicleLightbars = function(vehicle, colours, module)
	module = module or "Base"

	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then
		debugError("STFR: tried to override lightbar of non-existent vehicle " .. vehicle, 2)
		return
	end

	local lightbar = vehicleScript:getPartById("lightbar")
	if not lightbar then
		debugError("STFR: tried to override lightbar of vehicle with no lightbar " .. vehicle, 2)
		return
	end

	local coloursStr = ""
	for k,v in pairs(colours) do
		coloursStr = string.format("%s%s=%s;%s;%s;%s;%s;%s,", coloursStr, k, unpack(v))
	end

	vehicleScript:Load(vehicle, "{ lightbar { leftCol = 0;0;0, rightCol = 0;0;0, } }")
	addTableToPart(vehicle, "lightbar", "colours", colours, module)
	vehicleScript:Load(vehicle, "{ part lightbar { lua { init = LuaLightbar_Init,} } }")
end

---@type table<string, LightbarSirenScript>
local sirenMap = {}

---@param vehicle string
---@param sirens LightbarSirenScript
---@param module? string
local setVehicleSirens = function(vehicle, sirens, module)
	module = module or "Base"
	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then
		debugError("STFR: tried to override siren of non-existent vehicle " .. vehicle, 2)
		return
	end

	local lightbar = vehicleScript:getPartById("lightbar")
	if not lightbar then
		debugError("STFR: tried to override siren of vehicle with no lightbar " .. vehicle, 2)
		return
	end

	vehicleScript:Load(vehicle, "{ lightbar { soundSiren0 = NONE, soundSiren1 = NONE, soundSiren2 = NONE, } }")
	addTableToPart(vehicle, "lightbar", "sirens", sirens, module)
	vehicleScript:Load(vehicle, "{ part lightbar { lua { init = LuaLightbar_Init,} } }")
end

---@type table<string, HornScript>
local hornMap = {}

---@param vehicle string
---@param horns HornScript
---@param module? string
local setVehicleHorns = function(vehicle, horns, module)
	-- TODO: this requires a lightbar right now because it piggybacks off of light bar stuff, it could be edited to use the engine or something
	module = module or "Base"
	local vehicleScript = ScriptManager.instance:getVehicle(module .. "." .. vehicle)
	if not vehicleScript then
		debugError("STFR: tried to override horn of non-existent vehicle " .. vehicle, 2)
		return
	end

	local lightbar = vehicleScript:getPartById("lightbar")
	if not lightbar then
		debugError("STFR: tried to override horn of vehicle with no lightbar " .. vehicle, 2)
		return
	end

	vehicleScript:Load(vehicle, "{ sound { horn = NONE, } }")
	addTableToPart(vehicle, "lightbar", "horns", horns, module)
	vehicleScript:Load(vehicle, "{ part lightbar { lua { init = LuaLightbar_Init,} } }")
end

Events.OnGameBoot.Add(function()
	for vehicle, colours in pairs(lightbarMap) do
		local module, name = unpack(luautils.split(vehicle, "."))
		setVehicleLightbars(name, colours, module)
	end
	---@diagnostic disable-next-line: cast-local-type
	lightbarMap = nil

	for vehicle, sirens in pairs(sirenMap) do
		local module, name = unpack(luautils.split(vehicle, "."))
		setVehicleSirens(name, sirens, module)
	end
	---@diagnostic disable-next-line: cast-local-type
	sirenMap = nil

	for vehicle, horns in pairs(hornMap) do
		local module, name = unpack(luautils.split(vehicle, "."))
		setVehicleHorns(name, horns, module)
	end
	---@diagnostic disable-next-line: cast-local-type
	hornMap = nil
end)

---Utility to add new skins to vehicles
---@param vehicle string Name of the vehicle script
---@param zone ZoneName Zone ID for the skin
---@param texture string The new skin's texture
---@param module? string The vehicle's module
AddVehicleSkin = function(vehicle, zone, texture, module)
	AddVehicleSkinLightsMask(vehicle, zone, texture, nil, nil, module)
end

---Utility to add new skins to vehicles
---@param vehicle string Name of the vehicle script
---@param zone ZoneName Zone ID for the skin
---@param texture string The new skin's texture
---@param lights string The new skin's lights texture
---@param module? string The vehicle's module
AddVehicleSkinLights = function(vehicle, zone, texture, lights, module)
	AddVehicleSkinLightsMask(vehicle, zone, texture, lights, nil, module)
end

---Utility to add new skins to vehicles
---@param vehicle string Name of the vehicle script
---@param zone ZoneName Zone ID for the skin
---@param texture string The new skin's texture
---@param lights? string The new skin's lights texture
---@param mask? string The new skin's mask texture
---@param module? string The vehicle's module
AddVehicleSkinLightsMask = function(vehicle, zone, texture, lights, mask, module)
	module = module or "Base"

	local param = "skin { texture = " .. texture .. ", "
	if lights then
		param = param .. "textureLights =  " .. lights .. ", "
	end
	if mask then
		param = param .. "textureMask = " .. mask .. ", "
	end
	param = param .. "}"

	if not DoVehicleParam(vehicle, param, module) then return end
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

	if lights then
		local colour
		if luautils.stringEnds(lights, "_blue") then
			colour = LightbarColour.Blue
		elseif luautils.stringEnds(lights, "_red") then
			colour = LightbarColour.Red
		elseif luautils.stringEnds(lights, "_yellow") then
			colour = LightbarColour.Yellow
		else
			colour = LightbarColour.Default
		end
		lightbarMap[fullName] = lightbarMap[fullName] or { default = LightbarColour.Default }
		lightbarMap[fullName][newSkinNum] = colour
	end
end

---Adds a new skin to a vehicle and adds it to the replace table NOTE: this currently stops zone overrides from working on that vehicle
---@param vehicle string Name of the vehicle script
---@param texture string The new skin's texture
---@param replace int The skin number to replace. Only stable if overriding vanilla skins/skins from the mod that adds the vehicle
---@param module? string the module of the vehicle
AddVehicleSkinOverride = function(vehicle, replace, texture, module)
	module = module or "Base"

	if not DoVehicleParam(vehicle, "skin { texture = " .. texture .. ",}", module) then return end

	local fullName = module .. "." .. vehicle
	vehicleToSkin[fullName] = vehicleToSkin[fullName] or {}
	vehicleToSkin[fullName].Replace = vehicleToSkin[fullName].Replace or {}
	vehicleToSkin[fullName].Replace[replace] = ScriptManager.instance:getVehicle(fullName):getSkinCount() - 1
end

---Utility for setting vehicle skin siren sounds. The vehicle's original siren sounds will be lost
---@param vehicle string Short type of the vehicle
---@param skin integer? Skin index to set siren for, or nil to set the siren for all skins without an override
---@param yelp string Name of the yelp sound
---@param wail string Name of the wail sound
---@param alarm string Name of the alarm sound
---@param module? string Module of the vehicle. Defaults to Base
local setVehicleSkinSirens = function(vehicle, skin, yelp, wail, alarm, module)
	local fullName = (module or "Base") .. "." .. vehicle
	---@diagnostic disable-next-line: cast-local-type
	skin = skin or "default"

	sirenMap[fullName] = sirenMap[fullName] or {default="VehicleSirenYelp;VehicleSirenWall;VehicleSirenAlarm"}
	sirenMap[fullName][skin] = string.format("%s;%s;%s", yelp, wail, alarm)
end

---Utility for setting vehicle skin siren sounds. The vehicle's original siren sounds will be lost
---@param vehicle string Short type of the vehicle
---@param skin integer? Skin index to set siren for, or nil to set the siren for all skins without an override
---@param sound string Root of sound name for siren sounds. The final sounds will be this appended with "Yelp", "Wall"[sic] and "Alarm"
---@param module? string Module of the vehicle. Defaults to Base
local setVehicleSkinSirensAll = function(vehicle, skin, sound, module)
	setVehicleSkinSirens(vehicle, skin, sound .. "Yelp", sound .. "Wall", sound .. "Alarm", module)
end

---Utility for setting vehicle skin horn sounds. The vehicle's original horn sound will be lost
---@param vehicle string Short type of the vehicle
---@param skin integer? Skin index to set horn for, or nil to set the horn for all skins without an override
---@param sound string Sound name
---@param module? string Module of the vehicle. Defaults to Base
local setVehicleSkinHorn = function(vehicle, skin, sound, module)
	local fullName = (module or "Base") .. "." .. vehicle
	---@diagnostic disable-next-line: cast-local-type
	skin = skin or "default"

	hornMap[fullName] = hornMap[fullName] or {default="VehicleHornStandard"}
	hornMap[fullName][skin] = string.format(sound)
end

---@deprecated
---Utility to change the siren sound of a vehicle
---@param vehicle string Name of the vehicle script
---@param sound string Name of a sound
SetSirenSound = function(vehicle, sound)
	setVehicleSkinSirensAll(vehicle, nil, sound)
end

---Utility to change the horn sound of a vehicle
---@param vehicle string Name of the vehicle script
---@param mask string Name of a mask
SetMask = function(vehicle, mask)
	DoVehicleParam(vehicle, "textureMask = " .. mask .. ",}")
end

---Utility to change the horn sound of a vehicle
---@param vehicle string Name of the vehicle script
---@param sound string Name of a sound
SetHornSound = function(vehicle, sound)
	DoVehicleParam(vehicle, "sound { horn = " .. sound .. ",}")
end

---Sets a vehicle to use police zones instead of regular zones. Slower but needed for police
SetPoliceVehicle = function(vehicle, module)
	module = module or "Base"
	local fullName = module .. "." .. vehicle
	vehicleToSkin[fullName] = vehicleToSkin[fullName] or {}
	vehicleToSkin[fullName].Police = true
end

---Utility to change the radio of a vehicle
---@param vehicle string Name of the vehicle script
---@param radio string Name of a radio template
SetRadioType = function(vehicle, radio)
	DoVehicleParam(vehicle, "template = " .. radio .. ",")
end

if getActivatedMods():contains("VVehicleEnhancer") and getActivatedMods():contains("Time_Accurate_Sirens") then
end
if getActivatedMods():contains("SirenVariety") then
	SetHornSound("StepVan_swat", "BullHorn")
end

if not getActivatedMods():contains("VVehicleEnhancer") and not getActivatedMods():contains("SCKCO") then
	SetRadioType("StepVan_swat","Radio_HAM")

	SetPoliceVehicle("CarLightsPolice")
	SetPoliceVehicle("PickUpVanLightsPolice")
	SetPoliceVehicle("StepVan_swat")

	AddVehicleSkinLights("CarLightsPolice", ZoneName.KSP, "Vehicles/vehicle_STFR_carnormal_police_ksp", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights_blue")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Meade, "Vehicles/vehicle_STFR_carnormal_sheriff_meade", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights_blue")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Rosewood, "Vehicles/vehicle_STFR_carnormal_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_STFR_carnormal_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_STFR_carnormal_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Muldraugh, "Vehicles/vehicle_STFR_carnormal_police_muldraugh", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Riverside, "Vehicles/vehicle_STFR_carnormal_police_riverside", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.LouisvillePD, "Vehicles/vehicle_STFR_carnormal_police_louisville", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.JeffersonPD, "Vehicles/vehicle_STFR_carnormal_police_jefferson", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.JeffersonSD, "Vehicles/vehicle_STFR_carnormal_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")

	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.KSP, "Vehicles/vehicle_STFR_pickup_police_ksp", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Meade, "Vehicles/vehicle_STFR_pickup_sheriff_meade", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Rosewood, "Vehicles/vehicle_STFR_pickup_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_STFR_pickup_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/vehicle_STFR_pickup_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Muldraugh, "Vehicles/vehicle_STFR_pickup_police_muldraugh", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Riverside, "Vehicles/vehicle_STFR_pickup_police_riverside", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.LouisvillePD, "Vehicles/vehicle_STFR_pickup_police_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.JeffersonPD, "Vehicles/vehicle_STFR_pickup_police_jefferson", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.JeffersonSD, "Vehicles/vehicle_STFR_pickup_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")

	AddVehicleSkin("StepVan_swat", ZoneName.KSP, "Vehicles/vehicle_STFR_stepvan_swat_police_ksp_swat")
	AddVehicleSkin("StepVan_swat", ZoneName.Meade, "Vehicles/vehicle_STFR_stepvan_swat_sheriff_meade_swat")
	AddVehicleSkin("StepVan_swat", ZoneName.Rosewood, "Vehicles/vehicle_STFR_stepvan_swat_sheriff_rosewood_swat")
	AddVehicleSkin("StepVan_swat", ZoneName.WestPoint, "Vehicles/vehicle_STFR_stepvan_swat_police_westpoint_blue_swat")
--	AddVehicleSkin("StepVan_swat", ZoneName.WestPoint, "Vehicles/vehicle_STFR_pickup_police_westpoint_white")
--	AddVehicleSkin("StepVan_swat", ZoneName.Muldraugh, "Vehicles/vehicle_STFR_pickup_police_muldraugh")
	AddVehicleSkin("StepVan_swat", ZoneName.Riverside, "Vehicles/vehicle_STFR_stepvan_swat_police_riverside_sar")
	AddVehicleSkin("StepVan_swat", ZoneName.LouisvillePD, "Vehicles/vehicle_STFR_stepvan_swat_police_louisville_swat")
	AddVehicleSkin("StepVan_swat", ZoneName.JeffersonPD, "Vehicles/vehicle_STFR_stepvan_swat_police_jefferson_swat")
	AddVehicleSkin("StepVan_swat", ZoneName.JeffersonSD, "Vehicles/vehicle_STFR_stepvan_swat_sheriff_jefferson_swat")

	AddVehicleSkinLights("VanAmbulance", ZoneName.Meade, "Vehicles/vehicle_STFR_van_ems_meade", "Vehicles/Lights/vehicle_STFR_van_ems_lights_blue")
	AddVehicleSkinLights("VanAmbulance", ZoneName.Louisville, "Vehicles/vehicle_STFR_van_ems_louisville", "Vehicles/Lights/vehicle_STFR_van_ems_lights_red")
	AddVehicleSkinLights("VanAmbulance", ZoneName.Jefferson, "Vehicles/vehicle_STFR_van_ems_jefferson", "Vehicles/Lights/vehicle_STFR_van_ems_lights_red")

	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_STFR_pickup_fire_rosewood", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Meade, "Vehicles/vehicle_STFR_pickup_fire_meade", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Louisville, "Vehicles/vehicle_STFR_pickup_fire_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Jefferson, "Vehicles/vehicle_STFR_pickup_fire_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")

	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/vehicle_STFR_pickup_fire_rosewood", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Meade, "Vehicles/vehicle_STFR_pickup_fire_meade_covered", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Louisville, "Vehicles/vehicle_STFR_pickup_fire_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Jefferson, "Vehicles/vehicle_STFR_pickup_fire_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")

	AddVehicleSkinLights("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_state_park", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_conservation", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpTruckLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_federal", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")

	AddVehicleSkinLights("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_state_park", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_conservation", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("PickUpVanLights", ZoneName.Default, "Vehicles/vehicle_STFR_pickup_ranger_federal", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")

	AddVehicleSkinLights("CarLights", ZoneName.Default, "Vehicles/vehicle_STFR_carnormal_ranger_state_park", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLights", ZoneName.Default, "Vehicles/vehicle_STFR_carnormal_ranger_conservation", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")
	AddVehicleSkinLights("CarLights", ZoneName.Default, "Vehicles/vehicle_STFR_carnormal_ranger_federal", "Vehicles/Lights/vehicle_STFR_carnormal_police_lights")

	AddVehicleSkin("StepVanMail", ZoneName.Default, "Vehicles/vehicle_STFR_stepvan_extra_usps")

	AddVehicleSkinOverride("VanSpecial", 2, "Vehicles/vehicle_STFR_van_extra_usps")

	AddVehicleSkin("Van_doc", ZoneName.Meade, "Vehicles/vehicle_STFR_van_doc_meade")
	AddVehicleSkin("Van_doc", ZoneName.Jefferson, "Vehicles/vehicle_STFR_van_doc_jefferson")
	AddVehicleSkin("Van_doc", ZoneName.Louisville, "Vehicles/vehicle_STFR_van_doc_jefferson")
end
if getActivatedMods():contains("80kz1000") then
	if getActivatedMods():contains("SirenVariety") then
		SetHornSound("80kz1000", "BullHorn")
	end
	SetPoliceVehicle("80kz1000")

	AddVehicleSkinLights("80kz1000", ZoneName.KSP, "Vehicles/Motorcycle/vehicle_STFR_80kz1000_police_ksp", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights_blue")
	AddVehicleSkinLights("80kz1000", ZoneName.Meade, "Vehicles/Motorcycle/vehicle_STFR_80kz1000_sheriff_meade", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights_blue")
	AddVehicleSkinLights("80kz1000", ZoneName.Rosewood, "Vehicles/Motorcycle/vehicle_STFR_80kz1000_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.WestPoint, "Vehicles/Motorcycle/vehicle_80kz1000_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.WestPoint, "Vehicles/Motorcycle/vehicle_80kz1000_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.Muldraugh, "Vehicles/Motorcycle/vehicle_80kz1000_police_muldraugh", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.Riverside, "Vehicles/Motorcycle/vehicle_80kz1000_police_riverside", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.LouisvillePD, "Vehicles/Motorcycle/vehicle_80kz1000_police_louisville", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.JeffersonPD, "Vehicles/Motorcycle/vehicle_80kz1000_police_jefferson", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
	AddVehicleSkinLights("80kz1000", ZoneName.JeffersonSD, "Vehicles/Motorcycle/vehicle_STFR_80kz1000_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_80kz1000_police_lights")
end
if getActivatedMods():contains("FRUsedCars") then
	if getActivatedMods():contains("SirenVariety") then
		SetHornSound("86econolineambulance_swat", "BullHorn")
	end
	SetMask("86econolineambulance_swat", "Vehicles/Misc/vehicle_STFR_80f350_police_swat_mask")

	SetRadioType("chevystepvanswat","Radio_HAM")
	SetRadioType("86econolineambulance_swat","Radio_HAM")
	SetRadioType("85vicsheriff","Radio_HAM")
	SetRadioType("92crownvicPD","Radio_HAM")
	SetRadioType("91blazerpd","Radio_HAM")
	SetRadioType("87capricePD","Radio_HAM")
	SetRadioType("87c10fire","Radio_HAM")
	SetRadioType("firepumper","Radio_HAM")
	SetRadioType("86econolineambulance","Radio_HAM")
	SetRadioType("80f350ambulance","Radio_HAM")

	SetPoliceVehicle("chevystepvanswat")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_police_ksp_swat", "Vehicles/Lights/vehicle_STFR_stepvanchevy_police_lights_blue")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_sheriff_meade_swat", "Vehicles/Lights/vehicle_STFR_stepvanchevy_police_lights_blue")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_sheriff_rosewood_swat", "Vehicles/vehicle_chevystepvan_lights")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_police_westpoint_blue_swat", "Vehicles/vehicle_chevystepvan_lights")
--	AddVehicleSkinLights("chevystepvanswat", ZoneName.WestPoint, "Vehicles//Filibuster/vehicle_STFR_stepvanchevy_police_louisville_swat", "Vehicles/vehicle_chevystepvan_lights")
--	AddVehicleSkinLights("chevystepvanswat", ZoneName.Muldraugh, "Vehicles//Filibuster/vehicle_STFR_stepvanchevy_police_louisville_swat", "Vehicles/vehicle_chevystepvan_lights")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.Riverside, "Vehicles//Filibuster/vehicle_STFR_stepvanchevy_police_riverside_sar", "Vehicles/vehicle_chevystepvan_lights")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_police_louisville_swat", "Vehicles/vehicle_chevystepvan_lights")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_stepvanchevy_police_jefferson_swat", "Vehicles/vehicle_chevystepvan_lights")
	AddVehicleSkinLights("chevystepvanswat", ZoneName.JeffersonSD, "Vehicles//Filibuster/vehicle_STFR_stepvanchevy_sheriff_jefferson_swat", "Vehicles/vehicle_chevystepvan_lights")

	SetPoliceVehicle("86econolineambulance_swat")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_86econoline_police_ksp_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights_blue")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_86econoline_sheriff_meade_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights_blue")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_86econoline_sheriff_rosewood_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_86econoline_police_westpoint_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
--	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_86econoline_sheriff_rosewood_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
--	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.Muldraugh, "Vehicles/Filibuster/vehicle_STFR_86econoline_sheriff_rosewood_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.Riverside, "Vehicles/Filibuster/vehicle_STFR_86econoline_police_riverside_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_86econoline_police_louisville_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_86econoline_police_jefferson_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")
	AddVehicleSkinLights("86econolineambulance_swat", ZoneName.JeffersonSD, "Vehicles/Filibuster/vehicle_STFR_86econoline_sheriff_jefferson_swat", "Vehicles/Lights/vehicle_STFR_80f350_police_swat_lights")

	SetPoliceVehicle("85vicsheriff")
	AddVehicleSkinLights("85vicsheriff", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_ksp", "Vehicles/Lights/vehicle_STFR_85crownvic_police_lights_blue")
	AddVehicleSkinLights("85vicsheriff", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_85crownvic_sheriff_meade", "Vehicles/Lights/vehicle_STFR_85crownvic_police_lights_blue")
	AddVehicleSkinLights("85vicsheriff", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_85crownvic_sheriff_rosewood", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_westpoint_blue", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_westpoint_white", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.Muldraugh, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_muldraugh", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.Riverside, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_riverside", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_lousville", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_85crownvic_police_jefferson", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicsheriff", ZoneName.JeffersonSD, "Vehicles/Filibuster/vehicle_STFR_85crownvic_sheriff_jefferson", "Vehicles/vehicle_85crownvic_lights")

	SetPoliceVehicle("92crownvicPD")
	AddVehicleSkinLights("92crownvicPD", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_ksp", "Vehicles/Lights/vehicle_STFR_92crownvic_police_lights_blue")
	AddVehicleSkinLights("92crownvicPD", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_92crownvic_sheriff_meade", "Vehicles/Lights/vehicle_STFR_92crownvic_police_lights_blue")
	AddVehicleSkinLights("92crownvicPD", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_92crownvic_sheriff_rosewood", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_westpoint_blue", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_westpoint_white", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.Muldraugh, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_muldraugh", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.Riverside, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_riverside", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_louisville", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_92crownvic_police_jefferson", "Vehicles/vehicle_92crownvic_lights")
	AddVehicleSkinLights("92crownvicPD", ZoneName.JeffersonSD, "Vehicles/Filibuster/vehicle_STFR_92crownvic_sheriff_jefferson", "Vehicles/vehicle_92crownvic_lights")

	SetPoliceVehicle("91blazerpd")
	AddVehicleSkinLights("91blazerpd", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_blazer_police_ksp", "Vehicles/Lights/vehicle_STFR_blazer_police_lights_blue")
	AddVehicleSkinLights("91blazerpd", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_blazer_sheriff_meade", "Vehicles/Lights/vehicle_STFR_blazer_police_lights_blue")
	AddVehicleSkinLights("91blazerpd", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_blazer_sheriff_rosewood", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_blazer_police_westpoint_blue", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_blazer_police_westpoint_white", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.Muldraugh, "Vehicles/Filibuster/vehicle_STFR_blazer_police_muldraugh", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.Riverside, "Vehicles/Filibuster/vehicle_STFR_blazer_police_riverside", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_blazer_police_louisville", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_blazer_police_jefferson", "Vehicles/vehicle_blazerpd_lights")
	AddVehicleSkinLights("91blazerpd", ZoneName.JeffersonSD, "Vehicles/Filibuster/vehicle_STFR_blazer_sheriff_jefferson", "Vehicles/vehicle_blazerpd_lights")

	SetPoliceVehicle("87capricePD")
	AddVehicleSkinLights("87capricePD", ZoneName.KSP, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_ksp", "Vehicles/Lights/vehicle_STFR_87caprice_police_lights_blue")
	AddVehicleSkinLights("87capricePD", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_87caprice_sheriff_meade", "Vehicles/Lights/vehicle_STFR_87caprice_police_lights_blue")
	AddVehicleSkinLights("87capricePD", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_87caprice_sheriff_rosewood", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_westpoint_blue", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.WestPoint, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_westpoint_white", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.Muldraugh, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_muldraugh", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.Riverside, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_riverside", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.LouisvillePD, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_louisville", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.JeffersonPD, "Vehicles/Filibuster/vehicle_STFR_87caprice_police_jefferson", "Vehicles/vehicle_87caprice_lights")
	AddVehicleSkinLights("87capricePD", ZoneName.JeffersonSD, "Vehicles/Filibuster/vehicle_STFR_87caprice_sheriff_jefferson", "Vehicles/vehicle_87caprice_lights")

	AddVehicleSkinLights("80f350ambulance", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_80f350_ems_meade", "Vehicles/vehicle_80f350ambulance_lights")
	AddVehicleSkinLights("80f350ambulance", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_80f350_ems_louisville", "Vehicles/vehicle_80f350ambulance_lights")
	AddVehicleSkinLights("80f350ambulance", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_80f350_ems_jefferson", "Vehicles/vehicle_80f350ambulance_lights")

	AddVehicleSkinLights("86econolineambulance", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_86econoline_ems_meade", "Vehicles/vehicle_86econolineambulance_lights")
	AddVehicleSkinLights("86econolineambulance", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_86econoline_ems_louisville", "Vehicles/vehicle_86econolineambulance_lights")
	AddVehicleSkinLights("86econolineambulance", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_86econoline_ems_jefferson", "Vehicles/vehicle_86econolineambulance_lights")

	AddVehicleSkinLights("firepumper", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_firepumper_fire_rosewood", "Vehicles/vehicle_firepumper_lights")
	AddVehicleSkinLights("firepumper", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_firepumper_fire_meade", "Vehicles/vehicle_firepumper_lights")
	AddVehicleSkinLights("firepumper", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_firepumper_fire_louisville", "Vehicles/vehicle_firepumper_lights")
	AddVehicleSkinLights("firepumper", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_firepumper_fire_louisville", "Vehicles/vehicle_firepumper_lights")

	AddVehicleSkinLights("87c10fire", ZoneName.Rosewood, "Vehicles/Filibuster/vehicle_STFR_c10_utility_fire_rosewood", "Vehicles/vehicle_c10utilityfire_lights")
	AddVehicleSkinLights("87c10fire", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_c10_utility_fire_meade", "Vehicles/vehicle_c10utilityfire_lights")
	AddVehicleSkinLights("87c10fire", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_c10_utility_fire_louisville", "Vehicles/vehicle_c10utilityfire_lights")
	AddVehicleSkinLights("87c10fire", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_c10_utility_fire_louisville", "Vehicles/vehicle_c10utilityfire_lights")

	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_92wrangler_ranger_state_park")
	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_92wrangler_ranger_conservation")
	AddVehicleSkin("92wranglerranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_92wrangler_ranger_federal")

	AddVehicleSkinLights("85vicranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_85crownvic_ranger_state_park", "Vehicles/Lights/vehicle_STFR_85crownvic_police_lights_blue")
	AddVehicleSkinLights("85vicranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_85crownvic_ranger_conservation", "Vehicles/vehicle_85crownvic_lights")
	AddVehicleSkinLights("85vicranger", ZoneName.Default, "Vehicles/Filibuster/vehicle_STFR_85crownvic_ranger_federal", "Vehicles/vehicle_85crownvic_lights")

	AddVehicleSkin("86econoline_doc", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_86econoline_doc_meade")
	AddVehicleSkin("86econoline_doc", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_86econoline_doc_jefferson")
	AddVehicleSkin("86econoline_doc", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_86econoline_doc_jefferson")

	AddVehicleSkin("prisonbus", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_bus_doc_meade")
	AddVehicleSkin("prisonbus", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_bus_doc_jefferson")
	AddVehicleSkin("prisonbus", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_bus_doc_jefferson")

	AddVehicleSkin("schoolbus", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_bus_school_meade")
	AddVehicleSkin("schoolbus", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_bus_school_jefferson")
	AddVehicleSkin("schoolbus", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_bus_school_jefferson")

	AddVehicleSkin("schoolbusshort", ZoneName.Meade, "Vehicles/Filibuster/vehicle_STFR_bus_school_meade")
	AddVehicleSkin("schoolbusshort", ZoneName.Louisville, "Vehicles/Filibuster/vehicle_STFR_bus_school_jefferson")
	AddVehicleSkin("schoolbusshort", ZoneName.Jefferson, "Vehicles/Filibuster/vehicle_STFR_bus_school_jefferson")

	if getActivatedMods():contains("PogDogSkins") then
		AddVehicleSkin("schoolbus", ZoneName.Meade, "Vehicles/vehicle_schoolbus_callieshell")
		AddVehicleSkin("schoolbus", ZoneName.Louisville, "Vehicles/vehicle_schoolbus_callieshell")
		AddVehicleSkin("schoolbus", ZoneName.Jefferson, "Vehicles/vehicle_schoolbus_callieshell")
	end
end
if getActivatedMods():contains("VVehicleEnhancer") and not getActivatedMods():contains("SCKCO") then
	SetRadioType("StepVan_swat","Radio_HAM")

	SetPoliceVehicle("CarLightsPolice")
	SetPoliceVehicle("PickUpVanLightsPolice")
	SetPoliceVehicle("StepVan_swat")

	AddVehicleSkinLights("CarLightsPolice", ZoneName.KSP, "Vehicles/VVE/vehicle_STFR_carnormal_police_ksp_VVE", "Vehicles/vehicle_carlightspolice_lights_blue")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_meade_VVE", "Vehicles/vehicle_carlightspolice_lights_blue")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_rosewood_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_blue_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_white_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Muldraugh, "Vehicles/VVE/vehicle_STFR_carnormal_police_muldraugh_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.Riverside, "Vehicles/VVE/vehicle_STFR_carnormal_police_riverside_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.LouisvillePD, "Vehicles/VVE/vehicle_STFR_carnormal_police_louisville_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.JeffersonPD, "Vehicles/VVE/vehicle_STFR_carnormal_police_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsPolice", ZoneName.JeffersonSD, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")

	SetPoliceVehicle("CarLightsSheriff")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.KSP, "Vehicles/VVE/vehicle_STFR_carnormal_police_ksp_VVE", "Vehicles/vehicle_STFR_carnormal_police_lights_VVE_blue")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_meade_VVE", "Vehicles/vehicle_STFR_carnormal_police_lights_VVE_blue")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_rosewood_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_blue_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_white_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.Muldraugh, "Vehicles/VVE/vehicle_STFR_carnormal_police_muldraugh_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.Riverside, "Vehicles/VVE/vehicle_STFR_carnormal_police_riverside_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.LouisvillePD, "Vehicles/VVE/vehicle_STFR_carnormal_police_louisville_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.JeffersonPD, "Vehicles/VVE/vehicle_STFR_carnormal_police_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsSheriff", ZoneName.JeffersonSD, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")

	SetPoliceVehicle("CarLightsStatepolice")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.KSP, "Vehicles/VVE/vehicle_STFR_carnormal_police_ksp_VVE", "Vehicles/vehicle_STFR_carnormal_police_lights_VVE_blue")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_meade_VVE", "Vehicles/vehicle_STFR_carnormal_police_lights_VVE_blue")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_rosewood_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_blue_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_carnormal_police_westpoint_white_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.Muldraugh, "Vehicles/VVE/vehicle_STFR_carnormal_police_muldraugh_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.Riverside, "Vehicles/VVE/vehicle_STFR_carnormal_police_riverside_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.LouisvillePD, "Vehicles/VVE/vehicle_STFR_carnormal_police_louisville_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.JeffersonPD, "Vehicles/VVE/vehicle_STFR_carnormal_police_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")
	AddVehicleSkinLights("CarLightsStatepolice", ZoneName.JeffersonSD, "Vehicles/VVE/vehicle_STFR_carnormal_sheriff_jefferson_VVE", "vehicles/Lights/vehicle_STFR_carnormal_police_lights_VVE")

	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.KSP, "Vehicles/VVE/vehicle_STFR_pickup_police_ksp_VVE", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue_VVE")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_pickup_sheriff_meade_VVE", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue_VVE")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_pickup_sheriff_rosewood_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_pickup_police_westpoint_blue_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_pickup_police_westpoint_white_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Muldraugh, "Vehicles/VVE/vehicle_STFR_pickup_police_muldraugh_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.Riverside, "Vehicles/VVE/vehicle_STFR_pickup_police_riverside_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.LouisvillePD, "Vehicles/VVE/vehicle_STFR_pickup_police_louisville_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.JeffersonPD, "Vehicles/VVE/vehicle_STFR_pickup_police_jefferson_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")
	AddVehicleSkinLights("PickUpVanLightsPolice", ZoneName.JeffersonSD, "Vehicles/VVE/vehicle_STFR_pickup_sheriff_jefferson_VVE", "vehicles/vehicle_pickuptruck88_lightsy_police")

	AddVehicleSkin("StepVan_swat", ZoneName.KSP, "Vehicles/VVE/vehicle_STFR_stepvan_swat_police_ksp_swat_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_stepvan_swat_sheriff_meade_swat_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_stepvan_swat_sheriff_rosewood_swat_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_stepvan_swat_police_westpoint_blue_swat_VVE")
--	AddVehicleSkin("StepVan_swat", ZoneName.WestPoint, "Vehicles/VVE/vehicle_STFR_pickup_police_westpoint_white")
--	AddVehicleSkin("StepVan_swat", ZoneName.Muldraugh, "Vehicles/VVE/vehicle_STFR_pickup_police_muldraugh")
	AddVehicleSkin("StepVan_swat", ZoneName.Riverside, "Vehicles/VVE/vehicle_STFR_stepvan_swat_police_riverside_sar_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.LouisvillePD, "Vehicles/VVE/vehicle_STFR_stepvan_swat_police_louisville_swat_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.JeffersonPD, "Vehicles/VVE/vehicle_STFR_stepvan_swat_police_jefferson_swat_VVE")
	AddVehicleSkin("StepVan_swat", ZoneName.JeffersonSD, "Vehicles/VVE/vehicle_STFR_stepvan_swat_sheriff_jefferson_swat_VVE")

	AddVehicleSkinLights("VanAmbulance", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_van_ems_meade_VVE", "Vehicles/vehicle_vvvanambulance_lights")
	AddVehicleSkinLights("VanAmbulance", ZoneName.Louisville, "Vehicles/VVE/vehicle_STFR_van_ems_louisville_VVE", "Vehicles/Lights/vehicle_STFR_van_ems_lights_red_VVE")
	AddVehicleSkinLights("VanAmbulance", ZoneName.Jefferson, "Vehicles/VVE/vehicle_STFR_van_ems_jefferson_VVE", "Vehicles/vehicle_vvvanambulance_lights")

	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_pickup_fire_rosewood_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire2")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_pickup_fire_meade_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire2")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Louisville, "Vehicles/VVE/vehicle_STFR_pickup_fire_louisville_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire2")
	AddVehicleSkinLights("PickUpTruckLightsFire", ZoneName.Jefferson, "Vehicles/VVE/vehicle_STFR_pickup_fire_louisville_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire2")

	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Rosewood, "Vehicles/VVE/vehicle_STFR_pickup_fire_rosewood_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_pickup_fire_meade_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Louisville, "Vehicles/VVE/vehicle_STFR_pickup_fire_louisville_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire")
	AddVehicleSkinLights("PickUpVanLightsFire", ZoneName.Jefferson, "Vehicles/VVE/vehicle_STFR_pickup_fire_louisville_covered_VVE", "Vehicles/vehicle_pickuptruck88_lightsy_fire")

	AddVehicleSkinLightsMask("CarLights", ZoneName.Default, "Vehicles/VVE/vehicle_STFR_carnormal_ranger_state_park_VVE", "Vehicles//Lights/vehicle_STFR_carnormal_police_lights_VVE", "Vehicles/vehicle_royale_mask")
	AddVehicleSkinLightsMask("CarLights", ZoneName.Default, "Vehicles/VVE/vehicle_STFR_carnormal_ranger_conservation_VVE", "Vehicles//Lights/vehicle_STFR_carnormal_police_lights_VVE", "Vehicles/vehicle_royale_mask")
	AddVehicleSkinLightsMask("CarLights", ZoneName.Default, "Vehicles/VVE/vehicle_STFR_carnormal_ranger_federal_VVE", "Vehicles//Lights/vehicle_STFR_carnormal_police_lights_VVE", "Vehicles/vehicle_royale_mask")

	AddVehicleSkin("StepVanMail", ZoneName.Default, "Vehicles/VVE/vehicle_STFR_stepvan_extra_usps_VVE")

	AddVehicleSkinOverride("VanSpecial", 2, "Vehicles/VVE/vehicle_STFR_van_extra_usps_VVE")

	AddVehicleSkin("Van_doc", ZoneName.Meade, "Vehicles/VVE/vehicle_STFR_van_doc_meade_VVE", "Vehicles/vehicle_vvvan_lights")
	AddVehicleSkin("Van_doc", ZoneName.Jefferson, "Vehicles/VVE/vehicle_STFR_van_doc_jefferson_VVE", "Vehicles/vehicle_vvvan_lights")
	AddVehicleSkin("Van_doc", ZoneName.Louisville, "Vehicles/VVE/vehicle_STFR_van_doc_jefferson_VVE", "Vehicles/vehicle_vvvan_lights")
end
if getActivatedMods():contains("PzkVanillaPlusCarPack") then
	SetPoliceVehicle("pzkChevalierCeriseSedanPolice")
	SetPoliceVehicle("pzkDashMayorPolice")
	SetPoliceVehicle("pzkFranklinTriumphTWDPolice")
	SetPoliceVehicle("pzkChevalierTowTruckPolice")
	SetPoliceVehicle("pzkFranklinGalloperPolice")
	SetPoliceVehicle("pzkChevalierLaserPolice")
	SetPoliceVehicle("pzkFranklinStallionPolice")
	SetPoliceVehicle("pzkFranklinTriumphPolice")
	SetPoliceVehicle("pzkStepVanSwat")
	SetPoliceVehicle("pzkFranklinSwatTruck")

	SetRadioType("pzkFranklinStallionPolice","Radio_HAM")
	SetRadioType("pzkFranklinGalloperPolice","Radio_HAM")
	SetRadioType("pzkChevalierLaserPolice","Radio_HAM")
	SetRadioType("pzkFranklinTriumphPolice","Radio_HAM")

	SetRadioType("pzkChevalierLaserFire","Radio_HAM")
	SetRadioType("pzkFranklinGalloperFire","Radio_HAM")

	SetRadioType("pzkFranklinGalloperRanger","Radio_HAM")
	SetRadioType("pzkChevalierLaserRanger","Radio_HAM")

	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_cerise_police_ksp", "Vehicles/Lights/vehicle_STFR_cerise_police_lights_blue")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_cerise_sheriff_meade", "Vehicles/Lights/vehicle_STFR_cerise_police_lights_blue")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_cerise_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_cerise_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_cerise_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_cerise_police_muldraugh", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_cerise_police_riverside", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_cerise_police_louisville", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_cerise_police_jefferson", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")
	AddVehicleSkinLights("pzkChevalierCeriseSedanPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_cerise_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_cerise_police_lights")

	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_mayor_police_ksp", "Vehicles/Lights/vehicle_STFR_mayor_police_lights_blue")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_mayor_sheriff_meade", "Vehicles/Lights/vehicle_STFR_mayor_police_lights_blue")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_mayor_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_mayor_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_mayor_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_mayor_police_muldraugh", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_mayor_police_riverside", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_mayor_police_louisville", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_mayor_police_jefferson", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")
	AddVehicleSkinLights("pzkDashMayorPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_mayor_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_mayor_police_lights")

	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_ksp", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights_blue")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_triumphtwd_sheriff_meade", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights_blue")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_triumphtwd_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_muldraugh", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_riverside", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_louisville", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_triumphtwd_police_jefferson", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")
	AddVehicleSkinLights("pzkFranklinTriumphTWDPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_triumphtwd_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights")

	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_towtruck_police_ksp", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_towtruck_sheriff_meade", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_blue")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_towtruck_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_towtruck_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_towtruck_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_towtruck_police_muldraugh", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_towtruck_police_riverside", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_towtruck_police_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_towtruck_police_jefferson", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")
	AddVehicleSkinLights("pzkChevalierTowTruckPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_towtruck_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_pickup_police_lights")

	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_f1_police_ksp", "Vehicles/Lights/vehicle_STFR_f1_police_lights_blue", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f1_sheriff_meade", "Vehicles/Lights/vehicle_STFR_f1_police_lights_blue", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f1_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f1_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f1_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_f1_police_muldraugh", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_f1_police_riverside", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_f1_police_louisville", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_f1_police_jefferson", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_f1_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_f2_police_ksp", "Vehicles/Lights/vehicle_STFR_f2_police_lights_blue", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f2_sheriff_meade", "Vehicles/Lights/vehicle_STFR_f2_police_lights_blue", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f2_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f2_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f2_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_f2_police_muldraugh", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_f2_police_riverside", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_f2_police_louisville", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_f2_police_jefferson", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_f2_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_f3_police_ksp", "Vehicles/Lights/vehicle_STFR_f3_police_lights_blue", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f3_sheriff_meade", "Vehicles/Lights/vehicle_STFR_f3_police_lights_blue", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f3_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f3_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_f3_police_westpoint_white", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_f3_police_muldraugh", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_f3_police_riverside", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_f3_police_louisville", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_f3_police_jefferson", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_f3_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_province1_police_ksp", "Vehicles/Lights/Vehicle_STFR_province1_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province1_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_province1_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province1_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province1_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province1_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_province1_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_province1_police_riverside", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_province1_police_louisville", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_province1_police_jefferson", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_province1_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_province2_police_ksp", "Vehicles/Lights/Vehicle_STFR_province2_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province2_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_province2_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province2_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province2_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province2_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_province2_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_province2_police_riverside", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_province2_police_louisville", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_province2_police_jefferson", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_province2_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_province3_police_ksp", "Vehicles/Lights/Vehicle_STFR_province3_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province3_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_province3_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province3_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province3_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province3_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_province3_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_province3_police_riverside", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_province3_police_louisville", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_province3_police_jefferson", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_province3_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_province4_police_ksp", "Vehicles/Lights/Vehicle_STFR_province4_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province4_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_province4_police_lights_blue", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province4_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province4_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_province4_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_province4_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_province4_police_riverside", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_province4_police_louisville", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_province4_police_jefferson", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_province4_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")

	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_stallion_police_ksp", "Vehicles/Lights/Vehicle_STFR_stallion_lights_blue")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_stallion_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_stallion_lights_blue")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_stallion_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_stallion_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_stallion_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_stallion_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_stallion_police_riverside", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_stallion_police_louisville", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_stallion_police_jefferson", "Vehicles/Lights/Vehicle_STFR_stallion_lights")
	AddVehicleSkinLights("pzkFranklinStallionPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_stallion_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_stallion_lights")

	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_triumph_police_ksp", "Vehicles/Lights/Vehicle_STFR_triumph_lights_blue")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_triumph_sheriff_meade", "Vehicles/Lights/Vehicle_STFR_triumph_lights_blue")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_triumph_sheriff_rosewood", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_triumph_police_westpoint_blue", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_triumph_police_westpoint_white", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.Muldraugh, "Vehicles/PZK/vehicle_STFR_triumph_police_muldraugh", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_triumph_police_riverside", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_triumph_police_louisville", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_triumph_police_jefferson", "Vehicles/Lights/Vehicle_STFR_triumph_lights")
	AddVehicleSkinLights("pzkFranklinTriumphPolice", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_triumph_sheriff_jefferson", "Vehicles/Lights/Vehicle_STFR_triumph_lights")

	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_stepvanswat_police_ksp", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights_blue")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_stepvanswat_sheriff_meade", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights_blue")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_stepvanswat_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_stepvanswat_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_stepvanswat_police_riverside", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_stepvanswat_police_louisville", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_stepvanswat_police_jefferson", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkStepVanSwat", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_stepvanswat_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")

	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.KSP, "Vehicles/PZK/vehicle_STFR_swattruck_police_ksp", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights_blue")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_swattruck_sheriff_meade", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights_blue")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_swattruck_sheriff_rosewood", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.WestPoint, "Vehicles/PZK/vehicle_STFR_swattruck_police_westpoint_blue", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.Riverside, "Vehicles/PZK/vehicle_STFR_swattruck_police_riverside", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.LouisvillePD, "Vehicles/PZK/vehicle_STFR_swattruck_police_louisville", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.JeffersonPD, "Vehicles/PZK/vehicle_STFR_swattruck_police_jefferson", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")
	AddVehicleSkinLights("pzkFranklinSwatTruck", ZoneName.JeffersonSD, "Vehicles/PZK/vehicle_STFR_swattruck_sheriff_jefferson", "Vehicles/Lights/vehicle_STFR_stepvanswat_lights")

	AddVehicleSkinLights("pzkChevalierCeriseSedanFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_cerise_fire_rosewood", "Vehicles/Lights/vehicle_STFR_cerise_police_lights_red")
	AddVehicleSkinLights("pzkChevalierCeriseSedanFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_cerise_fire_meade", "Vehicles/Lights/vehicle_STFR_cerise_police_lights_red")
	AddVehicleSkinLights("pzkChevalierCeriseSedanFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_cerise_fire_louisville", "Vehicles/Lights/vehicle_STFR_cerise_police_lights_red")

	AddVehicleSkinLights("pzkFranklinTriumphTWDFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_triumphtwd_fire_rosewood", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTriumphTWDFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_triumphtwd_fire_meade", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTriumphTWDFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_triumphtwd_fire_louisville", "Vehicles/Lights/vehicle_STFR_triumphtwd_police_lights_red")

	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province1_fire_rosewood", "Vehicles/Lights/Vehicle_STFR_province1_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province1_fire_meade", "Vehicles/Lights/Vehicle_STFR_province1_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_province1_fire_louisville", "Vehicles/Lights/Vehicle_STFR_province1_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban1_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province2_fire_rosewood", "Vehicles/Lights/Vehicle_STFR_province2_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province2_fire_meade", "Vehicles/Lights/Vehicle_STFR_province2_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_province2_fire_louisville", "Vehicles/Lights/Vehicle_STFR_province2_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban2_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province3_fire_rosewood", "Vehicles/Lights/Vehicle_STFR_province3_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province3_fire_meade", "Vehicles/Lights/Vehicle_STFR_province3_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_province3_fire_louisville", "Vehicles/Lights/Vehicle_STFR_province3_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban3_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_province4_fire_rosewood", "Vehicles/Lights/Vehicle_STFR_province4_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_province4_fire_meade", "Vehicles/Lights/Vehicle_STFR_province4_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_province4_fire_louisville", "Vehicles/Lights/Vehicle_STFR_province4_police_lights_red", "Vehicles/vehicle_pzkChevalierSuburban4_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f1_fire_rosewood", "Vehicles/Lights/vehicle_STFR_f1_police_lights_red", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f1_fire_meade", "Vehicles/Lights/vehicle_STFR_f1_police_lights_red", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_f1_fire_louisville", "Vehicles/Lights/vehicle_STFR_f1_police_lights_red", "Vehicles/vehicle_pzkFranklinF1_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f2_fire_rosewood", "Vehicles/Lights/vehicle_STFR_f2_police_lights_red", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f2_fire_meade", "Vehicles/Lights/vehicle_STFR_f2_police_lights_red", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_f2_fire_louisville", "Vehicles/Lights/vehicle_STFR_f2_police_lights_red", "Vehicles/vehicle_pzkFranklinF2_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_f3_fire_rosewood", "Vehicles/Lights/vehicle_STFR_f3_police_lights_red", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_f3_fire_meade", "Vehicles/Lights/vehicle_STFR_f3_police_lights_red", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_f3_fire_louisville", "Vehicles/Lights/vehicle_STFR_f3_police_lights_red", "Vehicles/vehicle_pzkFranklinF3_mask")

	AddVehicleSkinLights("pzkChevalierTowTruckFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_towtruck_fire_rosewood", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("pzkChevalierTowTruckFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_towtruck_fire_meade", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")
	AddVehicleSkinLights("pzkChevalierTowTruckFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_towtruck_fire_louisville", "Vehicles/Lights/vehicle_STFR_pickup_police_lights_red")

	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f1_ranger_state_park", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f1_ranger_conservation", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f1_ranger_federal", "Vehicles/Lights/vehicle_STFR_f1_police_lights", "Vehicles/vehicle_pzkFranklinF1_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f2_ranger_state_park", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f2_ranger_conservation", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f2_ranger_federal", "Vehicles/Lights/vehicle_STFR_f2_police_lights", "Vehicles/vehicle_pzkFranklinF2_mask")

	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f3_ranger_state_park", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f3_ranger_conservation", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")
	AddVehicleSkinLightsMask("pzkFranklinGalloperRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_f3_ranger_federal", "Vehicles/Lights/vehicle_STFR_f3_police_lights", "Vehicles/vehicle_pzkFranklinF3_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province1_ranger_state_park", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province1_ranger_conservation", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province1_ranger_federal", "Vehicles/Lights/Vehicle_STFR_province1_police_lights", "Vehicles/vehicle_pzkChevalierSuburban1_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province2_ranger_state_park", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province2_ranger_conservation", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province2_ranger_federal", "Vehicles/Lights/Vehicle_STFR_province2_police_lights", "Vehicles/vehicle_pzkChevalierSuburban2_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province3_ranger_state_park", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province3_ranger_conservation", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province3_ranger_federal", "Vehicles/Lights/Vehicle_STFR_province3_police_lights", "Vehicles/vehicle_pzkChevalierSuburban3_mask")

	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province4_ranger_state_park", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province4_ranger_conservation", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")
	AddVehicleSkinLightsMask("pzkChevalierLaserRanger", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_province4_ranger_federal", "Vehicles/Lights/Vehicle_STFR_province4_police_lights", "Vehicles/vehicle_pzkChevalierSuburban4_mask")

	AddVehicleSkinLights("pzkVanPolice", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_vanpolice_doc_meade", "Vehicles/Lights/vehicle_STFR_vanseatspolice_lights_blue")
	AddVehicleSkinLights("pzkVanPolice", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_vanpolice_doc_jefferson", "Vehicles/Lights/vehicle_STFR_vanseatspolice_lights")
	AddVehicleSkinLights("pzkVanPolice", ZoneName.Jefferson, "Vehicles/PZK/vehicle_STFR_vanpolice_doc_jefferson", "Vehicles/Lights/vehicle_STFR_vanseatspolice_lights")

	AddVehicleSkinLights("pzkFranklinTruckFire", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_firetruck_fire_rosewood", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTruckFire", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_firetruck_fire_meade", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTruckFire", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_firetruck_fire_louisville", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")

	AddVehicleSkinLights("pzkFranklinTruckFireTanker", ZoneName.Rosewood, "Vehicles/PZK/vehicle_STFR_firetruck_fire_rosewood", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTruckFireTanker", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_firetruck_fire_meade", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")
	AddVehicleSkinLights("pzkFranklinTruckFireTanker", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_firetruck_fire_louisville", "Vehicles/Lights/vehicle_STFR_firetruck_police_lights_red")

	AddVehicleSkinLights("pzkVanBoxAmbulance", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_boxvan_ems_meade", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_blue")
	AddVehicleSkinLights("pzkVanBoxAmbulance", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_boxvan_ems_louisville", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_red")
	AddVehicleSkinLights("pzkVanBoxAmbulance", ZoneName.Jefferson, "Vehicles/PZK/vehicle_STFR_boxvan_ems_jefferson", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_red")

	AddVehicleSkinLights("pzkVanBoxFiretruck", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_boxvan_ems_meade", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_blue")
	AddVehicleSkinLights("pzkVanBoxFiretruck", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_boxvan_ems_louisville", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_red")
	AddVehicleSkinLights("pzkVanBoxFiretruck", ZoneName.Jefferson, "Vehicles/PZK/vehicle_STFR_boxvan_ems_jefferson", "Vehicles/Lights/vehicle_STFR_boxvan_ems_lights_red")

	AddVehicleSkin("pzkFranklinBankTruck", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_banktruck_brinks")
	AddVehicleSkin("pzkFranklinBankTruck", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_banktruck_dunbar")

	AddVehicleSkin("pzkFranklinTruckBus", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_bus_school_meade")
	AddVehicleSkin("pzkFranklinTruckBus", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_bus_school_jefferson")
	AddVehicleSkin("pzkFranklinTruckBus", ZoneName.Jefferson, "Vehicles/PZK/vehicle_STFR_bus_school_jefferson")

	AddVehicleSkin("pzkFranklinTruckBusPrison", ZoneName.Meade, "Vehicles/PZK/vehicle_STFR_bus_doc_meade")
	AddVehicleSkin("pzkFranklinTruckBusPrison", ZoneName.Louisville, "Vehicles/PZK/vehicle_STFR_bus_doc_jefferson")
	AddVehicleSkin("pzkFranklinTruckBusPrison", ZoneName.Jefferson, "Vehicles/PZK/vehicle_STFR_bus_doc_jefferson")

	AddVehicleSkin("pzkMinivanStellarisMail", ZoneName.Default, "Vehicles/PZK/vehicle_STFR_stellaris_extra_usps")
end
return vehicleToSkin
