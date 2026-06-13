function onLoad()
{
	saveFix();
}

function saveFix()
{
	if (FlxG.save.data.episode1FPLock == null)
        FlxG.save.data.episode1FPLock = 'locked';

    if (FlxG.save.data.freeplayMenuList == null)
        FlxG.save.data.freeplayMenuList = 0;

    if (FlxG.save.data.freeplayCurSelected == null)
        FlxG.save.data.freeplayCurSelected = 0;

    if (FlxG.save.data.birthdayLocky == null)
        FlxG.save.data.birthdayLocky = "uncompleted";

	FlxG.save.flush();
}

/**
 * [fullSave()]
 * Dev-only funciton that gives the player a 100% save file.
 */
function fullSave()
{
	saveFix();

	FlxG.save.data.episode1FPLock = 'unlocked';

	FlxG.save.data.birthdayLocky = 'beaten';

	FlxG.save.flush();
}

function resetData()
{
	saveFix();

	FlxG.save.data.episode1FPLock = 'locked';

    FlxG.save.data.freeplayMenuList = 0;

    FlxG.save.data.freeplayCurSelected = 0;

    FlxG.save.data.birthdayLocky = "uncompleted";

	FlxG.save.flush();
}