public with sharing class FlexTemplateController {


@AuraEnabled
public static String getFlexTemplateResponse(String AccName , String rating){

    // get Account record 
    Account acc = [SELECT Id, Name, Rating FROM Account WHERE Name like :AccName LIMIT 1];

    // get Product2 where rating__C = rating
    LIST<Product2> products = [SELECT Id, Name, Rating__c FROM Product2 WHERE Rating__c = :rating LIMIT 2];

// get Soft_Drink__C where rating__C = rating
    LIST<Soft_Drink__c> softDrinks = [SELECT Id, Name, Rating__c FROM Soft_Drink__c WHERE Rating__c = :rating LIMIT 2];

    

             

        Map<String, String> account = new Map<String, String>();
        account.put('id', acc.Id); 

        Map<String, String> Product1Map = new Map<String, String>();
        Product1Map.put('id', products[0].Id); 

        Map<String, String> Product2Map = new Map<String, String>();
        Product2Map.put('id',  products[1].Id); 


        Map<String, String> softDrink1Map = new Map<String, String>();
        softDrink1Map.put('id', softDrinks[0].Id); 

        Map<String, String> softDrink2Map = new Map<String, String>();
        softDrink2Map.put('id',  softDrinks[1].Id);  


        // Build input map
           Map<String,ConnectApi.WrappedValue> valueMap = new Map<String,ConnectApi.WrappedValue>();
        // Add wrapped values to map


        ConnectApi.WrappedValue accountWrappedValue = new ConnectApi.WrappedValue();
        accountWrappedValue.value = account;

        ConnectApi.WrappedValue Product1Wrapped = new ConnectApi.WrappedValue();
        Product1Wrapped.value = Product1Map;

        ConnectApi.WrappedValue Product2Wrapped = new ConnectApi.WrappedValue();
        Product2Wrapped.value = Product2Map;

        ConnectApi.WrappedValue SoftDrink1Wrapped = new ConnectApi.WrappedValue();
        SoftDrink1Wrapped.value = softDrink1Map;

        ConnectApi.WrappedValue softDrink2Wrapped = new ConnectApi.WrappedValue();
        softDrink2Wrapped.value = softDrink2Map;




        valueMap.put('Input:Account', accountWrappedValue);
        valueMap.put('Input:Product', Product1Wrapped);
        valueMap.put('Input:Product_2', Product2Wrapped);
        valueMap.put('Input:Soft_Drink', SoftDrink1Wrapped);
        valueMap.put('Input:Soft_Drink2', softDrink2Wrapped);

        // Configure invocation parameters
ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
executeTemplateInput.isPreview = false;
executeTemplateInput.inputParams = valueMap;

try {
    // Call the service

    // Call the service
ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = 
ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('Customer_Pitch', executeTemplateInput); 

// Consume response
System.debug('Prompt Testing: ' + generationsOutput.generations[0].text);

 return generationsOutput.generations[0].text;

} catch (Exception e) {
    System.debug(e.getMessage());
    throw e;
}
        


}
}