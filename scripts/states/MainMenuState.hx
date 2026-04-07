import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import lime.system.System;

import funkin.states.editors.MasterEditorMenu;

import funkin.scripting.PluginsManager;

import funkin.utils.MathUtil;
import flixel.FlxObject;

import funkin.backend.PlayerSettings;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.app.Application;
import openfl.filters.ShaderFilter;

import funkin.states.options.OptionsState;
import funkin.states.MainMenuState;
import funkin.states.CreditsState;
import funkin.states.StoryMenuState;

using StringTools;

typedef Utils = 
{
    @:deprecated('text is no longer used! Use sendNotification instead')
    @:noCompletion
    /**
    * The main text for your notification
    */
    @:optional var text:String;

    @:deprecated('text is no longer used! Use sendNotification instead')
    @:noCompletion
    /**
    * The secondary text for your notification
    */
    @:optional var subText:String;

    /**
    * The font used for your notification box (affects both main and secondary text!)
    */
    @:optional var font:String;

    /**
    * The text color used for your notification box (affects both main and secondary text!)
    */
    @:optional var textColor:FlxColor;

    /**
    * The width of your notification box.
    */
    @:optional var boxWidth:Int;

    /**
    * The height of your notification box.
    */
    @:optional var boxHeight:Int;

    /**
    * The color of your notification box.
    */
    @:optional var boxColor:FlxColor;

    /**
    * The camera that will be present in your notification box (Uses the last camera of the `FlxG.cameras.list` list by default).
    */
    @:optional var camera:FlxCamera;
} 

var curSelected:Int = 0;

var menuItems:FlxTypedGroup;

var camFilter:FlxCamera;
var messager;

var controls = PlayerSettings.player1.controls;

var optionShit:Array<String> = [
	'story_mode',
	'freeplay',
	'credits',
	'options'
];

var menuart:FlxSprite;
var eyes:FlxSprite;
var finishedFunnyMove:Bool = false;

var holdTimer:Float = 0;

var defaultShader:FlxRuntimeShader;
var defaultShader2:FlxRuntimeShader;

var howmuchyoufuckinkeptdoingit:Int = 0;

function onCreate()
{
	Application.current.window.title = "Funkin.avi: Recycled - Main Menu";
	
	camFilter = new FlxCamera();
	camFilter.bgColor = 0x0;
	FlxG.cameras.add(camFilter, false);

	persistentUpdate = persistentDraw = true;

	eyes = new FlxSprite().loadGraphic(Paths.image('Funkin_avi/menu/HahaSadBoi'));
	eyes.scrollFactor.set(0, 0);
	eyes.screenCenter();
	eyes.updateHitbox();
	eyes.antialiasing = ClientPrefs.globalAntialiasing;
	add(eyes);

	menuart = new FlxSprite().loadGraphic(Paths.image('Funkin_avi/menu/newspaper'));
	menuart.scrollFactor.set(0, 0);
	//menuart.setGraphicSize(StdDaInt(menuart.width * 1.175));
	menuart.updateHitbox();
	menuart.screenCenter();
	menuart.antialiasing = ClientPrefs.globalAntialiasing;
	add(menuart);

	menuItems = new FlxTypedGroup();
	add(menuItems);

	var scale:Float = 0.8;

	for (i in 0...optionShit.length)
	{
		var menuItem:FlxSprite = new FlxSprite(700, 0);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + optionShit[i]);
		menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		switch (menuItem.ID)
		{
			case 0:
				menuItem.y = 100;
			case 1:
				menuItem.y = 250;
			case 2:
				menuItem.y = 425;
			case 3:
				menuItem.y = 600;
		}
	}

	final ver = 'Nightmare Vision Engine v${Main.NMV_VERSION}\nPsych Engine v${Main.PSYCH_VERSION}\nFriday Night Funkin\' v${Main.FUNKIN_VERSION}';
	
	final verionDesc:FlxText = new FlxText(12, 0, 0, ver, 22);
	verionDesc.setFormat(Paths.font('DisneyFont'), 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	verionDesc.borderSize = 1.5;
	verionDesc.y = FlxG.height - verionDesc.height - 12;
	verionDesc.scrollFactor.set();
	verionDesc.cameras = [camFilter];
	add(verionDesc);
	
	newBox(-400, FlxG.height - 80, {
		text: 'Freeplay is Locked!', 
		subText: 'Complete Episode 1 to Unlock this Menu!',
		boxHeight: 90,
		boxWidth: 600,
		font: 'DisneyFont.ttf',
		camera: camFilter
	});

	changeItem(0);

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

	scratchStuff.cameras = [camFilter];
	grain.cameras = [camFilter];

	if (FlxG.stage.window.title.contains('*cantaloupe jumpscare*'))
		cantaloupeJumpscare();

	if (Application.current.window.title.contains('10 Seconds before I shut your fucking game again >:('))
	{
		new FlxTimer().start(10, function(e)
		{
			System.exit(0);
		});
	}

	FlxTween.tween(FlxG.sound.music, {pitch: 1}, 1.2);
	
	defaultShader2 = newShader('monitorFilter');
	if(ClientPrefs.shaders)
	{
		FlxG.camera.filters = [new ShaderFilter(defaultShader2)];
	}
}

