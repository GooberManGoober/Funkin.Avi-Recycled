import funkin.utils.CoolUtil;

using StringTools;

var camTwn:Array<FlxTween> = [];

var flashSprite:FlxSprite;
var flashSpeed:Float = 0.0;

function onLoad()
{
	flashSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	flashSprite.scale.set(3, 3);
	flashSprite.screenCenter();
	flashSprite.alpha = 0.001;
	flashSprite.cameras = [camHUD];
	add(flashSprite);
}

function onUpdate(elapsed)
{
	flashSprite.alpha = FlxMath.lerp(0, flashSprite.alpha, Math.exp(-elapsed * flashSpeed));
}

function onEvent(eventName, value1, value2) {
	switch (eventName) {
		case 'Camera Event':	
			var triggerInfo:Array<String> = value2.split(',');
			switch (value1.toLowerCase())
			{
				case "tween value":
					switch (triggerInfo[0].toLowerCase())
					{
						case "zoom":
							if (camTwn[0] != null)
								camTwn[0].cancel();

							camTwn[0] = FlxTween.tween(camGame, {zoom: Std.parseFloat(triggerInfo[1])}, Std.parseFloat(triggerInfo[2]), {ease: CoolUtil.getEaseFromString(triggerInfo[3].trim()), onComplete: function(twn:FlxTween)
							{
								defaultCamZoom = Std.parseFloat(triggerInfo[1]);
								camTwn[0] = null;
							}});
						
						case "alpha":
							if (camTwn[2] != null)
								camTwn[2].cancel();

							if (Std.parseFloat(triggerInfo[1]) > 1 || Std.parseFloat(triggerInfo[1]) < 0)
								triggerInfo[1] = "1";

							camTwn[2] = FlxTween.tween(camGame, {alpha: Std.parseFloat(triggerInfo[1])}, Std.parseFloat(triggerInfo[2]), {ease: CoolUtil.getEaseFromString(triggerInfo[3].trim()), onComplete: function(twn:FlxTween)
							{
								camTwn[2] = null;
							}});

						case "hudalpha":
							if (camTwn[3] != null)
								camTwn[3].cancel();

							if (Std.parseFloat(triggerInfo[1]) > 1 || Std.parseFloat(triggerInfo[1]) < 0)
								triggerInfo[1] = "1";

							camTwn[3] = FlxTween.tween(camHUD, {alpha: Std.parseFloat(triggerInfo[1])}, Std.parseFloat(triggerInfo[2]), {ease: CoolUtil.getEaseFromString(triggerInfo[3].trim()), onComplete: function(twn:FlxTween)
							{
								camTwn[3] = null;
							}});

						case "angle":
							if (camTwn[4] != null)
								camTwn[4].cancel();

							camTwn[4] = FlxTween.tween(camGame, {angle: Std.parseFloat(triggerInfo[1])}, Std.parseFloat(triggerInfo[2]), {ease: CoolUtil.getEaseFromString(triggerInfo[3].trim()), onComplete: function(twn:FlxTween)
							{
								camTwn[4] = null;
							}});
					}

				case "start hidden":
					//do nothing cause it's already doing something

				case "change value":
					switch (triggerInfo[0].toLowerCase())
					{
						case "defaultcamzoom": defaultCamZoom = Std.parseFloat(triggerInfo[1]);
						case "alpha": camGame.alpha = Std.parseFloat(triggerInfo[1]);
						case "hudalpha": camHUD.alpha = Std.parseFloat(triggerInfo[1]);
						case "angle": camGame.angle = Std.parseFloat(triggerInfo[1]);
						case "hudangle": camHUD.angle = Std.parseFloat(triggerInfo[1]);
						case "adddefaultcamzoom": defaultCamZoom += Std.parseFloat(triggerInfo[1]);
					}

				case "shake":
					if (triggerInfo[2] == "hud")
						camHUD.shake(Std.parseFloat(triggerInfo[0]), Std.parseFloat(triggerInfo[1]));
					else
						camGame.shake(Std.parseFloat(triggerInfo[0]), Std.parseFloat(triggerInfo[1]));

				case "flash":
					if (ClientPrefs.flashing)
					{
						if (triggerInfo[0] == null) triggerInfo[0] = "255";
						if (triggerInfo[1] == null) triggerInfo[1] = "255";
						if (triggerInfo[2] == null) triggerInfo[2] = "255";
						if (triggerInfo[3] == null) triggerInfo[3] = "1";
						if (triggerInfo[4] == null) triggerInfo[4] = "1";
						if (triggerInfo[5] == null) triggerInfo[5] = "false";
			
						var boolShit:Bool = false;
			
						if (triggerInfo[5].toLowerCase().trim() == "true")
							boolShit = true;
			
						flashSprite.color = FlxColor.fromRGB(Std.parseInt(triggerInfo[0]), Std.parseInt(triggerInfo[1]), Std.parseInt(triggerInfo[2]));
						flashSpeed = Std.parseFloat(triggerInfo[3]);
						flashSprite.alpha = Std.parseFloat(triggerInfo[4]);
						flashSprite.blend = (boolShit ? CoolUtil.getBlendFromString('add') : CoolUtil.getBlendFromString('normal'));
					}

				case "fade":
					if (triggerInfo[0] == null) triggerInfo[0] = "0";
					if (triggerInfo[1] == null) triggerInfo[1] = "0";
					if (triggerInfo[2] == null) triggerInfo[2] = "0";
					if (triggerInfo[3] == null) triggerInfo[3] = "1";
					if (triggerInfo[4] == null) triggerInfo[4] = "false";

					var boolShit:Bool = false;
	
					if (triggerInfo[4].toLowerCase().trim() == "true")
						boolShit = true;

					camGame.fade(FlxColor.fromRGB(Std.parseInt(triggerInfo[0]), Std.parseInt(triggerInfo[1]), Std.parseInt(triggerInfo[2])), Std.parseFloat(triggerInfo[3]), boolShit);
				case "change pos":
					if(camFollow != null)
					{
						isCameraOnForcedPos = false;
						if(triggerInfo[0] != null || triggerInfo[1] != null)
						{
							isCameraOnForcedPos = true;
							if(triggerInfo[0] == null) triggerInfo[0] = "0";
							if(triggerInfo[1] == null) triggerInfo[1] = "0";
							camFollow.x = Std.parseFloat(triggerInfo[0]);
							camFollow.y = Std.parseFloat(triggerInfo[1]);
						}
					}

				case "tween position":
					if (camFollow != null)
					{
						if (camTwn[7] != null)
							camTwn[7].cancel();

						isCameraOnForcedPos = false;
						if(triggerInfo[0] != null || triggerInfo[1] != null)
						{
							isCameraOnForcedPos = true;
							if(triggerInfo[0] == null) triggerInfo[0] = "0";
							if(triggerInfo[1] == null) triggerInfo[1] = "0";
							camTwn[7] = FlxTween.tween(camFollow, {x: Std.parseFloat(triggerInfo[0]), y: Std.parseFloat(triggerInfo[1])}, Std.parseFloat(triggerInfo[2]), {ease: CoolUtil.getEaseFromString(triggerInfo[3].trim().toLowerCase()), onComplete: function(twn:FlxTween)
							{
								camTwn[7] = null;
							}});
						}
					}
				case "snap position":
					if(camFollow != null)
					{
						isCameraOnForcedPos = false;
						if(triggerInfo[0] != null || triggerInfo[1] != null)
						{
							isCameraOnForcedPos = true;
							if(triggerInfo[0] == null) triggerInfo[0] = "0";
							if(triggerInfo[1] == null) triggerInfo[1] = "0";
							
							snapCamToPos(Std.parseFloat(triggerInfo[0]), Std.parseFloat(triggerInfo[1]), true);
						}
					}
			}
	}
}

function onEventPush(event)
{
	switch (event.event)
	{
		case "Camera Event":
			if (event.value1.toLowerCase().trim() == "start hidden")
			{
				camHUD.alpha = 0.001;
				camGame.fade(FlxColor.BLACK, 0.001);
			}
	}
}