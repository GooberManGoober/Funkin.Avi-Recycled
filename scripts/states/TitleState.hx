import lime.system.System;
import flixel.text.FlxText;
import sys.io.File;

import lime.app.Application;
import funkin.FunkinAssets;

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

var fade:FlxSprite;

var logoBl:FlxSprite;
var recycledText:FlxText;
var gfDance:FlxSprite;
var danceLeft:Bool = false;
var titleText:FlxText;

var skippedIntro:Bool = false;

var windowArray:Array<Any> = [
	"Also try Your Mom Simulator",
	"Imagine making yet another Suicide Mouse mod?",
	"Comically Large Spoon",
	"snas uddertail",
	"K i l l .",
	"Mr. Smile & White Noise are dating, this is canon.",
	"Fun Fact: Beep Bap Brip Skippity Bop",
	"3 Episodes are here, WOOOOOO",
	"Sample Text",
	"Shipy's SNS was peak, frfr",
	"Stfu, I'm playing Minecraft",
	"Stfu, I'm playing Fortnite",
	"RIP: Suicidal Remixes.",
	"Why did BF & GF enter these horrific cartoons in the first place?",
	"Muckney.mp4, realest one out there.",
	"We late, but we late in style",
	"ur adopted *epic roast 2022*",
	"MOUSE RAP. MOUSE RAP",
	"I'm shutting down your game now, fuck you",
	"How's life, buddy?",
	"mmmm, B E A N S .",
	"Grunt mod real.",
	"Vs Dead Bart is cancelled",
	"Funkin.exe is the next best thing",
	"Hi, wanna see me glitch?",
	"R.I.P: Welcome Old (Definitely The Best Banger Ever) /j",
	"POV: Your Mom",
	".edud ssarg emos hcuot og ot deen uoy ,das yrev tsuj ,yltsenoh ,das si thaT ?sdrawkcab txet siht fo lla gnidaer otni troffe hcum os gnittup enigamI - iva.niknuF",
	"Play Wednesday's Infidelity!",
	"Now with more depression!",
	"Now with more suicide!",
	"FNAF but with mice",
	"No, we're not doing thicc GF fan-service art",
	"Ben didn't drown, he sucked on Deez Nuts",
	"What the fuck do you mean 'we have a couch song'?",
	"Next Update: Malfunction will be more 'balanced' *wink wink*",
	"I have your IP Address: 103.189.166.35",
	"fuckin.mp3 - i juss shat meseff",
	"Subscribe to Yama haki and DEMOLITIONDON96 (haha, yes, shameless advertising)",
	"Fun Fact: I inhaled your mom last night",
	"a",
	" ",
	"What do you want me to say?",
	"I'm running out of things to say here...",
	"This random message serves no purpose to the game or the lore",
	"I'm DEAAAAAAAAAAAAD *plays Monochrome*",
	"Ah yes, this is a very original and very well thought out message for the game to randomly pick",
	"Stop asking for art of official female versions of the characters in this mod",
	"Help, my basement full of children I kidnapped is screaming, what do I do?",
	"I got uranium up my ass",
	"The horny detector has detected someone here in this game, I wonder who it is...",
	"Fuck you *undicks your Snickers*",
	"MCM is a good mod",
	"h o g .",
	"HOOOG RIDDDAAAAAAAAAAAA *plays Clash Royale loading screen theme*",
	"WE ARE GOING TO BEAT YOU TO DEATH.",
	"X2 Remixes are real.",
	//Community-Made Random Messages
	"A mod about a very unfortunate mouse.",
	"Imagine Having More Than 50 Members?!?!?!",
	"Its been 40 years and the mouse still hasn't regained sanity",
	"freddy fazbear.",
	"We don't know what to do with the tons of extras for V3 :/",
	"Mickeys are gonna need a big bed that's for sure",
	"Among us is not funny *nerd face*",
	"Discord bots are goofy aaaahhhhh",
	"Whoopsie looks like i gave the suicidal mouse a gun",
	"This is the window title 69, literally", //funi number
	"What the dog doin?",
	"Check us out on Friday Night Bloxxin' on Roblox!",
	"There's a Red Spy in the Base!!",
	"fuckin: restored.mp3 - jsjsjsdjdsjdsjadsjjads",
	"Lemon Demon got no iPhone",
	"The Update Y'all were waiting",
	"Mickey finds the forbidden sandwich",
	"Dev Note: Add a bomb shop link in the messages",
	"We literally improved everything for prevent hating",
	"Go touch grass",
	"Mod Includes: PC Crashing and Banger Songs",
	"Stop saying the square's name is Theodore!",
	"Let's be honest, Mods are carrying FNF",
	"Now better than ever!",
	"Over 100+ Messages!",
	"Your childhood friend is back!",
	"Youtube Kids is the best at having totally not bad videos!",
	"People skip this part, let's be honest",
	"when he, when he at the, he at the street, the street next door.",
	"fnf is cancelled go home.",
	"I've entered the mainframe, PREPARE TO LOSE YOUR PC!",
	"I live in your walls.",
	"saster my beloved",
	"Send help, I've spent 1 year coding for this mod",
	"You found the Most Difficult message ever!!!1111!1",
	"Congratulations, you won, now get out.",
	"I ate your doorframe now.",
	"No leakers allowed ):d",
	"Imagine the credits for the messages",
	"Mickey getting bitches, 100% real no fake",
	"Lets Goku mcdonalds, Y'know what im saiyan?",
	"Walter",
	"T H E  'C O R E', D E S T R O Y  I T !",
	"THE 'CORE' CONTAINS THE EVIL"
];

