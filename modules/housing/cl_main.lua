local housingModule = registerModule("housing")

housingModule.setHandler("initialize", function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            for k, v in ipairs(_properties)do
                local distance = Vdist2(v.buy.x, v.buy.y, v.buy.z, _playerPosition.x, _playerPosition.y, _playerPosition.z)

                if(v.owner)then
                    if(distance < (v.ownedRange or 200.0))then
                        DrawTxt(Config.Languages[Config.Language].private_property:gsub("_NAME", v.owner), 0.01, 0.03, 0.5, 0.5, 0, 255, 255, 255, false)
                    end
                end

                if (distance < 50.0) then
                    if(v.owner)then
                        Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, v.buy.x, v.buy.y, v.buy.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.1, 230, 230, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                    else
                        Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, v.buy.x, v.buy.y, v.buy.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.1, 0, 230, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                    end

                    if(distance < 2.0)then
                        if not v.owner then
                            if not createdPrompt then
                                createdPrompt = SetupPrompt(1, 0xCEFD9220, 0, Config.Languages[Config.Language].for_sale:gsub("_NAME", v.name):gsub("_PRICE", v.price))
                            end

                            if Citizen.InvokeNative(0xE0F65F0640EF0617, createdPrompt) then
                                activeProperty = k
                                TriggerServerEvent("redemrp_properties:purchase", k)
                            end
                        end
                    else
                        if createdPrompt then
                            PromptDelete(createdPrompt)

                            createdPrompt = nil
                        end
                    end
                end
            end
        end
    end)
end)

housingModule.setHandler("updateOwnership", function(data)
    for k,v in ipairs(data)do
        for i,j in ipairs(_properties)do
            if (j.name == v.name)then
                if i == activeProperty then
                    PromptDelete(createdPrompt)
                end
            end
        end
    end
end)