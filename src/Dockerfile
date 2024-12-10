# Use the official Nginx image as the base image
FROM nginx:alpine

# Copy your custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy your website files to the Nginx document root
COPY . /usr/share/nginx/html

# Install dependencies for building the Nginx Prometheus Exporter
RUN apk --no-cache add curl build-base

# Download and install the nginx-prometheus-exporter
RUN curl -LO https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter-0.11.0-linux-amd64.tar.gz && \
    tar xvf nginx-prometheus-exporter-0.11.0-linux-amd64.tar.gz && \
    mv nginx-prometheus-exporter-0.11.0-linux-amd64/nginx-prometheus-exporter /usr/local/bin/ && \
    rm -rf nginx-prometheus-exporter-0.11.0-linux-amd64*

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;", "nginx-prometheus-exporter -nginx.scrape-uri=http://localhost/status"]


