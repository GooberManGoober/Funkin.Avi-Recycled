import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import lime.system.System;

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

var windowShit:Array<Any> = [
	"Anyone up right now?",
	"Shipy's SNS Mickey & F.AVI Mickey would make love to each other",
	"We lied about Episode 2's release...",
	"I trapped don in my basement.",
	"Someone put an end to my misery.",
	"I dare you to press 7 on that keyboard of yours.",
	"Cock & ball torture.",
	"OKAY, YOU GOT DELUSIONAL, NOW STFU.",
	"Look at that cute little devil, he's cute :)",
	"Do you like the new menu art?",
	"You're gonna love the final song.",
	"Malfunction isn't easy anymore, fuck you, skill issue.",
	"SOMEONE PLEASE GIVE MICKEY HIS FUCKING SANDVICH", // intentional misspell lolol
	"Have fun, you'll be here for like an hour or longer.",
	"10 Seconds before I shut your fucking game again >:(",
	"Oh the misery, everybody wants to be my enemy.",
	"Sex, NOW.",
	"Quick, hide behind that conveniently shaped lamp!",
	"Welcome to hell",
	"blue lobster *jumpscare*",
	"hi. *starts dancing on the floor*",
	"sample text 2: electric boogaloo",
	"The bastard named squidward cheated on poor mickey :[",
	"D E A T H",
	"Man i'm hungry",
	"Shit, the mouse got a gun again.",
	"You should /kill @s NOW", // haha, funi Minecraft reference
	"Why are you here? FNF is still cancelled.",
	"This community is fr the big stinky.",
	"Go ahead, cancel us, you'll only make us come back stronger.",
	"NOOOOOOOOOOO, YOU CAN'T JUST CHEAT THE GAME!!!!!!!",
	"Mom, can we have Wednesday's Infidelity?",
	"WHAT THE FUCK IS A KILOMETER?",
	"Don't leave Muckney's party, please, you'll make him sad if you do :(",
	"It's about drive, it's about power, we stay hungry, we devour.",
	"Peter, the horse is here.",
	"*horse walks in*",
	"When she Isolated on my Lunacy til I Delusional.",
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
	"awesome mouse experience.",
	"This mod was stressful to make.",
	"Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled - Funkin.avi: Recycled",
	"Just like Domingo is constantly remaking Mickey's sprites, Dreupy is the Domingo of Delusional Recharts.",
	"When did Funkin.avi start development?",
	"I think one of the codes is a certain date",
	"The idea of the mod was created on 21/03/22, pretty crazy, right?",
	"Everyday is Muckney's Birthday",
	"there is no message, go play some minecraft",
	"THEY HIT THE FUCKING PENTAGON",
	"Want a break from the ads? If you tap now to take a short servey, you'll recieve 30 minutes of ad-free music.",
	"I bet you're complaining that this isn't easy to steal assets from right about now, silly kiddo",
	"Development was so long Mickey died of waiting",
	"um um um um um um um",
	"uhuhuhuh",
	"women.",
	"men."
];

