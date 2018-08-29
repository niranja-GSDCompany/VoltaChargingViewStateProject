trigger KioskTrigger on Kiosk__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	kioskTriggerHandler kth = new kioskTriggerHandler();
	if(trigger.isBefore){
		if(trigger.isInsert){
		 	kth.OnBeforeInsert(trigger.new);
		}
		else if(trigger.isUpdate){
			kth.OnBeforeUpdate(trigger.old,trigger.new,trigger.newMap,trigger.oldMap);
		}
		else if(trigger.isDelete){
			kth.OnBeforeDelete(trigger.new,trigger.newMap,trigger.oldMap);
		}
	}

	else if(trigger.isAfter){
		if(trigger.isInsert){
			kth.OnAfterInsert(trigger.new);
		}
		else if(trigger.isUpdate){
			kth.OnAfterUpdate(trigger.old,trigger.new,trigger.newMap,trigger.oldMap);
		}
	}




}