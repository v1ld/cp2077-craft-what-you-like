// CraftWhatYouWant - v1ld, 2022-03-08
// MIT License applies

// Bypass crafting quality perk checks so you can craft anything
@wrapMethod(CraftingSystem)
public final const func CanCraftGivenQuality(itemData: wref<gameItemData>, out quality: gamedataQuality) -> Bool {
  return true;
}

// Bypass crafting quality perk checks so you can craft anything
@wrapMethod(CraftingSystem)
public final const func CanCraftGivenQuality(itemRecord: wref<Item_Record>, out quality: gamedataQuality) -> Bool {
  return true;
}

// Treat random quality item crafts as having Crafting Skill 20, allowing Legendary and Epics to be crafted
@wrapMethod(RPGManager)
public final static func SetQualityBasedOnCraftingSkill(object: wref<GameObject>) -> CName {
  let quality: CName;
  // v1ld: emulate a Crafting Skill level of 20
  let craftingValue: Float = 20.0; // GameInstance.GetStatsSystem(object.GetGame()).GetStatValue(Cast<StatsObjectID>(object.GetEntityID()), gamedataStatType.Crafting);
  let scalingValue: Float = GameInstance.GetStatsDataSystem(object.GetGame()).GetValueFromCurve(n"random_distributions", craftingValue, n"crafting_to_random_quality_items");
  switch scalingValue {
    case 0.00:
      quality = n"Common";
      break;
    case 1.00:
      quality = n"Uncommon";
      break;
    case 2.00:
      quality = n"Rare";
      break;
    case 3.00:
      quality = n"Epic";
      break;
    case 4.00:
      quality = n"Legendary";
      break;
    default:
      quality = n"Common";
  };
  return quality;
}

// Bypass crafting perk prereqs on crafted items
@wrapMethod(RPGManager)
public final static func CheckCraftedItemPerkPrereq(itemData: wref<gameItemData>, context: wref<GameObject>, out prereqName: String) -> Bool {
  return false;
}

// Bypass equipment manager check on crafting perk prereqs for crafted items while preserving stat prereqs
@wrapMethod(RPGManager)
public final static func CheckPrereq(prereqRecord: wref<IPrereq_Record>, target: wref<GameObject>, opt referenceStatsID: StatsObjectID) -> Bool {
  let prereq: ref<IPrereq> = IPrereq.CreatePrereq(prereqRecord.GetID());
  let statPrereq: ref<StatPrereq> = prereq as StatPrereq;
  if IsDefined(statPrereq) && StatsObjectID.IsDefined(referenceStatsID) {
    if !statPrereq.IsFulfilled(target.GetGame(), target, referenceStatsID) {
      return false;
    };
  }; /* v1ld: skip all non-stat prereq checks, primarily perk prereqs 
  else {
    if !prereq.IsFulfilled(target.GetGame(), target) {
      return false;
    };
  }; */
  return true;
}