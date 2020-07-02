local houseModule = registerModule("housing")

houseModule.setHandler("purchaseHandler", function(propertyKey, property, player, _source)
    if(_properties[propertyKey] and not _properties[propertyKey].owned and property.type == "house")then
        if(player.getMoney() >= _properties[propertyKey].price)then
            player.removeMoney(_properties[propertyKey].price)

            _properties[propertyKey].owned = player.getName()
            _ownership[#_ownership
            
            + 1] = {
                name = _properties[propertyKey].name,
                owner = player.getName(),
                ownerID = player.getIdentifier(),
                characterID = player.getSessionVar("charid")
            }

            SaveResourceFile(GetCurrentResourceName(), "server/data/ownership.json", json.encode(_ownership))

            TriggerClientEvent("redemrp_properties:updateOwnership", -1, _ownership)

            for k,v in ipairs(_modules)do
                if v.handlers.housePurchased then
                    v.handlers.housePurchased(propertyKey, property, player, _source)
                end
            end
        end
    end
end)