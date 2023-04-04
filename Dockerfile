# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the entrypoint script
COPY ./entrypoint.sh .

# Change permission
RUN chmod +x entrypoint.sh

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run the entrypoint script
CMD ["bash", "/app/entrypoint.sh", "python", "manage.py", "runserver", "0.0.0.0:80"]
