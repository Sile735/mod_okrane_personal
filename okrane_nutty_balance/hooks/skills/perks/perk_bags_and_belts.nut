local gt = this.getroottable();
local found;
gt.Const.Strings.PerkDescription.BagsAndBelts = "Unlock two extra bag slots to carry all your favorite things. Items placed in bags no longer give a penalty to Maximum Fatigue.";

for( local row = 0; row < gt.Const.Perks.Perks.len(); row = row )
{
	for( local i = 0; i < gt.Const.Perks.Perks[row].len(); i = i )
	{
		local perk = gt.Const.Perks.Perks[row][i];

		if (perk.ID == "perk.bags_and_belts")
		{
			perk.Tooltip = gt.Const.Strings.PerkDescription.BagsAndBelts;
			found = true;
		}

		if (found)
		{
			break;
		}

		i = ++i;
	}

	if (found)
	{
		break;
	}

	row = ++row;
}
::mods_hookClass("skills/special/bag_fatigue", function (bf)
{
	bf.onUpdate = function( _properties )
	{
		local hasBagsAndBelts = this.getContainer().hasSkill("perk.bags_and_belts");
		local items = this.getContainer().getActor().getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);

		foreach( item in items )
		{
			if (!hasBagsAndBelts)
			{
				_properties.Stamina += item.getStaminaModifier() / 2;
			}
		}
	}

});