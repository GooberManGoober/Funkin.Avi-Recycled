import openfl.filters.ShaderFilter;
import funkin.utils.MathUtil;

var staticEffect:FlxRuntimeShader = newShader('tvStatic');

var shaderAnim:Float = 0;

function onLoad()
{
    defaultCamZoom = 0.75;
    cameraSpeed = 2.5;

    beatsPerZoom = 8;

    var office:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('Funkin_avi/stages/trueGrinsOfSins/office'));
    office.antialiasing = true;
    office.scrollFactor.set(1, 1);
    office.active = false;
    add(office);

    var chair:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('Funkin_avi/stages/trueGrinsOfSins/chair'));
    chair.antialiasing = true;
    chair.scrollFactor.set(1, 1);
    chair.active = false;
    add(chair);

    office.scale.set(0.85, 0.8);
    chair.scale.set(0.9, 0.85);
}

function onCreatePost()
{
    playHUD.updateIconScale = false;
    
    var funiLight:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('Funkin_avi/stages/trueGrinsOfSins/light'));
    funiLight.antialiasing = true;
    funiLight.scrollFactor.set(1, 1);
    funiLight.alpha = 0.6;
    funiLight.blend = CoolUtil.getBlendFromString('add');
    funiLight.active = false;
    add(funiLight);
    funiLight.scale.set(0.85, 0.8);
    
    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(staticEffect)
            ];
        }
    }
}

function onBeatHit()
{
    if (curBeat % 2 == 0)
    {
        iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);
		
		iconP1.updateHitbox();
		iconP2.updateHitbox();
    }
}

function onUpdate(elapsed)
{
    shaderAnim = Conductor.songPosition / 1000;
    
    if (ClientPrefs.shaders)
    {
        staticEffect.setFloat('uTime', shaderAnim);
        staticEffect.setFloat('iTime', shaderAnim);
    }

    final mult:Float = MathUtil.decayLerp(iconP1.scale.x, 1, 9, elapsed);
    iconP1.scale.set(mult, mult);
    iconP1.updateHitbox();

    final mult:Float = MathUtil.decayLerp(iconP2.scale.x, 1, 9, elapsed);
    iconP2.scale.set(mult, mult);
    iconP2.updateHitbox();
}