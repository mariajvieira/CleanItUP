# 2LEIC01T2 - CleanItUP Development Report

Welcome to the documentation pages of the CleanItUP app!
You can find here details about the CleanItUP, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

* [Business modeling](#Business-Modelling) 
  * [Product Vision](#Product-Vision)
  * [Features and Assumptions](#Features-and-Assumptions)
  * [Elevator Pitch](#Elevator-pitch)
* [Requirements](#Requirements)
  * [Domain model](#Domain-model)
* [Architecture and Design](#Architecture-And-Design)
  * [Logical architecture](#Logical-Architecture)
  * [Physical architecture](#Physical-Architecture)
  * [Vertical prototype](#Vertical-Prototype)
* [Project management](#Project-Management)

  
## Business Modelling
### Product Vision
#### What is CleanItUP?
CleanItUP is an app that aims to serve as a one-stop solution for individuals and communities looking to enhance their sustainability practices. It integrates various features to make environmental responsibility an accessible, enjoyable, and collective effort. These include:
* Information Repository: Provides up-to-date information on recycling protocols, available recycling bins (near locations, pick up updates, etc), sustainability tips, and eco-friendly practices.
* Community Forum: A platform for users to connect, share experiences and learn from each other about sustainable living.
* Local Initiative Finder: Helps users discover and participate in local green initiatives, fostering community involvement and impact.
* Gamification: Engages users through rewards, levels and challenges to encourage and motivate sustainable behaviors.

### Features and assumptions 
* User Login/Logout: Enables access to your personal account, allowing you to connect with friends, view their pages and posts, and add your work credentials to discover green initiatives and recycling bins at your workplace.
* Location Services: By allowing the app to access your location, it can help you find the nearest recycling bin and notify you of green initiatives nearby.
* Friend’s Forum: This feature enables you to post eco-friendly tips and share green initiatives with friends, as well as view their posts, fostering a community of shared sustainability interests.
* Progress Tracking: Monitor your environmental impact through a points system that reflects how eco-friendly your actions are.
* Calendar: Provides a schedule of upcoming local sustainability activities and keeps a record of your recycling efforts and event participation. 
* Map Integration: Displays a map pinpointing available recycling bins, making it easier to locate them.

### Elevator Pitch 
Imagine every small action you take could help shape a greener planet. CleanItUP is a groundbreaking app designed to turn the ideal of sustainable living into an accessible reality for everyone. With just a few taps, you can locate the nearest recycling bins, join local green initiatives, and get personalized reminders to make your lifestyle more eco-friendly. But it's not just an app — it's a community. Connect with friends, share sustainability tips, and track your progress with engaging gamification features.
Whether you're a dedicated environmentalist or just starting to explore how you can contribute, CleanItUP empowers you to make a tangible difference. It's not about doing everything perfectly but doing something positively. Join us in turning small steps into giant leaps for our planet. 
CleanItUP: where your green journey begins.


## Requirements 
The topics regarding this section (such as user stories, user interface mockups, acceptance tests and value and effort) are all in the group's GitHub Project. 
### Domain Model - Diagram: 

![dommodesof drawio (3)](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/146080260/a48fc5fb-2c19-4d81-a4be-e61dcf1b8752)


### Domain Model - Description:
* User:
Represents an individual who uses the application.
Attributes include a unique identifier (UserID), the user's name, email address, password for authentication, location to provide personalized information, and points that represent a cumulative score of the user’s eco-friendly actions.

* RecyclingBin:
Represents physical recycling bins that users can locate and use.
Attributes consist of a unique identifier (BinID), its physical location, and the type of content (e.g., plastics, paper, etc.) it is meant for.

* GreenInitiative:
Represents an eco-friendly initiative or event that users can participate in.
Attributes include a unique identifier (InitiativeID), the name of the initiative, a description, the date when the initiative takes place, its location, and an identifier for the organizer (related to a User who created it).

* ForumPost:
Represents posts made by users in a forum within the application.
Attributes include a post identifier (PostID), the content of the post, the author's identifier (AuthorID), and a timestamp indicating when the post was created.

* Topic:
Represents categories or subjects under which forum posts can be grouped.
Attributes consist of a unique identifier (TopicID), the name of the topic, and a description of what the topic covers.

* Progress:
Represents the tracking of a user's environmental actions and achievements within the application.
Attributes include the user's identifier (UserID), total points obtained from eco-friendly actions, the level (indicating the user's progression or ranking), and a string of achievements which may be a list or summary of specific accomplishments.

* Achievement:
Represents specific goals or milestones users can reach by performing sustainable actions.
Attributes consist of an achievement identifier (AchievementID), the name of the achievement, a description, and the number of points required to obtain this achievement.

Relations:
* User-RecyclingBin: This relationship suggests that a user may have zero or one used recycling bin daily. Daily, the app only registers one (at most) visit of the user to the bin. A bin might be used by many Users.

* User-GreenInitiative: Indicates that a user can participate in none or many green initiatives. This relationship allows users to engage with multiple environmental events or campaigns within the app.

* User-User: This recursive relationship implies that users can have connections with other users within the application. It  supports the social networking feature of the app where users can add friends and form a community.

* User-ForumPost: Depicts that a user can create none or multiple forum posts. Users can contribute to the forum by sharing tips, asking questions, or engaging in discussions.

* ForumPost-Topic: Each forum post is categorized in exactly one topic, which helps in organizing the forum's content and makes it easier for users to navigate and find relevant discussions.

* User-Progress:
A one-to-one relationship showing that each user has a progress tracker associated with their account, which monitors their actions and achievements related to sustainability efforts.

* Progress-Achievement: Indicates that the progress of a user can result in earning none or multiple achievements. Achievements are milestones within the app that users can unlock by completing certain tasks or accumulating a certain number of points.



## Architecture and Design

### Physical architecture
This deployment diagram provides a high-level view of how the CleanItUP system is physically structured, demonstrating the distributed nature of modern software systems that leverage cloud technologies for better performance, reliability, and user experience.
#### UML Component/Deployment Diagram: 
![dep_diagram](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/146080260/641dce45-1981-4c10-b980-2672da5dfaf1)


#### UML Deployment Diagram Description:
* Nodes:
Cloud Environment: Represents the high-level boundary of the system where all server components reside. This is typically a cloud provider's infrastructure, chosen for its reliability, scalability, and wide array of services.
Database Server (DBServer): A dedicated machine for hosting the database, which stores all persistent information, including user data, forum posts, and event details. The choice of a separate database server ensures data integrity and efficient access control.
Database (DB): This artifact is the actual database system, for instance a relational database management system (RDBMS).
Application Server (AppServer): Hosts the backend service, handling the application's business logic, processing requests and performing CRUD operations with the database.
Backend Service (Backend): The executable component that encapsulates the application's server-side logic. 
* Artifacts:
Mobile Application (MobileApp): This artifact represents the software that users directly interact with. The app could be built using a framework like Flutter (our choice), selected for its ability to compile to both iOS and Android from a single codebase, enhancing maintainability.
* Relationships and Dependencies:
The Database Server is connected to the Application Server, indicating that the backend service deployed on the Application Server communicates with the Database to store and retrieve data.
The Mobile Application communicates with the Backend Service via API calls over the network. This separation of client and server allows for the independent scaling of each component and facilitates updates and maintenance.
* Technologies Justification:
Database Server: Dedicated servers for databases optimize performance and security. They provide the necessary resources for handling high volumes of transactions and complex query processing, which is crucial for the app's data-intensive features like tracking environmental points and user interactions.
Application Server: Separating the application logic from the database layer follows the principle of single responsibility and allows independent scaling. A microservices architecture could also be adopted, with each service running in a containerized environment for better resource utilization and deployment flexibility (a topic to be further explored in the next sprint).
Mobile Application: A cross-platform mobile development framework like Flutter is chosen for its fast development cycle, UI capabilities, and native performance. This is in line with the product's need for a wide-reaching, engaging, and responsive user interface.

### Logical architecture
This package diagram provides the logical architecture of a system for managing recycling bins, incorporating external services like the Google Maps API. 
#### UML Package Diagram: 
<img width="411" alt="pkgdiagram" src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145374103/55394701-4cf9-4d0e-a050-ec521fced634">

#### UML Deployment Diagram Description:
* External Services:
This package represents the external services used by the system. In this case, it uses the Google Maps API.

* Recycling Bins System:
This package includes the core components of the recycling bins management system.

* Recycling Bins Web UI:
This package contains the user interface components which interacts with the recycling bins system. 

* Recycling Bins Search Logic:
This package contains the logic responsible for handling search functionalities related to recycling bins.

* Recycling Bins DataBase Schema:
This package represents the database schema used by the recycling bins system to store relevant data.



## Vertical Prototype:
In the prototype, it is implemented the starting menu, login page, and user profile screen of the application, showing the login feature. These screens demonstrate the integration of various technologies and validate architectural and design decisions. 
This demonstration of the app was made in Dart, using AndroidStudio and Flutter. 
[Link for .apk of the prototype](app-release.apk)


## Project Management 
### Definition of Ready 
* User story is well-defined and includes acceptance criteria and mockups.
* Team understands the user story and its scope.
* The story is estimated and sized.
  
### Definition of Done (DoD)
* Code meets the project's coding standards.
* Code is reviewed and approved by at least one other team member.
* No critical or high-severity issues reported by static code analysis tools.
* Unit tests are written and passing.
* All relevant documentation is updated.
* The feature or bug fix meets the acceptance criteria defined in the user story.
* No open critical or high-severity bugs related to the PBI.
* The feature is deployed to a staging environment and tested.

### Sprint 2 Overview 
#### Sprint Planning for This Iteration (Expected)
Details about the planned tasks and objectives set at the beginning of the sprint.
<img width="1511" alt="sprint2_sprintbacklog" src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/146080260/92f5d557-0cb4-4937-a47f-f0d785ce407f">
<img width="1507" alt="sprint2_management" src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/146080260/b4bfba47-2533-42d6-af9a-6a7319875795">

#### Sprint Planning for This Iteration (Current)
Updates and current status of the sprint planning.
<img width="1512" alt="image" src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/146080260/c7f439d7-0497-4c49-ad64-957a1302b7ab">


#### General considerations
* The team carefully analyzed the feedback provided by the professor, both in class and in the spreadsheet, in order to incorporate the advice to improve their project.
* The group came to the conclusion that, in the previous sprint, they should have payed greater attention to detail, in areas such as the Project Management section, the Changelog.md, a better use of GitHub, testing implementation and more detailed user stories (with corresponding mock-ups).
* As seen in "Sprint planning for this iteration (expected)", the necessary tasks and goals for this sprint were determined in group. Team members mutually agreed on their responsibilities, with some tasks being done in pairs due to their complexity. We tried to simplify the user stories as much as possible; however, some were very complex due to their nature and needed to be addressed jointly.
* The tasks from Sprint 1 were not marked as done/accepted until this iteration, as they were either previously incomplete or lacked testing.
* The testing isn't yet fully implemented, since the group had difficulties in that area. However, that will be a priority in the next sprint.

#### Main Difficulties of Each Team Element:
* Duarte Marques: Map implementation and Unit testing.
* Francisca Fernandes: Unit Testing and Team Management.
* Maria Vieira: Unit Testing, Team Management.
* Marta Cruz: Map implementation and Unit testing.
* Nazim Nasirov: Software issues

Note: further information on the improvements made in this iteration available in Changelog.md. 

#### Final retrospective 
The team believes to have done a significative incrementation on the project.
For the next sprint, one of our main goals is to expand the testing. 
Next, the team wants to finish the "in Progress" tasks, and to start new ones, such as changing the profile picture and features regarding friendships.


### Sprint 3 Overview 
#### Sprint Planning for This Iteration (Expected)
Details about the planned tasks and objectives set at the beginning of the sprint.
![Captura de ecrã 2024-05-22 234000](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/71a624b5-e78c-4088-ad03-5a09728ad94b)
![Captura de ecrã 2024-05-22 234019](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/6660a9cf-86c7-47e7-ad72-6c154ba2c5c9)
![Captura de ecrã 2024-05-22 234035](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/83b99c18-8ef9-45a7-8ef3-9315faaf3798)
![Captura de ecrã 2024-05-22 235358](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/fd4552a1-decd-41f2-bbec-60c7e80b684e)

#### Sprint Planning for This Iteration (Current)
Updates and current status of the sprint planning.
![Captura de ecrã 2024-05-23 012104](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/33f3bb3d-166f-48b6-bee2-149eb80c2b93)
![Captura de ecrã 2024-05-23 012320](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/3e1ced34-0f04-4427-8ba7-9edb5e57afbc)
![Captura de ecrã 2024-05-23 012339](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/79ebf4e3-743f-4edc-b9cf-7dc169f7753e)
![Captura de ecrã 2024-05-23 012352](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/f848fbfb-96fd-4bb1-b79a-94dd0608e98c)
![Captura de ecrã 2024-05-23 012405](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T2/assets/145373875/0efeb3d0-696f-46b1-87bd-ef017c8de502)



#### Sprint Retrospective

##### What went well
* The team is satisfied with the final app.
* We were able to implement all the desired "social features" (friend requests, friendships, posts, comments, likes, events).
* The features regarding the locations of bins were also successfully implemented.

##### Puzzles
* Ensuring Firebase worked correctly with consistent connections between Firebase, Gradle, and the Android Manifest.
* Ensuring that the number of friends appeared on the profile immediately after accepting a friend request was also challenging.
* Implementation of posts in the forum

##### Improvements made
For further information on the improvements made in this iteration, please refer to the Changelog.md file. 

##### Final retrospective 
The team believes to have done a significative incrementation on the project for this final sprint. 
Despite the challenging difficulties and the problems with the Firebase connection, the group overcame these problems and the project turned out as expected. 
In the end, we are proud of the final version of CleanItUP.

#### Lessons Learned
Throughout the project, we learned the benefits of working with Scrum and the importance of effective teamwork. 
By leveraging each team member's strengths and fostering open communication, we were able to collaborate more efficiently and solve problems quicker. 
Overall, the development of CleanItUP was a positive experience.



