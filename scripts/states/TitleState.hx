import lime.system.System;
import flixel.text.FlxText;
import sys.io.File;

import lime.app.Application;
import funkin.FunkinAssets;
import openfl.filters.ShaderFilter;

import funkin.states.MainMenuState;

using StringTools;

var initialized:Bool = false;

var blackScreen:FlxSprite;
var textGroup:FlxTypedGroup;
var credGroup:FlxTypedGroup;

// goofy ahh fix
var isTweenCancelled = false;

var whiteFade:FlxSprite;

var fadeTween:FlxTween;

var defaultShader:FlxRuntimeShader;
var defaultShader2:FlxRuntimeShader;

var fade:FlxSprite;

var logoBl:FlxSprite;
var recycledText:FlxText;
var gfDance:FlxSprite;
var danceLeft:Bool = false;
var titleText:FlxText;

var skippedIntro:Bool = false;

var transitioning:Bool = false;
var playJingle:Bool = false;

var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
var closedState:Bool = false;

function onCreate()
{	
	Application.current.window.title = 'Funkin.avi: Recycled - Title Screen';

	closedState = false;
	
	persistentUpdate = true;

	var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/title/Title_bg'), false);
	bg.screenCenter();
	bg.scale.x = 0.68;
	bg.scale.y = 0.67;
	add(bg);

	logoBl = new FlxSprite(150, -75);
	logoBl.frames = Paths.getSparrowAtlas('menus/title/MickeyLogo');
	logoBl.antialiasing = ClientPrefs.globalAntialiasing;
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
	logoBl.animation.play('bump');
	logoBl.updateHitbox();
	logoBl.screenCenter().y -= 50;
	logoBl.angle = -4;
	FlxTween.tween(logoBl, {angle: 4}, 4, {ease: FlxEase.quartInOut, type: 4});
	add(logoBl);

	recycledText = new FlxText(60, 515, 1200, "Recycled", 96);
	recycledText.setFormat(Paths.font('DisneyFont.ttf'), 50, FlxColor.fromRGB(255, 255, 255), "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	recycledText.borderSize = 1.5;
	recycledText.antialiasing = ClientPrefs.globalAntialiasing;
	recycledText.screenCenter('x');
	recycledText.angle = -4;
	FlxTween.tween(recycledText, {angle: 4, x: 15}, 4, {ease: FlxEase.quartInOut, type: 4});
	add(recycledText);

	titleText = new FlxText(24, 600, 1200, "Press Enter to Start", 96);
	titleText.setFormat(Paths.font('MagicOwlFont.otf'), 60, FlxColor.fromRGB(255, 255, 255), "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	titleText.borderSize = 1.5;
	titleText.antialiasing = ClientPrefs.globalAntialiasing;
	add(titleText);

	credGroup = new FlxTypedGroup();
	add(credGroup);
	textGroup = new FlxTypedGroup();

	blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	blackScreen.scale.set(FlxG.width * 3, FlxG.height * 3);
	blackScreen.scrollFactor.set();
	credGroup.add(blackScreen);

	if (FlxG.sound.music != null) FlxG.sound.music.stop();
	FlxTimer.wait(1, () -> {
		FunkinSound.playMusic(Paths.music('freakyMenu'), 0);
		Conductor.bpm = 60;
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		beatHit();
	});

	whiteFade = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	whiteFade.scale.set(FlxG.width * 3, FlxG.height * 3);
	whiteFade.scrollFactor.set();
	whiteFade.alpha = 0;
	add(whiteFade);

	if(!ClientPrefs.lowQuality) {
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
	}

	defaultShader2 = newShader('monitorFilter');
	if(ClientPrefs.shaders)
	{
		FlxG.camera.filters = [new ShaderFilter(defaultShader2)];
	}
	
	if (initialized)
		skipIntro();
	else
		initialized = true;
}

function onUpdate(elapsed)
{
	if (FlxG.sound.music != null && FlxG.sound.music.playing)
		Conductor.songPosition = FlxG.sound.music.time;

	var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

	/**
		* closing in a cool way
		*/
	if (FlxG.keys.justPressed.ESCAPE && !pressedEnter)
	{
		FlxG.sound.music.fadeOut(3);
		FlxTween.tween(FlxG.sound.music, {pitch: 0.001}, 2.5);
		FlxG.camera.fade(FlxColor.BLACK, 3, false, function()
		{
			System.exit(0);
		}, false);
	}

	// EASTER EGG

	if (initialized && !transitioning && skippedIntro)
	{
		if(pressedEnter)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('funkinAVI/menu/selectSfx'), 0.7);

			transitioning = true;

			FlxTween.tween(logoBl, {y: 2000}, 3, {ease: FlxEase.quadIn});
			FlxTween.tween(recycledText, {y: 2000}, 3, {ease: FlxEase.quadIn});
			FlxTween.tween(titleText, {y: 2000}, 3, {ease: FlxEase.quadIn});

			new FlxTimer().start(1.3, function(tmr:FlxTimer){
				closedState = true;
				ClientPrefs.quants = false;
				ClientPrefs.flush();
				FlxG.switchState(new MainMenuState());
			});
		}
	}

	if (initialized && pressedEnter && !skippedIntro)
	{
		skipIntro();
	}

	FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * 1.925), 0, 1));
	logoBl.scale.set(FlxMath.lerp(0.85, logoBl.scale.x, FlxMath.bound(1 - (elapsed * 1.995), 0, 1)), FlxMath.lerp(0.85, logoBl.scale.y, FlxMath.bound(1 - (elapsed * 1.995), 0, 1)));
	recycledText.scale.set(FlxMath.lerp(1, recycledText.scale.x, FlxMath.bound(1 - (elapsed * 1.995), 0, 1)), FlxMath.lerp(1, recycledText.scale.y, FlxMath.bound(1 - (elapsed * 1.995), 0, 1)));
}

