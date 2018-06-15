# Change to the project directory
cd $1

# Turn on maintenance mode
php artisan down

# Pull the latest changes from the git repository
git pull origin master

# Install/update composer dependecies
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Run database migrations
php artisan migrate --force

# Clear caches
php artisan cache:clear

# Clear expired password reset tokens
php artisan auth:clear-resets

# Clear and cache routes
php artisan route:clear
php artisan route:cache

# Clear and cache config
php artisan config:clear
php artisan config:cache

# Install node modules
npm install

# Build assets using Laravel Mix
npm run production

# Turn off maintenance mode
php artisan up
