public class AccountSummaryPrompt {
    //CapabilityType='PromptTemplateType://einstein_gpt__fieldCompletion'
    @InvocableMethod(label='Soft Drink Orders'
                     description='Find Soft Drink for Account'
                     CapabilityType='PromptTemplateType://einstein_gpt__recordSummary')
    public static List<Response> getSoftDrinkData(List<Request> requests) {
        // Validate the expected number of requests as an input
        if (requests.size() != 1)
            throw new ListException('The requests list must contain one entry only');
        Account acc = requests[0].objectToSummarize;
        
        List<Soft_Drink_Order__c> SoftDrinkOrders =
            [SELECT Id,Soft_Drink__r.Name ,Quantity__c from Soft_Drink_Order__c 
             WHERE Account__c = :acc.Id ];
        string responseData = null;
        if(SoftDrinkOrders.isEmpty()) {
            responseData = 'There are no Soft Drink records.';
        } else {
            for(Soft_Drink_Order__c drink : SoftDrinkOrders) {  
                responseData =
                    (responseData != null) ? responseData + '\n' : '';           
                responseData += String.format('Soft Drink Details: {0}, {1}.',
                                              new List<Object>{drink.Soft_Drink__r.Name, drink.Quantity__c});
            }
        }
        
        List<Case> Cases =
            [SELECT Id , Reason , Subject ,Description from Case 
             WHERE AccountId = :acc.Id ];
        
        if(Cases.isEmpty()) {
            responseData += 'There are no Cases Records.';
        } else {
            for(Case ca : Cases) {  
                responseData =
                    (responseData != null) ? responseData + '\n' : '';           
                responseData += String.format('Case Details:- Subject , Reason , Description of the Case are as below: {0}, {1}, {2}.',
                                              new List<Object>{ca.Subject, ca.Reason , ca.Description});
            }
        }
        
        
        List<Response> responses = new List<Response>();
        Response res = new Response();
        res.Prompt = responseData;
        responses.add(res);
        return responses;
    }
    
    public class Request {
        @InvocableVariable(required=true)
        public Account objectToSummarize;
    }
    
    public class Response {
        @InvocableVariable
        public String Prompt;
    }
    
}