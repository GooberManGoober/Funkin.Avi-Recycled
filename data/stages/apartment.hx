var pathway:String = 'stages/apartment/';

var bg1:FlxSprite;
var dodgeWarning:FlxSprite;

var dodged:Bool;
var shootin:Bool;

var relapseIconLol:HealthIcon;

var relapseEndNotes:Array<String> = [
    "ah",
    "eh",
    "ah",
    "eh",
    "oo",
    "o",
    "o",
    "ah",
    "ehh",
    "ooo",
    "ahh",
    "eee",
    "ah",
    "ah",
    "e",
    "ah",
    "ah",
    "ah",
    "ee",
    "o",
    "eh",
    "o",
    "e",
    "oh",
    "e",
    "oh",
    "e",
    "ah",
    "ehh",
    "ahh",
    "ahh",
    "ee",
    "ohhh"
];
var textGroup:FlxTypedGroup;

var sinsEnd:Bool = false;

function onLoad()
{
    defaultCamZoom = 0.46;
    cameraSpeed = 0.9;

    bg1 = new FlxSprite(0, 50).loadGraphic(Paths.image(pathway + 'relapseBG-nominnie'));
    bg1.scale.set(7, 7);
    bg1.antialiasing = false;
    add(bg1);

    stageBGFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	stageBGFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
	stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
	stageBGFlash.x -= 750;
	stageBGFlash.y -= 450;
	stageBGFlash.scrollFactor.set();
	add(stageBGFlash);

    textGroup = new FlxTypedGroup();
    add(textGroup);
}

function onCreatePost()
{
    playHUD.ratingPrefix = "pixelUI/";
    playHUD.ratingSuffix = "-pixel";
    
    dodgeWarning = new FlxSprite(1080, 540).loadGraphic(Paths.image('UI/dodgeSins/cycledWarn' + (FlxG.random.bool(2) ? "-alt" : "")));
    dodgeWarning.antialiasing = false;
    dodgeWarning.scale.set(4, 4);
    dodgeWarning.cameras = [camOther];
    dodgeWarning.screenCenter();
    dodgeWarning.alpha = 0.001;
    dodgeWarning.scale.set(3, 3);
    dodgeWarning.x += 450;
    add(dodgeWarning);

    relapseIconLol = new HealthIcon('relapse2NEW-pixel', false);
    iconP2.scale.set(0.85, 0.85);
    relapseIconLol.y = iconP2.y;
    relapseIconLol.scale.set(0.85, 0.85);
    relapseIconLol.alpha = 0.0001;
    playHUD.add(relapseIconLol);

    camGame.fade(FlxColor.BLACK, 0.0001);
	camHUD.alpha = 0.001;

    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("opponentSwap", 10, 1);
}

function onUpdate(elapsed)
{
    relapseIconLol.x = iconP2.x;

    detectSpace(cpuControlled);
}

