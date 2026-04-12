import funkin.audio.visualize.PolygonSpectogram;
import funkin.audio.visualize.PolygonSpectogram.VISTYPE;
import funkin.audio.visualize.SpectogramSprite.SPECDIRECTION;
import funkin.states.MainMenuState;

var songArt:FlxSprite;
var disc:FlxSprite;
var songArtOutline:FlxSprite;

var controls = Controls.instance;

function onLoad()
{
    var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/title/Title_bg'), false);
	bg.screenCenter();
	bg.scale.x = 0.68;
	bg.scale.y = 0.67;
	add(bg);

    var globalGradient = new FlxSprite().loadGraphic(Paths.image('filters/gradient'));
	globalGradient.screenCenter();
	globalGradient.setGraphicSize(Std.int(globalGradient.width * 0.68));
	globalGradient.alpha = 1;
	add(globalGradient);
    
    var viz = new PolygonSpectogram(FlxG.sound.music, FlxColor.WHITE, 1280, 2, SPECDIRECTION.HORIZONTAL);
    viz.waveAmplitude = 720 / 4;
    viz.thickness = 4;
    viz.y = 720 / 2;
    viz.color = FlxColor.WHITE;
    add(viz);

    songArt = new FlxSprite(-500, -60).loadGraphic(Paths.image('menus/pause/songs/unknown-song'));
    songArt.scale.set(0.69, 0.69);

    disc = new FlxSprite(songArt.x + 175, songArt.y - 12).loadGraphic(Paths.image('menus/pause/disc'));
    disc.scale.set(0.68, 0.68);

    songArtOutline = new FlxSprite(songArt.x - 20, songArt.y - 20).makeGraphic(890, 890, FlxColor.WHITE);
	songArtOutline.scale.set(0.69, 0.69);

    for (obj in [disc, songArtOutline, songArt])
		add(obj);

    var logoBl:FlxSprite = new FlxSprite(150, -75);
	logoBl.frames = Paths.getSparrowAtlas('menus/title/MickeyLogo');
	logoBl.antialiasing = ClientPrefs.globalAntialiasing;
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
	logoBl.updateHitbox();
	logoBl.screenCenter();
    logoBl.scale.set(0.65, 0.65);
    logoBl.x += 350;
	add(logoBl);
}

var selectedSomethin:Bool = false;

function onUpdate(elapsed)
{
    disc.angle += 1;

    if (controls.BACK && !selectedSomethin)
    {
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxTween.tween(disc, {x: songArt.x - 175}, 2.5, {ease: FlxEase.circIn, onComplete: 
		    function(twn:FlxTween)
			{
				FlxG.switchState(new MainMenuState());
			}
		});
    }
}