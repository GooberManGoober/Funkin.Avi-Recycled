function onSongStart()
{
    if (!ClientPrefs.downScroll)
    {        
        //Sidescroll
        modManager.queueEase(1296, 1300, "localrotateZ", -1.575, 'cubeInOut', 1);
        modManager.queueEase(1296, 1300, "localrotateZ", 1.575, 'cubeInOut', 0);
        //ending
        modManager.queueEase(1440, 1444, "localrotateZ", 0, 'quartOut', 1);
        modManager.queueEase(1440, 1444, "localrotateZ", 0, 'quartOut', 0);

        //The stuff for the part where multiple playfields would appear, however i had to improvise
        modManager.queueEase(1448, 1452, "opponentSwap", 0.5, 'quartOut', -1); 
        
        modManager.queueEase(1456, 1460, "opponentSwap", 0, 'quartOut', -1);
        modManager.queueEase(1456, 1460, "opponentSwap", -10, 'quartOut', 1);
        
        modManager.queueEase(1456, 1460, "transform0X", -632.5, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform1X", -522.5, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform1Y", 175, 'quartOut', 0);

        modManager.queueEase(1456, 1460, "reverse2", 1, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform2X", -225, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform2Y", -175, 'quartOut', 0);

        modManager.queueEase(1456, 1460, "reverse3", 1, 'quartOut', 0);

        //Ending
        modManager.queueEase(1560, 1568, "opponentSwap", 0, 'quartOut', -1);
        modManager.queueEase(1560, 1568, "opponentSwap", 0, 'quartOut', 1);
        
        modManager.queueEase(1560, 1568, "transform0X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform1X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform1Y", 0, 'quartOut', 0);

        modManager.queueEase(1560, 1568, "reverse2", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform2X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform2Y", 0, 'quartOut', 0);

        modManager.queueEase(1560, 1568, "reverse3", 0, 'quartOut', 0);

        //true middlescroll time
        modManager.queueEase(1569, 1572, "opponentSwap", -10, 'cubeInOut', 1);
        modManager.queueEase(1569, 1572, "opponentSwap", 10, 'cubeInOut', 0);

        modManager.queueEase(1573, 1573 + 4, "opponentSwap", 0.5, 'cubeInOut', 0);
        modManager.queueSet(1573, "transformX", 300, 0);
        modManager.queueSet(1573, "localrotate0Z", 1.575, 0);
        modManager.queueSet(1573, "transform0X", -655, 0);
        modManager.queueSet(1573, "transform1X", -260, 0);
        modManager.queueSet(1573, "transform2X", -372.5, 0);

        modManager.queueSet(1573, "localrotate3Z", -1.575, 0);
        modManager.queueSet(1573, "transform3X", 15, 0);

        modManager.queueSet(1573, "transform0Y", 170, 0);
        modManager.queueSet(1573, "transform1Y", 320, 0);
        modManager.queueSet(1573, "transform2Y", -340, 0);
        modManager.queueSet(1573, "transform3Y", 165, 0);

        modManager.queueSet(1573, "reverse2", 1, 0);
        //true middlescroll ends :(
        modManager.queueEase(1824, 1824 + 20, "opponentSwap", 0, 'quartOut', 1);

        modManager.queueEase(1824, 1824 + 20, "opponentSwap", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transformX", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform0X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "localrotate0Z", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform1X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform2X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "localrotate3Z", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform3X", 0, 'cubeInOut', 0);

        modManager.queueEase(1824, 1824 + 20, "transform0Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform1Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform2Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform3Y", 0, 'cubeInOut', 0);

        modManager.queueEase(1824, 1824 + 20, "reverse2", 0, 'cubeInOut', 0);
    }
    else
    {
        //Sidescroll
        modManager.queueEase(1296, 1300, "localrotateZ", 1.575, 'cubeInOut', 1);
        modManager.queueEase(1296, 1300, "localrotateZ", -1.575, 'cubeInOut', 0);
        //ending
        modManager.queueEase(1440, 1444, "localrotateZ", 0, 'quartOut', 1);
        modManager.queueEase(1440, 1444, "localrotateZ", 0, 'quartOut', 0);

        //The stuff for the part where multiple playfields would appear, however i had to improvise
        modManager.queueEase(1448, 1452, "opponentSwap", 0.5, 'quartOut', -1); 
        
        modManager.queueEase(1456, 1460, "opponentSwap", 0, 'quartOut', -1);
        modManager.queueEase(1456, 1460, "opponentSwap", -10, 'quartOut', 1);
        
        modManager.queueEase(1456, 1460, "transform0X", -632.5, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform1X", -522.5, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform1Y", 175, 'quartOut', 0);

        modManager.queueEase(1456, 1460, "reverse1", 1, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform2X", -225, 'quartOut', 0);
        modManager.queueEase(1456, 1460, "transform2Y", -175, 'quartOut', 0);

        modManager.queueEase(1456, 1460, "reverse0", 1, 'quartOut', 0);

        //Ending
        modManager.queueEase(1560, 1568, "opponentSwap", 0, 'quartOut', -1);
        modManager.queueEase(1560, 1568, "opponentSwap", 0, 'quartOut', 1);
        
        modManager.queueEase(1560, 1568, "transform0X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform1X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform1Y", 0, 'quartOut', 0);

        modManager.queueEase(1560, 1568, "reverse1", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform2X", 0, 'quartOut', 0);
        modManager.queueEase(1560, 1568, "transform2Y", 0, 'quartOut', 0);

        modManager.queueEase(1560, 1568, "reverse0", 0, 'quartOut', 0);

        //true middlescroll time
        modManager.queueEase(1569, 1572, "opponentSwap", -10, 'cubeInOut', 1);
        modManager.queueEase(1569, 1572, "opponentSwap", 10, 'cubeInOut', 0);

        modManager.queueEase(1573, 1573 + 4, "opponentSwap", 0.5, 'cubeInOut', 0);
        modManager.queueSet(1573, "transformX", 300, 0);
        modManager.queueSet(1573, "localrotate0Z", -1.575, 0);
        modManager.queueSet(1573, "transform0X", -655, 0);
        modManager.queueSet(1573, "transform1X", -260, 0);
        modManager.queueSet(1573, "transform2X", -372.5, 0);

        modManager.queueSet(1573, "localrotate3Z", 1.575, 0);
        modManager.queueSet(1573, "transform3X", 15, 0);

        modManager.queueSet(1573, "transform0Y", -170, 0);
        modManager.queueSet(1573, "transform1Y", 320, 0);
        modManager.queueSet(1573, "transform2Y", -340, 0);
        modManager.queueSet(1573, "transform3Y", -165, 0);

        modManager.queueSet(1573, "reverse1", 1, 0);
        //true middlescroll ends :(
        modManager.queueEase(1824, 1824 + 20, "opponentSwap", 0, 'quartOut', 1);

        modManager.queueEase(1824, 1824 + 20, "opponentSwap", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transformX", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform0X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "localrotate0Z", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform1X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform2X", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "localrotate3Z", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform3X", 0, 'cubeInOut', 0);

        modManager.queueEase(1824, 1824 + 20, "transform0Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform1Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform2Y", 0, 'cubeInOut', 0);
        modManager.queueEase(1824, 1824 + 20, "transform3Y", 0, 'cubeInOut', 0);

        modManager.queueEase(1824, 1824 + 20, "reverse1", 0, 'cubeInOut', 0);
    }
}