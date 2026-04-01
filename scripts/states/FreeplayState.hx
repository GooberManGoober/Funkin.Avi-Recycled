import openfl.filters.ShaderFilter;
import lime.app.Application;
import openfl.media.Sound;
import funkin.data.ClientPrefs;
import funkin.data.Highscore;
import funkin.utils.MathUtil;
import funkin.data.WeekData;
import flixel.text.FlxText;
import funkin.backend.PlayerSettings;
import funkin.data.Chart;
import funkin.backend.Difficulty;
import funkin.Mods;
import flixel.util.FlxStringUtil;

using StringTools;

typedef SongMetadata =
{
	var songName:String;
	var week:Int;
	var songCharacter:String;
	var color:FlxColor;
	var composer:String;
	var difficultyRank:String;
	var textColor:FlxColor;
}

var songs:Array<SongMetadata> = [];

var selector:FlxText;
var curSelected:Int = 0;

var curDifficulty:Int = -1;
	
var lastDifficultyName:String = '';

var scoreBG:FlxSprite;
var scoreText:FlxText;
var diffText:FlxText;
var lerpScore:Int = 0;
var lerpRating:Float = 0;
var intendedScore:Int = 0;
var intendedRating:Float = 0;

var controls = PlayerSettings.player1.controls;

var path:String = 'Funkin_avi/freeplay';

var grpSongs:FlxTypedGroup;

var songDisplay:Array<FlxText> = [];
var curPlaying:Bool = false;

var iconArray:Array<HealthIcon> = [];

var botplaytext:FlxText;

var bg:Null<FlxSprite>;

var camGame:FlxCamera; // Main camera (including shaders n shit)
var camHUD:FlxCamera; // Objects
var camOther:FlxCamera; // Gameplay Changers + Fade transitions

var defaultCamZoom:Float = 1;
var camZoomTween:FlxTween;

var defaultShader2:FlxRuntimeShader;
var smilesShader:FlxRuntimeShader;
var glitchyStuff:FlxRuntimeShader;
var chromAberration:FlxRuntimeShader;
var shaderTime:Float = 0;

var difficultyRank:String = 'HARD';
var songArtist:String = "Unknown";

var intendedColor:Int;
var colorTween:FlxTween;

