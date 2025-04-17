::MSU.Table.merge(::Const.Strings.PerkName, {
	RF_Medic = "Medic"
});

::MSU.Table.merge( ::Const.Strings.PerkDescription, {
	RF_Medic = ::UPD.getDescription({
		Fluff = "Years of training in the hospitals come very useful on the battlefield.",		
		Effects = [
			{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Injuries heal [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] day faster",
					"Recovers [color=" + this.Const.UI.Color.PositiveValue + "]10[/color] Hitpoints after each battle"
				]
			},
			{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the Bandage Ally skill."
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