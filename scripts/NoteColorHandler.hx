import funkin.utils.NoteUtil;

function onLoad()
{
    switch (PlayState.SONG.song.toLowerCase())
    {
        case 'devilish deal', 'isolated', 'lunacy', 'delusional', 'hunted', 'twisted grins', 'cycled sins', 'birthday', 'delusion', 'disclosure':
        {
            NoteUtil.defaultColors = [
                {r: 0xFF505050, g: 0xFFFFFFFF, b: 0xFF000000},
                {r: 0xFF505050, g: 0xFFFFFFFF, b: 0xFF000000},
                {r: 0xFF505050, g: 0xFFFFFFFF, b: 0xFF000000},
                {r: 0xFF505050, g: 0xFFFFFFFF, b: 0xFF000000}
            ];
            
            NoteUtil.quantDefaultColors = [
                {r: 0xFF737373, g: 0xFFFFFFFF, b: 0xFF2E2E2E},
                {r: 0xFFB3B3B3, g: 0xFFFFFFFF, b: 0xFF424242},
                {r: 0xFF777777, g: 0xFFFFFFFF, b: 0xFF2E2E2E},
                {r: 0xFFD4D4D4, g: 0xFFFFFFFF, b: 0xFF444444},
                {r: 0xFF7A7A7A, g: 0xFFFFFFFF, b: 0xFF343434},
                {r: 0xFF9C9C9C, g: 0xFFFFFFFF, b: 0xFF2F2F2F},
                {r: 0xFF686868, g: 0xFFFFFFFF, b: 0xFF1B1B1B},
                {r: 0xFF999999, g: 0xFFFFFFFF, b: 0xFF333333},
                {r: 0xFF5A5A5A, g: 0xFFFFFFFF, b: 0xFF363636},
                {r: 0xFF8a8a8a, g: 0xFFFFFFFF, b: 0xff3a3a3a},
                {r: 0xFFB0B0B0, g: 0xFFFFFFFF, b: 0xff505050}
            ];
        }
        case 'mercy': 
        {
            NoteUtil.defaultColors = [
                {r: 0xFFFDD577, g: 0xFFFEEECA, b: 0xFF6F4F0D},
                {r: 0xFFFDD577, g: 0xFFFEEECA, b: 0xFF6F4F0D},
                {r: 0xFFFDD577, g: 0xFFFEEECA, b: 0xFF6F4F0D},
                {r: 0xFFFDD577, g: 0xFFFEEECA, b: 0xFF6F4F0D}
            ];
            
            NoteUtil.quantDefaultColors = [
                {r: 0xFFFDD577, g: 0xFFFEEECA, b: 0xFF6F4F0D},
                {r: 0xFFFFF7E6, g: 0xFFFFFFFF, b: 0xFFEAA005},
                {r: 0xFFFCFAF6, g: 0xFFFFFFFF, b: 0xFFA58C57},
                {r: 0xFFFFE4A6, g: 0xFFFFFEFC, b: 0xFFAF7700},
                {r: 0xFFEEDBB0, g: 0xFFFDFBF7, b: 0xFF79612F},
                {r: 0xFFFFCA4A, g: 0xFFFFE0A1, b: 0xFF523802},
                {r: 0xFFC9B179, g: 0xFFE2D4B6, b: 0xFF2E291E},
                {r: 0xFFFFBA1D, g: 0xFFFFD373, b: 0xFF261A00},
                {r: 0xFFAB996E, g: 0xFFCCBFA4, b: 0xFF131211},
                {r: 0xFF7A7058, g: 0xFFA79B81, b: 0xFF000000},
                {r: 0xFF69562B, g: 0xFFA88843, b: 0xFF000000}
            ];
        }
        default:
        {
            NoteUtil.defaultColors = [
                {r: 0xFFC24B99, g: 0xFFFFFFFF, b: 0xFF3C1F56},
                {r: 0xFF00FFFF, g: 0xFFFFFFFF, b: 0xFF1542B7},
                {r: 0xFF12FA05, g: 0xFFFFFFFF, b: 0xFF0A4447},
                {r: 0xFFF9393F, g: 0xFFFFFFFF, b: 0xFF651038}
            ];
            
            NoteUtil.quantDefaultColors = [
                {r: 0xFFF9393F, g: 0xFFFFFFFF, b: 0xFF651038},
                {r: 0xFF00FFFF, g: 0xFFFFFFFF, b: 0xFF1542B7},
                {r: 0xFFC24B99, g: 0xFFFFFFFF, b: 0xFF3C1F56},
                {r: 0xFFF0E342, g: 0xFFFFFFFF, b: 0xFF554320},
                {r: 0xFFED36AD, g: 0xFFFFFFFF, b: 0xFF5C185A},
                {r: 0xFFE98F16, g: 0xFFFFFFFF, b: 0xFF3F2D12},
                {r: 0xFF4769B8, g: 0xFFFFFFFF, b: 0xFF161B27},
                {r: 0xFF12FA05, g: 0xFFFFFFFF, b: 0xFF0A4447},
                {r: 0xFF008080, g: 0xFFFFFFFF, b: 0xFF004D4D},
                {r: 0xFF8a8a8a, g: 0xFFFFFFFF, b: 0xff3a3a3a},
                {r: 0xFFbab86c, g: 0xFFFFFFFF, b: 0xff505a1f}
            ];
        }
    }
}

function onCreatePost()
{
    switch (PlayState.SONG.song.toLowerCase())
    {
        case 'devilish deal', 'isolated', 'lunacy', 'delusional', 'hunted', 'twisted grins', 'cycled sins', 'birthday', 'delusion', 'disclosure', 'mercy': 
            playerStrums.quants = opponentStrums.quants = false;
    }
}