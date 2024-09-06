public class wrapperRecordKey {
    @AuraEnabled public integer numberOfFields{get;set;}
    @AuraEnabled public list<string> keys{get;set;}
    @AuraEnabled public list<boolean> types{get;set;}
    
    public wrapperRecordKey(integer num, list<string> keyList, list<boolean> typeList) {
        //system.debug(keyList) ;
        //system.debug(typeList);
        numberOfFields = num;
        if(num == keyList.size() && num == typeList.size()) {
            system.debug('entering wrapper class');
            keys = keyList;
            types = typeList;
        }
    }
    
    public boolean equals(Object obj) {
        if(obj != null && obj instanceof wrapperRecordKey) {
            wrapperRecordKey otherKey = (wrapperRecordKey) obj;
            if(numberOfFields != otherKey.numberOfFields || types != otherKey.types) {
                return false;
            }
            else {
                for(integer i = 0; i < numberOfFields; i++) {
                    system.debug(i);
                    try{
                        if(types[i] == true && keys[i] != otherKey.keys[i]) {
                            return false;
                        }
                        else if(types[i] == false) {
                            integer length = keys[i].length() > otherKey.keys[i].length() ? keys[i].length() : otherKey.keys[i].length();
                            integer threshold = length - (integer)math.floor(length*0.8);
                            if(keys[i].getLevenshteinDistance(otherKey.keys[i], threshold) == -1) {
                                return false;
                            }
                        }
                    }
                    catch(exception e) {
                        return false;
                    }
                }
            }
            return true;
        }
        return false;
        
    }
}