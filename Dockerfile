FROM jenkins/jenkins:latest

USER root

# Install wget
RUN apt-get update && apt-get install -y wget

# Download and add the Google Chrome signing key
RUN wget -q -O /tmp/google_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub \
    && echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-key --keyring /etc/apt/trusted.gpg.d/google.gpg add /tmp/google_signing_key.pub \
    && rm /tmp/google_signing_key.pub

RUN apt-get update
RUN apt-get install -y google-chrome-stable

# install chromedriver

RUN apt-get install -yqq unzip

RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip

RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/


# Install necessary dependencies
RUN apt-get update && apt-get install -y python3 python3-pip xvfb

## Set the working directory in the container
#WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt



# Set up xvfb for headless browser testing
ENV DISPLAY=:99

# Set Jenkins user back as the default user
USER jenkins


