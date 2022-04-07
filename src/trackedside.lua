

--
--GLOBALS
--


--
--TrackedSide Object
--
TrackedSide = {}
TrackedSide.__index = TrackedSide


function TrackedSide:new(guid,name)
    local instance = {}   -- create object if user does not provide one
    setmetatable(instance, TrackedSide)
    instance.guid = guid
    instance.name = name
    instance.objectives = {}
    instance.units = {}
    instance.armies = {}
    return instance
end

-- Gets the guid of the side
function TrackedSide:getGuid()
    return self.guid
end

-- Gets the name of the side
function TrackedSide:getName()
    return self.name
end

function TrackedSide:addObjective(objective)
    table.insert(self.objectives, objective)
end

function TrackedSide:getObjectives()
    return self.objectives
end

function TrackedSide:addUnit(unit)
    table.insert(self.units,unit)
end

function TrackedSide:getUnits()
    return self.units
end

function TrackedSide:addArmy(army)
    table.insert(self.armies,army)
end

function TrackedSide:getArmies()
    return self.armies
end


--
--TrackedSideManager Object
--
TrackedSideManager = {}
TrackedSideManager.__index = TrackedSideManager

--- Instantiates a new TrackedSideManager
function TrackedSideManager:new()
    local instance = {}   -- create object if user does not provide one
    setmetatable(instance, TrackedSideManager)
    instance.sides = {}
    return instance
end

--- Adds a side to track
---@param side TrackedSide
function TrackedSideManager:addSide(side)
    table.insert(self.sides, side)
end

function TrackedSideManager:getSides()
    return self.sides
end

--- Parses all sides for a list of sides to track
function TrackedSideManager:parseSideTable()
    local sides = VP_GetSides()
    for k,v in ipairs(sides) do
        local currentSideName = v.name
        if not (string.find(currentSideName,"<CMOAI>")==nil)
        then
            --if the guid contains <CMOAI>
            --register it to the trackedsidemanager
            local side = TrackedSide:new(v.guid,v.name)
            self:addSide(side)
        end
    end
end



--
--Initialize Tracking Sides
--

function initTrackedSideManager()
    sideManager = TrackedSideManager:new()
    sideManager:parseSideTable()
    --add objectives, units
    for k,v in ipairs(sideManager:getSides()) do
        local currentSide = v
        --get objectives
        getAllObjectivesForSide(currentSide)
        --get units
        for unitk,unit in ipairs(VP_GetSide({Side = currentSide:getName()}).units) do
            currentSide:addUnit(unit)
        end
    end
    -- logObject("TrackedSideManager",sideManager)
end

