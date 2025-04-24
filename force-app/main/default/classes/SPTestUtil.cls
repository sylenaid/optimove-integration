/**
 * @File Name          : SPTestUtil.cls
 * @Description        : 
 * @Author             : acantero
 * @Group              : 
 * @Last Modified By   : acantero
 * @Last Modified On   : 4/24/2021, 7:02:22 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/23/2021, 11:02:51 AM   acantero     Initial Version
**/
@isTest
public without sharing class SPTestUtil {

    public static String loadStaticResource(String name) {
        StaticResource sr = [Select Body From StaticResource Where Name = :name LIMIT 1];
        return sr.Body.toString();
    }

    public static User createUser(String userKey) {
        return createUserWithRole(userKey, null);
    }

    public static User createUserWithRole(String userKey, String roleId) {
        ID profileId = [select Id from Profile where Name = 'System Administrator'][0].Id;
        String lastName = 'mytestuser' + userKey;
        User usrObj = new User(
            LastName = lastName, 
            ProfileId = profileId, 
            Alias = userKey, 
            LanguageLocaleKey = 'en_US', 
            Email = lastName + '@test.com', 
            EmailEncodingKey='UTF-8', 
            isActive = true, 
            LocaleSIDKey='en_US', 
            TimeZoneSidKey = 'America/New_York', 
            Username = lastName + '@test.com'
        );
        if (String.isNotBlank(roleId)) {
            usrObj.UserRoleId = roleId;
        }
        return usrObj;
    }

}