::modONB <- {
	ID = "mod_ONB",
	Name = "Okrane's Nutty Balance",
	Version = "0.2.0",
	// GitHubURL = "https://github.com/YOURNAME/mod_MODID",
}

local requiredMods = [
    "mod_dynamic_perks",
    "mod_reforged",
    "mod_stack_based_skills"    
];
::modONB.HooksMod <- ::Hooks.register(::modONB.ID, ::modONB.Version, ::modONB.Name);
::modONB.HooksMod.require(requiredMods);
local queueLoadOrder = [];
foreach (requirement in requiredMods)
{
	local idx = requirement.find(" ");
	queueLoadOrder.push("<" + (idx == null ? requirement : requirement.slice(0, idx)));
}
::modONB.HooksMod.queue(queueLoadOrder, function() {
	::modONB.Mod <- ::MSU.Class.Mod(::modONB.ID, ::modONB.Version, ::modONB.Name);
});

::modONB.HooksMod.queue(queueLoadOrder, function() {
    ::include("okrane_nutty_balance/load.nut");
}, ::Hooks.QueueBucket.Late);
