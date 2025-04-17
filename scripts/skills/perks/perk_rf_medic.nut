this.perk_rf_medic <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_medic";
		this.m.Name = "Medic";
		this.m.Description = "Medic";
		this.m.Icon = "ui/perks/perk_55.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;		
	}

	function onAdded()
	{		
		this.getContainer().add(::new("scripts/skills/actives/bandage_ally_skill"));
		this.getContainer().add(::new("scripts/skills/effects/medic_effect"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.rf_medic");
	}
});
