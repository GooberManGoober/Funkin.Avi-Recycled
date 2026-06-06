import openfl.filters.ShaderFilter;
import funkin.FunkinAssets;

var waltScreenThing:FlxSprite; // idk, this is needed too for some reason
var inkFormWarning:FlxText;
var spaceBarCounter:FlxText;
var mercyBoostIcon:FlxSprite;
var limitThing:Int = 0; // Default Value

var waltStatic:FlxRuntimeShader = newShader('vhsFilter');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');

var pissOfGlory:FlxSprite;
var greaterPiss:FlxSprite;

var retardedButPissBehind:FlxSprite;
var sameAsAdobe:FlxSprite;
var waltGoop:FlxSprite;

var pathway:String = 'stages/waltRoom/';

var mercyTmr:FlxTimer;
var disabledDrain:Bool = false;
var initialCount:Int = 0;

function onLoad()
{
    defaultCamZoom = 0.75;

    FunkinAssets.getGraphicUnsafe(Paths.image("characters/Walt"));
    FunkinAssets.getGraphicUnsafe(Paths.image("characters/walt death"));
    FunkinAssets.getGraphicUnsafe(Paths.image("characters/waltLaugh"));

    addCharacterToList('walt-death', 1);
    addCharacterToList('walt-true', 1);
    addCharacterToList('walt-cutscene', 1);

    camGame.alpha = 0.0001;
    camHUD.alpha = 0.0001;

    pissOfGlory = new FlxSprite(-470, -280);
    pissOfGlory.loadGraphic(Paths.image(pathway + 'newWaltBG'));
    pissOfGlory.scale.set(1.7, 1.7);
    pissOfGlory.updateHitbox();
    pissOfGlory.antialiasing = true;
    pissOfGlory.scrollFactor.set(1, 1);
    pissOfGlory.active = false;
    pissOfGlory.blend = BlendMode.ADD;

    retardedButPissBehind = new FlxSprite().loadGraphicFromSprite(pissOfGlory);
    retardedButPissBehind.scale.set(1.7, 1.7);
    retardedButPissBehind.updateHitbox();
    retardedButPissBehind.setPosition(pissOfGlory.x, pissOfGlory.y);
    add(retardedButPissBehind);

    greaterPiss = new FlxSprite(-60, -70);
    greaterPiss.loadGraphic(Paths.image(pathway + 'inkWaltBG'));
    greaterPiss.scale.set(1.7, 1.7);
    greaterPiss.blend = BlendMode.ADD;
    greaterPiss.visible = false;

    sameAsAdobe = new FlxSprite().loadGraphicFromSprite(greaterPiss);
    sameAsAdobe.visible = false;
    sameAsAdobe.setPosition(greaterPiss.x, greaterPiss.y);
    sameAsAdobe.scale.set(1.7, 1.7);
    add(sameAsAdobe);
}

function onSpawnNotePost(dunceNote){
	if(dunceNote.mustPress != true){
        dunceNote.cameras = [camGame];
		dunceNote.scrollFactor.set(1, 1);
    }
}

