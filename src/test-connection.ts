import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://nwjlijnbgvmvcowxyxfu.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53amxpam5iZ3ZtdmNvd3h5eGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNTI1OTgsImV4cCI6MjA1NDkyODU5OH0.Ie59yeseEc8A82gbJ56IVOq17bZOSjEkmzz-8qCPuPo';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testConnection() {
  try {
    // Test service_provider table
    console.log('\nTesting service_provider table:');
    const { data: providers, error: providersError } = await supabase
      .from('service_provider')
      .select('*')
      .order('id');
    
    if (providersError) {
      console.error('Error fetching providers:', providersError);
    } else {
      console.log('Service Providers:', providers);
    }

    // Test rides_available table
    console.log('\nTesting rides_available table:');
    const { data: rides, error: ridesError } = await supabase
      .from('rides_available')
      .select(`
        *,
        service_provider:serviceProvider (*)
      `)
      .order('date');
    
    if (ridesError) {
      console.error('Error fetching rides:', ridesError);
    } else {
      console.log('Available Rides:', rides);
    }

    // Test rides_history table
    console.log('\nTesting rides_history table:');
    const { data: history, error: historyError } = await supabase
      .from('rides_history')
      .select('*')
      .order('date');
    
    if (historyError) {
      console.error('Error fetching history:', historyError);
    } else {
      console.log('Ride History:', history);
    }

    // Test specific queries
    console.log('\nTesting specific queries:');
    
    // Get all AC vehicles
    const { data: acVehicles } = await supabase
      .from('service_provider')
      .select('*')
      .eq('facility', 'ac');
    console.log('AC Vehicles:', acVehicles);

    // Get available rides for a specific date
    const { data: specificDateRides } = await supabase
      .from('rides_available')
      .select('*, service_provider:serviceProvider(*)')
      .eq('date', '2025-01-17');
    console.log('Rides for 2025-01-17:', specificDateRides);

    // Get ride history for a specific provider
    const { data: providerHistory } = await supabase
      .from('rides_history')
      .select('*')
      .eq('serviceProvider', 'Lakshay');
    console.log('Lakshay\'s ride history:', providerHistory);

  } catch (err) {
    console.error('Connection failed:', err);
  }
}

testConnection(); 