var controls = Controls.instance;

var transitioning:Bool = false;
var playJingle:Bool = false;

var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
var closedState:Bool = false;

function onCreate()
{	
	Application.current.window.title = 'Funkin.avi: Recycled - ${windowArray[FlxG.random.int(0, windowArray.length-1)]}';

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

	recycledText = new FlxText(215, 515, 1200, "Recycled", 96);
	recycledText.setFormat(Paths.font('DisneyFont.ttf'), 50, FlxColor.fromRGB(255, 255, 255), "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	recycledText.borderSize = 1.5;
	recycledText.antialiasing = ClientPrefs.globalAntialiasing;
	recycledText.screenCenter(FlxAxes.X).x += 15;
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

	if (initialized) skipIntro();
	else initialized = true;
}

function onUpdate(elapsed)
{
	if (FlxG.sound.music != null && FlxG.sound.music.playing) Conductor.songPosition = FlxG.sound.music.time;

	var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

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
				FlxG.switchState(new MainMenuState());
			});
		}
	}

	if (initialized && pressedEnter && !skippedIntro) skipIntro();

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

var curBeat = 0;

function onBeatHit()
{
	curBeat += 1;
	
	if(!closedState)
	{
		FlxG.camera.zoom += 0.025;

		// logo doesn't have animation, we make one by ourselfs instead
		logoBl.scale.x += 0.03;
		logoBl.scale.y += 0.03;

		recycledText.scale.x += 0.03;
		recycledText.scale.y += 0.03;

		switch (curBeat)
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
				if(!isTweenCancelled) 
				{
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

function windowFixesAndEvents()
{
	if(Application.current.window.title.contains("Funkin.avi: Recycled - Hi, wanna see me glitch?"))
	{
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			Application.current.window.title = "Funkin.avi: Recycled - I'm starting to glitch now, oooooo";
			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				Application.current.window.title = "Funkin.avi: Recycled - That's cool, ain't it?";
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					Application.current.window.title = "Funkin.avi: Recycled - Wait...";
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						Application.current.window.title = "Funkin.avi: Recycled - What's going on here?";
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							Application.current.window.title = "Funkin.avi: Recycled - Why am I still glitching?";
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								Application.current.window.title = "Funkin.avi: Recycled - oh no...";
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									Application.current.window.title = "Funkin.avi: Recycled - oh god, oh fuck, PLAYER, PLEASE HELP ME!";
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										Application.current.window.title = "Funkin.avi: Recycled - I BEG OF YOU";
										new FlxTimer().start(1, function(tmr:FlxTimer)
										{
											Application.current.window.title = "Funkin.avi: Recycled - JUST GO TO THE MAIN MENU ALREADY, I CAN'T STOP AAAAAAAAAAAAAAAAAAAAAAA";
											new FlxTimer().start(1, function(tmr:FlxTimer)
											{
												Application.current.window.title = "Funkin.avi: Recycled - AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
												new FlxTimer().start(1, function(tmr:FlxTimer)
												{
													Application.current.window.title = "Funkin.avi: Recycled - WHAT ARE YOU WAITING FOR??????";
													new FlxTimer().start(1, function(tmr:FlxTimer)
													{
														Application.current.window.title = "Funkin.avi: Recycled - JUST GO ALREADY, JUST FUCKING PRESS ENTER";
														new FlxTimer().start(1, function(tmr:FlxTimer)
														{
															Application.current.window.title = "Funkin.avi: Recycled - OH GOD, THE GLITCH IS GETTING WORSE";
															new FlxTimer().start(1, function(tmr:FlxTimer)
															{
																Application.current.window.title = "Funkin.avi: Recycled - WHY DID I THINK THIS WAS A GOOD IDEA?";
																new FlxTimer().start(1, function(tmr:FlxTimer)
																{
																	Application.current.window.title = "Funkin.avi: Recycled - OH THE MISERY EVERYBODY WANNA BE MY ENEMY MY ENEMY";
																	new FlxTimer().start(1, function(tmr:FlxTimer)
																		{
																			Application.current.window.title = "Funkin.avi: Recycled - Hi, wanna see me glitch?";
																		});
																});
															});
														});
													});
												});
											});
										});
									});
								});
							});
						});
					});
				});
			});
		});
	}
	else if(Application.current.window.title.contains("Funkin.avi: Recycled - I'm shutting down your game now, fuck you"))
	{
		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			System.exit(0);
		});
	}
	else if(Application.current.window.title.contains("Funkin.avi: Recycled - .edud ssarg emos hcuot og ot deen uoy ,das yrev tsuj ,yltsenoh ,das si thaT ?sdrawkcab txet siht fo lla gnidaer otni troffe hcum os gnittup enigamI - delcyceR :iva.niknuF"))
		Application.current.window.title = ".edud ssarg emos hcuot og ot deen uoy ,das yrev tsuj ,yltsenoh ,das si thaT ?sdrawkcab txet siht fo lla gnidaer otni troffe hcum os gnittup enigamI - delcyceR :iva.niknuF";
	else if(Application.current.window.title.contains("Funkin.avi: Recycled - fuckin: restored.mp3 - jsjsjsdjdsjdsjadsjjads"))
		Application.current.window.title = "fuckin: restored.mp3 - jsjsjsdjdsjdsjadsjjads";
	else if(Application.current.window.title.contains('Funkin.avi: Recycled - fuckin.mp3 - i juss shat meseff'))
		Application.current.window.title = "fuckin: restored.mp3 - i juss shat meseff";
	else if(Application.current.window.title.contains("Funkin.avi: Recycled -  "))
		Application.current.window.title = " ";
}