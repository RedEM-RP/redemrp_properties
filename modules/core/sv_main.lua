local coreModule = registerModule("core")

RegisterServerEvent("redemrp_properties:getProperties")
AddEventHandler("redemrp_properties:getProperties", function()
    TriggerClientEvent("redemrp_properties:sendProperties", source, _properties)
end)

RegisterServerEvent("redemrp_properties:ready")
AddEventHandler("redemrp_properties:ready", function()
    TriggerClientEvent("redemrp_properties:sendProperties", source, _properties)
end)

RegisterServerEvent("redemrp_properties:purchase")
AddEventHandler("redemrp_properties:purchase", function(key)
    local _source = source

    local player = exports.redem_roleplay:getPlayerFromId(_source)

    for k,v in ipairs(_modules) do
        if v.handlers.purchaseHandler then
            v.handlers.purchaseHandler(key, _properties[key], player, _source)
        end
    end
end)

RegisterCommand("ptp", function(source, args)
    TriggerClientEvent("redemrp_properties:adminTeleport", source, tonumber(args[1]))
end, false)