import { Component, OnInit, Renderer2, Input } from '@angular/core';
import { ThemeService, Theme } from 'src/app/theme.service';
import { AuthService } from 'src/app/auth.service';
import { User } from 'src/app/models/user';
import { query } from '@angular/animations';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {
  currentTheme: Theme = Theme.LIGHT;
  currentThemeIcon = 'icon-moon';
  user: User | null = null;

  @Input()
  pageTitle = '';

  constructor(
    private renderer: Renderer2,
    private themeService: ThemeService,
    private auth: AuthService
  ) { }

  ngOnInit(): void {
    this.initialiseTheme();
    this.auth.user$.subscribe((user: User | null) => {
      this.user = user;
    });
  }

  initialiseTheme(){
    this.currentTheme = this.themeService.getCurrentTheme();    
    if(this.currentTheme === Theme.LIGHT){
      this.currentThemeIcon = 'icon-moon';
    document.querySelector('body')?.style.setProperty('background-color',  '#481C4B');
        const logoElement = document.querySelector('.logo') as HTMLImageElement;
        logoElement.src = 'assets/images/logo2.png';
    }
    if(this.currentTheme === Theme.DARK){
      this.currentThemeIcon = 'icon-sun';
      this.renderer.addClass(document.body, 'dark-theme');
    document.querySelector('body')?.style.setProperty('background-color',  '#222222');
    const logoElement = document.querySelector('.logo') as HTMLImageElement;
    logoElement.src = 'assets/images/logodark.png';
logoElement.style.setProperty('border-color', '#ffffff');
logoElement.style.setProperty('border', 'solid');


    }
  }

  changeTheme(){
    if(this.currentTheme === Theme.LIGHT){
      this.themeService.setThemeToStorage(Theme.DARK);
      this.currentTheme = Theme.DARK;
      this.currentThemeIcon = 'icon-sun';
      this.renderer.addClass(document.body, 'dark-theme');
    document.querySelector('body')?.style.setProperty('background-color',  '#222222');
    const logoElement = document.querySelector('.logo') as HTMLImageElement;
    logoElement.src = 'assets/images/logodark.png';
logoElement.style.setProperty('border-color', '#ffffff');
logoElement.style.setProperty('border', 'solid');




    }
    else {
        this.themeService.setThemeToStorage(Theme.LIGHT);
        this.currentTheme = Theme.LIGHT;
        this.currentThemeIcon = 'icon-moon';
        this.renderer.removeClass(document.body, 'dark-theme');
        document.querySelector('body')?.style.setProperty('background-color',  '#481C4B');
        const logoElement = document.querySelector('.logo') as HTMLImageElement;
        logoElement.src = 'assets/images/logo2.png';
    }
  }

  logout(){
    this.auth.signout();
  }

}
