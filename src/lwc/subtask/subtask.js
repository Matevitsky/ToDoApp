/**
 * Created by MKA on 19.10.2020.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getSubtasks from '@salesforce/apex/SubtaskController.getSubtasks';
import {refreshApex} from '@salesforce/apex';
import insertSubtask from '@salesforce/apex/SubtaskController.insertSubtask';
import deleteSubtask from '@salesforce/apex/SubtaskController.deleteSubtask';

export default class LwcModal extends LightningElement {

    @api subtaskModal = false;
    @api message;
    @api modalHeading;

    @api parentTaskId;

    @api
    openSubtaskWindow(parentTaskId) {
        this.subtaskModal = true;
        this.parentTaskId = parentTaskId;
    }

    @api
    closeSubtaskWindow() {
        this.subtaskModal = false;
        this.processing = true;
        refreshApex(this.subtasksResponse)
            .finally(() => this.processing = false);
    }

    @track
    subtasks = [];
    subtasksResponse;
    processing = true;

    //Add new Subtask from component
    newSubtaskName = '';

    updateSubtask(event) {
        this.newSubtask = event.target.value;
    }

    //Add new subtask
    addSubtaskToList(event) {

        if (this.newSubtask == '') {
            return;
        }
        this.processing = true;

        insertSubtask({subtaskName: this.newSubtask, taskId: this.parentTaskId})
            .then(result => {

                this.subtasks.push({
                    id: this.subtasks[this.subtasks.length - 1] ? this.subtasks[this.subtasks.length - 1].id + 1 : 0,
                    name: this.newSubtask,
                    recordId: result.Id
                });
                this.newSubtask = '';

            })
            .catch(error => console.log(error))
            .finally(() => this.processing = false);
    }

    //Delete subtask from list
    deleteSubtask(event) {

        let idToDelete = event.target.name;
        let subtasks = this.subtasks;
        let subtaskIndex;
        let recordIdToDelete;

        this.processing = true;

        for (let i = 0; i < subtasks.length; i++) {
            if (idToDelete === subtasks[i].id) {
                subtaskIndex = i;
            }
        }

        recordIdToDelete = subtasks[subtaskIndex].recordId;

        deleteSubtask({recordId: recordIdToDelete})
            .then(result => {
                if (result) {
                    subtasks.splice(subtaskIndex, 1);
                } else {
                }
            })
            .catch(error => console.log(error))
            .finally(() => this.processing = false);
        this.subtasks = event.target.querySelector(refreshSubtaskList);
    }

    @wire(getSubtasks, {taskId: '$parentTaskId'})
    getRecords(response) {
        this.subtasksResponse = response;
        let data = response.data;
        let error = response.error;

        if (data || error) {
            this.processing = false;
        }

        if (data) {

            this.subtasks = [];
            data.forEach(subtask__c => {
                this.subtasks.push({
                    id: this.subtasks.length + 1,
                    name: subtask__c.Name,
                    date__c: subtask__c.Date__c,
                    recordId: subtask__c.Id
                });
            });
        } else if (error) {
            console.log('error');
            console.log(error);
        }
    }

    refreshSubtaskList() {
        this.processing = true;
        refreshApex(this.subtasksResponse)
            .finally(() => this.processing = false);
    }

    arrayFields = ['Name'];

}
