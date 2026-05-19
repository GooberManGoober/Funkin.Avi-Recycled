import openfl.filters.ShaderFilter;
import flixel.addons.text.FlxTypeText;

import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');
var delusionalShift:FlxRuntimeShader = newShader('delusionalShift');
var redVignette:FlxRuntimeShader = newShader('redFromAngryBirds');

var fireThing:FlxSprite;

var floor:FlxSprite;
var stageCurtains:FlxSprite;
var rain:FlxSprite;
var rainTween:FlxTween;
var pathway:String = 'stages/abandonedStreet/delusion/';

var streetDaytime:FlxSprite;
var clouds:FlxSprite;
var brightSky:FlxSprite;

var atmosphereParticle:FlxEmitter;
var ashParticle:FlxEmitter;

var fakeLightOfHope:FlxSprite;
var streetRuins:FlxSprite;

var vignetteTween:FlxTween;
var effectRed:Float = 0.0;

var tumbleWeed:FlxSprite;

var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;

var drainValue:Float = 0;
var boundValue:Float = 0;

function onLoad()
{
    defaultCamZoom = 0.87;
    cameraSpeed = 1;
    
    colorsOrSmthElse = new FlxSprite(-990, 1600).loadGraphic(Paths.image(pathway + 'randomColors'));
    colorsOrSmthElse.setGraphicSize(Std.int(colorsOrSmthElse.width * 4));
    colorsOrSmthElse.updateHitbox();
    colorsOrSmthElse.antialiasing = ClientPrefs.globalAntialiasing;
    colorsOrSmthElse.screenCenter();
    colorsOrSmthElse.scale.set(3, 3);
    colorsOrSmthElse.scrollFactor.set(0.9, 0.9);
    colorsOrSmthElse.active = false;
    add(colorsOrSmthElse);
    
    floor = new FlxSprite(-20, 200).loadGraphic(Paths.image(pathway + 'street'));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    floor.scale.set(2.5, 2.3);
    floor.scrollFactor.set(1, 1);
    floor.active = false;
    add(floor);

    if (PlayState.SONG.song == 'Delusion')
    {	
        fakeLightOfHope = new FlxSprite(-990, 1600).loadGraphic(Paths.image('stages/abandonedStreet/falseHope'));
        fakeLightOfHope.setGraphicSize(Std.int(fakeLightOfHope.width * 4));
        fakeLightOfHope.updateHitbox();
        fakeLightOfHope.antialiasing = ClientPrefs.globalAntialiasing;
        fakeLightOfHope.screenCenter();
        fakeLightOfHope.scale.set(3, 3);
        fakeLightOfHope.scrollFactor.set(0.9, 0.9);
        add(fakeLightOfHope);

        if (!ClientPrefs.lowQuality)
		{
			fireThing = new FlxSprite(0, -80);
			fireThing.scale.set(5.85, 3);
			fireThing.alpha = 0.0001;
			fireThing.antialiasing = ClientPrefs.globalAntialiasing;
			fireThing.frames = Paths.getSparrowAtlas(pathway + 'delusional-fire');
			fireThing.animation.addByPrefix('burning', 'delusional-fire fire-idle', 16, true);
			fireThing.scrollFactor.set(0.8, 0.8);
			add(fireThing);
			fireThing.animation.play('burning');
		}

        brightSky = new FlxSprite(-990, 1600).loadGraphic(Paths.image(pathway + 'brightSky'));
        brightSky.setGraphicSize(Std.int(brightSky.width * 4));
        brightSky.updateHitbox();
        brightSky.antialiasing = true;
        brightSky.screenCenter();
        brightSky.scale.set(3, 3);
        brightSky.scrollFactor.set(0.9, 0.9);
        add(brightSky);

        if (!ClientPrefs.lowQuality)
        {
            clouds = new FlxSprite(-990, 1600).loadGraphic(Paths.image(pathway + 'clouds'));
            clouds.setGraphicSize(Std.int(clouds.width * 4));
            clouds.updateHitbox();
            clouds.antialiasing = true;
            clouds.screenCenter();
            clouds.scale.set(3, 3);
            clouds.scrollFactor.set(1.1, 1.1);
            add(clouds);
            clouds.visible = false;
        }

        streetDaytime = new FlxSprite(-20, 200).loadGraphic(Paths.image(pathway + 'streetDay'));
        streetDaytime.antialiasing = true;
        streetDaytime.scale.set(2.5, 2.3);
        streetDaytime.scrollFactor.set(1, 1);
        add(streetDaytime);

        streetRuins = new FlxSprite(-20, 200).loadGraphic(Paths.image(pathway + 'streetDestroyed'));
        streetRuins.antialiasing = ClientPrefs.globalAntialiasing;
        streetRuins.scale.set(2.8, 2.5);
        streetRuins.scrollFactor.set(1, 1);
        add(streetRuins);
        
        brightSky.visible = false;
		streetDaytime.visible = false;
        streetRuins.visible = false;
        fakeLightOfHope.visible = false;
    }

    if(!ClientPrefs.lowQulity)
    {
        stageCurtains = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/abandonedStreet/i_forgor'));
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.screenCenter();
        stageCurtains.scale.set(1.3,1.3);
        stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
        stageCurtains.cameras = [camOther];
        stageCurtains.scrollFactor.set(1.3, 1.3);
        add(stageCurtains);
    }
}

