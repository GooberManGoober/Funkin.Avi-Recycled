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

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.app.Application;

import funkin.states.options.OptionsState;
import funkin.states.MainMenuState;
import funkin.states.CreditsState;
import funkin.states.StoryMenuState;
import funkin.states.TitleState;
import funkin.states.FreeplayState;

using StringTools; 

var curSelected:Int = 0;

var menuItems:FlxTypedGroup;

var camFilter:FlxCamera;

var controls = Controls.instance;

var optionShit:Array<String> = [
	'story_mode',
	'freeplay',
	'credits',
	'options'
];
var windowShit:Array<Any> = [
	"Anyone up right now?",
	"Shipy's SNS Mickey & F.AVI Mickey will make love to each other",
	"We lied about Episode 2's release...",
	"I trapped Demolition in my basement.",
	"V3 will release next year, we need a fucking break",
	"Someone put an end to my misery. - Mickey 2023",
	"I dare you to press 7 on that keyboard of yours.",
	"Cock & ball torture.",
	"Look at that cute little devil, he c00t :3",
	"Do you like the new menu art?",
	"You're gonna love the final song.",
	"Malfunction isn't easy anymore, fuck you, skill issue B)",
	"Happy Birthday Muckney!",
	"Psych Engine basically corrupted all our shit, which is why it's on Another Engine now.",
	"SOMEONE PLEASE GIVE MICKEY HIS FUCKING SANDWICH",
	"Have fun, you'll be here for like an hour or longer.",
	"10 Seconds before I shut your fucking game again >:(",
	"Oh the misery, everybody wants to be my enemy.",
	"Sex, NOW.",
	"Quick, hide behind that conveniently shaped lamp!",
	"Welcome to hell",
	"blue lobster *jumpscare*",
	"hi. *starts dancing on the floor*",
	"sample text 2: electric boogaloo",
	"The bastard named squidward cheated on poor mickey :(",
	"D E A T H",
	"Man, i'm starving... *Fight or Flight plays*",
	"Shit, the mouse got a gun again.",
	"You should /kill @s NOW", // haha, funi Minecraft reference
	"Why are you here? FNF is still cancelled.",
	"This community is fr the big stinky.",
	"Go ahead, cancel us, you'll only make us come back stronger.",
	"NOOOOOOOOOOO, YOU CAN'T JUST CHEAT THE GAME!!!!!!!",
	"V3 Update in a Nutshell: Suicidal Remixes",
	"Mom, can we have Wednesday's Infidelity?",
	"GUYS, LOOK, IT'S SHIPY, SAY HELLO TO HER! :D",
	"Don't leave Muckney's party, please, you'll make him sad if you do :(",
	"It's about drive, it's about power, we stay hungry, we devour.",
	"Peter, the horse is here.",
	"*horse walks in*",
	"Anyone here watch Yahiamice?",
	"*cantaloupe jumpscare*",
	"Prank 'em John",
	"POV: You're a YouTuber doing some generic intro right about now",
	"Another very well thought out idea of a random message that this game can randomly pick from within the code.",
	"AHHH, FUCK, THERE'S RULE 34 OF SUICIDE MOUSE, WHYYYYYY????",
	"Check out this cool rare little easter egg that I found, which I want to show to you but I can't cause I'm just a title screen message.",
	"There's still uranium in my ass, send help.",
	"Main Menu Music: Alone",
	"Mickey lost his ballsack.",
	"Oh the horror of AI generated images.",
	"You should [R] Reset Character NOW", // boblox reference
	"peak mouse experience.",
	"Austin is the most horniest of the team lmao",
	"This mod was stressful to make, the organization was a mess lmao",
	"Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled",
	"Just like Domingo is constantly remaking Mickey's sprites, Dreupy is the Domingo of Delusional Recharts.",
	"When did Funkin.avi start development?",
	"I think one of the codes is a certain date",
	"This mod was an idea that started on 03/21/22, pretty crazy, right?",
	"Everyday is Muckney's Birthday",
	"there is no message, go play some minecraft",
	"THEY HIT THE FUCKING PENTAGON, SMILES",
	"Want a break from the ads? If you tap now to take a short servey, you'll recieve 30 minutes of ad-free music.",
	"FUCK YOU 8D!!!!!"
];

