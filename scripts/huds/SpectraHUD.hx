import flixel.util.FlxStringUtil;

import funkin.objects.Bar;
import funkin.objects.HealthIcon;
import funkin.utils.MathUtil;
import funkin.FunkinAssets;

using StringTools;

var healthBar:Bar;
var iconP1:HealthIcon;
var iconP2:HealthIcon;
var scoreTxt:FlxText;

var healthLerp:Float = 1;

var spectraSongTime:FlxText;
var centerMark:FlxText; // song display name and difficulty at the center

var infoDisplay:String = PlayState.SONG.song.replace('-', ' ');
var engineDisplay:String = '~ Episode 1 ~';

var watermarkTxt:FlxText;
var songTxt:FlxText;

function onLoad()
{
    name = 'SPECTRA';
    
    engineDisplay = parent.isStoryMode ? "~ Episode ??? ~" : "Funkin.avi: Recycled";
    
    spectraSongTime = new FlxText(-108, ClientPrefs.downScroll ? 655 : 100, 400, "", 32);
    spectraSongTime.setFormat(Paths.font("VanillaExtractRegular.ttf"), 13, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    if (PlayState.SONG.song != "Cycled Sins") 
        spectraSongTime.screenCenter(FlxAxes.X);
    spectraSongTime.scrollFactor.set();
    spectraSongTime.visible = !ClientPrefs.hideHud;
    spectraSongTime.borderSize = 2;
    add(spectraSongTime);

    final healthGraphic = FunkinAssets.exists(Paths.mods('images/${Paths.UI_PREFIX}healthBar-Long')) ? '${Paths.UI_PREFIX}healthBar-Long' : 'UI/healthBar-Long';
    
    healthBar = new Bar(-100, FlxG.height * (!ClientPrefs.downScroll ? 0.89 : 0.11), healthGraphic, function() return healthLerp, parent.healthBounds.min, parent.healthBounds.max);
    healthBar.screenCenter(FlxAxes.X);
    healthBar.leftToRight = false;
    healthBar.scrollFactor.set();
    healthBar.visible = !ClientPrefs.hideHud;
    healthBar.alphaMultipler = ClientPrefs.healthBarAlpha;
    
    reloadHealthBarColors();
    add(healthBar);

    iconP1 = new HealthIcon(parent.boyfriend.healthIcon, true);
    iconP1.y = healthBar.y - 75;
    iconP1.visible = !ClientPrefs.hideHud;
    iconP1.alphaMultipler = ClientPrefs.healthBarAlpha;
    iconP1.frameCount = parent.boyfriend.iconFrames;
    add(iconP1);
    
    iconP2 = new HealthIcon(parent.dad.healthIcon, false);
    iconP2.y = healthBar.y - 75;
    iconP2.visible = !ClientPrefs.hideHud;
    iconP2.alphaMultipler = ClientPrefs.healthBarAlpha;
    iconP2.frameCount = parent.dad.iconFrames;
    add(iconP2);

    scoreTxt = new FlxText(-75, 600, FlxG.width, "", 20);
    scoreTxt.setFormat(Paths.font("VanillaExtractRegular.ttf"), 14, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
    scoreTxt.scrollFactor.set();
    scoreTxt.borderSize = 1.25;
    scoreTxt.visible = (!ClientPrefs.hideHud || !parent.cpuControlled);
    add(scoreTxt);

    watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
    watermarkTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
    watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    watermarkTxt.setPosition(0, ClientPrefs.downScroll ? 685 : 8);
    watermarkTxt.screenCenter(FlxAxes.X);
    watermarkTxt.visible = !ClientPrefs.hideHud;
    add(watermarkTxt);

    songTxt = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 120 : 50), 0, 'Playing:');
    songTxt.setFormat(Paths.font('VanillaExtractRegular.ttf'), 16, FlxColor.WHITE);
    songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    if (PlayState.SONG.song != "Cycled Sins") songTxt.screenCenter(FlxAxes.X);
    songTxt.visible = !ClientPrefs.hideHud;
    add(songTxt);

    centerMark = new FlxText(50, (ClientPrefs.downScroll ? FlxG.height - 100 : 70), 0, infoDisplay);
    centerMark.setFormat(Paths.font('VanillaExtractRegular.ttf'), 24, FlxColor.WHITE);
    centerMark.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    if (PlayState.SONG.song != "Cycled Sins") centerMark.screenCenter(FlxAxes.X);
    centerMark.visible = !ClientPrefs.hideHud;
    add(centerMark);

    ratingGraphic = new FlxSprite();
    ratingGraphic.alpha = 0;
    add(ratingGraphic);
    
    ratingNumGroup = new FlxTypedGroup();
    add(ratingNumGroup);
    
    onUpdateScore(0, 0, 0);

    parent.scripts.set('spectraSongTime', spectraSongTime);
    parent.scripts.set('healthBar', healthBar);
    parent.scripts.set('iconP1', iconP1);
    parent.scripts.set('iconP2', iconP2);
    parent.scripts.set('scoreTxt', scoreTxt);
    parent.scripts.set('watermarkTxt', watermarkTxt);
    parent.scripts.set('songTxt', songTxt);
    parent.scripts.set('centerMark', centerMark);

    parent.scripts.set('ratingGraphic', ratingGraphic);
	parent.scripts.set('ratingNumGroup', ratingNumGroup);

    if (comboOffsets == null) comboOffsets = ClientPrefs.comboOffset;
}