var selectedSomethin:Bool = false;

function onCloseSubState() {
	selectedSomethin = false;
}

function onUpdate(elapsed)
{
	if (FlxG.keys.pressed.R)
	{
		holdTimer += elapsed;
	}
	else
		holdTimer = 0;


	if (holdTimer >= 0.5)
	{
		openSubState(new ScriptedSubstate("resetSave"));
		persistentUpdate = false;
	}

	if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

	if (!selectedSomethin)
	{
		if (controls.UI_UP_P)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
			changeItem(-1);
		}

		if (controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));
			changeItem(1);
		}

		if (controls.BACK)
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new TitleState());
		}

		if (controls.ACCEPT)
		{
			if (optionShit[curSelected] == 'freeplay')
			{
				if (FlxG.save.data.episode1FPLock == "unlocked")
				{
					FlxG.sound.play(Paths.sound('funkinAVI/menu/selectSfx'));
					
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							// Main Menu Select Animations
							FlxTween.tween(FlxG.camera, {zoom: 1.15}, 2, {ease: FlxEase.quartInOut});
							FlxTween.tween(menuart, {x: -170}, 2.2, {ease: FlxEase.quartInOut});
							FlxTween.tween(menuart, {y: 200}, 1.9, {ease: FlxEase.quartInOut});
							FlxTween.tween(spr, {x: -250, alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								FlxG.switchState(new ScriptedState('EpicSelectorWOOO'));
							});
						}
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					sendMessage('Freeplay is locked!', 'Complete Episode 1 to Unlock this menu.');
				}
			}
			else
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('funkinAVI/menu/selectSfx'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						// Main Menu Select Animations
						FlxTween.tween(FlxG.camera, {zoom: 1.15}, 2, {ease: FlxEase.quartInOut});
						FlxTween.tween(menuart, {x: -170}, 2.2, {ease: FlxEase.quartInOut});
						FlxTween.tween(menuart, {y: 200}, 1.9, {ease: FlxEase.quartInOut});
						FlxTween.tween(spr, {x: -250, alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'story_mode':
									FlxG.switchState(new StoryMenuState());
								case 'credits':
									FlxG.switchState(new CreditsState());
								case 'options':
									FlxG.switchState(new OptionsState());
							}
						});
					}
				});
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (!ClientPrefs.inDevMode) 
				FlxG.switchState(new ScriptedState("SexState"));
			else
				FlxG.switchState(new MasterEditorMenu());
		}
		if (FlxG.keys.justPressed.ONE && ClientPrefs.inDevMode)
		{
			PluginsManager.callPluginFunc('GameData', 'fullSave');
			FlxG.sound.play(Paths.sound('funkinAVI/easterEggSound'));
		}		
		if (FlxG.keys.justPressed.TWO && ClientPrefs.inDevMode)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/easterEggSound'));
			FlxG.save.data.episode1FPLock = "unlocked";
			FlxG.save.flush();
		}
	}
}


