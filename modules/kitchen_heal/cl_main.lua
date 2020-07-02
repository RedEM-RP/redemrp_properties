local kitchenHealModule = registerModule("kitchen heal")
local owns = {}

local promptIdentifier

AddEventHandler("onResourceStop", function(name)
    if(name == GetCurrentResourceName())then
        if promptIdentifier then
            PromptDelete(promptIdentifier)
        end
    end
end)

function setupHealPrompt()
    if not PromptIsValid(identifier) then
        identifier = PromptRegisterBegin()
        PromptSetControlAction(identifier, 0xCEFD9220)
        local str = CreateVarString(10, 'LITERAL_STRING', "Heal yourself")
        PromptSetText(identifier, str)
        PromptSetEnabled(identifier, 0)
        PromptSetVisible(identifier, 0)
        Citizen.InvokeNative(0x74C7D7B72ED0D3CF, identifier, 1500)
        PromptSetGroup(identifier, 0)
        PromptRegisterEnd(identifier)
    end

    return identifier
end

kitchenHealModule.setHandler("updateOwnership", function()
    TriggerServerEvent("redemrp_properties_kitchenHeal:getOwnership")
end)

kitchenHealModule.setHandler("initialize", function()
    TriggerServerEvent("redemrp_properties_kitchenHeal:getOwnership")

    promptIdentifier = setupHealPrompt()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            for k, v in ipairs(_properties)do
                local distance = Vdist2(v.kitchen.x, v.kitchen.y, v.kitchen.z, _playerPosition.x, _playerPosition.y, _playerPosition.z)

                if owns[v.name] then
                    if(distance < 50.0)then
                        Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, v.kitchen.x, v.kitchen.y, v.kitchen.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.1, 230, 230, 0, 155, 0, 0, 2, 0, 0, 0, 0)

                        if(distance < 2.0)then
                            PromptSetEnabled(promptIdentifier, 1)
                            PromptSetVisible(promptIdentifier, 1)

                            if Citizen.InvokeNative(0xE0F65F0640EF0617, promptIdentifier) then
                                SetEntityHealth(PlayerPedId(), 200.0)

                                exports.redem_roleplay.DisplayTip(0, "Healed!", 1000)

                                PromptSetEnabled(promptIdentifier, 0)
                                PromptSetVisible(promptIdentifier, 0)
                            end
                        else
                            PromptSetEnabled(promptIdentifier, 0)
                            PromptSetVisible(promptIdentifier, 0)
                        end
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent("redemrp_properties_kitchenHeal:sendOwnership")
AddEventHandler("redemrp_properties_kitchenHeal:sendOwnership", function(data)
    owns = data
end)