function onCreatePost()
{
    modManager.setValue("transform0X", -460, 0);
    modManager.setValue("transform1X", -460, 0);
    modManager.setValue("transform2X", -160, 0);
    modManager.setValue("transform3X", -160, 0);

    modManager.setValue("transformX", 115, 1);
    modManager.setValue("transformY", ClientPrefs.downScroll ? -130 : -30, 1);
    modManager.setValue("alpha", 0.5, 1);
    modManager.setValue("reverse", 1, 1);

    for (i in [0, 1])
        modManager.setValue('localrotate${i}Z', 0.25, 1);

    for (i in [2, 3])
        modManager.setValue('localrotate${i}Z', -0.25, 1);

    modManager.setValue("transform0X", -90 - 40, 1);
    modManager.setValue("transform1X", -85 - 40, 1);
    modManager.setValue("transform2X", 85 + 130, 1);
    modManager.setValue("transform3X", 90 + 130, 1);

    opponentStrums.cameras = [camGame];
    for(i in 0...opponentStrums.members.length){
		opponentStrums.members[i].scrollFactor.set(1, 1);
	}
    
    waltGoop = new FlxSprite(-800, 410).loadGraphic(Paths.image(pathway + 'melted'));
    waltGoop.scale.set(0.3, 0.3);
    waltGoop.alpha = 0.001;
    add(waltGoop);

    if(!ClientPrefs.lowQuality)
    {
        var vignette:FlxSprite = new FlxSprite(-250, -140).loadGraphic(Paths.image(pathway + 'vignetteOverlay'));
        vignette.cameras = [camOther];
        vignette.scale.set(0.75, 0.75);
        vignette.antialiasing = true;
        vignette.scrollFactor.set();
        vignette.active = false;
        add(vignette);
    }

    add(pissOfGlory);
    add(greaterPiss);
    boyfriend.visible = false;
    iconP2.y -= 20;

    waltScreenThing = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    waltScreenThing.scrollFactor.set();
    waltScreenThing.cameras = [camOther];
    waltScreenThing.alpha = 0.001;
    add(waltScreenThing);

    var waltInstructionsMain:FlxText = new FlxText(370, 500, 0, "Take Advantage of the SPACEBAR!", 30);
    waltInstructionsMain.cameras = [camOther];
    waltInstructionsMain.setFormat(Paths.font("splatter.otf"), 30);
    waltInstructionsMain.scrollFactor.set();

    var waltSubTxt:FlxText = new FlxText(waltInstructionsMain.x + 66, waltInstructionsMain.y + 40, 0,
        "(It will help you regain health when critically low)", 15);
    waltSubTxt.setFormat(Paths.font("splatter.otf"), 15);
    waltSubTxt.cameras = [camOther];
    waltSubTxt.alpha = 0;
    waltSubTxt.scrollFactor.set();

    inkFormWarning = new FlxText(0, 0, 0, "PRESS SPACE!", 15);
    inkFormWarning.setFormat(Paths.font("splatter.otf"), 50);
    inkFormWarning.cameras = [camOther];
    inkFormWarning.alpha = 0;
    inkFormWarning.scrollFactor.set();
    inkFormWarning.screenCenter();

    mercyBoostIcon = new FlxSprite(-10, 600);
    mercyBoostIcon.frames = Paths.getSparrowAtlas("UI/mercyIcon");
    mercyBoostIcon.animation.addByPrefix("full", "full", 7, true);
    mercyBoostIcon.animation.addByPrefix("hmm", "hmm", 7, true);
    mercyBoostIcon.animation.addByPrefix("halfway", "halfway", 7, true);
    mercyBoostIcon.animation.addByPrefix("thatsBad", "thatsBad", 7, true);
    mercyBoostIcon.animation.addByPrefix("almostOut", "almostOut", 7, true);
    mercyBoostIcon.animation.addByPrefix("empty", "empty", 7, true);
    mercyBoostIcon.animation.play("full");
    mercyBoostIcon.scale.set(0.75, 0.75);
    mercyBoostIcon.scrollFactor.set();
    mercyBoostIcon.cameras = [camOther];	

    spaceBarCounter = new FlxText(0, 650, 140, '${limitThing}', 15);
    spaceBarCounter.setFormat(Paths.font("splatter.otf"), 30, FlxColor.BLACK, "center", FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
    spaceBarCounter.cameras = [camOther];
    //spaceBarCounter.alpha = 0;
    spaceBarCounter.scrollFactor.set();

    if (ClientPrefs.mechanics)
    {
        add(waltInstructionsMain);
        add(waltSubTxt);
        add(mercyBoostIcon);
        add(spaceBarCounter);

        FlxTween.tween(waltInstructionsMain, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
        FlxTween.tween(waltSubTxt, {alpha: 0}, 1, {ease: FlxEase.quadInOut, startDelay: 8});
        FlxTween.tween(waltSubTxt, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut, startDelay: 3});
    }

    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(waltStatic),
                new ShaderFilter(dramaticCamMovement)
            ];
        }
        else
        {
            camGame.filters = [new ShaderFilter(dramaticCamMovement)];
        }
        camHUD.filters = [new ShaderFilter(dramaticCamMovement)];
    }

    if (ClientPrefs.mechanics)
    {
        limitThing += 20;
        initialCount = limitThing;
    }
}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;
    
    waltStatic.setFloat('time', shaderAnim);
	dramaticCamMovement.setFloat('time', shaderAnim);

    pissOfGlory.alpha = FlxMath.lerp(pissOfGlory.alpha, FlxG.random.float(0.01, .37), .2);
	greaterPiss.alpha = FlxMath.lerp(greaterPiss.alpha, FlxG.random.float(0.01, .37), .2);

    detectSpace(cpuControlled);

    if (ClientPrefs.mechanics)
    {
        spaceBarCounter.text = '${limitThing}';
    
        var healths:Array<Float> = [for (i in 1...21) i / 10]; // i dont really remember how were this done...
        var alphas:Array<Float> = [
            0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50, 0.45, 0.40, 0.35, 0.30, 0.25, 0.20, 0.15, 0.10, 0.05, 0.0
        ];
        var lastOne:Bool = true;
        for (i in 0...healths.length)
        {
            if (lastOne)
            {
                lastOne = tweenWaltScreen(healths[i], alphas[i]);
            }
        }
    }
}

