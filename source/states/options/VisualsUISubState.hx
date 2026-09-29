package states.options;

import flash.text.TextField;
import lime.utils.Assets;
import haxe.Json;
import flixel.input.keyboard.FlxKey;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Preferences';
		rpcTitle = 'Preferences Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Splash Opacity',
			'Sets the opacity for the Note Splashes, shown when hitting "Sick!" judgements on notes. (DOES NOT APPLY TO BLESS)',
			'splashAlpha',
			'percent',
			0.6);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Display Title Cards',
			"Whether to display the song cards at the start of a song.",
			'songCards',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hide Judgement Counter',
			'If checked, hides Judgement Counter on the screen',
			'hideJudgement',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Flashing Lights',
			"Whether to disable Flashing Lights on Menus, check this if you are sensitive to those.",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Epilepsy Mode',
			"",
			'epilepsy',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Screen Shake',
			"Uncheck this if you're sensitive to screen shakes!",
			'shaking',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Opacity',
			'How transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'Whether to display the FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Memory Counter',
			'Whether to display approximately how much Memory is being used.',
			'debugInfo',
			'bool',
			false);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		var option:Option = new Option('Cursor Style:',
			"Chooses what cursor you prefer.",
			'cursorSkin',
			'string',
			'Default',
			['Default', 'Hand', 'Mickey', 'Silhouette', 'The Eye']);
		addOption(option);
		option.onChange = onChangeCursor;

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		super();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		Overlay.updateDisplayInfo(ClientPrefs.showFPS, ClientPrefs.debugInfo);
	}
	#end

	function onChangeAntiAliasing()
		{
			for (sprite in members)
			{
				var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
				var sprite:FlxSprite = sprite; //Don't judge me ok
				if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
					sprite.antialiasing = ClientPrefs.globalAntialiasing;
				}
			}
		}

	function onChangeCursor()
	{
		FlxG.mouse.load(Paths.image('UI/funkinAVI/mouses/${ClientPrefs.cursorSkin}').bitmap);
		FlxG.mouse.visible = true;
	}
}
