/**
 * [UI.hx]
 * Used for handling D-Side's custom UI.
 * Also used for accessing the custom pause menu.
 */

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxCameraFollowStyle;
import funkin.utils.CameraUtil;
import funkin.scripting.PluginsManager;
import funkin.FunkinAssets;
import lime.app.Application;

var curEpisode:String;
var windowName:String = "";

var introSoundsSuffix:String = '';

var cameraOnDad = false;

function onMoveCamera(char)
{
    if (!PlayState.SONG.notes[curSection].mustHitSection)
        cameraOnDad = true;
    else
        cameraOnDad = false;
}

/**
 * [onPause]
 * Runs when the player pauses the game.
 * 
 * In this script:
 *  Stops existing pause menu from opening if not on low quality mode
 *  Opens custom pause menu (if not on lq mode)
 */
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
	ClientPrefs.comboOffset = [99999, 99999, 99999, 99999];

	countdownSounds = false;

	switch (PlayState.SONG.song)
	{
		case "Isolated", "Devilish Deal", "Lunacy", "Delusional", "Hunted", "Twisted Grins", "Laugh Track", "Birthday", "Delusion":
			introSoundsSuffix = "-cartoon";
		case "Malfunction":
			introSoundsSuffix = "-error";
		default:
			if(PlayState.isPixelStage) {
				introSoundsSuffix = '-pixel';
			}
	}
}

function onCreatePost()
{
    if (ClientPrefs.middleScroll)
	{
		if (PlayState.SONG.song != 'Devilish Deal')
		{
			modManager.setValue("opponentSwap", 0.5);
			opponentStrums.baseAlpha = 1;
			modManager.setValue("alpha", 0.65, 1);
			modManager.setValue("transform0X", -350, 1);
			modManager.setValue("transform1X", -350, 1);
			modManager.setValue("transform2X", 350, 1);
			modManager.setValue("transform3X", 350, 1);
		}
	}

	cameraSpeed *= 2;

	if (!ClientPrefs.lowQuality)
	{
		if (PlayState.SONG.stage != 'treasureIsland' && PlayState.SONG.stage != 'forbiddenRealm' && PlayState.SONG.stage != 'fuckingLine' && PlayState.SONG.stage != 'vaultRoom' && PlayState.SONG.stage != 'vaultRoomLegacy')
		{
			scratch = new FlxSprite();
			scratch.frames = Paths.getSparrowAtlas('Funkin_avi/filters/scratchShit');
			scratch.animation.addByPrefix('e', 'scratch thing', 24, true);
			scratch.animation.play('e');
			scratch.cameras = [camOther];
			add(scratch);
		}
	}

	if (PlayState.SONG.stage != "forestNew" && PlayState.SONG.stage != "circus" && PlayState.SONG.stage != 'clubhouse' && PlayState.SONG.stage != 'trueGrinsOfSins')
	{
		gf.visible = false;
	}

	if (!ClientPrefs.lowQuality)
	{
		globalGradient = new FlxSprite().loadGraphic(Paths.image('Funkin_avi/filters/gradient'));
		globalGradient.screenCenter();
		globalGradient.setGraphicSize(Std.int(globalGradient.width * 0.68));
		globalGradient.cameras = [camOther];
		globalGradient.alpha = 0;
		add(globalGradient);
		scripts.set('globalGradient', globalGradient);
	}

	var checkSongForGimmicks:Array<String> = [
		"Isolated",
		"Lunacy",
		"Delusional",
		"Hunted",
		"Laugh Track",
		"Don't Cross!",
		"Bless"
	];

	var checkMechanics:Bool = false;
	for (i in 0...checkSongForGimmicks.length)
		if (PlayState.SONG.song == checkSongForGimmicks[i])
			checkMechanics = true;

	switch (PlayState.SONG.song)
	{
		case "Devilish Deal", "Isolated", "Lunacy", "Delusional": curEpisode = "Episode 1";
		default: curEpisode = "Episode ???";
	}

	windowName = "Funkin.avi: Recycled - " + 
	(PlayState.isStoryMode ? curEpisode + " - " : "Freeplay - ") + PlayState.SONG.song + 
	" (Composed by: " + PluginsManager.callPluginFunc('CreditsData', 'getArtistName', [PlayState.SONG.song]) + 
	") - Chart by: " + PluginsManager.callPluginFunc('CreditsData', 'getCharterCredits', [PlayState.SONG.song]) + 
	" [" + PluginsManager.callPluginFunc('CreditsData', 'getDiffRank', [PlayState.SONG.song]) + "]" + 
	(checkMechanics ? ' - Mechanics: ' + (ClientPrefs.mechanics ? "Enabled" : "Disabled") : ""); // shitty long ass name that credits literally every fucking thing

	Application.current.window.title = windowName;
}

