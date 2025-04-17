::modONB.HooksMod.hook("scripts/skills/actives/lunge_skill", function(q) {
	
	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus = 0;		
	}	
	
}); 