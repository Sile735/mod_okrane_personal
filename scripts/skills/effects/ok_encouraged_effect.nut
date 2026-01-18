this.ok_encouraged_effect <- ::inherit("scripts/skills/skill", {
	m = {
		BonusActionPoints = 3,		
		ActionPointCostPenalty = 2
		IsInEffect = false,
		IsStartingTurn = false
	},
	function create()
	{
		this.m.ID = "effects.encouraged_effect_buff";
		this.m.Name = "Feeling Encouraged";
		this.m.Description = "This character started the turn cheered by a highly encouraging character!";
		this.m.Icon = "skills/rf_inspiring_presence_buff_effect.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.SoundOnUse = [
			"sounds/combat/rf_inspiring_presence_01.wav",
			"sounds/combat/rf_inspiring_presence_02.wav",
			"sounds/combat/rf_inspiring_presence_03.wav"
		];
		this.m.IsSerialized = false;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::MSU.Text.colorPositive("+" + this.m.BonusActionPoints) + " Action Points"
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.m.IsInEffect)
		{
			_properties.ActionPoints += this.m.BonusActionPoints;
			
			if (this.m.IsStartingTurn)
			{
				this.getContainer().getActor().setActionPoints(this.getContainer().getActor().getActionPointsMax() + this.m.BonusActionPoints);
				this.m.IsStartingTurn = false;				
			}
		}
	}

	function onTurnStart()
	{		
		this.m.IsStartingTurn = true;
		if (this.m.IsInEffect){
			this.spawnIcon("rf_inspiring_presence_buff_effect", this.getContainer().getActor().getTile());			
			::Sound.play(this.m.SoundOnUse[::Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.Skill * this.m.SoundVolume, this.getContainer().getActor().getPos());
		}
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
		this.m.IsStartingTurn = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
		this.m.IsStartingTurn = false;
	}
});
