
var mascotRoom:FlxSprite;
var mascotRoomPOV:FlxSprite;

function onLoad()
{
    defaultCamZoom = 0.9;
    
    mascotRoom = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/treasureIsland/mascotRoom"));
    mascotRoom.scale.set(1.4, 1.4);
    add(mascotRoom);

    mascotRoomPOV = new FlxSprite(-500, 0).loadGraphic(Paths.image("stages/treasureIsland/mascotRoomPOV"));
    mascotRoomPOV.scale.set(1.4, 1.4);
    mascotRoomPOV.alpha = 0.0001;
    add(mascotRoomPOV);
}

function onCreatePost()
{
    modManager.setValue("tipsy", 0.15, 1);
    modManager.setValue("drunk", 0.15, 1);
}

function onSongStart()
{
    modManager.queueFuncOnce(256 * 4, (s,s2)->{ 
        FlxTween.tween(mascotRoom, {alpha: 0}, 1.5);

        FlxTween.tween(camHUD, {alpha: 0}, 0.5);
    });

    modManager.queueFuncOnce(257 * 4, (s,s2)->{ 
        FlxTween.tween(boyfriend, {alpha: 0.0001}, 0.5);
        camGame.fade(FlxColor.BLACK, 0.3);
    });

    modManager.queueFuncOnce(260 * 4, (s,s2)->{ 
        camGame.fade(FlxColor.BLACK, 1, true);
        modManager.setValue("opponentSwap", 0.5);
        modManager.setValue("transformZ", -0.25, 1);
        modManager.setValue("alpha", 0.65, 1);

        modManager.setValue("confusion", 360, 1);
        modManager.setValue("reverse", 1, 1);

        modManager.setValue("transform0X", -475, 1);
        modManager.setValue("transform1X", -450, 1);
        modManager.setValue("transform2X", 450, 1);
        modManager.setValue("transform3X", 475, 1);

        modManager.setValue("transformY", !ClientPrefs.downScroll ? 67 : -67, 1);

        playHUD.alpha = 0;

        modManager.queueEase(332 * 4, 334 * 4, "opponentSwap", 0, "expoOut", 1);
        modManager.queueEase(332 * 4, 334 * 4, "transformZ", 0, "expoOut", 1);

        modManager.queueEase(332 * 4, 334 * 4, "alpha", 0, "expoOut", 1);

        modManager.queueEase(332 * 4, 334 * 4, "transform0X", 0, "expoOut", 1);
        modManager.queueEase(332 * 4, 334 * 4, "transform1X", 0, "expoOut", 1);

        modManager.queueEase(332 * 4, 334 * 4, "opponentSwap", (ClientPrefs.middleScroll ? 0.5 : 0), "expoOut", 0);
        modManager.queueEase(332 * 4, 334 * 4, "transform2X", (ClientPrefs.middleScroll ? 630 : 0), "expoOut", 1);
        modManager.queueEase(332 * 4, 334 * 4, "transform3X", (ClientPrefs.middleScroll ? 630 : 0), "expoOut", 1);

        modManager.queueEase(332 * 4, 334 * 4, "confusion", 0, "expoOut", 1);
        modManager.queueEase(332 * 4, 334 * 4, "reverse", 0, "expoOut", 1);

        modManager.queueEase(332 * 4, 334 * 4, "transformY", 0, "expoOut", 1);
    });
    
    modManager.queueFuncOnce(264 * 4, (s,s2)->{ 
        FlxTween.tween(mascotRoomPOV, {alpha: 1}, 1.5);
        FlxTween.tween(camHUD, {alpha: 1}, 0.5);
    });

    modManager.queueFuncOnce(328 * 4, (s,s2)->{ 
        camGame.visible = false;
    });

    modManager.queueFuncOnce(332 * 4, (s,s2)->{ 
        mascotRoom.alpha = 1;
        mascotRoomPOV.visible = false;

        playHUD.alpha = 1;

        camGame.visible = true;
        boyfriend.alpha = 1;
    });
}