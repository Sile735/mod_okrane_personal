// Injuries
//  - "Fresh" injuries show the round they were received in (used by the reworked Bandage, see bandage_ally_skill.nut)
//  - Injuries received outside of combat are never fresh
//  - The Medic perk (effects.rf_medic) heals injuries 1 day faster, like the Surgeon follower does
::modONB.HooksMod.hook("scripts/skills/injury/injury", function(q) {
	q.m.RoundAdded <- 0;	// tactical round in which the injury was received (not saved, only relevant in combat)

	// Healing time reduction in days from Medic
	q.onb_getMedicReduction <- function()
	{
		return this.getContainer().getActor().getSkills().hasSkill("effects.rf_medic") ? 1 : 0;
	}

	q.getName = @(__original) { function getName()
	{
		local ret = __original();
		if (this.isFresh() && !this.isTreated())
			ret += " (Fresh)";
		return ret;
	}}.getName;

	// Shown healing time: vanilla (incl. Surgeon and Nachzehrer potion) minus Medic, never below 1 day
	q.getHealingTime = @(__original) { function getHealingTime()
	{
		local ret = __original();
		local reduction = this.onb_getMedicReduction();
		ret.Min = ::Math.max(1, ret.Min - reduction);
		ret.Max = ::Math.max(1, ret.Max - reduction);
		return ret;
	}}.getHealingTime;

	// Copy of vanilla onNewDay with the Medic reduction added (vanilla computes the times inline,
	// so they cannot be adjusted by wrapping the original function)
	q.onNewDay = @() { function onNewDay()
	{
		local actor = this.getContainer().getActor();
		if (!(actor.getSkills().hasSkill("trait.oath_of_sacrifice") && this.m.IsTreatable) && (::World.Assets.getMedicine() >= ::Const.World.Assets.MedicinePerInjuryDay || !this.m.IsHealingMentioned))
		{
			if (this.m.IsHealingMentioned)
			{
				::World.Assets.addMedicine(-::Const.World.Assets.MedicinePerInjuryDay);
			}

			local daysPassed = ::Math.ceil((this.getTime() - this.m.TimeApplied) / ::World.getTime().SecondsPerDay);
			local minTime = this.m.HealingTimeMin * (this.m.IsTreated ? 0.5 : 1.0);
			local maxTime = this.m.HealingTimeMax * (this.m.IsTreated ? 0.5 : 1.0);

			local reduction = this.onb_getMedicReduction();
			if (::World.Retinue.hasFollower("follower.surgeon"))
				reduction += 1;
			if (actor.getSkills().hasSkill("effects.nachzehrer_potion"))
				reduction += 1;

			minTime = ::Math.max(1, minTime - reduction);
			maxTime = ::Math.max(1, maxTime - reduction);

			if (daysPassed < minTime)
				return;

			local chance = daysPassed / (maxTime * 1.0) * 100.0;
			if (::Math.rand(1, 100) <= chance)
			{
				this.removeSelf();
				return;
			}
		}
		else
		{
			this.m.TimeApplied = ::Math.minf(::Time.getVirtualTimeF(), this.m.TimeApplied + ::World.getTime().SecondsPerDay);
		}
	}}.onNewDay;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		if (this.isFresh() && !this.isTreated())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Was received on [Round|Concept.Round] " + ::MSU.Text.colorPositive(this.m.RoundAdded))
			});
		}
		return ret;
	}}.getTooltip;

	q.onAdded = @(__original) { function onAdded()
	{
		__original();
		if (::Tactical.isActive())
			this.m.RoundAdded = ::Tactical.TurnSequenceBar.getCurrentRound();
		else
			this.m.IsFresh = false;
	}}.onAdded;
});
