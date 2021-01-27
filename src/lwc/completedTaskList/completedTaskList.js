/**
 * Created by Sergey on 26.10.2020.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getTodoTask from '@salesforce/apex/TodoTaskViewController.getTodoTask';
import {refreshApex} from '@salesforce/apex';
import deleteTodoTask from '@salesforce/apex/TodoTaskViewController.deleteTodoTask';
import {getObjectInfo} from "lightning/uiObjectInfoApi";
import {getPicklistValues} from "lightning/uiObjectInfoApi";
import TODO_TASK_OBJECT from '@salesforce/schema/TodoTask__c';
import {createMessageContext, subscribe, unsubscribe} from 'lightning/messageService';
import LMC from '@salesforce/messageChannel/MyMessageChannel__c';



export default class CompletedTaskList extends LightningElement {

    @api objectName = 'TodoTask__c';
    @api fieldName = 'Category__c';
    @track fieldLabel;
    @api category = '';
    @api value;
    @track options;
    apiFieldName;

    @track
    todoTasks = [];
    @track
    todoTasksResponse;
    processing = true;


    @api
    refreshCompletedTodoList() {
        this.processing = true;
        console.log('thjis todo RESPONSE' +this.todoTasksResponse);
        refreshApex(this.todoTasksResponse)
            .finally(() => this.processing = false);
    }


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
            this.options = data.values.map(plValue => {
                return {
                    label: plValue.label,
                    value: plValue.value
                };
            });

            this.options.push({
                label: 'All',
                value: ''
            });

        } else if (error) {

            console.log('==============Error  ' + error);
            console.log(error);
        }
    }


    handleCompletedCategoryChange(event) {
        this.category = event.detail.value;
    }


    @wire(getTodoTask, {category: '$category', isCompleted: true})
    getTodoTasks(response) {

        this.todoTasksResponse = response;
        let data = response.data;
        let error = response.error;

        if (data || error) {
            this.processing = false;
        }

        if (data) {
            this.todoTasks = [];
            data.forEach(todoTask__c => {
                this.todoTasks.push({
                    id: this.todoTasks.length + 1,
                    name: todoTask__c.Name,
                    recordId: todoTask__c.Id,
                    status: todoTask__c.Category__c,
                    subtasks: todoTask__c.Subtasks__r
                });
            });

        } else if (error) {
            console.log('error');
            console.log(error);
        }

    }


    handleCompletedClickView(event) {
        let taskId = event.detail;
        this.template.querySelector("c-subtask").openSubtaskWindow(taskId);
    }

    handleDeleteNotification(event) {
        const taskToDeleteId = event.detail;

        deleteTodoTask({recordId: taskToDeleteId})
            .then(result => {
                if (result) {
                    this.refreshCompletedTodoList();
                    todoTasks.splice(todoTaskIndex, 1);
                }
            })
            .catch(error => console.log(error))
            .finally(() => this.processing = false);
    }


}


