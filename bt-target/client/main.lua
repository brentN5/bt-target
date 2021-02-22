local Models = {}
local Zones = {}

Citizen.CreateThread(function()
    RegisterKeyMapping("+playerTarget", "Player Targeting", "keyboard", "LMENU") --Removed Bind System and added standalone version
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")
end)

function playerTargetEnable()
    if success then return end
    if IsPedArmed(PlayerPedId(), 6) then return end

    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local hit, coords, entity = RayCastGamePlayCamera(20.0)

        if hit == 1 then
            if GetEntityType(entity) ~= 0 then
                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        if DoesEntityExist(GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), Models[_]["radius"], GetEntityModel(entity), 0, 0, 0)) then

                            success = true

                            SendNUIMessage({response = "validTarget", label = Models[_]["label"], icon = Models[_]["icon"], event = Models[_]["event"]})

                            while success and targetActive do
                                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                DisablePlayerFiring(PlayerPedId(), true)

                                if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                    SetNuiFocus(true, true)
                                    SetCursorLocation(0.5, 0.5)
                                end

                                if GetEntityType(entity) ~= 0 then
                                    if _ ~= GetEntityModel(entity) then
                                        success = false
                                    end
                                else
                                    success = false
                                end

                                Citizen.Wait(1)
                            end
                            SendNUIMessage({response = "leftTarget"})
                        end
                    end
                end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    if #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) < zone.targetoptions.distance then

                        success = true

                        SendNUIMessage({ response = "validTarget", label = zone.targetoptions.label, icon = zone.targetoptions.icon, event = zone.targetoptions.event })
                        while success and targetActive do
                            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                            local hit, coords, entity = RayCastGamePlayCamera(20.0)

                            DisablePlayerFiring(PlayerPedId(), true)

                            if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                SetNuiFocus(true, true)
                                SetCursorLocation(0.5, 0.5)
                            elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                success = false
                            end

                            Citizen.Wait(1)
                        end
                        SendNUIMessage({response = "leftTarget"})
                    end
                end
            end
        end
        Citizen.Wait(250)
    end
end

function playerTargetDisable()
    if success then return end

    targetActive = false

    SendNUIMessage({response = "closeTarget"})
end

--NUI CALL BACKS

RegisterNUICallback('selectTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false

    TriggerEvent(data.event)
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
end)

--Functions from https://forum.cfx.re/t/get-camera-coordinates/183555/14

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

--Exports

function AddCircleZone(name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
    Zones[name] = BoxZone:Create(center, length, width, options)
    Zones[name].targetoptions = targetoptions
end

function AddPolyzone(name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

exports("AddCircleZone", AddCircleZone)

exports("AddBoxZone", AddBoxZone)

exports("AddPolyzone", AddPolyzone)

exports("AddTargetModel", AddTargetModel)
