public class TicketSystem {

    
    
     public static String createTicket(String sub, String email, String description, Integer priorty, Integer status){

        String errorMessage = '';
	    String requestBody  = '{'+
                                '"description": "'+description+'",'+
                                '"subject": "'+sub+'",'+
                                '"email": "'+email+'",'+
                                '"priority": '+priorty+','+
                                '"status": '+status+
                            '}';
        System.debug(' requestBody '+requestBody);
        Http http = new Http();
        httpRequest httpReq = new httpRequest();
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setEndpoint('callout:freshDesk');
        //httpReq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        httpReq.setBody(requestBody);
        HttpResponse response = new HttpResponse();
        
        try{
             response = http.send(httpReq);
            if( response.getStatusCode() == 201 ){
                String responseBody = response.getBody();
              
 //parse the response Body and get the id of the ticket
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);   
                return String.valueOf(result.get('id'));



               
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+response.getBody());
            }
        }catch(System.Exception e){
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add  Endpoint';
            }else{
                errorMessage = 'Unexpected Error while communicating with API. '
                    +'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
            }
            System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed '+errorMessage);
        } 

        return '';
    }
    
}