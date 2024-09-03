local testing = {}
--made by dataticking again yes

local ogClientPrefsZoom
function onCreate()
    ogClientPrefsZoom = getPropertyFromClass("ClientPrefs", "camZooms")
end
function onEvent(eventName, value1, value2) 
    if eventName == 'awesomeZoom' then

        for i, v in ipairs(testing) do testing[i] = nil end

        for w in string.gmatch(value1,'([^,]+)') do
            table.insert(testing,w)
        end

        setProperty('camZooming',false)
        setPropertyFromClass("ClientPrefs", "camZooms",false)
        cancelTween("asf")
        if testing[3] ~= nil then
            setProperty('defaultCamZoom',testing[1])
        end
        doTweenZoom("asf", "camGame", testing[1], testing[2], value2)
    end
end

function onTweenCompleted(r)
    if r == 'asf' then
        if testing[3] ~= nil then
            setProperty('camGame.zoom',getProperty("defaultCamZoom"))
        end
        setPropertyFromClass("ClientPrefs", "camZooms",ogClientPrefsZoom)
    end

end
function onDestroy()
    setPropertyFromClass("ClientPrefs", "camZooms",ogClientPrefsZoom)
end

