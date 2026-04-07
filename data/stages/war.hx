var defaultPath:String = 'Funkin_avi/stages/war/';

var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null];

var camBars:FlxCamera;

function onLoad()
{
    defaultCamZoom = 0.6;
    cameraSpeed = 0.67;

    var sky = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'sky'));
    sky.scrollFactor.set(0.07, 0.05);
    add(sky);

    var sun = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'sun'));
    sun.scrollFactor.set(0.13, 0.09);
    add(sun);

    var bg = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'bg'));
    bg.scrollFactor.set(0.32, 0.27);
    add(bg);

    var semibg = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'semibackground'));
    semibg.scrollFactor.set(0.52, 0.48);
    semibg.scale.set(1.23, 1.23);
    semibg.updateHitbox();
    add(semibg);

    var things = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'things'));
    things.scrollFactor.set(0.73, 0.64);
    things.scale.set(1.25, 1.25);
    things.updateHitbox();
    add(things);

    var ground = new FlxSprite(-1280 * defaultCamZoom, -720 * defaultCamZoom, Paths.image(defaultPath + 'ground'));
    ground.scrollFactor.set(1, 1);
    ground.scale.set(1.35, 1.35);
    ground.updateHitbox();
    add(ground);
}

function onCreatePost()
{
    camBars = new FlxCamera();
	camBars.bgColor = 0x0;
    FlxG.cameras.insert(camBars, FlxG.cameras.list.indexOf(PlayState.camHUD) - 1, false);
    
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

var topBarTwn:FlxTween;
var bottomBarTwn:FlxTween;

function cinematicBarControls(?controlType:String = "add", ?speed:Float, ?ease:String = "circInOut", ?position:Float = 0, ?bopValue:Float = 0)
{
	switch (controlType.toLowerCase())
	{
		case "add", "create":
			// idk if i should change this cus i dont wanna fuck up and i lazy to test them lol -sylinpix (jason)
			if (cinematicBars["top"] == null)
			{
				cinematicBars["top"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				cinematicBars["top"].screenCenter(FlxAxes.X);
				cinematicBars["top"].cameras = [camBars];
				cinematicBars["top"].y = 0 - cinematicBars["top"].height; // offscreen
				add(cinematicBars["top"]);
			}

			if (cinematicBars["bottom"] == null)
			{
				cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				cinematicBars["bottom"].screenCenter(FlxAxes.X);
				cinematicBars["bottom"].cameras = [camBars];
				cinematicBars["bottom"].y = FlxG.height; // offscreen
				add(cinematicBars["bottom"]);
			}
			
		case "remove", "kill", "delete":
			if (cinematicBars["top"] != null)
			{
				cinematicBars["top"].kill();
				cinematicBars["top"] = null;
			}
			if (cinematicBars["bottom"] != null)
			{
				cinematicBars["bottom"].kill();
				cinematicBars["bottom"] = null;
			}
			
		case "movetop", "move top":
			if (topBarTwn != null)
				topBarTwn.cancel();

			topBarTwn = FlxTween.tween(cinematicBars["top"], {y: position - FlxG.height}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				topBarTwn = null;
			}});
			
		case "movebottom", "move bottom":
			if (bottomBarTwn != null)
				bottomBarTwn.cancel();

			bottomBarTwn = FlxTween.tween(cinematicBars["bottom"], {y: FlxG.height - position}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				bottomBarTwn = null;
			}});
			
		case "moveboth", "move both":
			if (topBarTwn != null)
				topBarTwn.cancel();
			if (bottomBarTwn != null)
				bottomBarTwn.cancel();

			topBarTwn = FlxTween.tween(cinematicBars["top"], {y: position - FlxG.height}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				topBarTwn = null;
			}});
			bottomBarTwn = FlxTween.tween(cinematicBars["bottom"], {y: FlxG.height - position}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				bottomBarTwn = null;
			}});
			
		case "boptop", "bop top":
			cinematicBars["top"].y = position - FlxG.height;
			FlxTween.tween(cinematicBars["top"], {y: (position - FlxG.height) + bopValue}, speed, {ease: CoolUtil.getEaseFromString(ease)});
			
		case "bopbottom", "bop bottom":
			cinematicBars["bottom"].y = FlxG.height - position;
			FlxTween.tween(cinematicBars["bottom"], {y: (FlxG.height - position) - bopValue}, speed, {ease: CoolUtil.getEaseFromString(ease)});
			
		case "bopboth", "bop both":
			if (topBarTwn != null)
				topBarTwn.cancel();
			if (bottomBarTwn != null)
				bottomBarTwn.cancel();

			cinematicBars["top"].y = position - FlxG.height;
			cinematicBars["bottom"].y = FlxG.height - position;
			topBarTwn = FlxTween.tween(cinematicBars["top"], {y: (position - FlxG.height) + bopValue}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				topBarTwn = null;
			}});
			bottomBarTwn = FlxTween.tween(cinematicBars["bottom"], {y: (FlxG.height - position) - bopValue}, speed, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
			{
				bottomBarTwn = null;
			}});
	}
}