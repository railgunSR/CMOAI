

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
-- Reference point stuff
--
function getAngle(centerPoint,targetPoint)
   local centerX = centerPoint.latitude or 0
   local centerY = centerPoint.longitude or 0
   local targetX = targetPoint.latitude or 0
   local targetY = targetPoint.longitude or 0
   local angle = math.atan(targetX-centerX,targetY-centerY)
   if(angle < 0)
   then
      angle = angle + math.pi * 2
   end
   return angle
end

function calculateCenterpoint(points)
   local accumulatorX = 0
   local accumulatorY = 0
   local numberPoints = 0
   for k,v in ipairs(points) do
      numberPoints = numberPoints + 1
      accumulatorX = accumulatorX + v.latitude
      accumulatorY = accumulatorY + v.longitude
   end
   local avgX = accumulatorX / numberPoints
   local avgY = accumulatorY / numberPoints
   local rVal = {latitude=avgX,longitude=avgY}
   return rVal
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