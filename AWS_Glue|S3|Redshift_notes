# AWS Glue & Redshift Project - Notes

### Describing Our Data

We have two CSV files. 

customer_features has information about customers. The columns are CustomerID (integer), Surname (string), Gender (string, male or female), Age (integer between 18 and 90), Geography (string, North America or Europe), IsActiveMember (integer, 1 or 0), HasPremiumMembership (integer, 1 or 0). There should be 20 unique rows, corresponding to 50 customers.

movie_ratings has information about the movies that our customers have watched. The columns are UserId (integer), MovieId (integer between 1 and 10000), Rating (decimal between 1 and 5), Timestamp (an integer, like 1425941529, which corresponds to a unix timestamp. This should fall between 2010 and this current year). Each customer will have multiple entries (30 for each), which represent a different movie for each customer.

### Project Concept

We will create an ETL (extract, transform, and load) process using AWS glue. We will be using data from multiple sources.

We have two data sources. One source is simple, an AWS S3 bucket. The other source is RDS (relational database service), a managed database service provided by AWS; we will access it via the AWS Glue Catalog. 

### Make an IAM role that Glue can use

In a new tab, we go to IAM and start to make a new role. We click on "Roles". Then we click "create role". Select AWS Service. Then select Glue.

For the permission policy, we select AdministratorAccess, which gives the role full access. This is not a best practice though.

For the role name, we type "GlueFullAccessRole". 

### Create the S3 bucket

Go to S3. Select "create bucket". We will call it "recommender-system-984909767". We won't alter any default settings. Then we select create bucket. 

Now, we will click on that bucket. Inside that bucket, we will upload our movie_ratings.csv file there. 

### Create the data source in the Data Catalog of Glue

First, we are creating a database in Glue. Later, we will make one in RDS. 

Now we open Glue in a new tab. Within the "Data Catalog" dropdown on the left, we select "databases". Then we click "add database". 
We will call it movie-ratings-database-glue. The default options are fine. Click create. 

Next, we want to create a table within this database. That table will contain our movie-ratings.csv file which we have stored on S3. 
We click on the database we made. Then we click "add tables using crawler". The crawler is a tool that can extract data in a CSV file. 
We will name the crawler "movie-ratings-crawler". Click next.

It asks "is the data already mapped to Glue tables?". We should see "Not Yet" selected. 
Next we click "add data source". 
The data source should be "S3", and we will select "in this account". Then we click "browse s3". We click our bucket, and hit choose. Then, we click off.
We will have "crawl all subfolders" selected. Then we click the orange button "add an s3 data source" to finalize this. 
Now, we select that data source, and click next. Now, we select an existing IAM role and use the one we created. Now we click next. 

Now, for target database, we select the one we just created. Here we can specify a frequency, but for now we leave it as "on demand". 

Now we review our information and select "create". 

Now that we've created it, we can click "run crawler". 

Once it finishes, we should be able to see our data in the "tables" selection on the left, under Data Catalog and databases. 

Now, if we want to view and query this data table, we will need another service. It is called "Athena". 

### Optional, Inspecting our Table with Athena

We open the Athena service in a new tab. Click launch query editor, with "trino SQL" selected since that is good for analyzing data on S3. 
We will see our data table on the left. Click the three dots, and select "preview table". 

Instead of displaying results, I got an error. "No output location provided. An output location is required either through the Workgroup result configuration setting or as an API input.". So I will try to modify the workgroup result configuration setting. I just had to click the "settings" tab and specify a result location in S3. I selected the same bucket as the one that has my movie_ratings CSV file. 

### Working on the trickier source

First, we open up the RDS service in a new tab. It is now called "Aurora and RDS".

We click "create database". We will use the "easy create" option and configure it with MySQL (we use this because it has a "free tier" option).
For the DB instance name, we will use a precise name: "customer-features-rds-db-instance".
The username can be left as "admin".
We will specify a password. The rest of the default options are fine. Then we click create. This will take some time. 
This creates our database instance. We still have to put the data inside it though. 

We need to modify our db instance so that "publicly accessible" is set to yes. We click "modify" to do this. 

To put the data inside of our RDS db instance, we can either use the CLI, or we use another tool like MySQL workbench. We will use the second one.
In my computer settings, I navigate to "MySQL" and make sure to start the server. Then I open up the program. 

We click "add connection". We will call it "RDSConnection". The connection method is standard (TCP/IP).
For the "hostname", we will use the endpoint for our RDS db instance. We click on the RDS db instance to get information like the endpoint, etc.
The endpoint will probably look like this:
customer-features-rds-db-instance.xyzabcxyzabc.us-east-2.rds.amazonaws.com
The port number should be the same as the port listed for our db instance. In our case, 3306. 
For username, this should match the master username of the instance. We chose "admin". You can check this on the "configuration" tab after clicking on our instance.

