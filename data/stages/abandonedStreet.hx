import openfl.filters.ShaderFilter;
import flixel.addons.text.FlxTypeText;

enum FlashType
{
	BG_FLASH;
	BG_DARK;
	CAM_FLASH_FANCY;
}

typedef FlashingSettings = 
{
	/**
	* The visiblity of your background you want it to flash at
	*/
	@:optional var alpha:Float;

	/**
	* How long you want the fade out transition to take
	*/
	@:optional var timer:Float;

	/**
	* Fade out transition easing
	*/
	@:optional var ease:(t:Float)->Float;

	/**
	 * The array of the color values (RGB)
	 */
	 @:optional var colors:Array<Int>;
}

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');
var delusionalShift:FlxRuntimeShader = newShader('delusionalShift');
var heatWaveEffect:FlxRuntimeShader = newShader('heatWave');

var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null];

var floor:FlxSprite;
var stageCurtains:FlxSprite;
var rain:FlxSprite;
var fakeLightOfHope:FlxSprite;
var rainTween:FlxTween;
var pathway:String = 'Funkin_avi/stages/' + PlayState.SONG.stage + '/images/';

var tumbleWeed:FlxSprite;
var tumbleGrp:FlxTypedGroup;

var dumbCamTwn:FlxTween;

var camPosTween:FlxTween;

// Mickey being delusional and minnie appearing Scene For Delusional aaaa
var minnieBackground:FlxSprite; 
var totallyanoriginalname:FlxSprite; // .. i have no idea what to say

var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;
var chromTween:FlxTween;

var stageBGFlash:FlxSprite;
var BGFlashTween:FlxTween;

var blendFlash:FlxSprite;
var flashTween:FlxTween;

var lyricsIcon:HealthIcon;
var lyrics:FlxTypeText;
var lyricsTween:FlxTween;
var iconTween:FlxTween;

var drainValue:Float = 0;
var boundValue:Float = 0;

function onLoad()
{
    defaultCamZoom = 0.87;
    cameraSpeed = 1;
    
    floor = new FlxSprite(-500, -100).loadGraphic(Paths.image(pathway + 'street'));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    floor.scale.set(1.5, 1.5);
    floor.scrollFactor.set(1, 1);
    floor.active = false;
    add(floor);	

    if (PlayState.SONG.song == 'Delusional')
    {	
        fakeLightOfHope = new FlxSprite(-990, 1500).loadGraphic(Paths.image(pathway + 'falseHope'));
        fakeLightOfHope.setGraphicSize(Std.int(fakeLightOfHope.width * 4));
        fakeLightOfHope.updateHitbox();
        fakeLightOfHope.antialiasing = ClientPrefs.globalAntialiasing;
        fakeLightOfHope.screenCenter();
        fakeLightOfHope.scale.set(3, 3);
        fakeLightOfHope.scrollFactor.set(0.9, 0.9);
        add(fakeLightOfHope);
        
        // Bedroom Grah :fire: - MalyPlus
        minnieBackground = new FlxSprite(-20, 200).loadGraphic(Paths.image(pathway + 'background'));
        minnieBackground.scale.set(2,2);
        minnieBackground.scrollFactor.set(1, 1);
        minnieBackground.antialiasing = ClientPrefs.globalAntialiasing;
        minnieBackground.visible = false;
        add(minnieBackground);

        totallyanoriginalname = new FlxSprite(-20, 200).loadGraphic(Paths.image(pathway + 'shading'));
        totallyanoriginalname.scale.set(2,2);
        totallyanoriginalname.scrollFactor.set(1,1);
        totallyanoriginalname.visible = false;
        totallyanoriginalname.antialiasing = ClientPrefs.globalAntialiasing;
        add(totallyanoriginalname);
    }

    stageBGFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	stageBGFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
	stageBGFlash.alpha = 0.0001; // it's at this value so the game doesn't lag when it becomes visible
	stageBGFlash.x -= 750;
	stageBGFlash.y -= 450;
	stageBGFlash.scrollFactor.set();
	add(stageBGFlash);

    if(!ClientPrefs.lowQulity)
    {
        stageCurtains = new FlxSprite(0, 0).loadGraphic(Paths.image(pathway + 'i_forgor'));
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.screenCenter();
        stageCurtains.scale.set(1.3,1.3);
        stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
        stageCurtains.cameras = [camOther];
        stageCurtains.scrollFactor.set(1.3, 1.3);
        add(stageCurtains);
    }

    blendFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	blendFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
	blendFlash.alpha = 0.0001;
	blendFlash.blend = BlendMode.ADD;
	blendFlash.x -= 750;
	blendFlash.y -= 450;
	blendFlash.scrollFactor.set();
	add(blendFlash);
}

