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
import funkin.states.MainMenuState;

using StringTools;

var camFilter:FlxCamera;

var curWeek:Int = 0;

var txtWeekTitle:FlxText;
var txtTracklist:FlxText;

var grpWeekText:FlxTypedGroup;

var transitionThing:FlxSprite;

var controls = Controls.instance;

var loadedWeeks:Array<WeekData> = [];

var movedBack:Bool = false;
var selectedWeek:Bool = false;
var stopspamming:Bool = false;

var street:FlxBackdrop;
var mickey:FlxSprite;

function onCreate()
{
	camFilter = new FlxCamera();
	camFilter.bgColor = 0x0;

	FlxG.cameras.add(camFilter, false);

	PlayState.isStoryMode = true;
	WeekData.reloadWeekFiles(true);
	if(curWeek >= WeekData.weeksList.length) curWeek = 0;
	persistentUpdate = persistentDraw = true;

	street = new FlxBackdrop(Paths.image('menus/story/street'), FlxAxes.X, 0, 0);
	street.velocity.set(-100, 0);
	street.y -= 30;
	street.scale.set(1.3, 1.3);
	add(street);

	mickey = new FlxSprite();
	mickey.frames = Paths.getSparrowAtlas('menus/story/mick');
	mickey.animation.addByPrefix('walk', 'mick idle', 8, true);
	mickey.animation.play('walk');
	mickey.screenCenter().y += 190;
	mickey.scale.set(0.25 / 2, 0.25 / 2);
	add(mickey);

	txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
	txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, "right");
	txtWeekTitle.alpha = 0.7;

	grpWeekText = new FlxTypedGroup();
	add(grpWeekText);

	var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
	add(blackBarThingie);

	Application.current.window.title = "Funkin.avi: Recycled - Story Mode";

	var num:Int = 0;
	for (i in 0...WeekData.weeksList.length)
	{
		var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		
		loadedWeeks.push(weekFile);
		WeekData.setDirectoryFromWeek(weekFile);
		var weekThing:MenuItem = new MenuItem(0, 300, WeekData.weeksList[i]);
		weekThing.y += ((weekThing.height + 20) * num);
		weekThing.targetY = num;
		grpWeekText.add(weekThing);

		weekThing.x += 100;
		weekThing.antialiasing = ClientPrefs.globalAntialiasing;

		num += 1;
	}

	WeekData.setDirectoryFromWeek(loadedWeeks[0]);
	
	txtTracklist = new FlxText(800, 425 + 60, 0, "", 32);
	txtTracklist.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.GRAY, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	txtTracklist.borderSize = 2;
	add(txtTracklist);
	add(txtWeekTitle);

	changeWeek();
	
	WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

	var newImage:FlxGraphic = Paths.image('menus/story/difficulties/hard');

	transitionThing = new FlxSprite(-1700, 0).loadGraphic(Paths.image('menus/story/storyMenuTransition'));
	add(transitionThing);

	FlxTween.tween(transitionThing, {x: 1600}, 2.1, {ease: FlxEase.quadInOut});

	if(!ClientPrefs.lowQuality) 
	{
		var scratch:FlxSprite = new FlxSprite();
		scratch.frames = Paths.getSparrowAtlas('filters/scratchShit');
		scratch.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
		scratch.animation.play('idle');
		scratch.screenCenter();
		scratch.scale.x = 1.1;
		scratch.scale.y = 1.1;
		add(scratch);

		var grain:FlxSprite = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
		grain.animation.addByPrefix('idle', 'grains 1', 24, true);
		grain.animation.play('idle');
		grain.screenCenter();
		grain.scale.x = 1.1;
		grain.scale.y = 1.1;
		add(grain);

		scratch.cameras = [camFilter];
		grain.cameras = [camFilter];
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

		if (controls.ACCEPT)
		{
			selectWeek();
		}
	}

	if (controls.BACK && !movedBack && !selectedWeek)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		movedBack = true;
		FlxG.switchState(new MainMenuState());
	}
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

	FlxTween.tween(street.velocity, {x: 0}, 4, {ease: FlxEase.cubeInOut});
	FlxTween.tween(mickey.velocity, {x: 100}, 4, {ease: FlxEase.cubeInOut});

	FlxTween.tween(FlxG.sound.music, {pitch: 0}, 6, {ease: FlxEase.cubeInOut});

	for (item in grpWeekText.members)
		FlxTween.tween(item, {alpha: 0}, 6, {ease: FlxEase.cubeInOut});
	FlxTween.tween(txtTracklist, {alpha: 0}, 6, {ease: FlxEase.cubeInOut});
	FlxTween.tween(txtWeekTitle, {alpha: 0}, 6, {ease: FlxEase.cubeInOut});
	
	PlayState.storyMeta.score = 0;
	PlayState.storyMeta.misses = 0;
	new FlxTimer().start(1, function(tmr:FlxTimer) {
		FlxG.camera.fade(FlxColor.BLACK, 5, false, function() { 
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.onComplete = null;
				FlxG.sound.music.stop();
			}
			
			FlxG.switchState(new PlayState());
		});
	});
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
		bullShit += 1;
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

	txtTracklist.text = 'Tracks\n\n';
	for (i in 0...stringThing.length) txtTracklist.text += stringThing[i] + '\n';

	txtTracklist.text = txtTracklist.text.toUpperCase();

	txtTracklist.screenCenter(FlxAxes.X).x += 400;
}