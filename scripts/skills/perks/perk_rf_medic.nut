// Medic: grants the Bandage skill and the Medic effect (faster injury healing and hitpoint regeneration,
// see scripts/skills/effects/medic_effect.nut and okrane_nutty_balance/hooks/injury.nut).
this.perk_rf_medic <- ::inherit("scripts/skills/skill", {
	m = {
		IsBandageAdded = false	// true if this perk added the Bandage skill (so it only removes its own)
	},
	function create()
	{
		this.m.ID = "perk.rf_medic";
		this.m.Name = ::Const.Strings.PerkName.RF_Medic;
		this.m.Description = ::Const.Strings.PerkDescription.RF_Medic;
		this.m.Icon = "ui/perks/perk_55.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onAdded()
	{
		local skills = this.getContainer();

		// Don't add a second Bandage if the character already has one (e.g. from a bandage item)
		if (!skills.hasSkill("actives.bandage_ally"))
		{
			skills.add(::new("scripts/skills/actives/bandage_ally_skill"));
			this.m.IsBandageAdded = true;
		}

		if (!skills.hasSkill("effects.rf_medic"))
			skills.add(::new("scripts/skills/effects/medic_effect"));
	}

	// Clean up on respec (the old version removed "actives.rf_medic", an ID that does not exist)
	function onRemoved()
	{
		if (this.m.IsBandageAdded)
			this.getContainer().removeByID("actives.bandage_ally");
		this.getContainer().removeByID("effects.rf_medic");
	}
});