function onCreatePost()
{
    tumbleGrp = new FlxTypedGroup();
    add(tumbleGrp);
    
    if(!ClientPrefs.lowQulity)
    {
        rain = new FlxSprite(-550, -800);
        rain.frames = Paths.getSparrowAtlas(pathway + 'rain');
        rain.animation.addByPrefix('drippin', 'Rain', 30, true);
        rain.scale.set(2, 2);
        rain.antialiasing = ClientPrefs.globalAntialiasing;
        rain.alpha = 0.0001;
        rain.animation.play('drippin');
        add(rain);
    }

    // Hardcoded Icons
    if (PlayState.SONG.song == "Isolated")
    {
        demonBFIcon = new HealthIcon('evilcy', true);
        demonBFIcon.visible = false;
        playHUD.add(demonBFIcon);
    
        demonBFScary = new HealthIcon('evildelu', true);
        demonBFScary.visible = false;
        playHUD.add(demonBFScary);
    
        fakeBFLosingFrame = new HealthIcon('evilrett', true);
        fakeBFLosingFrame.visible = false;
        playHUD.add(fakeBFLosingFrame);
    
        isolatedHappy = new HealthIcon('lunaavier', false);
        isolatedHappy.visible = false;
        playHUD.add(isolatedHappy);
        
        lunacyIcon = new HealthIcon('lunaavier', false);
        lunacyIcon.visible = false;
        playHUD.add(lunacyIcon);
        
        delusionalIcon = new HealthIcon('deluavier', false);
        delusionalIcon.visible = false;
        playHUD.add(delusionalIcon);
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

    switch (PlayState.SONG.song)
    {
        case "Delusional":
            camGame.fade(FlxColor.BLACK, 0.0001);
        
            death = new FunkinVideoSprite(false);
            death.load(Paths.video("mickeyDeath"));
            death.cameras = [camHUD];
            death.alpha = 0.0001;
            death.onEnd(() -> {
                death.kill();
                death.destroy();
                death = null;
            });
            deluSing = new FunkinVideoSprite(false);
            deluSing.visible = false;
            deluSing.load(Paths.video("deluLyrics"), [FunkinVideoSprite.muted]);
            deluSing.cameras = [camHUD];
            deluSing.onEnd(() -> {
                deluSing.kill();
                deluSing.destroy();
                deluSing = null;
            });
            minnieJumpscare = new FunkinVideoSprite(false);
            minnieJumpscare.visible = false;
            minnieJumpscare.load(Paths.video("minniePart"), [FunkinVideoSprite.muted]);
            minnieJumpscare.cameras = [camHUD];
            minnieJumpscare.onEnd(() -> {
                minnieJumpscare.kill();
                minnieJumpscare.destroy();
                minnieJumpscare = null;
            });
            add(death);
            add(deluSing);
            add(minnieJumpscare);

            minnieJumpscare.zIndex = 4;

            playHUD.zIndex = 7;
            playFields.zIndex = 8;


        case 'Isolated', 'Lunacy':
            camGame.fade(FlxColor.BLACK, 0.0001);
            camHUD.alpha = 0.001;
    }
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
        if (PlayState.SONG.song == "Delusional")
        {
            delusionalShift.setFloat('iTime', shaderAnim);
            delusionalShift.setFloat('uTime', shaderAnim);
            heatWaveEffect.setFloat("iTime", shaderAnim);
        }
    }

    if (PlayState.SONG.song == "Isolated")
    {
        fakeBFLosingFrame.x = iconP1.x;
        demonBFIcon.x = iconP1.x;
        demonBFScary.x = iconP1.x;

        fakeBFLosingFrame.y = iconP1.y;
        demonBFIcon.y = iconP1.y;
        demonBFScary.y = iconP1.y;

        isolatedHappy.x = iconP2.x;
        lunacyIcon.x = iconP2.x;
        delusionalIcon.x = iconP2.x;

        isolatedHappy.y = iconP2.y;
        lunacyIcon.y = iconP2.y;
        delusionalIcon.y = iconP2.y;
    }
}

function onEndSong()
{
    if (PlayState.SONG.song == "Delusional" && isStoryMode && FlxG.save.data.episode1FPLock != 'unlocked')
    {
        FlxG.save.data.episode1FPLock = 'unlocked';
        FlxG.save.flush();
    }
}

