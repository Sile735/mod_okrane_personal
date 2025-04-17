this.medic_effect <- this.inherit("scripts/skills/skill", {
	m = {
		HealingApplied = false
	},
	function create()
	{
		this.m.ID = "effects.rf_medic";
		this.m.Name = "Medic";
		this.m.Icon = "ui/perks/perk_55.png";
		this.m.IconMini = "medic_effect";
		this.m.Overlay = "medic_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Trait - 9;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
		::logInfo("creating medic effect");
	}

	function getDescription()
	{
		return "\"Extensive knowledge of the body allows this brother to heal up faster after every battle.\"";
	}

	function getTooltip()
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
				id = 11,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Injuries heal [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] day faster"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Recovers [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] Hitpoints after each battle"
			}
		];
		return ret;
	}

	function onCombatStarted()
	{
		this.m.HealingApplied = false;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive() && !this.m.HealingApplied)
		{
			actor.setHitpoints(this.Math.min(actor.getHitpoints() + 10, actor.getHitpointsMax()));
			actor.setDirty(true);
			this.m.HealingApplied = true;
		}
	}

});
