import openfl.display.BitmapData;
import funkin.utils.CameraUtil;
import flixel.text.FlxText;

import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;

var gradientFill:FlxSprite;
var gradient:FlxSprite;

var loading:Bool = true;

var duration:Float;
var angle:Int;
	
var yStart:Float;
var yEnd:Float;

function onUpdate(elapsed)
{
	if (gradientFill != null && gradient != null)
	{
		switch (status)
		{
			case 0:
				gradientFill.y = gradient.y - gradient.height;
			case 1:
				gradientFill.y = gradient.y + gradient.height;
			default:
		}
	}
}

function onLoad()
{
	camera = CameraUtil.lastCamera;

	duration = status == 1 ? 0.65 : 0.40;
	angle = status == 1 ? 270 : 90;
		
	yStart = -camera.viewHeight;
	yEnd = camera.viewHeight;

	gradient = FlxGradient.createGradientFlxSprite(1, Math.round(camera.viewHeight), [FlxColor.BLACK, FlxColor.TRANSPARENT], 1, angle);
	gradient.scale.x = camera.viewWidth + 5;
	gradient.scrollFactor.set();
	gradient.screenCenter(FlxAxes.X);
	gradient.camera = camera;
	gradient.y = yStart;

	gradientFill = new FlxSprite().makeScaledGraphic(camera.viewWidth + 5, camera.viewHeight, FlxColor.BLACK);
	gradientFill.screenCenter(FlxAxes.X);
	gradientFill.scrollFactor.set();
	gradientFill.camera = camera;
	add(gradientFill);
	add(gradient);

	FlxTween.tween(gradient, {y: yEnd}, duration, {onComplete: Void -> dispatchFinish()});
}