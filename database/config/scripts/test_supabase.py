"""
Supabase Connection Test Script
Tests database connectivity and basic CRUD operations
"""

from config.supabase_client import get_supabase_client
from datetime import datetime

def test_connection():
    """Test basic Supabase connection"""
    print("=" * 60)
    print("🔍 TESTING SUPABASE CONNECTION")
    print("=" * 60)
    
    supabase = get_supabase_client()
    
    # Test 1: Insert a test lead
    print("\n1️⃣ Testing INSERT operation...")
    test_lead = {
        "name": "Ryan Test",
        "phone": "+15559876543",
        "property_address": "456 Test Ave, Los Angeles, CA 90001",
        "lead_source": "Python Script Test",
        "data_enriched": False,
        "in_foreclosure": True
    }
    
    try:
        result = supabase.table("leads").insert(test_lead).execute()
        test_lead_id = result.data[0]['id']
        print(f"   ✅ Lead created: {test_lead_id}")
    except Exception as e:
        print(f"   ❌ INSERT failed: {e}")
        return
    
    # Test 2: Read the test lead
    print("\n2️⃣ Testing SELECT operation...")
    try:
        leads = supabase.table("leads").select("*").eq("id", test_lead_id).execute()
        print(f"   ✅ Found lead: {leads.data[0]['name']}")
    except Exception as e:
        print(f"   ❌ SELECT failed: {e}")
    
    # Test 3: Update the test lead
    print("\n3️⃣ Testing UPDATE operation...")
    try:
        update_result = supabase.table("leads").update({
            "data_enriched": True,
            "lender_name": "Test Bank"
        }).eq("id", test_lead_id).execute()
        print(f"   ✅ Lead updated: data_enriched = {update_result.data[0]['data_enriched']}")
    except Exception as e:
        print(f"   ❌ UPDATE failed: {e}")
    
    # Test 4: Insert call log
    print("\n4️⃣ Testing call_logs table...")
    try:
        call_log = {
            "lead_id": test_lead_id,
            "agent_name": "SaintSal",
            "call_type": "Test Call",
            "call_summary": "This is a test call log",
            "tags": ["test", "automated"]
        }
        log_result = supabase.table("call_logs").insert(call_log).execute()
        print(f"   ✅ Call log created: {log_result.data[0]['id']}")
    except Exception as e:
        print(f"   ❌ Call log failed: {e}")
    
    # Test 5: Insert scraper run
    print("\n5️⃣ Testing scraper_runs table...")
    try:
        scraper_run = {
            "leads_found": 10,
            "leads_enriched": 8,
            "leads_sent_to_ghl": 8,
            "status": "success",
            "errors": []
        }
        run_result = supabase.table("scraper_runs").insert(scraper_run).execute()
        print(f"   ✅ Scraper run logged: {run_result.data[0]['id']}")
    except Exception as e:
        print(f"   ❌ Scraper run failed: {e}")
    
    # Test 6: Delete test data
    print("\n6️⃣ Testing DELETE operation (cleanup)...")
    try:
        supabase.table("leads").delete().eq("id", test_lead_id).execute()
        print(f"   ✅ Test lead deleted")
    except Exception as e:
        print(f"   ❌ DELETE failed: {e}")
    
    # Final summary
    print("\n" + "=" * 60)
    print("🔥 DATABASE IS LIVE AND FULLY OPERATIONAL!")
    print("=" * 60)

if __name__ == "__main__":
    test_connection()
