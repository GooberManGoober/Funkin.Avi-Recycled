using StringTools;

enum CinematicControls
{
	MOVE;
	FLASH;
	ANGLE;
	ALPHA;
	COLOR;
	BOP;
}

typedef CinematicSettings =
{
	@:optional var valueInput:Float;

	@:optional var timer:Float;

	@:optional var ease:String;

	@:optional var colors:Array<Int>;
}

var cinematicBars:Map<String, FlxSprite> = ["top" => null, "bottom" => null];

var camBars:FlxCamera;

var shittyTwns:Array<FlxTween> = [];
function cinematicBarControls(controlType:CinematicControls, settings:CinematicSettings)
{
    // null checkes
    if (settings.colors == null) settings.colors = [0, 0, 0];
    if (settings.timer == null) settings.timer = 3;
    if (settings.ease == null) settings.ease = "linear";
    if (settings.valueInput == null) settings.valueInput = 50;

    switch (controlType)
    {		
        case CinematicControls.MOVE:
            if (cinematicBars["top"] == null)
            {
                cinematicBars["top"] = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height, FlxColor.WHITE);
                cinematicBars["top"].screenCenter(FlxAxes.X);
                cinematicBars["top"].cameras = [camBars];
                cinematicBars["top"].y = 0 - cinematicBars["top"].height; // offscreen
                add(cinematicBars["top"]);
                cinematicBars["top"].color = FlxColor.BLACK;
            }
    
            if (cinematicBars["bottom"] == null)
            {
                cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height, FlxColor.WHITE);
                cinematicBars["bottom"].screenCenter(FlxAxes.X);
                cinematicBars["bottom"].cameras = [camBars];
                cinematicBars["bottom"].y = FlxG.height; // offscreen
                add(cinematicBars["bottom"]);
                cinematicBars["bottom"].color = FlxColor.BLACK;
            }

            if (shittyTwns[0] != null)
                shittyTwns[0].cancel();
            if (shittyTwns[1] != null)
                shittyTwns[1].cancel();

            shittyTwns[0] = FlxTween.tween(cinematicBars["top"], {y: settings.valueInput - FlxG.height}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
            {
                shittyTwns[0] = null;
            }});
            shittyTwns[1] = FlxTween.tween(cinematicBars["bottom"], {y: FlxG.height - settings.valueInput}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
            {
                shittyTwns[1] = null;
            }});
                    
        case CinematicControls.BOP:
            if (cinematicBars["top"] != null && cinematicBars["bottom"] != null)
            {
                if (shittyTwns[2] != null)
                    shittyTwns[2].cancel();
                if (shittyTwns[3] != null)
                    shittyTwns[3].cancel();
    
                cinematicBars["top"].y -= settings.valueInput;
                cinematicBars["bottom"].y += settings.valueInput;
                shittyTwns[2] = FlxTween.tween(cinematicBars["top"], {y: cinematicBars["top"].y + settings.valueInput}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[2] = null;
                }});
                shittyTwns[3] = FlxTween.tween(cinematicBars["bottom"], {y: cinematicBars["bottom"].y - settings.valueInput}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[3] = null;
                }});
            }

        case CinematicControls.FLASH:
            if (cinematicBars["top"] != null && cinematicBars["bottom"] != null)
            {
                if (shittyTwns[4] != null)
                    shittyTwns[4].cancel();
                if (shittyTwns[5] != null)
                    shittyTwns[5].cancel();

                var lastColor:FlxColor = cinematicBars["top"].color;
                cinematicBars["top"].color = FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]);
                cinematicBars["bottom"].color = FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]);

                shittyTwns[4] = FlxTween.color(cinematicBars["top"], settings.timer, FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]), lastColor, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[4] = null;
                }});
                shittyTwns[5] = FlxTween.color(cinematicBars["bottom"], settings.timer, FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]), lastColor, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[5] = null;
                }});
            }

        case CinematicControls.ANGLE:
            if (cinematicBars["top"] != null && cinematicBars["bottom"] != null)
            {
                if (shittyTwns[6] != null)
                    shittyTwns[6].cancel();

                shittyTwns[6] = FlxTween.tween(camBars, {angle: settings.valueInput}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[6] = null;
                }});
            }

        case CinematicControls.COLOR:
            if (cinematicBars["top"] != null && cinematicBars["bottom"] != null)
            {
                if (shittyTwns[7] != null)
                    shittyTwns[7].cancel();
                if (shittyTwns[8] != null)
                    shittyTwns[8].cancel();

                shittyTwns[7] = FlxTween.color(cinematicBars["top"], settings.timer, cinematicBars["top"].color, FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]), {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[7] = null;
                }});
                shittyTwns[8] = FlxTween.color(cinematicBars["bottom"], settings.timer, cinematicBars["bottom"].color, FlxColor.fromRGB(settings.colors[0], settings.colors[1], settings.colors[2]), {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[8] = null;
                }});
            }
                
        case CinematicControls.ALPHA:
            if (cinematicBars["top"] != null && cinematicBars["bottom"] != null)
            {
                if (settings.valueInput > 1 || settings.valueInput < 0)
                    settings.valueInput = 1;

                if (shittyTwns[9] != null)
                    shittyTwns[9].cancel();

                shittyTwns[9] = FlxTween.tween(camBars, {alpha: settings.valueInput}, settings.timer, {ease: CoolUtil.getEaseFromString(settings.ease.toLowerCase().trim()), onComplete: function(twn:FlxTween)
                {
                    shittyTwns[9] = null;
                }});
            }
    }
}