We still have to do one more thing. We need to make a new EC2 security group; these groups handle inbound and outbound traffic. 
We need to make a new one where the inbound traffic rule allows "all traffic" and has a destination of 0.0.0.0/0 (which means allow all traffic). For this project, we can call it RecommendationGroup.
We need to make another inbound rule, that says "all TCP", with a destination of 0.0.0.0/0

After doing that, we modify our RDS db instance one more time, and choose our new security group, RecommendationGroup. 

Now when we try to connect, and we enter our password, we will be successful. We hit ok to make the connection. 

#### Using MySQL Workbench to Create a Table in Our Database

In RDS, we created the database instance. In mySQL Workbench, we are creating the database that will be within that instance.

Now, we double click on our connection in MySQL Workbench to open up the SQL editor. 

In the SQL editor, we type the following query, select it, then hit cmd + enter or ctrl + enter to execute.

```
create database customerfeaturesdatabase
```

After executing that, we refresh our schema on the left and we will see our new database. 

Now, in that left menu, we expand our database in the left. Where we see "tables", we right click, and select "data import wizard" to bring in our CSV file. 

Once that is done, we now have our CSV file in our database. This CSV file is successfully uploaded to our RDS db instance database.
This means we have finished completing the "extract" step of our ETL pipeline. 

Note: sometimes, the data import wizard messes up and can't import a CSV. 
In that case, you can open up the CSV file in VS code. In the bottom right, you will see an encoding like "UTF-8".
If you click on it, it allows you to change the encoding and save with that encoding. Try the UTF-8 encoding that doesn't mention BOM.

#### Connecting our RDS data to glue; make a VPC endpoint first

Now we open AWS Glue. We make a new database called "customer-features-glue-database". 
Now we have to connect this glue database to our RDS data. 

Before using a crawler, we will use "connections" within AWS glue. 

However, for the connection to work, we first need to use the VPC service, and create a new endpoint.

Click on the VPC service. Under the "PrivateLink and Lattice" dropdown on the left, click on endpoints. Click create endpoint. 
We need to create a VPC endpoint to S3. For the name, we will say "VPC endpoint to S3". 
Select "AWS Service". Search for "s3". Click the option that ends in .s3 (not in "outposts" or "global.accesspoint" etc.)
Two types of services pop up - gateway, and interfaces. We want to select the "gateway" one. 
Select a VPC in the VPC dropdown.
We need to connect to a subnet. We do this using the "route tables" feature. We check the available route table. 
For policy, we leave it alone as "full access". We should be good to create this endpoint. 

Now we can make our connection. Get back to the Glue service. This is within the "Data Catalog" dropdown. 
We click "create connection" within the Connections area (not the connectors area; watch out for that!)
For the connection type, select "aurora" since that is now paired with RDS.
For the database instance, select our RDS db instance. You may have to click the refresh button to see it. 
For the name, we use the same name we used when we created the database using MySQL Workbench. "customerfeaturesdatabase".
Now we enter the username and password that we specified when creating the RDS db instance. Username is "admin".
For the IAM service access role, select the role we created earlier, GlueFullAccessRole. 
Now we create it and test it, it should work. 

#### adding table from RDS using a crawler

Now that we have our RDS database in AWS glue, we click on that database (customer-features-glue-database), and click "add table using crawler".
We'll name it "customer-features-crawler". 
"Not Yet" should be selected for "is your data already mapped to Glue Tables".
In the data sources section, we click "add a data source". 
Our source will be "JDBC" (java data base connection). 
For the connection, we select the aurora connection we made. 
Now, for "include path", we need to be careful. Take note of the warning message: "MySQL don’t support schema in the path; instead, enter MyDatabase/%"
Because of this, our path will be "customerfeaturesdatabase/%"
We select our data source and click next. 
Now we select an IAM role; we use the one we created. GlueFullAccessRole. Then we click next.
Then for target database, we select "customer-features-glue-database". This is where we want our table to go. 
For the scheduling, we leave it as is, "on demand". Then we create the crawler.

Now, we need to run the crawler. We refresh our existing crawlers. Select the one we want, and then click run crawler. This is an extraction step. 

### creating our ETL job in AWS Glue

Now, we open up the Glue service and click on "ETL jobs". We click "create a job from a blank graph". 

This job will have two data sources; one is S3, one is the AWS Glue Data Catalog.
After each source, we will have a transform step, "Change Schema", which lets us change column names, change data types, drop columns, etc.
After that, we will join our data together using an inner join. 
Finally, we select a target - Amazon Redshift. 

