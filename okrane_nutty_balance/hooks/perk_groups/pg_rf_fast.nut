// Fast perk group: Nine Lives and Pathfinder at tiers 1-2.
// The whole tree is redefined on purpose (create() is replaced, not wrapped).
::modONB.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_fast", function(q) {
	q.create = @() { function create()
	{
		this.m.ID = "pg.rf_fast";
		this.m.Name = "Fast";
		this.m.Icon = "ui/perk_groups/rf_fast.png";
		this.m.Tree = [
			["perk.nine_lives"],
			["perk.pathfinder"],
			[],
			["perk.rf_dynamic_duo"],
			["perk.rf_calculated_strikes"],
			["perk.overwhelm"],
			["perk.rf_combo"]
		];
	}}.create;
});
