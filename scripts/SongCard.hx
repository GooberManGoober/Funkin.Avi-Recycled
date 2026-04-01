import funkin.scripting.PluginsManager;

// Pre-made Text
var composer:String = PluginsManager.callPluginFunc('CreditsData', 'getArtistName', [PlayState.SONG.song]);
var songTitle:String = PlayState.SONG.song;

var songCrdGrp:FlxSpriteGroup;

// JSON Var Helpers
var fontStuff:String = "vcr";

// Base Card Setup
var cardTxt:FlxText;
var cardSprite:FlxSprite;

// A bit of Decoration
var musicNoteIcon:FlxSprite;

// Health Icons
var dadIcon:HealthIcon;
var playerIcon:HealthIcon;

function setupCardData()
{
	switch (PlayState.SONG.song)
	{
		case 'Devilish Deal', 'Isolated', 'Lunacy', 'Hunted', 'Twisted Grins', 'Laugh Track', 'Birthday':
			fontStuff = "DisneyFont.ttf";
		case 'Delusional':
			fontStuff = "betterSatanFont.ttf";
		case 'Bless':
			fontStuff = "MagicOwlFont.otf";
		case "Don't Cross!":
			fontStuff = "PhantomMuff Full Letters 1.1.5.ttf";
		case 'Malfunction':
			fontStuff = "m40.ttf";
		default: 
			fontStuff = "vcr.ttf";
	}
}

function onCreatePost()
{
	setupCardData();

	var pIconName:String = boyfriend.healthIcon;
	var oIconName:String = dad.healthIcon;

	songCrdGrp = new FlxSpriteGroup();
	add(songCrdGrp);
	songCrdGrp.cameras = [camOther];

	cardSprite = new FlxSprite();

	dadIcon = new HealthIcon(oIconName, false);
	dadIcon.x = 260;
	dadIcon.y = 130;

	playerIcon = new HealthIcon(pIconName, true);
	playerIcon.x = 850;
	playerIcon.y = 460;

	cardSprite.makeGraphic(600, 350, 0xFF000000);
	cardSprite.screenCenter();

	cardTxt = new FlxText(cardSprite.x, cardSprite.y, 0, '- ' + songTitle + ' -\nBy: ' + composer);
	cardTxt.setFormat(Paths.font(fontStuff), 42, FlxColor.WHITE, "center");
	cardTxt.screenCenter();

	cardSprite.alpha = 0.001;

	songCrdGrp.add(cardSprite);
	songCrdGrp.add(dadIcon);
	songCrdGrp.add(playerIcon);

	dadIcon.alpha = 0.001;

	playerIcon.alpha = 0.001;

	cardTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	cardTxt.alpha = 0.001;

	songCrdGrp.add(cardTxt);
	songCrdGrp.add(dadIcon);
	songCrdGrp.add(playerIcon);

	if (!isStoryMode)
	{
		playCardAnim(0.08);
	}
	else if (isStoryMode)
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

function onStepHit()
{
	// Modified Card Delays
	switch (PlayState.SONG.song)
	{
		case 'Devilish Deal', 'Isolated', 'Lunacy':
			if (isStoryMode)
			{
				switch (curStep)
				{
					case 1: playCardAnim(0.2);
				}
			}
		case 'Delusional':
			if (isStoryMode)
			{
				switch (curStep)
				{
					case 1: playCardAnim(0.001);
				}
			}
	}
}