// Survival Instinct: additionally grants +5 Hitpoints (description in config/strings.nut).
::modONB.HooksMod.hook("scripts/skills/perks/perk_rf_survival_instinct", function(q) {
	q.m.ONB_HitpointsBonus <- 5;

	// When the perk is picked, also fill up the new hitpoints
	q.onAdded = @(__original) { function onAdded()
	{
		__original();
		local actor = this.getContainer().getActor();
		actor.setHitpoints(actor.getHitpoints() + this.m.ONB_HitpointsBonus);
	}}.onAdded;

	// Keeps Reforged's defense bonus
	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		__original(_properties);
		_properties.Hitpoints += this.m.ONB_HitpointsBonus;
	}}.onUpdate;
});
