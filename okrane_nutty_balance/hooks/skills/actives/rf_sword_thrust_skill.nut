// Sword Thrust (Reforged, fencing sword): removes the -20% chance to hit.
// Reforged 0.9 stores the penalty in m.MeleeSkillAdd (applied in onAnySkillUsed and shown in the tooltip);
// setting HitChanceBonus, as older versions of this mod did, no longer has any effect.
::modONB.HooksMod.hook("scripts/skills/actives/rf_sword_thrust_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.MeleeSkillAdd = 0;
	}}.create;
});
