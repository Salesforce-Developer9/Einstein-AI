public  with sharing class SoftDrinkOrderController {
    
   @InvocableMethod(label='Create Soft Drink Order' 
                     description='Create Soft Drink Order when User ask to create Soft Drink Order for example user Might say create a Soft Drink Order for the First Soft Drink Or create a Soft Drink Order for the Soft Drink Xyz')
    public static List<Soft_Drink_Order__c> createSoftDrinkOrder(List<Input> inputWrapper){

        Input inp = inputWrapper[0];

        //create  Soft_Drink_Order__c record fields are Soft_Drink__c, Quantity__c, Price__c
        Soft_Drink_Order__c sdo = new Soft_Drink_Order__c();
        sdo.Soft_Drink__c = inp.softDrinkID;
        sdo.Quantity__c = inp.Quantity;
        sdo.Price__c = inp.price;
        insert sdo;

        return new List<Soft_Drink_Order__c>{sdo};


    }

    public class Input {
        @InvocableVariable(required=true)
        public String softDrinkID;
        @InvocableVariable(required=true)
        public Integer Quantity;
        @InvocableVariable(required=true)
        public Double price;
    }

}