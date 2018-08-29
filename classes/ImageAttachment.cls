public with sharing class ImageAttachment {
	public ImageAttachment(ApexPages.StandardController controller) {
		
	}

	public PageReference runatstart(){
		Quote qut = [select Image_URL__c, Kiosk_Map_rich__c from Quote where id = :ApexPages.CurrentPage().getParameters().get('id')];
		//Quote qut = [select id from Quote where id = :ApexPages.CurrentPage().getParameters().get('id')];
		map<id,QuoteLineItem> qliMap = new map<id,QuoteLineItem>();
		qliMap.putall([select Product2id from QuoteLineItem where QuoteId = :qut.id]);
		map<id,Product2> prodMap = new map<id,Product2>();
		prodMap.putall([select Kiosk__c from Product2 where id in (select Product2id from QuoteLineItem where QuoteId = :qut.id)]);
		set<id> tempIdSet = new set<id>();
		for(Product2 p : prodMap.values()){
			tempIdSet.add(p.Kiosk__c);
		}
		List<Kiosk__c> kList = [select Longitude__c,Latitude__c, Network_Region__c from Kiosk__c where id in :tempIdSet AND Latitude__c != null AND Longitude__c != null Order By Network_Region__c];
		string fullMap = 'https://maps.googleapis.com/maps/api/staticmap?format=gif&maptype=roadmap&size=600x300';
		string urlString = 'https://maps.googleapis.com/maps/api/staticmap?format=gif&maptype=roadmap&size=600x300';
		string currentRegion='';
		string urlRich='';
		for(Kiosk__c k : kList){
			if(currentRegion!=k.Network_Region__c)
			{
				//New Region
				if(currentRegion!='')
				{
					urlRich+='<p><b>Region:</b> ' + currentRegion + '<img src="' + urlString + '" /></p>';
				}
				urlString = 'https://maps.googleapis.com/maps/api/staticmap?format=gif&maptype=roadmap&size=600x300';
				currentRegion=k.Network_Region__c;
			}
			urlString += '&markers=color:red%7C'+k.Latitude__c+','+k.Longitude__c; 
			fullMap += '&markers=color:red%7C'+k.Latitude__c+','+k.Longitude__c; 
		}
		urlRich+='<p><b>Region:</b> ' + currentRegion + '<img src="' + urlString + '" /></p>';
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		fullMap = fullMap.replace(' ', '%20');
		req.setEndpoint(fullMap);
		req.setMethod('GET');
		req.setHeader('Content-Type', 'application/pdf');
		req.setCompressed(true);
		req.setTimeout(60000);
		HttpResponse res = new HttpResponse();
		if(test.isrunningtest()){
			res.setBody('');
		}
		else{
			res = h.send(req);
		}
		string responseValue = '';
		responseValue = res.getBody();
		system.debug(logginglevel.info, '*****res='+res);
		system.debug('Response Body for File: ' + responseValue);
		blob image = res.getBodyAsBlob();
		Attachment n = new Attachment();
		n.ParentId = ApexPages.CurrentPage().getParameters().get('id');
		n.Name = 'Quote Kiosk Map';
		n.Body = image;
		n.contentType = 'pdf';
		//insert n;
		List<Attachment> atList = [select ParentId,name from Attachment where ParentId = :qut.id AND name = 'Quote Kiosk Map']; 
		Try{
			delete atList;
			insert n;
			string s = url.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=' + n.id;
			qut.Image_URL__c = s.replace('visual', 'content');
			qut.Kiosk_Map_rich__c =urlRich;
			update qut;
			Pagereference MyPage = new Pagereference('/'+qut.id);
			MyPage.setRedirect(true);
			return MyPage;
		}
		Catch(exception e){
			system.debug(logginglevel.info, '*****'+e);
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlmessage(0));
			ApexPages.addMessage(myMsg);
			return null;
		}

	}
}