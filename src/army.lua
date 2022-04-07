



--
--Unit discovery
--



ArmyGroup = {}
ArmyGroup.__index = ArmyGroup
ArmyGroup.types = { landrecon = "landrecon", landmain = "landmain", arty = "arty", landsupp = "landsupp" }

--- Instantiates a new ArmyGroup
---@param type string
function ArmyGroup:new(side,type)
    local instance = {}   -- create object if user does not provide one
    setmetatable(instance, ArmyGroup)
    instance.type = type
    instance.side = side
    instance.units = {}
    instance.objective = nil
    instance.mission = nil
    instance.units = {}
    return instance
end




function ArmyGroup:getType()
    return self.type
end


function ArmyGroup:getSide()
    return self.side
end



function ArmyGroup:addUnit(unit)
    table.insert(self.units,unit)
end

function ArmyGroup:getUnits()
    return self.units
end




--- Gets the objective of the army group
---@return TrackedSideObjective or nil
function ArmyGroup:getObjective()
    return self.objective
end

--- Sets the current objective of the army group
---@param objective TrackedSideObjective
function ArmyGroup:setObjective(objective)
    self.objective = objective
end





function ArmyGroup:getMission()
    return self.mission
end


function ArmyGroup:generateOrders()
    local objective = self.objective
        if (objective~=nil) then
        --get operational region
        local region = objective:getRegion()
        local regionPoints = region:getPoints()
        --get points that make up region in correct format
        local pointAcc = {}
        for k,v in ipairs(regionPoints) do
            local name = tostring(v.name)
            table.insert(pointAcc, name)
        end
        --get mission name
        local objectiveName = objective:getType().."_"..objective:getId()
        --generate mission
        self.mission = ScenEdit_AddMission(self.side,objectiveName,'patrol',{type='land',zone=pointAcc})
        self.mission.isactive = true
        self.mission.patrolmission.PatrolZone = pointAcc
        self.mission.patrolmission.subtype='asw'
        local options = {
            isactive=true,
            patrolmission={
                PatrolZone=pointAcc,
                subtype='asuw'
            }
        }
        -- print(self.side)
        -- print(objectiveName)
        -- print(dump(options))
        local newMission = ScenEdit_SetMission(self.side,objectiveName,options)
        self.mission = newMission
    end
end

function ArmyGroup:applyOrders()
    for k,v in ipairs(self.units) do
        local currentUnit = v
        ScenEdit_AssignUnitToMission (currentUnit.guid,self.mission.guid)
    end
end


