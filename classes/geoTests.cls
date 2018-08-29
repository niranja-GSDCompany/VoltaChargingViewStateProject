@isTest
private class geoTests {

    @isTest static void test_method_one() {
        Kiosk__c k = new Kiosk__c(name='test',City__c='San Francisco',State__c='CA',Street_Address__c='155 De Haro St',Zip_Code__c='94103');
        k.Geolocation__Latitude__s = 37.768350000;
        k.Geolocation__Longitude__s = -122.401788000;
        insert k;
    }

    @isTest static void test_method_two() {
        
        account a = new account(name='test', ShippingStreet = '155 De Haro', ShippingCity ='San Francisco', ShippingState = 'CA', ShippingPostalCode = '94044');
        insert a;
        RecordType recordTypeRec = [SELECT id FROM RecordType WHERE Name = 'Site' AND sObjectType = 'Opportunity'][0];
        opportunity o = new opportunity(name='test',stagename='Test Opp',closedate= date.today(), AccountId = a.id, RecordTypeId = recordTypeRec.Id);
        insert o;
        Id pricebookId = Test.getStandardPricebookId();
        Quote q = new Quote(name='test',OpportunityId=o.id, Pricebook2Id=pricebookId);
        insert q;
        Kiosk__c k = new Kiosk__c(Network_Region__c = 'HI',name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996',Geolocation__Latitude__s=37.7655519,Geolocation__Longitude__s=-122.4000855, Status__c = 'Under Construction', Latitude__c = 37.7655519, Longitude__c = -122.4000855, Charging_Engineered_for__c = '12');
        insert k;
        Product2 p = new Product2(name='test',Kiosk__c=k.id);
        insert p;
        Product2 p3 = new Product2(name='test p3',Kiosk__c=k.id);
        insert p3;
        
        System.debug('Product p : ' + p.id);
        
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=p.Id,UnitPrice = 10000,IsActive=true);
        insert standardPrice;
        
        Asset ast = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today(),UsageEndDate=date.today().addmonths(1),Product2Id=p.id, kiosk__c = k.id);
        insert ast;
        Asset ast1 = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today().addmonths(1),UsageEndDate=date.today().addmonths(1).addDays(15),Product2Id=p.id, kiosk__c = k.id);
        insert ast1;
        Asset ast2 = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today().addmonths(-2),UsageEndDate=date.today().addmonths(6),Product2Id=p.id, kiosk__c = k.id);
        insert ast2;
        Asset ast3 = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today().addmonths(-2),UsageEndDate=date.today().addmonths(1),Product2Id=p.id, kiosk__c = k.id);
        insert ast3;
        Quote q1 = new Quote(name='test',OpportunityId=o.id,Pricebook2Id=pricebookId);
        insert q1;
        QuoteLineItem qli = new QuoteLineItem(Product2Id = p.id, PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q1.id,UnitPrice=10000,Start_Date__c=date.today().addmonths(1),End_Date__c=date.today().addmonths(2));
        insert qli;
        QuoteLineItem qli4 = new QuoteLineItem(Product2Id = p3.id, PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q1.id,UnitPrice=10000,Start_Date__c=date.today().addmonths(1),End_Date__c=date.today().addmonths(2));
        insert qli4;
        System.debug('Test qli : ' + qli);
        
        Kiosk__c k1 = new Kiosk__c(Network_Region__c = 'HI',name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996',Geolocation__Latitude__s=37.7655519,Geolocation__Longitude__s=-122.4000855, Status__c = 'Active', Latitude__c = 37.7655519, Longitude__c = -122.4000855);
        insert k1;
        Product2 p1 = new Product2(name='test',Kiosk__c=k1.id);
        insert p1;
        
        System.debug('Product p1 : ' + p1.id);
        
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=p1.Id,UnitPrice = 10000,IsActive=true);
        insert standardPrice1;
        
        QuoteLineItem qli2 = new QuoteLineItem(Product2Id = p1.id, PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q1.id,UnitPrice=10000,Start_Date__c=date.today().addmonths(1),End_Date__c=date.today().addmonths(2));
        insert qli2;
        QuoteLineItem qli3 = new QuoteLineItem(Product2Id = p1.id, PricebookEntryId=standardPrice.id,Quantity=3,QuoteId=q1.id,UnitPrice=10000,Start_Date__c=date.today().addmonths(1),End_Date__c=date.today().addmonths(2));
        insert qli3;
        System.debug('Test qli2 : ' + qli2);
        
        Date_Input__c dateInputRef = new Date_Input__c(SetupOwnerId=UserInfo.getProfileId(), Date_Field_1__c = date.today(), Date_Field_2__c = date.today().addmonths(3));
        insert dateInputRef;
        
        PageReference Page = new PageReference('/apex/MapPage?qid='+q.id);
        test.setcurrentpage(Page);
        System.currentPageReference().getParameters().put('id', q.id);
        MapClass mapC = new MapClass();
        //mapC.codeCoverage();
        mapC.choosePriceBook();
        mapC.qut.Pricebook2Id = pricebookId;
        mapC.choosePriceBook();
        mapC.qut.Start_Date_for_Map_Page__c = date.today();
        mapC.qut.End_Date_for_Map_Page__c = date.today().addmonths(2);
        mapC.regnPicked = 'HI';
        mapC.underConstruction = true;
        mapC.alreadyBooked = true;
        
        System.debug('Test : ' + [select id from Kiosk__c where Network_Region__c = :mapC.regnPicked AND Longitude__c != null AND Latitude__c != null AND Status__c != 'Under Construction']);
        
        mapC.updateSearch();
        list<string> stringList = new list<string>();
        stringList.add(p.id);
        stringList.add(p1.id);
        string st = System.now().addDays(-15).formatGMT('EEE MMM dd HH:mm:ss ZZZZ yyyy');
        string en = System.now().addMonths(4).formatGMT('EEE MMM dd HH:mm:ss ZZZZ yyyy');
        
        System.debug('st : ' + st + ',en : ' + en);
        //String st = '2018-08-01 00:00:00';
        //String en = '2018-12-30 00:00:00';
        //string st = mapC.startDateString;
        //string en = mapC.endDateString;
        System.debug('AssetList from test class : ' + [select Start_Date_Text__c,End_Date_Text__c,AccountId,Product2Id,UsageEndDate,InstallDate from Asset]);
        MapClass.addProducts(stringList, q.id, st, en);
        mapC.returnToQuote();
        mapC.qliToRemove = qli2.id;
        mapC.getExistingFaces();
        mapC.removeFromQuote();
    }

    @isTest(seealldata = true) static void test_method_three() {
        Kiosk__c k = [select Zip_Code__c from Kiosk__c where Zip_Code__c != null limit 1];
        string s = k.Zip_Code__c;
        k.Zip_Code__c = '10001';
        update k;
        
        account a = new account(name='test', ShippingStreet = '155 De Haro', ShippingCity ='San Francisco', ShippingState = 'CA', ShippingPostalCode = '94044');
        insert a;
        RecordType recordTypeRec = [SELECT id FROM RecordType WHERE Name = 'Site' AND sObjectType = 'Opportunity'][0];
        opportunity o = new opportunity(name='test',stagename='Test Opp',closedate= date.today(), AccountId = a.id, RecordTypeId = recordTypeRec.Id);
        insert o;
        
        Quote q = new Quote(name='test',OpportunityId=o.id);
        insert q;
        
        PageReference Page = new PageReference('/apex/MapPage?qid='+q.id);
        test.setcurrentpage(Page);
        System.currentPageReference().getParameters().put('id', q.id);
        MapClass mapC = new MapClass();
        mapC.choosePriceBook();
        
        
    }

    @isTest static void test_method_four() {
        account a = new account(name='test', ShippingStreet = '155 De Haro', ShippingCity ='San Francisco', ShippingState = 'CA', ShippingPostalCode = '94044');
        insert a;
        RecordType recordTypeRec = [SELECT id FROM RecordType WHERE Name = 'Site' AND sObjectType = 'Opportunity'][0];
        opportunity o = new opportunity(name='test',stagename='Test Opp',closedate= date.today(), AccountId = a.id, RecordTypeId = recordTypeRec.Id);
        insert o;
        Kiosk__c k = new Kiosk__c(Network_Region__c = 'HI',name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996',Geolocation__Latitude__s=37.7655519,Geolocation__Longitude__s=-122.4000855);
        insert k;
        Product2 p = new Product2(name='test',Kiosk__c=k.id);
        insert p;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=p.Id,UnitPrice = 10000,IsActive=true);
        insert standardPrice;
        Quote q = new Quote(name='test',OpportunityId=o.id,Pricebook2Id=pricebookId);
        insert q;
        QuoteLineItem qli = new QuoteLineItem(PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q.id,UnitPrice=10000);
        insert qli;
        qli.Quantity = 2;
        update qli;
        Profile pr = [select id from profile where name='Standard User'];
        User u = new User(firstname='test',lastname='test',email='thisisatestemail@asdfasdfasdfnigknekncih.com',username='thisisatestemail@asdfasdfasdfnigknekncih.com',alias='asdfasdf',TimeZoneSidKey='GMT',LocaleSidKey='en_US',emailencodingkey='UTF-8',languagelocalekey='en_US',ProfileId = pr.Id);
        insert u;
        opportunity o1 = new opportunity(name='test',stagename='Test Opp',closedate=date.today(),AccountId=a.id,ownerid=u.id, RecordTypeId = recordTypeRec.Id);
        insert o1;
        Quote q1 = new Quote(name='test',OpportunityId=o1.id,Pricebook2Id=pricebookId);
        insert q1;
        QuoteLineItem qli1 = new QuoteLineItem(PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q1.id,UnitPrice=10000);
        insert qli1;


        PageReference Page = new PageReference('/apex/ImageAttachment?id='+q.id);
        test.setcurrentpage(Page);
        ImageAttachment ia = new ImageAttachment(null);
        ia.runatstart();

    }

}