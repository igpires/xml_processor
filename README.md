# README

## How to Run the Project

### Prerequisites
- Docker
- Docker Compose

### Steps to Run the Project
1. Clone the Repository:

If you haven’t already, clone the repository to your local environment.

``` bash
git clone git@github.com:igpires/xml_processor.git
cd xml_processor
```
2. Build and Start the Containers:

In the project directory, run the following command to build and start the containers:

``` bash
docker compose up -d --build
```

3. Precompile the Assets:

Once the containers are running, execute the following command to precompile the assets:

``` bash
docker compose exec xml_processor_service rails assets:precompile
```

4. Set Up the Database:

Create and migrate the database using the following commands:

``` bash
docker compose exec xml_processor_service rails db:create db:migrate
```

5. Access the Application:

Now, open `http://localhost:3000` in your browser. If everything went well, you should see the login page. Create an account, log in, and you’re all set!



## ERD DIAGRAM
![ERD diagram](https://github.com/user-attachments/assets/e4b0e08d-7999-4ae9-b018-12c2e3834f08)
