---@type IsoCell
local cell
Events.OnPostMapLoad.Add(function (c, x, y)
    cell = c
end)

local currentTime = 0

---@type fun(BaseVehicle):boolean
local getHornActive

local tempVehicle = BaseVehicle.new(nil)

for i = 0, getNumClassFields(tempVehicle) - 1 do
    local field = getClassField(tempVehicle, i)
    local fieldname = string.match(tostring(field), "([^%.]+)$")
    if fieldname == "soundHornOn" then
        getHornActive = function(vehicle)
            return getClassFieldVal(vehicle, field)
        end
        break
    end
end

tempVehicle = nil

if not getHornActive then
    error("STFR Lightbars: Could not create field getters")
end

--- Lua reimplementation of vehicle lightbars
---@class LuaLightbar
---@field private _vehicle BaseVehicle
---@field private _light IsoLightSource
---@field private _startTime number
---@field private _lastX integer
---@field private _lastY integer
---@field private _lastZ integer
---@field private _lastLightMode LightbarLightMode
---@field private _lastSide LightbarActiveLight
---@field private _leftR number
---@field private _leftG number
---@field private _leftB number
---@field private _rightR number
---@field private _rightG number
---@field private _rightB number
---@field private _emitter BaseSoundEmitter
---@field private _sirenSound number
---@field private _lastSirenMode LightbarSirenMode
---@field private _hornSound number
---@field sirenYelp string?
---@field sirenWail string?
---@field sirenAlarm string?
---@field horn string?
local LuaLightbar = {}
LuaLightbar.__index = LuaLightbar
---@type LuaLightbar[]
LuaLightbar.list = {}

---@alias LightbarActiveLight
---| 0 # None
---| 1 # Left
---| 2 # Right

---@alias LightbarLightMode
---| 0 # Off
---| 1 # Slow blink
---| 2 # Double blink
---| 3 # Fast blink

---@alias LightbarSirenMode
---| 0 # Off
---| 1 # Yelp
---| 2 # Wail
---| 3 # Alarm

---@private
---@type Callback_OnEnterVehicle|Callback_OnExitVehicle
LuaLightbar._handleEnterExitVehicle = function(character)
    if not character:isLocal() then return end
    local vehicle = character:getVehicle()
    for i = 1, #LuaLightbar.list, 1 do
        local lightbar = LuaLightbar.list[i]
        if lightbar._vehicle == vehicle then
            local shouldSpatialise = not vehicle:isAnyListenerInside()
            if lightbar._sirenSound ~= -1 then
                lightbar._emitter:set3D(lightbar._sirenSound, shouldSpatialise)
            end
            if lightbar._hornSound ~= -1 then
                lightbar._emitter:set3D(lightbar._hornSound, shouldSpatialise)
            end
        end
    end
end

Events.OnEnterVehicle.Add(LuaLightbar._handleEnterExitVehicle)
Events.OnExitVehicle.Add(LuaLightbar._handleEnterExitVehicle)

---@private
---@param mode LightbarLightMode
---@return LightbarActiveLight
LuaLightbar._getActiveLight = function(self, mode)
    local time = currentTime - self._startTime
    if mode == 1 then -- slow blinking
        time = time % 1000
        if time >= 50 and time < 450 then
            return 1
        elseif time >= 550 and time < 950 then
            return 2
        end
    elseif mode == 2 then -- double blink
        time = time % 1000
        if time >= 50 and time < 250 then
            return 1
        elseif time >= 300 and time < 500 then
            return 1
        elseif time >= 550 and time < 750 then
            return 2
        elseif time > 800 then
            return 2
        end
    elseif mode == 3 then -- fast blinking
        time = time % 300
        if time >= 25 and time < 125 then
            return 1
        elseif time >= 175 and time < 275 then
            return 2
        end
    end
    return 0
end

---@param mode LightbarLightMode
---@return string?
LuaLightbar._getSirenSound = function(self, mode)
    if mode == 1 then
        return self.sirenYelp
    elseif mode == 2 then
        return self.sirenWail
    elseif mode == 3 then
        return self.sirenAlarm
    end
end

---@param r number
---@param g number
---@param b number
LuaLightbar.setColourLeft = function(self, r, g, b)
    self._leftR = r
    self._leftG = g
    self._leftB = b
end

---@param r number
---@param g number
---@param b number
LuaLightbar.setColourRight = function(self, r, g, b)
    self._rightR = r
    self._rightG = g
    self._rightB = b
end

---@return BaseVehicle
LuaLightbar.getVehicle = function(self)
    return self._vehicle
end

---@param yelp string
---@param wail string
---@param alarm string
LuaLightbar.setSirenSounds = function(self, yelp, wail, alarm)
    self.sirenYelp = yelp
    self.sirenWail = wail
    self.sirenAlarm = alarm
end

local vec3 = Vector3f.new()