function onUpdate(elapsed)
{
    updateIconsPosition();
    updateIconsScale(elapsed);
    updateIconsAnimation();
    updateHealthBar();

    if (!parent.startingSong && !parent.paused && parent.updateTime && !parent.endingSong)
    {
        var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);
        parent.songPercent = (curTime / parent.songLength);

        var songCalc:Float = (parent.songLength - curTime);

        var secondsTotal:Int = Math.floor(curTime / 1000);
        if(secondsTotal < 0) secondsTotal = 0;

        spectraSongTime.text = FlxStringUtil.formatTime(secondsTotal, false) + ' / ' + FlxStringUtil.formatTime(Math.floor(songLength / 1000), false);
    }
}

function onUpdateScore(score, accuracy, misses, ?missed)
{
    var str:String = '$accuracy% [${(parent.totalPlayed != 0 ? parent.ratingFC : 'N/A')}]';

    scoreTxt.text = 'Score: ${FlxStringUtil.formatMoney(score, false)} / Accuracy: $str / Combo Breaks: $misses';
}

function updateIconsPosition()
{
    if (!updateIconPos) return;
    
    final iconOffset:Int = 26;
    if (!healthBar.leftToRight)
    {
        iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
        iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
    }
    else
    {
        iconP1.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
        iconP2.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
    }
}

function updateIconsScale(elapsed:Float)
{
    if (!updateIconScale) return;
    
    final mult:Float = MathUtil.decayLerp(iconP1.scale.x, 1, 9, elapsed);
    iconP1.scale.set(mult, mult);
    iconP1.updateHitbox();
    
    final mult:Float = MathUtil.decayLerp(iconP2.scale.x, 1, 9, elapsed);
    iconP2.scale.set(mult, mult);
    iconP2.updateHitbox();
}

function updateIconsAnimation()
{
    iconP1.updateIconAnim(healthBar.percent * 0.01);
    iconP2.updateIconAnim((100 - healthBar.percent) * 0.01);
}

function updateHealthBar() healthLerp = FlxMath.lerp(healthLerp, parent.health, .2 / (ClientPrefs.framerate / 60));

function reloadHealthBarColors()
{
    var dad = parent.dad;
    var boyfriend = parent.boyfriend;
    if (!healthBar.leftToRight) healthBar.setColors(dad.healthColour, boyfriend.healthColour);
    else healthBar.setColors(boyfriend.healthColour, dad.healthColour);
}

function flipBar()
{
    healthBar.leftToRight = !healthBar.leftToRight;
    iconP1.flipX = !iconP1.flipX;
    iconP2.flipX = !iconP2.flipX;
}

function onBeatHit()
{
    if (!updateIconScale) return;
    
    iconP1.scale.set(1.2, 1.2);
    iconP2.scale.set(1.2, 1.2);
    
    iconP1.updateHitbox();
    iconP2.updateHitbox();
}

function onCharacterChange()
{
    reloadHealthBarColors();

    iconP1.changeIcon(parent.boyfriend.healthIcon);
    iconP1.frameCount = parent.boyfriend.iconFrames;

    iconP2.changeIcon(parent.dad.healthIcon);
    iconP2.frameCount = parent.dad.iconFrames;
}

function onHealthChange(health)
{
    final newPercent:Null<Float> = FlxMath.remapToRange(FlxMath.bound(healthBar.valueFunction(), healthBar.bounds.min, healthBar.bounds.max), healthBar.bounds.min, healthBar.bounds.max, 0, 100);
    healthBar.percent = (newPercent != null ? newPercent : 0);
}

function onPopUpScore(daRating, combo, note)
{
    if (ClientPrefs.hideHud) return;
    
    parent.scripts.call('onPopUpScore', [note, daRating, ratingGraphic, ratingNumGroup]);
    
    parent.scripts.call('onPopUpScorePost', [note, daRating, ratingGraphic, ratingNumGroup]);
}

function cachePopUpScore()
{
    var ratings = ["sick", "good", "bad", "shit"];
    if (ClientPrefs.useEpicRankings) ratings.push('epic');
    
    for (rating in ratings) Paths.image('$ratingPrefix$rating$ratingSuffix');
    
    for (i in 0...10) Paths.image('${comboPrefix}num$i$ratingSuffix');
}