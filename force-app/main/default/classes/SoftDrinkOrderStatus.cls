public without sharing class SoftDrinkOrderStatus {
    
 @InvocableMethod(label='Order Status' 
                 description='Return Status of the Soft Drink Order , when user ask for it, for example user can say what is the status of My Soft Drink order ABC')
    public static List<String> getStatus(List<Integer> orderNumber){
        
        Soft_Drink_Order__c sd = [Select ID,Status__c from Soft_Drink_Order__c where Order_Number__c=:orderNumber[0] ];
        return new List<String> { sd.Status__c };

    }
}