function tweenWaltScreen(percentage:Float, alpha:Float):Bool {
    if (health <= percentage)
        FlxTween.tween(waltScreenThing, {alpha: alpha}, 0.15, {ease: FlxEase.sineInOut});
    else
        return true;
    return false;
}

function detectSpace(isAutoplay:Bool = false)
{
    if (!isAutoplay)
    {
        if (FlxG.keys.justPressed.SPACE)
        {
            switch (PlayState.SONG.stage)
            {
                case 'waltRoom':
                    if (limitThing > 0)
                    {
                        if (mercyTmr != null)
                            mercyTmr.cancel();

                        disabledDrain = true;
                        mercyTmr = new FlxTimer().start(1.2, function(tmr:FlxTimer)
                        {
                            disabledDrain = false;
                            mercyTmr = null;
                        });
                        health += 1.25;
                        limitThing -= 1;
                        var mathShit:Float = limitThing / initialCount;
                        switch (mathShit)
                        {
                            case 0.75: mercyBoostIcon.animation.play("hmm");
                            case 0.5: mercyBoostIcon.animation.play("halfway");
                            case 0.25: mercyBoostIcon.animation.play("thatsBad");
                            case 0.1 | 0.12: mercyBoostIcon.animation.play("almostOut");
                            case 0: mercyBoostIcon.animation.play("empty");
                        }
                    }
            }
        }
    } 
    else 
    { 
        switch (PlayState.SONG.stage)
        {
            case 'waltRoom':
                if (health < 0.3 && limitThing > 0)
                {
                    if (mercyTmr != null)
                        mercyTmr.cancel();

                    disabledDrain = true;
                    mercyTmr = new FlxTimer().start(1.2, function(tmr:FlxTimer)
                    {
                        disabledDrain = false;
                        mercyTmr = null;
                    });
                    health += 1.25;
                    limitThing -= 1;
                    var mathShit:Float = limitThing / initialCount;
                    switch (mathShit)
                    {
                        case 0.75: mercyBoostIcon.animation.play("hmm");
                        case 0.5: mercyBoostIcon.animation.play("halfway");
                        case 0.25: mercyBoostIcon.animation.play("thatsBad");
                        case 0.1 | 0.12: mercyBoostIcon.animation.play("almostOut");
                        case 0: mercyBoostIcon.animation.play("empty");
                    }
                }
        }
    }
}