function createCoolText(textArray:Array<String>, ?offset:Float = 0)
{
	for (i in 0...textArray.length)
	{
		var money:FlxText = new FlxText(0, 0, FlxG.width, textArray[i], 52);
		money.setFormat(Paths.font("DisneyFont.ttf"), 52, FlxColor.WHITE, "center");
		money.screenCenter(FlxAxes.X);
		money.y += (i * 60) + 200;
		credGroup.add(money);
		textGroup.add(money);
	}
}

function addMoreText(text:String, ?offset:Float = 0)
{
	var coolText:FlxText = new FlxText(0, 0, FlxG.width, text, 52);
	coolText.setFormat(Paths.font("DisneyFont.ttf"), 52, FlxColor.WHITE, "center");
	coolText.screenCenter(FlxAxes.X);
	coolText.y += (textGroup.length * 60) + 200;
	credGroup.add(coolText);
	textGroup.add(coolText);
}

function deleteCoolText()
{
	while (textGroup.members.length > 0)
	{
		credGroup.remove(textGroup.members[0], true);
		textGroup.remove(textGroup.members[0], true);
	}
}

function onBeatHit()
{
	if(!closedState) {
		FlxG.camera.zoom += 0.025;

		// logo doesn't have animation, we make one by ourselfs instead
		logoBl.scale.x += 0.03;
		logoBl.scale.y += 0.03;

		recycledText.scale.x += 0.03;
		recycledText.scale.y += 0.03;

		sickBeats += 1;
		switch (sickBeats)
		{
			case 1:
				createCoolText(["Goober (the guy with a -1.04 GPA)"], 15);
			case 3:
				addMoreText('Presents', 15);
			case 4:
				deleteCoolText();
			case 5:
				createCoolText(['Yet another...'], -40);
			case 7:
				addMoreText('...Restoration mod...', -40);
			case 8:
				deleteCoolText();
			case 9:
				createCoolText(["Now Running on..."], 15);
			case 11:
				addMoreText("Nightmare Vision", 15);
			case 12:
				deleteCoolText();
			case 13:
				addMoreText('Funkin');
			case 14:
				addMoreText('avi');
			case 15:
				addMoreText('Recycled');
			case 16:
				deleteCoolText();
			case 17:
				addMoreText('Enjoy');
			case 18:
				addMoreText('Your Stay...');
			case 19:
				if(!isTweenCancelled)
					fadeTween = FlxTween.tween(whiteFade, {alpha: 1}, 2, {ease: FlxEase.quartInOut});
			case 20:
				if(!isTweenCancelled) {
				fadeTween.cancel();
				whiteFade.alpha = 0;	
				}
				skipIntro();
		}
	}
}

function skipIntro():Void
{
	if (!skippedIntro)
	{
		remove(credGroup);
		FlxG.camera.flash(FlxColor.BLACK, 4);
	}

	isTweenCancelled = true;
	if (fadeTween != null) fadeTween.cancel();
	whiteFade.alpha = 0;

	skippedIntro = true;
}