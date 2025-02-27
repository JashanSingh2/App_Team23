import { supabase } from '@/lib/supabase';
import { RideAvailable, RideHistory } from '@/types/types';

export const ridesService = {
  // Get available rides
  async getAvailableRides(date?: string) {
    let query = supabase
      .from('rides_available')
      .select(`
        *,
        service_provider:serviceProvider (
          id,
          name,
          vehicleNumber,
          vehicleModel,
          vehicleType,
          facility,
          maxSeats,
          fare,
          rating
        )
      `);
    
    if (date) {
      query = query.eq('date', date);
    }
    
    const { data, error } = await query;
    if (error) throw error;
    return data as RideAvailable[];
  },

  // Book a ride
  async bookRide(rideData: Omit<RideHistory, 'id'>) {
    // First, check if seats are available
    const { data: availableRide } = await supabase
      .from('rides_available')
      .select('seatsAvailable')
      .eq('serviceProvider', rideData.serviceProvider)
      .eq('date', rideData.date)
      .single();

    if (!availableRide || availableRide.seatsAvailable <= 0) {
      throw new Error('No seats available');
    }

    // Start a transaction
    const { data, error } = await supabase
      .from('rides_history')
      .insert([rideData])
      .select();

    if (error) throw error;

    // Update available seats
    await supabase
      .from('rides_available')
      .update({ seatsAvailable: availableRide.seatsAvailable - 1 })
      .eq('serviceProvider', rideData.serviceProvider)
      .eq('date', rideData.date);

    return data[0] as RideHistory;
  },

  // Get ride history
  async getRideHistory() {
    const { data, error } = await supabase
      .from('rides_history')
      .select(`
        *,
        service_provider:serviceProvider (
          id,
          name,
          vehicleNumber,
          vehicleModel,
          vehicleType,
          facility,
          maxSeats,
          fare,
          rating
        )
      `)
      .order('date', { ascending: false });
    
    if (error) throw error;
    return data as RideHistory[];
  },

  // Get upcoming rides
  async getUpcomingRides() {
    const today = new Date().toISOString().split('T')[0];
    const { data, error } = await supabase
      .from('rides_history')
      .select(`
        *,
        service_provider:serviceProvider (
          id,
          name,
          vehicleNumber,
          vehicleModel,
          vehicleType,
          facility,
          maxSeats,
          fare,
          rating
        )
      `)
      .gte('date', today)
      .order('date');
    
    if (error) throw error;
    return data as RideHistory[];
  }
}; 