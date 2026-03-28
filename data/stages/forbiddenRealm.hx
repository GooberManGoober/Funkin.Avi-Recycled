import openfl.filters.ShaderFilter;
import funkin.utils.CoolUtil;

//var mickeyEmitter:FlxEmitter;
var fuckingsquares:FlxSprite;
var whiteBG:FlxSprite;
var glitchBG:FlxRuntimeShader;
var staticBG:FlxRuntimeShader;

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;
var chromTween:FlxTween;

var dumbCamTwn:FlxTween;

var pathway:String = 'favi/stages/' + PlayState.SONG.stage + '/images/';

function onLoad()
{
    PlayState.isPixelStage = true;
    defaultCamZoom = 0.75;
    //spawnGirlfriend = false;

    staticBG = newShader('tvStatic');
    glitchBG = newShader('vignetteGlitch');

    fuckingsquares = new FlxSprite(-750, -850);
    fuckingsquares.loadGraphic(Paths.image(pathway + 'malfunctionBG-NEW'));
    fuckingsquares.scale.set(1.2, 1);
    fuckingsquares.updateHitbox();
    fuckingsquares.antialiasing = false;
    fuckingsquares.scrollFactor.set(1, 1);
    fuckingsquares.active = false;
    add(fuckingsquares);
/*
    var greyParticles:FlxEmitter = new FlxEmitter(-2080.5, 650.4);
    greyParticles.launchMode = SQUARE;
    greyParticles.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
    greyParticles.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
    greyParticles.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    greyParticles.width = 4787.45;
    greyParticles.alpha.set(1, 1);
    greyParticles.lifespan.set(1.9, 4.9);
    greyParticles.loadParticles(Paths.image(pathway + 'greyParticle'), 500, 16, true);
    greyParticles.start(false, FlxG.random.float(.0521, .1060), 1000000);

    var blackParticles:FlxEmitter = new FlxEmitter(-2080.5, 912.4);
    blackParticles.launchMode = SQUARE;
    blackParticles.velocity.set(-70, -220, 70, -620, -110, 20, 110, -620);
    blackParticles.scale.set(6, 6, 6, 6, 2, 2, 2, 2);
    blackParticles.drag.set(2, 2, 2, 2, 7, 7, 12, 12);
    blackParticles.width = 4787.45;
    blackParticles.alpha.set(1, 1);
    blackParticles.lifespan.set(1.9, 4.9);
    blackParticles.loadParticles(Paths.image(pathway + 'particleBlack'), 500, 16, true);
    blackParticles.start(false, FlxG.random.float(.0821, .1460), 1000000);
    
    mickeyEmitter = new FlxEmitter(-2099.8, 1620.4);
    for (i in 0 ... 100)
    {
        var mickeyParticle = new FlxParticle();
        mickeyParticle.frames = Paths.getSparrowAtlas(pathway + 'mickParticle');
        mickeyParticle.animation.addByPrefix('mickParticle idle', 'mickParticle idle', 12, true);
        mickeyParticle.animation.play('mickParticle idle');
        mickeyParticle.exists = false;
        //mickeyParticle.animation.curAnim.curFrame = FlxG.random.int(0, 3);
        mickeyEmitter.add(mickeyParticle);
    }
    mickeyEmitter.launchMode = SQUARE;
    mickeyEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
    mickeyEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
    mickeyEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    mickeyEmitter.width = 4200.45;
    mickeyEmitter.alpha.set(1, 1);
    mickeyEmitter.lifespan.set(4, 4.5);
    mickeyEmitter.start(false, FlxG.random.float(.125, .287), 100000);
    mickeyEmitter.emitting = false;
*/
    whiteBG = new FlxSprite(-800, -200).makeGraphic(1, 1, 0xFFFFFFFF);
    whiteBG.scale.set(FlxG.width, FlxG.height);
    whiteBG.alpha = 0.001;
    whiteBG.active = false;
    add(whiteBG);
}

function onCreatePost()
{
    playHUD.ratingPrefix = "pixelUI/";
    playHUD.ratingSuffix = "-pixel";
/*
    if (PlayState.SONG.song != 'Malfunction Legacy')
    {
        add(greyParticles);
        foreground.add(blackParticles);
        foreground.add(mickeyEmitter);
    }
*/
    if (ClientPrefs.shaders)
    {
        if(!ClientPrefs.lowQuality)
        {
            camGame.filters = 
            [
                new ShaderFilter(chromZoomShader)
            ];
            camHUD.filters = 
            [
                new ShaderFilter(chromNormalShader)
            ];
            
            new FlxTimer().start(5, function(tmr)
            {
                camGame.filters = [new ShaderFilter(chromZoomShader)];
                camHUD.filters = [new ShaderFilter(chromNormalShader)];
            });
        }
    }
}

