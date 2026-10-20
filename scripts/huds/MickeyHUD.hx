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

var fancyBarOverlay:FlxSprite;

var infoDisplay:String = PlayState.SONG.song.replace('-', ' ');
var engineDisplay:String = '~ Episode 1 ~';

var watermarkTxt:FlxText;
var songTxt:FlxText;

function onLoad()
{
    name = 'MICKEY';
    
    markupEnabled = false;
    updateIconScale = PlayState.SONG.song != "Cycled Sins" ? true : false;

    engineDisplay = isStoryMode ? "~ Episode 1 ~" : "~ Freeplay ~";

    final healthGraphic = FunkinAssets.exists(Paths.mods('images/${Paths.UI_PREFIX}healthBar')) ? '${Paths.UI_PREFIX}healthBar' : 'UI/healthBar';
    healthBar = new Bar(0, FlxG.height * (!ClientPrefs.downScroll ? 0.89 : 0.11), healthGraphic, function() return healthLerp, parent.healthBounds.min, parent.healthBounds.max);
    healthBar.screenCenter(FlxAxes.X);
    healthBar.leftToRight = false;
    healthBar.scrollFactor.set();
    healthBar.visible = !ClientPrefs.hideHud;
    healthBar.alphaMultipler = ClientPrefs.healthBarAlpha;
    
    reloadHealthBarColors();
    add(healthBar);

    fancyBarOverlay = new FlxSprite(healthBar.x, healthBar.y).loadGraphic(Paths.image('UI/episode1Overlay'));
    fancyBarOverlay.scale.set(1.01, 1);
    fancyBarOverlay.screenCenter(FlxAxes.X);
    fancyBarOverlay.scrollFactor.set();
    if (ClientPrefs.downScroll) fancyBarOverlay.y -= 10;
    else
    {
        fancyBarOverlay.y -= 117;
        fancyBarOverlay.flipY = true;
    }
    fancyBarOverlay.visible = !ClientPrefs.hideHud;
    add(fancyBarOverlay);
    
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

    scoreTxt = new FlxText(0, healthBar.y + 40, FlxG.width, "", 20);
    scoreTxt.setFormat(Paths.font("DisneyFont.ttf"), 24, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreTxt.scrollFactor.set();
    scoreTxt.borderSize = 1.25;
    scoreTxt.visible = !ClientPrefs.hideHud;
    add(scoreTxt);

    watermarkTxt = new FlxText(0, 0, 0, engineDisplay);
    watermarkTxt.setFormat(Paths.font('DisneyFont.ttf'), 32, FlxColor.WHITE);
    watermarkTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    watermarkTxt.setPosition(0, ClientPrefs.downScroll ? 655 : 8);
    watermarkTxt.screenCenter(FlxAxes.X);
    watermarkTxt.visible = !ClientPrefs.hideHud;
    add(watermarkTxt);

    songTxt = new FlxText(watermarkTxt.x, watermarkTxt.y + 30, 1280, infoDisplay);
    songTxt.setFormat(Paths.font('DisneyFont.ttf'), 22, FlxColor.WHITE, "center");
    songTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    songTxt.alpha = 0.6;
    songTxt.screenCenter(FlxAxes.X);
    songTxt.visible = !ClientPrefs.hideHud;
    add(songTxt);

    ratingGraphic = new FlxSprite();
    ratingGraphic.alpha = 0;
    add(ratingGraphic);
    
    ratingNumGroup = new FlxTypedGroup();
    add(ratingNumGroup);
    
    onUpdateScore(0, 0, 0);

    parent.scripts.set('healthBar', healthBar);
    parent.scripts.set('fancyBarOverlay', fancyBarOverlay);
    parent.scripts.set('iconP1', iconP1);
    parent.scripts.set('iconP2', iconP2);
    parent.scripts.set('scoreTxt', scoreTxt);
    parent.scripts.set('watermarkTxt', watermarkTxt);
    parent.scripts.set('songTxt', songTxt);

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
        if (ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;
        
        var secondsTotal:Int = Math.floor(songCalc / 1000);
        if (secondsTotal < 0) secondsTotal = 0;
    }
}

function onUpdateScore(score, accuracy, misses, ?missed)
{
    var str:String = '$accuracy% [${(parent.totalPlayed != 0 ? parent.ratingFC : 'N/A')}]';

    scoreTxt.text = 'Score: ${FlxStringUtil.formatMoney(score, false)} - Combo Breaks: $misses - Accuracy: $str';
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