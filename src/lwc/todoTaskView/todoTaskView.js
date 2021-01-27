/**
 * Created by MKA on 17.10.2020.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getTodoTask from '@salesforce/apex/TodoTaskViewController.getTodoTask';
import {refreshApex} from '@salesforce/apex';
import deleteTodoTask from '@salesforce/apex/TodoTaskViewController.deleteTodoTask';
import {getObjectInfo} from "lightning/uiObjectInfoApi";
import {getPicklistValues} from "lightning/uiObjectInfoApi";
import TODO_TASK_OBJECT from '@salesforce/schema/TodoTask__c';
import completeTask from '@salesforce/apex/TodoTaskViewController.completeTask';

export default class Todo extends LightningElement {

    @api objectName = 'TodoTask__c';
    @api fieldName = 'Category__c';
    @track fieldLabel;
    @api category = '';
    @api value;
    @track options;
    apiFieldName;


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
            this.options.push({
                label: 'All',
                value: ''
            });
        } else if (error) {
            // Handle error
            console.log('==============Error  ' + error);
            console.log(error);
        }
    }


    handleChange(event) {
        this.category = event.detail.value;
    }

    @track
    todoTasks = [];

    todoTasksResponse;
    processing = true;

    handleDeleteTask(event) {

        const taskToDeleteId = event.detail;

        deleteTodoTask({recordId: taskToDeleteId})
            .then(result => {
                if (result) {
                    this.refreshTodoList();
                    todoTasks.splice(todoTaskIndex, 1);

                } else {
                }
            })
            .catch(error => console.log(error))
            .finally(() => this.processing = false);

    }

    @wire(getTodoTask, {category: '$category'})
    getTodoTasks(response) {
        this.todoTasksResponse = response;
        let data = response.data;
        let error = response.error;

        if (data || error) {
            this.processing = false;
        }

        if (data) {
            console.log(data);
            this.todoTasks = [];
            data.forEach(todoTask__c => {
                this.todoTasks.push({
                    id: this.todoTasks.length + 1,
                    name: todoTask__c.Name,
                    recordId: todoTask__c.Id,
                    status: todoTask__c.Status__c,
                    subtasks: todoTask__c.Subtasks__r
                });
            });
        } else if (error) {
            console.log('error');
            console.log(error);
        }

    }

    @api
    refreshTodoList() {
        this.processing = true;
        refreshApex(this.todoTasksResponse)
            .finally(() => this.processing = false);
    }

    handleClickView(event) {
        let taskId = event.detail;
        this.template.querySelector("c-subtask").openSubtaskWindow(taskId);
    }

    @api taskId;


    handleCompleteTask(event) {
        this.taskId = event.detail

        completeTask(event)
        {

            completeTask({taskId: this.taskId}).then(() => {
                this.refreshTodoList();
                console.log(' event started');
                this.dispatchEvent(new CustomEvent('refreshcompletedlist'));

            })
                .catch(error => {
                    console.log('Refresh Apex called' + error);
                });

        }
    }
}
