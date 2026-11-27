// Medic effect (granted by the Medic perk, scripts/skills/perks/perk_rf_medic.nut):
//  - injuries heal 1 day faster (implemented in okrane_nutty_balance/hooks/injury.nut, which checks this effect's ID)
//  - +15 hitpoints after each battle, +5 hitpoints at the start of each turn
this.medic_effect <- ::inherit("scripts/skills/skill", {
	m = {
		HealingApplied = false,	// prevents healing twice after the same battle
		HealAfterBattle = 15,
		HealPerTurn = 5
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
	}

	function getDescription()
	{
		return "\"Extensive knowledge of the body allows this brother to heal up faster during and after every battle.\"";
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
				text = "Injuries heal " + ::MSU.Text.colorPositive(1) + " day faster"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Recovers " + ::MSU.Text.colorPositive(this.m.HealAfterBattle) + " Hitpoints after each battle"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Recovers " + ::MSU.Text.colorPositive(this.m.HealPerTurn) + " Hitpoints each turn"
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
			actor.setHitpoints(this.Math.min(actor.getHitpoints() + this.m.HealAfterBattle, actor.getHitpointsMax()));
			actor.setDirty(true);
			this.m.HealingApplied = true;
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = ::Math.min(healthMissing, this.m.HealPerTurn);

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
