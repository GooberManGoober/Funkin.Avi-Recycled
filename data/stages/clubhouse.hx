import openfl.filters.ShaderFilter;

//BIRTHDAY
var delusionalStreet:FlxSprite;
var clubhouse:FlxSprite;

var aberrationBoom:FlxRuntimeShader = newShader('aberration');
var aberrationTimer:Float = 0;

var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');

function onLoad()
{
    defaultCamZoom = 0.85;
    cameraSpeed = 1.35;

    aberrationBoom.setFloat('aberration', 0.001);
    aberrationBoom.setFloat('effectTime', 0.001);

    delusionalStreet = new FlxSprite(-500, -700);
    delusionalStreet.loadGraphic(Paths.image('favi/stages/theLoop/images/Mickeybg'));
    delusionalStreet.alpha = 0.0001;
    add(delusionalStreet);

    clubhouse = new FlxSprite(-410, -100);
    clubhouse.frames = Paths.getSparrowAtlas('favi/stages/clubhouse/images/daHouse');
    clubhouse.animation.addByPrefix('balloons bounce', 'daHouse idle', 12, true);
    clubhouse.animation.play('balloons bounce');
    clubhouse.scale.set(1.15, 1.15);
    clubhouse.updateHitbox();
    clubhouse.antialiasing = true;
    clubhouse.scrollFactor.set(1, 1);
    add(clubhouse);

    var vignette:FlxSprite = new FlxSprite(-250, -140).loadGraphic(Paths.image('favi/stages/clubhouse/images/vignetteOverlay'));
    vignette.cameras = [camOther];
    vignette.scale.set(0.75, 0.75);
    vignette.antialiasing = true;
    vignette.scrollFactor.set();
    vignette.active = false;
    add(vignette);

    if (ClientPrefs.shaders)
    {
        camGame.filters = [
            new ShaderFilter(aberrationBoom),
            new ShaderFilter(monitorFilter)
        ];

        camHUD.filters = [new ShaderFilter(grayScale)];
    }
}

function onBeatHit()
{
    // they start going on an acid trip lmao
    if (curBeat == 256)
    {
        camGame.shake(0.015, 1.3);
        defaultCamZoom = 1.1;
        aberrationBoom.setFloat('aberration', 0.03);
        aberrationBoom.setFloat('effectTime', 0.06);
    }
    if (curBeat == 258)
    {
        aberrationBoom.setFloat('aberration', 0.06);
        aberrationBoom.setFloat('effectTime', 0.12);
    }
    if (curBeat == 260)
    {
        defaultCamZoom = 0.76;
        aberrationBoom.setFloat('aberration', 0.12);
        aberrationBoom.setFloat('effectTime', 0.24);
    }
    if (curBeat == 320)
    {
        camGame.shake(0.025, 1.3);
        defaultCamZoom = 1;
        aberrationBoom.setFloat('aberration', 0.15);
        aberrationBoom.setFloat('effectTime', 0.30);
    }
    if (curBeat == 322)
    {
        aberrationBoom.setFloat('aberration', 0.18);
        aberrationBoom.setFloat('effectTime', 0.36);
    }
    if (curBeat == 324)
    {
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 0.5);
    }

    if (curBeat >= 324 && curBeat <= 387)
    {
        aberrationBoom.setFloat('aberration', aberrationTimer);
        aberrationBoom.setFloat('effectTime', aberrationTimer);
    }

    if (curBeat == 388)
    {
        defaultCamZoom = 0.85;
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 0.5);
        aberrationBoom.setFloat('aberration', 0.001);
        aberrationBoom.setFloat('effectTime', 0.001);
    }

    if (curBeat == 520)
    {
        camGame.alpha = 0.000001;
        camHUD.alpha = 0;
        camOther.flash(FlxColor.WHITE, 1);
        gfGroup.alpha = 0.0001;

        delusionalStreet.alpha = 1;
        clubhouse.alpha = 0.0001;
    }
}

function onUpdate(elapsed)
{
    aberrationTimer -= 0.01;

    muckneyHealthColorShitLol();
}

function onStepHit()
{
    switch (curStep)
    {
        case 2125: 
            camGame.alpha = 1;
        case 2144:
            camGame.alpha = 0;
    }
}

function muckneyHealthColorShitLol()
{
    muckneyColors = [FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)];

    healthBar.setColors(FlxColor.fromRGB(muckneyColors[0], muckneyColors[1], muckneyColors[2]), boyfriend.healthColour);
}