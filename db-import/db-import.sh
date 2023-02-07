#!/bin/bash

echo "start create mysql..."
mysql -uroot -p123456 -htcpp-database < /home/trinity/trinity/sql/create/create_mysql.sql
echo "create mysql finish."
mysql -uroot -p123456 -htcpp-database < /db-import/create-user.sql
echo "create remote user finish."

