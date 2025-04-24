/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-18-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing abstract class GCPApi extends Callout {
    GCPAuth auth;
    protected Map<String, String> headers;

    public NamedCredentialsUtil.NamedCredentialData namedCredential {
        get {
            if (namedCredential == null)
                namedCredential = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                    Constants.GCP_API_NAMED_CREDENTIALS_NAME,
                    Constants.PRINCIPAL_NAME_CREDENTIALS,
                    null
                );

            return namedCredential;
        }
        private set;
    }

    public GCPApi() {
        GCPAuth auth = new GCPAuth();
        AuthToken token = auth.getToken();
        baseUrl = namedCredential.credentialUrl;
        headers = new Map<String, String>();

        headers.put(
            'Authorization',
            token.token_type + ' ' + token.access_token
        );
    }

    protected Exception getError() {
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