var menuart:FlxSprite;
var eyes:FlxSprite;
var finishedFunnyMove:Bool = false;

var holdTimer:Float = 0;

var howmuchyoufuckinkeptdoingit:Int = 0;

function onCreate()
{
	// shutdowns the game
	if (Application.current.window.title.contains('10 Seconds before I shut your fucking game again >:('))
	{
		new FlxTimer().start(10, function(e)
		{
			System.exit(0);
		});
	}
	
	camFilter = new FlxCamera();
	camFilter.bgColor = 0x0;
	FlxG.cameras.add(camFilter, false);

	persistentUpdate = persistentDraw = true;

	eyes = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/HahaSadBoi'));
	eyes.scrollFactor.set(0, 0);
	eyes.screenCenter();
	eyes.updateHitbox();
	eyes.antialiasing = ClientPrefs.globalAntialiasing;
	add(eyes);

	menuart = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/newspaper'));
	menuart.scrollFactor.set(0, 0);
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
		menuItem.scale.set(scale, scale);
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + optionShit[i]);
		menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();

		switch (menuItem.ID)
		{
			case 0:
				menuItem.y = 75;
			case 1:
				menuItem.y = 225;
				if (FlxG.save.data.episode1FPLock != 'unlocked') 
					menuItem.color = FlxColor.GRAY;
				else
					menuItem.color = FlxColor.WHITE;
			case 2:
				menuItem.y = 400;
			case 3:
				menuItem.y = 575;
		}
	}

	var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, FlxColor.BLACK);
	textBG.cameras = [camFilter];
	add(textBG);

    var botplaytext:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press TAB to see extra menu options', 18);
	botplaytext.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, "center");
	botplaytext.scrollFactor.set();
	botplaytext.cameras = [camFilter];
	add(botplaytext);

	final ver = 'Nightmare Vision Engine v${Main.NMV_VERSION}\nPsych Engine v${Main.PSYCH_VERSION}\nFriday Night Funkin\' v${Main.FUNKIN_VERSION}';
	
	final verionDesc:FlxText = new FlxText(12, 0, 0, ver, 22);
	verionDesc.setFormat(Paths.font('DisneyFont'), 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	verionDesc.borderSize = 1.5;
	verionDesc.y = FlxG.height - verionDesc.height - 22;
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

	scratchStuff.cameras = [camFilter];
	grain.cameras = [camFilter];

	if (FlxG.stage.window.title.contains('*cantaloupe jumpscare*')) coolMenuEvents(1);

	Application.current.window.title = "Funkin.avi - " + windowShit[FlxG.random.int(0, windowShit.length - 1)];

	// shutdowns the game
	if (Application.current.window.title.contains('10 Seconds before I shut your fucking game again >:('))
	{
		new FlxTimer().start(10, function(e)
		{
			System.exit(0);
		});
	}

	FlxTween.tween(FlxG.sound.music, {pitch: 1}, 1.2);
}

var selectedSomethin:Bool = false;

function onCloseSubState()
{
	selectedSomethin = false;
}

function onUpdate(elapsed)
{
	if (FlxG.keys.pressed.TAB)
	{
		openSubState(new ScriptedSubstate("MenuSelector"));
		persistentUpdate = false;
	}

	if (FlxG.keys.justPressed.R) coolMenuEvents(0);

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

		if(FlxG.mouse.wheel != 0)
		{
			FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'), 0.2);
			changeItem(-FlxG.mouse.wheel);
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
								FlxG.switchState(new FreeplayState());
							});
						}
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					sendMessage();
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
			if (!ClientPrefs.inDevMode) FlxG.switchState(new ScriptedState("SexState"));
			else FlxG.switchState(new MasterEditorMenu());
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

	if (curSelected >= menuItems.length) curSelected = 0;
	if (curSelected < 0) curSelected = menuItems.length - 1;

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

