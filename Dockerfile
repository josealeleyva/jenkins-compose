FROM jenkins/jenkins:lts-jdk17
# Switch to root user
USER root
# Install dependencies 
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    sudo \
    sshpass \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*
# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws
# Install Docker CLI (from official Debian repo)
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*
# Add Jenkins user to the Docker group
RUN usermod -aG docker jenkins
# Switch back to Jenkins user
USER jenkins
# Expose Jenkins default port
EXPOSE 8080
# Define the entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]