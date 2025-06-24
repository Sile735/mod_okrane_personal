::modONB.HooksMod.hook("scripts/skills/actives/deathblow_skill", function(q) {

	q.getTooltip = @(__original) function( ){
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] more damage against and ignores additional [color=" + this.Const.UI.Color.DamageValue + "]20%[/color] armor of targets that have the Dazed, Stunned, Staggered or Trapped in Net status effects"
		});
		return ret;
	};

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties ){
		if (_targetEntity == null)
		{
			return;
		}

		local targetStatus = _targetEntity.getSkills();

		if (_skill == this && (targetStatus.hasSkill("effects.dazed") || targetStatus.hasSkill("effects.stunned") || targetStatus.hasSkill("effects.sleeping") || targetStatus.hasSkill("effects.net") || targetStatus.hasSkill("effects.web") || targetStatus.hasSkill("effects.rooted") || targetStatus.hasSkill("effects.staggered")))
		{
			_properties.DamageTotalMult *= 1.33;
			_properties.DamageDirectAdd += 0.2;
		}
	};

});
	