local Models = {}
local Bones = {}
local Zones = {}

Citizen.CreateThread(function()
    RegisterKeyMapping("+playerTarget", "Player Targeting", "keyboard", "LMENU") --Removed Bind System and added standalone version
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")
end)

if Config.ESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        PlayerJob = ESX.GetPlayerData().job

        RegisterNetEvent('esx:setJob')
		AddEventHandler('esx:setJob', function(job)
		    PlayerJob = job
		end)
    end)
else
    PlayerJob = Config.NonEsxJob()
end

function playerTargetEnable()
    --if success then return end
    local playerPed = PlayerPedId() -- Defining player ped id before running loop
    if IsPedArmed(playerPed, 6) then return end

    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        local plyCoords = GetEntityCoords(playerPed)
        local hit, coords, entity = RayCastGamePlayCamera(20.0)
        local nearestVehicle = GetNearestVehicle()

        if hit == 1 then
            if GetEntityType(entity) ~= 0 then
                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        if Models[_]["job"] == nil then Models[_]["job"] = { "all" } end -- Nil check for Job default to ALL if undefined
                        for k , v in ipairs(Models[_]["job"]) do 
                            if ((v == "all") or (PlayerJob and v == PlayerJob.name)) then  -- Added Nil Check for PlayerJob
                                if #(plyCoords - coords) <= Models[_]["distance"] then

                                    success = true

                                    SendNUIMessage({response = "validTarget", data = Models[_]["options"], object = entity, model = _})

                                    while success and targetActive do
                                        local plyCoords = GetEntityCoords(playerPed)
                                        local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                        DisablePlayerFiring(playerPed, true)

                                        if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                            SetNuiFocus(true, true)
                                            SetCursorLocation(0.5, 0.5)
                                        end

                                        if GetEntityType(entity) == 0 or #(plyCoords - coords) > Models[_]["distance"] then
                                            success = false
                                        end

                                        Citizen.Wait(1)
                                    end
                                    SendNUIMessage({response = "leftTarget"})
                                end
                            end
                            
                        end
                    end
                end
                --Vehicle Bones
                -- if nearestVehicle then
                --     for _, bone in pairs(Bones) do
                --         local boneIndex = GetEntityBoneIndexByName(nearestVehicle, _)
                --         local bonePos = GetWorldPositionOfEntityBone(nearestVehicle, boneIndex)
                --         local distanceToBone = GetDistanceBetweenCoords(bonePos, plyCoords, 1)
                --         if #(bonePos - coords) <= Bones[_]["distance"] then
                --             for k , v in ipairs(Bones[_]["job"]) do
                --                 if v == "all" or v == PlayerJob.name then
                --                     if #(plyCoords - coords) <= Bones[_]["distance"] then
                --                         success = true
                --                         newOptions = {}
                --                         for i, op in ipairs(Bones[_]["options"]) do
                --                         	table.insert(newOptions,Bones[_]["options"][i])
                --                         end
                --                         SendNUIMessage({response = "validTarget", data = newOptions})

                --                         while success and targetActive do
                --                             local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                --                             local hit, coords, entity = RayCastGamePlayCamera(7.0)
                --                             local boneI = GetEntityBoneIndexByName(nearestVehicle, _)

                --                             DisablePlayerFiring(PlayerPedId(), true)

                --                             if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                --                                 SetNuiFocus(true, true)
                --                                 SetCursorLocation(0.5, 0.5)
                --                             end

                --                             if #(plyCoords - coords) > Bones[_]["distance"] then
                --                                 success = false
                --                             end

                --                             Citizen.Wait(1)
                --                         end
                --                         SendNUIMessage({response = "leftTarget"})
                --                     end
                --                 end
                --             end
                --         end
                --     end
                -- end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    if Zones[_]["targetoptions"]["job"] == nil then Zones[_]["targetoptions"]["job"] = { "all" } end -- Nil check for Job default to ALL if undefined
                    for k , v in ipairs(Zones[_]["targetoptions"]["job"]) do 
                        if ((v == "all") or (PlayerJob and v == PlayerJob.name)) then -- Added Nil Check for PlayerJob
                            if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then

                                success = true

                                SendNUIMessage({response = "validTarget", data = Zones[_]["targetoptions"]["options"]})
                                while success and targetActive do
                                    local plyCoords = GetEntityCoords(playerPed)
                                    local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                    DisablePlayerFiring(playerPed, true)

                                    if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                            SetNuiFocus(true, true)
                                            SetCursorLocation(0.5, 0.5)

                                    elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                    end
        
                                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                                        success = false
                                    end
        

                                    Citizen.Wait(1)
                                end
                                SendNUIMessage({response = "leftTarget"})
                            end
                            
                        end
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

    if data.event.args then
        TriggerEvent(data.event.event, data)
    else
        TriggerEvent(data.event.event)
    end
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)
    success = false

    targetActive = false
end)

--Added functions
function GetNearestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    if not (playerCoords and playerPed) then
        return
    end

    local pointB = GetEntityForwardVector(playerPed) * 0.001 + playerCoords

    local shapeTest = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z, pointB.x, pointB.y, pointB.z, 1.0, 10, playerPed, 7)
    local _, hit, _, _, entity = GetShapeTestResult(shapeTest)

    return (hit == 1 and IsEntityAVehicle(entity)) and entity or false
end

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

function AddTargetBone(bones, parameteres)
    for _, bone in pairs(bones) do
        Bones[bone] = parameteres
    end
end

function RemoveZone(name)
    if not Zones[name] then return end
    if Zones[name].destroy then
        Zones[name]:destroy()
    end

    Zones[name] = nil
end

exports("AddCircleZone", AddCircleZone)

exports("AddBoxZone", AddBoxZone)

exports("AddPolyzone", AddPolyzone)

exports("AddTargetModel", AddTargetModel)

exports("AddTargetBone", AddTargetBone)

exports("RemoveZone", RemoveZone)
