## Build Instructions


## Implementation Notes:

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