function VP_GetSides()
    return {
        {
            name="<CMOAI>Blue",
            guid="SideBlue",
            units={
                { name = 'Inf Plt (Generic)', guid = 'Infantry' }
            },
            contacts={}
        },
        {
            name="<CMOAI>Red",
            guid="SideRed",
            units={
                { name = 'Inf Plt (Generic)', guid = 'Infantry' }
            },
            contacts={}
        },
    }
end

function ScenEdit_GetReferencePoints(input)
    local side = input.side
    local refPts = input.area
    if(#refPts > 1 and string.find(refPts[2],"<CMOAI>O1") ~= nil and string.find(refPts[2],"ER") ~= nil and string.find(refPts[2],'5') == nil) then
        return {
            {
                name=side,
                latitude=1,
                highlighted=True,
                guid=side,
                longitude=1,
                locked=False,
                side=side
            },
            {
                name=refPts[2],
                latitude=1,
                highlighted=True,
                guid=refPts[2],
                longitude=1,
                locked=False,
                side=side
            }
        }
    end
    return {
        {
            name=side,
            latitude=1,
            highlighted=True,
            guid=side,
            longitude=1,
            locked=False,
            side=side
        }
}
end

function VP_GetSide(side)
    local sideName = side.Side
    if(string.find(sideName,"<CMOAI>Blue")) then
        return {
            guid=sideName,
            name=sideName,
            units={
                { name = 'Inf Plt (Generic)', guid = 'Infantry' }
            },
            contacts={}
        }
    end
    if(string.find(sideName,"<CMOAI>Red")) then
        return {
            guid=sideName,
            name=sideName,
            units={
                { name = 'Inf Plt (Generic)', guid = 'Infantry' }
            },
            contacts={}
        }
    end
    return {
        guid = "GenericSide",
        name = sideName,
        units = {
            {GUID="A",name="inf Bty"}
        }
    }
end

function ScenEdit_SpecialMessage(side,text)
    print(text)
end


function ScenEdit_AddMission(sideName,objectiveName,missionType,missionOptions)
    return {
        guid=objectiveName..sideName,
        name=objectiveName,
        isactive=false,
        side=sideName,
        type=missionType,
        patrolmission={},
    }
end


function ScenEdit_SetMission(sideName,objectiveName,mission)
    return mission
end

function ScenEdit_AssignUnitToMission(unitGUID,missionGUID)
    print('unit'..unitGUID..' added to mission '..missionGUID)
end

