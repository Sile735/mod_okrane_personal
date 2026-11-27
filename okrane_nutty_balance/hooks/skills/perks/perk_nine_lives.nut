// Nine Lives: additionally grants +10 Hitpoints (description in config/strings.nut).
::modONB.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) {
	q.m.ONB_HitpointsBonus <- 10;

	// When the perk is picked, also fill up the new hitpoints
	// (on savegame load the hitpoints are restored after the skills, so this does not heal on load)
	q.onAdded = @(__original) { function onAdded()
	{
		__original();
		local actor = this.getContainer().getActor();
		actor.setHitpoints(actor.getHitpoints() + this.m.ONB_HitpointsBonus);
	}}.onAdded;

	// Keep vanilla's onUpdate: it removes damage-over-time effects when Nine Lives triggers
	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		__original(_properties);
		_properties.Hitpoints += this.m.ONB_HitpointsBonus;
	}}.onUpdate;
});
