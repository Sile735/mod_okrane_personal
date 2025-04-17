local quick_hands = {
		ID = "perk.quick_hands",
		Key = "QuickHands",
		Description = ::UPD.getDescription({
			Fluff = "Fastest hands in the West.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Swapping any item in battle becomes a free action with no [Action Point|Concept.ActionPoints] cost once every [turn.|Concept.Turn]",					
				]
			}]
		})
	}
::UPD.setDescription(quick_hands.ID, quick_hands.Key, ::Reforged.Mod.Tooltips.parseString(quick_hands.Description));

local nine_lives = {
		ID = "perk.nine_lives",
		Key = "NineLives",
		Description = ::UPD.getDescription({
			Fluff = "Curiosity may have killed the cat but it sure took awhile.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Once per battle, upon receiving a killing blow, survive instead with a few [Hitpoints|Concept.Hitpoints] left and have all damage over time effects (e.g. [bleeding|Skill+bleeding_effect], [poisoned|Skill+spider_poison_effect]) cured.",
					"Upon triggering, gain [Heightened Reflexes|Skill+nine_lives_effect] until the start of your next [turn.|Concept.Turn]",
					"Permanently gain 10 [Hitpoints|Concept.Hitpoints]"
				]
			}]
		})
	}
::UPD.setDescription(nine_lives.ID, nine_lives.Key, ::Reforged.Mod.Tooltips.parseString(nine_lives.Description));

local bags_and_belts = {
		ID = "perk.bags_and_belts",
		Key = "BagsAndBelts",
		Description = ::UPD.getDescription({
			Fluff = "Preparedness is the key to victory.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Unlock two extra [bag slots.|Concept.BagSlots]",
					"Items placed in [bags|Concept.BagSlots] no longer apply a penalty to [Maximum Fatigue,|Concept.MaximumFatigue]"
				]
			}]
		})
	}

::UPD.setDescription(bags_and_belts.ID, bags_and_belts.Key, ::Reforged.Mod.Tooltips.parseString(bags_and_belts.Description));

local surv_inst = ::UPD.getDescription({
		Fluff = "Your will to live is strong!",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"Whenever you are attacked, gain a stacking bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] of " + ::MSU.Text.colorPositive("+2") + " on a miss and " + ::MSU.Text.colorPositive("+5") + " on a hit. This can stack up to " + ::MSU.Text.colorPositive("5") + " times for misses and up to " + ::MSU.Text.colorPositive("2") + " times for hits.",
				"At the start of every [turn|Concept.Turn] the bonus is reset except the bonus gained from getting hit which is retained for the remainder of the combat.", 
				"Permanently gain 5 [Hitpoints|Concept.Hitpoints]"
			]
		}]
	});

::UPD.setDescription("perk.rf_survival_instinct", "Survival Instinct", ::Reforged.Mod.Tooltips.parseString(surv_inst));

local hold_out = {
		ID = "perk.hold_out",
		Key = "HoldOut",	// Current name is 'Resilient'
		Description = ::UPD.getDescription({
			Fluff = "Keep it together!",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Any negative status effect with a finite duration (e.g. Bleeding, Charmed) has its duration reduced to [color=" + ::Const.UI.Color.NegativeValue + "]1[/color] turn.",
					"Status effects that have their effects grow weaker over several turns (e.g. Goblin Poison) are at their weakest state from the start.", 
					"Gain Immunity to [netted,|Skill+net_effect], [webbed,|Skill+web_effect] or [rooted.|Skill+rooted_effect]", 					
					"Permanently gain 5 [Hitpoints|Concept.Hitpoints]"
				]
 			}]
	 	})
	};
::UPD.setDescription(hold_out.ID, hold_out.Key, ::Reforged.Mod.Tooltips.parseString(hold_out.Description));
