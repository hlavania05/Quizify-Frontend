# Build App
FROM node:alpine3.18 AS build
WORKDIR /app
COPY package.json . 
RUN npm install
COPY . .
RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html

# Clean default HTML folder
RUN rm -rf *

# Copy the built frontend from the previous stage
COPY --from=build /app/dist .

# Copy the custom Nginx configuration file for routing
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
