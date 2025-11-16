::modONB.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	
	q.create = @(__original) function()
	{
		__original();
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 2;
	}	

	q.getPulledToTile = @(__original) function( _userTile, _targetTile ){
		local tile = __original(_userTile, _targetTile);
		if (tile == null){
			return null;
		}
		return __original(_userTile, tile);
	}
	
}); 