public class CaseCopilot {



    @InvocableMethod(label='Create Case record' 
                     description='Create Case record in System when user ask to create a Ticket for example user Might say create a ticket with priority high and subject as test Or Create a Case with Prority Low and Subject as XYZ and Description as XYZ')
    public static List<output> createCase(List<Input> inputWrapper){

        Input inp = inputWrapper[0];
        User currentUser = [SELECT Id,Email FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        String externalCaseId = TicketSystem.createTicket(inp.Subject, currentUser.email , inp.Description, 1,2);
        
       Case c = new Case();
        c.Subject = inp.Subject;
        c.Priority = inp.Priority;
        c.Description = inp.Description;
        c.AccountId = inp.AccountId;
        c.freshDeskId__c = externalCaseId; 
        insert c;
        Output out = new Output();
        out.caseRec = c;
        
        return new List<Output>{out};


    }

    public class Input {
        @InvocableVariable(required=true description='Subject Given by User')
        public String Subject;
        @InvocableVariable(required=true description='Priority given by user if no Priority is given then the default value is Low')
        public String Priority;
        @InvocableVariable(required=true description='Description given by user if No Description is given use Subject as Description')
        public String Description;
        @InvocableVariable(required=true description='get the Account Id from the Account Name given by user before creating the Case')
        public String AccountId;

   }
    
    Public class Output{
       @InvocableVariable(required=true description='Case Record Created in CRM to be displayed on the UI')
        public Case caseRec; 
    }
}