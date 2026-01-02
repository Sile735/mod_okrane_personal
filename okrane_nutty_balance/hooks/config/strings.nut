local tooltip_map = {
	"quick_hands" : {
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
	}, 
	"nine_lives" : {
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
	},
	"bags_and_belts" : {
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
	},
	"surv_inst" : {
		ID = "perk.rf_survival_instinct",
		Key = "Survival Instinct",
		Description = ::UPD.getDescription({
			Fluff = "Your will to live is strong!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you are attacked, gain a stacking bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] of " + ::MSU.Text.colorPositive("+2") + " on a miss and " + ::MSU.Text.colorPositive("+5") + " on a hit. This can stack up to " + ::MSU.Text.colorPositive("5") + " times for misses and up to " + ::MSU.Text.colorPositive("2") + " times for hits.",
					"At the start of every [turn|Concept.Turn] the bonus is reset except the bonus gained from getting hit which is retained for the remainder of the combat.", 
					"Permanently gain 5 [Hitpoints|Concept.Hitpoints]"
				]
			}]
		})
	},
	"hold_out" : {
		ID = "perk.hold_out",
		Key = "HoldOut",	// Current name is 'Resilient'
		Description = ::UPD.getDescription({
			Fluff = "Keep it together!",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Any negative [status effect|Concept.StatusEffect] with a finite duration (e.g. [$ $|Skill+disarmed_effect], [$ $|Skill+charmed_effect]) has its duration reduced to " + ::MSU.Text.colorPositive(1) + " [turn|Concept.Turn].",
					"[Status effects|Concept.StatusEffect] that have their effects grow weaker over several [turns|Concept.Turn] (e.g. [$ $|Skill+goblin_poison_effect]) are at their weakest state from the start.",
					"The effects of [$ $|Skill+bleeding_effect] are " + ::MSU.Text.colorPositive("halved") + "."
					"Gain Immunity to [netted,|Skill+net_effect], [webbed,|Skill+web_effect] or [rooted.|Skill+rooted_effect]", 					
					"Permanently gain 5 [Hitpoints|Concept.Hitpoints]"
				]
 			}]
	 	})
	},
	"supporter" : {
		ID = "perk.rf_supporter",
		Key = "Supporter",
		Description = ::UPD.getDescription({
			Fluff = "I\'ve got your back!",
			Effects = [			
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Gain the [$ $|Skill+rf_encourage_skill] skill which allows you to increase the [morale|Concept.Morale] of an ally and grant them extra [Action Point|Concept.ActionPoints]"
					]
				}
			]
		})
	}


};


::Reforged.QueueBucket.FirstWorldInit.push(function() {

	::logInfo("adding okrane tooltips");
	foreach (key, collection in tooltip_map)
	{
		::UPD.setDescription(collection.ID, collection.Key, ::Reforged.Mod.Tooltips.parseString(collection.Description));		
	}
	foreach (key, string in ::Const.Strings.PerkDescription)
	{
		local parsedString = ::Reforged.Mod.Tooltips.parseString(string);
		::Const.Strings.PerkDescription[key] = parsedString;
	}

	foreach (perkDef in ::Const.Perks.LookupMap)
	{
		perkDef.Tooltip = ::Reforged.Mod.Tooltips.parseString(perkDef.Tooltip);
	}

});