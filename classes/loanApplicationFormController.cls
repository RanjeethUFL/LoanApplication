public with sharing class loanApplicationFormController {
    public loanApplicationFormController() {

    }
    @AuraEnabled
    Public static Id saveLoanApplication(Loan_Application__c loan){
        try{ 
          User user = [Select id,contactId from user where id =: userinfo.getUserId()];
          if(user.contactId != null){
             loan.Customer__c = user.contactId;
          }
          String cibilscore = makeCallToCibil(loan.PAN__c);
            if(String.isNotBlank(cibilscore)){
    	         loan.CIBIL_Score__c = Decimal.valueOf(cibilscore);
            }
          loan.Loan_Status__c = 'Submitted';
          insert loan;
          return loan.Id;
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getmessage());
        } 
    }
    /* External system callout for aadhar verfication */ 

    @AuraEnabled
    Public static AadharWrapper makeCallToAadar(string aadharNumber){
        AadharWrapper response = new AadharWrapper();
        try{
            if(string.isnotblank(aadharNumber)){
                HTTPRequest tokenRequest = new HTTPRequest();
                tokenRequest.setEndpoint('https://obscure-beach-73718.herokuapp.com/aadharid/'+ aadharNumber);
                tokenRequest.setMethod('GET');
                HTTP http = new HTTP();
                HTTPResponse tokenResponse = http.send(tokenRequest);
                /* sample JSON format from external system
                {
                    "firstName": "Rajesh",
                    "lastName": "Kottu",
                    "Address": "Santa Residency",
                    "city": "Hyderabad",
                    "district": "Hyderabad",
                    "state": "Telanagana",
                    "pincode": "500018"
                } 
                */ 

                if(tokenResponse.getStatusCode() == 200 ){
                    response = (AadharWrapper)JSON.deserialize( tokenResponse.getBody(), AadharWrapper.class);
                }else {
                    throw new AuraHandledException('Aadhar validation Failed');
                } 
            }
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getmessage());
        }
        return  response;
    }

    @AuraEnabled
    Public static String makeCallToCibil(string pan){
        AadharWrapper response = new AadharWrapper();
        try{
            if(string.isnotblank(pan)){
                HTTPRequest tokenRequest = new HTTPRequest();
                tokenRequest.setEndpoint('https://obscure-beach-73718.herokuapp.com/CIBIL/'+ pan);
                tokenRequest.setMethod('GET');
                HTTP http = new HTTP();
                HTTPResponse tokenResponse = http.send(tokenRequest);
                /* sample JSON format from external system
                {
                     "CIBILScore" : "800"
                } 
                */ 

                if(tokenResponse.getStatusCode() == 200 ){
                    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(tokenResponse.getBody());

                    for(string str : m.keyset()){
                        if(str == 'CIBIL'){
                            string value = (string) m.get(str); 
							return value;
                        }
                    }
                }else{
                    throw new AuraHandledException('CIBIL validation Failed');
                } 
            }
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getmessage());
        }
        return null;
    }

    Public class AadharWrapper{
        @AuraEnabled Public string firstName;
        @AuraEnabled Public string lastName;
        @AuraEnabled Public string city;
        @AuraEnabled Public string district;
        @AuraEnabled Public string state;
        @AuraEnabled Public string pincode;
        @AuraEnabled Public string address;
        @AuraEnabled Public string key;
    }
}