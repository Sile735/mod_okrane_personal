::modONB.HooksMod.hook("scripts/skills/actives/rf_encourage_skill", function(q) {

	
	q.m.ActionPointCostPenalty <- 2;
	q.m.AttackPenaltyInEffect <- false;
	
	q.getTooltip = @(__original) function()
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
				text = ::Reforged.Mod.Tooltips.parseString("Can only be used on characters who are of your faction and whose [morale|Concept.Morale] is lower or equal to yours ")
			}
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Target gains 3 [Action Point|Concept.ActionPoints]")
			}

			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used after attacking. Subsequent attacks in the same turn cost " + ::MSU.Text.colorNegative(2) + " more [Action Point|Concept.ActionPoints]")
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
	}

	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;
		
		local target = _targetTile.getEntity();
		local actor = this.getContainer().getActor();

		if ( actor.getFaction() == target.getFaction() && actor.getMoraleState() - target.getMoraleState() >= 0 ) 
		{
			return true;
		}
		
		return __original(_originTile, _targetTile);		
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();		
		local morale_bonus = this.Math.min(2, _user.getMoraleState() - target.getMoraleState());
		if (morale_bonus > 0){
			_targetTile.getEntity().checkMorale(morale_bonus, this.getEncourageBonus(), ::Const.MoraleCheckType.Default);		
		}
		
		local skill = _targetTile.getEntity().getSkills().getSkillByID("effects.encouraged_effect_buff");
		if (skill != null)
		{			
			skill.m.IsInEffect = true;	
			::logInfo("Already Has Skill - toggling it on " + _targetTile.getEntity());			
		}
		else{		
			local encouraged_effect = ::new("scripts/skills/effects/ok_encouraged_effect");
			encouraged_effect.m.IsInEffect = true;
			_targetTile.getEntity().getSkills().add(encouraged_effect);
			::logInfo("Added Encouraged Effect to " + _targetTile.getEntity())
		}

		this.m.IsSpent = true;
		this.m.AttackPenaltyInEffect = true;
		return true;
	}



	q.onAnySkillExecutedFully = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.m.IsWeaponSkill)
		{
			this.m.IsSpent = true;
		}
		return __original( _skill, _targetTile, _targetEntity, _forFree );
	}

	q.onAfterUpdate = @(__original) function( _properties )
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
				{
					skill.m.ActionPointCost += this.m.ActionPointCostPenalty;
				}
			}
		}

		return __original(_properties);
	}

	q.onTurnEnd = @(__original)function()
	{
		this.m.AttackPenaltyInEffect = false;
		__original();
	}

	q.onCombatFinished = @(__original) function()
	{		
		this.m.AttackPenaltyInEffect = false;
		__original();
	}
		
}); 