// Quick Hands: once per turn ANY item swap is free.
// Replaces Reforged's version on purpose, which excludes swapping between two two-handed weapons.
::modONB.HooksMod.hook("scripts/skills/perks/perk_quick_hands", function(q) {
	q.getItemActionCost = @() { function getItemActionCost( _items )
	{
		if (this.m.IsSpent)
			return null;	// null = this skill does not change the cost
		return 0;
	}}.getItemActionCost;
});
