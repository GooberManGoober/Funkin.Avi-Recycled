import funkin.utils.MathUtil;
import flixel.util.FlxStringUtil;

using StringTools;

var spectraSongTime:FlxText;
var centerMark:FlxText; // song display name and difficulty at the center

var autoplaySine:Float = 0;
var autoplayMark:FlxText; // botplay/autoplay indicator at the center

var judgementCounter:FlxText;
var judgementUnderlay:FlxSprite;

var botTxtArray:Array<Any> = [
    "AUTOPLAY",
    "BOTPLAY",
    "BURN IN HELL",
    "hi nikoru lol",
    "YOU'RE FUCKING CHEATING!",
    "what the rat doin?",
    "2 WORDS: GIT GUD",
    "JAMMING TO THE SONG",
    "you're just using the botplay key to see all these random messages, aren't you?",
    "YOU FUCKING SUCK AT RHYTHM GAMES LMFAO",
    "POV: YOU'RE TOO LAZY TO ACTUALLY PLAY THE GAME",
    "eyeless mouse is real.",
    "BOO!",
    "IT'S ABOUT DRIVE, IT'S ABOUT POWER",
    "WE STAY HUNGRY, WE DEVOUR",
    "i'm fucking high on crack man...",
    "ALL OF OUR FOOD KEEPS BLOWING UP",
    "sample text",
    "I did ur mom 2023",
    "WHAT THE FUCK IS WRONG WITH YOU?",
    "no.",
    "i bet you fail to the tutorial still...",
    "I will personally skin you <3",
    "BOTPLAY 2: ELECTRIC BOOGALOO",
    "five nights at freddy's"
];

var infoDisplay:String = PlayState.SONG.song.replace('-', ' ');
var engineDisplay:String = '~ Episode 1 ~';

var watermarkTxt:FlxText;
var songTxt:FlxText;

