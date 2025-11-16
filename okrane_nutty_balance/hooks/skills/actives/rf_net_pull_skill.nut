::modONB.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	
	q.create = @(__original) function()
	{
		__original();
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 2;		}	
	
}); 