function onCreate()
{
	Application.current.window.title = "Funkin.avi: Recycled - Freeplay: Setting Up Category...";

	defaultShader2 = newShader('monitorFilter');
	chromAberration = newShader('aberration');
	chromAberration.setFloat('aberration', 0.07);
	chromAberration.setFloat('effectTime', 0.005);

	// Categories, Shaders, and Songlist Setup
	
	switch (FlxG.save.data.freeplayMenuList)
	{
		case 0: // Story Songs Menu
		{
			addSong('Devilish Deal', 3, 'satandd', FlxColor.fromRGB(65, 88, 94), 'obscurity', 'EASY', FlxColor.WHITE);
			addSong('Isolated', 3, 'avier', FlxColor.fromRGB(60, 60, 60), 'obscurity', 'NORMAL', FlxColor.fromRGB(255, 220, 220));
			addSong('Lunacy', 3, 'lunaavier', FlxColor.fromRGB(69, 54, 54), 'obscurity', 'HARD', FlxColor.fromRGB(255, 187, 187));
			addSong('Delusional', 3, 'deluavier', FlxColor.fromRGB(79, 32, 32), 'FR3SHMoure', 'INSANE', FlxColor.fromRGB(255, 110, 110));
		}
		case 1: // Extras Menu
		{		
			glitchyStuff = newShader('vignetteGlitch'); // Malfunction
			smilesShader = newShader('tvStatic'); // Twisted Grins

			addSong('Hunted', 3, 'goofy', FlxColor.fromRGB(94, 28, 35), 'JBlitz', 'NORMAL', FlxColor.fromRGB(255, 220, 220));
			addSong('Laugh Track', 3, 'ricky', FlxColor.fromRGB(60, 60, 60), 'Yama haki/Toko', 'HARD', FlxColor.fromRGB(255, 187, 187));
			addSong('Bless', 3, 'whitenew', FlxColor.WHITE, 'PualTheUnTruest', 'HARD', FlxColor.fromRGB(255, 187, 187));
			addSong("Don't Cross!", 3, 'cross', FlxColor.fromRGB(255, 0, 0), 'Yama haki/Toko', 'GOOD LUCK', FlxColor.fromRGB(201, 0, 0));
			addSong('Neglection', 3, 'pnm', FlxColor.fromRGB(117, 86, 27), 'AttackPan', 'NORMAL', FlxColor.fromRGB(255, 220, 220));
			addSong('Twisted Grins', 3, 'smile', FlxColor.fromRGB(54, 38, 38), 'ForFurtherNotice', 'HARD', FlxColor.fromRGB(255, 187, 187));

			addSong('Malfunction', 3, 'mal-pixel', FlxColor.fromRGB(150, 149, 186), 'obscurity', null, FlxColor.WHITE);

			if (FlxG.save.data.birthdayLocky != "uninvited")
				addSong('Birthday', 3, 'muckney', FlxColor.fromRGB(84, 255, 181), 'FR3SHMoure', 'PARTY', FlxColor.fromRGB(250, 234, 92));
		}
	}

	persistentUpdate = true;
	PlayState.isStoryMode = false;
	WeekData.reloadWeekFiles(false);

	camGame = new FlxCamera();
	camHUD = new FlxCamera();
	camOther = new FlxCamera();

	camHUD.bgColor = 0x0;
	camOther.bgColor = 0x0;

	FlxG.cameras.reset(camGame);
	FlxG.cameras.add(camHUD, false);
	FlxG.cameras.add(camOther, false);

	FlxG.cameras.setDefaultDrawTarget(camGame, true);

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image(path + '/menuFreeplay'));
	add(bg);

	grpSongs = new FlxTypedGroup();
	add(grpSongs);

	for (i in 0...songs.length)
	{
		var songText:Alphabet = new Alphabet(5, 320, songs[i].songName, true);
		songText.isMenuItem = true;
		songText.changeAxis = FlxAxes.Y;
		songText.targetY = i;
		songText.snapToTarget();
		songText.screenCenter(FlxAxes.X);
		grpSongs.add(songText);
		
		// using a FlxGroup is too much fuss!
		var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
		icon.sprTracker = songText;
		iconArray.push(icon);
		add(icon);
	}

	if (lastDifficultyName == '')
	{
		lastDifficultyName = Difficulty.defaultDifficulty;
	}
	curDifficulty = Math.round(Math.max(0, Difficulty.defaultDifficulties.indexOf(lastDifficultyName)));

	var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
	textBG.alpha = 0.6;
	textBG.cameras = [camHUD];
	add(textBG);
		
	botplaytext = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press B to toggle Botplay. Botplay: ' + (ClientPrefs.gameplaySettings["botplay"] == true ? 'ON' : 'OFF'), 18);
	botplaytext.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, "center");
	botplaytext.scrollFactor.set();
	botplaytext.cameras = [camHUD];
	add(botplaytext);

	scoreBG = new FlxSprite((FlxG.width * 0.7) - 6, 0).makeGraphic(1, 66, 0xFF000000);
	scoreBG.alpha = 0.6;
	scoreBG.cameras = [camHUD];
	add(scoreBG);
	
	scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
	scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right");
	scoreText.cameras = [camHUD];
	add(scoreText);

	diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
	diffText.font = scoreText.font;
	diffText.cameras = [camHUD];
	add(diffText);

	if(curSelected >= songs.length) curSelected = 0;
	bg.color = songs[curSelected].color;
	intendedColor = bg.color;

	changeSelection(0, false);
	changeDiff(0);

	// this is probably the most retartded shit ever sorry man
	// camZoomTween = FlxTween.tween(this, {}, 0);

	if(!ClientPrefs.lowQuality)
	{
		var scratchStuff:FlxSprite = new FlxSprite();
		scratchStuff.frames = Paths.getSparrowAtlas('Funkin_avi/filters/scratchShit');
		scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
		scratchStuff.animation.play('idle');
		scratchStuff.screenCenter();
		scratchStuff.scale.x = 1.1;
		scratchStuff.scale.y = 1.1;
		add(scratchStuff);

		var grain:FlxSprite = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('Funkin_avi/filters/Grainshit');
		grain.animation.addByPrefix('idle', 'grains 1', 24, true);
		grain.animation.play('idle');
		grain.screenCenter();
		grain.scale.x = 1.1;
		grain.scale.y = 1.1;
		add(grain);

		scratchStuff.cameras = [camHUD];
		grain.cameras = [camHUD];
	}
}


function onCloseSubstate() {
	changeSelection(0, false);
	persistentUpdate = true;
}

function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, composer:String, rankName:String, rankColor:FlxColor)
{
	songs.push({
		songName: songName,
		week: weekNum,
		songCharacter: songCharacter,
		color: color,
		composer: composer,
		difficultyRank: rankName,
		textColor: rankColor
	});
}