First, we'll start with the S3 data source. We click "add node", select the "sources" tab, select s3. 
We click browse, and we click on the name of our S3 bucket and we select the CSV file. 
We probably want to the "first row has headers" option, and that the 
We make sure the data format has "CSV" selected, with a comma delimiter. The quote character is single quote.

Now we add the transform step. While this data source node is selected, we click the "add node" (plus button) button again.
We click on the "transform" tab, and choose "Change Schema". We drop the "timestamp" column because it isn't relevant. 
We also make sure the "rating" column is type "double", and the UserId and MovieId data types are "long".

Now we'll look at the AWS Glue Data Catalog source. We click off any of our nodes, and click the plus button again.
For data source, select "AWS Glue Data Catalog". 
For the database, we select customer-features-glue-database. 
Now for table, we click the dropdown and select our table. We may have to click the refresh button to see it. 

Now we add a transform node to this source node. Again, we choose "Change Schema". 
The only column that doesn't seem relevant is "surname", so we elect to drop it.
We make sure haspremium, customerid, and isactivepremiummember data types are "int". gender and geography are "string".  

Now, we select one of our "Change Schema" nodes, and we add another transform node. This will be an inner join.
We select both of our "Change Schema" nodes - each one relates to one of our data sources. 
We need to join on a common variable. So under "join conditions", we select "add condition". 
We specify "customerid" on one side and "UserId" on the other side, since these columns are the same thing. 
It's ok that these columns have different names. As long as they represent the same thing. 

So, now we have finished the transform part of the pipeline. 

Now we need to mess around with Amazon redshift.

### Working with Amazon Redshift

First we need to create a new IAM role to handle Redshift access. 

Open IAM in a new tab. On the left, we select "Roles", then we click "create role". Select AWS Service, then Redshift.
The use case is "Redshift - customizable". 
We click next. We give it Administrator Access (not a best practice; just for demo purposes)
We'll name it "RedshiftFullAccessRole". Then we scroll down and click "create role". 

Now, open up the Redshift service in a new tab. 
We need to try the Redshift serverless free trial. 
We click "customize settings". For namesapce, we say "mynamespace". 
For the workgroup name, we'll call it "myworkgroup".  
We select an IAM role for this by clicking "associated IAM roles" and selecting the one we made. 
We don't change anything else. We click "save configuration". It should work. We click "continue".

Now, we click on our namespace name. It might take a while to show up. Hit refresh a couple of time until you see it. 
Then we click on "query data". We will use this to create the final table that has the final result of our ETL process. 
On the left, we will see a resource is highlighted - the "myworkgroup" resource. 
Click the web icon that's to the left of the workgroup name. This allows us to connect to the work group. 
For authentification, we will leave it as is; "federated user" is fine. 
We don't change the database name (which is dev by default). We click create connection. 

Under "native databases", we expand the "dev" database. 
We expand the public folder/schema. We see "tables" within that. We need to create a table. 
With "tables" selected, we click "create" and then "table". 
For Schema, make sure "public" is selected. We will call the table "finaltable". 

For the column names and types, we want them to be the same thing as what we see from our inner join in the ETL job. 
To see this, we switch back to our AWS Glue tab with the ETL job. We click on our join node. 
At the bottom of the page, we click "output schema" and we will see column names and types. 
UserId is long (BIGINT)
MovieId is long (BIGINT)
Rating is double (DECIMAL)
geography is string (CHAR)
haspremiummembership is int (INTEGER)
customerid is int (BIGINT)
gender is string (CHAR)
isactivemember is int (INTEGER)
age is int (INTEGER)

Then we click "create table". 

### connecting Redshift to Glue

We need to create another connection within Glue.
Last time, it was to connect to our RDS database. This time, it is to connect to our table in Redshift.

Open Glue in a new tab. Under data catalog, click connections, and then "create connection".
Do not click "redshift". Instead, use "JDBC" as the data source.
For the URL, in our redshift tab, click on our working group. Copy the JDBC URL there. We will use that. 
Set the username to be admin. Make a password.
Click next. We will call this "Jdbc redshift connection". 

### completing our ETL job in Glue

Now we can add the last part of our pipeline.

We click on our Inner Join node, and click "add node" and select the "target" tab, and choose Redshift. 

For Redshift access type, we will leave it as is; "direct data connection". Hit the refresh button and select the connection we made.
For Schema, select public. 
Then for table, select finaltable. 
For handling of data, we select "append" to insert the data into the target data table. 

Now we click the job details tab and specify the IAM role. GlueFullAccessRole is what we use. 

Now we click save, and we have finished our pipeline. 

Now, do NOT click run. This will incur charges. However, the work is done. Congratulations!




