## Purpose:
The db.mysql module can be used to develop software that connects to the popular open source
MySQL or MariaDB database servers.

### Local setup of a development server:
To run the mysql module tests, or if you want to just experiment, you can use the following
command to start a development version of MySQL using docker:
```sh
docker run -p 3306:3306 --name some-mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_ROOT_PASSWORD= -d mysql:latest
```
The above command will start a server instance without any password for its root account,
available to mysql client connections, on tcp port 3306.

You can test that it works by doing: `mysql -uroot -h127.0.0.1` .
You should see a mysql shell (use `exit` to end the mysql client session).

Use `docker container stop some-mysql` to stop the server.

Use `docker container rm some-mysql` to remove it completely, after it is stopped.

### Installation of development dependencies:
For Linux, you need to install `MySQL development` package and `pkg-config`.

For Windows, install [the installer](https://dev.mysql.com/downloads/installer/) ,
then copy the `include` and `lib` folders to `<V install directory>\thirdparty\mysql`.

### Troubleshooting

If you encounter weird errors (your program just exits right away, without
printing any messages, even though you have `println('hi')` statements in your
`fn main()`), when trying to run a program that does `import db.mysql` on windows, you
may need to copy the .dll file: `thirdparty/mysql/lib/libmysql.dll`, into the folder
of the executable too (it should be right next to the .exe file).

This is a temporary workaround, until we have a more permanent solution, or at least
more user friendly errors for that situation.

## Basic Usage

```v oksyntax
import db.mysql

// Create connection
import db.mysql

// Create connection
config := mysql.Config{
        host:     '127.0.0.1'
        port:     3306
        username: 'root'
        password: ''
        dbname:   'users'
}

// Connect to server
mut db := mysql.connect(config)!
// Do a query
res := db.query('select * from users')!
response := res.rows()
assert response[0].vals[1] == 'jackson'
// Close the connection if needed
db.close()
```

## SSL Connection

```v oksyntax
// Create ssl connection
config := mysql.Config{
        host:     '127.0.0.1'
        port:     3306
        username: 'root'
        password: ''
        dbname:   'users'
		
		// To enable ssl connection, you must specify the .client_ssl flag
		ssl_ca : './client-cert.pem'
		flag:     .client_ssl | .client_ssl_verify_server_cert
}
```