import funkin.scripting.PluginsManager;
import lime.app.Application;

var curEpisode:String;
var windowName:String = "";

var introSoundsSuffix:String = '';

var cameraOnDad = false;

public var globalGradient:FlxSprite;

var isPixelStage:Bool = false;
var pixelZoom = 1;

function onMoveCamera(char)
{
    if (!PlayState.SONG.notes[curSection].mustHitSection)
        cameraOnDad = true;
    else
        cameraOnDad = false;
}

function onPause() {
	FlxG.camera.followLerp = 0;
	persistentUpdate = false;
	persistentDraw = true;
	paused = true;

	if (audio.inst != null)
		audio.pause();

	openSubState(new ScriptedSubstate("FAVIPauseSubState"));
	FlxTween.globalManager.forEach((i:FlxTween) -> if (!i.finished) i.active = true); // makes the objects in the pause menu actually able to tween
	return ScriptConstants.STOP_FUNC;
}

function onLoad() {
	countdownSounds = false;

	switch (PlayState.SONG.song)
	{
		case "Isolated", "Devilish Deal", "Lunacy", "Delusional", "Hunted", "Twisted Grins", "Laugh Track", "Birthday", "Delusion":
			introSoundsSuffix = "-cartoon";
		case "Malfunction":
			introSoundsSuffix = "-error";
			isPixelStage = true;
			pixelZoom = 6;
		case "Cycled Sins":
			skipCountdown = true;
			isPixelStage = true;
			pixelZoom = 6;
		default:
			if(isPixelStage) {
				introSoundsSuffix = '-pixel';
			}
	}

	canAccessEditors = ClientPrefs.inDevMode;
}

