//::include("mod_MODID/some_priority_script");	// This file needs priority
::logInfo("Nutty Balance Loading");
::includeFiles(::IO.enumerateFiles("okrane_nutty_balance/hooks"));		// This will load and execute all hooks
::logInfo("loaded " + ::IO.enumerateFiles("okrane_nutty_balance/hooks"))
