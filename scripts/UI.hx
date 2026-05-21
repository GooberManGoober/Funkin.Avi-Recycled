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

	if (PlayState.SONG.song == "Bless Legacy") openSubState(new ScriptedSubstate("LegacyPauseSubState"));
	else openSubState(new ScriptedSubstate("FAVIPauseSubState"));
	FlxTween.globalManager.forEach((i:FlxTween) -> if (!i.finished) i.active = true); // makes the objects in the pause menu actually able to tween
	return ScriptConstants.STOP_FUNC;
}

function onLoad() {
	ClientPrefs.comboOffset = [99999, 99999, 99999, 99999];

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
			if(PlayState.isPixelStage) {
				introSoundsSuffix = '-pixel';
			}
	}

	canAccessEditors = ClientPrefs.inDevMode;
}

function onCreatePost()
{
    cameraSpeed *= 2;

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
			if(PlayState.isPixelStage) {
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
	if (playHUD.showRatingNum)
	{
		FlxTween.cancelTweensOf(ratingGraphic, ['scale.x', 'scale.y', 'alpha']);
		ratingGraphic.alpha = 1;
		ratingGraphic.loadGraphic(Paths.image(playHUD.ratingPrefix + daRating.image + playHUD.ratingSuffix));
		ratingGraphic.scale.set(0.4 * pixelZoom, 0.4 * pixelZoom);
		ratingGraphic.screenCenter();
		ratingGraphic.x = 15;
		ratingGraphic.y = 100;
		if (!ClientPrefs.downScroll)
			ratingGraphic.y += 495;
		
		if (playHUD.comboTween)
		{
			ratingGraphic.scale.set(0.485 * pixelZoom, 0.485 * pixelZoom);
			FlxTween.tween(ratingGraphic.scale, {x: 0.4 * pixelZoom, y: 0.4 * pixelZoom}, 0.5, {ease: FlxEase.expoOut});
		}

		if (isPixelStage)
			ratingGraphic.antialiasing = false;
		else
			ratingGraphic.antialiasing = ClientPrefs.globalAntialiasing;
		ratingGraphic.updateHitbox();
		FlxTween.tween(ratingGraphic, {alpha: 0}, 0.5, {startDelay: Conductor.stepCrotchet * 0.01, ease: FlxEase.expoOut});
	}

	if (playHUD.showRatingNum)
	{	
		var seperatedScore:Array<Int> = [];
				
		if (combo >= 1000)
		{
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop = 0;
		for (numScore in playHUD.ratingNumGroup.members)
		{
			FlxTween.cancelTweensOf(numScore);
			
			numScore.alpha = 1;
			numScore.scale.set(0.22 * pixelZoom, 0.22 * pixelZoom);
			numScore.screenCenter();
			numScore.x = (32 * daLoop) - 90;
			numScore.x += 130;
			numScore.y = ratingGraphic.y + 60;

			if (playHUD.comboTween)
			{
				numScore.scale.set(0.32 * pixelZoom, 0.32 * pixelZoom);
				FlxTween.cancelTweensOf(numScore, ['scale.x', 'scale.y']);
				FlxTween.tween(numScore.scale, {x: 0.22 * pixelZoom, y: 0.22 * pixelZoom}, 0.5, {ease: FlxEase.expoOut});
			}

			if (isPixelStage)
				numScore.antialiasing = false;
			else
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.updateHitbox();
			playHUD.ratingNumGroup.add(numScore);
			FlxTween.tween(numScore, {alpha: 0}, 0.5, {startDelay: Conductor.stepCrotchet * 0.01, ease: FlxEase.expoOut});

			daLoop += 1;
		}
	}
}