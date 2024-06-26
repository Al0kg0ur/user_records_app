# README

* **Description**

	This project aims to create a robust system for managing user data. It involves creating Sidekiq jobs to periodically fetch user records from an external API, store them in a PostgreSQL database, and perform various operations on the data including duplicate prevention, statistical analysis, and user interface for interaction.
* **Built With**
	1. Ruby on Rails - Version `7.1.3.3`
	2. Ruby - Version `3.0.3`

* **Installation**
	1. Clone Repository: `git clone git@github.com:Al0kg0ur/user_records_app.git`
	2. Install Dependencies: bundle install
	3. Database Setup: 	
	   1. Ensure PostgreSQL is installed and running.
	   2. Configure config/database.yml with your database credentials.
  	   3. Run migrations: `rake db:migrate`

* Redis Setup:
  Ensure Redis is installed and running.

  **Sidekiq Jobs**
	1. Hourly Job:
		1. Fetches user records from the API and stores them in the database.
  		2. Updates existing records based on UUID to prevent duplicates.
		3. Stores total male and female counts in Redis.
	2. Daily Job:
		1. Tabulates daily male and female counts from Redis.
  		2. Stores daily counts in the DailyRecord table.
    		3. Calculates and updates average male and female ages in DailyRecord.

* **User Interface**
  
	**Using Liquid:**
	1. Displays a table of all users with search and delete functionality.
	2. Updates male/female counts in DailyRecord upon user deletion.
	3. Shows the total number of user records.
	4. Displays a report of DailyRecord including date, male/female averages counts, and male/female average ages.

* **Acknowledgements**
	1. Sidekiq: Efficient background processing for Ruby.
	2. PostgreSQL: Powerful open-source relational database system.
	3. Redis: In-memory data structure store.
	4. Liquid: Templating language for rendering dynamic content.

