# 2LEIC01T2 - CleanItUP Development Report

Welcome to the documentation pages of the CleanItUP app!
You can find here details about the CleanItUP, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:


## Business Modelling
### Product Vision
#### What is CleanItUP?
CleanItUP is an app that aims to serve as a one-stop solution for individuals and communities looking to enhance their sustainability practices. It integrates various features to make environmental responsibility an accessible, enjoyable, and collective effort. These include:
* Information Repository: Provides up-to-date information on recycling protocols, available recycling bins (near locations, pick up updates, etc), sustainability tips, and eco-friendly practices.
* Community Forum: A platform for users to connect, share experiences and learn from each other about sustainable living.
* Local Initiative Finder: Helps users discover and participate in local green initiatives, fostering community involvement and impact.
* Gamification: Engages users through rewards, levels and challenges to encourage and motivate sustainable behaviors.

### Features and assumptions 

### Elevator Pitch 
Imagine every small action you take could help shape a greener planet. CleanItUP is a groundbreaking app designed to turn the ideal of sustainable living into an accessible reality for everyone. With just a few taps, you can locate the nearest recycling bins, join local green initiatives, and get personalized reminders to make your lifestyle more eco-friendly. But it's not just an app — it's a community. Connect with friends, share sustainability tips, and track your progress with engaging gamification features.
Whether you're a dedicated environmentalist or just starting to explore how you can contribute, CleanItUP empowers you to make a tangible difference. It's not about doing everything perfectly but doing something positively. Join us in turning small steps into giant leaps for our planet. 
CleanItUP: where your green journey begins.


## Requirements 

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