function changeItem(huh:Int = 0)
{
	curSelected += huh;

	if (curSelected >= menuItems.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = menuItems.length - 1;

	menuItems.forEach(function(spr:FlxSprite)
	{
		spr.animation.play('idle');
		spr.updateHitbox();

		if (spr.ID == curSelected)
		{
			spr.animation.play('selected');
			var add:Float = 0;
			if(menuItems.length > 4) {
				add = menuItems.length * 8;
			}
			spr.centerOffsets();
		}
	});
}

function cantaloupeJumpscare()
{
	var cantaloupe = new FlxSprite(-200, -100).loadGraphic(Paths.image('Funkin_avi/cantaloupe'));
	cantaloupe.scale.set(0.05, 0.05);
	cantaloupe.screenCenter();
	FlxTween.tween(cantaloupe.scale, {x: 2, y: 2}, 3, {ease: FlxEase.bounceOut, onComplete: _ -> FlxTween.tween(cantaloupe, {alpha: 0}, 2)});
	add(cantaloupe);
	FlxG.camera.shake(0.02, 5);
	FlxG.sound.play(Paths.sound('funkinAVI/fnaf_jumpscare'), 0.7, false, null, true, () -> cantaloupe.destroy());
}

var box:FlxSprite;
var boxText:FlxText;
var boxSubText:FlxText;

// var onDeny = new FlxSignal();

var boxTween:FlxTween;
var boxTween2:FlxTween;
var boxTween3:FlxTween;

function newBox(x:Float = 0, y:Float = 0, utils:Utils) {
    // null checks
    if (utils.font == null) utils.font = 'vcr';
    if (utils.textColor == null) utils.textColor = FlxColor.WHITE;
    if (utils.boxWidth == null) utils.boxWidth = 360;
    if (utils.boxHeight == null) utils.boxHeight = 90;
    if (utils.boxColor == null) utils.boxColor = FlxColor.BLACK;
    if (utils.camera == null) utils.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

    boxText = new FlxText(x, y, 0, 'this is a text!', 24);
    boxText.setFormat(Paths.font(utils.font), 32, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    boxText.scrollFactor.set();
    boxText.camera = utils.camera;

    boxSubText = new FlxText(x, boxText.y + 30, 0, 'this is a subtext!', 24);
    boxSubText.setFormat(Paths.font(utils.font), 24, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    boxSubText.scrollFactor.set();
    boxSubText.camera = utils.camera;

    box = new FlxSprite(x, boxText.y).makeGraphic(utils.boxWidth, utils.boxHeight, utils.boxColor);
    box.scrollFactor.set();
    box.camera = utils.camera;

    box.alpha = boxText.alpha = boxSubText.alpha = 0;

    add(box);
    add(boxText);
    add(boxSubText);
}

/**
    * Send a `MessageBox` message to the game.
    * @param text the principal piece of text of your notification.
    * @param subText the secondary piece of text of your notification.
    */
function sendMessage(text:String = 'text', subText:String = '')
{
    if (boxTween != null)
        boxTween.cancel();
    if (boxTween2 != null)
        boxTween2.cancel();
    if (boxTween3 != null)
        boxTween3.cancel();

    boxText.text = text;
    boxSubText.text = subText;

    boxTween = FlxTween.tween(boxText, {
        alpha: 1,
        x: 0
    }, 0.8, {
        ease: FlxEase.sineOut,
        onComplete: function(twn:FlxTween)
        {
            boxTween = FlxTween.tween(boxText, {
                alpha: 0,
                x: -400
            }, 1.5, {
                startDelay: 3,
                ease: FlxEase.sineInOut,
                onComplete: function(twn:FlxTween)
                {
                    boxTween = null;
                }
            });
        }
    });
    boxTween2 = FlxTween.tween(boxSubText, {
        alpha: 1,
        x: 0
    }, 0.8, {
        ease: FlxEase.sineOut,
        onComplete: function(twn:FlxTween)
        {
            boxTween2 = FlxTween.tween(boxSubText, {
                alpha: 0,
                x: -400
            }, 1.5, {
                startDelay: 3,
                ease: FlxEase.sineInOut,
                onComplete: function(twn:FlxTween)
                {
                    boxTween2 = null;
                }
            });
        }
    });
    boxTween3 = FlxTween.tween(box, {
        alpha: 1,
        x: 0
    }, 0.8, {
        ease: FlxEase.sineOut,
        onComplete: function(twn:FlxTween)
        {
            boxTween3 = FlxTween.tween(box, {
                alpha: 0,
                x: -400
            }, 1.5, {
                startDelay: 3,
                ease: FlxEase.sineInOut,
                onComplete: function(twn:FlxTween)
                {
                    boxTween3 = null;
                }
            });
        }
    });
}