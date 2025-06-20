::modONB.HooksMod.hook("scripts/skills/special/double_grip", function(q) {

	// Make swapping to bagged bombs a free action.
	// This has nothing to do with double grip bonus but is implemented in double_grip just for convenience
	// because double_grip is present on all relevant characters.
	q.getItemActionCost = @() { function getItemActionCost( _items )
	{
		if (this.m.IsFreeSwapSpent)
			return;

		foreach (item in _items)
		{
			if (item != null && item.isItemType(::Const.Items.ItemType.Tool))
			{
				return 0;
			}
		}
	}}.getItemActionCost;

});