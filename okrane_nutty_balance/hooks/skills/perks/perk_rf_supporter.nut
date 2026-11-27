// Supporter: Reforged's "recover Action Points when using a skill on a nearby ally" is disabled on purpose.
// In this mod Supporter's value comes from the reworked Encourage skill instead (see actives/rf_encourage_skill.nut).
// Reforged only sets up the AP recovery in onBeforeAnySkillExecuted, so making it do nothing disables it.
::modONB.HooksMod.hook("scripts/skills/perks/perk_rf_supporter", function(q) {
	q.onBeforeAnySkillExecuted = @() { function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
	}}.onBeforeAnySkillExecuted;
});
