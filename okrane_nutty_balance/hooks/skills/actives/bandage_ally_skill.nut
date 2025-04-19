::modONB.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	
	q.create = @(__original) function()
	{		
	 	__original();
	 	this.m.ActionPointCost = 5; 
	 	::MSU.Table.merge(this.m, {IsSpent = false});	 	
	}	
	
	q.onCombatStarted = @(__original) function()
	{
		this.m.IsSpent = false;
	}

	q.onCombatFinished = @(__original) function()
	{
		this.m.IsSpent = false;
	}


	q.onUse = @(__original) function( _user, _targetTile )
	{		
		local target = _targetTile.getEntity();
		if (!this.m.IsSpent)
		{
			target.setHitpoints(this.Math.floor(target.getHitpoints() + 20));	
			this.m.IsSpent = true;
		}
		return __original(_user, _targetTile);
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (this.m.IsSpent)
		{
			return __original(_originTile, _targetTile);
		}
		return true;
	}

}); 