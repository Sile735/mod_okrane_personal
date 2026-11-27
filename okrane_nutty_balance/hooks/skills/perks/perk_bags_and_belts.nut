// Bags and Belts: items in bags never reduce Maximum Fatigue with the perk, two-handed items included.
// Vanilla still applies the penalty for items that block a second slot (two-handed weapons) even with the perk.
// Without the perk the vanilla penalty (half the item's weight) stays.
// The perk description is set in config/strings.nut.
// (Rewritten from the legacy mod_hooks API to modern hooks.)
::modONB.HooksMod.hook("scripts/skills/special/bag_fatigue", function(q) {
	q.onUpdate = @() { function onUpdate( _properties )
	{
		if (this.getContainer().hasSkill("perk.bags_and_belts"))
			return;

		foreach (item in this.getContainer().getActor().getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag))
		{
			_properties.Stamina += item.getStaminaModifier() / 2;
		}
	}}.onUpdate;
});
