/**
 * Created by Sergey on 27.10.2020.
 */

import {LightningElement, track, wire, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import createTodoTask from "@salesforce/apex/ToDoTaskController.createToDoTask";
import TODO_TASK_OBJECT from '@salesforce/schema/TodoTask__c';
import {getObjectInfo, getPicklistValues} from "lightning/uiObjectInfoApi";


export default class InputTask extends LightningElement {


    @api objectName = 'TodoTask__c';
    @api fieldName = 'Category__c';
    @track fieldLabel;
    @api recordTypeId;

    @track options;
    apiFieldName;


    @track todoTask = TODO_TASK_OBJECT;


    @wire(getObjectInfo, {objectApiName: TODO_TASK_OBJECT})
    getObjectData({error, data}) {
        if (data) {
            if (this.recordTypeId == null)
                this.recordTypeId = data.defaultRecordTypeId;
            this.apiFieldName = this.objectName + '.' + this.fieldName;
            this.fieldLabel = data.fields[this.fieldName].label;

        } else if (error) {
            // Handle error
            console.log('==============Error  ');
            console.log(error);
        }
    }

    @wire(getPicklistValues, {recordTypeId: '$recordTypeId', fieldApiName: '$apiFieldName'})
    getPicklistValues({error, data}) {
        if (data) {
            // Map picklist values
            this.options = data.values.map(plValue => {
                return {
                    label: plValue.label,
                    value: plValue.value
                };
            });

        } else if (error) {
            // Handle error
            console.log('==============Error  ' + error);
            console.log(error);
        }
    }


    refreshTodoList() {
        this.template.querySelector("c-todo-task-view").refreshTodoList();
    }


    handleSubjectChange(event) {
        this.todoTask.Name = event.target.value;
    }

    handleCategoryChange(event) {
        this.todoTask.Category__c = event.detail.value;
    }


    handleSave() {

        if (this.validateFields()) {
            createTodoTask({todoTask: this.todoTask}).then(() => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Todo task created',
                        variant: 'success'
                    })
                );
                this.template.querySelector("c-todo-task-view").refreshTodoList();
            }).catch((err) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating todo task',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
                console.log("Error" + JSON.stringify(err));
            });
        }
    }

    validateFields() {
        return [...this.template.querySelectorAll('lightning-input , lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
    }

    refreshCompletedList(event) {
        console.log(' event recived input');
        this.dispatchEvent(new CustomEvent('refreshcompletedlist'));
    }
}
