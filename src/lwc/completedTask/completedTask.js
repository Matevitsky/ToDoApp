/**
 * Created by Sergey on 26.10.2020.
 */

import {LightningElement,api} from 'lwc';

export default class CompletedTask extends LightningElement {
    @api task;
    @api recordId;
    @api objectApiName;
  //  arrayFields = ['Name'];

    handleDeleteClick(event) {
        const deleteTaskEvent = new CustomEvent('deletetask', {
            detail: event.target.name
        });
        this.dispatchEvent(deleteTaskEvent);
    }

    handleCompletedTaskClickView(event){
        const completedTask = new CustomEvent('viewcompletedtask', {
            detail: event.target.name
        });
        this.dispatchEvent(completedTask);
    }
}
