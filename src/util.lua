

--
-- UTILITIES
--


--
-- table stuff
--
function tableIsEmpty(table)
   return next(table) == nil
end


--
--Logging
--

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function logObject(objectName,object)
   ScenEdit_SpecialMessage("playerSide", objectName..dump(object))
end