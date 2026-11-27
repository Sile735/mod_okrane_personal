// Bandage (vanilla skill, also granted by the Medic perk), reworked:
//  - Costs 5 AP
//  - The first use each combat also heals 20 Hitpoints and can target any ally (not only bleeding ones)
//  - Removes Bleeding and treats fresh injuries received at most TreatableRoundWindow rounds ago
//    (the round is tracked in hooks/injury.nut)
::modONB.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	// Within this amount of rounds from receiving an injury, it can be treated with a bandage
	// 0 means, that an injury is only treatable during the same round
	q.m.TreatableRoundWindow <- 2;
	q.m.HealAmount <- 20;		// hitpoints healed by the first use each combat
	q.m.IsSpent <- false;		// true once the heal of this combat was used

	q.create = @(__original) { function create()
	{
		__original();
		this.m.ActionPointCost = 5;
		this.m.Description = "Save yourself or another character from bleeding to death by applying pressure and provisional bandaging to any such wound.";
	}}.create;

	q.getTooltip = @() { function getTooltip()
	{
		return [
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes fresh Cut Artery, Cut Neck Vein and Grazed Neck injuries"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Heals " + ::MSU.Text.colorPositive(this.m.HealAmount) + " hitpoints the first time it is used each combat"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Treats any injury that was received at most " + ::MSU.Text.colorPositive(this.m.TreatableRoundWindow) + " [Round(s)|Concept.Round] ago")
			}
		];
	}}.getTooltip;

	q.onCombatStarted = @(__original) { function onCombatStarted()
	{
		__original();
		this.m.IsSpent = false;
	}}.onCombatStarted;

	q.onCombatFinished = @(__original) { function onCombatFinished()
	{
		__original();
		this.m.IsSpent = false;
	}}.onCombatFinished;

	q.onUse = @() { function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (!this.m.IsSpent)
		{
			// Never heal above maximum hitpoints
			target.setHitpoints(::Math.min(target.getHitpointsMax(), target.getHitpoints() + this.m.HealAmount));
			this.m.IsSpent = true;
		}

		this.spawnIcon("perk_55", _targetTile);

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

		// Bandages from items are consumed; the Medic perk's bandage has no item
		if (!::MSU.isNull(this.getItem()))
		{
			this.getItem().removeSelf();
		}

		this.updateAchievement("FirstAid", 1, 1);
		return true;	// vanilla returns true on a successful use
	}}.onUse;

	// While the heal is available, any ally can be targeted; afterwards the vanilla rules apply
	q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
	{
		if (this.m.IsSpent)
			return __original(_originTile, _targetTile);

		if (!_targetTile.IsOccupiedByActor)
			return false;

		return this.getContainer().getActor().isAlliedWith(_targetTile.getEntity());
	}}.onVerifyTarget;
});
