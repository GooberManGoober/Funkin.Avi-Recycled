var pathway:String = 'stages/war/';

function onLoad()
{
    defaultCamZoom = 0.6;
    cameraSpeed = 0.67;

    var sky = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'sky'));
    sky.scrollFactor.set(0.07, 0.05);
    add(sky);

    var sun = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'sun'));
    sun.scrollFactor.set(0.13, 0.09);
    add(sun);

    var bg = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'bg'));
    bg.scrollFactor.set(0.32, 0.27);
    add(bg);

    var semibg = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'semibackground'));
    semibg.scrollFactor.set(0.52, 0.48);
    semibg.scale.set(1.23, 1.23);
    semibg.updateHitbox();
    add(semibg);

    var things = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'things'));
    things.scrollFactor.set(0.73, 0.64);
    things.scale.set(1.25, 1.25);
    things.updateHitbox();
    add(things);

    var ground = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(pathway + 'ground'));
    ground.scrollFactor.set(1, 1);
    ground.scale.set(1.35, 1.35);
    ground.updateHitbox();
    add(ground);
}

function onCreatePost()
{
    cinematicBarControls("create", 1);
	cinematicBarControls("moveboth", 0.0001, 'linear', 420);
	camHUD.alpha = 0.001;
}

var cinematicValue:Float = 0;

function onSongStart()
{
    modManager.queueFuncOnce(1, (s,s2)->{ 
        defaultCamZoom = 1.1;
        cinematicBarControls("moveboth", 2, "backOut", 180);
        FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineOut});
    });

    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        defaultCamZoom = 0.6;
        cinematicBarControls("moveboth", 1, "circOut", 50);
        cinematicValue = 50;
    });

    for (i in [48, 56, 64, 72])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom += 0.1;
            cinematicBarControls("moveboth", 1.5, "circOut", cinematicValue + 20);
            cinematicValue += 20;
        });
    }

    modManager.queueFuncOnce(80 * 4, (s,s2)->{ 
        defaultCamZoom = 0.6;
        cinematicBarControls("moveboth", 2, "backOut", 50);
        cinematicValue = 0;
    });

    modManager.queueFuncOnce(176 * 4, (s,s2)->{ 
        camBars.flash(FlxColor.BLACK, 8);
        camHUD.alpha = 0;
    });

    modManager.queueFuncOnce(208 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.quartOut});
    });

    for (i in [272, 276, 280, 284])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom += 0.05;
        });
    }

    modManager.queueFuncOnce(288 * 4, (s,s2)->{ 
        defaultCamZoom = 0.6;
    });
}

function onBeatHit()
{
    if (curBeat >= 240 && curBeat < 288 && curBeat % 2 == 0)
    {
        camGame.zoom += 0.015;
        camHUD.zoom += 0.03;
    }

    if (curBeat >= 288 && curBeat < 352)
    {
        camGame.zoom += 0.015;
        camHUD.zoom += 0.03;
    }
}