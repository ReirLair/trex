FROM python:3.10

# Set working directory
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y sudo git curl build-essential libvips-dev

# Install Node.js and update npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Ensure user-level npm installation
ENV NPM_CONFIG_PREFIX="/app/home/.npm-global"
ENV NPM_CONFIG_CACHE="/app/home/.npm/.cache"

RUN mkdir -p /app/home/.npm-global /app/home/.npm/.cache && \
    chmod -R 777 /app/home/.npm-global /app/home/.npm/.cache

# Clone the repository
RUN git clone https://github.com/ReirLair/reikerpy.git /app

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expose port for the server
EXPOSE 7860

# Run the application
CMD ["python", "server.py"]
