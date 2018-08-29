@isTest
private class geoTests {

    @isTest static void test_method_one() {
        Kiosk__c k = new Kiosk__c(name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996');
        insert k;
    }

    @isTest static void test_method_two() {
        account a = new account(name='test');
        insert a;
        opportunity o = new opportunity(name='test',stagename='Test Opp',closedate=date.today(),AccountId=a.id);
        insert o;
        Quote q = new Quote(name='test',OpportunityId=o.id);
        insert q;
        Kiosk__c k = new Kiosk__c(Network_Region__c = 'HI',name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996',Geolocation__Latitude__s=37.7655519,Geolocation__Longitude__s=-122.4000855);
        insert k;
        Product2 p = new Product2(name='test',Kiosk__c=k.id);
        insert p;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=p.Id,UnitPrice = 10000,IsActive=true);
        insert standardPrice;
        Asset ast = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today(),UsageEndDate=date.today().addmonths(1),Product2Id=p.id);
        insert ast;
        Asset ast1 = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today().addmonths(1),UsageEndDate=date.today().addmonths(1).addDays(15),Product2Id=p.id);
        insert ast1;
        Asset ast2 = new Asset(AccountId=a.id,Name='test',InstallDate=Date.today().addmonths(-2),UsageEndDate=date.today().addmonths(6),Product2Id=p.id);
        insert ast2;
        Quote q1 = new Quote(name='test',OpportunityId=o.id,Pricebook2Id=pricebookId);
        insert q1;
        QuoteLineItem qli = new QuoteLineItem(PricebookEntryId=standardPrice.id,Quantity=1,QuoteId=q1.id,UnitPrice=10000,Start_Date__c=date.today().addmonths(1),End_Date__c=date.today().addmonths(2));
        insert qli;
        Kiosk__c k1 = new Kiosk__c(Network_Region__c = 'HI',name='test',City__c='Naytahwaush',State__c='GA',Street_Address__c='3150 Bright Shadow Impasse',Zip_Code__c='39996',Geolocation__Latitude__s=37.7655519,Geolocation__Longitude__s=-122.4000855);
        insert k1;
        Product2 p1 = new Product2(name='test',Kiosk__c=k1.id);
        insert p1;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id=pricebookId,Product2Id=p1.Id,UnitPrice = 10000,IsActive=true);
        insert standardPrice1;
        PageReference Page = new PageReference('/apex/MapPage?qid='+q.id);
        test.setcurrentpage(Page);
        MapClass mapC = new MapClass();
        mapC.codeCoverage();
        mapC.choosePriceBook();
        mapC.qut.Pricebook2Id = pricebookId;
        mapC.choosePriceBook();
        mapC.qut.Start_Date_for_Map_Page__c = date.today();
        mapC.qut.End_Date_for_Map_Page__c = date.today().addmonths(2);
        mapC.regnPicked = 'HI';
        mapC.underConstruction = true;
        mapC.alreadyBooked = true;
        mapC.updateSearch();
        list<string> stringList = new list<string>();
        stringList.add(p.id);
        stringList.add(p1.id);
        string st = 'Wed Oct 19 00:00:00 GMT 2016';
        string en = 'Tue Nov 08 00:00:00 GMT 2016';
        //string st = mapC.startDateString;
        //string en = mapC.endDateString;
        MapClass.addProducts(stringList, q.id, st, en);
        mapC.returnToQuote();
    }

    @isTest(seealldata = true) static void test_method_three() {
        Kiosk__c k = [select Zip_Code__c from Kiosk__c where Zip_Code__c != null limit 1];
        string s = k.Zip_Code__c;
        k.Zip_Code__c = '10001';
        update k;
    }

    @isTest static void test_method_four() {
        account a = new account(name='test');
        insert a;
        opportunity o = new opportunity(name='test',stagename='Test Opp',closedate=date.today(),AccountId=a.id);
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
        opportunity o1 = new opportunity(name='test',stagename='Test Opp',closedate=date.today(),AccountId=a.id,ownerid=u.id);
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
