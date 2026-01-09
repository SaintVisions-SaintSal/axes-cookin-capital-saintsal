"""
Supabase Client Configuration
Centralized Supabase connection for all scripts
"""

from supabase import create_client
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Supabase credentials
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

# Validate credentials
if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Missing SUPABASE_URL or SUPABASE_SERVICE_KEY in .env file")

# Initialize Supabase client
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def get_supabase_client():
    """
    Returns the initialized Supabase client
    """
    return supabase

if __name__ == "__main__":
    print("✅ Supabase client initialized successfully")
    print(f"📍 Connected to: {SUPABASE_URL}")
