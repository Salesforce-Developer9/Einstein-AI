public class CaseUpdates {

    @InvocableMethod(
        label='Get Queue ID and Assign Case'
        description='Returns the ID of a Queue/Group when given its developer name is given and assigns a Case to that queue'
    )
    public static List<OutputWrapper> getQueueIdAndAssignCase(List<InputWrapper> requests) {
        if (requests == null || requests.isEmpty()) {
            return new List<OutputWrapper>();
        }
        
        List<OutputWrapper> results = new List<OutputWrapper>();
        
        try {
            // Process each request
            for (InputWrapper req : requests) {
                OutputWrapper output = new OutputWrapper();
                
                // Query the queue directly
                if (String.isNotBlank(req.queueDeveloperName)) {
                    List<Group> queues = [
                        SELECT Id, DeveloperName 
                        FROM Group 
                        WHERE DeveloperName = :req.queueDeveloperName 
                        AND Type = 'Queue'
                        LIMIT 1
                    ];
                    
                    // If queue found, use it directly (taking index 0)
                    if (!queues.isEmpty()) {
                        output.queueId = queues[0].Id;
                        output.message = 'Queue found: ' + req.queueDeveloperName;
                        output.success = true;
                        
                        // Process Case assignment if caseId provided
                        if (String.isNotBlank(req.caseId)) {
                            try {
                                Id caseIdValue = Id.valueOf(req.caseId);
                                // Update case directly
                                update new Case(
                                    Id = caseIdValue,
                                    OwnerId = output.queueId
                                );
                                output.message = 'Success: Case assigned to queue ' + req.queueDeveloperName;
                            } catch (Exception e) {
                                output.message = 'Queue found but error updating Case: ' + e.getMessage();
                                output.success = false;
                            }
                        }
                    } else {
                        output.message = 'Error: Queue with developer name "' + req.queueDeveloperName + '" not found';
                        output.success = false;
                    }
                } else {
                    output.message = 'No queue developer name provided';
                    output.success = false;
                }
                
                results.add(output);
            }
        } catch (Exception e) {
            // Handle general exceptions
            OutputWrapper errorOutput = new OutputWrapper();
            errorOutput.success = false;
            errorOutput.message = 'Error processing request: ' + e.getMessage();
            results.add(errorOutput);
        }
        
        return results;
    }
    
    /**
     * @description Input wrapper class for the invocable method
     */
    public class InputWrapper {
        @InvocableVariable(label='Queue Developer Name' description='The developer name of the queue' required=true)
        public String queueDeveloperName;
        
        @InvocableVariable(label='Case ID' description='The ID of the Case to assign to the queue' required=true)
        public String caseId;
    }
    
    /**
     * @description Output wrapper class for the invocable method
     */
    public class OutputWrapper {
        @InvocableVariable(label='Queue ID' description='The ID of the found queue')
        public Id queueId;
        
        @InvocableVariable(label='Success' description='Whether the operation was successful')
        public Boolean success = false;
        
        @InvocableVariable(label='Message' description='Success or error message')
        public String message;
    }
}