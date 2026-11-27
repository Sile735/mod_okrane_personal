// Living Tree Shield (crafted Schrat shield): weighs 8 instead of 12 (-8 Maximum Fatigue).
// Reforged's changes to it (150 durability, sapling spawning, Reach ignore) are kept.
::modONB.HooksMod.hook("scripts/items/shields/special/craftable_schrat_shield", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.StaminaModifier = -8;
	}}.create;
});
