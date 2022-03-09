// CraftWhatYouWant - v1ld, 2022-03-08
// Copyright (c) 2022 v1ld.git@gmail.com
// This code is licensed under MIT license

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