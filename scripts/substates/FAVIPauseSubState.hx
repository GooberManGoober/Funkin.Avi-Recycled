import flixel.addons.transition.FlxTransitionableState;
import sys.io.File;
import haxe.Json;
import openfl.Lib;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText;
import funkin.api.DiscordClient;
import funkin.scripting.PluginsManager;
import lime.app.Application;
import funkin.utils.CameraUtil;
import funkin.states.options.OptionsState;
import funkin.states.FreeplayState;
import funkin.states.StoryMenuState;
import flixel.addons.text.FlxTypeText;

using StringTools;

var bg:FlxSprite;
var levelInfo:FlxText;
var menuItems:Array<String> = ['continue', 'restart', 'settings', 'escape'];
var funnyButton:FlxSprite;
var curSelected:Int = 0;
var buttonGroup:FlxTypedGroup;
var songText:FlxSprite;
var pauseMusic:FlxSound;
var disc:FlxSprite;
var songArt:FlxSprite;
var songArtOutline:FlxSprite;
var songName:FlxText;
var hasResumed:Bool = false;
var hasFinishedAnim:Bool = false;
var pauseNameTxt:FlxText;
var pauseSongStr:String;

var controls = Controls.instance;

var funnyButtonX:Float = 0;
var funnyButtonY:Float = 0;

var yourName:String;

var satanTxt:FlxTypeText;
var satanQuotes:Array<String> = [];

var fuckingName:String;

var itemStack:Array<String>;

var creepyRed = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, false, FlxColor.fromRGB(46, 0, 0)), '*');

