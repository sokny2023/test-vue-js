# Stage 1: Build the Vue.js app
FROM node:18-alpine as build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files from the current directory to the container's working directory
COPY . .

# Build the Vue.js app for production
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:stable-alpine as production

# Copy the build output from the previous stage to the nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to be able to access the app
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
