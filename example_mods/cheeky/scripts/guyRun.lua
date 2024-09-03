
local farthestLeft = -500
local farthestRight = 800

local baseY = 0

local running = false;
local init = false
function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' and value1 == 'penis' then
        baseY = getProperty("dad.y")
        runtwo()
        init=true
    end
end


function runtwo()
    if not running then
        flipX = getRandomBool()
        speed = 30000
        if getRandomBool(80) then
            speed = 7000
        end
        if getRandomBool(10) then
            speed = 100000
        end

        --perspective?
        local newY = baseY + getRandomInt(-100,100)
        local scale = 1
        if newY < baseY then
            scale = 0.5
        end
        if newY > (baseY) then
            scale = 1.1
        end

        
        setProperty("dad.y", newY)
        scaleObject("dad", scale,scale)

        runHaxeCode([[

            if (game.dad.y > game.boyfriend.y) {
                game.remove(game.dadGroup);
                game.insert(game.members.indexOf(game.boyfriendGroup) + 1,game.dadGroup);
            }
            else  
            {
                game.remove(game.dadGroup);
                game.addBehindBF(game.dadGroup);
            }
        ]])

 

    


        if flipX then
            setProperty("dad.flipX", true)  
            setProperty("dad.velocity.x", speed)  
            setProperty("dad.x", farthestLeft - getProperty("dad.width"))  
        else
            setProperty("dad.flipX", false)  
            setProperty("dad.velocity.x", -speed)  
            setProperty("dad.x", farthestRight + getProperty("dad.width"))  
        end

        running = true;
    end
end

function onSectionHit()
    if not running and init then
        runtwo()
    end
    
end

function onUpdate(elapsed)
    if getProperty('dad.x') > farthestRight + getProperty('dad.width') or getProperty('dad.x') < farthestLeft - getProperty("dad.width") then running = false end
end