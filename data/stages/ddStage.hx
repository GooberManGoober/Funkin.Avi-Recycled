import openfl.filters.ShaderFilter;
import flixel.addons.text.FlxTypeText;

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');

//DEVILISH DEAL
var gradient:FlxSprite;
var bg:FlxSprite;
var overlay:FlxSprite;

var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;
var chromTween:FlxTween;

var satanIconPulse:HealthIcon;
var iconPulseTween:FlxTween;
var satanTween:FlxTween;

var devilishGaming:FunkinVideoSprite;

function onLoad()
{
    bg = new FlxSprite(-600, 130).loadGraphic(Paths.image("stages/ddStage/sky"));
    bg.scale.set(0.84, 0.84);
    bg.scrollFactor.set(0.8, 0.8);
    add(bg);

    var buildings:FlxSprite = new FlxSprite(-600, 130).loadGraphic(Paths.image("stages/ddStage/back-buildings"));
    buildings.scale.set(0.84, 0.84);
    buildings.scrollFactor.set(0.9, 0.9);
    add(buildings);

    var alley:FlxSprite = new FlxSprite(-600, 130).loadGraphic(Paths.image("stages/ddStage/alley_and_bench"));
    alley.scale.set(0.84, 0.84);
    add(alley);
}

function onCreatePost()
{
    healthBar.leftToRight = true;
    
    var rain:FlxSprite = new FlxSprite(-600, 130);
    rain.frames = Paths.getSparrowAtlas("stages/ddStage/Rain");
    rain.animation.addByPrefix("crying bitch", "rain but the side", 30, true);
    rain.scale.set(2.1, 2.1);
    rain.scrollFactor.set(1.1, 1.1);
    rain.animation.play("crying bitch");
    rain.alpha = 0.5;
    foreground.add(rain);

    var fgWall:FlxSprite = new FlxSprite(-600, 290).loadGraphic(Paths.image("stages/ddStage/big-ass-wall"));
    fgWall.scale.set(0.84, 0.84);
    fgWall.scrollFactor.set(1.18, 1.18);
    foreground.add(fgWall);

    devilishGaming = new FunkinVideoSprite(false);
    devilishGaming.load(Paths.video("devilishIntro"), [FunkinVideoSprite.muted]);
    add(devilishGaming);
    devilishGaming.cameras = [camOther];
    devilishGaming.play();
    new FlxTimer().start(0.001, function(tmr:FlxTimer)
    {
        devilishGaming.pause();
        devilishGaming.bitmap.time = 0;
    });
    
    gradient = new FlxSprite().loadGraphic(Paths.image('filters/gradient'));
    gradient.cameras = [camOther];
    gradient.screenCenter();
    gradient.scale.set(0.5, 0.5);
    gradient.alpha = 0;
    add(gradient);

    satanIconPulse = new HealthIcon('satan', true);
    satanIconPulse.y = healthBar.y - 90;
    satanIconPulse.animation.curAnim.curFrame = 1;
    satanIconPulse.visible = false;
    satanIconPulse.frameCount = 3;
    playHUD.add(satanIconPulse);

    dad.setColorTransform(-1, -1, -1, 1, 0, 0, 0, 0);
	camGame.alpha = 0.001;

	camHUD.alpha = 0.001;

    modManager.setValue("opponentSwap", 1);
    modManager.setValue("alpha", 1, 1);

    iconP1.updateFrames = false;
    iconP2.updateFrames = false;
    
    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = ([
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromZoomShader),
                new ShaderFilter(chromNormalShader)
            ]);
            camHUD.filters = ([new ShaderFilter(chromNormalShader)]);
        }
        else
        {
            camGame.filters = ([
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromNormalShader)
            ]);
            camHUD.filters = ([
                new ShaderFilter(chromNormalShader)
            ]);
        }
    }

    iconP2.flipX = iconP1.flipX = true;
}

function onUpdate(elapsed)
{
    shaderAnim = Conductor.songPosition / 1000;
    
    chromZoomShader.setFloat('aberration', chromEffect);
    chromZoomShader.setFloat('effectTime', chromEffect);
    chromNormalShader.setFloat('rOffset', chromEffect / 70);
    chromNormalShader.setFloat('bOffset', -chromEffect / 70);
    dramaticCamMovement.setFloat('time', shaderAnim);

    var mult:Float = FlxMath.lerp(1, satanIconPulse.scale.x, FlxMath.bound(1 - (elapsed * 9), 0, 1));
	satanIconPulse.scale.set(mult, mult);
	satanIconPulse.updateHitbox();

    satanIconPulse.x = iconP2.x;
}

