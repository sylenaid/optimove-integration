/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-17-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
public abstract with sharing class DeleteRecordBatch extends GenericBatch {
    public override void execute(List<SObject> scope) {
        Database.delete(scope);
    }
}
