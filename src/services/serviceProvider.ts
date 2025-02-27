import { supabase } from '@/lib/supabase';
import { ServiceProvider } from '@/types/types';

export const serviceProviderService = {
  // Get all service providers
  async getAllProviders() {
    const { data, error } = await supabase
      .from('service_provider')
      .select('*');
    
    if (error) throw error;
    return data as ServiceProvider[];
  },

  // Get provider by ID
  async getProviderById(id: number) {
    const { data, error } = await supabase
      .from('service_provider')
      .select('*')
      .eq('id', id)
      .single();
    
    if (error) throw error;
    return data as ServiceProvider;
  },

  // Get providers by vehicle type
  async getProvidersByType(vehicleType: string) {
    const { data, error } = await supabase
      .from('service_provider')
      .select('*')
      .eq('vehicleType', vehicleType);
    
    if (error) throw error;
    return data as ServiceProvider[];
  }
}; 