function onSongStart()
{
    modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
        var warningTxt = new FlxText(0, 0, 1280, "Use the SPACEBAR to dodge\nwhen you see this warning\nappear on your screen.\nGood Luck.", 0);
        warningTxt.setFormat(Paths.font("randomNameToGetPlaceHolderFont.ttf"), 32, FlxColor.WHITE, "center");
        warningTxt.alpha = 0.001;
        warningTxt.screenCenter();
        warningTxt.x -= 200;
        warningTxt.cameras = [camOther];
        add(warningTxt);
        for (i in [warningTxt, dodgeWarning])
        {
            FlxTween.tween(i, {alpha: 1}, 1.5, {onComplete: function(twn:FlxTween)
            {
                new FlxTimer().start(3.2, function(tmr:FlxTimer)
                {
                    FlxTween.tween(i, {alpha: 0.001}, 1.5, {onComplete: function(twn:FlxTween)
                    {
                        dodgeWarning.visible = false;
                        dodgeWarning.alpha = 1;
                    }});
                });
            }});
        }
    });

    // Intro Cam Shit
    modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
        camGame.fade(0x000000, 0.0001, true);
    });

    modManager.queueFuncOnce(46 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 0.8, {ease: FlxEase.circInOut});
    });

    modManager.queueFuncOnce(176 * 4, (s,s2)->{ 
        FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.sineOut});
        FlxTween.tween(relapseIconLol, {alpha: 1}, 1, {ease: FlxEase.sineOut});
        camGame.fade(FlxColor.RED, 1, true);
    });

    // Cam Shit and Lyrics for intro to Phase 2
    modManager.queueFuncOnce(366 * 4, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 0}, 1);
    });

    modManager.queueFuncOnce(381 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'You REALLY think this is...', 'freeplayDisneyFont.ttf', 30, 1.1, 'sineInOut');
    });

    modManager.queueFuncOnce(384 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...some kind of...', 'freeplayDisneyFont.ttf', 30, 1.4, 'sineInOut');
    });

    modManager.queueFuncOnce(388 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...silly little GAME?', 'freeplayDisneyFont.ttf', 30, 1.15, 'sineInOut');
    });

    modManager.queueFuncOnce(394 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'Soon enough...', 'freeplayDisneyFont.ttf', 30, 1.3, 'sineInOut');
    });

    modManager.queueFuncOnce(398 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', "...you'll understand what ME...", 'freeplayDisneyFont.ttf', 30, 1.5, 'sineInOut');
    });

    modManager.queueFuncOnce(404 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...AND MY FRIENDS...', 'freeplayDisneyFont.ttf', 30, 1.6, 'sineInOut');
    });

    modManager.queueFuncOnce(408 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...HAVE TO GO THROUGH!', 'freeplayDisneyFont.ttf', 30, 1.1, 'sineInOut');
    });

    modManager.queueFuncOnce(413 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'Sooner or later...', 'freeplayDisneyFont.ttf', 30, 1.1, 'sineInOut');
    });

    modManager.queueFuncOnce(417 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...your DEATH will be nothing...', 'freeplayDisneyFont.ttf', 30, 1.1, 'sineInOut');
    });

    modManager.queueFuncOnce(421 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', '...BUT CYCLED SINS!', 'freeplayDisneyFont.ttf', 30, 1.1, 'sineInOut');
    });

    modManager.queueFuncOnce(429 * 4, (s,s2)->{ 
        camGame.visible = false;
    });

    modManager.queueFuncOnce(432 * 4, (s,s2)->{ 
        camGame.visible = true;
        FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
    });

    modManager.queueFuncOnce(560 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'Why doesn\'t my torturous ways travail...', 'freeplayDisneyFont.ttf', 30, 5, 'sineInOut');
    });

    modManager.queueFuncOnce(576 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'I\'m mental, indisposed and ill...', 'freeplayDisneyFont.ttf', 30, 5, 'sineInOut');
    });

    modManager.queueFuncOnce(592 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'I\'m deranged, full of hatred...', 'freeplayDisneyFont.ttf', 30, 5, 'sineInOut');
    });

    modManager.queueFuncOnce(608 * 4, (s,s2)->{ 
        manageLyrics('relapse2NEW-pixel', 'This should\'ve been your termination... isn\'t it?', 'freeplayDisneyFont.ttf', 30, 5, 'sineInOut');
    });

    modManager.queueFuncOnce(632 * 4, (s,s2)->{ 
        sinsEnd = true;
    });
    
    if (ClientPrefs.mechanics)
    {
        // Phase 1 Section
        modManager.queueFuncOnce(174 * 4, (s,s2)->{ 
            relapseGimmick(0.7, 0.3);
        });
        
        for (i in [180, 196, 198, 254, 303])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.35, 0.15);
            });
        }

        for (i in [188, 204])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(1.4, 0.6);
            });
        }

        modManager.queueFuncOnce(206 * 4, (s,s2)->{ 
            relapseGimmick(0.7, 0.54);
        });

        modManager.queueFuncOnce(214 * 4, (s,s2)->{ 
            relapseGimmick(0.7, 0.8);
        });

        for (i in [228, 244])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.7, 1);
            });
        }

        for (i in [248, 262, 276])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(1.4, 1.2);
            });
        }

        for (i in [270, 294])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.7, 1.5);
            });
        }

        // Phase 2 Section
        for (i in [438, 540])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.35, 1, true);
            });
        }

        for (i in [453, 524])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.7, 1, true);
            });
        }

        for (i in [460, 498])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.7, 0.9);
            });
        }

        modManager.queueFuncOnce(471 * 4, (s,s2)->{ 
            relapseGimmick(0.35, 1.1);
        });

        for (i in [484, 503])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.35, 1.3);
            });
        }

        for (i in [494, 508])
        {
            modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                relapseGimmick(0.35, 1.3, true);
            });
        }
    }

    for (i in [400, 404, 408, 412, 416, 420, 424, 428])
    {
        modManager.queueFuncOnce(i * 4, (s,s2)->{ 
            camFlashSystem('flash', {alpha: 0.32, timer: 1.2, colors: [255, 0, 0]});
            FlxG.camera.zoom += 0.1;
        });
    }
}

