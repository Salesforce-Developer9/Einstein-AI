public class ZipCodeName {

    
    @InvocableMethod(callout=true  
                     description='This Action Find the Name of the City based on the Zipcode given to it, for example when the user ask find the name of the City whose zip code is 90210 then it returns the city name')
    public static List<String> getCityForZipCode(List<Integer> zipCode){
        Integer zipCodeToFind = zipCode[0];
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.zipcodestack.com/v1/search?codes=' + zipCodeToFind +'&country=us' );
        req.setMethod('GET');
        req.setHeader('apikey', 'YOUR_API_KEY');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> resultMap = (Map<String, Object>)responseMap.get('results');
        List<Object> zipData = (List<Object>) resultMap.get(String.valueOf(zipCodeToFind));
        Map<String, Object> finalZipResult = (Map<String, Object>)zipData[0];
        
        String cityName = (String)finalZipResult.get('city');
        return new List<String> { cityName };
    }
}
