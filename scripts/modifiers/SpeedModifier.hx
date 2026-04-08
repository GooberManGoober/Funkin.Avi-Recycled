function getName() return 'speed';
function getModType() return NOTE_MOD;

function getPos(time, visualDiff, timeDiff, beat, pos, data, player, obj)
{
	var speedValue = getValue(player);
	
	var yAdjust:Float = 0;
	
	yAdjust += speedValue * 20 * (visualDiff / 38);
	
	pos.y += yAdjust;
	return pos;
}
