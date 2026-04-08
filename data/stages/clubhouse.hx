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
    delusionalStreet.loadGraphic(Paths.image('stages/clubhouse/Mickeybg'));
    delusionalStreet.alpha = 0.0001;
    add(delusionalStreet);

    clubhouse = new FlxSprite(-410, -100);
    clubhouse.frames = Paths.getSparrowAtlas('stages/clubhouse/daHouse');
    clubhouse.animation.addByPrefix('balloons bounce', 'daHouse idle', 12, true);
    clubhouse.animation.play('balloons bounce');
    clubhouse.scale.set(1.15, 1.15);
    clubhouse.updateHitbox();
    clubhouse.antialiasing = true;
    clubhouse.scrollFactor.set(1, 1);
    add(clubhouse);

    var vignette:FlxSprite = new FlxSprite(-250, -140).loadGraphic(Paths.image('stages/clubhouse/vignetteOverlay'));
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
    }
}

function onSongStart()
{
    // they start going on an acid trip lmao
    modManager.queueFuncOnce(256 * 4, (s,s2)->{ 
        camGame.shake(0.015, 1.3);
        defaultCamZoom = 1.1;
        aberrationBoom.setFloat('aberration', 0.03);
        aberrationBoom.setFloat('effectTime', 0.06);
    });

    modManager.queueFuncOnce(258 * 4, (s,s2)->{ 
        aberrationBoom.setFloat('aberration', 0.06);
        aberrationBoom.setFloat('effectTime', 0.12);
    });

    modManager.queueFuncOnce(260 * 4, (s,s2)->{ 
        defaultCamZoom = 0.76;
        aberrationBoom.setFloat('aberration', 0.12);
        aberrationBoom.setFloat('effectTime', 0.24);
    });

    modManager.queueFuncOnce(320 * 4, (s,s2)->{ 
        camGame.shake(0.025, 1.3);
        defaultCamZoom = 1;
        aberrationBoom.setFloat('aberration', 0.15);
        aberrationBoom.setFloat('effectTime', 0.30);
    });

    modManager.queueFuncOnce(322 * 4, (s,s2)->{ 
        aberrationBoom.setFloat('aberration', 0.18);
        aberrationBoom.setFloat('effectTime', 0.36);
    });

    modManager.queueFuncOnce(324 * 4, (s,s2)->{ 
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 0.5);
    });

    modManager.queueFuncOnce(388 * 4, (s,s2)->{ 
        defaultCamZoom = 0.85;
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 0.5);
        aberrationBoom.setFloat('aberration', 0.001);
        aberrationBoom.setFloat('effectTime', 0.001);
    });

    modManager.queueFuncOnce(520 * 4, (s,s2)->{ 
        camGame.alpha = 0.000001;
        camHUD.alpha = 0;
        camOther.flash(FlxColor.WHITE, 1);
        gfGroup.alpha = 0.0001;
        boyfriend.alpha = 0.0001;

        delusionalStreet.alpha = 1;
        clubhouse.alpha = 0.0001;
    });

    modManager.queueFuncOnce(2125, (s,s2)->{ 
        camGame.alpha = 1;
    });

    modManager.queueFuncOnce(2144, (s,s2)->{ 
        camGame.alpha = 0;
    });
}

function onBeatHit()
{
    if (curBeat >= 324 && curBeat <= 387)
    {
        aberrationBoom.setFloat('aberration', aberrationTimer);
        aberrationBoom.setFloat('effectTime', aberrationTimer);
    }
}

function onUpdate(elapsed)
{
    aberrationTimer -= 0.01;

    muckneyHealthColorShitLol();
}

function muckneyHealthColorShitLol()
{
    muckneyColors = [FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)];

    healthBar.setColors(FlxColor.fromRGB(muckneyColors[0], muckneyColors[1], muckneyColors[2]), boyfriend.healthColour);
}