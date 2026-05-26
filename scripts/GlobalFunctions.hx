import flixel.addons.text.FlxTypeText;

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

var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null];

var dumbCamTwn:FlxTween;

public var stageBGFlash:FlxSprite;
var BGFlashTween:FlxTween;

public var blendFlash:FlxSprite;
var flashTween:FlxTween;

var lyricsIcon:HealthIcon;
var lyrics:FlxTypeText;
var lyricsTween:FlxTween;
var iconTween:FlxTween;

public var camBars:FlxCamera;
public var camVideo:FlxCamera;

var topBarTwn:FlxTween;
var bottomBarTwn:FlxTween;

public var foreground:FlxTypedGroup;

public var ratingNameGroup:FlxTypedGroup<FlxSprite>;
public var ratingNumGroup:FlxTypedGroup<FlxSprite>;

function onLoad()
{
    camVideo = new FlxCamera();
	camVideo.bgColor = 0x0;
    FlxG.cameras.insert(camVideo, FlxG.cameras.list.indexOf(PlayState.camHUD) - 1, false);
    
    camBars = new FlxCamera();
	camBars.bgColor = 0x0;
    FlxG.cameras.insert(camBars, FlxG.cameras.list.indexOf(PlayState.camHUD) - 1, false);

    foreground = new FlxTypedGroup();
}

function onCreatePost()
{
    stageBGFlash = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
	stageBGFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
	stageBGFlash.alpha = 0.00001; // it's at this value so the game doesn't lag when it becomes visible
	stageBGFlash.x -= 750;
	stageBGFlash.y -= 450;
	stageBGFlash.scrollFactor.set();
    add(stageBGFlash);

	ratingNameGroup = new FlxTypedGroup();
	ratingNumGroup = new FlxTypedGroup();

	playHUD.add(ratingNameGroup);
	playHUD.add(ratingNumGroup);

    for (grp in [gfGroup, dadGroup, boyfriendGroup]) // fixes layering issue with the bg flash overlaying the characters
	{
		remove(grp);
		add(grp);
	}

    add(foreground);
    
    blendFlash = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	blendFlash.scale.set(FlxG.width * 5, FlxG.height * 5);
	blendFlash.alpha = 0.0001;
	blendFlash.blend = BlendMode.ADD;
	blendFlash.x -= 750;
	blendFlash.y -= 450;
	blendFlash.scrollFactor.set();
	add(blendFlash);

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
    lyricsIcon.frameCount = 3;
    lyricsIcon.cameras = [camOther];
    add(lyricsIcon);
}

public function camFlashSystem(flashType:String, settings:FlashingSettings)
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
            case 'flash':
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

            case 'dark':
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
            
            case 'fancy flash':
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

public function tweenCamera(zoom:Float = 0.9, time:Float = 0.6, ease:Null<String>):Void
{
    if (dumbCamTwn != null)
        dumbCamTwn.cancel();
    
    dumbCamTwn = FlxTween.tween(camGame, {zoom: zoom}, time, {ease: CoolUtil.getEaseFromString(ease), onComplete: function(twn:FlxTween)
    {
        defaultCamZoom = zoom;
        dumbCamTwn = null;
    }});
}

public function manageLyrics(icon:String = 'bf', text:String = 'swaggers', font:String = 'vcr', size:Int = 15, duration:Float = 5, tweenType:String = 'linear', ?textDelay:Float = 0.03)
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

public function cinematicBarControls(?controlType:String = "add", ?speed:Float, ?ease:String = "circInOut", ?position:Float = 0, ?bopValue:Float = 0)
{
	switch (controlType.toLowerCase())
	{
		case "add", "create":
			// idk if i should change this cus i dont wanna fuck up and i lazy to test them lol -sylinpix (jason)
			if (cinematicBars["top"] == null)
			{
				cinematicBars["top"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				cinematicBars["top"].screenCenter(FlxAxes.X);
				cinematicBars["top"].cameras = [camBars];
				cinematicBars["top"].y = 0 - cinematicBars["top"].height; // offscreen
				add(cinematicBars["top"]);
			}

			if (cinematicBars["bottom"] == null)
			{
				cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				cinematicBars["bottom"].screenCenter(FlxAxes.X);
				cinematicBars["bottom"].cameras = [camBars];
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