function onSongStart()
{
    switch(PlayState.SONG.song)
    {    
        case "Isolated":
            modManager.queueFuncOnce(160 * 4, (s,s2)->{ 
                iconP2.alpha = 0;
                isolatedHappy.visible = true;
                FlxTween.tween(isolatedHappy, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(168 * 4, (s,s2)->{ 
                iconP2.alpha = 0;
                isolatedHappy.visible = true;
                FlxTween.tween(isolatedHappy, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(172 * 4, (s,s2)->{ 
                delusionalIcon.visible = true;
                iconP2.alpha = 0;
                FlxTween.tween(delusionalIcon, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(176 * 4, (s,s2)->{ 
                fakeBFLosingFrame.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(fakeBFLosingFrame, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(184 * 4, (s,s2)->{ 
                demonBFIcon.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(demonBFIcon, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(188 * 4, (s,s2)->{ 
                demonBFScary.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(demonBFScary, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);
            });

            modManager.queueFuncOnce(12 * 4, (s,s2)->{ 
                camGame.fade(FlxColor.BLACK, 3, true);
            });

            modManager.queueFuncOnce(30 * 4, (s,s2)->{ 
                FlxTween.tween(camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut});
            });

            modManager.queueFuncOnce(88 * 4, (s,s2)->{ 
                tweenCamera(1.4, 3, 'sineInOut');
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});
            });

            modManager.queueFuncOnce(96 * 4, (s,s2)->{ 
                defaultCamZoom = 0.85;
                tweenCamera(0.85, 0.4, 'expoOut');

                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1.5);
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35});
            });

            modManager.queueFuncOnce(160 * 4, (s,s2)->{ 
                tweenCamera(1.3, 2, 'sineInOut');
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.85, timer: 0.5, ease: FlxEase.quartOut});
            });

            modManager.queueFuncOnce(184 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.77, timer: 0.5, ease: FlxEase.quartOut});
            });

            modManager.queueFuncOnce(188 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.6, timer: 0.5, ease: FlxEase.quartOut});
            });

            modManager.queueFuncOnce(192 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1.5);
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.35, colors: [194, 194, 194]});
                
                defaultCamZoom = 1.25;
            });

            modManager.queueFuncOnce(220 * 4, (s,s2)->{ 
                tweenCamera(0.85, 2, 'sineInOut');
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.1, colors: [194, 194, 194]});
            });

            modManager.queueFuncOnce(288 * 4, (s,s2)->{ 
                defaultCamZoom = 0.85;

                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1.5);
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
            });

            modManager.queueFuncOnce(352 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.85, timer: 0.5, ease: FlxEase.quartOut});
                tweenCamera(1.07, 5, 'quadInOut');
                cameraSpeed -= 0.25;
            });

            modManager.queueFuncOnce(376 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 4, ease: FlxEase.quartInOut});
            });

            for (i in [36, 40, 44, 52, 56, 60, 64, 68, 72, 76, 80, 84, 92])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});
                });
            }

            for (i in [100, 104, 108, 116, 120, 124, 132, 136, 140, 148, 152, 156, 228, 232, 236, 240, 244, 252, 260, 264, 268, 276 |
                280, 284, 292, 296, 300, 308, 312, 316, 324, 328, 332, 340, 344, 348])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.2, timer: 0.35, colors: [194, 194, 194]});
                });
            }

            for (i in [98, 102, 106, 110, 114, 118, 122, 126, 130, 134, 138, 142, 146, 150, 154, 158, 226, 230, 234, 238, 242, 246 |
                250, 254, 258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318, 322, 326, 330, 334 |
                338, 342, 346, 350])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.55, timer: 0.35, colors: [194, 194, 194]});
                });
            }

            for (i in [194, 196, 198, 200, 202, 204, 206, 210, 212, 214, 222])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.35, colors: [194, 194, 194]});
                });
            }

            for (i in [216, 217, 218, 219])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.1, colors: [194, 194, 194]});
                    camHUD.zoom += 0.04;
                });
            }

            for (i in [128, 256])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
                });
            }

            for (i in [48, 336, 304, 272, 112, 144])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.BLACK, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});
                });
            }

            modManager.queueFuncOnce(32 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
            });

            modManager.queueFuncOnce(416 * 4, (s,s2)->{ 
                camGame.visible = false;
                camHUD.visible = false;
            });

            modManager.queueFuncOnce(224 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
                if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
            });

            modManager.queueFuncOnce(320 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
                if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
            });

        case "Lunacy":
            if (!ClientPrefs.lowQulity)
            {
                for (i in [228, 238, 244, 252, 260, 270, 276, 284, 292, 300, 308, 316, 324, 332, 340, 248])
                {
                    modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                        if (rainTween != null)
                            rainTween.cancel();
        
                        if (rain != null)
                            rainTween = FlxTween.tween(rain, {alpha: 0.5}, 0.35, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
                            {
                                rainTween = null;
                            }});
                    });
                }

                for (i in [230, 240, 248, 256, 262, 272, 280, 288, 296, 304, 312, 320, 328, 336, 344, 352])
                {
                    modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                        if (rainTween != null)
                            rainTween.cancel();

                        if (rain != null)
                            rainTween = FlxTween.tween(rain, {alpha: 0.0001}, 0.35, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
                                {
                                    rainTween = null;
                                }});
                    });
                }

                modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
                    if (rain != null) rain.alpha = 1;
                });
            }

            for (i in [100, 108, 116, 124, 132, 140, 148])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.5, timer: 0.5, ease: FlxEase.sineOut});
                });
            }

            for (i in [160, 230, 240, 248, 256, 262, 272, 280, 280, 288, 296, 304, 312, 320, 328, 336, 344, 352])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 0.5, ease: FlxEase.quadOut});
                });
            }

            for (i in [156, 228, 238, 244, 252, 260, 270, 276, 284, 292, 300, 308, 316, 324, 332, 340, 348])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.77, timer: 0.5, ease: FlxEase.quadOut});
                });
            }

            for (i in [424, 432, 440, 448, 456, 464, 472])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.65, timer: 0.6, ease: FlxEase.sineOut});
                });
            }

            for (i in [32, 64])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
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
                });
            }

            for (i in [38, 40, 46, 48, 54, 56, 62, 70, 72, 78, 80, 86, 88, 102, 110, 118, 126, 134, 142, 150])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.12;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 0.3, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [96, 104, 112, 120, 128, 136, 144, 152])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.32;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 2.1, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [100, 108, 116, 124, 132, 140, 148])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.4;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 1, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            modManager.queueFuncOnce(156 * 4, (s,s2)->{ 
                if (chromTween != null)
                    chromTween.cancel();

                chromTween = FlxTween.num(chromEffect, 0.33, 0.2, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            });

            modManager.queueFuncOnce(158 * 4, (s,s2)->{ 
                if (chromTween != null)
                    chromTween.cancel();

                chromEffect = 0.4;

                chromTween = FlxTween.num(chromEffect, 0.0001, 0.2, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            });

            for (i in [160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248, 256, 264, 272, 280, 288, 296, 304, 312, 320, 328, 336, 344])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.55;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 0.6, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [162, 170, 178, 186, 194, 202, 210, 218, 226, 234, 242, 250, 258, 266, 274, 282, 290, 298, 306, 314, 322, 330, 338, 346])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.6;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 0.25, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [163, 171, 179, 187, 195, 203, 211, 219, 227, 235, 243, 251, 259, 267, 275, 283, 291, 299, 307, 315, 323, 331, 339, 347])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromTween = FlxTween.num(chromEffect, 0.5, 0.22, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                            chromEffect = 0.00001;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [165, 173, 181, 189, 197, 205, 213, 221])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromTween = FlxTween.num(chromEffect, 0.35, 0.2, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                            chromEffect = 0.00001;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [166, 174, 182, 190, 198, 206, 214, 222])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.45;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 0.2, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [167, 175, 183, 191, 199, 207, 215, 223])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.56;

                    chromTween = FlxTween.num(chromEffect, 0.0001, 0.2, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            for (i in [352, 354, 356, 358, 360, 362, 364, 366, 368, 370, 372, 374, 376, 378, 380, 
                    382, 384, 386, 388, 390, 392, 394, 396, 398, 400, 402, 404, 406, 408, 410, 
                    416, 418, 420, 422, 424, 426, 428, 430, 432, 434, 436, 438, 440, 442, 444, 
                    446, 448, 450, 452, 454, 456, 458, 460, 462, 464, 466, 468, 470, 472, 474])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (chromTween != null)
                        chromTween.cancel();

                    chromEffect = 0.3;

                    chromTween = FlxTween.num(chromEffect, 0.00001, 0.5, {
                        ease: FlxEase.sineOut,
                        onComplete: function(twn:FlxTween)
                        {
                            chromTween = null;
                        }
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                });
            }

            modManager.queueFuncOnce(412 * 4, (s,s2)->{ 
                if (chromTween != null)
                    chromTween.cancel();

                chromEffect = 0.36;

                chromTween = FlxTween.num(chromEffect, 0.00001, 1, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            });

            modManager.queueFuncOnce(476 * 4, (s,s2)->{ 
                if (chromTween != null)
                    chromTween.cancel();

                chromTween = FlxTween.num(chromEffect, 0.85, 1.6, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            });

            modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
                chromTween.cancel();

                chromEffect = 0.00001;
            });

            modManager.queueFuncOnce(16 * 4, (s,s2)->{ 
                camGame.fade(FlxColor.BLACK, 3, true);
            });

            modManager.queueFuncOnce(32 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing) camGame.flash(FlxColor.BLACK, 1.5);
                tweenCamera(camGame.zoom + .5, 16.5, 'sineInOut');
            });

            modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.BLACK, 0.9);
            });

            modManager.queueFuncOnce(88 * 4, (s,s2)->{ 
                tweenCamera(.75, 2.2, 'sineInOut');

                FlxTween.tween(camHUD, {alpha: 1}, 5, {ease: FlxEase.sineOut});
            });

            modManager.queueFuncOnce(96 * 4, (s,s2)->{ 
                defaultCamZoom = 0.75;
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1.5);
            });

            for (i in [128, 256])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
                });
            }

            modManager.queueFuncOnce(156 * 4, (s,s2)->{ 
                defaultCamZoom = 1.05;
            });

            modManager.queueFuncOnce(160 * 4, (s,s2)->{ 
                boundValue = 1.25;
                drainValue = 0.015;
                defaultCamZoom = 0.7;
                if (ClientPrefs.flashing) camGame.flash(FlxColor.BLACK, 1.5);
            });

            modManager.queueFuncOnce(192 * 4, (s,s2)->{ 
                defaultCamZoom = 0.75;
            });

            for (i in [200, 238, 270, 316, 332, 344])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.8;
                });
            }

            modManager.queueFuncOnce(208 * 4, (s,s2)->{ 
                defaultCamZoom = 0.85;
            });

            for (i in [216, 252, 284])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.9;
                });
            }

            modManager.queueFuncOnce(220 * 4, (s,s2)->{ 
                defaultCamZoom = 0.95;
            });

            for (i in [222, 267, 239, 271, 334])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 1;
                });
            }

            for (i in [224, 288])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.75;
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    FlxTween.tween(camHUD, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
                });
            }

            for (i in [228, 260, 292, 286])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 1.1;
                });
            }

            for (i in [230, 262, 296, 312, 236, 268])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.65;
                });
            }

            for (i in [232, 264])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    defaultCamZoom = 0.7;
                });
            }

            for (i in [412, 240, 272, 300, 304, 336, 248, 280, 328])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.7;
                });
            }

            modManager.queueFuncOnce(320 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1.5);
                defaultCamZoom = 0.7;
            });

            modManager.queueFuncOnce(254 * 4, (s,s2)->{ 
                defaultCamZoom = 1.1;
                FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(318 * 4, (s,s2)->{ 
                defaultCamZoom = 1.25;
                FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
            });

            for (i in [310, 342, 350])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 1.25;
                });
            }

            modManager.queueFuncOnce(352 * 4, (s,s2)->{ 
                defaultCamZoom = 0.65;
                FlxTween.tween(camHUD, {alpha: 0.25}, 8, {ease: FlxEase.sineInOut});
                FlxTween.num(health, 0.01, 20, null, shitshitfuckfuck -> health = shitshitfuckfuck);

                if (globalGradient != null)
                    FlxTween.tween(globalGradient, {alpha: 0.8}, 10);
                FlxTween.tween(FlxG.camera, {zoom: 1.1}, 18, {startDelay: 2});
            });

            modManager.queueFuncOnce(408 * 4, (s,s2)->{ 
                defaultCamZoom = 0.9;
                FlxTween.tween(camHUD, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(416 * 4, (s,s2)->{ 
                if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
            });

            modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
                boundValue = 1;
                drainValue = 0.02;
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.BLACK, 1.5);
                camHUD.alpha = 0;
            });

            modManager.queueFuncOnce(481 * 4, (s,s2)->{ 
                camFollow.x += 100;
            });

            modManager.queueFuncOnce(506 * 4, (s,s2)->{ 
                FlxTween.tween(camHUD, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(536 * 4, (s,s2)->{ 
                FlxTween.tween(camHUD, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(540 * 4, (s,s2)->{ 
                camGame.fade(FlxColor.BLACK, 5);
            });
        case "Delusional":
            modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
                if (rain != null) rain.alpha = 1;
            });

            modManager.queueFuncOnce(64 * 4, (s,s2)->{ 
                FlxTween.tween(fakeLightOfHope, {alpha: 0.001}, 1.7);
            });

            modManager.queueFuncOnce(474 * 4, (s,s2)->{
                
                floor.alpha = 0.0001;
                if (rain != null) rain.alpha = 0;
                if (!ClientPrefs.lowQulity)
                {
                    totallyanoriginalname.visible = true;
                    stageCurtains.visible = false;
                }
                minnieBackground.visible = true;
            });

            if (!ClientPrefs.lowQulity)
            {
                modManager.queueFuncOnce(679 * 4, (s,s2)->{ 
                    stageCurtains.alpha = 0.0001;
                    stageCurtains.visible = true;
                });
            }

            for (i in [680, 688, 696, 700, 704, 712, 720])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    if (!ClientPrefs.lowQulity)
                    {
                        stageCurtains.alpha = 1;
                        FlxTween.tween(stageCurtains, {alpha: 0}, 1, {ease: FlxEase.circOut});
                    }
                });
            }

            modManager.queueFuncOnce(728 * 4, (s,s2)->{ 
                if (!ClientPrefs.lowQuality)
                    FlxTween.tween(stageCurtains, {alpha: 1}, 5);
            });

            modManager.queueFuncOnce(740 * 4, (s,s2)->{ 
                if (!ClientPrefs.lowQulity)
                {
                    totallyanoriginalname.kill();
                    totallyanoriginalname.destroy();
                    totallyanoriginalname = null;
                }
                minnieBackground.kill();
                minnieBackground.destroy();
                minnieBackground = null;
                if (rain != null) rain.alpha = 1;
                
                floor.alpha = 1;
            });

            modManager.queueFuncOnce(146 * 4, (s,s2)->{ 
                manageLyrics('evildelu', 'Count the minutes...', 'disneyFreeplayFont.ttf', 30, 1.1, 'sineInOut', .05);
            });

            modManager.queueFuncOnce(150 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...of how long...", 'disneyFreeplayFont.ttf', 30, 1, 'sineInOut', 0.04);
            });

            modManager.queueFuncOnce(154 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...this show will play!", 'disneyFreeplayFont.ttf', 30, 2.2, 'quartInOut', .07);
            });

            modManager.queueFuncOnce(162 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "And remind yourself...", 'disneyFreeplayFont.ttf', 30, 1.3, 'sineInOut', .05);
            });

            modManager.queueFuncOnce(167 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...no matter what's in...", 'disneyFreeplayFont.ttf', 30, 2, 'sineInOut', .06);
            });

            modManager.queueFuncOnce(174 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...THE WAY!", 'disneyFreeplayFont.ttf', 30, 1, 'circOut', .035);
            });

            modManager.queueFuncOnce(178 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "All your dreams...", 'disneyFreeplayFont.ttf', 30, 1, 'sineInOut', .04);
            });

            modManager.queueFuncOnce(182 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...ARE SO FAR OUT OF REACH!", 'disneyFreeplayFont.ttf', 30, 4, 'quartInOut', .055);
            });

            modManager.queueFuncOnce(190 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "But if YOUR delusions...", 'disneyFreeplayFont.ttf', 30, 2.2, 'sineInOut', .045);
            });

            modManager.queueFuncOnce(196 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "...loops around then...", 'disneyFreeplayFont.ttf', 30, 1.3, "quartOut", .045);
            });

            modManager.queueFuncOnce(200 * 4, (s,s2)->{ 
                manageLyrics('evildelu', "Let's LOOP 'ROUND ONCE MORE.", 'disneyFreeplayFont.ttf', 30, 3, "sineInOut", .065);
            });

            modManager.queueFuncOnce(1 * 4, (s,s2)->{ 
                cinematicBarControls("create", 1);

                boundValue = 1;
                drainValue = 0.02;
                camGame.fade(FlxColor.BLACK, 2, true);
            });

            modManager.queueFuncOnce(470 * 4, (s,s2)->{ 
                cinematicBarControls("moveboth", 0.65, 'backIn', 380);
            });

            modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
                cinematicBarControls("moveboth", 10, 'linear', 70);
            });

            modManager.queueFuncOnce(672 * 4, (s,s2)->{ 
                cinematicBarControls("moveboth", 1, "circOut", 0);
            });

            modManager.queueFuncOnce(132 * 4, (s,s2)->{ 
                defaultCamZoom = 1.3;
                modManager.queueEase(136 * 4, 148 * 4, "alpha", 1, "linear");

                deluSing.play();
                deluSing.pause();
            });

            modManager.queueFuncOnce(136 * 4, (s,s2)->{ 
                camGame.fade(FlxColor.BLACK, 0.6);
                camHUD.fade(FlxColor.BLACK, 1.75);
            });

            modManager.queueFuncOnce(143 * 4, (s,s2)->{ 
                playHUD.alpha = 0;
                camHUD.fade(FlxColor.BLACK, 5, true);
                deluSing.resume();
                deluSing.visible = true;
                if (vocals.volume != 1) vocals.volume = 1; // it should be fixed then
            });

            modManager.queueFuncOnce(144 * 4, (s,s2)->{ 
                defaultCamZoom = 0.8;
                camGame.fade(0x000000, 5, true);
                camFlashSystem(FlashType.BG_DARK, {alpha: 1, timer: 0.3, ease: FlxEase.quartInOut});
                defaultCamZoom = 1.2;
                camFollow.x -= 100;
                FlxTween.tween(camFollow, {x: camFollow.x + 100}, 12, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(176 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 0.3, ease: FlxEase.quartInOut});
                defaultCamZoom = 0.75;
                camGame.flash(FlxColor.WHITE, 1);

                // today in super r slur shit we have this cus i hate my life
                FlxTween.tween(camFollow, {y: camFollow.y - 300}, .00000001, {onComplete: bensonFromRegularShow -> {
                    FlxTween.tween(camFollow, {y: camFollow.y + 300}, 7, {ease: FlxEase.sineInOut});
                }});
            });

            for (i in [180, 188, 196])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camGame.zoom += 0.3;
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.5, timer: 0.35});
                });
            }

            for (i in [184, 192, 200])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camGame.zoom += 0.15;
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.25, timer: 0.35});
                });
            }

            modManager.queueFuncOnce(204 * 4, (s,s2)->{ 
                defaultCamZoom = 1;
            });

            modManager.queueFuncOnce(208 * 4, (s,s2)->{ 
                camGame.fade(FlxColor.BLACK, .000001);
                defaultCamZoom = 1.3;
                modManager.queueEase(216 * 4, 220 * 4, "alpha", 0, "linear");
            });

            // Mickey Screams Like A Bitch
            modManager.queueFuncOnce(212 * 4, (s,s2)->{ 
                boundValue = 0.6;
                drainValue = 0.025;
                chromEffect = 0.3;
                chromTween = FlxTween.num(chromEffect, 1, 1.2, {
                    ease: FlxEase.sineOut
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);

                camGame.fade(FlxColor.BLACK, .000001, true);
                defaultCamZoom = 0.75;
                camGame.shake(0.01, 1.2);
            });
            // The Drop Starts
            modManager.queueFuncOnce(216 * 4, (s,s2)->{ 
                FlxTween.tween(playHUD, {alpha: 1}, 1, {ease: FlxEase.quadOut});
                if (chromTween != null) 
                    chromTween.cancel();
                
                chromTween = FlxTween.num(chromEffect, 0.18, 0.6, {
                    ease: FlxEase.sineOut
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);

                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 0.5);
                if (ClientPrefs.shaders)
                {
                    if (!ClientPrefs.lowQuality)
                    {
                        camGame.filters = ([
                            new ShaderFilter(dramaticCamMovement),
                            new ShaderFilter(monitorFilter),
                            new ShaderFilter(chromZoomShader),
                            new ShaderFilter(chromNormalShader),
                            new ShaderFilter(delusionalShift)
                        ]);
                        camHUD.filters = ([
                            new ShaderFilter(chromNormalShader),
                            new ShaderFilter(delusionalShift)
                        ]);
                    }
                    else
                    {
                        camGame.filters = ([
                            new ShaderFilter(monitorFilter),
                            new ShaderFilter(chromZoomShader),
                            new ShaderFilter(chromNormalShader),
                            new ShaderFilter(delusionalShift)
                        ]);
                        camHUD.filters = ([
                            new ShaderFilter(chromNormalShader), 
                            new ShaderFilter(delusionalShift)
                        ]);
                    }
                }
            });

            modManager.queueFuncOnce(228 * 4, (s,s2)->{ 
                chromTween = null;
                defaultCamZoom = 0.85;
            });

            modManager.queueFuncOnce(230 * 4, (s,s2)->{ 
                defaultCamZoom = 1;
            });

            modManager.queueFuncOnce(232 * 4, (s,s2)->{ 
                defaultCamZoom = 0.75;
            });

            modManager.queueFuncOnce(278 * 4, (s,s2)->{ 
                defaultCamZoom = 1;
            });

            for (i in [280, 312, 344])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 0.7;
                });
            }

            for (i in [288, 296, 304, 320, 328, 336])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom += 0.1;
                });
            }

            modManager.queueFuncOnce(308 * 4, (s,s2)->{ 
                defaultCamZoom += 0.2;
            });

            modManager.queueFuncOnce(340 * 4, (s,s2)->{ 
                defaultCamZoom += 0.3;
            });

            for (i in [356, 388])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 1.2;
                });
            }

            for (i in [358, 390])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    defaultCamZoom = 1.3;
                });
            }

            modManager.queueFuncOnce(360 * 4, (s,s2)->{ 
                defaultCamZoom = 0.75;
            });

            modManager.queueFuncOnce(375 * 4, (s,s2)->{ 
                chromTween = FlxTween.num(chromEffect, 1, 0.1, {
                    ease: FlxEase.sineInOut
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);

                tweenCamera(1.5, 0.1, 'sineInOut');
            });

            modManager.queueFuncOnce(376 * 4, (s,s2)->{ 
                if (chromTween != null) chromTween.cancel();
                    chromTween = null;
                camGame.visible = false;

                playHUD.alpha = 0;
            });

            modManager.queueFuncOnce(377 * 4, (s,s2)->{ 
                camGame.visible = true;
                playHUD.alpha = 1;
                modManager.setValue("alpha", 0);
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 1);
                defaultCamZoom = 0.8;
                
                chromTween = FlxTween.num(chromEffect, 0.1, 0.6, {
                    ease: FlxEase.quadOut
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            });

            modManager.queueFuncOnce(472 * 4, (s,s2)->{ 
                boundValue = 2;
                drainValue = 0;
                camGame.visible = false;
                playHUD.alpha = 0;
                modManager.setValue("alpha", 1);
            });

            modManager.queueFuncOnce(473 * 4, (s,s2)->{ 
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
                            new ShaderFilter(chromZoomShader),
                            new ShaderFilter(chromNormalShader)
                        ]);
                        camHUD.filters = ([new ShaderFilter(chromNormalShader)]);
                    }
                }
                chromEffect = 0.00001;
                defaultCamZoom = 0.85;
            });

            modManager.queueFuncOnce(1912, (s,s2)->{ 
                camFollow.x = 630;
                camFollow.y = 750;
                isCameraOnForcedPos = true;
                defaultCamZoom = 0.5;
                boyfriend.cameras = [camHUD];
                boyfriend.zIndex = 3;

                playHUD.alpha = 0;
                modManager.setValue("alpha", 1, 0);
                modManager.setValue("alpha", 1, 1);

                boyfriend.alpha = 0.0001;
            });

            modManager.queueFuncOnce(480 * 4, (s,s2)->{ 
                // no healthbar to add more onto the atmosphere of this section
                camGame.visible = true;
                modManager.setValue("alpha", 0, 0);
            });

            modManager.queueFuncOnce(508 * 4, (s,s2)->{ 
                FlxTween.tween(boyfriend, {alpha: 0.45}, 2.5, {ease: FlxEase.expoOut});
            });

            modManager.queueFuncOnce(671 * 4, (s,s2)->{ 
                minnieJumpscare.play();
                minnieJumpscare.pause();
            });

            modManager.queueFuncOnce(672 * 4, (s,s2)->{ 
                blendFlash.cameras = [camGame];
                boyfriend.alpha = 0.0001;
                camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.38, timer: 0.85, colors: [255, 255, 255]});
                minnieJumpscare.resume();
                minnieJumpscare.visible = true;
            });

            modManager.queueFuncOnce(720 * 4, (s,s2)->{ 
                FlxTween.tween(camGame, {alpha: 0.0001}, 5, {ease: FlxEase.quartInOut});
            });

            modManager.queueFuncOnce(736 * 4, (s,s2)->{ 
                blendFlash.cameras = [camGame];
            });

            modManager.queueFuncOnce(740 * 4, (s,s2)->{ 
                isCameraOnForcedPos = false;
                boundValue = 0.45;
                drainValue = 0.032;
                boyfriend.alpha = 1;
                camFollow.x = 0;
                camFollow.y = 0;
            });

            modManager.queueFuncOnce(744 * 4, (s,s2)->{ 
                camGame.alpha = 1;
                playHUD.alpha = 1;
                modManager.setValue("alpha", 0);
                defaultCamZoom = 0.9;
                chromEffect = 0.1;
                if (ClientPrefs.flashing)
                    camGame.flash(FlxColor.WHITE, 0.5);
                if (ClientPrefs.shaders)
                {
                    if (!ClientPrefs.lowQuality)
                    {
                        camGame.filters = ([
                            new ShaderFilter(dramaticCamMovement),
                            new ShaderFilter(heatWaveEffect),
                            new ShaderFilter(monitorFilter),
                            new ShaderFilter(chromZoomShader),
                            new ShaderFilter(chromNormalShader),
                            new ShaderFilter(delusionalShift)
                        ]);
                        
                        camHUD.filters = ([ 
                            new ShaderFilter(chromNormalShader), 
                            new ShaderFilter(delusionalShift)
                        ]);
                    }
                    else
                    {
                        camGame.filters = ([
                            new ShaderFilter(monitorFilter),
                            new ShaderFilter(chromZoomShader),
                            new ShaderFilter(chromNormalShader),
                            new ShaderFilter(delusionalShift)
                        ]);
                        camHUD.filters = ([ 
                            new ShaderFilter(chromNormalShader), 
                            new ShaderFilter(delusionalShift)
                        ]);
                    }
                }
            });

            for (i in [880, 884, 888, 892, 896, 900, 904, 908, 913, 916, 920, 924, 929, 933, 936, 940, 944, 948, 952, 956, 960, 964, 968, 972, 976, 980, 984, 988, 993, 997, 1000, 1004])
            {
                modManager.queueFuncOnce(i * 4, (s,s2)->{ 
                    camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.135, timer: 0.85, colors: [255, 0, 0]});
                });
            }

            // The part where shit gets serious, Evilrette/Satan starts the solo
            modManager.queueFuncOnce(1008 * 4, (s,s2)->{ 
                boundValue = 1.5;
                drainValue = 0.01;
                tweenCamera(1.35, 7, "quartInOut");
                camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.4, timer: 2, colors: [255, 0, 0]});
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.8, timer: 6, ease: FlxEase.quartInOut});
                isCameraOnForcedPos = true;
                camPosTween = FlxTween.tween(camFollow, {x: camFollow.x + 150, y: camFollow.y + 50}, 4.3, {ease: FlxEase.quartInOut});
            });
            // camera moves over to Mickey realizing he was never gonna win
            modManager.queueFuncOnce(1024 * 4, (s,s2)->{ 
                if (camPosTween != null)
                    camPosTween.cancel();
                    
                camPosTween = FlxTween.tween(camFollow, {x: camFollow.x - 750, y: camFollow.y - 70}, 1.5, {ease: FlxEase.circInOut});
            });

            modManager.queueFuncOnce(1040 * 4, (s,s2)->{ 
                camFollow.x = 440;
                camFollow.y = 360;
                defaultCamZoom = 0.5;
                camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 1, ease: FlxEase.circOut});
            });

            modManager.queueFuncOnce(1072 * 4, (s,s2)->{ 
                isCameraOnForcedPos = false;
                defaultCamZoom = 0.9;
                death.play();
                death.pause();
                modManager.queueEase(1082 * 4, 1086 * 4, "alpha", 1, "sineInOut");
            });

            modManager.queueFuncOnce(1082 * 4, (s,s2)->{ 
                FlxTween.tween(camGame, {zoom: 1.6}, 1, {ease: FlxEase.sineInOut});
                camGame.fade(FlxColor.BLACK, 0.7);
                FlxTween.tween(playHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(1086 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_DARK, {timer: 5});

                death.seekTo(0);
                death.resume();

                if (ClientPrefs.shaders)
                {
                    camHUD.filters = ([
                        new ShaderFilter(chromNormalShader), 
                        new ShaderFilter(delusionalShift)
                    ]);
                }

                FlxTween.tween(death, {alpha: 1}, 0.2, {ease: FlxEase.sineInOut});
            });

            modManager.queueFuncOnce(1136 * 4, (s,s2)->{ 
                camFlashSystem(FlashType.BG_FLASH, {alpha: 1, timer: 0.3, ease: FlxEase.sineOut});
                if (ClientPrefs.shaders)
                {
                    if (!ClientPrefs.lowQuality)
                    {
                        camGame.filters = ([
                            new ShaderFilter(dramaticCamMovement),
                            new ShaderFilter(monitorFilter)
                        ]);
                    }
                    else
                    {
                        camGame.filters = ([
                            new ShaderFilter(monitorFilter)
                        ]);
                    }
                }
            });

            modManager.queueFuncOnce(1144 * 4, (s,s2)->{ 
                 FlxTween.tween(camHUD, {alpha: 0}, 4);
            });
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
    
    switch (PlayState.SONG.song)
    {
        case 'Isolated':
            if ((curBeat > 96 && curBeat < 160) || (curBeat > 224 && curBeat < 352))
            {
                if (curBeat % 2 == 0)
                {
                    camGame.zoom += 0.05;
                    camHUD.zoom += 0.06;
                }
            }
        
        case 'Lunacy':
            if (curBeat >= 228 && curBeat <= 231 || curBeat >= 236 && curBeat <= 239 || curBeat >= 244 && curBeat <= 247 || curBeat >= 252
                && curBeat <= 255 || curBeat >= 260 && curBeat <= 263 || curBeat >= 168 && curBeat <= 171 || curBeat >= 276 && curBeat <= 279
                || curBeat >= 284 && curBeat <= 287 || curBeat >= 292 && curBeat <= 295 || curBeat >= 300 && curBeat <= 303 || curBeat >= 308
                && curBeat <= 311 || curBeat >= 316 && curBeat <= 319 || curBeat >= 324 && curBeat <= 327 || curBeat >= 332 && curBeat <= 335
                || curBeat >= 340 && curBeat <= 343 || curBeat >= 348 && curBeat <= 351)
            {
                if (chromTween != null)
                    chromTween.cancel();

                chromEffect = 0.32;

                chromTween = FlxTween.num(chromEffect, 0.0001, 0.22, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            }

        case 'Delusional':
            if ((curBeat >= 216 && curBeat < 340) || (curBeat >= 344 && curBeat < 356) || (curBeat >= 360 && curBeat < 388) || (curBeat >= 392 && curBeat < 408) || (curBeat >= 880 && curBeat < 1072))
            {
                FlxG.camera.zoom += 0.015;
                camHUD.zoom += 0.03;
            }

    }
}

function summonWeedMakerLmfao()
{
    tumbleWeed = new FlxSprite(1800, 700);
    tumbleWeed.antialiasing = ClientPrefs.globalAntialiasing;
    var velocityX:Float = 0;
    var bounceVal:Int = 835;
    var loopTime:Array<Float> = [];
    if (FlxG.random.bool(1))
    {
        tumbleWeed.loadGraphic(Paths.image(pathway + 'THELEGENDARYTUMBLEWEED'));
        tumbleWeed.scale.set(0.6, 0.6);
        velocityX = -1270;
        bounceVal = 50;
        loopTime[0] = 0.5;
        loopTime[1] = 0.1;
        loopTime[2] = 4;
    }
    else
    {
        tumbleWeed.loadGraphic(Paths.image(pathway + 'Tumble_' + FlxG.random.int(0,1)));
        velocityX = -520;
        loopTime[0] = 1.7;
        loopTime[1] = 0.75;
        loopTime[2] = 5.6;
    }
    tumbleWeed.velocity.set(velocityX, 0);
    tumbleGrp.add(tumbleWeed);
    FlxTween.tween(tumbleWeed, {angle: -360}, loopTime[0], {type: 2});
    FlxTween.tween(tumbleWeed, {y: bounceVal}, loopTime[1], {ease: FlxEase.sineInOut, type: 4});
    new FlxTimer().start(loopTime[2], function(tmr:FlxTimer)
    {
        tumbleWeed.kill();
        tumbleWeed = null;
    });
}

function camFlashSystem(flashType:FlashType, settings:FlashingSettings)
{
    // null checkes
    if (settings.colors == null) settings.colors = [255, 255, 255];
    if (settings.timer == null) settings.timer = 3;
    if (settings.ease == null) settings.ease = FlxEase.linear;
    if (settings.alpha == null) settings.alpha = .5;

    // due to the fact that some silly 19 year old guy called demo overuses the shit
    // out of the zooms this has to exist in cases of emergency   - jason the silly !!
    // stageBGFlash.setPosition(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom);

    if (ClientPrefs.flashing && stageBGFlash != null)
    {
        switch (flashType)
        {
            case FlashType.BG_FLASH:
                if (settings.alpha > 1 || settings.alpha < 0) // prevents a crash from making a dumb mistake
                    stageBGFlash.alpha = 0.5;
                else
                    stageBGFlash.alpha = settings.alpha;

                if (settings.timer <= 0) // another check to prevent a crash
                    settings.timer = 1;

                if (settings.colors[0] == 0 && settings.colors[1] == 0 && settings.colors[2] == 0) // blend check cause it makes it look cool
                    stageBGFlash.blend = BlendMode.NORMAL;
                else
                    stageBGFlash.blend = BlendMode.ADD;

                stageBGFlash.color = FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2], 255);

                if (BGFlashTween != null) // makes it so it won't look wonky, visually
                    BGFlashTween.cancel();

                BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: 0}, settings.timer, {
                    ease: settings.ease,
                    onComplete: function(twn:FlxTween)
                    {
                        BGFlashTween = null;
                    }
                });

            case FlashType.BG_DARK:
                if (stageBGFlash != null)
                {
                    if (BGFlashTween != null)
                        BGFlashTween.cancel();

                    if (stageBGFlash.blend != BlendMode.NORMAL)
                        stageBGFlash.blend = BlendMode.NORMAL;

                    if (settings.timer <= 0)
                        settings.timer = 1;

                    stageBGFlash.color = FlxColor.BLACK; // hardcoded to be black

                    BGFlashTween = FlxTween.tween(stageBGFlash, {alpha: settings.alpha}, settings.timer, {
                        ease: settings.ease,
                        onComplete: function(twn:FlxTween)
                        {
                            BGFlashTween = null;
                        }
                    });
                }
            
            case FlashType.CAM_FLASH_FANCY:
                if (blendFlash != null)
                {
                    if (settings.alpha > 1 || settings.alpha < 0) // prevents a crash from making a dumb mistake
                        blendFlash.alpha = 0.5;
                    else
                        blendFlash.alpha = settings.alpha;

                    if (settings.timer <= 0) // another check to prevent a crash
                        settings.timer = 1;

                    if (settings.colors[0] == 0 && settings.colors[1] == 0 && settings.colors[2] == 0) // turn it to white, cause I can
                        blendFlash.blend = BlendMode.NORMAL;
                    else
                        blendFlash.blend = BlendMode.ADD;

                    if (flashTween != null)
                        flashTween.cancel();

                    blendFlash.color = FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2], 255);

                    flashTween = FlxTween.tween(blendFlash, {alpha: 0}, settings.timer, {
                        ease: settings.ease,
                        onComplete: function(twn:FlxTween)
                        {
                            flashTween = null;
                        }
                    });
                }
        }
    }
}

