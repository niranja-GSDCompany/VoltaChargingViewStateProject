trigger ProjectCompleteOppClosedWon on Construction_Project__c (after insert, after update) {
	/*
	* If all of the Construction Projects that are related to an Opp are 'Completed',
	* set the Stage of the Opportunity to 'Closed Won'.
	*/
	List<Construction_Project__c> cpList = trigger.new;
	ProjectCompleteOppClosedWon.checkProjectComplete(cpList);
}