import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;

import funkin.backend.Difficulty;
import funkin.utils.CameraUtil;
import funkin.states.options.OptionsState;

var grpMenuShit:FlxTypedGroup;
var cornerTexts:Array<FlxText> = [];

var menuItems:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
var curSelected:Int = 0;

var pauseMusic:FlxSound;
var practiceText:FlxText;

var pauseNameTxt:FlxText;

function onCreate()
{
	var cam:FlxCamera = CameraUtil.lastCamera;
	
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

	pauseMusic = new FlxSound();
	pauseMusic.loadEmbedded(Paths.music("aviOST/pause/" + randomPauseSong), true, true);
	pauseMusic.volume = 0;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	FlxG.sound.list.add(pauseMusic);
	
	var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	bg.setGraphicSize(cam.width, cam.height);
	bg.updateHitbox();
	bg.cameras = [cam];
	bg.scrollFactor.set();
	add(bg);
	bg.alpha = 0;
	
	function createCornerText(text:String, ?addtoo:Bool = false)
	{
		var t = new FlxText(0, 15, cam.width - 15, text, 32);
		t.alignment = FlxTextAlign.RIGHT;
		t.setFormat(Paths.DEFAULT_FONT, 32);
		t.scrollFactor.set();
		cornerTexts.push(t);
		t.cameras = [cam];
		if (addtoo) add(t);
		return t;
	}
	
	var levelInfo = createCornerText(PlayState.SONG.song);
	add(levelInfo);
	
	var levelDifficulty = createCornerText(Difficulty.getCurrentDifficultyString());
	add(levelDifficulty);

	createCornerText("Composer: " + PlayState.SONG.composer, true);
	createCornerText("Charter: " + PlayState.SONG.charter, true);
	
	var blueballedTxt = createCornerText("Blueballed: " + PlayState.deathCounter);
	add(blueballedTxt);
	
	practiceText = createCornerText("PRACTICE MODE");
	practiceText.visible = PlayState.instance.practiceMode;
	add(practiceText);
	
	var chartingText = createCornerText("CHARTING MODE");
	add(chartingText);
	chartingText.visible = PlayState.chartingMode;
	
	FlxTween.tween(bg, {alpha: 0.6}, 0.4);
	
	var yt:Float = 15;
	for (k => i in cornerTexts)
	{
		i.y = yt - i.height;
		i.alpha = 0;
		FlxTween.tween(i, {alpha: 1, y: yt}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1 * (k + 1)});
		yt += i.height;
	}
	
	grpMenuShit = new FlxTypedGroup();
	grpMenuShit.cameras = [cam];
	add(grpMenuShit);

	pauseNameTxt = new FlxText(5, 700, 1280, "Now Playing: " + pauseSongStr + " - ForFurtherNotice");
	pauseNameTxt.setFormat(Paths.font("disneyFreeplayFont.ttf"), 16, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	pauseNameTxt.alpha = 0.0001;
	add(pauseNameTxt);
	FlxTween.tween(pauseNameTxt, {alpha: 1}, 1, {ease:FlxEase.quartOut});
	pauseNameTxt.camera = CameraUtil.lastCamera;
	
	regenMenu();
}

var holdTime:Float = 0;

function onUpdate(elapsed)
{
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;
	
	if (Controls.UI_UP_P)
	{
		changeSelection(-1);
	}
	if (Controls.UI_DOWN_P)
	{
		changeSelection(1);
	}
	
	var daSelected:String = menuItems[curSelected];
	
	if (Controls.ACCEPT)
	{
		switch (daSelected)
		{
			case "Resume":
				close();
			case "Restart Song":
				restartSong();
			case 'Options':
				toOptions();
			case "Exit to menu":
				returnToMain();
		}
	}
}

function returnToMain()
{
	PlayState.deathCounter = 0;
	PlayState.seenCutscene = false;
	CoolUtil.cancelMusicFadeTween();
	PlayState.changedDifficulty = false;
	PlayState.chartingMode = false;

	if (PlayState.isStoryMode)
	{
		FlxG.switchState(new ScriptedState('StoryMenu'));
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}
	else
	{
		switch (PlayState.SONG.song)
		{
			case 'Devilish Deal', 'Isolated', 'Lunacy', 'Delusional':
				FlxG.save.data.freeplayMenuList = 0;
				FlxG.save.flush();
				FlxG.switchState(new ScriptedState('FreeplayState'));
			default:
				FlxG.save.data.freeplayMenuList = 1;
				FlxG.save.flush();
				FlxG.switchState(new ScriptedState('FreeplayState')); // yeah, there's no way I'm making a case for EVERY fucking song in that menu, too much work!
		}
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}
}

function toOptions()
{
	PlayState.instance.paused = true;
	PlayState.instance.audio.volume = 0;
	FlxG.switchState(new OptionsState());
	@:privateAccess
	{
		if (pauseMusic._sound != null)
		{
			FunkinSound.playMusic(pauseMusic._sound, 0);
			FlxG.sound.music.time = pauseMusic.time;
			FlxTween.tween(FlxG.sound.music, {volume: 0.5}, 0.7);
		}
	}
	
	OptionsState.onPlayState = true;
}

function restartSong(?noTrans:Bool = false)
{
	PlayState.instance.paused = true;
	FlxG.sound.music.volume = 0;
	PlayState.instance.audio.volume = 0;
	
	if (noTrans)
	{
		FlxTransitionableState.skipNextTransOut = true;
	}
	
	FlxG.resetState();
}

function onDestroy()
{
	pauseMusic.destroy();
}

function changeSelection(?change:Int = 0)
{
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);
	
	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
	for (k => item in grpMenuShit.members)
	{
		item.targetY = k - curSelected;
		
		item.alpha = 0.6;
		if (item.targetY == 0)
		{
			item.alpha = 1;
		}
	}
}

function regenMenu():Void
{
	for (i in 0...grpMenuShit.members.length)
	{
		var obj = grpMenuShit.members[0];
		grpMenuShit.remove(obj, true);
		
		obj = FlxDestroyUtil.destroy(obj);
	}
	
	for (i in 0...menuItems.length)
	{
		var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
		item.isMenuItem = true;
		item.targetY = i;
		grpMenuShit.add(item);
	}
	curSelected = 0;
	changeSelection();
}
