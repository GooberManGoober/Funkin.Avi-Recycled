import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import lime.app.Application;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.graphics.FlxGraphic;
import funkin.data.WeekData;
import funkin.objects.MenuItem;
import funkin.data.Highscore;
import funkin.backend.PlayerSettings;
import openfl.filters.ShaderFilter;

using StringTools;

var camFilter:FlxCamera;

var scoreText:FlxText;

var txtWeekTitle:FlxText;
var bgSprite:FlxSprite;

var curWeek:Int = 0;

var txtTracklist:FlxText;

var grpWeekText:FlxTypedGroup;

var controls = PlayerSettings.player1.controls;

var grpLocks:FlxTypedGroup;

var defaultShader:FlxRuntimeShader;
var defaultShader2:FlxRuntimeShader;

var difficultySelectors:FlxTypedGroup;
var sprDifficulty:FlxSprite;
var leftArrow:FlxSprite;
var rightArrow:FlxSprite;
var transitionThing:FlxSprite;

var lerpScore:Int = 0;
var intendedScore:Int = 0;

var loadedWeeks:Array<WeekData> = [];

var movedBack:Bool = false;
var selectedWeek:Bool = false;
var stopspamming:Bool = false;

var tweenDifficulty:FlxTween;

function onCreate()
{
	camFilter = new FlxCamera();
	camFilter.bgColor = 0x0;

	FlxG.cameras.add(camFilter, false);

	PlayState.isStoryMode = true;
	WeekData.reloadWeekFiles(true);
	if(curWeek >= WeekData.weeksList.length) curWeek = 0;
	persistentUpdate = persistentDraw = true;

	scoreText = new FlxText(10000000000000000, 10, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("VCR OSD Mono", 32);

	txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
	txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, "right");
	txtWeekTitle.alpha = 0.7;

	var rankText:FlxText = new FlxText(0, 10);
	rankText.text = 'RANK: GREAT';
	rankText.setFormat(Paths.font("vcr.ttf"), 32);
	rankText.size = scoreText.size;
	rankText.screenCenter(FlxAxes.X);

	var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
	var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
	bgSprite = new FlxSprite(0, 56);
	bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

	grpWeekText = new FlxTypedGroup();
	add(grpWeekText);

	var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
	add(blackBarThingie);

	grpLocks = new FlxTypedGroup();
	add(grpLocks);

	Application.current.window.title = "Funkin.avi: Recycled - Choosing Episode";

	var num:Int = 0;
	for (i in 0...WeekData.weeksList.length)
	{
		var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		
		loadedWeeks.push(weekFile);
		WeekData.setDirectoryFromWeek(weekFile);
		var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[i]);
		weekThing.y += ((weekThing.height + 20) * num);
		weekThing.targetY = num;
		grpWeekText.add(weekThing);

		weekThing.screenCenter(FlxAxes.X);
		weekThing.antialiasing = ClientPrefs.globalAntialiasing;
		// weekThing.updateHitbox();

		num++;
	}

	WeekData.setDirectoryFromWeek(loadedWeeks[0]);
	
	difficultySelectors = new FlxTypedGroup();
	add(difficultySelectors);

	leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 9, grpWeekText.members[0].y + 9);
	leftArrow.frames = ui_tex;
	leftArrow.animation.addByPrefix('idle', "arrow left");
	leftArrow.animation.addByPrefix('press', "arrow push left");
	leftArrow.animation.play('idle');
	leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
	difficultySelectors.add(leftArrow);

	sprDifficulty = new FlxSprite(0, leftArrow.y);
	sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
	difficultySelectors.add(sprDifficulty);

	rightArrow = new FlxSprite(leftArrow.x + 376, grpWeekText.members[0].y + 9);
	rightArrow.frames = ui_tex;
	rightArrow.animation.addByPrefix('idle', 'arrow right');
	rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
	rightArrow.animation.play('idle');
	rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
	difficultySelectors.add(rightArrow);

	add(bgYellow);
	add(bgSprite);

	var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
	tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
	add(tracksSprite);

	txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
	txtTracklist.alignment = "center";
	txtTracklist.font = rankText.font;
	txtTracklist.color = 0xFFe55777;
	add(txtTracklist);
	// add(rankText);
	add(scoreText);
	add(txtWeekTitle);

	changeWeek();
	changeDifficulty();

	transitionThing = new FlxSprite(-1700, 0).loadGraphic(Paths.image('storyMenuTransition'));
	add(transitionThing);

	FlxTween.tween(transitionThing, {x: 1600}, 2.1, {ease: FlxEase.quadInOut});

	if(!ClientPrefs.lowQuality) 
	{
		var scratch:FlxSprite = new FlxSprite();
		scratch.frames = Paths.getSparrowAtlas('Funkin_avi/filters/scratchShit');
		scratch.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
		scratch.animation.play('idle');
		scratch.screenCenter();
		scratch.scale.x = 1.1;
		scratch.scale.y = 1.1;
		add(scratch);

		var grain:FlxSprite = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('Funkin_avi/filters/Grainshit');
		grain.animation.addByPrefix('idle', 'grains 1', 24, true);
		grain.animation.play('idle');
		grain.screenCenter();
		grain.scale.x = 1.1;
		grain.scale.y = 1.1;
		add(grain);

		scratch.cameras = [camFilter];
		grain.cameras = [camFilter];
	}

	defaultShader = newShader('grayScale');
	defaultShader2 = newShader('monitorFilter');
	if(ClientPrefs.shaders)
	{
		FlxG.camera.filters = [new ShaderFilter(defaultShader), new ShaderFilter(defaultShader2)];
	}

	ClientPrefs.gameplaySettings["botplay"] = false;
	ClientPrefs.flush();
}

