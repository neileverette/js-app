FROM node:20-alpine

# Set MongoDB credentials as environment variables
ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password \
    DD_ENV="prod" \
    DD_LOGS_INJECTION=true \
    DD_TRACE_SAMPLE_RATE="1" \
    DD_APPSEC_ENABLED=true \
    DD_IAST_ENABLED=true \
    DD_APPSEC_SCA_ENABLED=true \
    DD_GIT_COMMIT_SHA="808be51c1842ac0dabb68189c34b9b932bf0dcdc" \
    DD_GIT_REPOSITORY_URL="https://github.com/neileverette/js-app.git"

# Create a directory for the app
RUN mkdir -p /home/app

# Copy the application files to the container
COPY ./app /home/app

# Set the working directory to /home/app
WORKDIR /home/app

# Install npm dependencies
RUN npm install

# Datadog: Add the dd-trace dependency for instrumentation
RUN npm install dd-trace

# Add Datadog instrumentation (this must be before any other imports)
COPY ./app/server.js /home/app/server.js

# Set the command to start the app
CMD ["node", "server.js"]
