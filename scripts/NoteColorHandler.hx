import funkin.utils.NoteUtil;

function onCreatePost()
{
    switch (PlayState.SONG.song.toLowerCase())
    {
        case 'devilish deal', 'isolated', 'lunacy', 'delusional', 'hunted', 'twisted grins', 'cycled sins', 'birthday', 'delusion', 'disclosure', 'mercy': 
            playerStrums.quants = opponentStrums.quants = false;
    }
}

function onSpawnNotePost(note){
	final tail = (note.isSustainNote ? note.parent.tail : note.tail);
    for (sustain in tail)
    {
        sustain.alpha = 0.65;
    }
}

function onSpawnNoteSplash(splash, note)
{
    splash.alpha = 0.65;
}