/**
 * Created by MKA on 20.10.2020.
 */

import {api, LightningElement} from 'lwc';
import {refreshApex} from "@salesforce/apex";

export default class EditForm extends LightningElement {
    @api edit = false;

    processing = true;

    @api
    openEditWindow(parentTaskId) {
        this.edit = true;
        this.parentTaskId = parentTaskId;

    }

    closeEditForm() {
        this.edit = false;
        this.processing = true;
        refreshApex(this.todoTasksResponse)
            .finally(() => this.processing = false);
    }
}