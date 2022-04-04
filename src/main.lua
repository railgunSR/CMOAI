

--
--INITIALIZE
--
function initializeCMOAI()
    initTrackedSideManager()
end

initializeCMOAI()


--
--UPDATE
--
function updateCMOAI()
    
end

-- local side = sideManager:getSides()[2]

-- local points = side:getObjectives()[1]:getRegion():getPoints()

-- logObject("points",points)

-- local pointAcc = {}
-- for k,v in ipairs(points) do
--     local name = tostring(v.name)
--     table.insert(pointAcc, name)
-- end

-- logObject("pointAcc",pointAcc)

-- local mission = ScenEdit_AddMission(side:getName(),'Combat Patrol','patrol',{type='land',zone=pointAcc})
-- mission.isactive = true
-- mission.patrolmission.PatrolZone = pointAcc
-- mission = ScenEdit_SetMission(side:getName(),'Combat Patrol',mission)