::modONB.HooksMod.hook("scripts/skills/perks/perk_quick_hands", function(q) {
	
	q.getItemActionCost = @(__original) function(_items)
	{
	 	if (this.m.IsSpent)
			return null;

		return 0;
	}
});