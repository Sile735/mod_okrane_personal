// Net Pull (Reforged): range 3 instead of 2, and pulls the target up to 2 tiles closer.
::modONB.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 2;
	}}.create;

	// Pull twice: first step from the target's tile, second step from the resulting tile.
	// If the second step is not possible, the target only moves one tile.
	q.getPulledToTile = @(__original) { function getPulledToTile( _userTile, _targetTile )
	{
		local tile = __original(_userTile, _targetTile);
		if (tile == null)
			return null;

		local secondTile = __original(_userTile, tile);
		return secondTile == null ? tile : secondTile;
	}}.getPulledToTile;
});
