trigger LoanApplicationTrigger on Loan_Application__c (after update) {

    if(trigger.isupdate && trigger.isAfter){
        LoanApplicationTriggerHandler.afterUpdate(trigger.new, trigger.Old,trigger.newMap, Trigger.OldMap);
    }

}