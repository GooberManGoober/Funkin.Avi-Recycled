import openfl.filters.ShaderFilter;

//HUNTED FNF
var wobblyBG:FlxRuntimeShader = newShader('acidTrip');
var treesFront:FlxSprite;
var goofyStreet:FlxSprite;
var treesBack:FlxSprite;
var otherBack:FlxSprite;
var goofyBG:FlxSprite;

var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var redVignette:FlxRuntimeShader = newShader('redFromAngryBirds');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');

var grayScale:FlxRuntimeShader = newShader('grayScale');

var camHudMoves:Bool = false;

var uhhTurnBackNormalOrSmth:Void->Void;

var pathway:String = 'favi/stages/forestNew/images/';

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
        goofyBG = new FlxSprite(-600, -450).loadGraphic(Paths.image(pathway + 'actualNew/sky'));
        goofyBG.scrollFactor.set(0.7, 0.7);
        goofyBG.screenCenter();
        add(goofyBG);
    }

    otherBack = new FlxSprite(-600, -450).loadGraphic(Paths.image(pathway + 'actualNew/bushes'));
    otherBack.scale.set(1.3, 1.2);
    add(otherBack);

    treesBack = new FlxSprite(-600, -450).loadGraphic(Paths.image(pathway + 'actualNew/treesBG'));
    treesBack.scrollFactor.set(1, 0.8);
    add(treesBack);

    goofyStreet = new FlxSprite(-600, -450).loadGraphic(Paths.image(pathway + 'actualNew/road'));
    goofyStreet.scrollFactor.set(1, 1);
    add(goofyStreet);

    if(!ClientPrefs.lowQuality)
    {
        treesFront = new FlxSprite(-600, -450).loadGraphic(Paths.image(pathway + 'actualNew/treesFG'));
        treesFront.scrollFactor.set(1.2, 1.2);
    }
}

function onCreatePost()
{
    add(treesFront);

    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(grayScale),
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
            ];
        }
        else
        {
            camGame.filters = [new ShaderFilter(grayScale), new ShaderFilter(monitorFilter)];
        }

        camHUD.filters = [new ShaderFilter(grayScale)];
    }
}

function onBeatHit()
{
    if (ClientPrefs.shaders)
    {
        if (curBeat == 192)
        {	
            if(!ClientPrefs.lowQuality && goofyBG != null && treesFront != null)
                {
                    goofyBG.shader = wobblyBG;
                    goofyStreet.shader = wobblyBG;
                    treesBack.shader = wobblyBG;
                    otherBack.shader = wobblyBG;
                    treesFront.shader = wobblyBG;
                }
        }
    }
    
    if (curBeat == 256)
    {
        if(!ClientPrefs.lowQuality && treesFront != null && goofyBG != null)
            {
                goofyBG.shader = null;
                goofyStreet.shader = null;
                treesBack.shader = null;
                otherBack.shader = null;
                treesFront.shader = null;
            }
    }

    if (curBeat == 176) {
       FlxTween.tween(camGame, {zoom: 1.1}, 4.1, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
		{
			defaultCamZoom = 1.1;
		}});
    }
    if (curBeat == 184)
        defaultCamZoom = 1.4;
    if (curBeat == 190)
        defaultCamZoom = 0.65;
    if (curBeat == 192)
    {
        camHudMoves = true;
        if (ClientPrefs.flashing)
            camGame.flash(FlxColor.WHITE, 1.5);
        if (ClientPrefs.shaders)
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
    }
    if (curBeat == 256)
    {
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

        uhhTurnBackNormalOrSmth();
    }

    if (((curBeat >= 64 && curBeat < 128) && curBeat % 2 == 0) || (curBeat >= 128 && curBeat < 256))
    {
        FlxG.camera.zoom += ((curBeat > 176 && curBeat < 184) ? 0 : .05);
        camHUD.zoom += .04;
    }
}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;
    
    wobblyBG.setFloat('uTime', shaderAnim);
    redVignette.setFloat('time', shaderAnim);
    dramaticCamMovement.setFloat('time', shaderAnim);

    // yk i sometimes ask why we put sum stuff there n shit
    uhhTurnBackNormalOrSmth = function () {
        for (goofyAhhUIS in [camHUD])
        {
            goofyAhhUIS.x += 80;
            goofyAhhUIS.y = FlxMath.lerp(0, goofyAhhUIS.y, FlxMath.bound(elapsed * 2.4, 0, 1));
        }
        FlxTween.tween(PlayState.instance, {health: 2}, 1);
    }

    if (!camHudMoves) camHUD.angle = FlxMath.lerp(camHUD.angle, 0, FlxMath.bound(elapsed * 2.4, 0, 1));

    if (camHudMoves && ClientPrefs.mechanics)
    {
        var songPos = Conductor.songPosition;

        // math momento -jason
        camHUD.x = 20 + Math.sin(songPos / 300 * 3) * FlxG.width * 0.83 / 10;
        camHUD.y = 30 + Math.sin(songPos / 450) * FlxG.height * 0.9 / 10;
        camHUD.angle = Math.sin(songPos / 800) * 80 / 10;

        // illegal instruction moment
        FlxTween.tween(PlayState.instance, {health: FlxG.random.float(0.024, 2)}, 0.3);
    }
}