function onCreatePost()
{
    if(!ClientPrefs.lowQulity)
    {
        streetDaytime.visible = true;
        clouds.visible = true;
        brightSky.visible = true;

        atmosphereParticle = new FlxEmitter(-2080.5, 2000);
        atmosphereParticle.launchMode = FlxEmitterMode.SQUARE;
        atmosphereParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
        atmosphereParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
        atmosphereParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
        atmosphereParticle.width = 4787.45;
        atmosphereParticle.alpha.set(1, 0.3);
        atmosphereParticle.lifespan.set(1.9, 4.9);
        atmosphereParticle.loadParticles(Paths.image('stages/abandonedStreet/dustParticle'), 500, 16, true);
        atmosphereParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);

        ashParticle = new FlxEmitter(-2080.5, 2150.4);
        for (i in 0 ... 100)
            {
                var blackParticle = new FlxParticle();
                blackParticle.frames = Paths.getSparrowAtlas('stages/abandonedStreet/ashParticle');
                blackParticle.animation.addByPrefix('idle', 'ashParticle idle', 5, true);
                blackParticle.animation.play('idle');
                blackParticle.antialiasing = ClientPrefs.globalAntialiasing;
                blackParticle.exists = false;
                ashParticle.add(blackParticle);
            }
        ashParticle.launchMode = FlxEmitterMode.SQUARE;
        ashParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
        ashParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
        ashParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
        ashParticle.width = 4787.45;
        ashParticle.alpha.set(1, 1);
        ashParticle.lifespan.set(1.9, 4.9);
        ashParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);
        ashParticle.angle.set(290, 0);
        ashParticle.launchAngle.set(0, 280);
        foreground.add(atmosphereParticle);
		foreground.add(ashParticle);
    }

    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromZoomShader),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [new ShaderFilter(chromNormalShader)];
        }
        else
        {
            camGame.filters = [
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [
                new ShaderFilter(chromNormalShader)
            ];
        }
    }

    camBars.fade(FlxColor.BLACK, 0.001, false);
    camHUD.alpha = 0.001;

}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;
    
    if (ClientPrefs.shaders)
    {
        chromZoomShader.setFloat('aberration', chromEffect);
        chromZoomShader.setFloat('effectTime', chromEffect);
        chromNormalShader.setFloat('rOffset', chromEffect / 45);
        chromNormalShader.setFloat('bOffset', -chromEffect / 45);
        dramaticCamMovement.setFloat('time', shaderAnim);
        delusionalShift.setFloat('iTime', shaderAnim);
        delusionalShift.setFloat('uTime', shaderAnim);
        redVignette.setFloat('time', effectRed);
    }
}

