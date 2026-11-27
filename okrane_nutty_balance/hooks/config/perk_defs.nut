// Medic perk (new): name, UPD description and registration with Dynamic Perks.
// Reforged parses all perk descriptions ([Concept|...] links) when the first world is initialized,
// so the raw text here is enough.
::MSU.Table.merge(::Const.Strings.PerkName, {
	RF_Medic = "Medic"
});

::MSU.Table.merge(::Const.Strings.PerkDescription, {
	RF_Medic = ::UPD.getDescription({
		Fluff = "Years of training in the hospitals come very useful on the battlefield.",
		Effects = [
			{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Injuries heal " + ::MSU.Text.colorPositive("1") + " day faster",
					"Recovers " + ::MSU.Text.colorPositive("15") + " Hitpoints after each battle",
					"Recovers " + ::MSU.Text.colorPositive("5") + " Hitpoints each turn"
				]
			},
			{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [$ $|Skill+bandage_ally_skill] skill."
				]
			}
		]
	})
});

::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.rf_medic",
		Script = "scripts/skills/perks/perk_rf_medic",
		Name = ::Const.Strings.PerkName.RF_Medic,
		Tooltip = ::Const.Strings.PerkDescription.RF_Medic,
		Icon = "ui/perks/perk_55.png",
		IconDisabled = "ui/perks/perk_55_sw.png"
	}
]);
