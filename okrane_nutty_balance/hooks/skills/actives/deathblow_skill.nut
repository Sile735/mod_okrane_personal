// Deathblow (dagger): the bonus against helpless targets applies to more status effects and also
// ignores an extra 20% of armor. Vanilla: +33% damage against dazed, stunned, netted, sleeping... targets.
::modONB.HooksMod.hook("scripts/skills/actives/deathblow_skill", function(q) {
	// Status effects that make the target count as helpless
	q.m.ONB_HelplessEffects <- [
		"effects.dazed",
		"effects.stunned",
		"effects.sleeping",
		"effects.net",
		"effects.web",
		"effects.rooted",
		"effects.staggered"
	];

	q.onb_isHelpless <- function( _target )
	{
		local skills = _target.getSkills();
		foreach (id in this.m.ONB_HelplessEffects)
		{
			if (skills.hasSkill(id))
				return true;
		}
		return false;
	}

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts " + ::MSU.Text.colorDamage("33%") + " more damage against and ignores an additional " + ::MSU.Text.colorDamage("20%") + " of armor of targets that are Dazed, Stunned, Sleeping, Staggered, Netted, Webbed or Rooted"
		});
		return ret;
	}}.getTooltip;

	// Replaces vanilla's bonus (same +33% damage, more effects, plus armor penetration)
	q.onAnySkillUsed = @() { function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this || _targetEntity == null || !this.onb_isHelpless(_targetEntity))
			return;

		_properties.DamageTotalMult *= 1.33;
		_properties.DamageDirectAdd += 0.2;
	}}.onAnySkillUsed;
});
