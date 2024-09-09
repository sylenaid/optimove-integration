/**
 * @description       :
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             :
 * @last modified on  : 08-27-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
 **/
public with sharing class OptimoveUpdateAttributeResponse {
    public Boolean isSuccess { get; set; }

    public String requestId { get; set; }

    public List<OptimoveUpdateAttributeError> errors { get; set; }

    public class OptimoveUpdateAttributeError {
        public String error { get; set; }

        public String customerId { get; set; }

        public String realFieldName { get; set; }
    }

    public OptimoveUpdateAttributeResponse() {
        errors = new List<OptimoveUpdateAttributeError>();
    }
}
