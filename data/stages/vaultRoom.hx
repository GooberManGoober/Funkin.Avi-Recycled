import openfl.filters.ShaderFilter;

var chains:FlxSprite;
var vault:FlxSprite;
var thingy:FlxSprite;
var chains2:FlxSprite;
var chains3:FlxSprite;
var light:FlxSprite;
var flair:FlxSprite;

var othershader:FlxRuntimeShader = newShader('blessLightsShit');
var invert:FlxRuntimeShader = newShader('invertShader');

var letsFight:FunkinVideoSprite;

var pathway:String = 'stages/vaultRoom/';

function onLoad()
{
    //spawnGirlfriend = false;
	
    vault = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'vault'));
    vault.scale.set(2.45, 2.3);
    add(vault);

    chains = new FlxSprite(-225, -100).loadGraphic(Paths.image(pathway + 'chains1'));
    chains.scale.set(2.5, 2.3);
    chains.scrollFactor.set(1.2, 1.25);

    chains2 = new FlxSprite(-225, -100).loadGraphic(Paths.image(pathway + 'chains2'));
    chains2.scale.set(2.5, 2.3);
    chains2.scrollFactor.set(1.1, 1.2);

    chains3 = new FlxSprite(-225, -100).loadGraphic(Paths.image(pathway + 'chains3'));
    chains3.scale.set(2.5, 2.3);
    chains3.scrollFactor.set(1, 1.15);

    light = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'lightSource'));
    light.blend = BlendMode.DIFFERENCE;
    light.alpha = 0.37;
    light.scrollFactor.set(0.95, 1);
    light.scale.set(2.45, 2.3);

    flair = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'lightFlair'));
    flair.blend = BlendMode.SCREEN;
    flair.alpha = 0.6;
    flair.scrollFactor.set(1.4, 1.25);
    flair.scale.set(2.5, 2.4);

    thingy = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'darkness'));
    thingy.scale.set(2.45, 2.3);
}

function onCreatePost()
{
    foreground.add(chains3);
    foreground.add(chains2);
    foreground.add(chains);
    foreground.add(light);
    foreground.add(flair);
    foreground.add(thingy);

    dad.blend = BlendMode.ADD;
    iconP2.blend = BlendMode.ADD;

    camGame.alpha = 0.001;
	camHUD.alpha = 0.001;

    letsFight = new FunkinVideoSprite(false);
    letsFight.load(Paths.video("blessCountdown"), [FunkinVideoSprite.muted]);
    letsFight.cameras = [camHUD];
    letsFight.play();
    letsFight.visible = false;
    new FlxTimer().start(0.001, function(tmr:FlxTimer)
    {
        letsFight.pause();
    });
    add(letsFight);
    letsFight.zIndex = 2;
    playHUD.zIndex = 3;
    playFields.zIndex = 4;
	
	if (ClientPrefs.shaders)
    {
        camGame.filters = [new ShaderFilter(othershader)];
        new FlxTimer().start(1, function(tmr)
        {
            camGame.filters = [];
        });
    }
}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;
    
    if (ClientPrefs.shaders) othershader.setFloat('iTime', shaderAnim);

    // shitty system for the camera to stay updated
    var wn_r:Float = 70;
    var rotRateWn = curStep / 9.5;
    var wn_toy = -640 + -Math.sin(rotRateWn * 2) * wn_r * 0.45;

    if (dad.curCharacter == "white-noise-new")
    {
        dad.y += (wn_toy - dad.y) / 12;
        iconP2.y += (((healthBar.y - 85) + -Math.sin(rotRateWn * 2) * 20 * 0.45) - iconP2.y) / 12;
    }
}