function onSongStart()
{
    modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
        satanIconPulse.visible = true;
        satanIconPulse.alpha = 0.001;
    });

    modManager.queueFuncOnce(128 * 4, (s,s2)->{ 
        camGame.visible = false;
        camHUD.visible = false;
        playFields.visible = false;
    });

    modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
        devilishGaming.resume();
        devilishGaming.visible = true;
    });

    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        FlxTween.tween(devilishGaming, {alpha: 0}, 3, {ease: FlxEase.sineOut});
        FlxTween.tween(camGame, {alpha: 1}, 3, {ease: FlxEase.sineOut});
        defaultCamZoom = 1.3;
        manageLyrics('satandd', 'In the rain...', 'betterSatanFont.ttf', 30, 2, 'sineInOut', 0.1);
    });

    modManager.queueFuncOnce(20 * 4, (s,s2)->{ 
        manageLyrics('satandd', '...Looking so blue...', 'betterSatanFont.ttf', 30, 3.2, 'sineInOut', 0.08);
    });

    modManager.queueFuncOnce(26 * 4, (s,s2)->{ 
        manageLyrics('satandd', '...SPEAK...', 'betterSatanFont.ttf', 30, 0.7, 'sineInOut', 0.05);
    });

    modManager.queueFuncOnce(28 * 4, (s,s2)->{
        isCameraOnForcedPos = true;
        FlxTween.tween(camFollow, {x: 1500, y: 1300}, 2, {ease: FlxEase.sineInOut});
        FlxTween.tween(FlxG.camera, {zoom: 0.55}, 2, {ease: FlxEase.sineInOut});
        defaultCamZoom = 0.55;
        manageLyrics('satandd', '...What is on your mind?', 'betterSatanFont.ttf', 30, 2.5, 'sineInOut', 0.06);
    });

    modManager.queueFuncOnce(30 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.sineOut});
    });

    for (i in [32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            if (ClientPrefs.shaders)
            {
                if (chromTween != null)
                    chromTween.cancel();

                chromEffect = 0.32;

                chromTween = FlxTween.num(chromEffect, 0.0001, 1.2, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            }
        });
    }

    modManager.queueFuncOnce(60 * 4, (s,s2)->{ 
        FlxTween.tween(camFollow, {x: 2200, y: 1400}, 2, {ease: FlxEase.sineInOut});
        FlxTween.tween(FlxG.camera, {zoom: 1.2}, 2, {ease: FlxEase.sineInOut});
        defaultCamZoom = 1.2;
        FlxTween.tween(camHUD, {alpha: 0.4}, 0.75, {ease: FlxEase.quartInOut});
        FlxTween.tween(dad.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1}, 2, {ease: FlxEase.circInOut});
        if (ClientPrefs.shaders)
        {
            if (chromTween != null)
                chromTween.cancel();

            chromEffect = 0.15;

            chromTween = FlxTween.num(chromEffect, 0.0001, 1.2, {
                ease: FlxEase.sineOut,
                onComplete: function(twn:FlxTween)
                {
                    chromTween = null;
                }
            }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
        }
    });

    modManager.queueFuncOnce(62 * 4, (s,s2)->{ 
        if (ClientPrefs.shaders)
        {
            if (chromTween != null)
                chromTween.cancel();

            chromEffect = 0.15;

            chromTween = FlxTween.num(chromEffect, 0.0001, 2, {
                ease: FlxEase.sineOut,
                onComplete: function(twn:FlxTween)
                {
                    chromTween = null;
                }
            }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
        }

        iconP2.animation.curAnim.curFrame = 2;
    });

    modManager.queueFuncOnce(63 * 4, (s,s2)->{ 
        iconP1.animation.curAnim.curFrame = 1;
    });

    modManager.queueFuncOnce(96 * 4, (s,s2)->{ 
        iconP1.animation.curAnim.curFrame = 2;
    });

    modManager.queueFuncOnce(112 * 4, (s,s2)->{ 
        iconP1.animation.curAnim.curFrame = 0;
    });
    
    modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
        isCameraOnForcedPos = false;
        defaultCamZoom = 0.55;
        FlxTween.tween(camHUD, {alpha: 1}, 1.2, {ease: FlxEase.quartInOut});
    });

    modManager.queueFuncOnce(128 * 4, (s,s2)->{ 
        camGame.visible = false;
        if (ClientPrefs.flashing)
            camOther.flash(FlxColor.WHITE, 1);
        if (ClientPrefs.shaders)
        {
            if (chromTween != null)
                chromTween.cancel();

            chromEffect = 0.4;

            chromTween = FlxTween.num(chromEffect, 0.0001, 2.3, {
                ease: FlxEase.sineOut,
                onComplete: function(twn:FlxTween)
                {
                    chromTween = null;
                }
            }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
        }
    });
}