function onLoad()
{
	switch (PlayState.SONG.song)
	{
		case 'War Dilemma': itemStack = ['wd-continue', 'wd-restart', 'wd-settings', 'wd-escape'];
		case 'Malfunction': itemStack = ['mal-continue', 'mal-restart', 'mal-settings', 'rage'];
		case 'Birthday': itemStack = ['continue', 'restart', 'settings', 'leave'];
		default: itemStack = ['continue', 'restart', 'settings', 'escape'];
	}

	// cool stuff
	menuItems = itemStack;

	yourName = DiscordClient.username;

	satanQuotes = [
		"No, it is forbidden...",
		"You can't leave now...",
		"You're not going anywhere...",
		"You've come too far to leave now...",
		"The fun has just begun...",
		"Don't be afraid of a little mouse...",
		"Stay right where you are, " + yourName + "...",
		"He's already died many times...",
		"What difference will you leaving do?",
		"Leaving so soon?",
		"Something wrong, " + yourName + "?",
		"Are you scared?",
		"You've seen too much, I won't let you go yet...",
		"Do you know who I am?",
		"You're a coward, " + yourName + "...",
		"Not so fast, friend...",
		"Not so fast, " + yourName + "...",
		"Why leave so soon? You'll be back. *And we'll be waiting...*"
	];

	var randomPauseSong:String = "";
	var randomizer:Int = FlxG.random.int(1, 3);

	switch (randomizer)
	{
		case 1: 
			randomPauseSong = "shipTheFartYayHoorayv3v";
			pauseSongStr = "Ship The Fart Hooray < 3 (Distant Stars)";
		case 2: 
			randomPauseSong = "somberNight";
			pauseSongStr = "Ahh The Scary (Somber Night)";
		case 3: 
			randomPauseSong = "theWretchedTilezones";
			pauseSongStr = "The Wretched Tilezones (Simple Life)";
	}

	fuckingName = PlayState.SONG.song;

	var pauseArtAsset:String = fuckingName.toLowerCase().replace(" ", "-");

	pauseMusic = new FlxSound();
	pauseMusic.loadEmbedded(Paths.music("aviOST/pause/" + randomPauseSong), true, true);
	pauseMusic.volume = 0;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	FlxG.sound.list.add(pauseMusic);

	var data = PluginsManager.callPluginFunc('CreditsData', 'jsonStuff', [PlayState.SONG.song]);

	var array:Array<Dynamic> = data.settings;

	// all variable initial setups
	bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	levelInfo = new FlxText(FlxG.width * 0.75 + array[2], 100, 0, "", 32);
	songArt = new FlxSprite(780, 110);
	songArtOutline = new FlxSprite(songArt.x - 20, songArt.y - 20 /*POV: you're lazy to do the math yourself*/).makeGraphic(890, 890, FlxColor.WHITE);
	disc = new FlxSprite(songArt.x + 75, songArt.y - 12).loadGraphic(Paths.image('menus/pause/disc'));
	songName = new FlxText(FlxG.width * 0.78 + array[1], 10, 0, ((PlayState.SONG.song == "Delusional" && (PlayState.instance.curBeat >= 472 && PlayState.instance.curBeat <= 744)) ? "Regret" : PlayState.SONG.song), 32);
	countDown = new FlxText(0, 0, 1280, "", 0);
	satanTxt = new FlxTypeText(0, 25, 1280, "");
	pauseNameTxt = new FlxText(5, 700, 1280, "Now Playing: " + pauseSongStr + " - ForFurtherNotice");

	// text stuff
	// I'M NOT DELUSIONAL, YOU'RE DELUSIONAL !!!!!!
	levelInfo.setFormat(Paths.font("disneyFreeplayFont.ttf"), 18, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	songName.setFormat(Paths.font("disneyFreeplayFont.ttf"), 46, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	pauseNameTxt.setFormat(Paths.font("disneyFreeplayFont.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	countDown.setFormat(Paths.font("betterSatanFont.ttf"), 90, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	satanTxt.setFormat(Paths.font("disneyFreeplayFont.ttf"), 32, FlxColor.fromRGB(255, 117, 107), 'center', FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(92, 0, 26));
	satanTxt.borderSize = 2;
	if (Paths.image('menus/pause/songs/' + pauseArtAsset) != null)
		songArt.loadGraphic(Paths.image('menus/pause/songs/' + pauseArtAsset));
	else if (Paths.image('menus/pause/songs/' + pauseArtAsset) == null)
		songArt.loadGraphic(Paths.image('menus/pause/songs/unknown-song'));

	// scales
	bg.scale.set(FlxG.width * 4, FlxG.height * 4);
	disc.scale.set(0.28, 0.28);
	songArt.scale.set(0.29, 0.29);
	songArtOutline.scale.set(0.29, 0.29); // this was easier for me to scale it off the ORIGINAL image size instead of just trying to get the exact graphic size of the song art being SCALED

	levelInfo.text = array[0];

	for (obj in [levelInfo, bg, songName, countDown])
		obj.scrollFactor.set();

	countDown.screenCenter();
	
	satanTxt.screenCenter(FlxAxes.X);

	// alpha value setup
	for (obj in [bg, levelInfo, songName, pauseNameTxt])
		obj.alpha = 0.0001;

	countDown.visible = false;

	// fuck it. add everything
	for (obj in [bg, songName, levelInfo, pauseNameTxt, disc, songArtOutline, songArt])
		add(obj);

	// menu buttons
	buttonGroup = new FlxTypedGroup();
	buttonGroup.camera = CameraUtil.lastCamera;
	add(buttonGroup);

	for (i in 0...menuItems.length)
	{
		songText = new FlxSprite(0, (10 * i) + 30).loadGraphic(Paths.image('menus/pause/menuButtons/' + menuItems[i]));
		songText.alpha = 0;
		buttonGroup.add(songText);
		FlxTween.tween(songText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
	}

	satanTxt.camera = CameraUtil.lastCamera;
	add(satanTxt);

	countDown.camera = CameraUtil.lastCamera;
	add(countDown);

	// tweens (bruh moment)
	FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartOut, onComplete: 
		function(twn:FlxTween)
			{
				hasFinishedAnim = true;
			}
		});
	FlxTween.tween(levelInfo, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
	FlxTween.tween(songName, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
	FlxTween.tween(disc, {x: disc.x - 300}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(disc, {angle: 360}, 2, {type: 2});
	FlxTween.tween(songArt, {x: songArt.x - 110}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(songArtOutline, {x: songArtOutline.x - 110}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(pauseNameTxt, {alpha: 1}, 1, {ease:FlxEase.quartOut});

	funnyButton = new FlxSprite(0, 0);
	switch (PlayState.SONG.song)
	{
		case 'War Dilemma':
				funnyButton.loadGraphic(Paths.image('menus/pause/selectorSkin/wd-selector'));
		case 'Malfunction':
			funnyButton.loadGraphic(Paths.image('menus/pause/selectorSkin/mal-selector'));
		default:
			funnyButton.loadGraphic(Paths.image('menus/pause/selectorSkin/select'));
	}
	add(funnyButton);

	funnyButton.alpha = 0;

	FlxTween.tween(funnyButton, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});

	changeSelection();
	Application.current.window.title += " - {Paused}";

	for (i in [bg, levelInfo, funnyButton, buttonGroup, songText, disc, songArt, songArtOutline, songName, pauseNameTxt])
		i.camera = CameraUtil.lastCamera;
}

function onUpdate(elapsed)
{
	switch (menuItems[curSelected])
	{
		case 'continue':
			funnyButtonX = songText.x + 300;
			funnyButtonY = 120;
		case 'restart':
			funnyButtonX = songText.x + 310;
			funnyButtonY = 265;
		case 'settings':
			funnyButtonX = songText.x + 540;
			funnyButtonY = 420;
		case 'escape':
			funnyButtonX = songText.x + 300;
			funnyButtonY = 580;
		case 'leave':
			funnyButtonX = songText.x + 530;
			funnyButtonY = 580;
		case 'wd-continue':
			funnyButtonX = songText.x + 430;
			funnyButtonY = 124;
		case 'wd-restart':
			funnyButtonX = songText.x + 370;
			funnyButtonY = 280;
		case 'wd-settings':
			funnyButtonX = songText.x + 720;
			funnyButtonY = 430;
		case 'wd-escape':
			funnyButtonX = songText.x + 570;
			funnyButtonY = 585;
		case 'mal-continue':
			funnyButtonX = songText.x + 410;
			funnyButtonY = 104;
		case 'mal-restart':
			funnyButtonX = songText.x + 420;
			funnyButtonY = 250;
		case 'mal-settings':
			funnyButtonX = songText.x + 770;
			funnyButtonY = 410;
		case 'rage':
			funnyButtonX = songText.x + 960;
			funnyButtonY = 570;
	}

	if (funnyButton != null) funnyButton.setPosition(
		FlxMath.lerp(funnyButtonX, funnyButton.x, FlxMath.bound(1 - (elapsed * 15), 0, 1)), 
		FlxMath.lerp(funnyButtonY, funnyButton.y, FlxMath.bound(1 - (elapsed * 15), 0, 1))
	);

	updateSelection();

	if (!hasResumed && hasFinishedAnim)
	{
		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);
		
		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					resumeGame();
				case 1:
					remove(disc);
					restartSong();
				case 2:
					remove(disc);
					PlayState.instance.paused = true;
					PlayState.instance.audio.volume = 0;
					FlxG.switchState(new OptionsState());
					@:privateAccess
					{
						if (pauseMusic._sound != null)
						{
							FlxG.sound.music.time = pauseMusic.time;
							FunkinSound.playMusic(pauseMusic._sound, 0);
							FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.7);
						}
					}
					OptionsState.onPlayState = true;
				case 3:
					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'delusional':
							satanTxt.applyMarkup(satanQuotes[FlxG.random.int(0, satanQuotes.length - 1)], [creepyRed]);
							satanTxt.start(0.02, true);
						case 'birthday':
							remove(disc);
							FlxG.switchState(new ScriptedState('ManIHateYouSoMuchYouMadeMuckneySad')); // grah
						default:
							remove(disc);
							PlayState.seenCutscene = false;
							
							CoolUtil.cancelMusicFadeTween();
							PlayState.changedDifficulty = false;
							PlayState.chartingMode = false;
							PlayState.deathCounter = 0;

							Conductor.bpm = 60;

							if (PlayState.isStoryMode)
							{
								FlxG.switchState(new StoryMenuState());
								FlxG.sound.playMusic(Paths.music('freakyMenu'));
							}
							else
							{
								FlxG.switchState(new FreeplayState());
								FlxG.sound.playMusic(Paths.music('freakyMenu'));
							}
					}
			}
		}
	}

	if (pauseMusic != null && pauseMusic.playing)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.1 * elapsed;
	}
}

function onDestroy()
{
	if (pauseMusic != null)
		pauseMusic.destroy();
}

function changeSelection(?change:Int = 0):Void
{
	FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.6);

	if (menuItems != null)
		curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

	var bullShit:Int = 0;
}

