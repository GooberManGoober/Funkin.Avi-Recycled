var circusPath:String = 'stages/circus/';

function onLoad()
{
    defaultCamZoom = 1;
    cameraSpeed = 2;

    var sky = new FlxSprite(-1280 * .25,  -720 * .2, Paths.image(circusPath + 'sky'));
    sky.scrollFactor.set(.05, .05);
    sky.scale.set(.75, .75);
    sky.updateHitbox();
    add(sky);

    var floor = new FlxSprite(-1280, -720, Paths.image(circusPath + 'floor'));
    floor.scale.set(1.1, 1.1);
    add(floor);

    var tent = new FlxSprite(-1280, -720, Paths.image(circusPath + 'tent'));
    add(tent);
}

function onCreatePost()
{
    var tentsfront = new FlxSprite(-1280 * 1.2, -720, Paths.image(circusPath + 'tentsfront'));
    tentsfront.scrollFactor.set(1.25, 1.25);
    tentsfront.scale.set(1.15, 1.15);
    add(tentsfront);
}

function opponentNoteHit(note)
{
    if (health > 0.4)
        health -= 0.01;

    camHUD.angle = FlxG.random.float(-1.5, 1.5);
    camGame.shake(0.0035, 0.05);
    camHUD.shake(0.002, 0.035);
    FlxTween.tween(camHUD, {angle: 0}, .025);
}