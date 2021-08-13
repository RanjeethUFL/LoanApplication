import { LightningElement ,track, wire } from 'lwc';
import {  ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import EDUCATION_FIELD from '@salesforce/schema/Loan_Application__c.Education__c';
import MARTIALSTATUS_FIELD from '@salesforce/schema/Loan_Application__c.Marital_status__c';
import EMPLOYMENTTYPE_FIELD from '@salesforce/schema/Loan_Application__c.Employment_Type__c';
import LOANTYPE_FIELD from '@salesforce/schema/Loan_Application__c.Loan_Type__c';
import LOAN_OBJECT from '@salesforce/schema/Loan_Application__c'; 
import saveLoanApplication from '@salesforce/apex/loanApplicationFormController.saveLoanApplication';
import makeCallToAadar from '@salesforce/apex/loanApplicationFormController.makeCallToAadar';


export default class LoanApplicationForm extends NavigationMixin(LightningElement) {
    activeSections = ['A',  'B' , 'C'];
    @track loanRecord = {};
    edpickListvalues = [];
    mspickListvalues = [];
    emppickListvalues = [];
    loanpickListvalues = [];
    isBusiness = false;
    isSalaried = false;
    showProduct = false;


    @wire(getObjectInfo, { objectApiName: LOAN_OBJECT })
    objectInfo;

    handleChange(event){
        if(event.target.label == 'Aadhaar Number'){
            this.loanRecord.Aadhaar_Number__c =  event.target.value;
            if(this.loanRecord.Aadhaar_Number__c.length == 12){
                this.validateCallAadhar();
            }
        }
        if(event.target.label == 'Current Address'){
            this.loanRecord.Current_Address__c =  event.target.value;
        }
        if(event.target.label == 'City'){
            this.loanRecord.City__c =  event.target.value;
        }
        if(event.target.label == 'District'){
            this.loanRecord.District__c =  event.target.value;
        }
        if(event.target.label == 'State'){
            this.loanRecord.State__c =  event.target.value;
        }
        if(event.target.label == 'Pin Code'){
            this.loanRecord.Pin_Code__c =  event.target.value;
        }
        if(event.target.label == 'PAN'){
            this.loanRecord.PAN__c =  event.target.value;
        }
        if(event.target.label == 'Martial Status'){
            this.loanRecord.Marital_status__c =  event.target.value;
        }
        if(event.target.label == 'Education'){
            this.loanRecord.Education__c =  event.target.value;
        }
        if(event.target.label == 'Employment Type'){
            this.loanRecord.Employment_Type__c =  event.target.value;
            if(event.target.value == 'Business'){
                this.isBusiness =  true;
                this.isSalaried =  false;
            }
            else if(event.target.value == 'Salaried'){
                this.isBusiness =  false;
                this.isSalaried =  true;
            }else{
                this.isBusiness =  false;
                this.isSalaried =  false;
            }
        }
        if(event.target.label == 'Type of Business'){
            this.loanRecord.Type_of_Business__c =  event.target.value;
        }
        if(event.target.label == 'Company'){
            this.loanRecord.Company__c =  event.target.value;
        }
        if(event.target.label == 'CTC(Yearly)'){
            this.loanRecord.CTC__c =  event.target.value;
        }
        if(event.target.label == 'Loan Type'){
            this.loanRecord.Loan_Type__c =  event.target.value;
            if(event.target.value == 'CD' || event.target.value == 'Car loan' || event.target.value == 'Two-wheeler'){
                this.showProduct = true;
            }else{
                this.showProduct = false;
            }
        }
        if(event.target.label == 'Loan Amount'){
            this.loanRecord.Loan_Amount__c =  event.target.value;
        }
        if(event.target.label == 'Duration(Months)'){
            this.loanRecord.Duration__c =  event.target.value;
        }
        if(event.target.label == 'Product'){
            this.loanRecord.Product__c =  event.target.value;
        }
        if(event.target.label == 'First Name'){
            this.loanRecord.First_Name__c =  event.target.value;
        }
        if(event.target.label == 'Last Name'){
            this.loanRecord.Last_Name__c =  event.target.value;
        }
    }

    validateCallAadhar(){
        
        makeCallToAadar({
            aadharNumber: this.loanRecord.Aadhaar_Number__c
        })
        .then(result => {
            console.log(result);
            if(result.key){
                this.loanRecord.First_Name__c = '';
                this.loanRecord.Last_Name__c = ''; 
                this.loanRecord.Current_Address__c = '';
                this.loanRecord.City__c = '';
                this.loanRecord.District__c =''; 
                this.loanRecord.State__c = '';
                this.loanRecord.Pin_Code__c ='';
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!!',
                    message: 'Aadhar Validation Failed',
                    variant: 'error',
                    mode: 'sticky'
                }))
            }else{
                this.loanRecord.First_Name__c = result.firstName;
                this.loanRecord.Last_Name__c = result.lastName; 
                this.loanRecord.Current_Address__c = result.address;
                this.loanRecord.City__c = result.city;
                this.loanRecord.District__c = result.district; 
                this.loanRecord.State__c = result.state;
                this.loanRecord.Pin_Code__c = result.pincode;
            }
        })
        .catch(error => {

            var errorValue = 'Unknown error';
            if (Array.isArray(error.body)) {
                errorValue = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                errorValue = error.body.message;
            }

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: errorValue,
                variant: 'error'
            }))
        });
    }

    @wire (getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: EDUCATION_FIELD})
    wiredPicklistValuesEd({ error, data }) {
        if (data) {
            this.edpickListvalues = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire (getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: MARTIALSTATUS_FIELD})
    wiredPicklistValuesMS({ error, data }) {
        if (data) {
            this.mspickListvalues = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire (getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: EMPLOYMENTTYPE_FIELD})
    wiredPicklistValuesET({ error, data }) {
        if (data) {
            this.emppickListvalues = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire (getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: LOANTYPE_FIELD})
    wiredPicklistValuesLT({ error, data }) {
        if (data) {
            this.loanpickListvalues = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    insertLoanRecord(){

        const allValid = [...this.template.querySelectorAll('lightning-input , lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        if (allValid) {
           
        } else {
            return;
        }

        saveLoanApplication({
            loan: this.loanRecord
        })
        .then(result => {

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    actionName: 'view'
                }
            });

            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Loan Application is Successfully Created!!',
                variant: 'success'
            }))
        })
        .catch(error => {

            var errorValue = 'Unknown error';
            if (Array.isArray(error.body)) {
                errorValue = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                errorValue = error.body.message;
            }

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: errorValue,
                variant: 'error'
            }))
        });
    }

}