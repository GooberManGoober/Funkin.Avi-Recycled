import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import flixel.FlxState;
import openfl.Lib;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;

/**
	This is the initialization class. if you ever want to set anything before the game starts or call anything then this is probably your best bet.
**/
class Init extends FlxState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var filters:Array<BitmapFilter> = []; // the filters the game has active
	/// initalise filters here
	#if !neko
	public static var gameFilters:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [
		"Deuteranopia" => {
			var matrix:Array<Float> = [
				0.43, 0.72, -.15, 0, 0,
				0.34, 0.57, 0.09, 0, 0,
				-.02, 0.03,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		},
		"Protanopia" => {
			var matrix:Array<Float> = [
				0.20, 0.99, -.19, 0, 0,
				0.16, 0.79, 0.04, 0, 0,
				0.01, -.01,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		},
		"Tritanopia" => {
			var matrix:Array<Float> = [
				0.97, 0.11, -.08, 0, 0,
				0.02, 0.82, 0.16, 0, 0,
				0.06, 0.88, 0.18, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		}
	];
	#end

    public override function create() {
        trace('Initializating...');

		super.create();
		
		ClientPrefs.loadDefaultKeys();
		FlxG.save.bind('funkin', CoolUtil.getSavePath());

        PlayerSettings.init();
		ClientPrefs.loadPrefs();
		Highscore.load();
		GameData.loadShit();
		
		CoolUtil.createCoreFile();

        if (FlxG.save.data.weekCompleted != null) StoryMenu.weekCompleted = FlxG.save.data.weekCompleted;

        #if cpp
		// run the gc's for a little bit of perfomance improvements :]]
		cpp.NativeGc.enable(true);
		cpp.NativeGc.run(true);
		#end

        #if !neko
		// apply saved filters
		FlxG.game.setFilters(filters);
		#end

        FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

        FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        #if DISCORD_ALLOWED
        DiscordClient.initialize();

        
        Lib.application.window.onClose.add(function() {
            DiscordClient.shutdown();
        });
		#end

        FlxG.mouse.visible = true;
        FlxG.mouse.useSystemCursor = false;

        #if windows
        backend.windows.CppAPI.darkMode();
        #end

        #if !neko
		FlxG.game.setFilters(filters);

		var theFilter:String = ClientPrefs.filter;
		if (gameFilters.get(theFilter) != null)
		{
			var realFilter = gameFilters.get(theFilter).filter;

			if (realFilter != null)
				filters.push(realFilter);
		}

		FlxG.game.setFilters(filters);
		#end
		// */

        // fixes shaders acting weird when resizing the screen
        @:privateAccess
        {
            final resetSpriteCache = function(sprite:openfl.display.Sprite) {
                @:privateAccess {
                    sprite.__cacheBitmap = null;
                    sprite.__cacheBitmapData = null;
                }
            }

            FlxG.signals.gameResized.add((w, h) -> {
                if (FlxG.cameras != null) for (cam in FlxG.cameras.list)
                    if (cam != null && cam.filters != null)
                    {
                        resetSpriteCache(cam.flashSprite);
                    }
    
                if (FlxG.game != null) 
                {
                    resetSpriteCache(FlxG.game);
                }
           });
        }

        #if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end
        
        FlxG.autoPause = ClientPrefs.autoPause;
        FlxG.mouse.load(Paths.image('UI/funkinAVI/mouses/${ClientPrefs.cursorSkin}').bitmap);
		FlxG.mouse.visible = true;

        // initializating ends here and switches to the state the Main class intends to
        #if Freeplay
        FlxG.switchState(Type.createInstance(FreeplayCategories, [])); 
        #end

        var curState = Main.initialState;

        trace('Initialization complete, switching to ${Type.getClassName(curState)}');
        FlxG.switchState(Type.createInstance(curState, []));   
    }
}
