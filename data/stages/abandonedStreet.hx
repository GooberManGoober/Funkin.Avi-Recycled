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

var grayScale:FlxRuntimeShader = newShader('grayScale');
var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');
var delusionalShift:FlxRuntimeShader = newShader('delusionalShift');
var heatWaveEffect:FlxRuntimeShader = newShader('heatWave');

var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null];

var colorsOrSmthElse:FlxSprite;
var floor:FlxSprite;
var stageCurtains:FlxSprite;
var rain:FlxSprite;
var fakeLightOfHope:FlxSprite;
var rainTween:FlxTween;
var pathway:String = 'favi/stages/' + PlayState.SONG.stage + '/images/';

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
    
    colorsOrSmthElse = new FlxSprite(-500, -100).loadGraphic(Paths.image(pathway + 'bg'));
    colorsOrSmthElse.antialiasing = ClientPrefs.globalAntialiasing;
    colorsOrSmthElse.scale.set(1.2, 1.2);
    add(colorsOrSmthElse);

    floor = new FlxSprite(-500, -100).loadGraphic(Paths.image(pathway + 'street'));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    floor.scale.set(1.2, 1.2);
    floor.scrollFactor.set(1, 1);
    floor.active = false;
    add(floor);	

    if (PlayState.SONG.song == 'Delusional')
    {	
        fakeLightOfHope = new FlxSprite(-990, 1600).loadGraphic(Paths.image(pathway + 'falseHope'));
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
    if(!ClientPrefs.lowQulity)
    {
        rain = new FlxSprite(-550, -900);
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
                new ShaderFilter(grayScale), 
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromZoomShader),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [new ShaderFilter(grayScale), new ShaderFilter(chromNormalShader)];
        }
        else
        {
            camGame.filters = [
                new ShaderFilter(grayScale), 
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [
                new ShaderFilter(grayScale),
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
            deluSing.play();
            deluSing.pause();
            deluSing.onEnd(() -> {
                deluSing.kill();
                deluSing.destroy();
                deluSing = null;
            });
            minnieJumpscare = new FunkinVideoSprite(false);
            minnieJumpscare.visible = false;
            minnieJumpscare.load(Paths.video("minniePart"), [FunkinVideoSprite.muted]);
            minnieJumpscare.cameras = [camHUD];
            minnieJumpscare.play();
            minnieJumpscare.pause();
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

function onBeatHit()
{
    if (PlayState.SONG.song == "Isolated")
        switch (curBeat)
        {
            case 160:
                iconP2.alpha = 0;
                isolatedHappy.visible = true;
                FlxTween.tween(isolatedHappy, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);

            case 168:
                lunacyIcon.visible = true;
                iconP2.alpha = 0;
                FlxTween.tween(lunacyIcon, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);

            case 172:
                delusionalIcon.visible = true;
                iconP2.alpha = 0;
                FlxTween.tween(delusionalIcon, {alpha: 0}, 1);
                FlxTween.tween(iconP2, {alpha: 1}, 0.6);

            case 176:
                fakeBFLosingFrame.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(fakeBFLosingFrame, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);

            case 184:
                demonBFIcon.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(demonBFIcon, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);

            case 188:
                demonBFScary.visible = true;
                iconP1.alpha = 0;
                FlxTween.tween(demonBFScary, {alpha: 0}, 1);
                FlxTween.tween(iconP1, {alpha: 1}, 0.6);
        }
    
    switch (PlayState.SONG.song)
    {
        case 'Lunacy':
            if (!ClientPrefs.lowQulity)
            {
                if (curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270 || curBeat == 276 || curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324 || curBeat == 332 || curBeat == 340 || curBeat == 248)
                {
                    if (rainTween != null)
                        rainTween.cancel();
    
                    if (rain != null)
                        rainTween = FlxTween.tween(rain, {alpha: 0.5}, 0.35, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
                        {
                            rainTween = null;
                        }});
                }
                if (curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320 || curBeat == 328 || curBeat == 336 || curBeat == 344 || curBeat == 352)
                {
                    if (rainTween != null)
                        rainTween.cancel();

                    if (rain != null)
                        rainTween = FlxTween.tween(rain, {alpha: 0.0001}, 0.35, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
                            {
                                rainTween = null;
                            }});
                }
                if (curBeat == 480)
                {
                    if (rain != null) rain.alpha = 1;
                }
            }
        case 'Delusional':
            if (curBeat == 1)
            {
                if (rain != null) rain.alpha = 1;
            }
            if (curBeat == 64)
            {
                FlxTween.tween(fakeLightOfHope, {alpha: 0.001}, 1.7);
            }
            if (curBeat == 474) // load daytime street assets
            {
                colorsOrSmthElse.alpha = 0.0001;
                
                floor.alpha = 0.0001;
                if (rain != null) rain.alpha = 0;
                if (!ClientPrefs.lowQulity)
                {
                    totallyanoriginalname.visible = true;
                    stageCurtains.visible = false;
                }
                minnieBackground.visible = true;
            }

            if (curBeat == 679 && !ClientPrefs.lowQulity)
            {
                stageCurtains.alpha = 0.0001;
                stageCurtains.visible = true;
            }

            if (curBeat == 680 || curBeat == 688 || curBeat == 696 || curBeat == 700 || curBeat == 704 || curBeat == 712 || curBeat == 720)
            {
                if (!ClientPrefs.lowQulity)
                {
                    stageCurtains.alpha = 1;
                    FlxTween.tween(stageCurtains, {alpha: 0}, 1, {ease: FlxEase.circOut});
                }
            }

            if (curBeat == 728 && !ClientPrefs.lowQulity)
                FlxTween.tween(stageCurtains, {alpha: 1}, 5);

            if (curBeat == 740) // go back to the street in a even more decayed state
            {
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

                colorsOrSmthElse.alpha = 1;
                
                floor.alpha = 1;
            }
        }

    switch (PlayState.SONG.song)
    {
        case 'Isolated':
            switch (curBeat)
            {
                case 12: camGame.fade(FlxColor.BLACK, 3, true);

                case 30:
                    FlxTween.tween(camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut});

                case 88: 
                    tweenCamera(1.4, 3, 'sineInOut');
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});

                case 96:
                    defaultCamZoom = 0.85;
                    tweenCamera(0.85, 0.4, 'expoOut');

                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35});

                case 160: 
                    tweenCamera(1.3, 2, 'sineInOut');
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.85, timer: 0.5, ease: FlxEase.quartOut});

                case 184:
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.77, timer: 0.5, ease: FlxEase.quartOut});

                case 188:
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.6, timer: 0.5, ease: FlxEase.quartOut});

                case 192: 
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.35, colors: [194, 194, 194]});
                    
                    defaultCamZoom = 1.25;

                // same as dad
                // case 199: updateSectionCamera('bf', true);

                // update after testing without the cam thing they rarely still stunned so idk what to do lmao

                case 220: 
                    tweenCamera(0.85, 2, 'sineInOut');
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.1, colors: [194, 194, 194]});

                case 288:
                    defaultCamZoom = 0.85;

                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});

                case 352:
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.85, timer: 0.5, ease: FlxEase.quartOut});
                    tweenCamera(1.07, 5, 'quadInOut');
                    cameraSpeed -= 0.25;

                case 376:
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 4, ease: FlxEase.quartInOut});

                case 36, 40, 44, 52, 56, 60, 64, 68, 72, 76, 80, 84, 92:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});

                case 100, 104, 108, 116, 120, 124, 132, 136, 140, 148, 152, 156, 228, 232, 236, 240, 244, 252, 260, 264, 268, 276 |
                    280, 284, 292, 296, 300, 308, 312, 316, 324, 328, 332, 340, 344, 348:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.2, timer: 0.35, colors: [194, 194, 194]});

                case 98, 102, 106, 110, 114, 118, 122, 126, 130, 134, 138, 142, 146, 150, 154, 158, 226, 230, 234, 238, 242, 246 |
                    250, 254, 258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318, 322, 326, 330, 334 |
                    338, 342, 346, 350:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.55, timer: 0.35, colors: [194, 194, 194]});

                case 194, 196, 198, 200, 202, 204, 206, 210, 212, 214, 222:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.35, colors: [194, 194, 194]});

                case 216, 217, 218, 219:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 0.1, colors: [194, 194, 194]});
                    camHUD.zoom += 0.04;

                case 128, 256:
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});

                case 48, 336, 304, 272, 112, 144:
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.BLACK, 1.5);
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.32, timer: 1.2, colors: [194, 194, 194]});

                case 32:
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);

                case 416:
                    camGame.visible = false;
                    camHUD.visible = false;

                case 224:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);

                case 320:
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.4, timer: 0.35, colors: [194, 194, 194]});
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);
            }

            if ((curBeat > 96 && curBeat < 160) || (curBeat > 224 && curBeat < 352))
            {
                if (curBeat % 2 == 0)
                {
                    camGame.zoom += 0.05;
                    camHUD.zoom += 0.06;
                }
            }

        case 'Lunacy':
            
            if (curBeat == 100 || curBeat == 108 || curBeat == 116 || curBeat == 124 || curBeat == 132 || curBeat == 140 || curBeat == 148)
            {
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.5, timer: 0.5, ease: FlxEase.sineOut});
            }

            if (curBeat == 160 || curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272
                || curBeat == 280 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320
                || curBeat == 328 || curBeat == 336 || curBeat == 344 || curBeat == 352)
            {
                camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 0.5, ease: FlxEase.quadOut});
            }

            // Darkens BG
            if (curBeat == 156 || curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270
                || curBeat == 276 || curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324
                || curBeat == 332 || curBeat == 340 || curBeat == 348)
            {
                camFlashSystem(FlashType.BG_DARK, {alpha: 0.77, timer: 0.5, ease: FlxEase.quadOut});
            }

            if (curBeat == 424 || curBeat == 432 || curBeat == 440 || curBeat == 448 || curBeat == 456 || curBeat == 464 || curBeat == 472)
            {
                camFlashSystem(FlashType.BG_FLASH, {alpha: 0.65, timer: 0.6, ease: FlxEase.sineOut});
            }

            if (curBeat == 32 || curBeat == 64)
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

            if (curBeat == 38 || curBeat == 40 || curBeat == 46 || curBeat == 48 || curBeat == 54 || curBeat == 56 || curBeat == 62 || curBeat == 70
                || curBeat == 72 || curBeat == 78 || curBeat == 80 || curBeat == 86 || curBeat == 88 || curBeat == 102 || curBeat == 110
                || curBeat == 118 || curBeat == 126 || curBeat == 134 || curBeat == 142 || curBeat == 150)
            {
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
            }

            if (curBeat == 96 || curBeat == 104 || curBeat == 112 || curBeat == 120 || curBeat == 128 || curBeat == 136 || curBeat == 144 || curBeat == 152)
            {
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
            }

            if (curBeat == 100 || curBeat == 108 || curBeat == 116 || curBeat == 124 || curBeat == 132 || curBeat == 140 || curBeat == 148)
            {
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
            }

            if (curBeat == 156)
            {
                if (chromTween != null)
                    chromTween.cancel();

                chromTween = FlxTween.num(chromEffect, 0.33, 0.2, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            }

            if (curBeat == 158)
            {
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
            }

            if (curBeat == 160 || curBeat == 168 || curBeat == 176 || curBeat == 184 || curBeat == 192 || curBeat == 200 || curBeat == 208
                || curBeat == 216 || curBeat == 224 || curBeat == 232 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 264
                || curBeat == 272 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320
                || curBeat == 328 || curBeat == 336 || curBeat == 344)
            {
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
            }

            if (curBeat == 162 || curBeat == 170 || curBeat == 178 || curBeat == 186 || curBeat == 194 || curBeat == 202 || curBeat == 210
                || curBeat == 218 || curBeat == 226 || curBeat == 234 || curBeat == 242 || curBeat == 250 || curBeat == 258 || curBeat == 266
                || curBeat == 274 || curBeat == 282 || curBeat == 290 || curBeat == 298 || curBeat == 306 || curBeat == 314 || curBeat == 322
                || curBeat == 330 || curBeat == 338 || curBeat == 346)
            {
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
            }

            if (curBeat == 163 || curBeat == 171 || curBeat == 179 || curBeat == 187 || curBeat == 195 || curBeat == 203 || curBeat == 211
                || curBeat == 219 || curBeat == 227 || curBeat == 235 || curBeat == 243 || curBeat == 251 || curBeat == 259 || curBeat == 267
                || curBeat == 275 || curBeat == 283 || curBeat == 291 || curBeat == 299 || curBeat == 307 || curBeat == 315 || curBeat == 323
                || curBeat == 331 || curBeat == 339 || curBeat == 347)
            {
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
            }

            if (curBeat == 165 || curBeat == 173 || curBeat == 181 || curBeat == 189 || curBeat == 197 || curBeat == 205 || curBeat == 213
                || curBeat == 221)
            {
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
            }

            if (curBeat == 166 || curBeat == 174 || curBeat == 182 || curBeat == 190 || curBeat == 198 || curBeat == 206 || curBeat == 214
                || curBeat == 222)
            {
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
            }

            if (curBeat == 167 || curBeat == 175 || curBeat == 183 || curBeat == 191 || curBeat == 199 || curBeat == 207 || curBeat == 215
                || curBeat == 223)
            {
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
            }

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

            if (curBeat == 352 || curBeat == 354 || curBeat == 356 || curBeat == 358 || curBeat == 360 || curBeat == 362 || curBeat == 364
                || curBeat == 366 || curBeat == 368 || curBeat == 370 || curBeat == 372 || curBeat == 374 || curBeat == 376 || curBeat == 378
                || curBeat == 380 || curBeat == 382 || curBeat == 384 || curBeat == 386 || curBeat == 388 || curBeat == 390 || curBeat == 392
                || curBeat == 394 || curBeat == 396 || curBeat == 398 || curBeat == 400 || curBeat == 402 || curBeat == 404 || curBeat == 406
                || curBeat == 408 || curBeat == 410 || curBeat == 416 || curBeat == 418 || curBeat == 420 || curBeat == 422 || curBeat == 424
                || curBeat == 426 || curBeat == 428 || curBeat == 430 || curBeat == 432 || curBeat == 434 || curBeat == 436 || curBeat == 438
                || curBeat == 440 || curBeat == 442 || curBeat == 444 || curBeat == 446 || curBeat == 448 || curBeat == 450 || curBeat == 452
                || curBeat == 454 || curBeat == 456 || curBeat == 458 || curBeat == 460 || curBeat == 462 || curBeat == 464 || curBeat == 466
                || curBeat == 468 || curBeat == 470 || curBeat == 472 || curBeat == 474)
            {
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
            }

            if (curBeat == 412)
            {
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
            }

            if (curBeat == 476)
            {
                if (chromTween != null)
                    chromTween.cancel();

                chromTween = FlxTween.num(chromEffect, 0.85, 1.6, {
                    ease: FlxEase.sineOut,
                    onComplete: function(twn:FlxTween)
                    {
                        chromTween = null;
                    }
                }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
            }

            if (curBeat == 480)
            {
                chromTween.cancel();

                chromEffect = 0.00001;
            }

            switch (curBeat)
            {
                // I'm NOT gonna have a fun time recoding all this for the BG dimming in and out later lmao

                case 16: camGame.fade(FlxColor.BLACK, 3, true);

                case 32:
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.BLACK, 1.5);
                    tweenCamera(camGame.zoom + .5, 16.5, 'sineInOut');

                case 64:
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.BLACK, 0.9);

                case 88:
                    tweenCamera(.75, 2.2, 'sineInOut');

                    FlxTween.tween(camHUD, {alpha: 1}, 5, {ease: FlxEase.sineOut});

                case 96:
                    defaultCamZoom = 0.75;
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);

                case 128, 256:
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);

                case 156:
                    defaultCamZoom = 1.05;

                case 160:
                    boundValue = 1.25;
                    drainValue = 0.015;
                    defaultCamZoom = 0.7;
                    if (ClientPrefs.flashing) camGame.flash(FlxColor.BLACK, 1.5);

                case 192:
                    defaultCamZoom = 0.75;
                case 200, 238, 270, 316, 332, 344:
                    defaultCamZoom = 0.8;
                case 208:
                    defaultCamZoom = 0.85;
                case 216, 252, 284:
                    defaultCamZoom = 0.9;
                case 220:
                    defaultCamZoom = 0.95;
                case 222, 267, 239, 271, 334:
                    defaultCamZoom = 1;

                case 224, 288:
                    defaultCamZoom = 0.75;
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    FlxTween.tween(camHUD, {alpha: 0}, 3, {ease: FlxEase.sineInOut});

                case 228, 260, 292, 286:
                    defaultCamZoom = 1.1;

                case 230, 262, 296, 312, 236, 268:
                    defaultCamZoom = 0.65;

                case 232, 264:
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    defaultCamZoom = 0.7;

                case 412, 240, 272, 300, 304, 336, 248, 280, 328:
                    defaultCamZoom = 0.7;

                case 320:
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1.5);
                    defaultCamZoom = 0.7;

                case 254:
                    defaultCamZoom = 1.1;
                    FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});

                case 318:
                    defaultCamZoom = 1.25;
                    FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});

                case 310, 342, 350:
                    defaultCamZoom = 1.25;

                case 352:
                    defaultCamZoom = 0.65;
                    FlxTween.tween(camHUD, {alpha: 0.25}, 8, {ease: FlxEase.sineInOut});
                    FlxTween.num(health, 0.01, 20, null, shitshitfuckfuck -> health = shitshitfuckfuck);

                    if (globalGradient != null)
                        FlxTween.tween(globalGradient, {alpha: 0.8}, 10);
                    FlxTween.tween(FlxG.camera, {zoom: 1.1}, 18, {startDelay: 2});

                case 408:
                    defaultCamZoom = 0.9;
                    FlxTween.tween(camHUD, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});

                case 416: if (ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1.5);

                case 480:
                    boundValue = 1;
                    drainValue = 0.02;
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.BLACK, 1.5);
                    camHUD.alpha = 0;

                case 481:
                    camFollow.x += 100;

                case 506:
                    FlxTween.tween(camHUD, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});

                case 536:
                    FlxTween.tween(camHUD, {alpha: 0}, 2, {ease: FlxEase.sineInOut});

                case 540:
                    camGame.fade(FlxColor.BLACK, 5);
            }

        case 'Delusional':
            if (curBeat == 146)
                manageLyrics('evildelu', 'Count the minutes...', 'disneyFreeplayFont.ttf', 30, 1.1, 'sineInOut', .05);
            if (curBeat == 150)
                manageLyrics('evildelu', "...of how long...", 'disneyFreeplayFont.ttf', 30, 1, 'sineInOut', 0.04);
            if (curBeat == 154)
                manageLyrics('evildelu', "...this show will play!", 'disneyFreeplayFont.ttf', 30, 2.2, 'quartInOut', .07);
            if (curBeat == 162)
                manageLyrics('evildelu', "And remind yourself...", 'disneyFreeplayFont.ttf', 30, 1.3, 'sineInOut', .05);
            if (curBeat == 167)
                manageLyrics('evildelu', "...no matter what's in...", 'disneyFreeplayFont.ttf', 30, 2, 'sineInOut', .06);
            if (curBeat == 174)
                manageLyrics('evildelu', "...THE WAY!", 'disneyFreeplayFont.ttf', 30, 1, 'circOut', .035);
            if (curBeat == 178)
                manageLyrics('evildelu', "All your dreams...", 'disneyFreeplayFont.ttf', 30, 1, 'sineInOut', .04);
            if (curBeat == 182)
                manageLyrics('evildelu', "...ARE SO FAR OUT OF REACH!", 'disneyFreeplayFont.ttf', 30, 4, 'quartInOut', .055);
            if (curBeat == 190)
                manageLyrics('evildelu', "But if YOUR delusions...", 'disneyFreeplayFont.ttf', 30, 2.2, 'sineInOut', .045);
            if (curBeat == 196)
                manageLyrics('evildelu', "...loop around then...", 'disneyFreeplayFont.ttf', 30, 1.3, "quartOut", .045);
            if (curBeat == 200)
                manageLyrics('evildelu', "Let's LOOP 'ROUND ONCE MORE.", 'disneyFreeplayFont.ttf', 30, 3, "sineInOut", .065);

            if (curBeat == 1)
                cinematicBarControls("create", 1);
            if (curBeat == 470)
                cinematicBarControls("moveboth", 0.65, 'backIn', 380);
            if (curBeat == 480)
                cinematicBarControls("moveboth", 10, 'linear', 70);
            if (curBeat == 672)
                cinematicBarControls("moveboth", 1, "circOut", 0);

            switch (curBeat)
            {
                case 1: 
                    boundValue = 1;
                    drainValue = 0.02;
                    camGame.fade(FlxColor.BLACK, 2, true);
                case 132: 
                    defaultCamZoom = 1.3;
                    modManager.queueEase(136 * 4, 148 * 4, "alpha", 1, "linear");
                case 136:
                    camGame.fade(FlxColor.BLACK, 0.6);
                    camHUD.fade(FlxColor.BLACK, 1.75);
                // BF Starts Singing Some Lyrics
                case 143:
                    playHUD.alpha = 0;
                    camHUD.fade(FlxColor.BLACK, 5, true);
                    deluSing.seekTo(0);
                    deluSing.resume();
                    deluSing.visible = true;
                    if (vocals.volume != 1) vocals.volume = 1; // it should be fixed then
                case 144:
                    defaultCamZoom = 0.8;
                    camGame.fade(0x000000, 5, true);
                    camFlashSystem(FlashType.BG_DARK, {alpha: 1, timer: 0.3, ease: FlxEase.quartInOut});
                    defaultCamZoom = 1.2;
                    camFollow.x -= 100;
                    FlxTween.tween(camFollow, {x: camFollow.x + 100}, 12, {ease: FlxEase.sineInOut});
                case 176:
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 0.3, ease: FlxEase.quartInOut});
                    defaultCamZoom = 0.75;
                    camGame.flash(FlxColor.WHITE, 1);

                    // today in super r slur shit we have this cus i hate my life
                    FlxTween.tween(camFollow, {y: camFollow.y - 300}, .00000001, {onComplete: bensonFromRegularShow -> {
                        FlxTween.tween(camFollow, {y: camFollow.y + 300}, 7, {ease: FlxEase.sineInOut});
                    }});
                case 180, 188, 196:
                    camGame.zoom += 0.3;
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.5, timer: 0.35});
                case 184, 192, 200:
                    camGame.zoom += 0.15;
                    camFlashSystem(FlashType.BG_FLASH, {alpha: 0.25, timer: 0.35});
                case 204: defaultCamZoom = 1;
                case 208:
                    camGame.fade(FlxColor.BLACK, .000001);
                    defaultCamZoom = 1.3;
                    modManager.queueEase(216 * 4, 220 * 4, "alpha", 0, "linear");

                // Mickey Screams Like A Bitch
                case 212:
                    boundValue = 0.6;
                    drainValue = 0.025;
                    chromEffect = 0.3;
                    chromTween = FlxTween.num(chromEffect, 1, 1.2, {
                        ease: FlxEase.sineOut
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);

                    camGame.fade(FlxColor.BLACK, .000001, true);
                    defaultCamZoom = 0.75;
                    camGame.shake(0.01, 1.2);
                // The Drop Starts
                case 216:
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
                                new ShaderFilter(grayScale), 
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
                                new ShaderFilter(grayScale), 
                                new ShaderFilter(chromNormalShader), 
                                new ShaderFilter(delusionalShift)
                            ]);
                        }
                    }
                case 228:
                    chromTween = null;
                    defaultCamZoom = 0.85;
                case 230: defaultCamZoom = 1;
                case 232: defaultCamZoom = 0.75;
                case 278: defaultCamZoom = 1;
                case 280, 312, 344: defaultCamZoom = 0.7;
                case 288, 296, 304, 320, 328, 336: defaultCamZoom += 0.1;
                case 308: defaultCamZoom += 0.2;
                case 340: defaultCamZoom += 0.3;
                case 356, 388: defaultCamZoom = 1.2;
                case 358, 390: defaultCamZoom = 1.3;
                case 360: defaultCamZoom = 0.75;
                case 375:
                    chromTween = FlxTween.num(chromEffect, 1, 0.1, {
                        ease: FlxEase.sineInOut
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);

                    tweenCamera(1.5, 0.1, 'sineInOut');
                case 376:
                    if (chromTween != null) chromTween.cancel();
                        chromTween = null;
                    camGame.visible = false;

                    playHUD.alpha = 0;
                case 377:
                    camGame.visible = true;
                    playHUD.alpha = 1;
                    modManager.setValue("alpha", 0);
                    if (ClientPrefs.flashing)
                        camGame.flash(FlxColor.WHITE, 1);
                    defaultCamZoom = 0.8;
                    
                    chromTween = FlxTween.num(chromEffect, 0.1, 0.6, {
                        ease: FlxEase.quadOut
                    }, shitshitfuckfuck -> chromEffect = shitshitfuckfuck);
                case 472:
                    boundValue = 2;
                    drainValue = 0;
                    camGame.visible = false;
                    playHUD.alpha = 0;
                    modManager.setValue("alpha", 1);
                case 473:
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
                            camHUD.filters = ([new ShaderFilter(grayScale), new ShaderFilter(chromNormalShader)]);
                        }
                        else
                        {
                            camGame.filters = ([
                                new ShaderFilter(monitorFilter),
                                new ShaderFilter(chromZoomShader),
                                new ShaderFilter(chromNormalShader)
                            ]);
                            camHUD.filters = ([new ShaderFilter(grayScale), new ShaderFilter(chromNormalShader)]);
                        }
                    }
                    chromEffect = 0.00001;
                    defaultCamZoom = 0.85;
                case 478:
                    camFollow.x = 630;
                    camFollow.y = 750;
                    isCameraOnForcedPos = true;
                    defaultCamZoom = 0.5;
                    boyfriend.cameras = [camHUD];
                    boyfriend.zIndex = 3;

                    playHUD.alpha = 0;
                    modManager.setValue("alpha", 1);

                    boyfriend.alpha = 0.0001;
                case 480:
                    // no healthbar to add more onto the atmosphere of this section
                    camGame.visible = true;
                    modManager.setValue("alpha", 0);
                case 508:
					FlxTween.tween(boyfriend, {alpha: 0.45}, 2.5, {ease: FlxEase.expoOut});
                case 672:
                    blendFlash.cameras = [camGame];
                    boyfriend.alpha = 0.0001;
                    camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.38, timer: 0.85, colors: [255, 255, 255]});
                    minnieJumpscare.seetTo(0);
                    minnieJumpscare.resume();
                    minnieJumpscare.visible = true;
                case 720:
                    FlxTween.tween(camGame, {alpha: 0.0001}, 5, {ease: FlxEase.quartInOut});
                case 736:
                    blendFlash.cameras = [camGame];
                case 740:
                    isCameraOnForcedPos = false;
                    boundValue = 0.45;
                    drainValue = 0.032;
                    boyfriend.alpha = 1;
                    camFollow.x = 0;
                    camFollow.y = 0;
                case 744:
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
                                new ShaderFilter(grayScale), 
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
                                new ShaderFilter(grayScale), 
                                new ShaderFilter(chromNormalShader), 
                                new ShaderFilter(delusionalShift)
                            ]);
                        }
                    }
                case 880, 884, 888, 892, 896, 900, 904, 908, 913, 916, 920, 924, 929, 933, 936, 940, 944, 948, 952, 956, 960, 964, 968, 972, 976, 980, 984, 988, 993, 997, 1000, 1004:
                    camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.135, timer: 0.85, colors: [255, 0, 0]});
                // The part where shit gets serious, Evilrette/Satan starts the solo
                case 1008:
                    boundValue = 1.5;
                    drainValue = 0.01;
                    tweenCamera(1.35, 7, "quartInOut");
                    camFlashSystem(FlashType.CAM_FLASH_FANCY, {alpha: 0.4, timer: 2, colors: [255, 0, 0]});
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0.8, timer: 6, ease: FlxEase.quartInOut});
                    isCameraOnForcedPos = true;
                    camPosTween = FlxTween.tween(camFollow, {x: camFollow.x + 150, y: camFollow.y + 50}, 4.3, {ease: FlxEase.quartInOut});
                // camera moves over to Mickey realizing he was never gonna win
                case 1024:
                    if (camPosTween != null)
                        camPosTween.cancel();
                    
                    camPosTween = FlxTween.tween(camFollow, {x: camFollow.x - 750, y: camFollow.y - 70}, 1.5, {ease: FlxEase.circInOut});
                case 1040:
                    camFollow.x = 440;
                    camFollow.y = 360;
                    defaultCamZoom = 0.5;
                    camFlashSystem(FlashType.BG_DARK, {alpha: 0, timer: 1, ease: FlxEase.circOut});
                case 1072:
                    isCameraOnForcedPos = false;
                    defaultCamZoom = 0.9;
                    modManager.queueEase(1082 * 4, 1086 * 4, "alpha", 1, "sineInOut");
                case 1082:
                    FlxTween.tween(camGame, {zoom: 1.6}, 1, {ease: FlxEase.sineInOut});
                    camGame.fade(FlxColor.BLACK, 0.7);
                    FlxTween.tween(playHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
                case 1086:
                    camFlashSystem(FlashType.BG_DARK, {timer: 5});

					death.play();
                    death.seekTo(0);

                    if (ClientPrefs.shaders)
                    {
                        camHUD.filters = ([
                            new ShaderFilter(chromNormalShader), 
                            new ShaderFilter(delusionalShift)
                        ]);
                    }

                    FlxTween.tween(death, {alpha: 1}, 0.2, {ease: FlxEase.sineInOut});
                case 1136:
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
                case 1144:
                    FlxTween.tween(camHUD, {alpha: 0}, 4);
            }

        if ((curBeat >= 216 && curBeat < 340) || (curBeat >= 344 && curBeat < 356) || (curBeat >= 360 && curBeat < 388) || 
            (curBeat >= 392 && curBeat < 408) || (curBeat >= 880 && curBeat < 1072))
        {
            FlxG.camera.zoom += .015;
            for (mridk in [camHUD]) mridk.zoom += .03;
        }
    }
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