function changeBotPlay(){
	ClientPrefs.gameplaySettings["botplay"] = (ClientPrefs.gameplaySettings["botplay"] == true) ? false : true;
	if (ClientPrefs.gameplaySettings["botplay"] == true)
		botplaytext.text = 'Press B to toggle Botplay. Botplay: ON';
	else
		botplaytext.text = 'Press B to toggle Botplay. Botplay: OFF';

	ClientPrefs.flush();

	return;
}

var instPlaying:Int = -1;

var holdTime:Float = 0;

function onUpdate(elapsed)
{
	if (FlxG.sound.music.volume < 0.7)
	{
		FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
	}

	Conductor.songPosition = FlxG.sound.music.time;

	if (FlxG.keys.justPressed.B) {
		changeBotPlay();
	}

	if (ClientPrefs.shaders) // bye bye lag
	{
		if (FlxG.save.data.freeplayMenuList == 1)
		{
			shaderTime = Conductor.songPosition / 1000;

			glitchyStuff.setFloat('time', shaderTime);
			glitchyStuff.setFloat('prob', shaderTime);

			smilesShader.setFloat('iTime', shaderTime);
			smilesShader.setFloat('uTime', shaderTime);
		}
	}

	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
	lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));

	if (Math.abs(lerpScore - intendedScore) <= 10)
		lerpScore = intendedScore;
	if (Math.abs(lerpRating - intendedRating) <= 0.01)
		lerpRating = intendedRating;

	var ratingSplit:Array<String> = Std.string(MathUtil.floorDecimal(lerpRating * 100, 2)).split('.');
	if(ratingSplit.length < 2) { //No decimals, add an empty space
		ratingSplit.push('');
	}
	
	while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
		ratingSplit[1] += '0';
	}

	scoreText.text = 'PERSONAL BEST: ' + FlxStringUtil.formatMoney(lerpScore, false) + ' (' + ratingSplit.join('.') + '%)';
	positionHighscore();

	var upP = controls.UI_UP_P;
	var downP = controls.UI_DOWN_P;
	var accepted = controls.ACCEPT;
	var ctrl = FlxG.keys.justPressed.CONTROL;

	var shiftMult:Int = 1;
	if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

	if(songs.length > 1)
	{
		if (upP)
		{
			changeSelection(-shiftMult, true);
			holdTime = 0;
		}
		if (downP)
		{
			changeSelection(shiftMult, true);
			holdTime = 0;
		}

		if(controls.UI_UP || controls.UI_DOWN)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult), true);
				changeDiff();
			}
		}

		if(FlxG.mouse.wheel != 0)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.2);
			changeSelection(-shiftMult * FlxG.mouse.wheel, false);
		}
	}

	for (i in 0...iconArray.length)
	{
		if(songs[i].songName == "Birthday")
			iconArray[i].animation.curAnim.curFrame = 1; // funi
		//i swear to god theres too much .replace
		else if(songs[i].songName == "Don't Cross!")
		{
			var stop:Bool = false;
			if(!stop)
			{
				iconArray[i].offset.x = FlxG.random.float(-4, 4);
				iconArray[i].offset.y = FlxG.random.float(-4, 4);
				iconArray[i].angle = FlxG.random.int(-30, 30);	
			}
			
			new FlxTimer().start(0.1, timer->stop = true);
		}
	}

	if (controls.BACK)
	{
		persistentUpdate = false;
		if(colorTween != null) {
			colorTween.cancel();
		}
		FlxG.sound.play(Paths.sound('cancelMenu'));
		
		FlxG.switchState(new ScriptedState('EpicSelectorWOOO'));
		FlxG.mouse.visible = true;
	}

	if (FlxG.keys.justPressed.SPACE)
	{
		if (instPlaying != curSelected)
		{
			if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
			Mods.currentModDirectory = songs[curSelected].folder;
			PlayState.SONG = Chart.fromSong(songs[curSelected].songName, curDifficulty);
			
			FunkinSound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
			instPlaying = curSelected;
		}
	}
	else if (accepted)
	{
		persistentUpdate = false;

		if(colorTween != null) {
			colorTween.cancel();
		}

		var ret = PlayState.prepareForSong(songs[curSelected].songName, curDifficulty, false);
	
		if (ret != null)
		{
			trace('Failed to load song. \nException: ' + ret);
			
			return;
		}

		// ignore that im using the short "if" thing is for less code stuff due to lazyness lol
		FlxTween.tween(FlxG.camera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
		new FlxTimer().start(0.7, function(e)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(() -> {
				new PlayState();
			}, true);
		});
	}
}

function changeDiff(?change:Int = 0)
{
	curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.difficulties.length - 1);
		
	lastDifficultyName = Difficulty.difficulties[curDifficulty];
	
	difficultyRank = songs[curSelected].difficultyRank;
	diffText.color = songs[curSelected].textColor;

	PlayState.storyMeta.difficulty = curDifficulty;
	diffText.text = 'RANK: ' + difficultyRank;// display the text
	positionHighscore();
}

