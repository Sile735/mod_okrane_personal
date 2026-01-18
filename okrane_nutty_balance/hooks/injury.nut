::modONB.HooksMod.hook("scripts/skills/injury/injury", function(q) {

	q.m.RoundAdded <- 0;

	q.getName = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret += " (Fresh)";
		}

		return ret;
	}
	
	q.getHealingTime = @(__original) function()
	{		
		local time = this.getTime();
		local mint = this.Math.max(1, (this.m.IsTreated ? this.m.HealingTimeMin * 0.5 : this.m.HealingTimeMin) - this.Math.ceil((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay));
		local maxt = this.Math.max(1, (this.m.IsTreated ? this.m.HealingTimeMax * 0.5 : this.m.HealingTimeMax) - this.Math.floor((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay));

		if (("State" in this.World) && this.World.State != null && this.World.Retinue.hasFollower("follower.surgeon"))
		{
			mint = this.Math.max(1, mint - 1);
			maxt = this.Math.max(1, maxt - 1);
		}

		if (this.getContainer().getActor().getSkills().hasSkill("effects.nachzehrer_potion"))
		{
			mint = this.Math.max(1, mint - 1);
			maxt = this.Math.max(1, maxt - 1);
		}		

	 	if (this.getContainer().getActor().getSkills().hasSkill("effects.rf_medic"))
		{
			mint = this.Math.max(1, mint - 1);
			maxt = this.Math.max(1, maxt - 1);
		}

		return {
			Min = mint,
			Max = maxt
		};
	}

	q.onNewDay = @(__original) function(){

		if (!(this.getContainer().getActor().getSkills().hasSkill("trait.oath_of_sacrifice") && this.m.IsTreatable) && (this.World.Assets.getMedicine() >= this.Const.World.Assets.MedicinePerInjuryDay || !this.m.IsHealingMentioned))
		{
			if (this.m.IsHealingMentioned)
			{
				this.World.Assets.addMedicine(-this.Const.World.Assets.MedicinePerInjuryDay);
			}

			local time = this.getTime();
			local daysPassed = this.Math.ceil((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay);
			local minTime = this.m.HealingTimeMin * (this.m.IsTreated ? 0.5 : 1.0);
			local maxTime = this.m.HealingTimeMax * (this.m.IsTreated ? 0.5 : 1.0);

			if (this.World.Retinue.hasFollower("follower.surgeon"))
			{
				minTime = this.Math.max(1, minTime - 1);
				maxTime = this.Math.max(1, maxTime - 1);
			}

			if (this.getContainer().getActor().getSkills().hasSkill("effects.nachzehrer_potion"))
			{
				minTime = this.Math.max(1, minTime - 1);
				maxTime = this.Math.max(1, maxTime - 1);
			}

			if (this.getContainer().getActor().getSkills().hasSkill("effects.rf_medic"))
			{
				minTime = this.Math.max(1, minTime - 1);
				maxTime = this.Math.max(1, maxTime - 1);
			}

			if (daysPassed < minTime)
			{
				return;
			}

			local chance = daysPassed / (maxTime * 1.0) * 100.0;

			if (this.Math.rand(1, 100) <= chance)
			{
				this.removeSelf();
				return;
			}
		}
		else
		{
			this.m.TimeApplied = this.Math.minf(this.Time.getVirtualTimeF(), this.m.TimeApplied + this.World.getTime().SecondsPerDay);
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Was received on [Round|Concept.Round] " + ::MSU.Text.colorPositive(this.m.RoundAdded)),
			});
		}

		return ret;
	}

	// We need to implement this as hookTree, because some injuries might overwrite this without calling the base function
	q.onAdded = @(__original) function()
	{
		__original();
		if (::Tactical.isActive())
		{
			this.m.RoundAdded = ::Tactical.TurnSequenceBar.getCurrentRound();
		}
		else
		{
			this.m.IsFresh = false;
		}
	}

	
});