function onCreatePost()
{
    cameraSpeed *= 2;

	playHUD.comboOffsets = [99999, 99999, 99999, 99999];

	if (!ClientPrefs.lowQuality)
	{
		switch (PlayState.SONG.stage)
		{
			case 'war', 'treasureIsland', 'forbiddenRealm', 'fuckingLine', 'vaultRoom', 'vaultRoomLegacy', 'apartment', 'waltRoom':
				//nothing
			default:
				scratch = new FlxSprite();
				scratch.frames = Paths.getSparrowAtlas('filters/scratchShit');
				scratch.animation.addByPrefix('e', 'scratch thing', 24, true);
				scratch.animation.play('e');
				scratch.cameras = [camOther];
				add(scratch);
		}
	}

	if (ClientPrefs.middleScroll && (PlayState.SONG.song != "Malfunction" && PlayState.SONG.song != "Mercy"))
	{
		modManager.setValue("opponentSwap", 0.5, 0);
        modManager.setValue("transform2X", 630, 1);
        modManager.setValue("transform3X", 630, 1);

		opponentStrums.underlayAlphaMult = 0;

		opponentStrums.baseAlpha = 0.35;
		opponentStrums.alpha = 0.35;
	}
	else
	{
		opponentStrums.underlayAlphaMult = 1;

		opponentStrums.baseAlpha = 1;
		opponentStrums.alpha = 1;
	}

	if (!ClientPrefs.opponentStrums)
	{
		opponentStrums.underlayAlphaMult = 0;

		opponentStrums.baseAlpha = 0;
		opponentStrums.alpha = 0;
	}

	switch (PlayState.SONG.stage)
	{
		case 'forestNew', 'clubhouse', 'trueGrinsOfSins', 'apartment':
			//nothing
		default:
			gf.visible = false;
	}

	switch (PlayState.SONG.stage)
	{
		case 'apartment', 'forbiddenRealm':
			playHUD.ratingPrefix = 'pixelUI/ratings/';
			playHUD.comboPrefix = 'pixelUI/combo/';
		case 'vaultRoomLegacy':
			playHUD.ratingPrefix = 'legacyUI/ratings/';
			playHUD.comboPrefix = 'legacyUI/combo/';
		default:
			playHUD.ratingPrefix = 'UI/ratings/';
			playHUD.comboPrefix = 'UI/combo/';
	}

	if (!ClientPrefs.lowQuality)
	{
		globalGradient = new FlxSprite().loadGraphic(Paths.image('filters/gradient'));
		globalGradient.screenCenter();
		globalGradient.setGraphicSize(Std.int(globalGradient.width * 0.68));
		globalGradient.cameras = [camOther];
		globalGradient.alpha = 0;
		add(globalGradient);
	}

	switch (PlayState.SONG.song)
	{
		case "Devilish Deal", "Isolated", "Lunacy", "Delusional": curEpisode = "Episode 1";
		default: curEpisode = "Episode ???";
	}

	windowName = "Funkin.avi: Recycled - " + 
	(PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + PlayState.SONG.song + 
	" (Composed by: " + PluginsManager.callPluginFunc('CreditsData', 'getArtistName', [PlayState.SONG.song]) + 
	") - Chart by: " + PluginsManager.callPluginFunc('CreditsData', 'getCharterCredits', [PlayState.SONG.song]) + 
	" [" + PluginsManager.callPluginFunc('CreditsData', 'getDiffRank', [PlayState.SONG.song]) + "]"; // shitty long ass name that credits literally every fucking thing

	Application.current.window.title = windowName;

	new FlxTimer().start(5, function(tmr:FlxTimer)
	{
		windowName = "Funkin.avi: Recycled - " + 
		(PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + 
		PlayState.SONG.song + 
		" [" + PluginsManager.callPluginFunc('CreditsData', 'getDiffRank', [PlayState.SONG.song]) + "]"; // short version that displays after 5 seconds yayaya

		Application.current.window.title = windowName;
	});

}

function onUpdate(elapsed)
{
    // the COOLER cam pos thing or whatever
	// x, y, angle
	var camOffset = [0.0, 0.0, 0];

	var char = cameraOnDad ? dad : boyfriend;

	if (char.animation.curAnim != null && !isCameraOnForcedPos && ClientPrefs.camFollowsCharacters) 
	{
		switch (char.animation.curAnim.name.substring(4))
		{
			case 'RIGHT', 'RIGHT-alt':
				camOffset[2] += 1.3;
			case 'LEFT', 'LEFT-alt':
				camOffset[2] -= 1.45;
		}
	}

	if(!inCutscene) {
		camGame.scrollAngle = FlxMath.lerp(camGame.scrollAngle, 0 + camOffset[2], 0.04 * cameraSpeed);
	}
}

function onCountdownTick(swagCounter)
{
    var introAlts:Array<String> = ['prepare', 'ready', 'set', 'go'];
	var antialias:Bool = ClientPrefs.globalAntialiasing;
	var scaleSetter:Int = 1;
	switch (PlayState.SONG.song)
	{
		case "Isolated", "Devilish Deal", "Lunacy", "Delusional", "Hunted", "Twisted Grins", "Birthday", "Delusion":
			introAlts = ['cartoon-prepare', 'cartoon-ready', 'cartoon-set', 'cartoon-go'];
			scaleSetter = 1;
		case "Malfunction":
			introAlts = ['mal-prepare', 'mal-ready', 'mal-set', 'mal-go'];
			antialias = false;
			scaleSetter = 6;
		default:
			if (isPixelStage)
			{
				introAlts = ['pixelUI/prepare-pixel', 'pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel'];
				antialias = false;
				scaleSetter = 6;
			}
	}

	switch (swagCounter)
	{
		case 0:
			FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix));
			var prepare:FlxSprite = makeCountdownSprite(introAlts[0]);
			prepare.cameras = [camOther];
			prepare.scale.set(scaleSetter, scaleSetter);
			prepare.antialiasing = antialias;
			add(prepare);
		case 1:
			FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix));
			var ready:FlxSprite = makeCountdownSprite(introAlts[1]);
			ready.scale.set(scaleSetter, scaleSetter);
			ready.antialiasing = antialias;
            add(ready);
			ready.cameras = [camOther];
            remove(countdownReady);
		case 2:
            FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix));
			var set:FlxSprite = makeCountdownSprite(introAlts[2]);
			set.scale.set(scaleSetter, scaleSetter);
			set.antialiasing = antialias;
            add(set);
			set.cameras = [camOther];
            remove(countdownSet);
        case 3:
            FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix));
			var go:FlxSprite = makeCountdownSprite(introAlts[3]);
			go.scale.set(scaleSetter, scaleSetter);
			go.antialiasing = antialias;
            add(go);
			go.cameras = [camOther];
            remove(countdownGo);
    }
}