function onSongStart()
{
    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
        FlxTween.tween(camHUD, {alpha: 1}, 5, {ease: FlxEase.sineInOut, startDelay: 1.5});
        defaultCamZoom = 1.3;
    });

    modManager.queueFuncOnce(32 * 4, (s,s2)->{ 
        defaultCamZoom = 1.2;
    });

    modManager.queueFuncOnce(40 * 4, (s,s2)->{ 
        defaultCamZoom = 1.1;
    });

    modManager.queueFuncOnce(48 * 4, (s,s2)->{ 
        defaultCamZoom = 1;
    });

    modManager.queueFuncOnce(56 * 4, (s,s2)->{ 
        defaultCamZoom = 0.9;
    });

    modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
        defaultCamZoom = 0.75;
    });

    modManager.queueFuncOnce(128 * 4, (s,s2)->{ 
        tweenCamera(1.1, 9.7, 'quadInOut');
    });

    modManager.queueFuncOnce(256 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
    });

    modManager.queueFuncOnce(264 * 4, (s,s2)->{ 
        modManager.setValue("alpha", 1, 1);
    });

    modManager.queueFuncOnce(275 * 4, (s,s2)->{ 
        modManager.setValue("alpha", 0, 1);
    });

    modManager.queueFuncOnce(468 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 4, {ease: FlxEase.sineInOut});
        modManager.queueEase(480 * 4, 494 * 4, "alpha", 1, "linear", 1);
    });

    modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
        FlxTween.tween(dad, {alpha: 0}, 5);
        FlxTween.tween(waltGoop, {alpha: 1}, 5);
    });

    modManager.queueFuncOnce(498 * 4, (s,s2)->{ 
        camGame.alpha = 0;
        camOther.flash(FlxColor.WHITE, 3);
    });
}

function onBeatHit()
{
    if (ClientPrefs.mechanics && !disabledDrain)
    {
        // Health Drain Shit
        if (curBeat >= 0 && curBeat <= 63)
            health -= 0.005;
        else if (curBeat >= 64 && curBeat <= 79)
            health -= 0.025;
        else if (curBeat >= 80 && curBeat <= 87)
            health -= 0.055;
        else if (curBeat >= 88 && curBeat <= 95)
            health -= 0.015;
        else if (curBeat >= 96 && curBeat <= 127)
            health -= 0.036;
        else if (curBeat >= 128 && curBeat <= 159)
            health -= 0.14;
        else if (curBeat >= 160 && curBeat <= 191)
            health -= 0.031;
        else if (curBeat >= 192 && curBeat <= 207)
            health -= 0.015;
        else if (curBeat >= 208 && curBeat <= 239)
            health -= 0.03;
        else if (curBeat >= 240 && curBeat <= 255)
            health -= 0.005;
        else if (curBeat >= 256 && curBeat <= 291)
            health -= 0.02;
        else if (curBeat >= 292 && curBeat <= 307)
            health -= 0.03;
        else if (curBeat >= 308 && curBeat <= 339)
            health -= 0.04;
        else if (curBeat >= 340 && curBeat <= 371)
            health -= 0.055;
        else if (curBeat >= 372 && curBeat <= 387)
            health -= 0.078;
        else if (curBeat >= 388 && curBeat <= 403)
            health -= 0.09;
        else if (curBeat >= 404 && curBeat <= 451)
            health -= 0.1;
        else if (curBeat >= 452 && curBeat <= 467)
            health -= 0.115;
    }
}

function onEvent(name, value1, value2)
{
    if (name == "Mercy Transition")
    {
        switch (value1.toLowerCase())
        {
            case "start":
                defaultCamZoom = 0.75;
                for (bullshit in [retardedButPissBehind, sameAsAdobe, pissOfGlory, greaterPiss])
                    bullshit.visible = false;
                modManager.setValue("alpha", 1, 1);
                camFlashSystem('fancy flash', {alpha: 0.5, ease: FlxEase.sineOut, timer: 0.2, colors: [247, 230, 166]});

            case "finish":
                for (bullshit in [retardedButPissBehind, sameAsAdobe, pissOfGlory, greaterPiss])
                    bullshit.visible = true;
                camFlashSystem('fancy flash', {alpha: 0.5, ease: FlxEase.sineOut, timer: 0.2, colors: [247, 230, 166]});
                FlxTween.tween(sameAsAdobe, {alpha: 0}, 0.25, {ease: FlxEase.sineOut});
                modManager.setValue("alpha", 0.5, 1);
                FlxTween.tween(camHUD, {alpha: 1}, 0.31, {ease: FlxEase.sineInOut});
        }
    }
}