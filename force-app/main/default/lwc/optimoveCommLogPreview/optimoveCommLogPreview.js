/**
 * @description       : 
 * @author            : SkyPlanner - Dianelys Velazquez
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : SkyPlanner - Dianelys Velazquez
**/
import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class OptimoveCommLogPreview extends LightningModal {
    @api subject;
    @api body;

    handleClose() {
        this.close("okay");
    }
}