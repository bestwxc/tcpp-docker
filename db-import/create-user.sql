create user 'trinity'@'%' identified by 'trinity';
grant all on auth.* to 'trinity'@'%';
grant all on world.* to 'trinity'@'%';
grant all on characters.* to 'trinity'@'%';
grant all on hotfixes.* to 'trinity'@'%';
flush privileges;

