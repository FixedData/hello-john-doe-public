
function onUpdate(elapsed)
    if (keyboardJustPressed("TWO")) then
        runHaxeCode([[
            game.setSongTime(Conductor.songPosition + 10000);
            game.clearNotesBefore(Conductor.songPosition);
        ]])
    end
end