function onCreate()
{
	FlxG.mouse.load(Paths.image('Funkin_avi/Hand').bitmap);
	if (!FlxG.mouse.visible) FlxG.mouse.visible = true;

	Application.current.window.title = "Funkin.avi: Recycled - " + windowShit[FlxG.random.int(0, windowShit.length - 1)];
	
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
	if(optionShit.length > 6) {
		scale = 0.6 / optionShit.length;
	}

		// Story Mode
		var menuItem:FlxSprite = new FlxSprite(700, 100);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[0]);
		menuItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 0;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 0;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		// Freeplay
		var menuItem:FlxSprite = new FlxSprite(700, 250);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[1]);
		menuItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 1;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 1;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		// Credits
		var menuItem:FlxSprite = new FlxSprite(700, 425);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[2]);
		menuItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 2;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 2;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();
		
		// Settings
		var menuItem:FlxSprite = new FlxSprite(700, 600);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[3]);
		menuItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 3;
		//menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.135;
		if(optionShit.length < 6) scr = 3;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();
		
	var versionShit:FlxText = new FlxText(12, FlxG.height - 84, 0, "Funkin.avi v2.0.0", 12);
	versionShit.scrollFactor.set();
	versionShit.setFormat(Paths.font("DisneyFont.ttf"), 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	versionShit.cameras = [camFilter];
	add(versionShit);

	var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Nightmare Vision Engine v" + Main.NMV_VERSION, 12);
	versionShit.scrollFactor.set();
	versionShit.setFormat(Paths.font("DisneyFont.ttf"), 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	versionShit.cameras = [camFilter];
	add(versionShit);

	var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Friday Night Funkin' v0.2.8", 12);
	versionShit.scrollFactor.set();
	versionShit.setFormat(Paths.font("DisneyFont.ttf"), 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	versionShit.cameras = [camFilter];
	add(versionShit);

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
		coolMenuEvents(3);

	if (Application.current.window.title.contains('10 Seconds before I shut your fucking game again >:('))
	{
		new FlxTimer().start(10, function(e)
		{
			System.exit(0);
		});
	}
	
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
			FlxG.switchState(new ScriptedState('TitleState'));
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
									FlxG.mouse.visible = false;
									FlxG.switchState(new ScriptedState('StoryMenu'));
								case 'credits':
									FlxG.mouse.visible = false;
									FlxG.switchState(new ScriptedState('CreditsMenu'));
								case 'options':
									OptionsState.onPlayState = false;
									FlxG.switchState(new ScriptedState('Options'));
							}
						});
					}
				});
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new ScriptedState("SexState"));
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

function coolMenuEvents(getEvent:Int)
{
	switch (getEvent)
	{
		case 1:
			var redGradient:FlxSprite = new FlxSprite(0, 0, Paths.image('Funkin_avi/filters/redGradient'));
			redGradient.setGraphicSize(Std.int(redGradient.width * 0.7));
			redGradient.screenCenter();
			redGradient.cameras = [camFilter];
			FlxTween.tween(redGradient, {alpha: 0}, 0.9, {onComplete: sex -> redGradient.destroy()});
			add(redGradient);
			FlxG.sound.play(Paths.sound('funkinAVI/oof'), 1, false, null, true);

		case 3:
			var cantaloupe = new FlxSprite(-200, -100).loadGraphic(Paths.image('Funkin_avi/cantaloupe'));
			cantaloupe.scale.set(0.05, 0.05);
			cantaloupe.screenCenter();
			FlxTween.tween(cantaloupe.scale, {x: 2, y: 2}, 3, {ease: FlxEase.bounceOut, onComplete: _ -> FlxTween.tween(cantaloupe, {alpha: 0}, 2)});
			add(cantaloupe);
			FlxG.camera.shake(0.02, 5);
			FlxG.sound.play(Paths.sound('funkinAVI/fnaf_jumpscare'), 0.7, false, null, true, () -> cantaloupe.destroy());

		case 4:
			if (FlxG.save.data.birthdayLocky == "obtained" || FlxG.save.data.birthdayLocky == "beaten")
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				switch(howmuchyoufuckinkeptdoingit) {
					case 0:
						sendMessage('You\'ve already unlocked this song!', 'Go to freeplay to play the song.');
					case 1:
						sendMessage('Can\'t you understand?', 'You already unlocked the song.');
					case 2:
						sendMessage('Can\'t you read?', 'This. Is. Already. Unlocked.');
					case 3:
						sendMessage('go to freeplay menu.', 'its already unlocked.');
					case 4:
						sendMessage('IF YOU KEEP DOING IT THEN', 'IM GONNA DO SOMETHING BAD');
					case 5:
						sendMessage('...', 'Im closing the game. Fuck you');
						new FlxTimer().start(2, function(tmr:FlxTimer){
							System.exit(0);
						});
				}
				howmuchyoufuckinkeptdoingit++;
			}
			else
			{
				FlxG.save.data.birthdayLocky = 'obtained';

				FlxG.save.flush();
				FlxG.sound.play(Paths.sound('funkinAVI/easterEggSound'));
				sendMessage('Something has unlocked!', 'Check freeplay to see what has been unlocked.');
			}
	}
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