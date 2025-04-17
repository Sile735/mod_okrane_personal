::modONB.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) {
	
	q.onAdded = @() function()
	{		
	 	local actor = this.getContainer().getActor();
		actor.setHitpoints(this.Math.floor(actor.getHitpoints() + 10));			
	}

	q.onUpdate = @() function(_properties)
	{		
		_properties.Hitpoints += 10;	
	}
	
});