function onSectionHit()
{
    if (camZooming)
    {
        FlxG.camera.zoom -= 0.015;
        camHUD.zoom -= 0.03;
    }
}

function relapseGimmick(reactionTime:Float = 2, damageAmount:Float = 0.4, ?doubleBarrel:Bool = false)
{
    dodged = false;
    shootin = true;
    FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Reload'), 0.4);
    dodgeWarning.visible = true;
    dad.specialAnim = true;
    FlxTween.color(dodgeWarning, reactionTime - 0.2, FlxColor.WHITE, (doubleBarrel ? FlxColor.YELLOW : FlxColor.RED));

    new FlxTimer().start(reactionTime, function(tmr:FlxTimer)
    {
        FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
        dad.playAnim("attack", true);
        dad.specialAnim = true;
        if (!doubleBarrel) dodgeWarning.visible = false;
        //checkCamPosition();
        new FlxTimer().start(0.1, function(tmr:FlxTimer)
        {
            if(dodged)
            {
                boyfriend.playAnim('dodge');
                health += 0.05;
            }
            else
            {
                FlxG.camera.shake(0.05, 0.05);
                health -= damageAmount;
            }

            if(doubleBarrel)
            {
                FlxTween.color(dodgeWarning, 0.12, FlxColor.YELLOW, FlxColor.RED);
                new FlxTimer().start(0.275, function(tmr:FlxTimer)
                {
                    dodgeWarning.visible = false;
                    FlxG.sound.play(Paths.sound('funkinAVI/relapseMechs/Shoot'), 0.4);
                    dad.playAnim("attack", true);
                    dad.specialAnim = true;
                    if(dodged)
                    {
                        boyfriend.playAnim('dodge');
                        health += 0.05;
                    }
                    else
                    {
                        FlxG.camera.shake(0.05, 0.05);
                        health -= damageAmount / 2;
                    }
                    dodged = false;
                    shootin = false;
                    dodgeWarning.color = FlxColor.WHITE;
                });
            }
            else
            {
                dodged = false;
                shootin = false;
                dodgeWarning.color = FlxColor.WHITE;
            }
        });
    });
}

var mercyTmr:FlxTimer;
var disabledDrain:Bool = false;
var initialCount:Int = 0;
function detectSpace(isAutoplay:Bool = false)
{
    if (!isAutoplay)
    {
        if (FlxG.keys.justPressed.SPACE)
        {
            if (shootin)
                dodged = true;
        }
    } 
    else 
    {
        if (shootin)
            dodged = true;
    }
}

function opponentNoteHit(note)
{
    if (sinsEnd && !note.isSustainNote)
    {
        var text:FlxText = new FlxText(-750, 490, 150, relapseEndNotes[0]);
        text.setFormat(Paths.font("freeplayDisneyFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        textGroup.add(text);
        FlxTween.tween(text, {x: text.x - FlxG.random.int(-150, 150), y: text.y - 700, alpha: 0, angle: FlxG.random.int(-20, 20)}, 2, {ease: FlxEase.sineOut});
        relapseEndNotes.shift();
    }
}