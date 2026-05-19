import openfl.filters.ShaderFilter;

import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;

var chromZoomShader:FlxRuntimeShader = newShader('aberration');
var chromNormalShader:FlxRuntimeShader = newShader('aberrationDefault');
var dramaticCamMovement:FlxRuntimeShader = newShader('cameraMovement');
var monitorFilter:FlxRuntimeShader = newShader('monitorFilter');

var floor:FlxSprite;
var stageCurtains:FlxSprite;

var pathway:String = 'stages/crossover/';

var atmosphereParticle:FlxEmitter;
var ashParticle:FlxEmitter;

var chromEffect:Float = 0.0001;
var shaderAnim:Float = 0;

function onLoad()
{
    defaultCamZoom = 0.5;
    cameraSpeed = 1;
    
    floor = new FlxSprite(-500, -100).loadGraphic(Paths.image(pathway + 'street'));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    floor.scale.set(1.5, 1.5);
    floor.scrollFactor.set(1, 1);
    add(floor);	

    if(!ClientPrefs.lowQulity)
    {
        stageCurtains = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/abandonedStreet/i_forgor'));
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.screenCenter();
        stageCurtains.scale.set(1.3,1.3);
        stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
        stageCurtains.cameras = [camOther];
        stageCurtains.scrollFactor.set(1.3, 1.3);
        add(stageCurtains);
    }
}

function onCreatePost()
{
    snapCamToPos(475, 450, true);
    
    if (!ClientPrefs.lowQulity) // i made so the particles only appear on aviers side of the stage because sigma
    {
        atmosphereParticle = new FlxEmitter(-2180.5, 2100);
        atmosphereParticle.launchMode = FlxEmitterMode.SQUARE;
        atmosphereParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
        atmosphereParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
        atmosphereParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
        atmosphereParticle.width = 4787.45 / 2;
        atmosphereParticle.alpha.set(1, 0.3);
        atmosphereParticle.lifespan.set(1.9, 4.9);
        atmosphereParticle.loadParticles(Paths.image('stages/abandonedStreet/dustParticle'), 500, 16, true);
        atmosphereParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);

        ashParticle = new FlxEmitter(-2180.5, 2250.4);
        for (i in 0 ... 100)
            {
                var blackParticle = new FlxParticle();
                blackParticle.frames = Paths.getSparrowAtlas('stages/abandonedStreet/ashParticle');
                blackParticle.animation.addByPrefix('idle', 'ashParticle idle', 5, true);
                blackParticle.animation.play('idle');
                blackParticle.antialiasing = ClientPrefs.globalAntialiasing;
                blackParticle.exists = false;
                ashParticle.add(blackParticle);
            }
        ashParticle.launchMode = FlxEmitterMode.SQUARE;
        ashParticle.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
        ashParticle.scale.set(4, 4, 4, 4, 0, 0, 0, 0);
        ashParticle.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
        ashParticle.width = 4787.45 / 2;
        ashParticle.alpha.set(1, 1);
        ashParticle.lifespan.set(1.9, 4.9);
        ashParticle.start(false, FlxG.random.float(.0521, .1060), 1000000);
        ashParticle.angle.set(290, 0);
        ashParticle.launchAngle.set(0, 280);
        foreground.add(atmosphereParticle);
		foreground.add(ashParticle);
    }

    if (ClientPrefs.shaders)
    {
        if (!ClientPrefs.lowQuality)
        {
            camGame.filters = [
                new ShaderFilter(dramaticCamMovement),
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromZoomShader),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [new ShaderFilter(chromNormalShader)];
        }
        else
        {
            camGame.filters = [
                new ShaderFilter(monitorFilter),
                new ShaderFilter(chromNormalShader)
            ];
            camHUD.filters = [
                new ShaderFilter(chromNormalShader)
            ];
        }
    }
}

function onUpdate(elapsed)
{
    var shaderAnim = Conductor.songPosition / 1000;
    
    if (ClientPrefs.shaders)
    {
        chromZoomShader.setFloat('aberration', chromEffect);
        chromZoomShader.setFloat('effectTime', chromEffect);
        chromNormalShader.setFloat('rOffset', chromEffect / 45);
        chromNormalShader.setFloat('bOffset', -chromEffect / 45);
        dramaticCamMovement.setFloat('time', shaderAnim);
    }
}