package backend.data;

/**
 * **lmao you ain't gonna play malfunction so easly**.
 * 
 *  Anyways the data thing which is useful for stuff such like:
 * - the birthday song been in the extras section after beating it
 * - var progression:FlxSave = new FlxSave();
 * progression for cool ass stuff
 * - etc
 * 
 * Also this is like the [**Psych Engine ClientPrefs file**](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/ClientPrefs.hx),
 * 
 * but with game data instead of option data (that one is on **Init** file and some others)
 */
class GameData
{
	// Progression Shit
	public static var episode1FPLock:String = 'locked';

	// Alters the icons in freeplay
	public static var huntedLock:String = 'locked';
	public static var malfunctionLock:String = 'locked';
	public static var blessLock:String = 'locked';
	public static var warLock:String = 'locked';
	public static var crossinLock:String = 'locked';
	public static var tgLock:String = 'locked';
	public static var rickyLock:String = 'locked';

	// Gamejolt Stuff
	public static var GJ_username:String = "";
	public static var GJ_token:String = "";

	// Intro Stuff
	public static var hasSeenWarning:Bool = false;
	public static var hasSeenFlxSplash:Bool = false;

	// Hidden Songs
	public static var birthdayLocky:String = "uncompleted";
	public static var maniaSaves:Array<String> = ["unlocked", "unlocked", "unlocked"];

	public static function lockinIt():Void
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());

		if (progression.data.episode1FPLock == null)
			progression.data.episode1FPLock = 'locked';

		if (progression.data.huntedLock == null)
			progression.data.huntedLock = 'locked';
		if (progression.data.malfunctionLock == null)
			progression.data.malfunctionLock = 'locked';
		if (progression.data.blessLock == null)
			progression.data.blessLock = 'locked';
		if (progression.data.warLock == null)
			progression.data.warLock = 'locked';
		if (progression.data.crossinLock == null)
			progression.data.crossinLock = 'locked';
		if (progression.data.tgLock == null)
			progression.data.tgLock = 'locked';
		if (progression.data.rickyLock == null)
			progression.data.rickyLock = 'locked';

		if (progression.data.gjUser == null)
			progression.data.gjUser = "";
		if (progression.data.gjToken == null)
			progression.data.gjToken = "";

		if (progression.data.hasSeenWarning == null)
			progression.data.hasSeenWarning = false;
		if (progression.data.hasSeenFlxSplash == null)
			progression.data.hasSeenFlxSplash = false;

		if (progression.data.birthdayLocky == null)
			progression.data.birthdayLocky = "uncompleted";
		if (progression.data.highOnCrackLock == null)
			progression.data.highOnCrackLock = "undiscovered";

		progression.flush();
	}

	public static function saveShit():Void
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());
		trace('saving data');

		progression.data.episode1FPLock = episode1FPLock;

		progression.data.huntedLock = huntedLock;
		progression.data.malfunctionLock = malfunctionLock;
		progression.data.blessLock = blessLock;
		progression.data.warLock = warLock;
		progression.data.crossinLock = crossinLock;
		progression.data.tgLock = tgLock;
		progression.data.rickyLock = rickyLock;

		progression.data.gjUser = GJ_username;
		progression.data.gjToken = GJ_token;

		progression.data.hasSeenWarning = hasSeenWarning;
		progression.data.hasSeenFlxSplash = hasSeenFlxSplash;

		progression.data.birthdayLocky = birthdayLocky;

		progression.flush();
	}

	public static function loadShit():Void
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());

		trace('loading data');

		episode1FPLock = progression.data.episode1FPLock;

		huntedLock = progression.data.huntedLock;
		malfunctionLock = progression.data.malfunctionLock;
		blessLock = progression.data.blessLock;
		warLock = progression.data.warLock;
		crossinLock = progression.data.crossinLock;
		tgLock = progression.data.tgLock;
		rickyLock = progression.data.rickyLock;

		GJ_username = progression.data.gjUser;
		GJ_token = progression.data.gjToken;

		hasSeenWarning = progression.data.hasSeenWarning;
		hasSeenFlxSplash = progression.data.hasSeenFlxSplash;

		birthdayLocky = progression.data.birthdayLocky;

		saveShit();
	}

	public static function unlockEverything():Void
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());

		episode1FPLock = 'unlocked';

		huntedLock = 'beaten';
		malfunctionLock = 'beaten';
		blessLock = 'beaten';
		warLock = 'beaten';
		crossinLock = 'beaten';
		tgLock = 'beaten';
		rickyLock = 'beaten';

		birthdayLocky = 'beaten';

		saveShit();
	}

	public static function checkBotplay(lockValue:Null<String>)
	{
		if (lockValue == null)
			lockValue = 'unlocked';

		if ((lockValue == 'unlocked' || lockValue == 'obtained') || PlayState.isStoryMode)
			PlayState.instance.cpuControlled = false;
	}

	public static var canOverrideCPU:Bool = false;

	public static function overrideBotplay()
	{
		canOverrideCPU = true;
		ClientPrefs.gameplaySettings["botplay"] = true;
		MusicBeatState.switchState(new PlayState());
	}

	public static function setFreeplayData()
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());

		var curLock:String;

		curLock = 'beaten';

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'hunted':
				if (progression.data.huntedLock != 'beaten')
					curLock = huntedLock = 'unlocked';
			case "dont cross":
				if (progression.data.crossinLock != 'beaten')
					curLock = crossinLock = 'unlocked';
			case 'war dilemma':
				if (progression.data.warLock != 'beaten')
					curLock = warLock = 'unlocked';
			case 'twisted grins':
				if (progression.data.tgLock != 'beaten')
					curLock = tgLock = 'unlocked';
			case 'birthday':
				if (progression.data.birthdayLocky != 'beaten')
					curLock = birthdayLocky = 'beaten';
			case 'malfunction':
				if (progression.data.malfunctionLock != 'beaten')
					curLock = malfunctionLock = 'unlocked';
			case 'bless':
				if (progression.data.blessLock != 'beaten')
					curLock = blessLock = 'unlocked';
			case 'laugh track':
				if (progression.data.rickyLock != 'beaten')
					curLock = rickyLock = 'unlocked';
		}
		saveShit();
		if (!GameData.canOverrideCPU)
			checkBotplay(curLock); // just to double check :)))))))
	}

	public static function completeFPSong()
	{
		var progression:FlxSave = new FlxSave();
		progression.bind("gameProgression", CoolUtil.getSavePath());
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'hunted':
				huntedLock = 'beaten';
			case "dont cross":
				crossinLock = 'beaten';
			case 'war dilemma':
				warLock = 'beaten';
			case 'twisted grins':
				tgLock = 'beaten';
			case 'malfunction':
				malfunctionLock = 'beaten';
			case 'bless':
				blessLock = 'beaten';
			case 'laugh track':
				rickyLock = 'beaten';
			case 'birthday':
				birthdayLocky = 'beaten';
		}
		saveShit();
	}

	public static function completeEpisode()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'delusional':
				episode1FPLock = 'unlocked';
		}
		saveShit();
	}
}
