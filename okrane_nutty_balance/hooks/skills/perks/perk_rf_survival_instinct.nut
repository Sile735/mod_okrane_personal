::modONB.HooksMod.hook("scripts/skills/perks/perk_rf_survival_instinct", function(q) {
	
	q.onAdded = @() function()
	{		
	 	local actor = this.getContainer().getActor();
		actor.setHitpoints(this.Math.floor(actor.getHitpoints() + 10));			
	}

	q.onUpdate = @() function(_properties)
	{
		local bonus = this.getBonus();
		_properties.MeleeDefense += bonus;
		_properties.RangedDefense += bonus;		
		_properties.Hitpoints += 5;	
	}
});