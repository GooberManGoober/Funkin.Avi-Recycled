import openfl.filters.ShaderFilter;

//HUNTED FNF
var wobblyBG:FlxRuntimeShader = newShader('acidTrip');
var treesFront:FlxSprite;
var goofyStreet:FlxSprite;
var treesBack:FlxSprite;
var goofyBG:FlxSprite;

var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var redVignette:FlxRuntimeShader = newShader('redFromAngryBirds');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');

var camHudMoves:Bool = false;

var uhhTurnBackNormalOrSmth:Void->Void;

var pathway:String = 'stages/forestNew/';

function onLoad()
{
    // Literally what Goofy is seeing right about now lmfao
    wobblyBG.setFloat('uSpeed', 1.0);
    wobblyBG.setFloat('uFrequency', 1.0);
    wobblyBG.setFloat('uWaveAmplitude', 0.5);

    cameraSpeed = 0.9;
    defaultCamZoom = 0.65;

    if(!ClientPrefs.lowQuality)
    {
        goofyBG = new FlxSprite(-600, -650).loadGraphic(Paths.image(pathway + 'bg'));
        goofyBG.scrollFactor.set(0.7, 0.7);
        goofyBG.scale.set(1.2, 1.2);
        goofyBG.screenCenter();
        add(goofyBG);
    }

    treesBack = new FlxSprite(-550, -650).loadGraphic(Paths.image(pathway + 'treesBack'));
    treesBack.scale.set(1.3, 1.2);
    treesBack.scrollFactor.set(1, 0.8);
    add(treesBack);

    goofyStreet = new FlxSprite(-700, -950).loadGraphic(Paths.image(pathway + 'ground'));
    goofyStreet.scale.set(2, 1.9);
    goofyStreet.scrollFactor.set(1, 1);
    add(goofyStreet);

    if(!ClientPrefs.lowQuality)
    {
        treesFront = new FlxSprite(-550, -650).loadGraphic(Paths.image(pathway + 'treesFront'));
        treesFront.scale.set(1.5, 1.5);
        treesFront.scrollFactor.set(1.2, 1.2);
    }
}

function onCreatePost()
{
    foreground.add(treesFront);

    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
            ];
        }
        else
        {
            camGame.filters = [new ShaderFilter(monitorFilter)];
        }
    }

    cinematicBarControls("create", 1);
    cinematicBarControls("moveboth", 0.0001, 'linear', 380);
}

