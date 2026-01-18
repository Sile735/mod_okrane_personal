::modONB.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	// Within this amount of rounds from receiving an injury, it can be treated with a bandage
	// 0 means, that an injury is only treatable during the same round
	q.m.TreatableRoundWindow <- 2;


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
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Treats any injury that was received at most " + ::MSU.Text.colorPositive(this.m.TreatableRoundWindow) + " [Round(s)|Concept.Round] ago")
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

		this.spawnIcon("perk_55", _targetTile);

		local target = _targetTile.getEntity();
		foreach (skill in target.getSkills().m.Skills)
		{
			if (skill.getID() == "effects.bleeding")	// We could also use removeAllByID for the bleed effects, but this is a bit more performant
			{
				skill.removeSelf();
			}
			else if (skill.isType(::Const.SkillType.TemporaryInjury) && skill.isFresh() && !skill.isTreated())
			{
				local roundsSinceAdded = ::Tactical.TurnSequenceBar.getCurrentRound() - skill.m.RoundAdded;
				if (roundsSinceAdded <= this.m.TreatableRoundWindow)
				{
					skill.setTreated(true);
					::World.Statistics.getFlags().increment("InjuriesTreatedWithBandage");
				}
			}
		}

		// Unlike Vanilla (which calls removeById) we only set IsGarbage of the targeted bleed skills to true. The target still needs to be force-updated by someone so the changes take effect
		target.getSkills().update();

		if (!::MSU.isNull(this.getItem()))
		{
			this.getItem().removeSelf();
		}

		this.updateAchievement("FirstAid", 1, 1);		
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		if (this.m.IsSpent)
		{
			return __original(_originTile, _targetTile);
		}

		if (_targetTile.IsOccupiedByActor){
			local target = _targetTile.getEntity();	
			if (!this.getContainer().getActor().isAlliedWith(target)) return false;
		}
		else {
			return false;
		}

		return true;
	}

}); 