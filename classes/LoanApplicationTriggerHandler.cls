public with sharing class LoanApplicationTriggerHandler {
    Public Static String LOAN_STATUS = 'Approved';

    public static void afterUpdate(List<Loan_Application__c> newList, List<Loan_Application__c> oldList, 
                                    Map<Id,Loan_Application__c> newMap, Map<Id,Loan_Application__c> oldMap ){
                                        
        List<Loan_Payments__c> paymentInsertList = new List<Loan_Payments__c>();
        Map<Id, Id> contactMap = new Map<Id,Id>();
        Map<Id, Id> contactToUserMap = new Map<Id,Id>();
        for(Loan_Application__c loan : newList){
            if(loan.Loan_Status__c == LOAN_STATUS && loan.Loan_Status__c != oldMap.get(loan.Id).Loan_Status__c){
                contactMap.put(Loan.Id, loan.Customer__c);
                Loan_Payments__c  payment = new Loan_Payments__c();
                payment.Loan_Application__c = loan.Id;
                payment.Payment_Month__c = 'August';
                payment.Received_Amount__c = 15000;
    
                Loan_Payments__c  payment1 = new Loan_Payments__c();
                payment1.Loan_Application__c = loan.Id;
                payment1.Payment_Month__c = 'September';
                payment1.Received_Amount__c = 25000;
    
                Loan_Payments__c  payment2 = new Loan_Payments__c();
                payment2.Loan_Application__c = loan.Id;
                payment2.Payment_Month__c = 'October';
                payment2.Received_Amount__c = 30000; 
    
                paymentInsertList.add(payment);
                paymentInsertList.add(payment1);
                paymentInsertList.add(payment2);
            }
               
        }

        for(user userRecord : [Select id,contactId from user where contactId in : contactMap.values()]){
            contactToUserMap.put(UserRecord.contactId, userRecord.Id);
        }
        
        system.debug(contactToUserMap);

        for(Loan_Application__c loan : newList){
            if(loan.Customer__c != null){
                //retrive user from contact
                Id userRecord =  contactToUserMap.get(loan.Customer__c);
                 if(userRecord != null ){
                    notifyUsers(new Set<String>{userRecord}, loan.Id);
                 }
            }
         // Insert Sample Payment records for demo purpose, this requires calculations later for actual implementation

        }
        if(paymentInsertList.size() > 0){
            insert paymentInsertList;
        }    
    }

    public static void notifyUsers(Set<String> recipientsIds, String targetId) {

        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='NotifyCommunityUser'];
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('Congratulations');
        notification.setBody('Loan Approved, Kindly contact RM for futher information');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
        }
    }

}