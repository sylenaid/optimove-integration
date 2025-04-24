/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-18-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public with sharing class AuthToken {
    public String access_token {get; set;}

    public Long expires_in {get; set;}

    public String token_type {get; set;}
}