::modONB.HooksMod.hook("scripts/skills/actives/rf_encourage_skill", function(q) {
	
	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;
		
		local target = _targetTile.getEntity();
		local actor = this.getContainer().getActor();

		if ( actor.getFaction() == target.getFaction() && actor.getMoraleState() - target.getMoraleState() >= actor.getTile().getDistanceTo(target.getTile()) && target.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return true;
		}
		
		return __original(_originTile, _targetTile);		
	}	
		
}); 