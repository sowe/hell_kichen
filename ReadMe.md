# Hell kichen
HellsKichen is a new etl's launcher for pentaho data integration whit new features . Only works in Linux/Unix OS

  - Multiples environments/configuration (prepro,docker,etc..)
  - Multiples pdi versions
  - Prevent running multiple instances
  - logs
  - getting a standard pdi errors
  - logging namespace

## Enviroment
For use HK you need to create a new folder like live (live environments) , in this folder you need create a three files:
 -  jdbc.properties
 -  hellkitchen.properties
 -  .kettle/kettle.properties or **ln -s kettle.properties ./kettle/kettle.properties**
 

### JDBC
In this file you declare the several database connection via jndi. 
```
Mysql/type=javax.sql.DataSource
MysqlO/driver=org.gjt.mm.mysql.Driver
Mysql/url=jdbc:mysql://IP:PORT/DATABASE?zeroDateTimeBehavior=convertToNull
Mysql/user=user
Mysql/password=password
```
 
### Hells Configuration (hellkitchen.properties)
Is a configuration file , you can choouse the PDI version and the loggin folder , this option is interesante if you use a [kibana](https://www.elastic.co/products/kibana) .

```
kettle_path=/home/pdi/data-integration/
kettle_log=/home/pdi/logs/
```

### kettle.properties
Link an offical documentation [kettle](https://help.pentaho.com/Documentation/6.1/0P0/180/Other_Issues/000).


## Options
HK allows many configurations and it's easier to maintain and get information for humans :D.
* Objetin the time excution , this parameter is optional
* The job name and path
* The log level by deafult is *Minimal*
* The log name with the date and hour of execution (**logname_year+month+day+hours+minute+second**)
* Tnviroment (live,docker,pre) the name of enviromoes must be the same name to folder whit configuration,
* pdi if you want to change the pdi version in a excution and don't use the parameter in a HK files.
* log if you want to change the log folder in a excution and don't use the parameter in a HK files.
* help script.
* version (pdi and  hellskitchen).
* save,occasionally it is undesirable to have multiple instances of the job run in parallel.

### Level Logs
The log levels 
- Nothing: Don't show any output.
- Minimal: Only use minimal logging.
- Basic: This is the default basic logging level.
- Detailed: Give detailed logging output.
- Debug: For debugging purposes, very detailed output.
- Rowlevel: Logging at a row level, this can generate a lot of data.
- Stream: No log show the content.

### Errors code and definition
This is a code error for HK and Pentaho Data Integration:

1. 0) The job ran without a problem.
2. 1) Errors occurred during processing
3. 2) An unexpected error occurred during loading / running of the job
4. 7) The job couldn't be loaded from XML or the Repository
5. 8) Error loading steps or plugins (error in loading one of the plugins mostly)
6. 9) Command line usage printing:

### Development

Want to contribute? Great!

License
----
LGP2
