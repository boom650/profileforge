#!/bin/bash
# ProfileForge Backend Server Startup Script

cd "$(dirname "$0")"

echo "🚀 Starting ProfileForge Backend Server..."
echo "📍 http://localhost:8080"
echo "📚 API Docs: http://localhost:8080/docs"
echo ""

# Start the server
python3 -m uvicorn server:app --host 0.0.0.0 --port 8080 --reload
