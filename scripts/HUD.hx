import funkin.utils.MathUtil;
import flixel.util.FlxStringUtil;

using StringTools;

var spectraSongTime:FlxText;
var centerMark:FlxText; // song display name and difficulty at the center

var autoplaySine:Float = 0;
var autoplayMark:FlxText; // botplay/autoplay indicator at the center

var judgementCounter:FlxText;
var judgementUnderlay:FlxSprite;

var fancyBarOverlay:FlxSprite;

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
    playHUD.markupEnabled = false;
    playHUD.updateIconScale = PlayState.SONG.song != "Cycled Sins" ? true : false;
    
    if (PlayState.SONG.stage != "waltRoom") health = 0.5;

    switch (PlayState.SONG.song)
    {
        case "Devilish Deal", "Isolated", "Lunacy", "Delusional":
            engineDisplay = isStoryMode ? "~ Episode 1 ~" : "~ Freeplay ~";
        default:
            engineDisplay = isStoryMode ? "~ Episode ??? ~" : "Funkin.avi: Recycled";
    }
    
    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            fancyBarOverlay = new FlxSprite(healthBar.x, healthBar.y).loadGraphic(Paths.image('UI/episode1Overlay'));
            fancyBarOverlay.scale.set(1.01, 1);
            fancyBarOverlay.screenCenter(FlxAxes.X);
            fancyBarOverlay.scrollFactor.set();
            if (ClientPrefs.downScroll)
                fancyBarOverlay.y -= 10;
            else
            {
                fancyBarOverlay.y -= 117;
                fancyBarOverlay.flipY = true;
            }
            fancyBarOverlay.visible = !ClientPrefs.hideHud;
            playHUD.insert(1, fancyBarOverlay);

            scoreTxt.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            scoreTxt.scrollFactor.set();
            scoreTxt.borderSize = 1.25;

            watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
            watermarkTxt.setFormat(Paths.font('DisneyFont.ttf'), 32, FlxColor.WHITE);
            watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            watermarkTxt.setPosition(0, ClientPrefs.downScroll ? 655 : 8);
            watermarkTxt.screenCenter(FlxAxes.X);
            watermarkTxt.visible = !ClientPrefs.hideHud;
            playHUD.add(watermarkTxt);

            songTxt = new FlxText(watermarkTxt.x, watermarkTxt.y + 30, 1280, infoDisplay);
            songTxt.setFormat(Paths.font('DisneyFont.ttf'), 22, FlxColor.WHITE, "center");
            songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            songTxt.alpha = 0.6;
            songTxt.screenCenter(FlxAxes.X);
            songTxt.visible = !ClientPrefs.hideHud;
            playHUD.add(songTxt);

            autoplayMark = new FlxText(scoreTxt.x + 400, scoreTxt.y, FlxG.width, '', 32);
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
            autoplayMark.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center");
            autoplayMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.25);
            autoplayMark.screenCenter(FlxAxes.X);
            autoplayMark.alpha = 0;
            autoplayMark.visible = false;
            playHUD.add(autoplayMark);
        default:
            spectraSongTime = new FlxText(-108, ClientPrefs.downScroll ? 655 : 100, 400, "", 32);
            spectraSongTime.setFormat(Paths.font("VanillaExtractRegular.ttf"), 13, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            if (PlayState.SONG.song != "Cycled Sins") 
                spectraSongTime.screenCenter(FlxAxes.X);
            spectraSongTime.scrollFactor.set();
            spectraSongTime.visible = !ClientPrefs.hideHud;
            spectraSongTime.borderSize = 2;
            playHUD.add(spectraSongTime);

            healthBar.bg.loadGraphic(Paths.image('UI/healthBar-Long'));
            healthBar.barWidth = healthBar.bg.width;

            healthBar.x -= 100;
            healthBar.barCenter -= 100;

            scoreTxt.y = 600;
            scoreTxt.x -= 75;
            scoreTxt.setFormat(Paths.font("VanillaExtractRegular.ttf"), 14, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            scoreTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
            scoreTxt.visible = (!ClientPrefs.hideHud || !cpuControlled);

            watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
            watermarkTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
            watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            watermarkTxt.setPosition(0, ClientPrefs.downScroll ? 685 : 8);
            watermarkTxt.screenCenter(FlxAxes.X);
            watermarkTxt.visible = !ClientPrefs.hideHud;
            playHUD.add(watermarkTxt);

            songTxt = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 120 : 50), 0, 'Playing:');
            songTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
            songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (PlayState.SONG.song != "Cycled Sins") songTxt.screenCenter(FlxAxes.X);
            songTxt.visible = !ClientPrefs.hideHud;
            playHUD.add(songTxt);

            centerMark = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 100 : 70), 0, infoDisplay);
            centerMark.setFormat(Paths.font('VanillaExtractRegular.ttf'), 24, FlxColor.WHITE);
            centerMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            if (PlayState.SONG.song != "Cycled Sins") centerMark.screenCenter(FlxAxes.X);
            centerMark.visible = !ClientPrefs.hideHud;
            playHUD.add(centerMark);

            autoplayMark = new FlxText(0, 0, FlxG.width - 780, '', 32);
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
            autoplayMark.setFormat(Paths.font("VanillaExtractRegular.ttf"), 14, FlxColor.WHITE, "right");
            autoplayMark.y = 600;
            autoplayMark.x += 700;
            autoplayMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2.3);
            autoplayMark.alpha = 0;
            autoplayMark.visible = false;
            playHUD.add(autoplayMark);
    }

    if (ClientPrefs.showRatings && PlayState.SONG.song != "Cycled Sins")
    {
        judgementUnderlay = new FlxSprite(890, 0).loadGraphic(Paths.image('UI/judge-underlay')); 
        judgementUnderlay.scrollFactor.set();
        judgementUnderlay.scale.set(0.35, 0.32);
        judgementUnderlay.alpha = 0.45;
        judgementUnderlay.visible = !ClientPrefs.hideHud;
        playHUD.add(judgementUnderlay);

        judgementCounter = new FlxText(1155, 0, 0, "", 20);
        judgementCounter.setFormat(Paths.font("VanillaExtractRegular.ttf"), 17, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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
    if (!ClientPrefs.opponentStrums)
	{
		modManager.setValue("alpha", 1, 1);
	}
    
    var str:String = '${MathUtil.floorDecimal(ratingPercent * 100, 2)}% [${(totalPlayed != 0 ? ratingFC : 'N/A')}]';

    if (ClientPrefs.showRatings && PlayState.SONG.song != "Cycled Sins")
    {
        if (ClientPrefs.useEpicRankings)
            judgementCounter.text = 'Marvs: ${epics}\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
        else
            judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
    }

    scoreTxt.scale.set(1, 1);
    
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
        autoplayMark.visible = !ClientPrefs.hideHud;
        if (autoplayMark.visible)
        {
            autoplaySine += 180 * (elapsed / 4);
            autoplayMark.alpha = 1 - Math.sin((Math.PI * autoplaySine) / 80);
        }
    }
    else
    {
        scoreTxt.visible = !ClientPrefs.hideHud;
        autoplayMark.visible = false;
    }

    if (PlayState.chartingMode || ClientPrefs.inDevMode)
    {
        if (FlxG.keys.justPressed.SIX)
        {
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
        }
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
    }

    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            songTxt.alpha = 0.6 * playHUD.alpha;

    }

    if (ClientPrefs.showRatings && PlayState.SONG.song != "Cycled Sins")
    {
        judgementUnderlay.alpha = 0.45 * playHUD.alpha;
    }

    if (PlayState.SONG.song != "Devilish Deal")
    {
        switch (dad.curCharacter.toLowerCase())
        {
            case 'alphamouse', 'relapseNEW':
                //do nothing
            default:
                if (healthBar.percent > 80)
                    iconP2.animation.curAnim.curFrame = 1;
                else if (healthBar.percent < 20)
                    iconP2.animation.curAnim.curFrame = 2;
                else
                    iconP2.animation.curAnim.curFrame = 0;
        }

        switch (boyfriend.curCharacter)
        {
            case 'sunnyMouse', 'everett-relapse':
                //do nothing
            default:
                if (healthBar.percent > 80)
                    iconP1.animation.curAnim.curFrame = 2;
                else if (healthBar.percent < 20)
                    iconP1.animation.curAnim.curFrame = 1;
                else
                    iconP1.animation.curAnim.curFrame = 0;
        }
    }
}