var shittyTmr:FlxTimer;
function changeSelection(?change:Int = 0, ?playSound:Bool = true)
{
	if(playSound) FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.4);

	if (shittyTmr != null)
		shittyTmr.cancel();

	shittyTmr = new FlxTimer().start(0.88, function(tmr:FlxTimer) {
		shittyTmr = null;
	});

	if(ClientPrefs.flashing)
		FlxG.camera.flash(FlxColor.BLACK, 0.1);

	curSelected += change;

	if (curSelected < 0)
		curSelected = songs.length - 1;
	if (curSelected >= songs.length)
		curSelected = 0;

	var songName:String = songs[curSelected].songName;
	songArtist = songs[curSelected].composer;

	switch (FlxG.save.data.freeplayMenuList)
	{
		case 0: 
			Application.current.window.title = "Funkin.avi: Recycled - Freeplay: Story Menu - " + songName + ' - Composed by: ' + songArtist;
		case 1:
			Application.current.window.title = "Funkin.avi: Recycled - Freeplay: Extras Menu - " + songName + " - Composed by: " + songArtist;
	}

	var newColor:Int = songs[curSelected].color;
	if(newColor != intendedColor) {
		if(colorTween != null) {
			colorTween.cancel();
		}
		intendedColor = newColor;
		colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
			onComplete: function(twn:FlxTween) {
				colorTween = null;
			}
		});
	}

	// selector.y = (70 * curSelected) + 30;

	intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
	intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);

	var bullShit:Int = 0;

	for (i in 0...iconArray.length)
		iconArray[i].alpha = 0.6;

	iconArray[curSelected].alpha = 1;

	for (s in 0...songDisplay.length)
		songDisplay[s].alpha = 0;

	for (item in grpSongs.members)
	{
		item.targetY = bullShit - curSelected;
		bullShit += 1;
		
		item.alpha = 0.6;
		if (item.targetY == 0)
			item.alpha = 1;
	}

	Mods.currentModDirectory = songs[curSelected].folder;
	PlayState.storyMeta.curWeek = songs[curSelected].week;

	curDifficulty = 2;

	if (ClientPrefs.shaders) // to prevent lag
	{
		// ah yes, formatting made by vsc itself - jason
		switch (songs[curSelected].songName.toLowerCase().replace(" ", "-"))
		{
			case 'bless':
				FlxG.camera.shake(0.01, 0.001);
				if(!ClientPrefs.lowQuality) {
					FlxG.camera.filters = (
						[
							new ShaderFilter(defaultShader2)
						]);
				}

			case 'malfunction':
				if(!ClientPrefs.lowQuality) {
					FlxG.camera.filters = (
						[
							new ShaderFilter(glitchyStuff), 
							new ShaderFilter(chromAberration),
							new ShaderFilter(defaultShader2)
						]);
				}
				FlxG.camera.shake(0.01, 0.001);

			case "don't-cross!":
				if(!ClientPrefs.lowQuality) {
					FlxG.camera.filters = (
						[
							new ShaderFilter(chromAberration),
							new ShaderFilter(defaultShader2)
						]);
				}
				
			case 'twisted-grins':
				if(!ClientPrefs.lowQuality)
				{
					FlxG.camera.filters = (
					[
						new ShaderFilter(smilesShader),
						new ShaderFilter(defaultShader2)
					]);
				}

			case 'birthday':
				if(!ClientPrefs.lowQuality)
					FlxG.camera.filters = ([new ShaderFilter(defaultShader2)]);
				FlxG.camera.shake(0.01, 0.001);
			
			case 'devilish-deal' | 'delusional':
				if(!ClientPrefs.lowQuality)
					FlxG.camera.filters = ([new ShaderFilter(chromAberration), new ShaderFilter(defaultShader2)]);
				FlxG.camera.shake(0.01, 0.001);

			default:
				if(!ClientPrefs.lowQuality)
					FlxG.camera.filters = ([new ShaderFilter(defaultShader2)]);
				FlxG.camera.shake(0.01, 0.001);
		}
	}

	difficultyRank = songs[curSelected].difficultyRank;
	diffText.color = songs[curSelected].textColor;

	diffText.text = 'RANK: ' + difficultyRank;// display the text
	positionHighscore();
}

function positionHighscore() {
	scoreText.x = FlxG.width - scoreText.width - 6;
	scoreBG.scale.x = FlxG.width - scoreText.x + 6;
	scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
	diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
	diffText.x -= diffText.width / 2;
}