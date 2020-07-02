local kitchenHealModule = registerModule("kitchen heal")

RegisterServerEvent("redemrp_properties_kitchenHeal:getOwnership")
AddEventHandler("redemrp_properties_kitchenHeal:getOwnership", function()
    local _source = source

    local player = exports.redem_roleplay:getPlayerFromId(_source)

    local owns = {}
    for k,v in ipairs(_ownership)do
        if v.ownerID == player.getIdentifier() and v.characterID == player.getSessionVar("charid") then
            owns[v.name] = true
        end
    end

    TriggerClientEvent("redemrp_properties_kitchenHeal:sendOwnership", _source, owns)
end)