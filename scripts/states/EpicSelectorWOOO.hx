import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.app.Application;
import openfl.filters.ShaderFilter;
import funkin.backend.PlayerSettings;
using StringTools;

var freeplayCats:Array<String> = ['Story', 'Extras'];
var grpCats:FlxTypedGroup;
var curSelected:Int = 0;
var BG:FlxSprite;
var defaultShader2:FlxRuntimeShader;

var controls = PlayerSettings.player1.controls;

function onCreate()
{
	BG = new FlxSprite().loadGraphic(Paths.image('Funkin_avi/freeplay/menuFreeplay'));
	BG.updateHitbox();
	BG.screenCenter();
	add(BG);

	defaultShader2 = newShader('monitorFilter');

	if(!ClientPrefs.lowQuality && ClientPrefs.shaders) 
	{
		FlxG.camera.filters = [new ShaderFilter(defaultShader2)];
	}

	Application.current.window.title = "Funkin.avi: Recycled - Freeplay: Category Menu";

	grpCats = new FlxTypedGroup();
	add(grpCats);

	for (i in 0...freeplayCats.length)
	{
		var catsText:Alphabet = new Alphabet(5, 320, freeplayCats[i], true, false);
		catsText.isMenuItem = true;
		catsText.changeAxis = FlxAxes.Y;
		catsText.targetY = i;
		catsText.snapToTarget();
		catsText.screenCenter(FlxAxes.X);
		grpCats.add(catsText);
	}

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
	}

	changeSelection();
}

function onUpdate(elapsed)
{
	if (controls.UI_UP_P) 
		changeSelection(-1);
	
	if (controls.UI_DOWN_P) 
		changeSelection(1);

	if (controls.BACK) 
	{
		Conductor.bpm = (60);
		FlxG.sound.play(Paths.sound("cancelMenu"));
		FlxG.switchState(new ScriptedState('MainMenuState'));
	}

	if (controls.ACCEPT)
	{
		FlxG.save.data.freeplayMenuList = curSelected;
		FlxG.save.flush();
		FlxG.switchState(new ScriptedState('FreeplayState'));
	}
}

function changeSelection(?change:Int = 0) 
{
	curSelected = FlxMath.wrap(curSelected + change, 0, freeplayCats.length - 1);

	FlxG.save.data.freeplayMenuList = curSelected;
	FlxG.save.flush();

	var bullShit:Int = 0;

	for (item in grpCats.members) 
	{
		item.targetY = bullShit - curSelected;
		bullShit += 1;

		item.alpha = 0.6;
		if (item.targetY == 0) {
			item.alpha = 1;
		}
	}

	FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
}