function restartSong(?noTrans:Bool = false)
{
	PlayState.instance.paused = true; // For lua
	PlayState.instance.audio.volume = 0;

	if(noTrans)
		FlxTransitionableState.skipNextTransOut = true;
	else
		FlxTransitionableState.skipNextTransOut = false;
	FlxG.resetState();
}

function resumeGame()
{
	hasResumed = true;
	songName.alpha = 0;
	levelInfo.alpha = 0;
	satanTxt.text = "";
	
	FlxG.sound.play(Paths.sound('clickText'), 0.6);
	FlxTween.tween(disc, {x: disc.x + 800}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(songArt, {x: songArt.x + 510}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(songArtOutline, {x: songArtOutline.x + 510}, 0.8, {ease: FlxEase.quartOut});
	FlxTween.tween(pauseNameTxt, {alpha: 0}, 0.75, {ease: FlxEase.quartOut});
	FlxTween.tween(funnyButton, {alpha: 0}, 0.8, {ease: FlxEase.quartInOut});

	new FlxTimer().start(0.4, function(tmr:FlxTimer)
	{
		FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.6);
		countDown.visible = true;
		countDown.text = "3";
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.6);
			countDown.text = "2";
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.6);
				countDown.text = "1";
				FlxTween.tween(bg, {alpha: 0}, 1.2, {ease: FlxEase.quartInOut});
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.6);
					countDown.text = "Go!";
					FlxTween.tween(countDown, {alpha: 0}, 0.4);
					new FlxTimer().start(0.55, function(tmr:FlxTimer)
					{
						close();
						remove(disc);
						Application.current.window.title = "Funkin.avi: Recycled - " + 
						(PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + 
						PlayState.SONG.song + 
						" [" + PluginsManager.callPluginFunc('CreditsData', 'getDiffRank', [PlayState.SONG.song]) + "]";
					});
				});
			});
		});
	});
}

function updateSelection()
{
	if (hasFinishedAnim)
	{
		buttonGroup.forEach(function(spr:FlxSprite)
		{
			spr.alpha = hasResumed ? 0 : 0.45;
		});
	
		if (buttonGroup.members[curSelected].alpha == 0.45)
			buttonGroup.members[curSelected].alpha = hasResumed ? 0 : 1;
	}
}