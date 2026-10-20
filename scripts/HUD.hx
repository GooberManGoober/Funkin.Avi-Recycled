using StringTools;

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

function onCreatePost()
{
    if (PlayState.SONG.stage != "waltRoom") health = 0.5;

    switch (PlayState.SONG.stage)
    {	
        case 'abandonedStreet', 'ddStage':
            autoplayMark = new FlxText(scoreTxt.x + 400, scoreTxt.y, FlxG.width, '', 32);
            autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';
            autoplayMark.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center");
            autoplayMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.25);
            autoplayMark.screenCenter(FlxAxes.X);
            autoplayMark.alpha = 0;
            autoplayMark.visible = false;
            playHUD.add(autoplayMark);
        default:
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
    if (ClientPrefs.showRatings && PlayState.SONG.song != "Cycled Sins")
    {
        if (ClientPrefs.useEpicRankings) judgementCounter.text = 'Marvs: ${epics}\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
        else judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\n';
    }

    botplayTxt.visible = false;
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

    if ((PlayState.chartingMode || ClientPrefs.inDevMode) && FlxG.keys.justPressed.SIX) autoplayMark.text = '[' + botTxtArray[FlxG.random.int(0, botTxtArray.length-1)] + ']';

    if (ClientPrefs.showRatings && PlayState.SONG.song != "Cycled Sins") judgementUnderlay.alpha = 0.45 * playHUD.alpha;

    if (PlayState.SONG.song != "Devilish Deal")
    {
        switch (dad.curCharacter.toLowerCase())
        {
            case 'alphamouse', 'relapseNEW': //do nothing
            default:
                if (healthBar.percent > 80) iconP2.animation.curAnim.curFrame = 1;
                else if (healthBar.percent < 20) iconP2.animation.curAnim.curFrame = 2;
                else iconP2.animation.curAnim.curFrame = 0;
        }

        switch (boyfriend.curCharacter)
        {
            case 'sunnyMouse', 'everett-relapse': //do nothing
            default:
                if (healthBar.percent > 80) iconP1.animation.curAnim.curFrame = 2;
                else if (healthBar.percent < 20) iconP1.animation.curAnim.curFrame = 1;
                else iconP1.animation.curAnim.curFrame = 0;
        }
    }
}