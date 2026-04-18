import funkin.audio.visualize.PolygonSpectogram;
import funkin.audio.visualize.PolygonSpectogram.VISTYPE;
import funkin.audio.visualize.SpectogramSprite.SPECDIRECTION;
import funkin.states.MainMenuState;
import funkin.data.Chart;
import lime.app.Application;
import funkin.FunkinAssets;
import flixel.util.FlxStringUtil;

using StringTools;

var songArt:FlxSprite;
var disc:FlxSprite;
var songArtOutline:FlxSprite;

var controls = Controls.instance;

var vocals:Null<FlxSound> = null;
var inst:FlxSound = null;

var viz:PolygonSpectogram;

var curSong = 0;

var songIsPLaying:Bool = false;

var timeTxt:FlxText;
var timeBar:Bar;
var songNameTxt:FlxText;
var botplaytext:FlxText;
var textBG:FlxSprite;

var bg2:FlxSprite;

var inSelectorMode:Bool = true;
var shuffle:Bool = false;

var songList:Array<String> = [
    'Devilish Deal',
    'Isolated',
    'Lunacy',
    'Delusional',
    //Extras
    'Hunted',
	'Laugh Track',
	'Bless',
	"Don't Cross!",
	'War Dilemma',
	'Neglection',
	'Twisted Grins',
    'Mercy',
    'Cycled Sins',
    'Malfunction',
    'Birthday',
    //Covers & Collabs
	'Delusion',
	'Disclosure',
    'Bless Legacy'
];

var songPercent:Float = 0;

