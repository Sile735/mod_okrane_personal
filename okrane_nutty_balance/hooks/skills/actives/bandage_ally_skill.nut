::modONB.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	
	q.create = @(__original) function()
	{		
	 	__original();
	 	this.m.ActionPointCost = 5; 
	 	this.m.Description = "Save yourself or another character from bleeding to death by applying pressure and provisional bandaging to any such wound.";
	 	::MSU.Table.merge(this.m, {IsSpent = false});	 	
	}

	q.getTooltip = @(__original) function()
	{	
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Bleeding status effect"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes fresh Cut Artery, Cut Neck Vein and Grazed Neck injuries"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Heals 20 hitpoints the first time it is used"
			}
		];

		return ret;

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