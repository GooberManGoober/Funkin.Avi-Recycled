import funkin.scripting.PluginsManager;
import funkin.backend.PlayerSettings;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import funkin.utils.CameraUtil;
import funkin.FunkinAssets;
import funkin.Mods;

var bg:FlxSprite;

var warning:FlxText;
var desc:FlxText;

var onYes:Bool = false;
var yesText:FlxText;
var noText:FlxText;

var controls = PlayerSettings.player1.controls;

function onLoad()
{
	bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	bg.scrollFactor.set();

	warning = new FlxText(0, 150, 0, "", 50);
	warning.setFormat(Paths.font("disneyFreeplayFont.ttf"), 50, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	warning.screenCenter(FlxAxes.X).x -= 100;
	warning.applyMarkup('*WARNING*',
		[
			new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "*")
		]
	);

	desc = new FlxText(200, 250, 0, "", 35);
	desc.setFormat(Paths.font("disneyFreeplayFont.ttf"), 35, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	desc.applyMarkup('You are about to *PERMANENTLY DELETE* your save data.\nAre you sure you want to *delete* your save data?\n*It cannot be recovered once deleted.*',
		[
			new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "*")
		]
	);

	for (i in [bg, warning, desc])
	{
		i.alpha = 0;
		i.camera = CameraUtil.lastCamera;
		add(i);
	}

	yesText = new FlxText(0, desc.y + 150, 0, 'Yes', 70);
	yesText.screenCenter(FlxAxes.X);
	yesText.setFormat(Paths.font("disneyFreeplayFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	yesText.x -= 200;
	yesText.alpha = 0.6;
	yesText.camera = CameraUtil.lastCamera;
	add(yesText);
	noText = new FlxText(0, desc.y + 150, 0, 'No', 70);
	noText.screenCenter(FlxAxes.X);
	noText.setFormat(Paths.font("disneyFreeplayFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	noText.x += 200;
	noText.alpha = 1;
	noText.camera = CameraUtil.lastCamera;
	add(noText);
	updateOptions();

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

	scratchStuff.camera = CameraUtil.lastCamera;
	grain.camera = CameraUtil.lastCamera;
}

function onUpdate(elapsed)
{
	bg.alpha += elapsed * 1.5;
	if(bg.alpha > 0.6) bg.alpha = 0.6;

	warning.alpha += elapsed * 1.5;
	if(warning.alpha > 1) warning.alpha = 1;

	desc.alpha += elapsed * 1.5;
	if(desc.alpha > 1) desc.alpha = 1;

	if(controls.UI_LEFT_P || controls.UI_RIGHT_P) 
	{
		FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 1);
		onYes = !onYes;
		updateOptions();
	}
	if(controls.BACK) 
	{
		FlxG.sound.play(Paths.sound('cancelMenu'), 1);
		close();
	} 
	else if(controls.ACCEPT)
	{
		FlxG.sound.play(Paths.sound('cancelMenu'), 1);
		if(onYes) 
		{
			resetData();
			FlxG.sound.music.fadeOut(0.3);
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, resetZaGame, false);
		}
		close();
	}
}

function resetZaGame()
{
	FlxG.resetGame();

	resetData();

	FunkinAssets.cache.clearStoredMemory();
	FunkinAssets.cache.clearUnusedMemory();

	PluginsManager.populate();

	Mods.applyModConfig();
}

function updateOptions() {
	var scales:Array<Float> = [0.75, 1];
	var alphas:Array<Float> = [0.6, 1.25];
	var confirmInt:Int = onYes ? 1 : 0;

	yesText.alpha = alphas[confirmInt];
	yesText.scale.set(scales[confirmInt], scales[confirmInt]);
	noText.alpha = alphas[1 - confirmInt];
	noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
}

function resetData()
{
	FlxG.save.data.episode1FPLock = 'locked';

    FlxG.save.data.freeplayMenuList = 0;

    FlxG.save.data.huntedLock = 'locked';
    FlxG.save.data.malfunctionLock = 'locked';
    FlxG.save.data.blessLock = 'locked';
    FlxG.save.data.crossinLock = 'locked';
    FlxG.save.data.tgLock = 'locked';
    FlxG.save.data.rickyLock = 'locked';

    FlxG.save.data.birthdayLocky = "uncompleted";

	FlxG.save.data.loading = false;

	FlxG.save.flush();
}