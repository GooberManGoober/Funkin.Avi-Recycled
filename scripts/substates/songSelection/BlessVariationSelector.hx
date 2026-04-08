import funkin.utils.CameraUtil;

var bg:FlxSprite;

var warning:FlxText;
var desc:FlxText;

var canAccept:Bool = false;

var onDefault:Bool = true;
var defaultText:FlxText;
var legacyText:FlxText;

function onLoad()
{
	bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	bg.scrollFactor.set();

	warning = new FlxText(0, 150, 0, "Song Selector", 50);
	warning.setFormat(Paths.font("disneyFreeplayFont.ttf"), 50, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	warning.screenCenter(FlxAxes.X);

	desc = new FlxText(200, 250, 0, 'This song has multiple variations\n(Default, and Legacy).\nWhich one would you like to play?', 35);
	desc.setFormat(Paths.font("disneyFreeplayFont.ttf"), 35, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	desc.screenCenter(FlxAxes.X);

	for (i in [bg, warning, desc])
	{
		i.alpha = 0;
		i.camera = CameraUtil.lastCamera;
		add(i);
	}

	defaultText = new FlxText(0, desc.y + 150, 0, 'Default', 70);
	defaultText.screenCenter(FlxAxes.X);
	defaultText.setFormat(Paths.font("disneyFreeplayFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	defaultText.x -= 150;
	defaultText.alpha = 0.6;
	defaultText.camera = CameraUtil.lastCamera;
	add(defaultText);

	legacyText = new FlxText(0, desc.y + 150, 0, 'Legacy', 70);
	legacyText.screenCenter(FlxAxes.X);
	legacyText.setFormat(Paths.font("disneyFreeplayFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	legacyText.x += 250;
	legacyText.alpha = 1;
	legacyText.camera = CameraUtil.lastCamera;
	add(legacyText);
	updateOptions();

	var scratchStuff:FlxSprite = new FlxSprite();
	scratchStuff.frames = Paths.getSparrowAtlas('filters/scratchShit');
	scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
	scratchStuff.animation.play('idle');
	scratchStuff.screenCenter();
	scratchStuff.scale.x = 1.1;
	scratchStuff.scale.y = 1.1;
	add(scratchStuff);

	var grain:FlxSprite = new FlxSprite();
	grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
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
	if(bg.alpha > 0.6) 
	{
		bg.alpha = 0.6;
		canAccept = true;
	}

	warning.alpha += elapsed * 1.5;
	if(warning.alpha > 1) warning.alpha = 1;

	desc.alpha += elapsed * 1.5;
	if(desc.alpha > 1) desc.alpha = 1;

	if(Controls.UI_LEFT_P || Controls.UI_RIGHT_P) 
	{
		FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 1);
		onDefault = !onDefault;
		updateOptions();
	}
	if(Controls.BACK) 
	{
		FlxG.sound.play(Paths.sound('cancelMenu'), 1);
		close();
	} 
	else if (Controls.ACCEPT && canAccept)
	{
		switch (defaultText.alpha)
		{
			case 0.6:
				var ret = PlayState.prepareForSong("Bless Legacy", 2, false);		
				if (ret != null)
				{
					trace('Failed to load song. \nException: ' + ret);
					
					return;
				}

				// ignore that im using the short "if" thing is for less code stuff due to lazyness lol
				FlxTween.tween(CameraUtil.lastCamera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
				FlxTween.tween(FlxG.camera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
				CameraUtil.lastCamera.fade(FlxColor.BLACK, 0.7, false);

				new FlxTimer().start(0.7, function(e)
				{
					FlxG.sound.music.stop();
					FlxG.switchState(() -> {
						new PlayState();
					}, true);
				});
			default: 
				var ret = PlayState.prepareForSong("Bless", 2, false);		
				if (ret != null)
				{
					trace('Failed to load song. \nException: ' + ret);
					
					return;
				}

				// ignore that im using the short "if" thing is for less code stuff due to lazyness lol
				FlxTween.tween(CameraUtil.lastCamera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
				FlxTween.tween(FlxG.camera, {zoom: 2.5}, 1.5, {ease: FlxEase.expoInOut});
				CameraUtil.lastCamera.fade(FlxColor.BLACK, 0.7, false);
				new FlxTimer().start(0.7, function(e)
				{
					FlxG.sound.music.stop();
					FlxG.switchState(() -> {
						new PlayState();
					}, true);
				});
		}
	}
}

function updateOptions() {
	var scales:Array<Float> = [0.75, 1];
	var alphas:Array<Float> = [0.6, 1.25];
	var confirmInt:Int = onDefault ? 1 : 0;

	defaultText.alpha = alphas[confirmInt];
	defaultText.scale.set(scales[confirmInt], scales[confirmInt]);
	legacyText.alpha = alphas[1 - confirmInt];
	legacyText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
}