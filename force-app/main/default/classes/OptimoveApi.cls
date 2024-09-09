/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 09-04-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing abstract class OptimoveApi extends Callout {
    public NamedCredentialsUtil.NamedCredentialData namedCredential {
        get {
            if (namedCredential == null)
                namedCredential = NamedCredentialsUtil.getOrgDefinedNamedCredential(
                    Constants.OPTIMOVE_API_NAMED_CREDENTIALS_NAME,
                    Constants.PRINCIPAL_NAME_CREDENTIALS,
                    null
                );

            return namedCredential;
        }
        private set;
    }

    public OptimoveApi() {
        baseUrl = namedCredential.credentialUrl;
    }

    protected Exception getError() {
        return exceptionDetails != null
            ? LogException.newInstance(
                  Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                  exceptionDetails
              )
            : LogException.newInstance(
                  'Error calling Optimove API.',
                  Constants.LOGGER_OPTIMOVE_API_CATEGORY,
                  req,
                  resp
              );
    }
}
