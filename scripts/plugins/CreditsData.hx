import sys.io.File;
import haxe.Json;

using StringTools;

typedef PauseData =
{
    var settings:Array<Dynamic>;
}

var devilishDeal:String = '{
	"settings":
	[
		"Art: Domingo, Moe, Hikki,\n& SkylarFilm\n\nChart: Purg\n\nCode: ThatOneSillyGuy & Jason\n\nMusic: obscurity.", -40, -5
	]
}';
var isolated:String = '{
	"settings":
	[
		"Art: Domingo & Moe\n\nChart: ThatOneSillyGuy\n\nCode: Jason & ThatOneSillyGuy\n\nMusic: obscurity.", 0, -5
	]
}';

var lunacy:String = '{
	"settings":
	[
		"Art: Domingo & Moe\n\nChart: Venage5603\n\nCode: Jason & ThatOneSillyGuy\n\nMusic: obscurity.", 25, -5
	]
}';

var delusional:String = '{
	"settings":
	[
		"Art: Domingo, Moe, BladzAMC_Emerald,\nTeelbe, Hikki, GreyDoodlez,\nAustinWProductions\n& ThatOneSillyGuy\n\nChart: Dreupy\n\nCode: Jason, MalyPlus\n& ThatOneSillyGuy\n\nMusic: FR3SHMoure\n\nVoice Actor: BonoanAnything", -21, -43
	]
}';

// fuck you goofy fnf
var hunted:String = '{
	"settings":
	[
		"Art: GreyDoodlez, Jason,\n8tastic & rezeo\n\nChart: Jason & ThatOneSillyGuy\n\nCode: Jason, ThatOneSillyGuy \n& MalyPlus\n\nMusic: JBlitz", 18, 0
	]
}';

var laughTrack:String = '{
	"settings":
	[
		"Art: Just_Kuro, Jason &\nGreyDoodlez\n\nChart: ThatOneSillyGuy\n\nCode: Jason & ThatOneSillyGuy\n\nMusic: Lasagnacat", -35, -5
	]
}';

var bless:String = '{
	"settings":
	[
		"Art: ThatOneSillyGuy\nAustinWProductions, JDrive, Teelbe\n& Moe\n\nChart: ThatOneSillyGuy\n\nCode: Jason, MalyPlus \n& ThatOneSillyGuy\n\nMusic: Lasagnacat", 33, -30
	]
}';

var dontCross:String = '{
	"settings":
	[
		"Art: Domingo & Moe\n\nChart: ThatOneSillyGuy\n\nCode: ThatOneSillyGuy\n\nMusic: Lasagnacat", -55, 20
	]
}';

var warDilemma:String = '{
	"settings":
	[
		"Art: BladzAMC_Emerald,\nAustinWProductions, & Teelbe\n\nChart: Purg\n\nCode: Jason & ThatOneSillyGuy\n\nMusic: Sayan Sama & obscurity.", -30, 0
	]
}';

var twistedGrins:String = '{
	"settings":
	[
		"Art: AustinWProduction,\nTeelbe & TrellXD\n\nChart: Purg\n\nCode: ThatOneSillyGuy & Goober Man\n\nMusic: ForFurtherNotice\n\nVoice Actor: Jogadorice", -68, -23
	]
}';

var malfunction:String = '{
	"settings":
	[
		"Art: ThatOneSillyGuy, 8tastic &\njaooazul\n\nChart: ThatOneSillyGuy\n\nCode: ThatOneSillyGuy\n\nMusic: obscurity.", -43, -13
	]
}';

var birthday:String = '{
	"settings":
	[
		"Art: Teelbe\n\nChart: Jason & ThatOneSillyGuy\n\nCode: Jason & ThatOneSillyGuy\n\nMusic: FR3SHMoure", 0, 15
	]
}';

var neglection:String = '{
	"settings":
	[
		"Art: Moe\n\n3D Modeling: MalyPlus\n\nChart: ThatOneSillyGuy\n\nCode: ThatOneSillyGuy\n\nMusic: AttackPan", -21, 21
	]
}';

var blessLegacy:String = '{
	"settings":
	[
		"Art: ThatOneSillyGuy\nAustinWProductions, JDrive, Teelbe\n& Moe\n\nChart: ThatOneSillyGuy\n\nCode: Jason, \nThatOneSillyGuy\n\nMusic: END_SELLA", -40, -30
	]
}';

var delusion:String = '{
	"settings":
	[
		"Art: Domingo & Moe\n\nChart: Unknown\n\nCode: ThatOneSillyGuy\n\nMusic: FluffyHairs", -10, 15
	]
}';

var json:String = null;
var array:Array<Dynamic>;
var data:PauseData;

var difficultyRank:String = 'HARD';
var songArtist:String = "Unknown";
var charter:String = "Unknown";

function jsonStuff(fuckingName:String)
{
    switch (fuckingName)
    {
        case "Devilish Deal": json = devilishDeal;
        case "Isolated": json = isolated;
        case "Lunacy": json = lunacy;
        case "Delusional": json = delusional;
        case "Hunted": json = hunted;
        case "Laugh Track": json = laughTrack;
        case "Bless": json = bless;
		case "Bless Legacy": json = blessLegacy;
        case "Don't Cross!": json = dontCross;
        case "Twisted Grins": json = twistedGrins;
        case "Malfunction": json = malfunction;
		case "Neglection": json = neglection;
        case "Birthday": json = birthday;
		case "Delusion": json = delusion;
		case "War Dilemma": json = warDilemma;
    }

    if (json != null && json.length > 0)
    {
		var data = Json.parse(json);
	    return data;
    }
	else 
		return null;
}

function getCharterCredits(name)
{
	switch (name)
	{
		case "Devilish Deal", "Twisted Grins", "War Dilemma": charter = "Purg";
		case "Delusional", "Birthday": charter = "Dreupy";
		case "Hunted": charter = "Jason & ThatOneSillyGuy";
		case "Lunacy", "Isolated", "Malfunction", "Laugh Track", "Neglection", "Bless Legacy": charter = "ThatOneSillyGuy"; 
		case "Don't Cross!": charter = "ThatOneSillyGuy & fakeburrito123";
		default: charter = "Unknown";
	}
	return charter;
}

function getDiffRank(name)
{
	switch (name.toLowerCase().replace(' ', '-'))
	{
		case 'devilish-deal': difficultyRank = 'EASY';
		case 'isolated', 'hunted', 'neglection', 'delusion': difficultyRank = 'NORMAL';
		case 'delusional': difficultyRank = 'INSANE';
		case 'malfunction': difficultyRank = 'null';
		case "don't-cross!": difficultyRank = 'GOOD LUCK';
		case 'birthday': difficultyRank = 'PARTY';
		default: difficultyRank = 'HARD';
	}
	return difficultyRank;
}

function getArtistName(name)
{
	switch (name)
	{
		case "Devilish Deal", "Isolated", "Lunacy", "Malfunction": songArtist = "obscurity.";
		case "Birthday", "Delusional": songArtist = "FR3SHMoure";
		case "Hunted": songArtist = "JBlitz";
		case "Laugh Track", "Don't Cross!": songArtist = "Yama haki/Toko";
		case "Bless": songArtist = "Lasagnacat";
		case "War Dilemma": songArtist = "Sayan Sama & obscurity.";
		case "Twisted Grins": songArtist = "ForFurtherNotice";
		case "Neglection": songArtist = "AttackPan";
		case "Bless Legacy": songArtist = "END_SELLA";
		case "Delusion": songArtist = "Fluffyhairs";
		default: songArtist = "Unknown";
	}
	return songArtist;
}