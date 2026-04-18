using StringTools;

var difficultyRank:String = 'HARD';
var songArtist:String = "Unknown";
var charter:String = "Unknown";

function getCharterCredits(name)
{
	switch (name)
	{
		case "Devilish Deal", "Twisted Grins", "War Dilemma", "Cycled Sins": charter = "Purg";
		case "Delusional", "Birthday": charter = "Dreupy";
		case "Hunted": charter = "Jason & ThatOneSillyGuy";
		case "Lunacy", "Isolated", "Malfunction", "Laugh Track", "Neglection", "Bless Legacy", "Mercy": charter = "ThatOneSillyGuy"; 
		case "Don't Cross!": charter = "ThatOneSillyGuy & fakeburrito123";
		case "Disclosure": charter = "Goober Man";
		default: charter = "Unknown";
	}
	return charter;
}

function getDiffRank(name)
{
	switch (name.toLowerCase().replace(' ', '-'))
	{
		case 'devilish-deal': difficultyRank = 'EASY';
		case 'isolated', 'hunted', 'neglection', 'delusion', 'disclosure': difficultyRank = 'NORMAL';
		case 'delusional', 'mercy': difficultyRank = 'INSANE';
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
		case "Hunted", "Cycled Sins": songArtist = "JBlitz";
		case "Laugh Track", "Don't Cross!", "Disclosure": songArtist = "Yama haki";
		case "Bless": songArtist = "Lasagnacat";
		case "Mercy": songArtist = "Ophomix24";
		case "War Dilemma": songArtist = "Sayan Sama & obscurity.";
		case "Twisted Grins": songArtist = "ForFurtherNotice";
		case "Neglection": songArtist = "AttackPan";
		case "Bless Legacy": songArtist = "END_SELLA";
		case "Delusion": songArtist = "Fluffyhairs";
		default: songArtist = "Unknown";
	}
	return songArtist;
}