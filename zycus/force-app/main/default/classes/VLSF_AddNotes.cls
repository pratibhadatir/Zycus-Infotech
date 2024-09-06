public with sharing class VLSF_AddNotes{
	@AuraEnabled(cacheable = true)
	public static List<VLSF_Custom_Note__c> getCaseNotes(String caseId, String objectType){
		// Integer offset = (pageNumber - 1) * pageSize;
		System.debug('caseId::' + caseId);
		System.debug('objectType::' + objectType);
		
		List<VLSF_Custom_Note__c> notesData = new List<VLSF_Custom_Note__c>();
		if (objectType == 'Case' || objectType == 'case'){
			notesData = [SELECT Id, VLSF_Description__c, VLSF_Case__c, CreatedBy.Name, Owner.Name, CreatedDate, VLSF_Problem__c, VLSF_Title__c FROM VLSF_Custom_Note__c where VLSF_Case__c=:caseId Order By CreatedDate DESC];
		} else if (objectType == 'Problem' || objectType == 'problem') {
			notesData = [SELECT Id, VLSF_Description__c, VLSF_Case__c, CreatedBy.Name, Owner.Name, CreatedDate, VLSF_Problem__c,  VLSF_Title__c FROM VLSF_Custom_Note__c where VLSF_Problem__c=:caseId Order By CreatedDate DESC];
		} else {
			notesData = null;
		}
		return notesData;
	}
	
	@AuraEnabled
	public static string deletenote(Id recordId){
		System.debug('recordId::' + recordId);
		
		try {
			List<VLSF_Custom_Note__c> notesData = [SELECT Id FROM VLSF_Custom_Note__c where Id=:recordId ];
			System.debug('notesData::' + notesData);
			
			delete notesData;
			return 'Record deleted successfully.';
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	@AuraEnabled
	public static string updateNote(Id recordId, String title, String description){
		System.debug('recordId::' + recordId);
		
		try {
			VLSF_Custom_Note__c notesData = [SELECT Id, VLSF_Title__c, VLSF_Description__c FROM VLSF_Custom_Note__c where Id=:recordId LIMIT 1];
			notesData.VLSF_Title__c = title;
			notesData.VLSF_Description__c = description;
			update notesData;
			return 'Record updated successfully.';
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	@AuraEnabled
	public static String createNotes(String subject, String description, Id caseId, String objectType){
		System.debug('recordId: ' + caseId);
		System.debug('subject: ' + subject);
		System.debug('description: ' + description);
		System.debug('objectType: ' + objectType);
		List<ContentVersion> contentList = New List<ContentVersion>();
		// ContentVersion cv = new ContentVersion();
		// cv.Title = String.valueOf(subject); // Set the subject as the title of the ContentVersion
		// // cv.Description = description; // Set the description of the ContentVersion
		// cv.VLSF_Note__c = description;
		// cv.PathOnClient = subject + '.snote'; // Set a default path on client
		// cv.FirstPublishLocationId = caseId; // Set the parent record Id
		// cv.VersionData = Blob.valueOf(description); // Set the data as the description content
		// cv.ContentLocation = 'S'; // S indicates SNOTE type
		String jiraComments = '';
		List<VLSF_Custom_Note__c> customNoteList = new List<VLSF_Custom_Note__c>();
		List<String> existingCommentBodies = new List<String>();
		List<Case> caseList = new List<Case>();
		List<Problem> problemList = new List<Problem>();
		VLSF_Custom_Note__c note = new VLSF_Custom_Note__c();
		if (objectType == 'Case' || objectType == 'case'){
			note.VLSF_Title__c = subject;
			note.VLSF_Description__c = description;
			note.VLSF_Case__c = caseId;
			
			Case caseRecord = [Select Id, CaseNumber, VLSF_Opsgenie_Alert_Id__c, Origin, VLSF_Incident_type__c, VLSF_JIRA_Issue_Identifier__c, VLSF_Jira_Issue_Number__c, VLSF_Last_Update_from_Jira__c, VLSF_Jira_Comments__c
			FROM Case
			WHERE Id = :caseId
			LIMIT 1];
			System.debug('caseRecord: ' + caseRecord);
			System.debug('caseRecord.VLSF_Jira_Comments__c: ' + caseRecord.VLSF_Jira_Comments__c);
			if (caseRecord.VLSF_Jira_Comments__c == null ){
				if (caseRecord.Origin == 'Event' && caseRecord.VLSF_Opsgenie_Alert_Id__c != null){
					makeOpsgenieCallout(caseId, description);
				} else if (caseRecord.VLSF_JIRA_Issue_Identifier__c != null && caseRecord.VLSF_Last_Update_from_Jira__c != null){
					makeCalloutToJira(caseId, description, objectType);
				}
				existingCommentBodies.add(description);
				caseRecord.VLSF_Jira_Comments__c = JSON.serialize(existingCommentBodies);
				System.debug('caseRecord.VLSF_Jira_Comments__c::' + caseRecord.VLSF_Jira_Comments__c);
				caseList.add(caseRecord);
				customNoteList.add(note);
			}
			else if (caseRecord.VLSF_Jira_Comments__c != null || caseRecord.VLSF_Jira_Comments__c != ''){
				jiraComments = (caseRecord.VLSF_Jira_Comments__c);
				existingCommentBodies = (List<String>)JSON.deserialize(jiraComments, List<String>.class);
				System.debug('JiraComments::' + jiraComments);
				System.debug('existingCommentBodies::' + existingCommentBodies);
				if (!existingCommentBodies.contains(description)){
					if (caseRecord.Origin == 'Event' && caseRecord.VLSF_Opsgenie_Alert_Id__c != null){
						makeOpsgenieCallout(caseId, description);
					} else if (caseRecord.VLSF_JIRA_Issue_Identifier__c != null && caseRecord.VLSF_Last_Update_from_Jira__c != null){
						makeCalloutToJira(caseId, description, objectType);
					}
					existingCommentBodies.add(description);
					caseRecord.VLSF_Jira_Comments__c = JSON.serialize(existingCommentBodies);
					System.debug('caseRecord.VLSF_Jira_Comments__c::' + caseRecord.VLSF_Jira_Comments__c);
					caseList.add(caseRecord);
					// contentList.add(cv);
					customNoteList.add(note);
				}
			}
		} else if (objectType == 'Problem' || objectType == 'problem'){
			note.VLSF_Title__c = subject;
			note.VLSF_Description__c = description;
			note.VLSF_Problem__c = caseId;
			Problem prob = [Select Id, VLSF_Jira_Issue_Id__c, VLSF_Jira_Comments__c, VLSF_Last_Update_from_Jira__c, ProblemNumber
			from Problem
			where Id = :caseId];
			System.debug('prov: ' + prob);
			System.debug('prob.VLSF_Jira_Comments__c: ' + prob.VLSF_Jira_Comments__c);
			If (prob.VLSF_Jira_Comments__c == null){
				if (prob.VLSF_Jira_Issue_Id__c != null && prob.VLSF_Last_Update_from_Jira__c != null){
					makeCalloutToJira(caseId, description, objectType);
				}
				existingCommentBodies.add(description);
				prob.VLSF_Jira_Comments__c = JSON.serialize(existingCommentBodies);
				System.debug('prob.VLSF_Jira_Comments__c::' + prob.VLSF_Jira_Comments__c);
				problemList.add(prob);
				// contentList.add(cv);
				customNoteList.add(note);
				
			} else if (prob.VLSF_Jira_Comments__c != null || prob.VLSF_Jira_Comments__c != ''){
				jiraComments = (prob.VLSF_Jira_Comments__c);
				System.debug('JiraComments::' + jiraComments);
				existingCommentBodies = (List<String>)JSON.deserialize(jiraComments, List<String>.class);
				if (!existingCommentBodies.contains(description)){
					System.debug('existingCommentBodies.contains(description)::' + existingCommentBodies.contains(description));
					if (prob.VLSF_Jira_Issue_Id__c != null && prob.VLSF_Last_Update_from_Jira__c != null){
						makeCalloutToJira(caseId, description, objectType);
					}
					existingCommentBodies.add(description);
					prob.VLSF_Jira_Comments__c = JSON.serialize(existingCommentBodies);
					System.debug('prob.VLSF_Jira_Comments__c::' + prob.VLSF_Jira_Comments__c);
					problemList.add(prob);
					// contentList.add(cv);
					customNoteList.add(note);
					
				}
			}
		}
		if (!customNoteList.isEmpty()){
			if (note.VLSF_Title__c != null && note.VLSF_Description__c != null && ( note.VLSF_Problem__c != null || note.VLSF_Case__c !=null )){
				try{
					insert customNoteList;
					if (!caseList.isEmpty()){
						update caseList;
					}
					if (!problemList.isEmpty()){
						update problemList;
					}
					return 'Record was successfully inserted.';
				} catch (DmlException e){
					System.debug('Error: ' + e.getMessage());
					
					String errorMessage = 'Error: ' + e.getMessage();
					for (Integer i = 0; i < e.getNumDml(); i++){
						errorMessage += '\n' + e.getDmlMessage(i);
						System.debug('Error: ' + e.getDmlMessage(i));
					}
					return errorMessage;
				}
			}
		} else{
			return 'You can not add duplicate note.';
		}
		return '';
	}
	
	@future(callout = true)
	public static void makeOpsgenieCallout(Id caseId, String noteContent){
		Case cases = [select Id, VLSF_Opsgenie_Alert_Id__c, Origin, VLSF_Incident_type__c, caseNumber
		from Case
		where Id = :caseId];
		
		try{
			// Construct the callout request
			String apiKey;
			List<VLSF_Opsgenie_Api_Key__mdt> configs = [SELECT Apikey__c
			FROM VLSF_Opsgenie_Api_Key__mdt
			Limit 1];
			if (!configs.isEmpty()){
				apiKey = configs[0].Apikey__c;
			}
			system.debug('Genie Key...' + apiKey);
			HttpRequest request = new HttpRequest();
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json');
			request.setHeader('Authorization', 'GenieKey ' + apiKey);
			
			if (cases != null && cases.Origin == 'Event' && cases.VLSF_Opsgenie_Alert_Id__c != null){
				request.setEndpoint('https://api.opsgenie.com/v2/alerts/' + EncodingUtil.urlEncode(cases.VLSF_Opsgenie_Alert_Id__c, 'UTF-8') + '/notes');
				request.setBody('{"note":"' + noteContent + '"}');
				
				// Send the request
				Http http = new Http();
				HttpResponse response = http.send(request);
				
				// Handle the response
				if (response.getStatusCode() == 202){
					System.debug('Opsgenie CNotes callout successful. Response Body: ' + response.getBody());
					VLSF_ExceptionLog.SuccessLog(response.getBody(), cases.caseNumber); // Assuming caseNumber is not available directly
				} else{
					System.debug('Opsgenie callout Failed with Status Code: ' + response.getStatusCode());
					VLSF_ExceptionLog.ErrorLog(response.getBody(), cases.caseNumber);
				}
			} else{
				System.debug('..Not an Event so No callout for Notes..');
			}
		} catch (Exception e){
			System.debug('Exception occurred while making Opsgenie callout: ' + e.getMessage());
			//Call Exception Class
			VLSF_ExceptionLog.ExceptionLog(e, cases.caseNumber);
		}
	}
	
	@future(callout = true)
	public static void makeCalloutToJira(Id recordId, String noteContent, String objectType){
		if (objectType == 'Case' || objectType == 'case'){
			Case caseRecord = [Select Id, VLSF_JIRA_Issue_Identifier__c, VLSF_Jira_Issue_Number__c, VLSF_Last_Update_from_Jira__c, CaseNumber, VLSF_Jira_Comments__c
			FROM Case
			WHERE Id = :recordId];
			if (caseRecord.VLSF_JIRA_Issue_Identifier__c != null){
				
				try{
					String REQUEST_BODYCOM = '{"body":' + JSON.serialize(noteContent) + ' }';
					HttpRequest requestComment = new HttpRequest();
					Http http = new Http();
					HttpResponse responseComment = new HttpResponse();
					Http httpRootObjCom = new Http();
					//Authentication token is added in Named Credential
					requestComment.setEndpoint('callout:JIRA/rest/api/2/issue/' + caseRecord.VLSF_JIRA_Issue_Identifier__c + '/comment');
					requestComment.setHeader('Content-Type', 'application/json');
					requestComment.setHeader('Accept', 'application/json');
					requestComment.setMethod('POST');
					System.debug(REQUEST_BODYCOM);
					
					requestComment.setBody(REQUEST_BODYCOM);
					requestComment.setTimeout(60000);
					responseComment = http.send(requestComment);
					if (responseComment.getStatusCode() == 201){
						System.debug(noteContent + ' uploaded successfully to Jira.');
						VLSF_ExceptionLog.SuccessLog(noteContent + ' uploaded successfully to Jira.', caseRecord.CaseNumber);
					} else{
						System.debug('Error uploading ' + contentVersion.Title + ' to Jira. Status code: ' + responseComment.getStatusCode());
						VLSF_ExceptionLog.ErrorLog(responseComment.getBody(), caseRecord.CaseNumber);
					}
				} catch (Exception e){
					VLSF_ExceptionLog.ExceptionLog(e, caseRecord.CaseNumber);
				}
			}
		} else if (objectType == 'Problem' || objectType == 'problem'){
			Problem prob = [Select Id, VLSF_Jira_Issue_Id__c, VLSF_Jira_Comments__c, VLSF_Last_Update_from_Jira__c, ProblemNumber
			from Problem
			where Id = :recordId];
			if (prob.VLSF_Jira_Issue_Id__c != null){
				
				try{
					String REQUEST_BODYCOM = '{"body":' + JSON.serialize(noteContent) + ' }';
					HttpRequest requestComment = new HttpRequest();
					Http http = new Http();
					HttpResponse responseComment = new HttpResponse();
					Http httpRootObjCom = new Http();
					//Authentication token is added in Named Credential
					requestComment.setEndpoint('callout:JIRA/rest/api/2/issue/' + prob.VLSF_Jira_Issue_Id__c + '/comment');
					requestComment.setHeader('Content-Type', 'application/json');
					requestComment.setHeader('Accept', 'application/json');
					requestComment.setMethod('POST');
					System.debug(REQUEST_BODYCOM);
					
					requestComment.setBody(REQUEST_BODYCOM);
					requestComment.setTimeout(60000);
					responseComment = http.send(requestComment);
					if (responseComment.getStatusCode() == 201){
						System.debug(noteContent + ' uploaded successfully to Jira.');
						VLSF_ExceptionLog.SuccessLog(noteContent + ' uploaded successfully to Jira.', prob.ProblemNumber);
					} else{
						System.debug('Error uploading ' + contentVersion.Title + ' to Jira. Status code: ' + responseComment.getStatusCode());
						VLSF_ExceptionLog.ErrorLog(responseComment.getBody(), prob.ProblemNumber);
					}
				} catch (Exception e){
					VLSF_ExceptionLog.ExceptionLog(e, prob.ProblemNumber);
				}
			}
		}
	}
	
}