# Ask for mysql account & password
read -p "Project name: " project
read -p "MySQL account: " account
read -p "MySQL password: " -s password

echo "Start Process ..."
# Create project
composer create-project --prefer-dist laravel/laravel $project

# Git init
cd $project
git init
git add .
git commit -m "Initial project"

# Database create exclusive user for this project
USER=$project
PASSWORD=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';" > init.sql
echo "CREATE DATABASE IF NOT EXISTS \`$USER\` default charset utf8 COLLATE utf8_general_ci;" >> init.sql
echo "GRANT ALL PRIVILEGES ON \`$USER\`.* TO '$USER'@'localhost';" >> init.sql

mysql -u $account -p$password < init.sql
rm -f init.sql

# Modify .env database config
sed -i "" 's/DB_DATABASE=homestead/DB_DATABASE='$USER'/g' .env
sed -i "" 's/DB_USERNAME=homestead/DB_USERNAME='$USER'/g' .env
sed -i "" 's/DB_PASSWORD=secret/DB_PASSWORD='$PASSWORD'/g' .env

# Install development tools

## npm develop environment
npm install

## barryvdh/laravel-debugbar - https://github.com/barryvdh/laravel-debugbar
composer require barryvdh/laravel-debugbar --dev
php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"

## laravel/telescope - https://laravel.com/docs/5.8/telescope
composer require laravel/telescope --dev
php artisan telescope:install
php artisan migrate  # for telescope usage