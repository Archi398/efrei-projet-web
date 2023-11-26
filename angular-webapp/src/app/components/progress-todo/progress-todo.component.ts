import {Component} from '@angular/core';
import {MatProgressBarModule} from '@angular/material/progress-bar';

/**
 * @title Determinate progress-bar
 */
@Component({
  selector: 'progress-todo',
  templateUrl: 'progress-todo.component.html',
  standalone: true,
  imports: [MatProgressBarModule],
})
export class ProgressBarTodo {
  value = 0;

  constructor() {
    this.value = 80;
    
   }
}
