import funkin.scripting.PluginsManager;

// Pre-made Text
var composer:String = PluginsManager.callPluginFunc('CreditsData', 'getArtistName', [PlayState.SONG.song]);
var songTitle:String = PlayState.SONG.song;

var songCrdGrp:FlxSpriteGroup;

// JSON Var Helpers
var fontStuff:String = "vcr";

var isLegacy:Bool = false;

// Base Card Setup
var cardTxt:FlxText;
var cardSprite:FlxSprite;

// Health Icons
var dadIcon:HealthIcon;
var playerIcon:HealthIcon;

function setupCardData()
{
	switch (PlayState.SONG.song)
	{
		case 'Devilish Deal', 'Isolated', 'Lunacy', 'Hunted', 'Twisted Grins', 'Laugh Track', 'War Dilemma', 'Birthday', 'Delusion', 'Disclosure':
			fontStuff = "DisneyFont.ttf";
		case 'Delusional':
			fontStuff = "betterSatanFont.ttf";
		case 'Bless':
			fontStuff = "MagicOwlFont.otf";
		case "Don't Cross!":
			fontStuff = "PhantomMuff Full Letters 1.1.5.ttf";
		case 'Malfunction':
			fontStuff = "m40.ttf";
		case 'Bless Legacy':
			fontStuff = "vcr.ttf";
			isLegacy = true;
		default: 
			fontStuff = "vcr.ttf";
	}
}

function onLoad()
{
	songCrdGrp = new FlxSpriteGroup();
	add(songCrdGrp);
	songCrdGrp.cameras = [camOther];
}

function onCreatePost()
{
	setupCardData();

	var pIconName:String = boyfriend.healthIcon;
	var oIconName:String = dad.healthIcon;

	if (!isLegacy)
	{
		cardSprite = new FlxSprite().makeGraphic(600, 350, 0xFF000000);
		cardSprite.screenCenter();
		cardSprite.alpha = 0.001;
		songCrdGrp.add(cardSprite);

		cardTxt = new FlxText(cardSprite.x, cardSprite.y, 0, '- ' + songTitle + ' -\nBy: ' + composer);
		cardTxt.setFormat(Paths.font(fontStuff), 42, FlxColor.WHITE, "center");
		cardTxt.screenCenter();
		cardTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		cardTxt.alpha = 0.001;
		songCrdGrp.add(cardTxt);
	}
	else
	{
		cardSprite = new FlxSprite(0, 0).makeGraphic(999, 136, FlxColor.WHITE);
		cardSprite.scrollFactor.set();
		cardSprite.blend = BlendMode.ADD;
		cardSprite.alpha = 0;
		cardSprite.screenCenter();
		songCrdGrp.add(cardSprite);

		cardTxt = new FlxText(0, 0, 600, '$songTitle\nBy: $composer');
		cardTxt.setFormat(Paths.font(fontStuff), 36, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		cardTxt.scrollFactor.set();
		cardTxt.borderSize = 1.25;
		cardTxt.alpha = 0;
		cardTxt.screenCenter();
		songCrdGrp.add(cardTxt);
	}

	if (!isLegacy)
	{
		dadIcon = new HealthIcon(oIconName, false);
		dadIcon.frameCount = 3;
		dadIcon.x = 260;
		dadIcon.y = 130;

		playerIcon = new HealthIcon(pIconName, true);
		playerIcon.frameCount = 3;
		playerIcon.x = 850;
		playerIcon.y = 460;

		dadIcon.alpha = 0.001;
		playerIcon.alpha = 0.001;

		dadIcon.animation.curAnim.curFrame = 2;
		playerIcon.animation.curAnim.curFrame = 2;
	
		songCrdGrp.add(dadIcon);
		songCrdGrp.add(playerIcon);
	}


	if (!isLegacy)
	{
		switch (PlayState.SONG.song)
		{
			case 'Devilish Deal', 'Isolated', 'Lunacy', 'Delusional':
			// do nothing, it's already set under stepHit()
			default:
				playCardAnim(0.08);
		}
	}
}

function onSongStart()
{
	if (isLegacy)
	{
		playLegacyCardAnim();
	}

	// Modified Card Delays
	switch (PlayState.SONG.song)
	{
		case 'Devilish Deal', 'Isolated', 'Lunacy':
			modManager.queueFuncOnce(1, (s,s2)->{ 
				playCardAnim(0.2);
			});
		case 'Delusional':
			modManager.queueFuncOnce(1, (s,s2)->{ 
				playCardAnim(0.001);
			});
	}
}

// This is a function in case you want the card to show up later in the song instead of instantly
function playCardAnim(delaySet:Float = 0)
{	
	FlxTween.tween(cardSprite, {alpha: 1}, 1.5, {ease: FlxEase.sineInOut, startDelay: delaySet,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(cardSprite, {alpha: 0}, 1.5, {ease: FlxEase.sineInOut, startDelay: 3.5});
		}
	});
	FlxTween.tween(dadIcon, {alpha: 1}, 2.2, {ease: FlxEase.sineInOut, startDelay: delaySet,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(dadIcon, {alpha: 0}, 2.2, {ease: FlxEase.sineInOut, startDelay: 3.5});
		}
	});
	FlxTween.tween(playerIcon, {alpha: 1}, 2.2, {ease: FlxEase.sineInOut, startDelay: delaySet,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(playerIcon, {alpha: 0}, 2.2, {ease: FlxEase.sineInOut, startDelay: 3.5});
		}
	});
	FlxTween.tween(cardTxt, {alpha: 1}, 2, {ease: FlxEase.sineInOut, startDelay: delaySet,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(cardTxt, {alpha: 0}, 2, {ease: FlxEase.sineInOut, startDelay: 3.5});
		}
	});
}

function playLegacyCardAnim()
{
	FlxTween.tween(cardSprite, {alpha: 0.5}, 1, {ease: FlxEase.circOut,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(cardSprite, {alpha: 0}, 1.5, {ease: FlxEase.circIn, startDelay: 4});
		}
	});

	FlxTween.tween(cardTxt, {alpha: 1}, 1, {ease: FlxEase.circOut,
		onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(cardTxt, {alpha: 0}, 1.5, {ease: FlxEase.circIn, startDelay: 4});
		}
	});
}