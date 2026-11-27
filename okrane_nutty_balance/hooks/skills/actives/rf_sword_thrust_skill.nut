// Sword Thrust (Reforged): removes the skill's built-in hit chance bonus.
::modONB.HooksMod.hook("scripts/skills/actives/rf_sword_thrust_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.HitChanceBonus = 0;
	}}.create;
});
