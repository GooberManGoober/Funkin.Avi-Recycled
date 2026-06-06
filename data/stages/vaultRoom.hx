import openfl.filters.ShaderFilter;

var chains:FlxSprite;
var chainsI:FlxSprite;
var vault:FlxSprite;
var vaultI:FlxSprite;
var thingy:FlxSprite;
var thingyI:FlxSprite;

var chrom:FlxRuntimeShader;
var invert:FlxRuntimeShader = newShader('invertShader');

var pathway:String = 'stages/vaultRoom/';

function onLoad()
{
	defaultCamZoom = 0.9;
	
	chrom = newShader('aberration');
	chrom.setFloat('aberration', 0.06);
	chrom.setFloat('effectTime', 0.12);

	vault = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'vault'));
	vault.scale.set(1.45, 1.3);
	add(vault);
}

function onCreatePost()
{
	gf.visible = false;

	dad.blend = BlendMode.ADD;
    iconP2.blend = BlendMode.ADD;

    camGame.alpha = 0.001;
	camHUD.alpha = 0.001;
	
	chains = new FlxSprite(-225, -100).loadGraphic(Paths.image(pathway + 'chains'));
	chains.scale.set(1.5, 1.3);
	chains.scrollFactor.set(1.2, 1.25);
	foreground.add(chains);
	thingy = new FlxSprite(-200, -100).loadGraphic(Paths.image(pathway + 'holyshitdarkness'));
	thingy.scale.set(1.45, 1.3);
	foreground.add(thingy);
}

function onUpdate(elapsed)
{
	// shitty system for the camera to stay updated
    var wn_r:Float = 70;
    var rotRateWn = curStep / 9.5;
    var wn_toy = 0 + -Math.sin(rotRateWn * 2) * wn_r * 0.45;

	var bf_toy = -440 + -Math.sin(rotRateWn * 2) * wn_r * 0.45;

    if (dad.curCharacter == "white-noise")
    {
        dad.y += (wn_toy - dad.y) / 12;
        iconP2.y += (((healthBar.y - 85) + -Math.sin(rotRateWn * 2) * 20 * 0.45) - iconP2.y) / 12;
    }

	if (boyfriend.curCharacter == "bfghost")
    {
        boyfriend.y += (bf_toy - boyfriend.y) / 12;
    }
}

function onSongStart()
{
    modManager.queueFuncOnce(1, (s,s2)->{
        FlxTween.tween(camGame, {alpha: 1}, 5, {ease: FlxEase.expoOut});
    });

    modManager.queueFuncOnce(42, (s,s2)->{ 
        FlxTween.tween(camHUD, {alpha: 1}, 3);
    });
	
	modManager.queueFuncOnce(544 * 4, (s,s2)->{ 
		camGame.flash(FlxColor.WHITE, 3);
		if (ClientPrefs.shaders) camGame.filters = [new ShaderFilter(chrom)];

		defaultCamZoom = 0.65;
		camFollow.x = 600;
		camFollow.y = 400;
		isCameraOnForcedPos = true;

		FlxG.game.setFilters([new ShaderFilter(invert)]);
		invert.setFloat('binaryIntensity', 1000);
		invert.setFloat('negativity', 1);

		boyfriend.blend = BlendMode.ADD;

		FlxTween.tween(playHUD, {alpha: 0}, 0.6);
    });

	modManager.queueFuncOnce(608 * 4, (s,s2)->{ 
		camGame.flash(FlxColor.BLACK, 3);
		camGame.filtersEnabled = false;

		defaultCamZoom = 0.9;
		isCameraOnForcedPos = false;
		
		invert.setFloat('negativity', 0);

		boyfriend.blend = BlendMode.NORMAL;
		
		FlxTween.tween(playHUD, {alpha: 1}, 0.6);
	});

	modManager.queueFuncOnce(3072, (s,s2)->{ 
		defaultCamZoom = 1;
		camFollow.x = 1050;
		camFollow.y = 600;
		isCameraOnForcedPos = true;
	});

	modManager.queueFuncOnce(3200, (s,s2)->{ 
		defaultCamZoom = 0.86;
		isCameraOnForcedPos = false;
	});
}

function onDestroy()
{
    FlxG.game.setFilters([]);
}