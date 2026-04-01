function onLoad()
{
    var whiteVoid:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.WHITE);
    whiteVoid.screenCenter();
    add(whiteVoid);

    var line:FlxSprite = new FlxSprite(-80, 0).loadGraphic(Paths.image('Funkin_avi/stages/fuckingLine/theLine'));
    line.scale.set(1.3, 1.3);
    add(line);
}

function opponentNoteHit(note)
{
    boyfriend.x += 1.2;
    boyfriend.y -= 1.2;
    boyfriend.scale.x -= 0.0012;
    boyfriend.scale.y -= 0.0012;

    if (ClientPrefs.mechanics)
    {
        if(health > 0.05) // trol
            health -= 0.015;
    }
}

function goodNoteHit(note)
{
    boyfriend.x -= 1.4;
    boyfriend.y += 1.4;
    boyfriend.scale.x += 0.0014;
    boyfriend.scale.y += 0.0014;
}