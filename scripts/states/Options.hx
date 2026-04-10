import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxG;

import openfl.filters.ShaderFilter;

import funkin.states.options.NoteSettingsSubState;
import funkin.states.options.ControlsSubState;
import funkin.states.options.GraphicsSettingsSubState;
import funkin.states.options.VisualsUISubState;
import funkin.states.options.GameplaySettingsSubState;
import funkin.states.options.MiscSubState;
import funkin.states.options.OptionsState;
import funkin.states.MainMenuState;

import lime.app.Application;

using StringTools;

var options:Array<String> = [
    'Controls',
    'Graphics',
    'Visuals and UI',
    'Gameplay',
    "NMV"
];
var grpOptions:FlxTypedGroup;
var curSelected:Int = 0;
var menuBG:FlxSprite;

var selectorLeft:Alphabet;
var selectorRight:Alphabet;

var controls = Controls.instance;

function openSelectedSubstate(label:String) {
    switch(label) {
        case 'Controls':
            openSubState(new ControlsSubState());
        case 'Graphics':
            openSubState(new GraphicsSettingsSubState());
        case 'Visuals and UI':
            openSubState(new VisualsUISubState());
        case 'Gameplay':
            openSubState(new GameplaySettingsSubState());
        case 'NMV':
            openSubState(new MiscSubState());
    }
    persistentUpdate = false;
}

function onCreate() {
    if (ClientPrefs.shaders) {
        FlxG.camera.filters = [
            new ShaderFilter(newShader("grayScale")),
            new ShaderFilter(newShader('monitorFilter'))
        ];
    }

    Application.current.window.title = "Funkin.avi: Recycled - Options Menu";

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
    bg.color = 0xFFea71fd;
    bg.updateHitbox();
    
    bg.screenCenter();
    add(bg);

    grpOptions = new FlxTypedGroup();
    add(grpOptions);

    for (i in 0...options.length)
    {
        var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
        optionText.screenCenter();
        optionText.y += (100 * (i - (options.length / 2))) + 50;
        grpOptions.add(optionText);
    }

    selectorLeft = new Alphabet(0, 0, '>', true, false);
	add(selectorLeft);
	selectorRight = new Alphabet(0, 0, '<', true, false);
	add(selectorRight);

    changeSelection();
    ClientPrefs.flush();
    
    if(!ClientPrefs.lowQuality)
	{
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
}

function onCloseSubState() {
	persistentUpdate = true;

	ClientPrefs.flush();
}

function onUpdate(elapsed:Float) {
    if (controls.UI_UP_P) {
        changeSelection(-1);
    }
    if (controls.UI_DOWN_P) {
        changeSelection(1);
    }

    if (controls.BACK)
    {
        FlxG.sound.play(Paths.sound('cancelMenu'));
        if (OptionsState.onPlayState) 
        {
            FlxG.switchState(() -> {
                new PlayState();
            });
        } else {
            FlxG.switchState(() -> {
                new MainMenuState();
            });
        }
    }

    if (controls.ACCEPT) {
        openSelectedSubstate(options[curSelected]);
    }
}

function changeSelection(?change:Int = 0) {
    curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);

    var bullShit:Int = 0;

    for (item in grpOptions.members) {
        item.targetY = bullShit - curSelected;
        bullShit += 1;

        item.alpha = 0.6;
        if (item.targetY == 0) {
            item.alpha = 1;
            selectorLeft.x = item.x - 63;
            selectorLeft.y = item.y;
            selectorRight.x = item.x + item.width + 15;
            selectorRight.y = item.y;
        }
    }

    FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
}