function onSongStart()
{
	if (PlayState.SONG.song == "Delusional") // just to add the window title changing stuffs
	{
		modManager.queueFuncOnce(472 * 4, (s,s2)->{ 
			windowName = "...";
			Application.current.window.title = windowName;
		});

		modManager.queueFuncOnce(476 * 4, (s,s2)->{ 
			windowName = "Where am I...?";
			Application.current.window.title = windowName;
		});

		modManager.queueFuncOnce(480 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [________]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(484 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [P_______]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(488 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PE______]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(492 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEA_____]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(496 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEAC____]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(500 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEACE___]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(504 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEACEF__]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(508 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEACEFU_]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(512 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + "Regret [PEACEFUL]";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(728 * 4, (s,s2)->{
			windowName = "...";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(736 * 4, (s,s2)->{
			windowName = "Welcome back.... Little mouse.";
			Application.current.window.title = windowName;
		});
		modManager.queueFuncOnce(744 * 4, (s,s2)->{
			windowName = "Funkin.avi: Recycled - " + (PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + PlayState.SONG.song + " [" + PluginsManager.callPluginFunc('CreditsData', 'getDiffRank', [PlayState.SONG.song]) + "]";
			Application.current.window.title = windowName;
		});
	}
}

function onPopUpScorePost(note, daRating, ratingGraphic, numGroup) {
	if (playHUD.showRating)
	{
		var rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image(playHUD.ratingPrefix + daRating.image + playHUD.ratingSuffix));
		rating.scale.set(0.7 * pixelZoom, 0.7 * pixelZoom);
		rating.screenCenter();
		rating.x = (FlxG.width * 0.35) - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		
		if (isPixelStage)
			rating.antialiasing = false;
		else
			rating.antialiasing = ClientPrefs.globalAntialiasing;
		rating.updateHitbox();
		ratingNameGroup.add(rating);
		FlxTween.tween(rating, {alpha: 0}, 0.2, {startDelay: Conductor.crotchet * 0.001});
	}

	if (playHUD.showRatingNum)
	{	
		var seperatedScore:Array<Int> = [];
		var xOffset:Int = 0;
			
		if (combo >= 1000)
		{
			seperatedScore.push(Math.floor(combo / 1000) % 10);
			xOffset = 9;
		}
		if (combo >= 100)
		{
			seperatedScore.push(Math.floor(combo / 100) % 10);
			xOffset = 6;
		}
		if (combo >= 10)
		{
			seperatedScore.push(Math.floor(combo / 10) % 10);
			xOffset = 3;
		}
		seperatedScore.push(combo % 10);

		var daLoop = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite();
			numScore.loadGraphic(Paths.image(playHUD.comboPrefix + 'num' + Std.int(i) + playHUD.ratingSuffix));
			numScore.alpha = 1;
			numScore.scale.set(0.5 * pixelZoom, 0.5 * pixelZoom);
			numScore.screenCenter();
			numScore.x = ((FlxG.width * 0.35) + (43 * daLoop) - 90) + xOffset;
			numScore.y += 80;

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (isPixelStage)
				numScore.antialiasing = false;
			else
				numScore.antialiasing = ClientPrefs.globalAntialiasing;

			numScore.updateHitbox();
			ratingNumGroup.add(numScore);
			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crotchet * 0.002
			});

			daLoop += 1;
		}
	}
}