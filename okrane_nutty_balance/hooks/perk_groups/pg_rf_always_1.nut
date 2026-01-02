::modONB.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_always_1", function(q) {
	q.create = @() function()
	{
		this.m.ID = "pg.rf_always_1";
		this.m.Name = "General";
		this.m.Icon = "ui/perk_groups/rf_always_1.png";
		this.m.Tree = [
			["perk.bags_and_belts"],
			["perk.quick_hands"],
			["perk.fortified_mind"],
			[],
			[],
			[],
			[]
		];
	}
});