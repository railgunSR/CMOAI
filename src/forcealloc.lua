


--
--Functions for creating army groups and allocating units and objectives
--



function generateArmyGroups()
    -- ScenEdit_SpecialMessage("playerSide", "gen army groups")
    for k,s in ipairs(sideManager:getSides()) do
        local currentSide = s
        -- ScenEdit_SpecialMessage("playerSide", "start")
        local armyGroup = ArmyGroup:new(currentSide:getName(),ArmyGroup.types.landmain)
        -- ScenEdit_SpecialMessage("playerSide", "made army")
        --assign units
        for j,v in ipairs(currentSide:getUnits()) do
            armyGroup:addUnit(v)
            -- ScenEdit_SpecialMessage("playerSide", "added unit")
        end
        if not(tableIsEmpty(currentSide:getObjectives()))
        then
            -- ScenEdit_SpecialMessage("playerSide", "added obj")
            armyGroup:setObjective(currentSide:getObjectives()[1])
        end
        currentSide:addArmy(armyGroup)
    end
end


function orderArmies()
    for sidek,side in ipairs(sideManager:getSides()) do
        for armyk,army in ipairs(side:getArmies()) do
            -- ScenEdit_SpecialMessage("playerSide", "generated orders")
            army:generateOrders()
            army:applyOrders()
        end
    end
end





