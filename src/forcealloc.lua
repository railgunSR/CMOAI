


--
--Functions for creating army groups and allocating units and objectives
--



function generateArmyGroups()
    -- ScenEdit_SpecialMessage("playerSide", "gen army groups")
    for k,s in ipairs(sideManager:getSides()) do
        local currentSide = s
        --assign units
        for j,v in ipairs(currentSide:getUnits()) do
            local currentUnit = v
            local fullUnit = ScenEdit_GetUnit({GUID=currentUnit.guid})
            if (isGroundUnit(fullUnit))
            then
                print("is ground")
                if(isMobileGroundUnit(fullUnit))
                then
                    print("is mobile")
                    if(isMechInf(fullUnit))
                    then
                        assignToArmyOfRole(currentSide,fullUnit,ArmyGroup.types.landmain)
                    elseif(isArty(fullUnit))
                    then
                        assignToArmyOfRole(currentSide,fullUnit,ArmyGroup.types.arty)
                    end
                end
            end
            if (isAirUnit(fullUnit))
            then
                if(isHelicopter(fullUnit))
                then
                    assignToArmyOfRole(currentSide,fullUnit,ArmyGroup.types.heli)
                end
            end
            -- ScenEdit_SpecialMessage("playerSide", "added unit")
        end
    end
end

armyDistCutoff = 5

function assignToArmyOfRole(side,unit,armyRole)
    local assigned = false
    local unitLoc = getUnitLocation(unit)
    print("assign")
    for j,army in ipairs(side:getArmies()) do
        if( army:getType()==armyRole and --if role matches
            math.abs(getDistance(unitLoc,getUnitListLocation(army:getUnits()))) < armyDistCutoff and --if we're close enough
            assigned == false --if we haven't already assigned to an army
        )
        then
            assigned = true
            army:addUnit(unit)
        end
    end
    -- if we haven't already assigned it, create a new army of type
    if(assigned == false)
    then
        local armyGroup = ArmyGroup:new(side:getName(),armyRole)
        armyGroup:addUnit(unit)
        side:addArmy(armyGroup)
    end
end


function orderArmies()
    for sidek,side in ipairs(sideManager:getSides()) do
        for armyk,army in ipairs(side:getArmies()) do
            -- ScenEdit_SpecialMessage("playerSide", "generated orders")
            -- army:generateOrders()
            -- army:applyOrders()
        end
    end
end





