import funkin.utils.CameraUtil;

var grpMenuShit:FlxTypedGroup;

var controls = Controls.instance;

var menuItems:Array<String> = ['Juke Box', 'Reset Save Data'];
var curSelected:Int = 0;

function onCreate()
{
	var cam:FlxCamera = CameraUtil.lastCamera;
	
	var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	bg.setGraphicSize(cam.width, cam.height);
	bg.updateHitbox();
	bg.cameras = [cam];
	bg.scrollFactor.set();
	add(bg);
	bg.alpha = 0;
	
	FlxTween.tween(bg, {alpha: 0.6}, 0.4);
	
	grpMenuShit = new FlxTypedGroup();
	grpMenuShit.cameras = [cam];
	add(grpMenuShit);
	
	regenMenu();
}

var holdTime:Float = 0;

function onUpdate(elapsed)
{
	if (controls.UI_UP_P)
	{
		changeSelection(-1);
	}
	if (controls.UI_DOWN_P)
	{
		changeSelection(1);
	}
	
	var daSelected:String = menuItems[curSelected];
	
   if (controls.ACCEPT)
    {
        switch (daSelected)
        {
            case "Juke Box":
                FlxG.switchState(new ScriptedState('JukeBoxState'));
				FlxG.sound.music.volume = 0;
            case "Reset Save Data":
                openSubState(new ScriptedSubstate("resetSave"));
        }
    }
}

function changeSelection(?change:Int = 0)
{
	curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);
	
	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
	for (k => item in grpMenuShit.members)
	{
		item.targetY = k - curSelected;
		
		item.alpha = 0.6;
		if (item.targetY == 0)
		{
			item.alpha = 1;
		}
	}
}

function regenMenu():Void
{
	for (i in 0...grpMenuShit.members.length)
	{
		var obj = grpMenuShit.members[0];
		grpMenuShit.remove(obj, true);
		
		obj = FlxDestroyUtil.destroy(obj);
	}
	
	for (i in 0...menuItems.length)
	{
		var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
		item.isMenuItem = true;
		item.targetY = i;
		grpMenuShit.add(item);
	}
	curSelected = 0;
	changeSelection();
}