function onBeatHit()
{
    if (!ClientPrefs.lowQuality)
    {
        if (PlayState.SONG.song == "Delusional" && FlxG.random.bool(3) && tumbleWeed == null && curBeat < 474)
            summonWeedMakerLmfao();
        else if (PlayState.SONG.song != "Delusional" && FlxG.random.bool(3) && tumbleWeed == null)
            summonWeedMakerLmfao();
    }
    
    if (curBeat >= 72 && curBeat <= 87)
    {
        effectRed = 1;

        if (vignetteTween != null)
            vignetteTween.cancel();

        vignetteTween = FlxTween.num(effectRed, 0.0, 0.4, {
            ease: FlxEase.sineOut,
            onComplete: function(twn:FlxTween)
            {
                vignetteTween = null;
            }
        }, shitshitfuckfuck -> effectRed = shitshitfuckfuck);
    }

    if (curBeat >= 88 && curBeat <= 103)
    {
        effectRed = 1.2;
        
        if (vignetteTween != null)
            vignetteTween.cancel();

        vignetteTween = FlxTween.num(effectRed, 0.0, 0.4, {
            ease: FlxEase.sineOut,
            onComplete: function(twn:FlxTween)
            {
                vignetteTween = null;
            }
        }, shitshitfuckfuck -> effectRed = shitshitfuckfuck);
    }
}

function onSongStart()
{
    modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
        camBars.fade(FlxColor.BLACK, 2, true);
        cinematicBarControls("create", 1);
        cinematicBarControls("moveboth", 0.0001, 'linear', 100);
    });
    
    modManager.queueFuncOnce(8 * 4, (s,s2)->{ 
        defaultCamZoom -= 0.08;
        camFlashSystem('flash', {timer: 0.35});
        cinematicBarControls("moveboth", 0.35, 'circOut', 70);
        FlxTween.tween(camHUD, {alpha: 1}, 0.4);
    });

    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        defaultCamZoom += 0.1;
        cinematicBarControls("moveboth", 0.35, 'circOut', 80);
    });

    modManager.queueFuncOnce(24 * 4, (s,s2)->{ 
        camGame.zoom += 0.12;
        defaultCamZoom -= 0.2;
        camFlashSystem('flash', {alpha: 0.35, timer: 0.45, ease: FlxEase.circOut, colors: [255, 135, 135]});
        cinematicBarControls("bopboth", 0.45, 'circOut', 60, 40);
    });

    modManager.queueFuncOnce(40 * 4, (s,s2)->{ 
        defaultCamZoom -= 0.25;
        camFlashSystem('flash', {alpha: 0.6, timer: 0.3, ease: FlxEase.circOut, colors: [255, 135, 135]});
        cinematicBarControls("bopboth", 0.3, 'circOut', 55, 40);
        camGame.zoom += 0.16;
    });

    for (i in [104, 112, 120, 128])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camGame.zoom += 0.25;
			camFlashSystem('flash', {alpha: 0.6, timer: 0.3, ease: FlxEase.circOut, colors: [255, 135, 135]});
            cinematicBarControls("bopboth", 0.3, 'circOut', 70, 30);
        });
    }

    modManager.queueFuncOnce(136 * 4, (s,s2)->{ 
        camFlashSystem('flash', {alpha: 0.35, timer: 0.45, ease: FlxEase.circOut, colors: [255, 135, 135]});
        camGame.zoom += 0.1;
        cinematicBarControls("bopboth", 0.45, 'circOut', 85, 30);
        defaultCamZoom += 0.11;
    });

    for (i in [108, 116])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('dark', {alpha: 0.2, timer: 0.35, ease: FlxEase.sineOut});
            cinematicBarControls("moveboth", 0.35, 'sineOut', 100);
        });
    }

    for (i in [110, 118])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('dark', {alpha: 0.5, timer: 0.35, ease: FlxEase.sineOut});
            cinematicBarControls("moveboth", 0.35, 'sineOut', 120);
        });
    }

    for (i in [
            25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 
            63, 64, 65, 66, 67, 68, 69, 70, 71, 137, 138, 
            139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 
            150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 
            161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 
            172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 
            183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 232, 
            233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243,
            244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254,
            255, 256, 257, 258, 259, 260, 261
        ])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('flash', {alpha: 0.35, timer: 0.45, ease: FlxEase.circOut, colors: [255, 135, 135]});
            cinematicBarControls("bopboth", 0.45, 'circOut', 70, 30);
            camGame.zoom += 0.1;

            modManager.setValue("drunkZ", 1, -1);
            modManager.setValue("drunk", 1, -1);

            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunkZ", 0, 'circOut', -1);
            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunk", 0, 'circOut', -1);

        });
    }

    for (i in [72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('flash', {alpha: 0.56, timer: 0.45, ease: FlxEase.circOut, colors: [255, 135, 135]});
            cinematicBarControls("bopboth", 0.45, 'circOut', 80, 30);
            camGame.zoom += 0.16;

            modManager.setValue("drunkZ", 1.25, -1);
            modManager.setValue("drunk", 1.25, -1);

            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunkZ", 0, 'circOut', -1);
            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunk", 0, 'circOut', -1);
        });
    }

    for (i in [88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('flash', {alpha: 0.89, timer: 0.45, ease: FlxEase.circOut, colors: [255, 135, 135]});
            cinematicBarControls("bopboth", 0.45, 'circOut', 100, 30);
            camGame.zoom += 0.21;

            modManager.setValue("drunkZ", 1.5, -1);
            modManager.setValue("drunk", 1.5, -1);

            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunkZ", 0, 'circOut', -1);
            modManager.queueEase(i * 4, (i * 4) + 1.75, "drunk", 0, 'circOut', -1);
        });
    }

    for (i in [36, 134])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('dark', {alpha: 0.8, timer: 0.21, ease: FlxEase.sineOut});
            cinematicBarControls("moveboth", 0.21, 'sineOut', 120);
            defaultCamZoom += 0.3;
        });
    }

    modManager.queueFuncOnce(136 * 4, (s,s2)->{ 
        defaultCamZoom -= 0.3;
    });

    modManager.queueFuncOnce(24 * 4, (s,s2)->{ 
        FlxTween.tween(streetDaytime, {alpha: 0}, 5);
        FlxTween.tween(clouds, {alpha: 0}, 5);
        FlxTween.tween(brightSky, {alpha: 0}, 5);
    });

    modManager.queueFuncOnce(232 * 4, (s,s2)->{ 
        fakeLightOfHope.visible = true;
        streetRuins.visible = true;

        if (!ClientPrefs.lowQuality) 
        {
            fireThing.alpha = 1;

            atmosphereParticle.visible = false;
            ashParticle.visible = false;
        }

        camGame.flash(FlxColor.fromRGB(255, 135, 135), 0.3);

        camFollow.x = 440;
        camFollow.y = 360;
        defaultCamZoom = 0.5;
        isCameraOnForcedPos = true;
    });

    modManager.queueFuncOnce(264 * 4, (s,s2)->{ 
        isCameraOnForcedPos = false;
        defaultCamZoom = 0.9;
    });

    modManager.queueFuncOnce(295 * 4, (s,s2)->{ 
        modManager.setValue("alpha", 1, -1);
        playHUD.alpha = 0;
        camGame.alpha = 0;
        camHUD.flash(FlxColor.fromRGB(255, 135, 135), 1);
    });
}

