# Inception Project Checklist

## Project Structure Requirements
- [x] Project completed on a Virtual Machine
- [x] All configuration files in `srcs` folder
- [x] Makefile at root directory
- [x] Makefile builds Docker images using docker-compose.yml
- [ ] Directory structure matches requirements:
  ```
  .
  ├── Makefile
  ├── secrets/
  │   ├── db_password.txt
  │   ├── db_root_password.txt
  │   ├── wordpress_user.txt
  │   └── wordpress_password.txt
  └── srcs/
      ├── docker-compose.yml
      ├── .env
      └── requirements/
          ├── mariadb/
          │   ├── Dockerfile
          │   ├── conf/
          │   └── tools/
          ├── nginx/
          │   ├── Dockerfile
          │   ├── conf/
          │   └── tools/
          └── wordpress/
              ├── Dockerfile
              ├── conf/
              └── tools/
  ```

## Docker Compose & Environment
- [x] Docker Compose file created
- [x] .env file with environment variables
- [x] Secrets files created and referenced
- [x] Docker network established (inception)
- [ ] Volumes configured:
  - [x] WordPress database volume
  - [x] WordPress website files volume
- [ ] Volumes available in `/home/login/data` on host

## Container Requirements

### NGINX Container
- [x] Dockerfile written from Debian/Alpine
- [x] TLS 1.2 or 1.3 only configuration
- [x] SSL certificate generated (self-signed)
- [x] Listens on port 443 only
- [x] Acts as sole entry point
- [x] Properly configured to serve WordPress
- [x] No nginx in other containers

### WordPress Container  
- [x] Dockerfile written from Debian/Alpine
- [x] PHP-FPM installed and configured
- [x] No nginx installed
- [x] WordPress properly configured
- [ ] Database connection working
- [x] Website accessible through nginx
- [ ] Two users in WordPress database:
  - [ ] Administrator (username NOT admin/Admin/administrator/Administrator)
  - [ ] Regular user

### MariaDB Container
- [x] Dockerfile written from Debian/Alpine
- [x] No nginx installed
- [ ] Database properly initialized
- [x] WordPress database created
- [ ] Users created with correct permissions
- [ ] Accessible from WordPress container

## Security & Best Practices
- [x] No passwords in Dockerfiles
- [x] Environment variables used
- [x] Docker secrets implemented
- [x] No ready-made images pulled (except base OS)
- [ ] No latest tag used
- [ ] No infinite loop commands (tail -f, sleep infinity, etc.)
- [ ] Containers restart automatically on crash
- [ ] Credentials not stored in Git repository

## Domain & Network Configuration
- [x] Domain configured: `mgeiger-.42.fr`
- [x] Domain points to local IP in /etc/hosts
- [x] Network line present in docker-compose.yml
- [ ] No forbidden network options (host, --link, links)

## Functionality Tests
- [x] `make up` builds and starts all containers
- [x] `make down` stops all containers  
- [x] All containers show "Up" status
- [x] Website accessible via https://mgeiger-.42.fr
- [ ] SSL certificate warning can be bypassed
- [x] WordPress installation completes
- [x] WordPress admin panel accessible
- [ ] Database connection working
- [ ] File persistence (volumes working)
- [ ] Containers restart after crash

## File Verification
- [x] Custom Dockerfiles for each service
- [x] Startup scripts separated from Dockerfiles
- [ ] Configuration files properly structured
- [ ] No hardcoded credentials
- [ ] Proper file permissions

## Current Status Assessment
✅ **Completed:**
- Basic container structure
- Docker Compose setup
- SSL certificate generation
- Environment variables and secrets
- Startup scripts created

⚠️ **In Progress:**
- Database connection issues (needs manual setup)
- WordPress configuration

❌ **Remaining:**
- WordPress admin user creation (non-admin username)
- Volume persistence verification
- Complete functionality testing
- Domain configuration verification

## Next Steps Priority
1. Fix MariaDB database creation (add COPY command to Dockerfile)
2. Complete WordPress database setup
3. Create WordPress admin user with compliant username
4. Test volume persistence
5. Verify all containers restart automatically
6. Final functionality testing

## Bonus Parts (Optional)
- [ ] Redis cache for WordPress
- [ ] FTP server container
- [ ] Static website (non-PHP)
- [ ] Adminer setup
- [ ] Additional useful service

## Final Validation
- [ ] All mandatory requirements working perfectly
- [ ] No errors in container logs
- [ ] Website fully functional
- [ ] Volumes persist data across restarts
- [ ] Security requirements met
- [ ] Ready for submission