import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import lime.app.Application;
import openfl.filters.ShaderFilter;
import funkin.states.MainMenuState;

using StringTools;

var upText:FlxText;
var downText:FlxText;

var monitor:FlxRuntimeShader;

var controls = Controls.instance;

function onCreate() 
{
    monitor = newShader('monitorFilter');

    if (ClientPrefs.shaders)
    {
        FlxG.camera.filters = [new ShaderFilter(monitor)];
    }

    var eyes:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/HahaSadBoi'));
    eyes.scrollFactor.set(0, 0);
    eyes.screenCenter();
    eyes.updateHitbox();
    eyes.antialiasing = true;
    add(eyes);

    upText = new FlxText(0, 20, 0, 'Lmao, you thought this was on Psych Engine?', 32);
    upText.setFormat(Paths.font('DisneyFont.ttf'), 50, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    upText.screenCenter(FlxAxes.X);
    upText.setFormat(Paths.font('DisneyFont.ttf'), 50, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(upText);

    downText = new FlxText(0, 560, 0, 'Man, these psych kids be so down bad rn lmfao.\n(Press ESC to leave)', 32);
    downText.setFormat(Paths.font('DisneyFont.ttf'), 50, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    downText.screenCenter(FlxAxes.X);
    add(downText);

    var scratch:FlxSprite = new FlxSprite();
    scratch.frames = Paths.getSparrowAtlas('filters/scratchShit');
    scratch.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
    scratch.animation.play('idle');
    scratch.screenCenter();
    scratch.scale.x = 1.1;
    scratch.scale.y = 1.1;
    add(scratch);

    var grain:FlxSprite = new FlxSprite();
    grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
    grain.animation.addByPrefix('idle', 'grains 1', 24, true);
    grain.animation.play('idle');
    grain.screenCenter();
    grain.scale.x = 1.1;
    grain.scale.y = 1.1;
    add(grain);
}

function onUpdate(elapsed) {

    if (controls.BACK)
    {
        Application.current.window.alert('Bro think there was sex', 'L moment');
        FlxG.switchState(new MainMenuState());
    }
}