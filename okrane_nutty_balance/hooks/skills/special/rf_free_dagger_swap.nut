// Reforged gives every character one free swap to/from a dagger per turn (special.rf_free_dagger_swap).
// This mod extends it: swapping to/from a tool (bombs, flasks, nets...) is free as well.
// Daggers and tools share the same once-per-turn free swap.
::modONB.HooksMod.hook("scripts/skills/special/rf_free_dagger_swap", function(q) {
	q.getItemActionCost = @(__original) { function getItemActionCost( _items )
	{
		local ret = __original(_items);	// 0 for daggers, null otherwise
		if (ret != null || this.m.IsSpent)
			return ret;

		foreach (item in _items)
		{
			if (item != null && item.isItemType(::Const.Items.ItemType.Tool))
				return 0;
		}
		return null;
	}}.getItemActionCost;
});
