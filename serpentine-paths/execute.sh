#!/bin/bash

# Pull the Google Cloud SDK image
docker pull google/cloud-sdk:latest

# Run the Docker container with Firestore emulator
docker run -d -p 9000:9000 google/cloud-sdk:latest gcloud beta emulators firestore start --host-port=0.0.0.0:9000

echo "Firestore emulator is now running and accessible on port 9000."
