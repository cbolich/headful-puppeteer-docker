#!/bin/bash

echo "starting X server and VNC display"

# Create a virtual display using Xvfb
Xvfb :2 -screen 0 1024x768x24 &

# Start the VNC server and connect it to the virtual display
/usr/bin/x11vnc -display :2 -usepw -forever -quiet &

# Set the DISPLAY environment variable
export DISPLAY=:2

echo "starting node server"

# Launch your Node.js application with Puppeteer debugging enabled
node --inspect=0.0.0.0:9229 index.js --remote-debugging-port=9222 &

# Wait for the Node.js server to start
sleep 5

# Check if the debugging endpoint is available
echo "Checking /json/version endpoint..."
curl -s http://localhost:9222/json/version

# Start Nginx in the foreground
echo "starting Nginx"
nginx -g 'daemon off;'

# Keep the script running
wait