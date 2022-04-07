

--
-- Determining what type of unit
--


--
--Ground units
--

function isMobileGroundUnit(unit)
    return string.find(unit.subtype,'5001') ~= nil
end


function isGroundUnit(unit)
    return string.find(unit.type,'Facility') ~= nil
end


function isInf(unit)
    return unit.category == 1000
end

function isMechInf(unit)
    return string.find(unit.name,'Mech Inf') ~= nil
end

function isArmor(unit)
    return unit.category == 2000
end

function isArty(unit)
    return string.find(unit.name,'Arty') ~= nil
end

function isAAA(unit)
    return unit.category == 5000 or unit.category == 6000
end





--
--Air units
--




function isAirUnit(unit)
    return string.find(unit.type,'Aircraft') ~= nil
end


function isHeli(unit)
    local category = unit.category
    if( category == 2003)
    then
       return true
    end
    return false
end




--
-- Location related utilities
--

function getUnitLocation(unit)
    return {
        latitude = unit.latitude,
        longitude = unit.longitude
    }
end

function getUnitListLocation(unitList)
    local accumulatorX = 0
    local accumulatorY = 0
    local number = 0
    for k,unit in ipairs(unitList) do
        number = number + 1
        accumulatorX = accumulatorX + unit.latitude
        accumulatorY = accumulatorY + unit.longitude
    end
    return {
        latitude = accumulatorX / number,
        longitude = accumulatorY / number
    }
end



