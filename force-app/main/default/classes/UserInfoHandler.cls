public with sharing class UserInfoHandler {
    
    @InvocableMethod(label='User info Action' 
    description='Return current Logged in user Details. For example when user ask what is my name or Brief me about myself')
public static List<String> getUserDetails(List<String> userName){
    String response = '';
    User currentUser = [SELECT Id, Name,CompanyName,EmployeeNumber,UserRole.Name FROM User 
                        WHERE Id = :UserInfo.getUserId() LIMIT 1];
    
    response = 'Here are the Details about the User:- User Name: '+currentUser.Name + 
               ' Company Name: '+currentUser.CompanyName + ' Employee Number: '+currentUser.EmployeeNumber + 
               ' User Role: '+currentUser.UserRole.Name; 
    
    return new List<String>{response};

}
    
}