function onCloseSubstate() {
	persistentUpdate = true;
	changeWeek();
}

function onUpdate(elapsed)
{
	// scoreText.setFormat('VCR OSD Mono', 32);
	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 30, 0, 1)));
	if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

	scoreText.text = "WEEK SCORE:" + lerpScore;

	// FlxG.watch.addQuick('font', scoreText.font);

	if (!movedBack && !selectedWeek)
	{
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		if (upP)
		{
			changeWeek(-1);
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
		}

		if (downP)
		{
			changeWeek(1);
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
		}

		if (controls.UI_RIGHT)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.UI_LEFT)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');

		if (controls.ACCEPT)
		{
			selectWeek();
		}
	}

	if (controls.BACK && !movedBack && !selectedWeek)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		movedBack = true;
		FlxG.switchState(new ScriptedState('MainMenuState'));
	}

	grpLocks.forEach(function(lock:FlxSprite)
	{
		lock.y = grpWeekText.members[lock.ID].y;
		lock.visible = (lock.y > FlxG.height / 2);
	});
}

function selectWeek()
{
	if (stopspamming == false)
	{
		FlxG.sound.play(Paths.sound('funkinAVI/menu/confirmEpisode'));

		grpWeekText.members[curWeek].startFlashing();

		stopspamming = true;
	}

	// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
	var songArray:Array<String> = [];
	var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
	for (i in 0...leWeek.length)
	{
		songArray.push(leWeek[i][0]);
	}
	
	selectedWeek = true;
	
	var ret = PlayState.prepareForWeek(songArray, 2, true);
	
	if (ret != null)
	{
		trace('Failed to load week. \nException: ' + ret);
		
		selectedWeek = false;
		return;
	}
	
	PlayState.storyMeta.score = 0;
	PlayState.storyMeta.misses = 0;
	new FlxTimer().start(1, function(tmr:FlxTimer) {
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.onComplete = null;
			FlxG.sound.music.stop();
		}
		
		FlxG.switchState(new PlayState());
	});
}

function changeDifficulty(?change:Int = 0):Void
{
	WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

	var newImage:FlxGraphic = Paths.image('menudifficulties/hard');

	if(sprDifficulty.graphic != newImage)
	{
		sprDifficulty.loadGraphic(newImage);
		sprDifficulty.x = leftArrow.x + 60;
		sprDifficulty.x += (308 - sprDifficulty.width) / 3;
		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;

		if(tweenDifficulty != null) tweenDifficulty.cancel();
		tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
		{
			tweenDifficulty = null;
		}});
	}

	intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, 2);
}

function changeWeek(?change:Int = 0):Void
{
	curWeek += change;

	if (curWeek >= loadedWeeks.length)
		curWeek = 0;
	if (curWeek < 0)
		curWeek = loadedWeeks.length - 1;

	var leWeek:WeekData = loadedWeeks[curWeek];
	WeekData.setDirectoryFromWeek(leWeek);

	var leName:String = leWeek.storyName;
	txtWeekTitle.text = leName.toUpperCase();
	txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 14);
	txtWeekTitle.screenCenter(FlxAxes.X);

	var bullShit:Int = 0;

	for (item in grpWeekText.members)
	{
		item.targetY = bullShit - curWeek;
		if (item.targetY == Std.int(0))
			item.alpha = 1;
		else
			item.alpha = 0.6;
		bullShit++;
	}

	bgSprite.visible = true;
	var assetName:String = leWeek.weekBackground;
	if(assetName == null || assetName.length < 1) {
		bgSprite.visible = false;
	} else {
		bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
	}
	PlayState.storyWeek = curWeek;

	updateText();
}

function updateText()
{
	var leWeek:WeekData = loadedWeeks[curWeek];
	var stringThing:Array<String> = [];
	for (i in 0...leWeek.songs.length) {
		stringThing.push(leWeek.songs[i][0]);
	}

	txtTracklist.text = '';
	for (i in 0...stringThing.length)
	{
		txtTracklist.text += stringThing[i] + '\n';
	}

	txtTracklist.text = txtTracklist.text.toUpperCase();

	txtTracklist.screenCenter(FlxAxes.X);
	txtTracklist.x -= FlxG.width * 0.35;

	intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, 2);
}