function onBeatHit()
{    
    // me when zoom gets higher or whatever -jason
    if(curBeat >= 64 && curBeat < 95)
    {
        FlxG.camera.zoom += 0.025;
        camHUD.zoom += 0.042;
        FlxTween.tween(gradient, {alpha: 0.3}, 2);
    }

    if(curBeat >= 96 && curBeat < 111)
    {
        FlxG.camera.zoom += 0.04;
        camHUD.zoom += 0.053;
        FlxTween.tween(gradient, {alpha: 0.6}, 2);
    }

    if(curBeat == 112)
    {
        isCameraOnForcedPos = true;
        FlxTween.tween(camFollow, {x: camFollow.x - 150, y: 1380}, 14, {ease: FlxEase.sineInOut});
        FlxTween.tween(FlxG.camera, {zoom: 2}, 14, {ease: FlxEase.sineInOut});
        FlxTween.tween(gradient, {alpha: 0.9}, 2);
    }

    if(curBeat >= 112) // doesn't make sense to but a "&& curBeat < idk"
    {
        // not including camGame cus it bugs out
        camHUD.zoom += 0.053;
    }

    if (curBeat >= 64 && curBeat <= 79)
    {
        if (iconPulseTween != null)
            iconPulseTween.cancel();
        if (satanTween != null)
            satanTween.cancel();

        satanIconPulse.alpha = 0.25;
        iconP2.alpha = 0.75;

        iconPulseTween = FlxTween.tween(satanIconPulse, {alpha: 0}, 0.65, {onComplete: function(twn:FlxTween)
            {
                iconPulseTween = null;
            }
        });

        satanTween = FlxTween.tween(iconP2, {alpha: 1}, 0.65, {onComplete: function(twn:FlxTween)
            {
                satanTween = null;
            }
        });
    }
    if (curBeat >= 80 && curBeat <= 95)
    {
        if (iconPulseTween != null)
            iconPulseTween.cancel();
        if (satanTween != null)
            satanTween.cancel();

        satanIconPulse.alpha = 0.35;
        iconP2.alpha = 0.65;

        iconPulseTween = FlxTween.tween(satanIconPulse, {alpha: 0}, 0.65, {onComplete: function(twn:FlxTween)
            {
                iconPulseTween = null;
            }
        });

        satanTween = FlxTween.tween(iconP2, {alpha: 1}, 0.65, {onComplete: function(twn:FlxTween)
            {
                satanTween = null;
            }
        });
    }
    if (curBeat >= 96 && curBeat <= 111)
    {
        if (iconPulseTween != null)
            iconPulseTween.cancel();
        if (satanTween != null)
            satanTween.cancel();

        satanIconPulse.alpha = 0.5;
        iconP2.alpha = 0.5;

        iconPulseTween = FlxTween.tween(satanIconPulse, {alpha: 0}, 0.65, {onComplete: function(twn:FlxTween)
            {
                iconPulseTween = null;
            }
        });

        satanTween = FlxTween.tween(iconP2, {alpha: 1}, 0.65, {onComplete: function(twn:FlxTween)
            {
                satanTween = null;
            }
        });
    }
    if (curBeat >= 112 && curBeat <= 130)
    {
        if (iconPulseTween != null)
            iconPulseTween.cancel();
        if (satanTween != null)
            satanTween.cancel();

        satanIconPulse.alpha = 0.75;
        iconP2.alpha = 0.25;

        iconPulseTween = FlxTween.tween(satanIconPulse, {alpha: 0}, 0.65, {onComplete: function(twn:FlxTween)
            {
                iconPulseTween = null;
            }
        });

        satanTween = FlxTween.tween(iconP2, {alpha: 1}, 0.65, {onComplete: function(twn:FlxTween)
            {
                satanTween = null;
            }
        });
    }	

    satanIconPulse.scale.set(1.35, 1.35);
	satanIconPulse.updateHitbox();

    if (curBeat >= 64 && curBeat <= 95 && ClientPrefs.shaders)
    {
        if (chromTween != null)
            chromTween.cancel();

        chromEffect = 0.23;

        chromTween = FlxTween.num(chromEffect, 0.0001, 1.5, {
            ease: FlxEase.sineOut,
            onComplete: function(twn:FlxTween)
            {
                chromTween = null;
            }
        }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
    }

    if (curBeat >= 96 && curBeat <= 111 && ClientPrefs.shaders)
    {
        if (chromTween != null)
            chromTween.cancel();

        chromEffect = 0.27;

        chromTween = FlxTween.num(chromEffect, 0.0001, 1.5, {
            ease: FlxEase.sineOut,
            onComplete: function(twn:FlxTween)
            {
                chromTween = null;
            }
        }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
    }

    if (curBeat >= 112 && curBeat <= 127 && ClientPrefs.shaders)
    {
        if (chromTween != null)
            chromTween.cancel();

        chromEffect = 0.32;

        chromTween = FlxTween.num(chromEffect, 0.0001, 1.5, {
            ease: FlxEase.sineOut,
            onComplete: function(twn:FlxTween)
            {
                chromTween = null;
            }
        }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
    }
}