function onUpdate()
{
    shaderAnim = Conductor.songPosition / 1000;
    
    if (ClientPrefs.shaders)
    {
        chromNormalShader.setFloat('rOffset', chromEffect / 20);
        chromNormalShader.setFloat('bOffset', -chromEffect / 20);
        if (!ClientPrefs.lowQuality)
        {
            chromZoomShader.setFloat('aberration', chromEffect);
            chromZoomShader.setFloat('effectTime', chromEffect);
        }
        glitchBG.setFloat('time', shaderAnim);
        glitchBG.setFloat('prob', shaderAnim);
        staticBG.setFloat('uTime', shaderAnim);
        staticBG.setFloat('iTime', shaderAnim);
    }
}

function opponentNoteHit(note)
{
    if (dad.curCharacter == 'glitched-mickey-new-pixel')
    {
        if (health > 0.05)
            health -= 0.01 * 2;

        camGame.shake(0.008, 0.07);
        camHUD.shake(0.015, 0.07);

        if (ClientPrefs.shaders)
        {			
            if(!ClientPrefs.lowQuality && ClientPrefs.flashing)
            {
                camGame.filters = [
                    new ShaderFilter(chromZoomShader),
                    new ShaderFilter(chromNormalShader)
                ];
                camHUD.filters = [
                    new ShaderFilter(chromNormalShader)
                ];
            }
            
            chromEffect += 0.2;
            
            if (chromTween != null)
                chromTween.cancel();

            chromTween = FlxTween.num(chromEffect, 0.0001, 0.1, {
				ease: FlxEase.sineOut,
                onComplete: function(twn:FlxTween)
                {
                    chromTween = null;
                }
			}, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
        }
    }
}

function onBeatHit()
{
    if (curBeat == 160)
    {
        whiteBG.alpha = 1;
        FlxTween.tween(whiteBG, {alpha: 0}, 2);
        FlxTween.tween(fuckingsquares, {alpha: 0}, 5, {ease: FlxEase.sineOut});
    }

    if (curBeat == 184)
    {
        FlxTween.tween(fuckingsquares, {alpha: 1}, 1.5, {ease: FlxEase.sineOut});
    }

    switch (curBeat)
    {
        // Intro Cam Stuff
        case 1: FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
        case 16: tweenCamera(1.2, 5, 'quartInOut');
        case 32:
            defaultCamZoom = 0.75;
            FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
        case 160: defaultCamZoom = 0.65;
        case 164: tweenCamera(1.5, 6, 'sineInOut');
        case 191:
            //mickeyEmitter.emitting = true;
            if (ClientPrefs.shaders)
            {
                if (!ClientPrefs.lowQuality)
                {
                    camGame.filters = [new ShaderFilter(chromZoomShader)];
                    camHUD.filters = [new ShaderFilter(chromNormalShader)];
                }
            }
        case 320:
            FlxTween.tween(camHUD, {alpha: 0}, 0.5);
        case 328:
            FlxTween.tween(camHUD, {alpha: 1}, 0.5);
        case 584:
            FlxTween.tween(camHUD, {alpha: 0}, 4.45, {ease: FlxEase.quartInOut});
        case 616:
            camGame.visible = false;

        case 48: defaultCamZoom = 0.75;
        case 39: defaultCamZoom = 0.75;
        case 64: defaultCamZoom = 0.75;
        case 72: defaultCamZoom = 0.75;
        case 88: defaultCamZoom = 0.75;
        case 96: defaultCamZoom = 0.75;
        case 103: defaultCamZoom = 0.75;
        case 113: defaultCamZoom = 0.75;
        case 128: defaultCamZoom = 0.75;
        case 184: defaultCamZoom = 0.75;
        case 192: defaultCamZoom = 0.75;

        case 38: tweenCamera(1.5, 0.25, 'sineInOut');
        case 102: tweenCamera(1.5, 0.25, 'sineInOut');

        case 45: defaultCamZoom = 0.9;
        case 61: defaultCamZoom = 0.9;
        case 110: defaultCamZoom = 0.9;
        case 126: defaultCamZoom = 0.9;
        case 187: defaultCamZoom = 0.9;

        case 46: defaultCamZoom = 1;
        case 62: defaultCamZoom = 1;
        case 67: defaultCamZoom = 1;
        case 76: defaultCamZoom = 1;
        case 83: defaultCamZoom = 1;
        case 92: defaultCamZoom = 1;
        case 111: defaultCamZoom = 1;
        case 127: defaultCamZoom = 1;
        case 158: defaultCamZoom = 1;
        case 190: defaultCamZoom = 1;

        case 47: defaultCamZoom = 1.3;
        case 63: defaultCamZoom = 1.3;
        case 68: defaultCamZoom = 1.3;
        case 84: defaultCamZoom = 1.3;
        case 112: defaultCamZoom = 1.3;
        case 159: defaultCamZoom = 1.3;

        case 69: defaultCamZoom = 1.1;
        case 85: defaultCamZoom = 1.1;
    }
}

function tweenCamera(zoom:Float = 0.9, time:Float = 0.6, ease:Null<String>)
{
    if (dumbCamTwn != null)
        dumbCamTwn.cancel();
    
    dumbCamTwn = FlxTween.tween(camGame, {zoom: zoom}, time, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
    {
        defaultCamZoom = zoom;
        dumbCamTwn = null;
    }});
}