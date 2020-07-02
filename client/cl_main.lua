_properties = {}
_modules = {}
local createdPrompt = false

_playerPosition = vector3(10.0, 10.0, 10.0)

Citizen.CreateThread(function()
    while true do
        _playerPosition = GetEntityCoords(PlayerPedId())

        Citizen.Wait(200)
    end
end)

AddEventHandler("onResourceStop", function(name)
    if(name == GetCurrentResourceName())then
        for k,v in ipairs(_properties)do
            RemoveBlip(v.blip)
        end

        if createdPrompt then
            PromptDelete(createdPrompt)
        end
    end
end)

RegisterNetEvent("redemrp_properties:sendProperties")
AddEventHandler("redemrp_properties:sendProperties", function(data)
    _properties = data

    for k,v in ipairs(_properties)do
        _properties[k].blip = N_0x554d9d53f696d002(1664425300, v.buy.x, v.buy.y, v.buy.z)
        SetBlipSprite(_properties[k].blip, -2024635066, 1)
        
        if(v.owner)then
            Citizen.InvokeNative(0x9CB1A1623062F402, _properties[k].blip, v.owner .. "'s " .. v.type)
        else
            Citizen.InvokeNative(0x9CB1A1623062F402, _properties[k].blip, "For Sale Property " .. v.type)
        end
    end
end)

RegisterNetEvent("redemrp_properties:updateOwnership")
AddEventHandler("redemrp_properties:updateOwnership", function(data)
    for k,v in ipairs(data)do
        for i,j in ipairs(_properties)do
            if (j.name == v.name)then
                _properties[i].owner = v.owner
                _properties[i].ownerData = {
                    character = v.characterID,
                    identifier = v.ownerID
                }
                Citizen.InvokeNative(0x9CB1A1623062F402, _properties[i].blip, _properties[i].owner .. "'s " .. _properties[i].type)

                for _,m in ipairs(_modules)do
                    if m.handlers.updateOwnership then
                        m.handlers.updateOwnership(data)
                    end
                end
            end
        end
    end
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)


    Citizen.InvokeNative(0x66E0276CC5F6B9DA, 2)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), 255)
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end

function CreateVarString(p0, p1, variadic)
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end

function DisplayHelpText(str)
	Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
	Citizen.InvokeNative(0x5F68520888E69014, str)
	Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, 0, 1, -1)
end

function SetupPrompt(identifier, control, grouping, text)
    if not PromptIsValid(identifier) then
        identifier = PromptRegisterBegin()
        PromptSetControlAction(identifier, control)
        local str = CreateVarString(10, 'LITERAL_STRING', text)
        PromptSetText(identifier, str)
        PromptSetEnabled(identifier, 1)
        PromptSetVisible(identifier, 1)
        Citizen.InvokeNative(0x74C7D7B72ED0D3CF, identifier, 1500)
        PromptSetGroup(identifier, grouping)
        PromptRegisterEnd(identifier)
    end

    return identifier
end

function registerModule(name)
    local id = #_modules + 1
    _modules[id] = {
        name = name,
        handlers = {}
    }

    _modules[id].setHandler = function(name, cb)
        _modules[id].handlers[name] = cb
    end

    print("^1[RedEM:RP Properties]^0 (Client) Module registered: " .. name)

    return _modules[id]
end

local firstSpawn = false

Citizen.CreateThread(function()
    while firstSpawn == false do
        local spawned = Citizen.InvokeNative(0xB8DFD30D6973E135 --[[NetworkIsPlayerActive]], PlayerPedId(), Citizen.ResultAsInteger())
        if spawned then
            TriggerServerEvent("redemrp_properties:ready")

            for k,v in ipairs(_modules)do
                if v.handlers.initialize then
                    v.handlers.initialize()
                end
            end

            firstSpawn = true
        end
    end
end)

RegisterNetEvent("redemrp_properties:adminTeleport")
AddEventHandler("redemrp_properties:adminTeleport", function(key)
    SetEntityCoords(PlayerPedId(), _properties[key].buy.x, _properties[key].buy.y, _properties[key].buy.z)
end)