function onSongStart()
{
    modManager.queueFuncOnce(1, (s,s2)->{ 
        FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.expoOut});
        for (light in [light, flair])
        {
            light.visible = false;
            light.alpha -= 0.2;
        }
    });

    modManager.queueFuncOnce(42, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 3);
    });

    modManager.queueFuncOnce(84, (s,s2)->{ 
        for (light in[light, flair])
        {
            light.visible = true;
            FlxTween.tween(light, {alpha: light.alpha + 0.2}, 0.64, {ease: FlxEase.expoOut});
        }
    });

    modManager.queueFuncOnce(421, (s,s2)->{ 
        defaultCamZoom = 0.95;
    });

    modManager.queueFuncOnce(610, (s,s2)->{ 
        defaultCamZoom = 1.2;
    });

    modManager.queueFuncOnce(615, (s,s2)->{ 
        defaultCamZoom = 0.95;
        camFlashSystem('fancy flash', {alpha: 0.4, ease: FlxEase.circOut, timer: 1.35});
    });

    modManager.queueFuncOnce(862, (s,s2)->{ 
        defaultCamZoom = 1.1;
    });

    modManager.queueFuncOnce(904, (s,s2)->{ 
        defaultCamZoom = 1.3;
    });

    modManager.queueFuncOnce(947, (s,s2)->{ 
        defaultCamZoom = 0.9;
    });

    modManager.queueFuncOnce(1115, (s,s2)->{ 
        defaultCamZoom = 0.8;
        FlxG.game.setFilters([new ShaderFilter(invert)]);
        invert.setFloat('binaryIntensity', 1000);
        invert.setFloat('negativity', 1);

        camGame.flash(FlxColor.BLACK, 2);
        modManager.queueEase(1828, 1873, "alpha", 0, "linear", -1);
    });

    modManager.queueFuncOnce(1828, (s,s2)->{ 
        FlxTween.tween(playHUD, {alpha: 1}, 3);
        invert.setFloat('negativity', 0);
        letsFight.visible = true;
        letsFight.seekTo(0);
        letsFight.resume();
    });

    modManager.queueFuncOnce(1818, (s,s2)->{ 
        defaultCamZoom = 2;
    });

    modManager.queueFuncOnce(1850, (s,s2)->{ 
        defaultCamZoom = 0.9;
        camGame.visible = true;
        camGame.zoom += 0.15;
        camFlashSystem('fancy flash', {alpha: 0.45, timer: 0.25});
    });

    modManager.queueFuncOnce(2018, (s,s2)->{ 
        defaultCamZoom = 1.15;
    });

    modManager.queueFuncOnce(2024, (s,s2)->{ 
        defaultCamZoom = 0.95;
        camFlashSystem('fancy flash', {alpha: 0.4, ease: FlxEase.circOut, timer: 1.35});
    });

    modManager.queueFuncOnce(2187, (s,s2)->{ 
        isCameraOnForcedPos = true;
        camFollow.x = 450;
        camFollow.y = 250;
        defaultCamZoom = 0.7;
    });

    modManager.queueFuncOnce(2524, (s,s2)->{ 
        defaultCamZoom = 0.95;
        camFollow.x = 0;
        camFollow.y = 0;
        isCameraOnForcedPos = false;
        invert.setFloat('negativity', 1);
        
        camGame.flash(FlxColor.BLACK, 2);
    });

    modManager.queueFuncOnce(2860, (s,s2)->{ 
        FlxTween.num(1, 0, 2, {ease: FlxEase.quartOut}, num -> invert.setFloat('negativity', num));
    });

    for (i in [2881, 2889, 2897])
    {
        modManager.queueFuncOnce(i, (s,s2)->{ 
            defaultCamZoom += 0.05;
        });
    }

    modManager.queueFuncOnce(2902, (s,s2)->{ 
        if (ClientPrefs.shaders)
        {
            // We make ur Laptop fry till the end of the song :fire: - MalyPlus
            camGame.filters = [new ShaderFilter(othershader)];
        }
        defaultCamZoom = 0.95;
    });

    modManager.queueFuncOnce(446 * 4, (s,s2)->{ 
        modManager.queueEase(447 * 4, 1818, "alpha", 1, "linear", -1);
    });

    modManager.queueFuncOnce(447 * 4, (s,s2)->{ 
        camGame.visible = false;
        FlxTween.tween(playHUD, {alpha: 0}, 2);
    });
}

function onDestroy()
{
    FlxG.game.setFilters([]);
}