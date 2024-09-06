public class VLSF_ExceptionLog {
    
    public static void ExceptionLog(Exception e){
        
        ExceptionLog(e, ''); 
        
    }
    
    public static void ExceptionLog(Exception e, String relatedTold){
        
        VLSF_Exception_Log__c ex;
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        String className = stackTrace.substringAfter('.').substringBefore('.'); 
        String methodName = stackTrace.substringBefore(':').substringafter(className).substringafter('.');
        
        //Governer Limit of executingQuery
        
        String QueryLimit = 'SOQL Queries (used/allowed): '+ Limits.getQueries() +'/'+ Limits.getLimitQueries(); 
        //of records (queried /allowed): Limits.getDelRows() Limits.getiimitDalRows();
        String DMLimit = 'Number of records (queried /allowed:) '+ Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();            
        String DMLStats = 'Number of DML statements (used/allowed): '+ Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
        String CPUT = 'Amount of CPU time (in ms) (used/allowed:) ' + Limits.getcputime() + '/' + Limits.getLimitCpuTime();
        
        //Log information in object
        
        ex = new VLSF_Exception_Log__c();
        ex.VLSF_Record_Id__c = relatedTold;
        ex.VLSF_Class_Flow_Name__c = className;
        ex.VLSF_Exception_Method__c = methodName;
        ex.VLSF_Governor_Limit__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{QueryLimit, DMLimit, DMLStats, CPUT});
        ex.VLSF_Exception_Message__c = e.getMessage();
        ex.VLSF_Exception_Type__c = e.getTypeName();
        ex.VLSF_Exception_Line__c = e.getLineNumber();
        ex.VLSF_Stack_Trace__c = e.getStackTraceString();
        database.insert(ex);
                        System.debug('Inserted Exception Log: ' + ex);

        
    }
    
    public static void ExceptionLog(Exception e, String relatedTold, String source){
        
        VLSF_Exception_Log__c ex;
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        String className = stackTrace.substringAfter('.').substringBefore('.'); 
        String methodName = stackTrace.substringBefore(':').substringafter(className).substringafter('.');
        
        //Governer Limit of executingQuery
        
        String QueryLimit = 'SOQL Queries (used/allowed): '+ Limits.getQueries() +'/'+ Limits.getLimitQueries(); 
        //of records (queried /allowed): Limits.getDelRows() Limits.getiimitDalRows();
        String DMLimit = 'Number of records (queried /allowed:) '+ Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();            
        String DMLStats = 'Number of DML statements (used/allowed): '+ Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
        String CPUT = 'Amount of CPU time (in ms) (used/allowed:) ' + Limits.getcputime() + '/' + Limits.getLimitCpuTime();
        
        //Log information in object
        
        ex = new VLSF_Exception_Log__c();
        ex.VLSF_Record_Id__c = relatedTold;
        ex.VLSF_Class_Flow_Name__c = className;
        ex.VLSF_Exception_Method__c = methodName;
        ex.VLSF_Governor_Limit__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{QueryLimit, DMLimit, DMLStats, CPUT});
        ex.VLSF_Exception_Message__c = e.getMessage();
        ex.VLSF_Exception_Type__c = e.getTypeName();
        ex.VLSF_Exception_Line__c = e.getLineNumber();
        ex.VLSF_Stack_Trace__c = e.getStackTraceString();
        ex.VLSF_Source_of_Error__c = source;
        database.insert(ex);
                System.debug('Inserted Exception Log: ' + ex);        
    }
    
    public static void SuccessLog(String responseBody, String recordDetails){ 
        
        VLSF_Exception_Log__c ex;
        
        ex = new VLSF_Exception_Log__c();
        ex.VLSF_Record_Number__c = recordDetails;
        ex.VLSF_Success_Body__c = responseBody;
        database.insert(ex);
        System.debug('Inserted Success Log: ' + ex);        
    }
    public static void ErrorLog(String responseBody, String recordDetails){ 
        
        VLSF_Exception_Log__c ex = new VLSF_Exception_Log__c();
        ex.VLSF_Record_Number__c = recordDetails;
        ex.VLSF_Source_of_Error__c = responseBody;
        database.insert(ex);
        System.debug('Inserted Error Log: ' + ex);        
    } 
    public static void ErrorLogMigration(String responseBody, String recordDetails, Integer recordCount, String className){ 
        
        VLSF_Exception_Log__c ex = new VLSF_Exception_Log__c();
        ex.VLSF_Record_Id__c= recordDetails;
        ex.VLSF_Class_Flow_Name__c = className;
        ex.VLSF_Record_Number__c = String.valueOf(recordCount);
        ex.VLSF_Exception_Message__c = responseBody;
        database.insert(ex);
        System.debug('Inserted Error Log: ' + ex);        
    }   
}