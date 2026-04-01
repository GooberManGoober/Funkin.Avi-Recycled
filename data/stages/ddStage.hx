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

var lyricsIcon:HealthIcon;
var lyrics:FlxTypeText;
var lyricsTween:FlxTween;
var iconTween:FlxTween;

var devilishGaming:FunkinVideoSprite;

function onLoad()
{
    bg = new FlxSprite(-600, 130).loadGraphic(Paths.image("Funkin_avi/stages/ddStage/images/dd-bg"));
    bg.scale.set(0.75, 0.75);
    add(bg);
}

function onCreatePost()
{
    healthBar.leftToRight = true;
    
    overlay = new FlxSprite(-640, 170).loadGraphic(Paths.image("Funkin_avi/stages/ddStage/images/dd-overlay"));
    overlay.scrollFactor.set(1.15, 1.15);
    add(overlay);

    devilishGaming = new FunkinVideoSprite(false);
    devilishGaming.load(Paths.video("devilishIntro"), [FunkinVideoSprite.muted]);
    add(devilishGaming);
    devilishGaming.cameras = [camOther];
    devilishGaming.play();
    devilishGaming.visible = false;
    new FlxTimer().start(0.001, function(tmr:FlxTimer)
    {
        devilishGaming.pause();
        devilishGaming.bitmap.time = 0;
    });
    
    gradient = new FlxSprite().loadGraphic(Paths.image('Funkin_avi/filters/gradient'));
    gradient.cameras = [camOther];
    gradient.screenCenter();
    gradient.scale.set(0.5, 0.5);
    gradient.alpha = 0;
    add(gradient);

    satanIconPulse = new HealthIcon('satan', true);
    satanIconPulse.y = healthBar.y - 90;
    satanIconPulse.animation.curAnim.curFrame = 1;
    satanIconPulse.visible = false;
    playHUD.add(satanIconPulse);

    dad.setColorTransform(-1, -1, -1, 1, 0, 0, 0, 0);
	camGame.alpha = 0.001;

	camHUD.alpha = 0.001;

    if (ClientPrefs.middleScroll)
	{
		modManager.setValue("opponentSwap", 0.5);
	}
    else
    {
        modManager.setValue("opponentSwap", 1);
    }
    modManager.setValue("transform0X", -3500, 1);
    modManager.setValue("transform1X", -3500, 1);
    modManager.setValue("transform2X", 3500, 1);
	modManager.setValue("transform3X", 3500, 1);
    modManager.setValue("alpha", 1, -1);
    
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

    lyrics = new FlxTypeText(0, FlxG.height - 65, 0, '', 15);
    lyrics.setFormat(Paths.font('vcr'), 30, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    lyrics.cameras = [camOther];
    lyrics.alpha = 0;
    lyrics.borderSize = 4;
    lyrics.scrollFactor.set();
    lyrics.screenCenter(FlxAxes.X).x -= 90;
    add(lyrics);

    lyricsIcon = new HealthIcon('bf', false);
    lyricsIcon.x = lyrics.x - 150;
    lyricsIcon.y = lyrics.y - 65;
    lyricsIcon.visible = false;
    lyricsIcon.cameras = [camOther];
    add(lyricsIcon);

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
    modManager.queueEase(120, 128, "alpha", 0, 'quartInOut', -1);

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
        manageLyrics('satandd', 'In the rain...', 'betterSatanFont.ttf', 30, 2, 'sineInOut', 0.1);
    });

    modManager.queueFuncOnce(20 * 4, (s,s2)->{ 
        manageLyrics('satandd', '...Looking so blue...', 'betterSatanFont.ttf', 30, 3.2, 'sineInOut', 0.08);
    });

    modManager.queueFuncOnce(26 * 4, (s,s2)->{ 
        manageLyrics('satandd', '...SPEAK...', 'betterSatanFont.ttf', 30, 0.7, 'sineInOut', 0.05);
    });

    modManager.queueFuncOnce(28 * 4, (s,s2)->{ 
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
    });

    modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
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

    if(curBeat >= 112)
    {
        FlxTween.tween(gradient, {alpha: 0.9}, 2);
        FlxG.camera.zoom += 0.04;
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

/**
	* Manages the `lyrics` of the song in-game
	* @param icon Lyrics icon as string
	* @param text The lyrics text
	* @param font Lyric font
	* @param size Lyric size
	* @param duration Delay time to disappear
	* @param tweenType Tween ease (as string)
	* @param textDelay Text delay. The amount of seconds to type the next word
	* 
	* @author DEMOLITIONDON96 Ft. Jason
	*/
function manageLyrics(icon:String = 'bf', text:String = 'swaggers', font:String = 'vcr', size:Int = 15, duration:Float = 5,
		tweenType:String = 'linear', textDelay:Float = 0.03)
{
	if (!lyricsIcon.visible)
	{
		lyricsIcon.visible = true;
		lyricsIcon.alpha = 0;
	}

	lyricsIcon.changeIcon(icon, false, false, false);

	if (icon == "satandd")
		lyricsIcon.y = lyrics.y - 80;
	else
		lyricsIcon.y = lyrics.y - 65;

	lyrics.font = Paths.font(font);
	lyrics.resetText(text);
	lyrics.start(textDelay); // currently placeholder time !!

	if (lyricsTween != null)
		lyricsTween.cancel();

	if (iconTween != null)
		iconTween.cancel();

	iconTween = FlxTween.tween(lyricsIcon, {
		'scale.x': 1,
		'scale.y': 1,
		alpha: 1
	}, 0.5, {
		ease: CoolUtil.getEaseFromString(tweenType),
		onComplete: function(twn:FlxTween)
		{
			iconTween = FlxTween.tween(lyricsIcon, {alpha: 0, 'scale.x': 0, 'scale.y': 0}, 0.25, {
				startDelay: duration,
				ease: CoolUtil.getEaseFromString(tweenType),
				onComplete: function(twn:FlxTween)
				{
					iconTween = null;
				}
			});
		}
	});

	lyricsTween = FlxTween.tween(lyrics, {
		size: size,
		alpha: 1
	}, 0.5, {
		ease: CoolUtil.getEaseFromString(tweenType),
		onComplete: function(twn:FlxTween)
		{
			lyricsTween = FlxTween.tween(lyrics, {alpha: 0, size: 0}, 0.25, {
				startDelay: duration,
				ease: CoolUtil.getEaseFromString(tweenType),
				onComplete: function(twn:FlxTween)
				{
					lyricsTween = null;
				}
			});
		}
	});
}