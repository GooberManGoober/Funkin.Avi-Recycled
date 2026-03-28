/**
 * [onLoad()]
 * Runs upon loading the mod.
 */
function onLoad() {
	FlxG.save.data.loading = false;
	saveFix();
}

/**
 * [saveFix()]
 * Checks the custom save-data variables and sets them in case they are null.
*/
function saveFix()
{
	if (FlxG.save.data.episode1FPLock == null)
        FlxG.save.data.episode1FPLock = 'locked';

    if (FlxG.save.data.freeplayMenuList == null)
        FlxG.save.data.freeplayMenuList = 0;

    if (FlxG.save.data.huntedLock == null)
        FlxG.save.data.huntedLock = 'locked';
    if (FlxG.save.data.malfunctionLock == null)
        FlxG.save.data.malfunctionLock = 'locked';
    if (FlxG.save.data.blessLock == null)
        FlxG.save.data.blessLock = 'locked';
    if (FlxG.save.data.crossinLock == null)
        FlxG.save.data.crossinLock = 'locked';
    if (FlxG.save.data.tgLock == null)
        FlxG.save.data.tgLock = 'locked';
    if (FlxG.save.data.rickyLock == null)
        FlxG.save.data.rickyLock = 'locked';

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

	FlxG.save.data.huntedLock = 'beaten';
	FlxG.save.data.malfunctionLock = 'beaten';
	FlxG.save.data.blessLock = 'beaten';
	FlxG.save.data.crossinLock = 'beaten';
	FlxG.save.data.tgLock = 'beaten';
	FlxG.save.data.rickyLock = 'beaten';

	FlxG.save.data.birthdayLocky = 'beaten';

	FlxG.save.data.loading = false;

	FlxG.save.flush();
}