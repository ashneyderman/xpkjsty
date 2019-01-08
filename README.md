## Build Instructions

Solution consists of two parts:

  * Elixir API backend, located in api subdirectory
  * UI that access the APIs to display reports and provide users with a way to specify arguments for the report generation. This portion is located in webapp subdirectory.

#### API build instructions

  * Have elixir installed on your system. I used elixir version 1.5.2 on my machine
  * cd ./api
  * mix deps.get
  * iex -S mix

  This will result in API backend running on port 4000. You have access to:
  
  * GraphIQL interface http://localhost:4000/graphiql
  * API http://localhost:4000/api
  * Status http://localhost:4000/status

  A working version of the service was deployed to the cloud

    GrapIQL - https://tcbchalapi.kocomojo.net/graphiql
    API - https://tcbchalapi.kocomojo.net/api
    Status - https://tcbchalapi.kocomojo.net/status

#### Webapp build instructions

  * Have a latest(ish) version of node installed. I used v9.4.0
  * cd webapp
  * npm install
  * npm run start

  If all goes well application will startup on port 3000. You can access it

  * Webapp - http://localhost:3000/

  Webapp was created with the help of react-create-app scripts. So, all you know about that project applies here too.

## Release instructions

  Both projects can be deployed to the cloud. Dockerfile is provided for both. To release API:

  * cd ./api
  * MIX_ENV=prod mix release --profile=tcb_challenge:prod
  * docker build -t tcbchalapi:latest .

  This will create a deplyable docker image. Note, relase built with distillery like that does not include erlang runtime. So when you build the release the elixir/erlang versions specified in the docker file (1.5.2/20) have to the versions with which you produce the release. Othewise, docker image will not be runnable. The manifests produced by distillery will mismatch the referenced libs. 

  To build and release webapp

  * cd ./webapp
  * npm run build
  * docker build -t tcbchalapp:latest .

  This will create a deplyable docker image.

## API Known problems:

* ORDER BY does not seem to work. I tried to add ORDER BY clause to the solution but socrata service complains about malformed query. I ran put of time to figure out why:

```
05:59:20 alex@alexmac thecitybase(master) > curl -H "X-App-Token: ULA5cSpuf2eg99ZGRT71sdWT5" 'https://data.cityofchicago.org/resource/cdmx-wzbz.json?%24query=SELECT+date_extract_y%28creation_date%29+AS+year%2Cdate_extract_m%28creation_date%29+AS+month%2Cward%2Ccount%28%2A%29+WHERE+ward+in+%2814%2C35%29+AND+creation_date+BETWEEN+%272018-02-01T00%3A00%3A00.000%27+AND+%272018-06-30T00%3A00%3A00.000%27+ORDER+BY+month+GROUP+BY+year%2Cmonth%2Cward'
{
  "code" : "query.compiler.malformed",
  "error" : true,
  "message" : "Could not parse SoQL query \"SELECT date_extract_y(creation_date) AS year,date_extract_m(creation_date) AS month,ward,count(*) WHERE ward in (14,35) AND creation_date BETWEEN '2018-02-01T00:00:00.000' AND '2018-06-30T00:00:00.000' ORDER BY month GROUP BY year,month,ward\" at line 1 character 218",
  "data" : {
    "query" : "SELECT date_extract_y(creation_date) AS year,date_extract_m(creation_date) AS month,ward,count(*) WHERE ward in (14,35) AND creation_date BETWEEN '2018-02-01T00:00:00.000' AND '2018-06-30T00:00:00.000' ORDER BY month GROUP BY year,month,ward",
    "position" : { }
  }
}
```
