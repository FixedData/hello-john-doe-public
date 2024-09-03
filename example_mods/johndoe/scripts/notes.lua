--this is (i think) a really bad way of doing it but im really lazy

function onStartCountdown()
    runTimer('k', 0.00001)
    addHaxeLibrary('InputFormatter', 'backend')
end

function onTimerCompleted(t)
    if t == 'k' then
        for i = 0,3 do
            setPropertyFromGroup('strumLineNotes', i, "x", -1000)
        end
        runHaxeCode([[
    for (i in game.unspawnNotes) 
    {
        i.copyAlpha = false;
        i.noteSplashData.a = 1;
        if (i.isSustainNote) 
        {
            i.alpha = 1;
            i.multAlpha = 1;
        }
        for (p in game.playerStrums) 
        {

            i.antialiasing = p.antialiasing = false;
             i.rgbShader.enabled = i.noteSplashData.useRGBShader = p.useRGBShader = false;
            
        }
    }


    var notes = ['note_left','note_down','note_up','note_right'];
    for (i in 0...game.playerStrums.length) {

        game.playerStrums.members[i].x += 10;
        if (i > 0) {
            game.playerStrums.members[i].x += -4.7 * i;
        }
        game.playerStrums.members[i].alpha = 0.8;

       var note = game.playerStrums.members[i];


       var t = new AttachedFlxText(0,0,0,InputFormatter.keyFormatting(ClientPrefs.keyBinds.get(notes[i])[0]),20);
       t.sprTracker = note;
       t.copyAlpha = false;
       t.font = Paths.font('ARIAL.TTF');
       t.updateHitbox();
       t.yAdd = note.height - t.height + 5;
   
       insert(members.indexOf(note) + 1,t);
       t.cameras = [camHUD];
    }
        ]]);
    end
end
