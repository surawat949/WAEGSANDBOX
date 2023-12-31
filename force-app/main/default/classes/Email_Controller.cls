public with sharing class Email_Controller {
    public String serverInstance{
        get{
		    if(this.serverInstance == null){
			    this.serverInstance = URL.getSalesforceBaseUrl().getHost();
		    }
		
		    return this.serverInstance;
        }
        set;
    }
    
    public String getStaticResourceBaseURI () {
        
        if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
        	return 'https://waeg-hoyavisioncare.cs109.force.com/resource/';
		return 'https://hoyavisioncare.force.com/resource/';
        
    }

    // get hoya documents Id
    public List<Document> list_documents{
        get{
		    if(this.list_documents == null){
			    this.list_documents = [SELECT Id,Name,DeveloperName,Folder.Name FROM Document WHERE Folder.Name = 'Image_Email'];
		    }
		    return this.list_documents;
        }
        set;
    }// get seiko documents Id
    public List<Document> list_seiko_documents{
        get{
		    if(this.list_seiko_documents == null){
			    this.list_seiko_documents = [SELECT Id,Name,DeveloperName,Folder.Name FROM Document WHERE Folder.Name = 'SEIKO PRO Emails'];
		    }
		    return this.list_seiko_documents;
        }
        set;
    }
    
    public void testFiller () {
        String a = 'b';
        String b = 'a';
        
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
        a = 'a';
        b = 'b';
        a = 'b';
        b = 'a';
            
            
            
    }
}