Setup Instructions:

****Change the Oracle Username and Password in SocialPantherDB.java****

1. Set up the source via:

source ~panos/1555/bash.env.unixs

javac SocialPantherDriver.java
javac SocialPantherBenchmark.java

2. Run SQLPLUS, then run @socialPantherTEAM_15 to setup/populate the database

3a. For manual testing with the UI, use:

java SocialPantherDriver

3b. For auto/manual testing, use:

java SocialPantherBenchmark

4. Run queries on SQLPLUS to see changes in the database as a result of the functions in Social Panther Driver or Benchmark 
