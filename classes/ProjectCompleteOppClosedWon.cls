public with sharing class ProjectCompleteOppClosedWon {
	public static void checkProjectComplete(List<Construction_Project__c> cpList) {
		//Stores the Opportunity Ids
		List<String> oppIdList = new List<String>();
		List<Opportunity> updateOpp = new List<Opportunity>();
		Map<String, Map<String, Construction_Project__c>> cpMap = new Map<String, Map<String, Construction_Project__c>>();

		// Loop through the Construction Projects and get the Opp Ids that they
		// are associated with.
		for(Construction_Project__c cp : cpList){
			oppIdList.add(cp.Biz_Dev_Opportunity__c);
			cpMap.put(cp.Biz_Dev_Opportunity__c, new Map<String, Construction_Project__c>{cp.id => cp});
		}

		// Get the opportunities with the Ids that are stored in the list of Opp Ids from the
		// for loop above.
		Map<String, Opportunity> oppMap = new Map<String, Opportunity>([SELECT Id, Name FROM Opportunity WHERE Id IN :oppIdList]);
		// Stores the Construction Project Ids
		List<String> cpIdList = new List<String>();

		// Loop through map of Opportunities and add their Ids to a list
		// so that you can use that list to query all of the Consturction
		// Projects that are related to each Opp
		for(Opportunity opp : oppMap.values()){
			cpIdList.add(opp.Id);
		}

		// Get all Construction projects that are related to the Opps in the list.
		List<Construction_Project__c> allRelatedCpList = [SELECT Id, Name, Stage__c, Biz_Dev_Opportunity__c 
														FROM Construction_Project__c WHERE Biz_Dev_Opportunity__c IN :cpIdList];

		// Loop through the map of maps of Constuction Projects and group them together
		// in a map based on the Opportunity Id and the Construction Id.
		for(Construction_Project__c cp : allRelatedCpList){
			Map<String, Construction_Project__c> newCpMap = cpMap.get(cp.Biz_Dev_Opportunity__c);
			if(!newCpMap.containsKey(cp.Id)){
				newCpMap.put(cp.Id, cp);
			}
		}
		system.debug('All Related CP: '+allRelatedCpList);
		// Loop through the grouped Construction Projects and check to see
		// if all of the Construction Projects are set to Stage = 'Completed'.
		// If they are completed update the count. Once the loop has been finished,
		// check to see if the size of the map = the count. If it does, change the
		// Opp to 'Closed Won'.
		for(String cpId : cpMap.keySet()){
			Map<String, Construction_Project__c> cpGroupMap = cpMap.get(cpId);
			Integer completedCount = 0;
			system.debug('id: '+cpId);
			for(Construction_Project__c cp : cpGroupMap.values()){
				system.debug('Name & Id & Stage: '+cp.Name+' '+cp.Biz_Dev_Opportunity__c+' '+cp.Stage__c);
				if(cp.Stage__c == 'Completed'){
					completedCount += 1;
				}
			}
			system.debug('Count Size: '+completedCount);
			system.debug('Group Map Size: '+cpGroupMap.size());
			if(cpGroupMap.size() == completedCount){
				Opportunity opp = oppMap.get(cpId);
				opp.StageName = 'Closed Won';
				updateOpp.add(opp);
				system.debug(opp.Id);
			}
		}

		update updateOpp;
	}
}