function onLoad()
{
    for (i in songList)
        Paths.image('menus/pause/songs/${songList[i].toLowerCase().replace(' ', '-')}');
    
    FlxG.sound.music.volume = 0;

    Application.current.window.title = "Funkin.avi: Recycled - Juke Box";

    var bg:FlxSprite = new FlxSprite();
	bg.loadGraphic(Paths.image('menus/title/Title_bg'), false);
	bg.screenCenter();
	bg.scale.x = 0.68;
	bg.scale.y = 0.67;
	add(bg);

    viz = new PolygonSpectogram(null, FlxColor.WHITE, 1280, 2, SPECDIRECTION.HORIZONTAL);
    viz.waveAmplitude = 720 / 4;
	viz.thickness = 4;
	viz.y = 720 / 2;
    viz.color = FlxColor.WHITE;
    add(viz);

    var logoBl:FlxSprite = new FlxSprite(150, -75);
	logoBl.frames = Paths.getSparrowAtlas('menus/title/MickeyLogo');
	logoBl.antialiasing = ClientPrefs.globalAntialiasing;
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
	logoBl.updateHitbox();
	logoBl.screenCenter();
    logoBl.scale.set(0.65, 0.65);
    logoBl.x += 350;
	add(logoBl);

    final timeGraphic = 'UI/healthBar-Long';

    timeBar = new Bar(500, FlxG.height - 60, timeGraphic, function() return songPercent, 0, 1);
    timeBar.scrollFactor.set();
    timeBar.screenCenter(FlxAxes.X).x += 100;
    add(timeBar);

    timeTxt = new FlxText(50, timeBar.y - 30, FlxG.width, "", 32);
    timeTxt.setFormat(Paths.font('DisneyFont.ttf'), 26, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    timeTxt.scrollFactor.set();
    timeTxt.borderSize = 2;
    add(timeTxt);

    bg2 = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	bg2.setGraphicSize(FlxG.width, FlxG.height);
	bg2.updateHitbox();
	bg2.scrollFactor.set();
	add(bg2);
	bg2.alpha = 0.75;

    songArt = new FlxSprite(-500, -60).loadGraphic(Paths.image('menus/pause/songs/unknown-song'));
    songArt.screenCenter(FlxAxes.X);
    songArt.scale.set(0.53, 0.53);

    disc = new FlxSprite(songArt.x, songArt.y - 12).loadGraphic(Paths.image('menus/pause/disc'));
    disc.scale.set(0.52, 0.52);

    songArtOutline = new FlxSprite(songArt.x - 20, songArt.y - 20).makeGraphic(890, 890, FlxColor.WHITE);
	songArtOutline.scale.set(0.53, 0.53);

    for (obj in [disc, songArtOutline, songArt])
		add(obj);

    songNameTxt = new FlxText(0, 19, FlxG.width, "", 32);
    songNameTxt.setFormat(Paths.font('DisneyFont.ttf'), 36, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songNameTxt.scrollFactor.set();
    songNameTxt.borderSize = 2;
    add(songNameTxt);

    textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
	textBG.alpha = 0.6;
	add(textBG);

    botplaytext = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press SPACE to play a selected song', 18);
	botplaytext.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, "center");
	botplaytext.scrollFactor.set();
	add(botplaytext);

    var globalGradient = new FlxSprite().loadGraphic(Paths.image('filters/gradient'));
	globalGradient.screenCenter();
	globalGradient.setGraphicSize(Std.int(globalGradient.width * 0.68));
	globalGradient.alpha = 1;
	add(globalGradient);

    changeSongSelection(0, false, true);
}

var selectedSomethin:Bool = false;

function onUpdate(elapsed)
{
    if (songIsPLaying) 
    {
        disc.angle += 1;

        var curTime:Float = Math.max(0, inst.time);
        songPercent = curTime / inst.length;

        var songCalc:Float = (inst.length - curTime);

        var secondsTotal:Int = Math.floor(curTime / 1000);
        if(secondsTotal < 0) secondsTotal = 0;

        timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false) + ' / ' + FlxStringUtil.formatTime(Math.floor(inst.length / 1000), false);
    }

    if (FlxG.sound.music.volume > 0 && !selectedSomethin)
		FlxG.sound.music.volume = 0;

    if (vocals != null && vocals.length > inst.time)
    {
		vocals.time = inst.time;
    }

    if (controls.BACK && !selectedSomethin)
    {
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        destroyFreeplayVocals();
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
        FlxG.switchState(new MainMenuState());
        FlxG.autoPause = ClientPrefs.autoPause;
    }

    if (inSelectorMode)
    {
        if (controls.UI_LEFT_P)
            changeSongSelection(-1, false, true);

        if (controls.UI_RIGHT_P)
            changeSongSelection(1, false, true);
    }

    if (songIsPLaying)
    {
        if (FlxG.keys.justPressed.S)
        {
            shuffle = !shuffle;
            botplaytext.text = 'Press SPACE to change what song to play / Press S to toggle shuffling (${shuffle ? 'ON' : 'OFF'})';
        }
    }

    if (FlxG.keys.justPressed.SPACE)
    {
        if (!songIsPLaying)
        {
            playSelectedSong();

            FlxTween.tween(bg2, {alpha: 0}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArtOutline, {x: -520}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(disc, {x: -325}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArt, {x: -500}, 0.75, {ease: FlxEase.expoOut});

            FlxG.autoPause = false;
            inSelectorMode = false;

            botplaytext.text = 'Press SPACE to change what song to play / Press S to toggle shuffling (${shuffle ? 'ON' : 'OFF'})';

            FlxTween.tween(songArt.scale, {x: 0.69, y: 0.69}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(disc.scale, {x: 0.68, y: 0.68}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArtOutline.scale, {x: 0.69, y: 0.69}, 0.75, {ease: FlxEase.expoOut});
        }
        else
        {
            pauseSelectedSong();

            FlxTween.tween(bg2, {alpha: 0.75}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArtOutline, {x: 212}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(disc, {x: 232}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArt, {x: 232}, 0.75, {ease: FlxEase.expoOut});

            FlxG.autoPause = ClientPrefs.autoPause;
            inSelectorMode = true;

            botplaytext.text = "Press SPACE to play a selected song";

            FlxTween.tween(songArt.scale, {x: 0.59, y: 0.59}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(disc.scale, {x: 0.58, y: 0.58}, 0.75, {ease: FlxEase.expoOut});
            FlxTween.tween(songArtOutline.scale, {x: 0.59, y: 0.59}, 0.75, {ease: FlxEase.expoOut});
        }
    }
}

function changeSongSelection(change:Int, ?forcePlay:Bool = false, ?goToSelector:Bool = false)
{
    curSong = FlxMath.wrap(curSong + change, 0, songList.length - 1);

    var pauseArtAsset:String = songList[curSong].toLowerCase().replace(" ", "-");
    
    if (FunkinAssets.exists(Paths.getPath('images/menus/pause/songs/' + pauseArtAsset + '.png', null, true)))
		songArt.loadGraphic(Paths.image('menus/pause/songs/' + pauseArtAsset));
	else 
		songArt.loadGraphic(Paths.image('menus/pause/songs/unknown-song'));

    songNameTxt.text = '< ${songList[curSong]} >';

    if (!forcePlay)
        FlxG.sound.play(Paths.sound('funkinAVI/menu/scrollSfx'));

    if (forcePlay) playSelectedSong();

    inSelectorMode = goToSelector;
}

function playSelectedSong()
{
    destroyFreeplayVocals();

    songIsPLaying = true;

    PlayState.SONG = Chart.fromSong(songList[curSong], 2);
    
    inst = new FlxSound().loadEmbedded(Paths.inst(songList[curSong]));
    inst.play();
    inst.persist = true;
    inst.looped = true;
    inst.volume = 1;
    inst.onComplete = function()
    {
        inst.volume = 0;
        
        changeSongSelection(shuffle ? FlxG.random.int(1, songList.length - 1) : 1, true);
    };
    FlxG.sound.list.add(inst);

    // ??? why would you ever to do rewrite this
    if (PlayState.SONG.needsVoices) vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
    else vocals = new FlxSound();
    vocals.play();
    vocals.persist = true;
    vocals.looped = true;
    vocals.volume = 1;
    FlxG.sound.list.add(vocals);

    viz.setSound(inst);
}

function pauseSelectedSong()
{
    destroyFreeplayVocals();

    songIsPLaying = false;
}

function destroyFreeplayVocals()
{
    if (vocals != null)
    {
        vocals.stop();
        vocals.destroy();
    }
    vocals = null;

    if (inst != null)
    {
        inst.stop();
        inst.destroy();
    }
    inst = null;
}