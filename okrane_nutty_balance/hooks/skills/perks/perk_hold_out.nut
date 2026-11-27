// Hold Out ("Resilient"): additionally grants +5 Hitpoints and, for player characters,
// immunity to being netted, webbed or rooted (description in config/strings.nut).
::modONB.HooksMod.hook("scripts/skills/perks/perk_hold_out", function(q) {
	q.m.ONB_HitpointsBonus <- 5;

	// When the perk is picked, also fill up the new hitpoints
	q.onAdded = @(__original) { function onAdded()
	{
		__original();
		local actor = this.getContainer().getActor();
		actor.setHitpoints(actor.getHitpoints() + this.m.ONB_HitpointsBonus);
	}}.onAdded;

	// Keeps vanilla (shorter negative effects) and Reforged (bleeding halved)
	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		__original(_properties);
		_properties.Hitpoints += this.m.ONB_HitpointsBonus;
		if (this.getContainer().getActor().isPlayerControlled())
			_properties.IsImmuneToRoot = true;
	}}.onUpdate;
});