---Updates the position and colour of the active light
LuaLightbar.update = function(self)
    if not self._vehicle:getSquare() then
        self:delete()
        return
    end

    ---@type LightbarLightMode
    local lightMode
    ---@type LightbarSirenMode
    local sirenMode

    if self._vehicle:getBatteryCharge() <= 0 then
        lightMode = 0
        sirenMode = 0
    else
        lightMode = self._vehicle:getLightbarLightsMode()
        sirenMode = self._vehicle:getLightbarSirenMode()
    end

    if sirenMode ~= self._lastSirenMode then
        if self._sirenSound ~= -1 then
            self._emitter:stopSoundLocal(self._sirenSound)
        end
        local sound = self:_getSirenSound(sirenMode)
        if sound then
            self._sirenSound = self._emitter:playSoundLoopedImpl(sound)
        else
            self._sirenSound = -1
        end
        self._lastSirenMode = sirenMode
    end

    if self.horn and getHornActive(self._vehicle) then
        if self._hornSound == -1 then
            self._hornSound = self._emitter:playSoundLoopedImpl(self.horn)
        end
    elseif self._hornSound ~= -1 then
        self._emitter:stopSoundLocal(self._hornSound)
        self._hornSound = -1
    end

    if lightMode ~= self._lastLightMode then
        self._lastLightMode = lightMode
        self._startTime = getTimeInMillis()

        if lightMode == 0 then
            cell:removeLamppost(self._light)
            self._lastSide = 0
            return
        end
    elseif lightMode == 0 then
        return
    end

    local activeSide = self:_getActiveLight(lightMode)

    if activeSide ~= 0 then
        local x,y,z = 0,0,0
        local r, g, b
        if activeSide == 1 then
            x = x + 0.4
            r = self._leftR
            g = self._leftG
            b = self._leftB
        else
            x = x - 0.4
            r = self._rightR
            g = self._rightG
            b = self._rightB
        end

        self._vehicle:getWorldPos(x, y, z, vec3)
        x = vec3:x()
        y = vec3:y()
        z = vec3:z() + 1

        -- this is way faster than math.floor lol
        x = x - x % 1
        y = y - y % 1
        z = z - z % 1

        if self._lastSide == activeSide and self._lastX == x and self._lastY == y and self._lastZ == z then
            return
        end

        if self._lastSide ~= 0 then
            cell:removeLamppost(self._light)
        end
        self._light = IsoLightSource.new(x, y, z, r, g, b, 8)
        cell:addLamppost(self._light)

        self._lastX = x
        self._lastY = y
        self._lastZ = z
        self._lastSide = activeSide
    elseif self._lastSide ~= 0 then
        cell:removeLamppost(self._light)
        self._lastSide = 0
    end
end

---Creates a LuaLightbar for a vehicle with the given colours
---@param vehicle BaseVehicle The vehicle
---@param leftR? number Left red
---@param leftG? number Left green
---@param leftB? number Left blue
---@param rightR? number Right red
---@param rightG? number Right green
---@param rightB? number Right blue
---@return LuaLightbar
LuaLightbar.new = function(vehicle, leftR, leftG, leftB, rightR, rightG, rightB)
    local o = {}

    setmetatable(o, LuaLightbar)
    ---@cast o LuaLightbar

    o._vehicle = vehicle
    o._emitter = vehicle:getEmitter()
    o._leftR = leftR or 0
    o._leftG = leftG or 0
    o._leftB = leftB or 0
    o._rightR = rightR or 0
    o._rightG = rightG or 0
    o._rightB = rightB or 0

    o._startTime = -1
    o._lastX = 0
    o._lastY = 0
    o._lastZ = 0
    o._lastLightMode = 0
    o._lastSide = 0
    o._sirenSound = -1
    o._hornSound = -1

    -- this one gets deleted right away but needs to exist to avoid a null pointer error
    o._light = IsoLightSource.new(0, 0, 0, 0, 0, 0, 8)

    table.insert(LuaLightbar.list, o)

    return o
end

---Cleans up resources so that the lightbar can be collected. Remove any references to the object after calling this.
LuaLightbar.delete = function(self)
    for i = 1, #LuaLightbar.list do
        if LuaLightbar.list[i] == self then
            table.remove(LuaLightbar.list, i)
            break
        end
    end

    cell:removeLamppost(self._light)
end

Events.OnTick.Add(function(tick)
    currentTime = getTimeInMillis()
    for i = #LuaLightbar.list, 1, -1 do
        LuaLightbar.list[i]:update()
    end
end)

---Creates a LuaLightbar for a vehicle
---@type VehiclePart_init
LuaLightbar_Init = function(vehicle, part)
    local lightbar = LuaLightbar.new(vehicle)

    local skinIndex = vehicle:getSkinIndex()
    local colours = part:getTable("colours")
    if colours then
        local skinColours = luautils.split(colours[skinIndex] or colours.default, ";")
        for i = 1, 6 do
            skinColours[i] = tonumber(skinColours[i])
        end
        lightbar:setColourLeft(skinColours[1], skinColours[2], skinColours[3])
        lightbar:setColourRight(skinColours[4], skinColours[5], skinColours[6])
    end

    local sirens = part:getTable("sirens")
    if sirens then
        lightbar:setSirenSounds(unpack(luautils.split(sirens[skinIndex] or sirens.default, ";")))
    end

    local horns = part:getTable("horns")
    if horns then
        lightbar.horn = horns[skinIndex] or horns.default
    end
end

return LuaLightbar