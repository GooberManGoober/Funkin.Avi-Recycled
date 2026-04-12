import lime.system.System;
import flixel.text.FlxText;
import lime.app.Application;

var crashLives:FlxText;
var crashLivesIcon:FlxSprite;
var crashLivesCounter:Int = 0;

var heartTween:FlxTween;
var malfunctionTxt:FlxTween;

function onLoad() 
{
	if (ClientPrefs.downScroll)
	{
		crashLives = new FlxText(600, 170, 0, "", 20);
		crashLivesIcon = new FlxSprite(550, 170);
	}
	else
	{
		crashLives = new FlxText(600, 500, 0, "", 20);
		crashLivesIcon = new FlxSprite(550, 500);
	}

	crashLives.setFormat(Paths.font("Retro Gaming.ttf"), 20, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	crashLives.borderSize = 2;
	crashLives.borderQuality = 2;
	crashLives.antialiasing = false;
	crashLives.scrollFactor.set();
	crashLives.cameras = [camHUD];

	crashLivesIcon.frames = Paths.getSparrowAtlas('UI/malfunctionGimmickIcon');
	crashLivesIcon.animation.addByPrefix('idle', 'lives-icon idle', 15);
	crashLivesIcon.animation.addByPrefix('OMFG IT GLITCHES', 'lives-icon glitchin', 15);
	crashLivesIcon.animation.play('idle');
	crashLivesIcon.scale.set(2.2, 2.2);
	crashLivesIcon.antialiasing = false;
	crashLivesIcon.cameras = [camHUD];
	playHUD.add(crashLives);
	playHUD.add(crashLivesIcon);

	crashLivesCounter += 45;
	crashLives.text = 'Lives: ' + crashLivesCounter;
}

function setupNote(note) {
	note.reloadNote('ERROR');
	note.hitCausesMiss = false;
	note.canMiss = true;
	note.ignoreNote = note.mustPress;
}

function goodNoteHit(note) {
	if (note.noteType == 'Error Note') 
	{
		health += note.hitHealth * 3.8;
		crashLivesCounter -= 1;

		crashLives.text = 'Lives: ' + crashLivesCounter;

		if (malfunctionTxt != null)
			malfunctionTxt.cancel();

		if (heartTween != null)
			heartTween.cancel();

		malfunctionTxt = FlxTween.tween(crashLives, {alpha: 1}, 0.6, {
			ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				malfunctionTxt = FlxTween.tween(crashLives, {alpha: 0.3}, 2, {
					ease: FlxEase.quartInOut,
					startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						malfunctionTxt = null;
					}
				});
			}
		});

		heartTween = FlxTween.tween(crashLivesIcon, {alpha: 1}, 0.6, {
			ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween)
			{
				heartTween = FlxTween.tween(crashLivesIcon, {alpha: 0.3}, 2, {
					ease: FlxEase.quartInOut,
					startDelay: 5,
					onComplete: function(twn:FlxTween)
					{
						heartTween = null;
					}
				});
			}
		});

		// to be honest we can just use shake
		//                                - jason

		FlxTween.tween(crashLives, {x: 620}, 0.01);
		FlxTween.tween(crashLivesIcon, {x: 570}, 0.01);
		FlxTween.tween(crashLives, {x: 585}, 0.01, {startDelay: 0.1});
		FlxTween.tween(crashLivesIcon, {x: 535}, 0.01, {startDelay: 0.1});
		FlxTween.tween(crashLives, {x: 610}, 0.01, {startDelay: 0.2});
		FlxTween.tween(crashLivesIcon, {x: 560}, 0.01, {startDelay: 0.2});
		FlxTween.tween(crashLives, {x: 595}, 0.01, {startDelay: 0.3});
		FlxTween.tween(crashLivesIcon, {x: 545}, 0.01, {startDelay: 0.3});
		FlxTween.tween(crashLives, {x: 600}, 0.01, {startDelay: 0.4});
		FlxTween.tween(crashLivesIcon, {x: 550}, 0.01, {startDelay: 0.4});

		crashLivesIcon.animation.play("OMFG IT GLITCHES");

		new FlxTimer().start(0.25, function(tmr:FlxTimer)
		{
			crashLivesIcon.animation.play('idle');
		});

		if (crashLivesCounter == -1)
		{
			finishSong();
			trace('0 lives left, closing game...');
			FlxG.sound.play(Paths.sound('funkinAVI/wiiCrash'), 1);

			if (FlxG.random.bool(10))																																																	
				Application.current.window.alert("You Suck LMAO\n\n\nmaybe actually be good at the game for once instead of killing yourself so many times bro.", 'Note About Your Skill:'); // 10% of probability
			else																																																																					/**corny ass shit no offense**/
				Application.current.window.alert("<Message Log>\n========================                                                                                        \n\nPlayState.hx (7504):\n   if(crashLivesCounter == -1)\n   {trace('0 lives left, closing game...')}\n\n\njust give up, you stand no chance against me, everett.",
					'Error On Funkin.avi.exe!:');

			System.exit(0);
		}
	}
}
