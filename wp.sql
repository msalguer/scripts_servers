CREATE DATABASE `dbname_here`;
CREATE USER 'username_here'@'localhost' IDENTIFIED WITH mysql_native_password BY 'pass_here';
GRANT ALL ON `dbname_here`.* TO 'username_here'@'localhost';
FLUSH PRIVILEGES;
SELECT User FROM mysql.user;
SHOW DATABASES;
exit
