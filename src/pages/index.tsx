import { useEffect, useState } from 'react';
import { ServiceProvider, RideAvailable } from '@/types/types';
import { serviceProviderService } from '@/services/serviceProvider';
import { ridesService } from '@/services/rides';
import { RideCard } from '@/components/RideCard';

export default function Home() {
  const [providers, setProviders] = useState<ServiceProvider[]>([]);
  const [availableRides, setAvailableRides] = useState<RideAvailable[]>([]);
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);

  useEffect(() => {
    loadProviders();
    loadAvailableRides();
  }, [selectedDate]);

  const loadProviders = async () => {
    try {
      const data = await serviceProviderService.getAllProviders();
      setProviders(data);
    } catch (error) {
      console.error('Error loading providers:', error);
    }
  };

  const loadAvailableRides = async () => {
    try {
      const data = await ridesService.getAvailableRides(selectedDate);
      setAvailableRides(data);
    } catch (error) {
      console.error('Error loading rides:', error);
    }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Available Rides</h1>
      
      <div className="mb-6">
        <label className="block mb-2">Select Date:</label>
        <input
          type="date"
          value={selectedDate}
          onChange={(e) => setSelectedDate(e.target.value)}
          className="border rounded px-3 py-2"
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {availableRides.map((ride) => (
          <RideCard
            key={ride.id}
            provider={ride.service_provider!}
            onBook={() => {
              // Implement booking logic
              console.log('Booking ride:', ride);
            }}
          />
        ))}
      </div>
    </div>
  );
} 