# Use an official Node.js runtime as the base image
FROM node:18.17.0-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./


COPY .env.local .env.local


# Install the dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .


# Set environment variables (make sure to replace with your actual token)
#ENV REPLICATE_API_TOKEN=<your-token-here>

# Expose the port the app runs on
EXPOSE 3000

# Run the development server
CMD ["npm", "run", "dev"]

