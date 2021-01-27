/**
 * Created by Sergey on 27.10.2020.
 */

import {api, LightningElement} from 'lwc';



export default class ToDoTaskItem extends LightningElement {

    @api task;
    fields = ['Name'];
    @api objectApiName = 'TodoTask__c';


    clickButtonComplete(event){
        const deleteTaskEvent = new CustomEvent('completetask', {
            detail: event.target.name
        });

        this.dispatchEvent(deleteTaskEvent);

    }

    clickButtonView(event){
        const deleteTaskEvent = new CustomEvent('viewtask', {
            detail: event.target.name

        });
        this.dispatchEvent(deleteTaskEvent);
    }

    clickButtonDelete(event){
        const deleteTaskEvent = new CustomEvent('deletetask', {
            detail: event.target.name
        });
        this.dispatchEvent(deleteTaskEvent);
    }
}
