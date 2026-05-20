import funkin.utils.NoteUtil;

function onCreatePost()
{
    switch (PlayState.SONG.song.toLowerCase())
    {
        case 'devilish deal', 'isolated', 'lunacy', 'delusional', 'hunted', 'twisted grins', 'cycled sins', 'birthday', 'delusion', 'disclosure', 'mercy': 
            playerStrums.quants = opponentStrums.quants = false;
    }
}