function summonWeedMakerLmfao()
{
    tumbleWeed = new FlxSprite(1800, 600);
    tumbleWeed.antialiasing = ClientPrefs.globalAntialiasing;
    var velocityX:Float = 0;
    var bounceVal:Int = 735;
    var loopTime:Array<Float> = [];
    if (FlxG.random.bool(1))
    {
        tumbleWeed.loadGraphic(Paths.image('stages/abandonedStreet/THELEGENDARYTUMBLEWEED'));
        tumbleWeed.scale.set(0.6, 0.6);
        velocityX = -1270;
        bounceVal = 50;
        loopTime[0] = 0.5;
        loopTime[1] = 0.1;
        loopTime[2] = 4;
    }
    else
    {
        tumbleWeed.loadGraphic(Paths.image('stages/abandonedStreet/Tumble_' + FlxG.random.int(0,1)));
        velocityX = -520;
        loopTime[0] = 1.7;
        loopTime[1] = 0.75;
        loopTime[2] = 5.6;
    }
    tumbleWeed.velocity.set(velocityX, 0);
    foreground.add(tumbleWeed);
    FlxTween.tween(tumbleWeed, {angle: -360}, loopTime[0], {type: 2});
    FlxTween.tween(tumbleWeed, {y: bounceVal}, loopTime[1], {ease: FlxEase.sineInOut, type: 4});
    new FlxTimer().start(loopTime[2], function(tmr:FlxTimer)
    {
        tumbleWeed.kill();
        tumbleWeed = null;
    });
}