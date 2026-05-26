import openfl.filters.ShaderFilter;
import funkin.utils.CoolUtil;

import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;

var mickeyEmitter:FlxEmitter;
var blackParticles:FlxEmitter;
var fuckingsquares:FlxSprite;

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;
var chromTween:FlxTween;

var pathway:String = 'stages/forbiddenRealm/';

function onLoad()
{
    defaultCamZoom = 0.75;
    //spawnGirlfriend = false;

    fuckingsquares = new FlxSprite(-750, -850);
    fuckingsquares.loadGraphic(Paths.image(pathway + 'malfunctionBG-NEW'));
    fuckingsquares.scale.set(1.2, 1);
    fuckingsquares.updateHitbox();
    fuckingsquares.antialiasing = false;
    fuckingsquares.scrollFactor.set(1, 1);
    fuckingsquares.active = false;
    add(fuckingsquares);

    var greyParticles:FlxEmitter = new FlxEmitter(-2080.5, 1212.4);
    greyParticles.launchMode = FlxEmitterMode.SQUARE;
    greyParticles.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
    greyParticles.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
    greyParticles.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    greyParticles.width = 4787.45;
    greyParticles.alpha.set(1, 1);
    greyParticles.lifespan.set(1.9, 4.9);
    greyParticles.loadParticles(Paths.image(pathway + 'greyParticle'), 500, 16, true);
    greyParticles.start(false, FlxG.random.float(.0521, .1060), 1000000);
    add(greyParticles);

    blackParticles = new FlxEmitter(-2080.5, 1212.4);
    blackParticles.launchMode = FlxEmitterMode.SQUARE;
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
    mickeyEmitter.launchMode = FlxEmitterMode.SQUARE;
    mickeyEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
    mickeyEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
    mickeyEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
    mickeyEmitter.width = 4200.45;
    mickeyEmitter.alpha.set(1, 1);
    mickeyEmitter.lifespan.set(4, 4.5);
    mickeyEmitter.start(false, FlxG.random.float(.125, .287), 100000);
    mickeyEmitter.emitting = false;

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

    if (PlayState.SONG.song != 'Malfunction Legacy')
    {
        foreground.add(blackParticles);
        foreground.add(mickeyEmitter);
    }

    camGame.alpha = 0.001;
	camHUD.alpha = 0.001;
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

function onSongStart()
{
    modManager.queueFuncOnce(160 * 4, (s,s2)->{ 
        whiteBG.alpha = 1;
        FlxTween.tween(whiteBG, {alpha: 0}, 2);
        FlxTween.tween(fuckingsquares, {alpha: 0}, 5, {ease: FlxEase.sineOut});
    });

    modManager.queueFuncOnce(184 * 4, (s,s2)->{ 
        FlxTween.tween(fuckingsquares, {alpha: 1}, 1.5, {ease: FlxEase.sineOut});
    });

    modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
        FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
    });

    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        tweenCamera(1.2, 5, 'quartInOut');
    });

    modManager.queueFuncOnce(32 * 4, (s,s2)->{ 
        defaultCamZoom = 0.75;
        FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
    });

    modManager.queueFuncOnce(160 * 4, (s,s2)->{ 
        defaultCamZoom = 0.65;
    });

    modManager.queueFuncOnce(164 * 4, (s,s2)->{ 
        tweenCamera(1.5, 6, 'sineInOut');
    });

    modManager.queueFuncOnce(191 * 4, (s,s2)->{ 
        mickeyEmitter.emitting = true;
        if (ClientPrefs.shaders)
        {
            if (!ClientPrefs.lowQuality)
            {
                camGame.filters = [new ShaderFilter(chromZoomShader)];
                camHUD.filters = [new ShaderFilter(chromNormalShader)];
            }
        }
    });

    modManager.queueFuncOnce(320 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 0.5);
    });

    modManager.queueFuncOnce(324 * 4, (s,s2)->{ 
        var count = makeCountdownSprite('mal-prepare');
        count.scrollFactor.set();
        count.scale.set(6, 6);
		count.antialiasing = false;
        count.updateHitbox();
        count.screenCenter();
        count.cameras = [camGame];
        foreground.add(count);
        FlxG.sound.play(Paths.sound('intro3-glitch'), 2);
    });

    modManager.queueFuncOnce(325 * 4, (s,s2)->{ 
        var count = makeCountdownSprite('mal-ready');
        count.scrollFactor.set();
        count.scale.set(6, 6);
		count.antialiasing = false;
        count.updateHitbox();
        count.screenCenter();
        count.cameras = [camGame];
        count.antialiasing = false;
        foreground.add(count);
        FlxG.sound.play(Paths.sound('intro2-glitch'), 2);
    });

    modManager.queueFuncOnce(326 * 4, (s,s2)->{ 
        var count = makeCountdownSprite('mal-set');
        count.scrollFactor.set();
        count.scale.set(6, 6);
		count.antialiasing = false;
        count.updateHitbox();
        count.screenCenter();
        count.cameras = [camGame];
        count.antialiasing = false;
        foreground.add(count);
        FlxG.sound.play(Paths.sound('intro1-glitch'), 2);
    });

    modManager.queueFuncOnce(327 * 4, (s,s2)->{ 
        var count = makeCountdownSprite('mal-go');
        count.scrollFactor.set();
        count.scale.set(6, 6);
		count.antialiasing = false;
        count.updateHitbox();
        count.screenCenter();
        count.cameras = [camGame];
        count.antialiasing = false;
        foreground.add(count);
        FlxG.sound.play(Paths.sound('introGo-glitch'), 2);
    });

    modManager.queueFuncOnce(328 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 0.5);
    });

    modManager.queueFuncOnce(584 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 4.45, {ease: FlxEase.quartInOut});
    });

    modManager.queueFuncOnce(616 * 4, (s,s2)->{ 
        camGame.visible = false;
    });

    for (i in [48, 39, 64, 72, 88, 96, 103, 113, 128, 184, 192])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom = 0.75;
        });
    }

    for (i in [38, 102])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            tweenCamera(1.5, 0.25, 'sineInOut');
        });
    }

    for (i in [45, 61, 110, 126, 187])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom = 0.9;
        });
    }

    for (i in [46, 62, 67, 76, 83, 92, 111, 127, 158, 190])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom = 1;
        });
    }

    for (i in [47, 63, 68, 84, 112, 159])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom = 1.3;
        });
    }

    for (i in [69, 85])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            defaultCamZoom = 1.1;
        });
    }
}