# Step 1: Build the frontend application
FROM node:alpine3.18 as build

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Step 2: Set up the Nginx server and copy the static files
FROM nginx:1.23-alpine

# Copy custom nginx configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf

# Clean the default Nginx html folder
WORKDIR /usr/share/nginx/html
RUN rm -rf *

# Copy the built frontend app from the previous build stage
COPY --from=build /app/dist .

# Expose port 80
EXPOSE 80

# Start Nginx with the custom config
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
