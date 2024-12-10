# Use the official Nginx image as the base image
FROM nginx:alpine

# Copy your custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy your website files to the Nginx document root
COPY . /usr/share/nginx/html


# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]


