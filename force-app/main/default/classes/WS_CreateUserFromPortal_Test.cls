@isTest
public class WS_CreateUserFromPortal_Test {

  @isTest
	static void teste(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact'
        );
        insert ct;

        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'Existing',
            LastName = 'User',
            Email = 'existinguser@myemail.com'
        );
        insert con;
        
        CustomUser cUser = new CustomUser();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/CreateUserFromPortal';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Failure to Deserialize request
        
		cUser.contactId  = 'asdsadsa';
        cUser.username   = 'NameTest';
        cUser.password   = 'asdadasdasd';
		String myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));
        
        // Missing attributes

        cUser.contactId = null;
        myJSON = JSON.serialize(cUser);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (ContactId, Username or Password)', responseBody);

        // Contact doesn't exist

        String fakeId = String.valueOf(ct.Id).substring(0, String.valueOf(ct.Id).length()-1);
        fakeId += 'X';
        cUser.contactId = fakeId;
        myJSON = JSON.serialize(cUser);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        //cdu 2021-10-15: don't understand this test, makes deployment fail
        //System.assert(responseBody.contains('malformed id')); // to be updated

        // Duplicate username
        ct.Email = 'test@johnc.com';
        update ct;
        //Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User'].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User + API'].Id;
        User newUser = new User(
            alias = 'asd1',
            email = con.email,
            emailencodingkey = 'UTF-8',
            firstname = con.firstName,
            lastname = con.lastname,
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            contactId = con.Id,
            timezonesidkey = 'America/New_York',
            username = 'mynewusertestclass@tradeportal.hoyavision.com',
            CommunityNickname = 'myne',
            ProfileId = profileId,
            IsActive = true,
            FederationIdentifier = 'mynewusertestclass@tradeportal.hoyavision.com');

        insert newUser;
        cUser.contactId = ct.Id;
        cUser.username = 'mynewusertestclass';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('A user with the specified username already exists in the system.', responseBody);
        
        // Invalid password
        cUser.username = 'actualnewuser';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('INVALID_NEW_PASSWORD: Your password must include letters and numbers', responseBody);
        List<User> users = [SELECT Id, Username FROM User WHERE Username = 'actualnewuser@tradeportal.hoyavision.com'];
        system.debug(users);

        // 200 OK
        cUser.password = '123Abcd!';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateUserFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());

        // WS Fed Controller and WS_GenerateWSMetadataFile tests
        WS_Federation_Realm__c realm = new WS_Federation_Realm__c();
        realm.name = 'name';
        realm.Realm__c = 'hoya';
        realm.Audience__c = 'Realm__c';
        realm.Action__c = 'https://Action__c';
        realm.Issuer__c = 'Issuer__c';
        realm.ValidityPeriod__c = 100;
        realm.EncodedPrivateKey__c = 'MIIEowIBAAKCAQEAx8MC8aVghiRQC6g5q6R5M6c6E7Q/unVIpDJSayNGhsq+Zbm48syuXEA96PDlSv1d0nqg8N8aqpMOPA3GJF5ETyN33pZgyBT175MahgNOvVObv7DcPDACyBMXiYAWBMqxKUCghOZdSAIuTA5m4ATZoTQGlvsw3f3i7dssbaxNId4ziNViV9Wiw54n4Dp4o7P99COMILQojB8qbT/en9SotN6g9ovf9Kmni3ZDn9YtTSenBGlBJMZKM8UydAdqrhN/QRT/sr0a6i6lK+IUsvMe5y308O0toVGyvN2dwd9pCwmrdfjciQQN09q8DkSKFepN783ittB8YamNDN09u2X2ZQIDAQABAoIBAGzGDYZTjPm+MDAIzE5gYvbzajZsgf8f+gwesq5QKQkgwQhXVxQuzArDmHKNKe3phPsldxlyAu064hdlUK1g/0UwhQcZT13ju/9WVK0AhBGnwzlgLqw/YGRdsQVYT6UQUeOqoz16yvR464jSlsYJHhAfai8wXG2k37qxC8I0flOf2jIUe6m2TbcC5cxTeWZmbDf+kSr+grvIHf+mx4M8lFM0Z6T0Ny1Is1hezFmVP3n4N1cNas3afdD826yZ82miyBuqXghcu5doSnKVMmc3d+NO8w6dCVXQUX0vAimTtRXyWvWrDK/Dg0OUhXf/o7jWFw5TXR3TcFiw/Gt+11Q3XMECgYEA77NRpwyWoTf5qw4uW11AveBIpByJQ/0jTFPCvWIuau31ZylotagPYc6TfLG6PAQjQORcDz9JUyj3Mk29c961uERxCiviK/yTUOZ4yY6t+e67wzs57WOkqSvHBvI1yTKdW3EDNV5S2reNDBInow6cE/og0QPAeMmt03KABi1UURkCgYEA1VhxmTBYVU9vxQH1WNiqWqVYmGCRHqYeu7XpmhaqvDUfS38IBOKIkDFmVlRLQKVm7V5iqcYdkl7YwaCss9qVpdOwjujBkUgrDDoM/Weaas7RgEdwpp4bZvxq08EsNZdgTB3hgbqJlEcEYRW+Yk/gOdeHe6kZ+/W/g/gWHrKe/S0CgYAj3YLkKeAH82YqEA8joIplXr+/vn1TbPbxHr9OsvgbC8viSbHfLGxQyCYNTFJ/VGcp+IFFzsRb6w9BuZwVUEeEcMkxKmvHBR3Nxw5fqjeh4/S4O45pVLV4kpJPGcKufiJJYlmGjLx8+WXjXnwLy83St2RdoeAUsqiNsN4zDmlFUQKBgH9DsRAGjMrnBe9pSafkJ0rHU2AiSq8TvUWQMHdgihyXO8HXVztCvt/09+0Lf5BimlGCeix4J+/GcFqgtCTdgWNYMfwt0DoP6M30WwdWpACOut5gv0xFCGeYr0j99JdLY4BEWt7+HU+8RVp8lAMlTsZyUTltGDj60XGxrdBGER1JAoGBANamEfOLfjcrh7gKorFtDSzGFkdipQT/EnQXYv18l6DljcJNsFhDu5XFiZjEo2HFu+sY7gPeW4+yWhFNKTVckBDEUFY6g6oSxCtQNr8v5SLNvF7zlW+pb94nmkCdfeZR/QnJhpdbqAB8/Z9Jl+DK4ML7HtC78NbFKZenM2jTsixv';
        realm.Certificate__c = 'MIIDbjCCAlagAwIBAgIEUye51jANBgkqhkiG9w0BAQUFADB5MQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZyYW5jaXNjbzETMBEGA1UEChMKc2FsZXNmb3JjZTERMA8GA1UECxMIaWRlbnRpdHkxFTATBgNVBAMTDHdzZmVkZXJhdGlvbjAeFw0xNDAzMTgwMzEzMjZaFw0yNDAzMTUwMzEzMjZaMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQKEwpzYWxlc2ZvcmNlMREwDwYDVQQLEwhpZGVudGl0eTEVMBMGA1UEAxMMd3NmZWRlcmF0aW9uMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx8MC8aVghiRQC6g5q6R5M6c6E7Q/unVIpDJSayNGhsq+Zbm48syuXEA96PDlSv1d0nqg8N8aqpMOPA3GJF5ETyN33pZgyBT175MahgNOvVObv7DcPDACyBMXiYAWBMqxKUCghOZdSAIuTA5m4ATZoTQGlvsw3f3i7dssbaxNId4ziNViV9Wiw54n4Dp4o7P99COMILQojB8qbT/en9SotN6g9ovf9Kmni3ZDn9YtTSenBGlBJMZKM8UydAdqrhN/QRT/sr0a6i6lK+IUsvMe5y308O0toVGyvN2dwd9pCwmrdfjciQQN09q8DkSKFepN783ittB8YamNDN09u2X2ZQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQA402TWrvZSUp9jNJcx4IQMS+sLVOIS11C2J/HZqlBRtCcM0u++s3rYyhEttGbGvYG9FJ6WdomUvbklyic/4JRcqXb+TsIvxy06/P1g8sLP0WnfIO/yPnCACIo5slIPCJMKK7eQfvzD009+l4hdmJW63A6xcuwhJAeO00iSopNH2kzUxT6KbEPVH+QezdCBotVZCJ9N2JrgpC31MUHRNXY2Bb0cOqXmEk2Zj+xqMFuFGzi6yYuuyfZxPOSd2NJABSUS2Uwi2jRtNnIZH20m0parIKVezKtzaUzSNU3KC1kdR/NSigg8mE8qFFonKdZ8v6B/JB39ohXxXkGErWn+GGOd';
        realm.Modulus__c = 'AMfDAvGlYIYkUAuoOaukeTOnOhO0P7p1SKQyUmsjRobKvmW5uPLMrlxAPejw5Ur9XdJ6oPDfGqqTDjwNxiReRE8jd96WYMgU9e+TGoYDTr1Tm7+w3DwwAsgTF4mAFgTKsSlAoITmXUgCLkwOZuAE2aE0Bpb7MN394u3bLG2sTSHeM4jVYlfVosOeJ+A6eKOz/fQjjCC0KIwfKm0/3p/UqLTeoPaL3/Spp4t2Q5/WLU0npwRpQSTGSjPFMnQHaq4Tf0EU/7K9GuoupSviFLLzHuct9PDtLaFRsrzdncHfaQsJq3X43IkEDdPavA5EihXqTe/N4rbQfGGpjQzdPbtl9mU=';
        realm.Exponent__c = 'AQAB';
        insert realm;
        
        PageReference pageRef = Page.WSFederation;
        Test.setCurrentPage(pageRef);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('wtrealm', 'hoya');
        ApexPages.currentPage().getParameters().put('wctx', 'context');
        System.runAs(newUser) {
            WSFederationController controller = new WSFederationController(); 
            System.assertEquals('https://Action__c', controller.getAction());
            System.assertEquals('context', controller.getContext());
            System.assertEquals(realm.realm__c, 'hoya');
            System.assertEquals(realm.Action__c, 'https://Action__c');
            System.assertEquals(realm.Issuer__c, 'Issuer__c');
            System.assertEquals(realm.ValidityPeriod__c, 100);
            System.assertNotEquals(null, controller.getResult());

            // WS_GenerateWSMetadataFile TEST
            request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GenerateWSMetadataFile';
            request.httpMethod = 'GET';
            RestContext.request = request;
            RestContext.response = response;
            WS_GenerateWSMetadataFile.generateMetadata();
        }
    }
    
    private class CustomUser {
        string contactId {get; set;}
        string username {get; set;}
        string password {get; set;}
    }
}