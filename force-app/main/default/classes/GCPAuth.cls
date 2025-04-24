/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-18-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class GCPAuth extends Callout {
    public NamedCredentialsUtil.NamedCredentialData namedCredential {
        get {
            if (namedCredential == null)
                namedCredential = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                    Constants.GCP_API_TOKEN_NAMED_CREDENTIALS_NAME,
                    Constants.PRINCIPAL_NAME_CREDENTIALS,
                    null
                );

            return namedCredential;
        }
        private set;
    }

    public GCPAuth() {
        baseUrl = namedCredential.credentialUrl;
    }

    public AuthToken getToken() {
        String env = Util.getValidCredentialSuffix();
        String extCredentialName =
            Constants.GCP_API_EXTERNAL_CREDENTIAL_NAME + env;
        String requestBody =
            '{ ' +
            '"client_id" : "{!$Credential.' +
            extCredentialName +
            '.client_id}", ' +
            '"client_secret" : "{!$Credential.' +
            extCredentialName +
            '.client_secret}", ' +
            '"audience" : "{!$Credential.' +
            extCredentialName +
            '.audience}",' +
            '"grant_type" : "client_credentials"' +
            '}';
        post('', null, null, requestBody);

        if (!isResponseCodeSuccess())
            throw getError();

        return (AuthToken) JSON.deserialize(resp.getBody(), AuthToken.class);
    }

    Exception getError() {
        return exceptionDetails != null
            ? LogException.newInstance(
                  Constants.LOGGER_GCP_API_CATEGORY,
                  exceptionDetails
              )
            : LogException.newInstance(
                  'Error calling GCP API.',
                  Constants.LOGGER_GCP_API_CATEGORY,
                  req,
                  resp
              );
    }
}
