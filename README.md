### REQUIREMENTS

* Ruby 2.2.0
* Rails 4
* Postgres
* All of the above can be grabbed from Homebrew if on a Mac

### SETUP

* clone repository
* cd into app
* $ bundle
* $ rake db:create
* $ rake db:migrate
* $ rails s

Now all API endpoints should work

### Tests

For tests just run the command:

* $ rspec

### Design

* Pretty simple rails api app. 
* Used RESTful and DRY code where possible (could have used some helpers to further Dryify app)
* For the database I took an extra step and used Postgres instead of the defualt Sqlite. This way app can be easily pushed to production
* I could have created a designated endpoint for receiving callbacks, but wasn't sure if this was necessary

### Caveats

* While creating the app, I realized Rails doesn't support multi-threading, so if the callback_url can't be reached, the server will hang. 
* ...to avoid this, using any of Rails's Job implementations should work

* Rails doesn't like the keyword 'Queue', due to timeconstraints didn't fix one of the api responses. It returns "custom_queue_id" instead of "queue_id". There is definitely a not so hard fix for this out there.
* Also due to this, the queue model has been named 'CustomQueue' instead of 'Queue'


### If This were a real production app..

* I would separate the queue, message, consumer into seperate files! (same with test files)
* I would use Node.js if creating my own queue due to first caveat above
* (I probably wouldn't implement my own queueing system)

### To turn this into production ready code:

* I'd address the above, then..
* I'd push this to Heroku (or aws), and since we're using Postgres as our databse, this will be fast!