function onSongStart()
{
    modManager.queueFuncOnce(1, (s,s2)->{ 
        cinematicBarControls("moveboth", 2, 'circOut', 80);
    });
    
    modManager.queueFuncOnce(176 * 4, (s,s2)->{ 
        FlxTween.tween(camGame, {zoom: 1.1}, 4.1, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
		{
			defaultCamZoom = 1.1;
		}});
    });

    modManager.queueFuncOnce(184 * 4, (s,s2)->{ 
        defaultCamZoom = 1.4;
    });

    modManager.queueFuncOnce(190 * 4, (s,s2)->{ 
        defaultCamZoom = 0.65;
    });

    modManager.queueFuncOnce(192 * 4, (s,s2)->{ 
        camHudMoves = true;
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 1.5);
        if (ClientPrefs.shaders)
        {
            if (!ClientPrefs.lowQuality)
            {
                camGame.filters = [
                    new ShaderFilter(redVignette),
                    new ShaderFilter(dramaticCamMovement),
                    new ShaderFilter(monitorFilter),
                ];
            }
            else
            {
                camGame.filters = [new ShaderFilter(redVignette), new ShaderFilter(monitorFilter)];
            }

            if(!ClientPrefs.lowQuality && goofyBG != null && treesFront != null)
            {
                goofyBG.shader = wobblyBG;
                goofyStreet.shader = wobblyBG;
                treesBack.shader = wobblyBG;
                treesFront.shader = wobblyBG;
                cinematicBarControls("moveboth", 2, 'circOut', 0);
            }
        }
    });

    modManager.queueFuncOnce(256 * 4, (s,s2)->{ 
        camHudMoves = false;
        camGame.flash(FlxColor.BLACK, 2);
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
            ];
        }
        else
        {
            camGame.filters = [new ShaderFilter(monitorFilter)];
        }

        if(!ClientPrefs.lowQuality && treesFront != null && goofyBG != null)
        {
            goofyBG.shader = null;
            goofyStreet.shader = null;
            treesBack.shader = null;
            treesFront.shader = null;
            cinematicBarControls("moveboth", 2, 'circOut', 80);
        }

        uhhTurnBackNormalOrSmth();
    });

    modManager.queueFuncOnce(1311, (s,s2)->{ 
        cinematicBarControls("moveboth", 1.65, 'backIn', 380);
        FlxTween.tween(camGame, {zoom: 1.1}, 1.65, {ease: FlxEase.backIn, onComplete: function(twn:FlxTween)
		{
			camGame.alpha = 0;
		}});
    });

    modManager.queueFuncOnce(1352, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 1.65, {ease: FlxEase.sineInOut});
    });

    modManager.queueFuncOnce(1024, (s,s2)->{ 
        FlxTween.tween(playHUD, {alpha: 1}, 1, {ease: FlxEase.cubeOut});
    });

    modManager.queueFuncOnce(736, (s,s2)->{ 
        FlxTween.tween(playHUD, {alpha: 0}, 2.5, {ease: FlxEase.backInOut});
    });

    //modchart beginning
    modManager.queueEase(736, 736 + 20, "alpha", 1, "backInOut", 1);
    if (!ClientPrefs.middleScroll) modManager.queueEase(736, 736 + 20, "opponentSwap", 0.5, 'backInOut', 0);

    modManager.queueEase(736, 736 + 20, "drunkZSpeed", 2, 'backInOut', 0);
    modManager.queueEase(736, 736 + 20, "drunkSpeed", 2, 'backInOut', 0);

    modManager.queueEase(768, 768 + 4, "drunkZ", 1, 'backInOut', 0);
    modManager.queueEase(768, 768 + 4, "drunk", 1, 'backInOut', 0);

    //modchart ending
    modManager.queueEase(1024, 1024 + 20, "alpha", 0, "cubeOut", 1);
    if (!ClientPrefs.middleScroll) modManager.queueEase(1024, 1024 + 20, "opponentSwap", 0, 'cubeOut', 0);
    modManager.queueEase(1024, 1024 + 20, "drunkZ", 0, 'cubeOut', 0);
    modManager.queueEase(1024, 1024 + 20, "drunk", 0, 'cubeOut', 0);
}

function onBeatHit()
{
    if (((curBeat >= 64 && curBeat < 128) && curBeat % 2 == 0) || (curBeat >= 128 && curBeat < 256))
    {
        FlxG.camera.zoom += ((curBeat > 176 && curBeat < 184) ? 0 : .05);
        camHUD.zoom += .04;

    }
}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;

    var wobbleAnim = shaderAnim;
    if (!camHudMoves)
        wobbleAnim = FlxMath.lerp(wobbleAnim, 0, FlxMath.bound(elapsed * 2.4, 0, 1));
    
    wobblyBG.setFloat('uTime', shaderAnim);
    redVignette.setFloat('time', shaderAnim);
    dramaticCamMovement.setFloat('time', shaderAnim);

    // yk i sometimes ask why we put sum stuff there n shit
    uhhTurnBackNormalOrSmth = function () {
        FlxTween.tween(PlayState.instance, {health: 2}, 1);
    }

    if (!camHudMoves) camHUD.scrollAngle = FlxMath.lerp(camHUD.scrollAngle, 0, FlxMath.bound(elapsed * 2.4, 0, 1));

    if (camHudMoves && ClientPrefs.mechanics)
    {
        var songPos = Conductor.songPosition;

        // math momento -jason
        camHUD.scrollAngle = Math.sin(songPos / 800) * 80 / 10;

        // illegal instruction moment
        FlxTween.tween(PlayState.instance, {health: FlxG.random.float(0.024, 2)}, 0.3);
    }
}