function onUpdate(elapsed)
{
    if (PlayState.SONG.song != "Bless Legacy")
	{
		// the COOLER cam pos thing or whatever
		// x, y, angle
		var camOffset = [0.0, 0.0, 0];

		var char = cameraOnDad ? dad : boyfriend;

		if (char.animation.curAnim != null && !isCameraOnForcedPos && ClientPrefs.camFollowsCharacters) 
		{
			switch (char.animation.curAnim.name.substring(4))
			{
				case 'RIGHT':
					camOffset[2] += 1.3;
				case 'LEFT':
					camOffset[2] -= 1.45;

				case 'RIGHT-alt':
					camOffset[2] += 1.3;
				case 'LEFT-alt':
					camOffset[2] -= 1.45;

				case 'RIGHTmiss':
					camOffset[2] += 1.3;
				case 'LEFTmiss':
					camOffset[2] -= 1.45;
			}
		}

		if(!inCutscene) {
			camGame.angle = FlxMath.lerp(camGame.angle, 0 + camOffset[2], FlxMath.bound(elapsed * 2.4 * cameraSpeed, 0, 1));
		}
	}
}

function onCountdownTick(swagCounter)
{
    var introAlts:Array<String> = ['Funkin_avi/countdownAssets/default-prepare', 'Funkin_avi/countdownAssets/default-ready', 'Funkin_avi/countdownAssets/default-set', 'Funkin_avi/countdownAssets/default-go'];
	var antialias:Bool = ClientPrefs.globalAntialiasing;
	switch (PlayState.SONG.song)
	{
		case "Isolated", "Devilish Deal", "Lunacy", "Delusional", "Hunted", "Twisted Grins", "Laugh Track", "Birthday", "Delusion":
			introAlts = ['Funkin_avi/countdownAssets/cartoon-prepare', 'Funkin_avi/countdownAssets/cartoon-ready', 'Funkin_avi/countdownAssets/cartoon-set', 'Funkin_avi/countdownAssets/cartoon-go'];
		case "Malfunction":
			introAlts = ['Funkin_avi/countdownAssets/mal-prepare', 'Funkin_avi/countdownAssets/mal-ready', 'Funkin_avi/countdownAssets/mal-set', 'Funkin_avi/countdownAssets/mal-go'];
			antialias = false;
		default:
			if(PlayState.isPixelStage) {
				introAlts = ['pixelUI/prepare-pixel', 'pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel'];
				antialias = false;
			}
	}

	switch (swagCounter)
	{
		case 0:
			FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix));
			var prepare:FlxSprite = makeCountdownSprite(introAlts[0]);
			prepare.cameras = [camOther];
			add(prepare);
		case 1:
			FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix));
			var ready:FlxSprite = makeCountdownSprite(introAlts[1]);
            add(ready);
			ready.cameras = [camOther];
            remove(countdownReady);
		case 2:
            FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix));
			var set:FlxSprite = makeCountdownSprite(introAlts[2]);
            add(set);
			set.cameras = [camOther];
            remove(countdownSet);
        case 3:
            FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix));
			var go:FlxSprite = makeCountdownSprite(introAlts[3]);
            add(go);
			go.cameras = [camOther];
            remove(countdownGo);
    }
}