function coolMenuEvents(getEvent:Int)
{
	switch (getEvent)
	{
		case 0:
			var redGradient:FlxSprite = new FlxSprite(0, 0, Paths.image('filters/redGradient'));
			redGradient.setGraphicSize(Std.int(redGradient.width * 0.7));
			redGradient.screenCenter();
			redGradient.cameras = [camFilter];
			FlxTween.tween(redGradient, {alpha: 0}, 0.9, {onComplete: sex -> redGradient.destroy()});
			add(redGradient);
			FlxG.sound.play(Paths.sound('funkinAVI/oof'), 1, false, null, true);

		case 1:
			var cantaloupe = new FlxSprite(-200, -100).loadGraphic(Paths.image('menus/mainmenu/cantaloupe'));
			cantaloupe.scale.set(0.05, 0.05);
			cantaloupe.screenCenter(FlxAxes.XY).x -= 700;
			cantaloupe.y -= 300;
			FlxTween.tween(cantaloupe.scale, {x: 2, y: 2}, 3, {ease: FlxEase.bounceOut, onComplete: _ -> FlxTween.tween(cantaloupe, {alpha: 0}, 2)});
			cantaloupe.shake(.05, 0, 5);
			add(cantaloupe);
			FlxG.camera.shake(0.02, 5);
			FlxG.sound.play(Paths.sound('funkinAVI/fnaf_jumpscare'), 0.7, false, null, true, () -> cantaloupe.destroy());
	}
}

/**
 * The functions for the message box
 */

typedef Utils = 
{
    @:noCompletion
    /**
    * The main text for your notification
    */
    @:optional var text:String;

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

var box:FlxSprite;
var boxText:FlxText;
var boxSubText:FlxText;

var boxTween:FlxTween;
var boxTween2:FlxTween;
var boxTween3:FlxTween;

function newBox(x:Float = 0, y:Float = 0, utils:Utils)
{   
    // null checks
    if (utils.font == null) utils.font = 'vcr';
    if (utils.text == null) utils.text = 'this is a text!';
    if (utils.subText == null) utils.subText = 'this is a subtext!';
    if (utils.textColor == null) utils.textColor = FlxColor.WHITE;
    if (utils.boxWidth == null) utils.boxWidth = 360;
    if (utils.boxHeight == null) utils.boxHeight = 90;
    if (utils.boxColor == null) utils.boxColor = FlxColor.BLACK;
    if (utils.camera == null) utils.camera = CameraUtil.lastCamera;

    box = new FlxSprite(x, y).makeGraphic(utils.boxWidth, utils.boxHeight, utils.boxColor);
    box.scrollFactor.set();
    box.alpha = 0;
	box.camera = utils.camera;
    add(box);

    boxText = new FlxText(x, y, 0, utils.text, 24);
    boxText.setFormat(Paths.font(utils.font), 32, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    boxText.scrollFactor.set();
    boxText.alpha = 0;
	boxText.camera = utils.camera;
    add(boxText);

    boxSubText = new FlxText(x, y + 30, 0, utils.subText, 24);
    boxSubText.setFormat(Paths.font(utils.font), 24, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    boxSubText.scrollFactor.set();
    boxSubText.alpha = 0;
	boxSubText.camera = utils.camera;
    add(boxSubText);
}

function sendMessage()
{
    if (boxTween != null)
        boxTween.cancel();
    if (boxTween2 != null)
        boxTween2.cancel();
    if (boxTween3 != null)
        boxTween3.cancel();
    
    boxTween = FlxTween.tween(boxText, {alpha: 1, x: 0}, 0.8, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
        {
            boxTween = FlxTween.tween(boxText, {alpha: 0, x: -400}, 1.5, {startDelay: 3, ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                {
                    boxTween = null;
                }
            });
        }
    });

    boxTween2 = FlxTween.tween(boxSubText, {alpha: 1, x: 0}, 0.8, {ease: FlxEase.sineOut,onComplete: function(twn:FlxTween)
        {
            boxTween2 = FlxTween.tween(boxSubText, {alpha: 0, x: -400}, 1.5, {startDelay: 3, ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                {
                    boxTween2 = null;
                }
            });
        }
    });

    boxTween3 = FlxTween.tween(box, {alpha: 1, x: 0}, 0.8, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween)
        {
            boxTween3 = FlxTween.tween(box, {alpha: 0, x: -400}, 1.5, {startDelay: 3, ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
                {
                    boxTween3 = null;
                }
            });
        }
    });
}