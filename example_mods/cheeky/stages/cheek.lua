
local allowShader =false
function onCreate()
    setProperty('skipCountdown', true);
    makeLuaSprite("cb", 'cb', 0, 180)
    addLuaSprite("cb")
    scaleObject('cb',1.12,1.12);

    makeLuaSprite("gate", 'gate', 100, 180)
    scaleObject('gate',1.12,1.12);

    makeLuaSprite("shaderobj");
    initLuaShader("ripple")
    setSpriteShader("shaderobj", "ripple")


    runHaxeCode([[
        var shader = game.modchartSprites.get('shaderobj').shader;
        addShader(shader,FlxG.camera);
    ]])

end


function onEvent(eventName, value1, value2, strumTime)
    if eventName == 'Play Animation' and value1 == 'hey' and value2 == 'dad' then

    end
    if eventName == '' and value1 == 'itburns' then
        removeLuaSprite('black',true);
        setProperty('boyfriend.visible' , true)
        setProperty("camHUD.visible", true)
        runHaxeCode([[
            camHUD._fxFadeAlpha = 0;
        ]])
    end
    if eventName == '' and value1 == 'shader' then
        allowShader = true;
        runHaxeCode([[
            var shader = game.modchartSprites.get('shaderobj').shader;

            FlxTween.num(0,1,0.1,{},(f)->{
                shader.setFloat('ratio',f);
            });

            camHUD._fxFadeColor = FlxColor.WHITE;
            FlxTween.tween(camHUD, {_fxFadeAlpha: 1},1, {onComplete:Void->{
                removeShader(shader,FlxG.camera);
            }});
        ]])

        -- runTimer("sigh",0.5)
    end
end


--infry im gonna fucking kill you
local xx = 750;
local yy = 560;
local xx2 = 750;
local yy2 = 560;
local ofs = 20;
local followchars = true;


function onUpdate(elapsed)
    if allowShader then
        setProperty("shaderobj.x", getProperty("shaderobj.x") + elapsed)
        setShaderFloat("shaderobj", "iTime",getProperty("shaderobj.x"))

    end



    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else

            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end


function onStepHit()
    if curStep == 545 then
        setProperty('boyfriend.visible' , false)
    end

    if curStep == 656 then
        addLuaSprite("gate")
        removeLuaSprite("cb")
    end
end