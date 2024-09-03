local scaryasfwords = {
	'boo!!!',
	'March 18th',
 	'#####',
  	'hacked',
	'due die',
	"i’m gonna get you",
    'john doe is awesome!',
	'too easy',
	'wait die yes yes die die !!####',
	'666',
	'USE 666',
    '@infry KID',
	'john footpenis',
	'/e free!',
	'/e dance',
	'/e danec'
}
local scarylength = 0
local randomJumpTimer = 15

local scaryAssAppTitles = {
    'vs john doe fnf!!',
    'john doe!!!!',
    'ahhh booo',
    'march 18 fnf',
    'KYS !!!',
    'roblox scary horrro',
    'penis!',
    'roblox scary',
    'scary roblox horror',
    'john die scary march 18 horror fnf theme mod fnf sonic exe@m',
    'yeah',
    'john footpenis!'
}
local scaryTitleLength = 0

local ogClientPrefsZoom
local shaderName = "GlitchA"

local gointofakegameover = false
function onCreate()
    makeLuaSprite("ohio", 'home - Copy', -90, 50)
    addLuaSprite("ohio")
    scaleObject('ohio',1.12,1.12);

    makeLuaSprite("bgwall", 'bg', -250, 0)
    setScrollFactor("bgwall", 0.9, 0.9)
    addLuaSprite("bgwall")

    makeLuaSprite("floor", 'floor', 150, 700)
    addLuaSprite("floor")

   





    setProperty('bgwall.antialiasing',false)
    setProperty('floor.antialiasing',false)
   
    setProperty('ohio.antialiasing',false)

    makeLuaSprite("hudelement", 'hudbar')
    setGraphicSize("hudelement", 1280, 0, true)
    setObjectCamera("hudelement", 'other')
    addLuaSprite("hudelement", true)

    math.randomseed(os.time()) --random funny name for the app
    scaryTitleLength = 0
    for _ in pairs(scaryAssAppTitles) do scaryTitleLength = scaryTitleLength + 1 end
    title = scaryAssAppTitles[math.random(1, scaryTitleLength)]
    addHaxeLibrary('Application', 'lime.app')
    runHaxeCode([[
        Application.current.window.title = "]]..title..[[";
    ]])

    makeLuaSprite("GlitchA")
    makeGraphic("shaderImage", screenWidth, screenHeight)
    setSpriteShader("shaderImage", "GlitchA")
    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        game.initLuaShader(shaderName);
        var shader0 = game.createRuntimeShader(shaderName);
        game.getLuaObject('house2').shader = shader0;
        game.getLuaObject('sky2').shader = shader0;
        game.getLuaObject("GlitchA").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        return;
    ]])
    setShaderFloat("GlitchA", "glitchAmount", 0.000001) 
    setPropertyFromClass("GameOverSubstate", "characterName", 'rbf') 
    setPropertyFromClass("GameOverSubstate", "deathSoundName", 'boom') 

end

function onCreatePost() -- sure ig
    setProperty("iconP1.visible", false)
    setProperty("iconP2.visible", false)
	setProperty('timeBarBG.visible',false)
	setProperty('timeBar.visible',false)
	setProperty('timeTxt.visible',false)
    setTextFont('scoreTxt','bobos.ttf')

    setProperty("healthBarBG.visible", false)
    setProperty('healthGain', 0.5)
    setProperty('healthLoss', 0.5)
    setProperty('health', 1.5)
    makeLuaSprite("emptyhp", 'hb')
    makeLuaSprite("filledhp", 'hbfilled') --heathaele
    runHaxeCode([[
		game.healthBar.createImageBar(game.getLuaObject('emptyhp').pixels,game.getLuaObject('filledhp').pixels);
		game.healthBar.updateBar();
	]])
    setProperty('healthBar.x',973.5)
    setProperty('healthBar.y',53.2)  
    setObjectCamera('healthBar','other')

	if downscroll then
		setProperty('scoreTxt.x', getProperty('scoreTxt.x') - 200)
		setProperty('scoreTxt.y', getProperty('scoreTxt.y') - 60)
    else
        for i = 0,7 do
            noteTweenY('noteTween'..i, i, 100, 0.01)   
        end
	end
    createIcon()

end

function onUpdate(elapsed)
    if getProperty('health') < 1 and not gointofakegameover then -- yeah man.
        setProperty('health', -999999)
    end

    if curBeat < 472 then
        setProperty('camOther.zoom', getProperty('camHUD.zoom'))
        randomJumpTimer = randomJumpTimer - elapsed;
        if randomJumpTimer < 0 then
            math.randomseed(os.time())
            randomJumpTimer = math.random(10,15)
            willItJump = math.random(1,2)
            if willItJump == 1 then
                scaryJumpscare()
            end
        end
    end

    setShaderFloat("GlitchA", "iTime", os.clock())

    animateIcon()

