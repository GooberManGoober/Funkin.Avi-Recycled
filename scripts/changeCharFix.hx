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
        case 'abandonedStreet':
            switch (dad.curCharacter)
            {
                case 'delusional-mickey':
                    dad.setPosition(-260, 120);
                case 'mickey-delu-intro':
                    dad.setPosition(-210, 180);
                case 'death-part-1':
                    dad.setPosition(-450, 100);
                case 'death-part-2':
                    dad.setPosition(-430, 100);
                case 'delumickey':
                    dad.setPosition(-870, -185);
                case 'deluMick-eyeless':
                    dad.setPosition(-870, -185);
                default:
                    dad.setPosition(-870, -190);
            }
            switch (boyfriend.curCharacter)
            {
                case 'evildelu': boyfriend.setPosition(550, 190);
                case 'bf-delu-intro': boyfriend.setPosition(750, 350);
                case 'bf-demon': boyfriend.setPosition(275, 65);
                case 'Mickey-Bedroom': boyfriend.setPosition(575, 50);
                default: boyfriend.setPosition(275, 50);
            }
        case 'forestNew':
            // It was before perfect but then Jason had put the new spritesheet... im gonna explode :) - MalyPlus
            // lol - jason the jasenous
            dad.setPosition(-110, -15); // goofy ahh goofy offsets - malyplus
            boyfriend.setPosition(480, -220);
            gf.setPosition(170, -50);
        case 'circus':
            dad.setPosition(-990, -100);
            boyfriend.setPosition(0,-360);
            gf.setPosition(-300, -200);
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
        case 'vaultRoom':
            boyfriend.setPosition(960, 530);
            dad.setPosition(-680, -520);
        case 'fuckingLine':
            dad.setPosition(-400, -150);
            boyfriend.setPosition(900, 300);
        case 'ddStage':
            boyfriend.setPosition(770, 450);
            dad.setPosition(400, -600);
        default:
            boyfriend.setPosition(770, 450);
            dad.setPosition(100, 100);
            gf.setPosition(300, 100);
    }
}