/*  This class will serve as a flag for preventing recursive trigger */

public class TriggerFlag {
    static Boolean updateFlag = true ;
    public static void setUpdateFlag(){
        updateFlag = false ;  
    }
    
    public static Boolean getUpdateFlag(){
        
        return updateFlag ;
    }
    

}