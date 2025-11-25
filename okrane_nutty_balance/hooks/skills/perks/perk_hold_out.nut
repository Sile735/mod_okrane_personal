::modONB.HooksMod.hook("scripts/skills/perks/perk_hold_out", function(q) {
	
	q.onAdded = @() function()
	{		
	 	local actor = this.getContainer().getActor();
		actor.setHitpoints(this.Math.floor(actor.getHitpoints() + 5));			
	}

	q.onUpdate = @() function(_properties)
	{		

		local actor = this.getContainer().getActor();
		
		_properties.Hitpoints += 5;	
		_properties.NegativeStatusEffectDuration += -5;		
	 	if (actor.isPlayerControlled()){
	 		_properties.IsImmuneToRoot = true;
	 	}
	}
	
}); 