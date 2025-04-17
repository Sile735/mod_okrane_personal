::Hooks.registerJS("ui/mods/mod_MODID/setup.js");	// priority registering

local prefixLen = "ui/mods/".len();
foreach(file in ::IO.enumerateFiles("ui/mods/mod_MODID/js_hooks"))	// automatically register all hook-like files
{
	::Hooks.registerJS(file + ".js");
}

::Hooks.registerJS("ui/mods/mod_MODID/my/new/ui/class.js");
::Hooks.registerCSS("ui/mods/mod_MODID/my/new/ui/class.css");

