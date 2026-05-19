function onCreatePost()
{
    resetCharPos();
}

function onEvent(eventName, value1, value2)
{
    if (eventName == "Change Character")
    {
        resetCharPos();
    }
}

function resetCharPos()
{
    switch (PlayState.SONG.stage)
    {
        case 'vaultRoomLegacy':
            switch (boyfriend.curCharacter)
            {
                case 'bfghost':
                    boyfriend.setPosition(300, -450);
                default:
                    boyfriend.setPosition(950, 520);
            }
            dad.setPosition(0, 100);
        case 'abandonedStreet':
            switch (dad.curCharacter)
            {
                case 'delusional-mickey':
                    dad.setPosition(-430, 220);
                case 'mick-lunacyEnd':
                    dad.setPosition(-750, -110);
                default:
                    dad.setPosition(-870, -90);
            }
            switch (boyfriend.curCharacter)
            {
                case 'evildelu': boyfriend.setPosition(550, 290);
                case 'bf-delu-intro': boyfriend.setPosition(800, 500);
                case 'bf-demon': boyfriend.setPosition(430, 175);
                case 'Mickey-Bedroom': boyfriend.setPosition(575, 50);
                default: boyfriend.setPosition(275, 150);
            }
        case 'crossoverStreet':
            dad.setPosition(-870, -90);
            boyfriend.setPosition(870, 600);
        case 'apartment':
            dad.setPosition(-1000, 245);
    		boyfriend.setPosition(590, 250);
            gf.setPosition(530, 130);
        case 'delusionStreet':
            switch (dad.curCharacter)
            {
                case 'delusional-mickey':
                    dad.setPosition(-260, 120);
                case 'mick-lunacyEnd':
                    dad.setPosition(-750, -210);
                default:
                    dad.setPosition(-870, -190);
            }
            switch (boyfriend.curCharacter)
            {
                case 'bf-demon': boyfriend.setPosition(275, 100);
                case 'bf-delu-intro': boyfriend.setPosition(750, 350);
                default: boyfriend.setPosition(275, 25);
            }
        case 'forestNew':
            // It was before perfect but then Jason had put the new spritesheet... im gonna explode :) - MalyPlus
            // lol - jason the jasenous
            dad.setPosition(-320, 160); // goofy ahh goofy offsets - malyplus
            boyfriend.setPosition(850, -45);
            gf.setPosition(480, 120);
        case 'treasureIsland':
            boyfriend.setPosition(1080, 310);
            dad.setPosition(0, 190);
        case 'clubhouse':
            switch (dad.curCharacter)
            {
                case 'mickey-lunacy-legacy':
                    dad.setPosition(0, 0);
                default:
                    dad.setPosition(-240, -260);
            }
            switch (boyfriend.curCharacter)
            {
                case 'bf-demon-old':
                    boyfriend.setPosition(500, -320);
                default:
                    boyfriend.setPosition(650, -360);
            }
            gf.setPosition(280, -410);

        case 'forbiddenRealm':
            if (dad.curCharacter == 'gm-calm-pixel')
                dad.setPosition(-130, 50);
            else
                dad.setPosition(-100, 150);
            
            boyfriend.setPosition(1300, 600);
        case 'trueGrinsOfSins':
            boyfriend.setPosition(1300, 400);
            dad.setPosition(0, 0);
            gf.setPosition(1100, 560);
        case 'war':
			dad.setPosition(-140, 30);
   	 		boyfriend.setPosition(1450, 650);
        case 'waltRoom':
            switch (dad.curCharacter)
            {
                case 'walt-true':
                    dad.setPosition(280, -200);
                case 'walt-new':
                    dad.setPosition(260, -50);
                case 'walt-cutscene':
                    dad.setPosition(260, -10);
                case 'walt-death':
                    dad.setPosition(260, -190);
                default:
                    dad.setPosition(0, 0);
            }
            boyfriend.setPosition(330, 300);
        case 'vaultRoom':
            boyfriend.setPosition(960, 530);
            dad.setPosition(-680, -520);
        case 'fuckingLine':
            dad.setPosition(-400, -150);
            boyfriend.setPosition(900, 300);
        case 'ddStage':
            boyfriend.setPosition(1450, 1100);
		    dad.setPosition(1760, 90);
        default:
            boyfriend.setPosition(770, 450);
            dad.setPosition(100, 100);
            gf.setPosition(300, 100);
    }
}