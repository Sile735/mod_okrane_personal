::modONB.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_trained", function(q) {
	q.create = @() function()
	{
		this.m.ID = "pg.rf_trained";
		this.m.Name = "Trained";
		this.m.Icon = "ui/perk_groups/rf_trained.png";
		this.m.Tree = [
			["perk.rf_medic"], 
			[],
			["perk.rotation"],
			["perk.rf_vigilant"],
			["perk.underdog"],
			["perk.rf_finesse"],
			["perk.rf_weapon_master"]
		];
	}
});
