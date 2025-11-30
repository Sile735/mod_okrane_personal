this.medic_effect <- this.inherit("scripts/skills/skill", {
	m = {
		HealingApplied = false
	},
	function create()
	{
		this.m.ID = "effects.rf_medic";
		this.m.Name = "Medic";
		this.m.Icon = "ui/perks/perk_55.png";
		this.m.IconMini = "icon_medic";
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
				text = "Recovers [color=" + this.Const.UI.Color.PositiveValue + "]15[/color] Hitpoints after each battle"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Recovers [color=" + this.Const.UI.Color.PositiveValue + "]5[/color] Hitpoints each turn"
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
			actor.setHitpoints(this.Math.min(actor.getHitpoints() + 15, actor.getHitpointsMax()));
			actor.setDirty(true);
			this.m.HealingApplied = true;
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = this.Math.min(healthMissing, 5);

		if (healthAdded <= 0)
		{
			return;
		}

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer())
		{
			this.Tactical.spawnIconEffect("status_effect_79", actor.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	}

});
