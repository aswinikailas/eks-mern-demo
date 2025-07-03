FROM node:18.19.1-alpine

# Create non-root user and switch to it
RUN adduser -D appuser
USER appuser

WORKDIR /home/appuser/app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy app source
COPY --chown=appuser:appuser . .

EXPOSE 5050

CMD ["npm", "start"]
