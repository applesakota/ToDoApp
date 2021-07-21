### ToDo App

Create your reminders easily
<br />
<br />
### About the app

Free browse movies app for finding trending or upcoming movies.
Also you can search for movies by their genre. Possibility to find current rating of movies, and to see more details about movie you find.

<p align="center">
<img src="ToDoAppHeader.png">
</p>

|      | Registration Screens     |
|---                  |---   |
| Splash Screen                   | Welcome to my app. Enjoy exploring |
| Registration Screen             | You can registrate to app with email and password |
| Login Screen                    | You can login to app with email and password |

## Concepts used in registration

* Firebase authentication
* UI: For UI I use both, programmatically, and storyboards.
* TODO: Need to implement sign in with google account and facebook account

<p align="center">
<img src="ToDoAppBody1.png">
</p>

### App Flow

App uses core data for saving data localy
- For title app uses user email
- If user don't have any reminders we empty screen to show
- If user have some reminders, UITableView will be shown with that reminders
- User can see all categories listed in UICollectionView in CategoryViewController
- Also user can see reminders if he click on some category from CategoryViewController
- User can checked or unchecked every reminder

|      | Main Screens     |
|---                  |---   |
| Home View Controller            | User can see table of all reminders |
| Category View Controller        | User can see list of all categories inside app |


