



--
-- Globals
--
objectiveIdCounter = 0


--
--TrackedSideObjectiveRegion
--
TrackedSideObjectiveRegion = {}
TrackedSideObjectiveRegion.__index = TrackedSideObjectiveRegion

--- Instantiates a new TrackedSideManager
function TrackedSideObjectiveRegion:new()
    local instance = {}   -- create object if user does not provide one
    setmetatable(instance, TrackedSideObjectiveRegion)
    instance.points = {}
    return instance
end


function TrackedSideObjectiveRegion:addPoint(point)
    table.insert(self.points, point)
end

function TrackedSideObjectiveRegion:getPoints()
    return self.points
end

function regionSortFunc(k1, k2)
    -- ScenEdit_SpecialMessage("playerSide", dump(centerpoint).."<br>"..dump(k1).."<br>"..dump(k2))
    return getAngle(centerpoint,k1) < getAngle(centerpoint,k2)
end

function TrackedSideObjectiveRegion:sortPoints()
    centerpoint = calculateCenterpoint(self.points)
    -- logObject("self.points",self.points)
    local newTable = self.points
    table.sort(newTable,regionSortFunc)
    self.points = newTable
end


--
--TrackedSideObjective
--
TrackedSideObjective = {}
TrackedSideObjective.__index = TrackedSideObjective
TrackedSideObjective.types = { control = "control", eradicate = "eradicate" }
TrackedSideObjective.statuses = { complete = "complete", failed = "failed", notcomplete = "notcomplete" }

--- Instantiates a new TrackedSideManager
function TrackedSideObjective:new(id,type)
    local instance = {}   -- create object if user does not provide one
    setmetatable(instance, TrackedSideObjective)
    instance.id = id
    instance.type = type
    instance.status = TrackedSideObjective.statuses.notcomplete
    instance.region = {}
    return instance
end

function TrackedSideObjective:getId()
    return self.id
end

--- Attaches a region to this objective
---@param region TrackedSideObjectiveRegion
function TrackedSideObjective:attachRegion(region)
    self.region = region
end

--- Returns the region assigned to this objective
function TrackedSideObjective:getRegion()
    return self.region
end

function TrackedSideObjective:getType()
    return self.type
end

function TrackedSideObjective:codeToObjType(code)
    if(code==CMOAI_OBJECTIVE_CODE_ERADICATE)
    then
        return TrackedSideObjective.types.eradicate
    elseif (code==CMOAI_OBJECTIVE_CODE_CONTROL) then
        return TrackedSideObjective.types.control
    end
    return TrackedSideObjective.types.eradicate
end


--
--objective setup
--

local CMOAI_OBJECTIVE_CODE_ERADICATE = "ER"
local CMOAI_OBJECTIVE_CODE_CONTROL = "CT"

--Example format
--<CMOAI>O1_1_ER  (Objective 1, waypoint 1, type eradicate)

--- Parses all objectives for a given side
---@param side TrackedSide
function getAllObjectivesForSide(side)
    local sideName = side:getName()
    local regions = {}
    local objectiveId = 1
    local waypointCount = 1
    local objectiveType = CMOAI_OBJECTIVE_CODE_ERADICATE

    local pointAccumulator = {}
    local foundPreviousObj = true

    --loop looking for new objective points
    local shouldRun = true
    local incrementCount = 0
    while(shouldRun) do
        --break infinite loops just in case
        incrementCount = incrementCount + 1
        if(incrementCount > 100)
        then
            shouldRun = false
        end

        --actual logic
        local nameToCheck = "<CMOAI>O"..objectiveId.."_"..waypointCount.."_"..objectiveType
        local currentPoints = ScenEdit_GetReferencePoints({side=sideName, area={sideName,nameToCheck}})
        if(#currentPoints < 2)
        then
            --if point accumulator isn't empty, we have a valid region
            --   create TrackedSideObjectiveRegion from points
            --   increment to whatever we need to do next (new objectiveId, or objectiveType)
            --else if previous waypoint also doesn't exist, we know we're done parsing
            --else increment waypoint count
            if(tableIsEmpty(pointAccumulator))
            then
                if(objectiveType == CMOAI_OBJECTIVE_CODE_ERADICATE)
                then
                    objectiveType = CMOAI_OBJECTIVE_CODE_CONTROL
                else
                    if(foundPreviousObj==true)
                    then
                        foundPreviousObj = false
                        objectiveId = objectiveId + 1
                        objectiveType = CMOAI_OBJECTIVE_CODE_ERADICATE
                        waypointCount = 1
                    else
                        --we know there aren't any other objective types
                        --we weren't already able to find waypoints for all other objective types
                        --won't find any more objectives
                        shouldRun = false
                    end
                end
            else
                --create region object
                local newRegion = TrackedSideObjectiveRegion:new()
                for k,v in ipairs(pointAccumulator) do
                    newRegion:addPoint(v)
                end
                --points are organized counterclockwise
                newRegion:sortPoints()
                --create objective object
                local newObj = TrackedSideObjective:new(objectiveId,TrackedSideObjective:codeToObjType(objectiveType))
                newObj:attachRegion(newRegion)
                --attach to side
                side:addObjective(newObj)
                -- logObject("newRegion",newRegion)
                --incrementer objectiveId
                objectiveId = objectiveId + 1
                --set objectiveType to start of types
                objectiveType = CMOAI_OBJECTIVE_CODE_ERADICATE
                --set waypointCount to 1
                waypointCount = 1
                --let engine know we found previous obj
                foundPreviousObj = true
                --zero out pointAccumulator
                for k,v in pairs(pointAccumulator) do pointAccumulator[k]=nil end
            end
        else
            table.insert(pointAccumulator, currentPoints[2])
            waypointCount = waypointCount + 1
        end
    end
    -- local nameToCheck = "<CMOAI>O"..objectiveId.."_"..waypointCount.."_"..objectiveType
end


