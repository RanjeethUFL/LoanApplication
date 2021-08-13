@isTest
private class loanApplicationFormControllerTest {
    
    @testSetup
    static void createSampleLoanData(){
        Contact con = new Contact();
        con.LastName ='Test';
        con.FirstName ='Contact';
        Insert con;
        
        Loan_Application__c lApp = new Loan_Application__c();
        lApp.Aadhaar_Number__c = '523456789012';
        lApp.Customer__c = con.Id;
        lApp.PAN__c = 'SUPER00007';
        Insert lApp;
    }
    
    @isTest
    private static void saveLoanApplicationTest(){
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Loan_Application__c lApp = new Loan_Application__c();
        lApp.Aadhaar_Number__c = '123412341234';
        lApp.Customer__c = con.Id;
        Test.startTest();
        loanApplicationFormController.saveLoanApplication(lApp);
        Test.stopTest();
        List<Loan_Application__c> loanApplication = [Select id,Aadhaar_Number__c FROM Loan_Application__c WHERE Aadhaar_Number__c='123412341234'];
        System.assertEquals(1, loanApplication.size(), '1 Loan Application record should be created with Aadhaar ......');
    }
    
    @isTest
    private static void checkAadharTest(){
        Loan_Application__c loanApplication = [Select id,Aadhaar_Number__c FROM Loan_Application__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        loanApplicationFormController.makeCallToAadar(loanApplication.Aadhaar_Number__c);
        Test.stopTest();
    }
    
    
    @isTest
    private static void checkCibilTest(){
        Loan_Application__c loanApplication = [Select id,PAN__c,Aadhaar_Number__c FROM Loan_Application__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new CibilMockHttpResponseGenerator());
        Test.startTest();
        String cibilScore = loanApplicationFormController.makeCallToCibil(loanApplication.PAN__c);
        Test.stopTest();
		System.assertEquals(800, Integer.valueOf(cibilScore), 'Cibil score in not updated');
    }
    
}