function tweenCamera(zoom:Float = 0.9, time:Float = 0.6, ease:Null<String>):Void
{
    if (dumbCamTwn != null)
        dumbCamTwn.cancel();
    
    dumbCamTwn = FlxTween.tween(camGame, {zoom: zoom}, time, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
    {
        defaultCamZoom = zoom;
        dumbCamTwn = null;
    }});
}

function manageLyrics(icon:String = 'bf', text:String = 'swaggers', font:String = 'vcr', size:Int = 15, duration:Float = 5, tweenType:String = 'linear', textDelay:Float = 0.03)
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
                cinematicBars["top"].zIndex = 5;
				cinematicBars["top"].cameras = [camHUD];
				cinematicBars["top"].y = 0 - cinematicBars["top"].height; // offscreen
				add(cinematicBars["top"]);
			}

			if (cinematicBars["bottom"] == null)
			{
				cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				cinematicBars["bottom"].screenCenter(FlxAxes.X);
                cinematicBars["bottom"].zIndex = 6;
				cinematicBars["bottom"].cameras = [camHUD];
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

function opponentNoteHit(note)
{
    switch (PlayState.SONG.song)
    {  
        case 'Lunacy', 'Delusional':
            if (ClientPrefs.mechanics)
                if (health > boundValue)
                    health -= drainValue;
    }
}