function onCreatePost()
{
    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
        default:
            if (ClientPrefs.downScroll) 
                spectraSongTime = new FlxText(-108, 655, 400, "", 32); 
            else 
                spectraSongTime = new FlxText(-108, 100, 400, "", 32);
            spectraSongTime.setFormat(Paths.font("VanillaExtractRegular.ttf"), 13, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            if (!ClientPrefs.middleScroll) 
                spectraSongTime.screenCenter(FlxAxes.X);
            spectraSongTime.scrollFactor.set();
            spectraSongTime.borderSize = 2;
            playHUD.add(spectraSongTime);
    }

    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            scoreTxt.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            scoreTxt.scrollFactor.set();
            scoreTxt.borderSize = 1.25;
            scoreTxt.visible = (!ClientPrefs.hideHud || !cpuControlled);
            playHUD.add(scoreTxt);
        default:
            scoreTxt.setFormat(Paths.font("VanillaExtractRegular.ttf"), 14, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            scoreTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
    }

    switch (PlayState.SONG.song)
    {
        case "Devilish Deal", "Isolated", "Lunacy", "Delusional":
            if (isStoryMode) 
                engineDisplay = "~ Episode 1 ~";
            else
                engineDisplay = "~ Freeplay ~";
        default:
            if (isStoryMode) 
                engineDisplay = "~ Episode ??? ~";
            else
                engineDisplay = "Funkin.avi: Recycled";
    }

    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
            watermarkTxt.setFormat(Paths.font('DisneyFont.ttf'), 32, FlxColor.WHITE);
            watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (ClientPrefs.downScroll) watermarkTxt.setPosition(0, 655); else watermarkTxt.setPosition(0, 8);
            watermarkTxt.screenCenter(FlxAxes.X);
            playHUD.add(watermarkTxt);

            songTxt = new FlxText(watermarkTxt.x, watermarkTxt.y + 30, 1280, infoDisplay);
            songTxt.setFormat(Paths.font('DisneyFont.ttf'), 22, FlxColor.WHITE, "center");
            songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            songTxt.alpha = 0.6;
            songTxt.screenCenter(FlxAxes.X);
            playHUD.add(songTxt);

            autoplayMark = new FlxText(scoreTxt.x + 400, scoreTxt.y, FlxG.width - 780, '', 32);
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
            autoplayMark.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center");
            autoplayMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.25);
            autoplayMark.alpha = 0;
            autoplayMark.visible = false;
            playHUD.add(autoplayMark);
        default:
            watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
            watermarkTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
            watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (ClientPrefs.downScroll) 
                watermarkTxt.setPosition(0, 685); 
            else 
                watermarkTxt.setPosition(0, 8);
            watermarkTxt.screenCenter(FlxAxes.X);
            playHUD.add(watermarkTxt);

            songTxt = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 120 : 50), 0, 'Playing:');
            songTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
            songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (!ClientPrefs.middleScroll) songTxt.screenCenter(FlxAxes.X);
            playHUD.add(songTxt);

            centerMark = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 100 : 70), 0, infoDisplay);
            centerMark.setFormat(Paths.font('VanillaExtractRegular.ttf'), 24, FlxColor.WHITE);
            centerMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (!ClientPrefs.middleScroll) centerMark.screenCenter(FlxAxes.X);
            playHUD.add(centerMark);

            autoplayMark = new FlxText(scoreTxt.x + 400, scoreTxt.y, FlxG.width - 780, '', 32);
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
            autoplayMark.setFormat(Paths.font("VanillaExtractRegular.ttf"), 14, FlxColor.WHITE, "center");
            autoplayMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2.3);
            autoplayMark.alpha = 0;
            autoplayMark.visible = false;
            playHUD.add(autoplayMark);

    }

    if (ClientPrefs.showRatings)
    {
        if(!PlayState.isPixelStage)
        {
            if(ClientPrefs.downScroll) 
                judgementUnderlay = new FlxSprite(910, 0).loadGraphic(Paths.image('Funkin_avi/ui/judge-underlay')); 
            else 
                judgementUnderlay = new FlxSprite(890, 0).loadGraphic(Paths.image('Funkin_avi/ui/judge-underlay'));
            judgementUnderlay.scrollFactor.set();
            judgementUnderlay.scale.set(0.35, 0.32);
            judgementUnderlay.alpha = 0.45;
            judgementUnderlay.visible = !ClientPrefs.hideHud;
            playHUD.add(judgementUnderlay);
        }
        else
        {
            if(ClientPrefs.downScroll) 
                judgementUnderlay = new FlxSprite(890, 0).loadGraphic(Paths.image('Funkin_avi/ui/judge-underlay')); 
            else 
                judgementUnderlay = new FlxSprite(870, 0).loadGraphic(Paths.image('Funkin_avi/ui/judge-underlay'));
            judgementUnderlay.scrollFactor.set();
            judgementUnderlay.scale.set(0.37, 0.32);
            judgementUnderlay.alpha = 0.45;
            judgementUnderlay.visible = !ClientPrefs.hideHud;
            playHUD.add(judgementUnderlay);
        }

        if (!PlayState.isPixelStage)
        {
            judgementCounter = new FlxText(1155, 0, 0, "", 20);
            judgementCounter.setFormat(Paths.font("VanillaExtractRegular.ttf"), 17, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        }
        else 
        {
            judgementCounter = new FlxText(1125, 0, 0, "", 20);
            judgementCounter.setFormat(Paths.font("m40.ttf"), 17, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        }
        judgementCounter.borderSize = 2;
        judgementCounter.borderQuality = 2;
        judgementCounter.scrollFactor.set();
        judgementCounter.screenCenter(FlxAxes.Y);
        judgementCounter.visible = !ClientPrefs.hideHud;
        playHUD.add(judgementCounter);
    }
}

function onUpdatePost(elapsed)
{
    var str:String = '${MathUtil.floorDecimal(ratingPercent * 100, 2)}% [${(totalPlayed != 0 ? ratingFC : 'N/A')}]';

    if (ClientPrefs.showRatings)
    {
        if (ClientPrefs.useEpicRankings)
            judgementCounter.text = 'Epics: ${epics}\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
        else
            judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
    }
    
    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            scoreTxt.text = 'Score: ' + FlxStringUtil.formatMoney(songScore, false) 
            + ' - Combo Breaks: ' + songMisses 
            + ' - Accuracy: ' + str;
        default:
            scoreTxt.text = 'Score: ' + FlxStringUtil.formatMoney(songScore, false)
            + ' / Accuracy: ' + str
            + ' / Combo Breaks: ' + songMisses;
    }

    botplayTxt.visible = timeBar.visible = timeTxt.visible = false;
    if (cpuControlled)
    {
        scoreTxt.visible = false;
        autoplayMark.visible = true;
        if (autoplayMark.visible)
        {
            autoplaySine += 180 * (elapsed / 4);
            autoplayMark.alpha = 1 - Math.sin((Math.PI * autoplaySine) / 80);
        }
    }
    else
    {
        scoreTxt.visible = true;
        autoplayMark.visible = false;
    }

    if (!startingSong)
    {
        if (!paused)
        {
            if(updateTime) {
                var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
                if(curTime < 0) curTime = 0;
                songPercent = (curTime / songLength);

                var songCalc:Float = (songLength - curTime);

                var secondsTotal:Int = Math.floor(curTime / 1000);
                if(secondsTotal < 0) secondsTotal = 0;

                switch (PlayState.SONG.stage)
                {
                    case 'abandonedStreet', 'ddStage':
                        //Do nothing cuz fuck you
                    default:
                        spectraSongTime.text = FlxStringUtil.formatTime(secondsTotal, false) + ' / ' + FlxStringUtil.formatTime(Math.floor(songLength / 1000), false);
                }
            }
        }

        // Conductor.lastSongPos = FlxG.sound.music.time;
    }
}