import flixel.FlxSprite;
import flixel.text.FlxText;
import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxGradient;

// I got plans, and I'm gonna make the art for this lmao -don
var leMuckney:FlxSprite;
var background:FlxSprite;
var booHooHeSoSadThatItsRainingNowYouAreSuchAHorriblePerson:FlxSprite;
var theFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComingTheFogIsComing:FlxSprite;

// the text stuff
var totallyEmotionalTextDisplay:FlxText;

function onCreate() {
   // setup window's new functionality
   Application.current.window.borderless = true;
   Application.current.window.title = "Was it worth it?";

   // bans you from playing Birthday
   FlxG.save.data.birthdayLocky = "uninvited";
   FlxG.save.flush();

   // setup screen
   var gradient:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height + 320, FlxColor.BLACK);
   gradient = FlxGradient.createGradientFlxSprite(2130, 512, [0x00FFFFFF, 0x558FA197, 0xAA2D3D33], 1, 90, true);
   gradient.screenCenter();
   gradient.y += 60;
   gradient.scale.y = 1.22;
   add(gradient);

   leMuckney = new FlxSprite().loadGraphic(Paths.image("Funkin_avi/youHeartlessShit/muckneySadBoi"));
   leMuckney.setGraphicSize(0, FlxG.height);
   leMuckney.screenCenter();
   add(leMuckney);

   totallyEmotionalTextDisplay = new FlxText(0, 0, 500, "You're no longer invited back to the party,\nyou monster...");
   totallyEmotionalTextDisplay.setFormat(Paths.font("DisneyFont.ttf"), 70, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
   totallyEmotionalTextDisplay.borderSize = 5;
   add(totallyEmotionalTextDisplay);
   
   var birthdayInstButSlower:FlxSound = new FlxSound().loadEmbedded(Paths.music("aviOST/aTrueMonster"));
   FlxG.sound.list.add(birthdayInstButSlower);
   birthdayInstButSlower.play();
}