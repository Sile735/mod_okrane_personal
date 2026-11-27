// Okrane's Nutty Balance - preload / registration
// Registers the mod with Modern Hooks and MSU, then loads every hook file in the Late bucket.

::modONB <- {
	ID = "mod_ONB",
	Name = "Okrane's Nutty Balance",
	Version = "0.6.1",	// keep in sync with the GitHub release tag
	GitHubURL = "https://github.com/Sile735/mod_okrane_personal",
	// Functions pushed here (by hook files) run once, when the first world is initialized,
	// after Reforged has parsed its own tooltips (same pattern as ::Reforged.QueueBucket.FirstWorldInit)
	FirstWorldInit = []
};

local requiredMods = [
	"mod_msu",
	"mod_dynamic_perks",
	"mod_reforged",
	"mod_stack_based_skills"
];

::modONB.HooksMod <- ::Hooks.register(::modONB.ID, ::modONB.Version, ::modONB.Name);
::modONB.HooksMod.require(requiredMods);

// Build the load order from the requirements: ">" means "load AFTER that mod" ("<" would mean BEFORE).
// Version constraints like "mod_x >= 1.0" are stripped down to the mod ID.
local queueLoadOrder = [];
foreach (requirement in requiredMods)
{
	local idx = requirement.find(" ");
	queueLoadOrder.push(">" + (idx == null ? requirement : requirement.slice(0, idx)));
}

::modONB.HooksMod.queue(queueLoadOrder, function() {
	::modONB.Mod <- ::MSU.Class.Mod(::modONB.ID, ::modONB.Version, ::modONB.Name);

	// In-game "new version available" notification via MSU
	::modONB.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::modONB.GitHubURL);
	::modONB.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);
});

// Hooks are registered in the Late bucket so they wrap on top of Reforged's own changes.
::modONB.HooksMod.queue(queueLoadOrder, function() {
	::include("okrane_nutty_balance/load.nut");
}, ::Hooks.QueueBucket.Late);

::modONB.HooksMod.queue(queueLoadOrder, function() {
	foreach (func in ::modONB.FirstWorldInit)
	{
		func();
	}
	delete ::modONB.FirstWorldInit;
}, ::Hooks.QueueBucket.FirstWorldInit);
