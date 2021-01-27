/**
 * Created by Sergey on 27.10.2020.
 */

import {LightningElement} from 'lwc';

export default class MainComponent extends LightningElement {

    refreshCompletedList(){
        console.log(' event recived MAIN');
        this.template.querySelector('c-completed-task-list').refreshCompletedTodoList();
    }
}
