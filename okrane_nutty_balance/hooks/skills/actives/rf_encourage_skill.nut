// Encourage (from the Supporter perk), reworked:
//  - Usable on any ally of your faction whose morale is lower than or equal to yours
//  - Raises the target's morale by up to 2 steps (the difference between your morale and theirs)
//  - The target gains +3 Action Points (scripts/skills/effects/ok_encouraged_effect.nut)
//  - Cannot be used after attacking; after using it, your attacks cost +2 Action Points for the rest of the turn
::modONB.HooksMod.hook("scripts/skills/actives/rf_encourage_skill", function(q) {
	q.m.ActionPointCostPenalty <- 2;	// extra AP cost of weapon skills after encouraging
	q.m.AttackPenaltyInEffect <- false;	// true from using Encourage until the end of the turn
	q.m.MaxMoraleSteps <- 2;			// maximum number of morale states the target can gain

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		local actualResolveBonus = "";
		if (this.getContainer().getActor().getID() != ::MSU.getDummyPlayer().getID())
		{
			actualResolveBonus = " (" + ::MSU.Text.colorizeValue(this.getEncourageBonus(), {AddSign = true}) + ")";
		}

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(format("Trigger a positive [Morale Check|Concept.Morale] for the target with a bonus of %s%s of your [Resolve|Concept.Bravery]", ::MSU.Text.colorizePct(this.m.EncourageBonusFraction), actualResolveBonus))
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of " + ::MSU.Text.colorPositive(this.getMaxRange()) + " tiles"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can only be used on characters who are of your faction and whose [morale|Concept.Morale] is lower or equal to yours")
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Target gains " + ::MSU.Text.colorPositive(3) + " [Action Points|Concept.ActionPoints]")
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used after attacking. Subsequent attacks in the same turn cost " + ::MSU.Text.colorNegative(this.m.ActionPointCostPenalty) + " more [Action Points|Concept.ActionPoints]")
			}
		]);

		if (this.m.IsSpent)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can only be used once per [turn|Concept.Turn]")
			});
		}

		return ret;
	}}.getTooltip;

	q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() == target.getFaction() && actor.getMoraleState() >= target.getMoraleState())
			return true;

		return __original(_originTile, _targetTile);
	}}.onVerifyTarget;

	q.onUse = @() { function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		local moraleSteps = ::Math.min(this.m.MaxMoraleSteps, _user.getMoraleState() - target.getMoraleState());
		if (moraleSteps > 0)
		{
			target.checkMorale(moraleSteps, this.getEncourageBonus(), ::Const.MoraleCheckType.Default);
		}

		// Grant the +AP effect (re-activate it if the target still has it from an earlier use)
		local effect = target.getSkills().getSkillByID("effects.encouraged_effect_buff");
		if (effect == null)
		{
			effect = ::new("scripts/skills/effects/ok_encouraged_effect");
			target.getSkills().add(effect);
		}
		effect.m.IsInEffect = true;

		this.m.IsSpent = true;
		this.m.AttackPenaltyInEffect = true;
		return true;
	}}.onUse;

	// Attacking first makes Encourage unusable for the rest of the turn
	q.onAnySkillExecutedFully = @(__original) { function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.m.IsWeaponSkill)
			this.m.IsSpent = true;
		return __original(_skill, _targetTile, _targetEntity, _forFree);
	}}.onAnySkillExecutedFully;

	// After encouraging, weapon skills cost more AP for the rest of the turn
	q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local applyEffect = this.m.AttackPenaltyInEffect;

		// When previewing a skill while already in effect, we want to show the effect will be lost
		// If not already in effect, we want to show that the effect will be available after the previewed skill is used
		if (actor.isPreviewing() && actor.getPreviewSkill() != null)
		{
			applyEffect = !this.m.AttackPenaltyInEffect && actor.getPreviewSkill().getActionPointCost() != 0;
		}

		if (applyEffect)
		{
			foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
			{
				if (skill.m.IsWeaponSkill)
					skill.m.ActionPointCost += this.m.ActionPointCostPenalty;
			}
		}

		return __original(_properties);
	}}.onAfterUpdate;

	q.onTurnEnd = @(__original) { function onTurnEnd()
	{
		this.m.AttackPenaltyInEffect = false;
		__original();
	}}.onTurnEnd;

	q.onCombatFinished = @(__original) { function onCombatFinished()
	{
		this.m.AttackPenaltyInEffect = false;
		__original();
	}}.onCombatFinished;
});