function onPush(event)
{
    camBars = new FlxCamera();
	camBars.bgColor = 0x0;
    FlxG.cameras.insert(camBars, FlxG.cameras.list.indexOf(PlayState.camHUD) - 1, false);
}

function onTrigger(value1, value2)
{
    var triggerInfo:Array<String> = value2.split(',');
    switch (value1.toLowerCase().trim())
    {
        case "move": 
            cinematicBarControls(CinematicControls.MOVE, 
            {
                valueInput: Std.parseFloat(triggerInfo[0]), //Thickness of the bars
                timer: Std.parseFloat(triggerInfo[1]), //Duration
                ease: triggerInfo[2] //Ease name
            });
        case "angle": 
            cinematicBarControls(CinematicControls.ANGLE, 
            {
                valueInput: Std.parseFloat(triggerInfo[0]), //Camera angle of the bars
                timer: Std.parseFloat(triggerInfo[1]), //Duration
                ease: triggerInfo[2] //Ease name
            });
        case "color": 
            cinematicBarControls(CinematicControls.COLOR, 
            {
                colors: //Color the bars change to
                [
                    Std.parseInt(triggerInfo[0]), //R
                    Std.parseInt(triggerInfo[1]), //G
                    Std.parseInt(triggerInfo[2]) //B
                ], 
                timer: Std.parseFloat(triggerInfo[3]), //Duration
                ease: triggerInfo[4] //Ease name
            });
        case "flash": 
            cinematicBarControls(CinematicControls.FLASH, 
            {
                colors: //Flash color of the bars
                [
                    Std.parseInt(triggerInfo[0]), //R
                    Std.parseInt(triggerInfo[1]), //G
                    Std.parseInt(triggerInfo[2]) //B
                ], 
                timer: Std.parseFloat(triggerInfo[3]), //Duration
                ease: triggerInfo[4] //Ease name
            });
        case "alpha": 
            cinematicBarControls(CinematicControls.ALPHA, 
            {
                valueInput: Std.parseFloat(triggerInfo[0]), //Alpha value of the camera the bars are on
                timer: Std.parseFloat(triggerInfo[1]), //Duration
                ease: triggerInfo[2] //Ease name
            });
        case "bop": 
            cinematicBarControls(CinematicControls.BOP, 
            {
                valueInput: Std.parseFloat(triggerInfo[0]), //How intense the bars will bop
                timer: Std.parseFloat(triggerInfo[1]), //Duration
                ease: triggerInfo[2] //Ease name
            });
    }
}