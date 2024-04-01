import { LightningElement, track } from 'lwc';
import getFlexTemplateResponse from '@salesforce/apex/FlexTemplateController.getFlexTemplateResponse';

export default class FlexTemplateLwc extends LightningElement {


     ratingValue;
     response;
     accName;
     isLoading = false;

    ratingOptions = [
        { label: 'Best', value: 'Best' },
        { label: 'Average', value: 'Average' },
        { label: 'Low', value: 'Low' }
    ];

    handleRatingChange(event) {
        this.ratingValue = event.detail.value;
        console.log('Rating Value: ' + this.ratingValue);
    }

    handleAccountChange(event) {
        this.accName = event.target.value;
        console.log('Account Id: ' + this.accName);

    }

    handleSubmit(){
        this.isLoading = true;
        console.log('Rating Value: ' + this.ratingValue);
        console.log('Account Id: ' + this.accName);

        getFlexTemplateResponse({ AccName: this.accName ,rating: this.ratingValue})
        .then(result => {
            this.response = result;
            console.log('Response: ' + this.response);
            this.isLoading = false;
        })
        .catch(error => {
            console.log('Error: ' + error);
            this.isLoading = false;
        });



    }

    
}