end

function onBeatHit()

	if curBeat < 336 then
		playAnim("bgwall", "s", true)
    end
	if curBeat >= 400 then --and not was being fucky 
		playAnim("bgwall", "s", true)
	end

end

function onEvent(eventName, value1, value2)
    if eventName == 'setGlitchAmount' and value1 > '0' and not botPlay then
        setProperty('health', getProperty('health') - 0.1)
    end
    if eventName == 'JohnSwapBG' then
        swapBG()
    end
    if eventName == 'Change Character' then
        runHaxeCode([[
            game.healthBar.createImageBar(game.getLuaObject('emptyhp').pixels,game.getLuaObject('filledhp').pixels);
            game.healthBar.updateBar();
        ]])
    end
    if eventName == 'setGlitchAamount' then
        setShaderFloat("GlitchA", "glitchAmount", value1)  
    end
end

function scaryJumpscare() --may rip this out into a seperate script
    makeLuaSprite('graybg')
    makeGraphic("graybg", 1280, 720, '999999')
    addLuaSprite('graybg')
    setObjectCamera('graybg', 'other')
    setProperty('graybg.alpha', 0.4)

    scarylength = 0
    for _ in pairs(scaryasfwords) do scarylength = scarylength + 1 end
    words = scaryasfwords[math.random(1, scarylength)]
    makeLuaText("scaryasf", words, screenWidth)
    setTextFont("scaryasf", "Creepster-Regular.ttf")
    setTextSize("scaryasf", 60)
    setTextBorder("scaryasf", 0, "")
    setTextColor("scaryasf", "000000")
    setObjectCamera('scaryasf', 'other')
    screenCenter("scaryasf", 'y')
    addLuaText("scaryasf")
    runTimer("endingscary", 2)
end

function onTimerCompleted(r)
    if r == 'endingscary' then
        setProperty('scaryasf.visible', false)
        setProperty('graybg.visible', false)
        removeLuaSprite("graybg", true)
        removeLuaText("scaryasf", true)
    end
end

function swapBG()

    if getProperty("bgwall.alpha") == 0 then
        newoffset = 0
        bg1alpha = 1
        bg2alpha = 0
    else
        newoffset = -100  
        bg1alpha = 0
        bg2alpha = 1
    end
    triggerEvent("addBaseOffsetCam", 0, newoffset)

    doTweenAlpha("wallfade", "bgwall", bg1alpha, 3, "linear")
    doTweenAlpha("floorfade", "floor", bg1alpha, 3, "linear")
    doTweenAlpha("frienfade", "frien", bg1alpha, 3, "linear")

    doTweenAlpha("housefade", "house2", bg2alpha, 3, "linear")
    doTweenAlpha("skyfade", "sky2", bg2alpha, 3, "linear")
    doTweenAlpha("groundfade", "extraground2", bg2alpha, 3, "linear")
end

function onDestroy()
    runHaxeCode([[
        Application.current.window.title = "Friday Night Funkin': Psych Engine";
    ]])
end


function createIcon()
    makeLuaSprite("secondicon")
    loadGraphic("secondicon", "icons/ididit", 166, 150)
    addAnimation("secondicon", "win", {0})
    addAnimation("secondicon", "default", {1})
    addAnimation("secondicon", "lose", {2})
    playAnim("secondicon", "default")
    addLuaSprite('secondicon',true)
    setObjectCamera('secondicon', 'other')
    setProperty('secondicon.x', 820)

end

function animateIcon() --fake icon

    setProperty('secondicon.scale.y', getProperty('iconP1.scale.y'))
    setProperty('secondicon.scale.x', getProperty('iconP1.scale.x'))
    setProperty('secondicon.angle', getProperty('iconP1.angle'))
    
    if (getProperty("healthBar.percent") < 60) then
        playAnim("secondicon", "lose")
    elseif getProperty("healthBar.percent") > 90 then
        playAnim("secondicon", "win")
    else
        playAnim("secondicon", "default")
    end
end

local xx = 750;
local yy = 560;
local xx2 = 750;
local yy2 = 560;
local ofs = 20;
local followchars = true;
local del = 0;
local del2 = 0;


function onUpdate()
	if del > 0 then
		del = del - 1
	end
	if del2 > 0 then
		del2 = del2 - 1
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


